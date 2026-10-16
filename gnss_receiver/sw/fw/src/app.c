/* МГП-8: прикладной уровень ПО МК — см. inc/app.h. */
#include <string.h>
#include "app.h"
#include "fpga.h"
#include "nmea.h"
#include "mem.h"

enum { ST_IDLE, ST_SNAP, ST_ACQ };

/* копии для решения в фоне: прерывание может заменить измерения и эфемериды во время решения */
static obs_t OBS[PVT_MAXOBS] MEM_SRAM4;
static eph_t EPH[PVT_MAXOBS] MEM_SRAM4;
static char  NB[4096];                       /* GSV по 96 КА — до 1,8 КБ */

static void lk(const app_t *a, int on) { if (a->rx->lock) a->rx->lock(on); }

int app_init(app_t *a, rx_t *r, uint8_t *const *snap, void (*lock)(int on))
{
    static const int DEF_SIG[] = {SIG_L1CA, SIG_G1CA, SIG_E1B, SIG_B1I};
    memset(a, 0, sizeof(*a));
    a->rx = r;
    for (int k = 0; k < APP_NSNAP; k++) a->snap[k] = snap[k];
    a->ac = (acq_cfg_t){.dop_max = 6000, .dop_step = 250, .nper = 2, .thresh = 2.0};
    a->nsig = (int)(sizeof(DEF_SIG) / sizeof(DEF_SIG[0]));
    memcpy(a->sig, DEF_SIG, sizeof(DEF_SIG));
    a->acq_period = 10.0;
    a->pps_sec = -1;
    rx_init(r);
    r->lock = lock;
    if (fpga_rd(R_ID) != 0x4D475038u) return APP_E_FPGA;
    a->fpga_ver = fpga_rd(R_VERSION);
    a->nch = corr_init();
    if (!a->nch) return APP_E_FPGA;
    int e = 0;
    if (max2771_init(0xFF, &a->rf)) e |= APP_E_RF;     /* все восемь каналов (двухчастотный режим) */
    fpga_wr(R_TIC_PERIOD, APP_TIC);
    fpga_wr(R_IRQ_CLR, 0x7Fu);
    fpga_wr(R_IRQ_MASK, IRQ_CORR | IRQ_TIC | IRQ_PPS);
    return e;
}

int app_irq(app_t *a)
{
    rx_t *r = a->rx;
    uint32_t st = fpga_rd(R_IRQ_STATUS);
    if (st & ~IRQ_CORR) fpga_wr(R_IRQ_CLR, st & ~IRQ_CORR);  /* CORR — уровень, снимается чтением результатов */
    a->n_irq++;
    if (st & IRQ_TIC) a->n_tic++;
    if (st & IRQ_PPS) a->n_pps++;
    uint64_t n = corr_time_now();
    rx_process(r, n);
    int req = a->n_pps != a->pps_seen;
    if (!r->time_ok) return req;
    if (!a->next_m) a->next_m = (n / APP_EPOCH + 1) * APP_EPOCH;
    if (n < a->next_m) return req;
    /* эпоха наступила: фиксация сразу после чтения результатов — «зеркало» NCO отнесено к моменту
     * не далее 1 мс от эпохи; при опоздании (долгая блокировка) эпоха пропускается */
    uint64_t m = a->next_m;
    a->next_m = (n / APP_EPOCH + 1) * APP_EPOCH;
    if (n - m > APP_LATCH_MAX) { a->n_late++; return req; }
    int k = rx_latch(r, m);
    if (k < 0) return req;
    a->lat_m = m;
    a->lat_n = k;
    a->seq++;
    return 1;
}

/* момент ближайшей секунды GPST не ранее чем через APP_PPS_LEAD — в PPS_T (по последнему решению,
 * не старше APP_PPS_HOLD) */
static void arm_pps(app_t *a)
{
    const rx_t *r = a->rx;
    uint64_t n = corr_time_now(), t96;
    double qe, sec;
    if (!r->n_sol || (double)(int64_t)(n - r->sol_n) / FS_HZ > APP_PPS_HOLD) return;
    if (!rx_pps_next(r, n + APP_PPS_LEAD / 4, &t96, &qe, &sec)) return;
    fpga_wr(R_PPS_T_LO, (uint32_t)t96);
    fpga_wr(R_PPS_T_HI, (uint32_t)(t96 >> 32));               /* запись старшего слова взводит */
    a->pps_sec = sec;
    a->pps_qerr = qe;
}

static void out_nmea(app_t *a, const sol_t *s, int n, int week, int dt_ls)
{
    if (!a->out) return;
    a->out(NB, nmea_gga(NB, s, week, s->t_rx, dt_ls));
    a->out(NB, nmea_rmc(NB, s, week, s->t_rx, dt_ls));
    a->out(NB, nmea_gsa(NB, s, OBS, n));
    a->out(NB, nmea_gsv(NB, OBS, n));
    a->out(NB, nmea_gst(NB, s, week, s->t_rx, dt_ls));
    a->out(NB, nmea_zda(NB, week, s->t_rx, dt_ls));
    a->n_nmea++;
}

/* решение по последней фиксации: копия под блокировкой, решение без неё, запись результата
 * под блокировкой (углы КА в r->obs — только если новой фиксации не было) */
static int solve(app_t *a)
{
    rx_t *r = a->rx;
    lk(a, 1);
    uint32_t seq = a->seq;
    uint64_t m = a->lat_m;
    int n = r->nobs;
    if (n < 4) { lk(a, 0); a->seq_done = seq; return 0; }
    memcpy(OBS, r->obs, sizeof(obs_t) * (size_t)n);
    for (int i = 0; i < n; i++)
        if (OBS[i].eph) { EPH[i] = *OBS[i].eph; OBS[i].eph = &EPH[i]; }
    pvt_cfg_t cfg = r->pcfg;
    memcpy(cfg.ion, r->ion, sizeof(cfg.ion));
    cfg.iono = r->ion_ok;
    sol_t s = r->sol;
    double trx = rx_time(r, m);
    int week = r->week, dt_ls = r->dt_ls;
    lk(a, 0);
    a->seq_done = seq;
    if (!pvt_solve(OBS, n, trx, &cfg, &s)) { a->n_fail++; return 0; }
    lk(a, 1);
    if (a->seq == seq)
        for (int i = 0; i < n; i++) { const eph_t *e = r->obs[i].eph; r->obs[i] = OBS[i]; r->obs[i].eph = e; }
    r->sol = s;
    r->sol_n = m;
    r->n_sol++;
    lk(a, 0);
    a->n_sol++;
    arm_pps(a);
    out_nmea(a, &s, n, week, dt_ls);
    return 1;
}

static void snap_begin(app_t *a, int rf)
{
    a->snap_rf = rf;
    a->k = 0;
    a->st = ST_SNAP;
    acq_snap_start(rf, APP_SNAP_N, 0);
}

/* сигнал a->si списка или конец цикла поиска */
static void sig_begin(app_t *a)
{
    if (a->si >= a->nsig) {
        a->st = ST_IDLE;
        a->acq_next = corr_time_now() + (uint64_t)(a->acq_period * FS_HZ);
        return;
    }
    rx_sig_range(a->sig[a->si], &a->q, &a->q1);
    a->st = ST_ACQ;
}

int app_sol(app_t *a)
{
    int w = APP_IDLE;
    if (a->seq != a->seq_done && solve(a)) w |= APP_SOL;
    if (a->n_pps != a->pps_seen) { a->pps_seen = a->n_pps; arm_pps(a); }   /* следующая секунда */
    return w;
}

int app_poll(app_t *a)
{
    int w = APP_IDLE;
    switch (a->st) {
    case ST_IDLE:
        if (corr_time_now() >= a->acq_next) { a->si = 0; sig_begin(a); }
        break;
    case ST_SNAP:
        if (!acq_snap_read(APP_SNAP_N, a->snap[a->k], &a->t0[a->k])) break;
        w |= APP_SNAP;
        if (++a->k < APP_NSNAP) acq_snap_start(a->snap_rf, APP_SNAP_N, 0);
        else a->st = ST_ACQ;
        break;
    case ST_ACQ: {
        int sig = a->sig[a->si];
        /* снимки — того ВЧ-канала и не старше APP_SNAP_AGE (t0 — мл. 32 бит номера отсчёта) */
        if (a->k < APP_NSNAP || SIGS[sig].rf != a->snap_rf ||
            (uint32_t)corr_time_now() - a->t0[0] > APP_SNAP_AGE) {
            snap_begin(a, SIGS[sig].rf);
            break;
        }
        int s = rx_acquire_one(a->rx, (const uint8_t *const *)a->snap, a->t0, APP_NSNAP, APP_SNAP_N, sig,
                               a->q, &a->ac);
        a->n_acq++;
        if (s > 0) a->n_found++;
        w |= APP_ACQ;
        if (s < 0 || ++a->q > a->q1) { a->si++; sig_begin(a); }
        break;
    }
    }
    return w;
}
