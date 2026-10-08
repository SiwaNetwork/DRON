/* МГП-8: управление приёмником.
 * Время излучения сигнала КА (GPS L1 C/A): по границе подкадра LNAV (TOW из HOW — время начала
 * следующего подкадра) и фазе кода без свёртки из «зеркала» NCO:
 *   t_tx(n) = ref_tow + (code_tot(n) − ref_code) / 2^32 / R_code.
 * Псевдодальность: PR = c·(t_rx(n) − t_tx(n)), t_rx — шкала приёмника (номинальная Fд). */
#include <math.h>
#include <string.h>
#include "fpga.h"
#include "rx.h"

#define TWO32 4294967296.0

void rx_init(rx_t *r)
{
    memset(r, 0, sizeof(*r));
    pvt_default_cfg(&r->pcfg);
    trk_default_cfg(&r->tcfg);
    r->dt_ls = (int)GPST_UTC;
}

double rx_time(const rx_t *r, uint64_t n)
{
    return r->t0_tow + (double)(int64_t)(n - r->t0_n) / FS_HZ;
}

static void on_bit(void *ctx, int bit, uint64_t n_end);
static rx_t *RX;                     /* для обратного вызова (один приёмник) */

int rx_acquire(rx_t *r, const uint8_t *const *x4, const uint32_t *t0, int nsnap, int len, int sig,
               uint64_t t_start, const acq_cfg_t *ac)
{
    int chs[CORR_MAXCH], n = 0;
    const sig_info_t *si = &SIGS[sig];
    RX = r;
    for (int prn = 1; prn <= 32; prn++) {
        int busy = 0;
        for (int k = 0; k < CORR_MAXCH; k++) if (r->ch[k].used && r->ch[k].sig == sig && r->ch[k].prn == prn) busy = 1;
        if (busy) continue;
        acq_res_t a;
        if (!acq_search_multi(x4, t0, nsnap, len, sig, prn, 0, ac, &a)) continue;
        int ch = corr_alloc(sig);
        if (ch < 0) break;
        double rate = si->chip_rate * (1 + a.doppler / sig_carrier(sig, 0));
        double cps = a.code_phase + rate * (double)(int64_t)(t_start - t0[0]) / FS_HZ;
        corr_load_code(ch, sig, prn);
        rx_ch_t *c = &r->ch[ch];
        memset(c, 0, sizeof(*c));
        c->used = 1; c->ch = ch; c->sig = sig; c->prn = prn;
        trk_start(&c->trk, ch, sig, prn, 0, a.doppler, cps, t_start, &r->tcfg);
        c->trk.on_bit = on_bit;
        c->trk.ctx = c;
        lnav_init(&c->nav, prn);
        chs[n++] = ch;
    }
    if (n) corr_start(chs, n, t_start);
    return n;
}

static void on_bit(void *ctx, int bit, uint64_t n_end)
{
    rx_ch_t *c = ctx;
    rx_t *r = RX;
    int id = lnav_bit(&c->nav, bit, n_end);
    if (!id) return;
    /* граница подкадра: конец последнего бита — эпоха кода внутри отсчёта n_end */
    uint64_t n = n_end + 1;
    double cp;
    corr_phase_at(c->ch, n, &cp, NULL);
    if (cp > CORR[c->ch].L / 2) cp -= CORR[c->ch].L;          /* эпоха чуть позже начала отсчёта */
    c->ref_n = n;
    c->ref_code = corr_code_total_at(c->ch, n) - (uint64_t)(int64_t)llround(cp * TWO32);
    c->ref_tow = c->nav.sf_end_tow;
    c->tx_ok = 1;
    if (c->nav.eph_new) {
        r->eph[SYS_GPS][c->prn] = c->nav.eph;
        c->nav.eph_new = 0;
        r->week = c->nav.eph.week;
    }
    if (c->nav.ion_ok && !r->ion_ok) { memcpy(r->ion, c->nav.ion, sizeof(r->ion)); r->ion_ok = 1; }
    if (c->nav.ok_utc) r->dt_ls = c->nav.dt_ls;
    if (!r->time_ok) {                       /* начальная шкала: задержка распространения ≈ 75 мс */
        r->t0_n = n;
        r->t0_tow = c->ref_tow + 0.075;
        r->time_ok = 1;
    }
}

void rx_process(rx_t *r, uint64_t n_now)
{
    corr_dump_t d;
    RX = r;
    for (int k = 0; k < CORR_MAXCH; k++) {
        rx_ch_t *c = &r->ch[k];
        if (!c->used) continue;
        while (corr_read(c->ch, &d, n_now)) trk_update(&c->trk, &d);
        if (c->trk.state == TRK_IDLE) {          /* срыв более 1 с — канал освобождается */
            corr_free(c->ch);
            c->used = 0;
        }
    }
}

int rx_measure(rx_t *r, uint64_t n_m)
{
    if (!r->time_ok) return 0;
    double trx = rx_time(r, n_m);
    int n = 0;
    for (int k = 0; k < CORR_MAXCH && n < PVT_MAXOBS; k++) {
        rx_ch_t *c = &r->ch[k];
        if (!c->used || !c->tx_ok || c->trk.state != TRK_LOCK) continue;
        eph_t *e = &r->eph[SYS_GPS][c->prn];
        if (!e->valid) continue;
        const sig_info_t *si = &SIGS[c->sig];
        uint64_t ct = corr_code_total_at(c->ch, n_m);
        double ttx = c->ref_tow + (double)(int64_t)(ct - c->ref_code) / TWO32 / si->chip_rate;
        obs_t *o = &r->obs[n];
        memset(o, 0, sizeof(*o));
        o->sys = SYS_GPS; o->prn = c->prn;
        o->pr = CLIGHT * eph_tdiff(trx, ttx);
        o->dop = trk_doppler(&c->trk);
        o->fc = sig_carrier(c->sig, 0);
        o->cn0 = c->trk.cn0;
        o->eph = e;
        n++;
    }
    r->nobs = n;
    if (n < 4) return 0;
    memcpy(r->pcfg.ion, r->ion, sizeof(r->ion));
    r->pcfg.iono = r->ion_ok;
    sol_t s = r->sol;
    if (!pvt_solve(r->obs, n, trx, &r->pcfg, &s)) return 0;
    r->sol = s;
    r->sol_n = n_m;
    r->n_sol++;
    return 1;
}

int rx_pps_next(const rx_t *r, uint64_t n_now, uint64_t *t96, double *qerr, double *sec)
{
    if (!r->n_sol) return 0;
    const sol_t *s = &r->sol;
    /* GPST(n) = t_rx(n) − (b + ḃ·Δt)/c, Δt — от эпохи решения */
    double tm = s->t_rx;                                  /* GPST на отсчёте sol_n */
    double rate = 1.0 - s->clkd / CLIGHT;                 /* секунд GPST на секунду шкалы приёмника */
    double tn = tm + (double)(int64_t)(n_now - r->sol_n) / FS_HZ * rate;
    double S = floor(tn) + 1.0;
    double nx = (double)r->sol_n + (S - tm) / rate * FS_HZ; /* дробный номер отсчёта */
    double x96 = nx * 4.0;
    double xi = floor(x96 + 0.5);
    *t96 = (uint64_t)xi - 1 - PPS_DELAY_T96;              /* импульс — в конце такта PPS_T */
    *qerr = (x96 - xi) / F96_HZ;
    if (sec) *sec = S;
    return 1;
}
