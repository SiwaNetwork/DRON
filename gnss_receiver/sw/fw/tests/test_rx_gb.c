/* Сквозная проверка приёма Galileo E1 и BeiDou B1I совместно с GPS L1 C/A (ПЗ п. 9.1.2) на модели
 * ПЛИС. Имитатор: видимые КА над Москвой по эфемеридам RINEX, все сигналы — ВЧ-канал 1 (1568 МГц):
 * GPS L1 C/A (45 дБГц, LNAV); Galileo E1 (45 дБГц, BOC(1,1): E1-B с символами I/NAV 250 с⁻¹ —
 * страницы по эфемеридам, и пилот E1-C с вторичным кодом CS25, мощность поровну); BeiDou B1I
 * (45 дБГц, 2,046 Мчип/с, код NH20 и биты D1 50 с⁻¹ — подкадры 1–3 по эфемеридам, КА MEO/IGSO).
 * Время КА в сигнале — Δt − TGD (GPS), Δt − BGD(E1, E5b) (Galileo), Δt − TGD1 (BeiDou); шкалы GST
 * и BDT совмещены с GPST (GGTO = 0, BDT = GPST − 14 с); уход ТКГ +0,3 ppm; без атмосферы.
 * ПО МК: захват по снимкам (E1 — по неполному периоду кода 4 мс), слежение (E1-B — BOC, символ —
 * период кода; B1I — синхронизация по коду NH, биты 20 мс), декодирование I/NAV и D1, решение с
 * часами по системам. Проверка: все каналы в захвате, эфемериды Galileo и BeiDou приняты и
 * совпадают с исходными, ошибка координат и времени по совместному решению, расхождение шкал
 * систем в решении (ошибка привязки GST/BDT к GPST сказалась бы именно в нём), решения только
 * по Galileo и только по BeiDou. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "gnss.h"
#include "codes.h"
#include "fpga.h"
#include "corr.h"
#include "corr_sim.h"
#include "eph.h"
#include "rinex.h"
#include "lnav.h"
#include "inav.h"
#include "bdsnav.h"
#include "pvt.h"
#include "rx.h"

#define RNX "../../sim/data/BRDC00IGS_R_20211700000_01D_MN_subset.rnx"
#define MAXS 24
#define DUR  40.0                    /* с */

static const int NMAX[SYS_N] = {[SYS_GPS] = 7, [SYS_GAL] = 6, [SYS_BDS] = 7};    /* КА на систему */
static const char SYSC[SYS_N] = {[SYS_GPS] = 'G', [SYS_GLO] = 'R', [SYS_GAL] = 'E', [SYS_BDS] = 'C'};
/* типы слов I/NAV по страницам подкадра 30 с (номинальная последовательность E1-B) */
static const int WT[15] = {2, 4, 6, 7, 8, 17, 19, 16, 0, 0, 1, 3, 5, 0, 16};

static eph_t EPH[8000];
static int NE;
static double T0, DELTA = 0.3e-6, RR[3], FLO;
static float GN[65536], SINT[1024];
static uint32_t rng = 4243;
static uint32_t xs(void) { rng ^= rng << 13; rng ^= rng >> 17; rng ^= rng << 5; return rng; }

typedef struct {
    int sys, sig, prn;
    eph_t e;                         /* эфемериды в разрядности сообщения */
    double *tsv;                     /* время КА (GPST, без TGD) на сетке 1 мс истинного времени */
    double rate;                     /* элементов в секунду: чипы (L1 C/A, B1I), полу-чипы (E1, BOC) */
    double fc;
    uint8_t code[CODE_MAX_BYTES], code2[CODE_MAX_BYTES];    /* E1: E1-B и E1-C */
    uint8_t sec[32];                 /* E1-C — CS25, B1I — NH20 */
    uint8_t *dat;                    /* биты LNAV / символы I/NAV / биты D1, начиная с d0 */
    long d0, nd;
    double A, ph0, el;
    /* состояние на текущей миллисекунде */
    int64_t idx;
    double x, dx;
    uint32_t ph, dph;
    float v;
} sat_t;
static sat_t S[MAXS];
static int NS;

static double t_true(uint64_t n) { return T0 + (double)n / (FS_HZ * (1 + DELTA)); }

static double tsv_at(const eph_t *e, double t)
{
    double tau = 0.075, rs[3], dts;
    for (int it = 0; it < 4; it++) {
        eph_satpos(e, t - tau, rs, &dts, NULL, NULL);
        double th = 7.2921151467e-5 * tau;
        double x = rs[0] * cos(th) + rs[1] * sin(th), y = -rs[0] * sin(th) + rs[1] * cos(th);
        tau = sqrt((x - RR[0]) * (x - RR[0]) + (y - RR[1]) * (y - RR[1]) + (rs[2] - RR[2]) * (rs[2] - RR[2])) / CLIGHT;
    }
    eph_satpos(e, t - tau, rs, &dts, NULL, NULL);
    return t - tau + dts;
}

static int dat_at(const sat_t *p, long i) { i -= p->d0; return (i >= 0 && i < p->nd) ? p->dat[i] : 0; }

static void chip_value(sat_t *p)
{
    int64_t j = p->idx;
    if (p->sys == SYS_GPS) {
        int c = code_bit(p->code, (int)(j % 1023));
        p->v = (float)((c ^ dat_at(p, (long)(j / 20460))) ? -p->A : p->A);
    } else if (p->sys == SYS_GAL) {
        /* полу-чип j: чип j/2, период кода (символ) — 4092 чипа; поднесущая — +1, затем −1 */
        int64_t ch = j >> 1, per = ch / 4092;
        int c = (int)(ch % 4092);
        int eb = (code_bit(p->code, c) ^ dat_at(p, (long)per)) ? -1 : 1;
        int ec = (code_bit(p->code2, c) ^ p->sec[per % 25]) ? -1 : 1;
        p->v = (float)(p->A * 0.70710678 * (eb - ec) * ((j & 1) ? -1 : 1));
    } else {
        /* чип по BDT: период кода 1 мс — чип кода NH, бит D1 — 20 мс */
        int64_t ms = j / 2046;
        int c = code_bit(p->code, (int)(j % 2046)) ^ p->sec[ms % 20] ^ dat_at(p, (long)(ms / 20));
        p->v = (float)(c ? -p->A : p->A);
    }
}

/* время КА в сигнале на истинный момент t (GPST; с групповой задержкой) */
static double tsv_sig(const sat_t *p, double t)
{
    double x = (t - T0) * 1e3;
    long k = (long)x;
    return p->tsv[k] + (p->tsv[k + 1] - p->tsv[k]) * (x - k) - p->e.tgd;
}

/* состояние на отсчёт i (начало миллисекунды k истинного времени) */
static void ms_state(sat_t *p, long k, uint64_t i)
{
    double t = t_true(i), fr = (t - T0) * 1e3 - k;
    double tsv = p->tsv[k] + (p->tsv[k + 1] - p->tsv[k]) * fr;
    double dts = (p->tsv[k + 1] - p->tsv[k]) * 1e3 / (FS_HZ * (1 + DELTA));   /* на отсчёт */
    double ts = tsv - p->e.tgd - (p->sys == SYS_BDS ? GPST_BDT : 0.0);       /* шкала системы */
    double u = ts * p->rate;
    p->idx = (int64_t)floor(u);
    p->x = u - (double)p->idx;
    p->dx = dts * p->rate;
    double ph = p->fc * (tsv - T0) - FLO * (1 + DELTA) * (t - T0) + p->ph0;
    p->ph = (uint32_t)(int64_t)llround((ph - floor(ph)) * 4294967296.0);
    p->dph = (uint32_t)(int64_t)llround((p->fc * dts - FLO / FS_HZ) * 4294967296.0);
    chip_value(p);
}

static int q2(double v) { return (v < 0 ? 2 : 0) | (fabs(v) > 0.70710678 ? 1 : 0); }

static long cur = -1;
static uint64_t next_i;

static uint32_t src(uint64_t i)
{
    if (cur < 0 || i >= next_i) {
        long k = (long)floor((t_true(i) - T0) * 1e3);
        cur = k;
        for (int s = 0; s < NS; s++) ms_state(&S[s], k, i);
        next_i = (uint64_t)ceil((k + 1) * 1e-3 * FS_HZ * (1 + DELTA));
        if (next_i <= i) next_i = i + 1;
    }
    double re = 0, im = 0;
    for (int s = 0; s < NS; s++) {
        sat_t *p = &S[s];
        re += p->v * SINT[((p->ph >> 22) + 256) & 1023];
        im += p->v * SINT[p->ph >> 22];
        p->ph += p->dph;
        p->x += p->dx;
        if (p->x >= 1.0) { p->x -= 1.0; p->idx++; chip_value(p); }
    }
    double xr = re + GN[xs() & 65535] * 0.70710678, xq = im + GN[xs() & 65535] * 0.70710678;
    return (uint32_t)(q2(xr) << 2 | q2(xq)) << (4 * SIGS[SIG_L1CA].rf);
}

/* угол места и азимут КА в момент t */
static double elev(const eph_t *e, double t, double *az)
{
    double lat = 55.7558 * GPI / 180, lon = 37.6173 * GPI / 180, rs[3], dts;
    eph_satpos(e, t, rs, &dts, NULL, NULL);
    double d[3] = {rs[0] - RR[0], rs[1] - RR[1], rs[2] - RR[2]}, rho = sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
    double ue = (-sin(lon) * d[0] + cos(lon) * d[1]) / rho;
    double un = (-sin(lat) * cos(lon) * d[0] - sin(lat) * sin(lon) * d[1] + cos(lat) * d[2]) / rho;
    double uu = (cos(lat) * cos(lon) * d[0] + cos(lat) * sin(lon) * d[1] + sin(lat) * d[2]) / rho;
    if (az) *az = atan2(ue, un);
    return asin(uu);
}

/* данные навигационного сообщения на интервале имитации */
static void make_data(sat_t *p, int nk)
{
    double ts0 = p->tsv[0] - 7, ts1 = p->tsv[nk - 1] + 1;
    if (p->sys == SYS_GPS) {
        eph_t ee = p->e;
        ee.iodc = ee.iode;
        long sf0 = (long)floor(ts0 / 6.0), sf1 = (long)floor(ts1 / 6.0) + 1;
        p->d0 = sf0 * 300;
        p->nd = (sf1 - sf0) * 300;
        p->dat = malloc((size_t)p->nd);
        int d29 = 0, d30 = 0;
        for (long s = sf0; s < sf1; s++) {
            uint8_t *b = p->dat + (s - sf0) * 300;
            lnav_encode(&ee, (int)(s % 5) + 1, (int)((s + 1) % 100800), d29, d30, b);
            d29 = b[298]; d30 = b[299];
        }
    } else if (p->sys == SYS_GAL) {
        /* страница — 2 с GST (500 символов), тип слова — по положению в подкадре 30 с */
        long pg0 = (long)floor(ts0 / 2.0), pg1 = (long)floor(ts1 / 2.0) + 1;
        p->d0 = pg0 * 500;
        p->nd = (pg1 - pg0) * 500;
        p->dat = malloc((size_t)p->nd);
        for (long g = pg0; g < pg1; g++) {
            int tow = (int)((2 * g) % 604800);
            inav_encode_page(&p->e, WT[(tow % 30) / 2], tow, p->e.week, p->dat + (g - pg0) * 500);
        }
    } else {
        /* подкадр D1 — 6 с BDT, кадр — 30 с BDT (подкадр 1 — с SOW, кратного 30) */
        long sf0 = (long)floor((ts0 - GPST_BDT) / 6.0), sf1 = (long)floor((ts1 - GPST_BDT) / 6.0) + 1;
        p->d0 = sf0 * 300;
        p->nd = (sf1 - sf0) * 300;
        p->dat = malloc((size_t)p->nd);
        for (long s = sf0; s < sf1; s++)
            bdsnav_encode(&p->e, (int)(s % 5) + 1, (int)((6 * s) % 604800), p->dat + (s - sf0) * 300);
    }
}

typedef struct { const eph_t *e; double el; } cand_t;
static int cmp_el(const void *a, const void *b)
{
    double d = ((const cand_t *)b)->el - ((const cand_t *)a)->el;
    return d > 0 ? 1 : d < 0 ? -1 : 0;
}

static void add_sys(int sys, int sig, int q0, int q1)
{
    cand_t c[64];
    int nc = 0;
    for (int prn = q0; prn <= q1; prn++) {
        const eph_t *e = eph_select(EPH, NE, sys, prn, T0);
        if (!e) continue;
        double el = elev(e, T0, NULL);
        if (el > 15 * GPI / 180) { c[nc].e = e; c[nc].el = el; nc++; }
    }
    qsort(c, (size_t)nc, sizeof(c[0]), cmp_el);
    for (int i = 0; i < nc && i < NMAX[sys] && NS < MAXS; i++) {
        sat_t *p = &S[NS++];
        p->sys = sys; p->sig = sig; p->prn = c[i].e->prn; p->e = *c[i].e; p->el = c[i].el;
        if (sys == SYS_GAL) {
            p->e.iode &= 0x3FF;
            p->e.sva &= 0xFF;
            p->e.svh &= 0x1C7;
        } else if (sys == SYS_BDS) {
            p->e.iode &= 31;
            p->e.iodc &= 31;
            p->e.sva &= 15;
            p->e.svh &= 1;
            p->e.tgd = round(p->e.tgd / 0.1e-9) * 0.1e-9;
        }
        p->fc = sig_carrier(sig, 0);
        p->rate = sys == SYS_GPS ? 1.023e6 : 2.046e6;
        code_gen(sig, p->prn, p->code);
        if (sys == SYS_GAL) {
            code_gen(SIG_E1C, p->prn, p->code2);
            sec_code(SIG_E1C, p->prn, p->sec);
        } else if (sys == SYS_BDS)
            sec_code(SIG_B1I, p->prn, p->sec);
        int nk = (int)(DUR * 1000) + 3;
        p->tsv = malloc(sizeof(double) * nk);
        for (int k = 0; k < nk; k++) p->tsv[k] = tsv_at(&p->e, T0 + k * 1e-3);
        make_data(p, nk);
        p->A = sqrt(pow(10, 45.0 / 10) / FS_HZ);
        p->ph0 = (xs() % 6283) / 6283.0;
    }
}

static double dist(const double *a, const double *b)
{
    return sqrt((a[0] - b[0]) * (a[0] - b[0]) + (a[1] - b[1]) * (a[1] - b[1]) + (a[2] - b[2]) * (a[2] - b[2]));
}

/* решение только по КА системы sys (≥ 4 КА); ошибка координат, времени */
static int solve_sys(const rx_t *rx, uint64_t nm, int sys, double *err, double *terr, int *n)
{
    obs_t o[PVT_MAXOBS];
    *n = 0;
    for (int i = 0; i < rx->nobs; i++) if (rx->obs[i].sys == sys) o[(*n)++] = rx->obs[i];
    if (*n < 4) return 0;
    pvt_cfg_t cfg = rx->pcfg;
    sol_t s = rx->sol;
    if (!pvt_solve(o, *n, rx_time(rx, nm), &cfg, &s)) return 0;
    *err = dist(s.pos, RR);
    *terr = s.t_rx - t_true(nm);
    return 1;
}

int main(void)
{
    setvbuf(stdout, NULL, _IOLBF, 0);
    NE = rinex_read_nav(RNX, EPH, 8000);
    for (int i = 0; i < 65536; i += 2) {
        double u1 = (xs() + 1.0) / 4294967297.0, u2 = (xs() + 1.0) / 4294967297.0;
        GN[i] = (float)(sqrt(-2 * log(u1)) * cos(2 * GPI * u2));
        GN[i + 1] = (float)(sqrt(-2 * log(u1)) * sin(2 * GPI * u2));
    }
    for (int i = 0; i < 1024; i++) SINT[i] = (float)sin(2 * GPI * (i + 0.5) / 1024);
    llh2ecef(55.7558 * GPI / 180, 37.6173 * GPI / 180, 150.0, RR);
    FLO = RF_LO[SIGS[SIG_L1CA].rf];
    double tf = 0;
    for (int i = 0; i < NE; i++) if (EPH[i].sys == SYS_GPS) { tf = EPH[i].toe; break; }
    tf = floor((tf + 1800) / 30.0) * 30.0;
    /* начало — за 3 с до кадра GPS и подкадра I/NAV (кадр D1 — с GPST, кратного 30, + 14 с) */
    T0 = tf - 3.0 + 0.075;
    add_sys(SYS_GPS, SIG_L1CA, 1, 32);
    add_sys(SYS_GAL, SIG_E1B, 1, 36);
    add_sys(SYS_BDS, SIG_B1I, 6, 58);
    int nsys[SYS_N] = {0};
    for (int s = 0; s < NS; s++) nsys[S[s].sys]++;
    printf("Имитатор: КА GPS %d, Galileo %d, BeiDou %d; L1 C/A, E1 (B+C), B1I по 45 дБГц, начало %.3f с недели, "
           "уход ТКГ %+.2f ppm, %.0f с\n", nsys[SYS_GPS], nsys[SYS_GAL], nsys[SYS_BDS], T0, DELTA * 1e6, DUR);
    for (int s = 0; s < NS; s++)
        printf("  %c%02d: угол места %4.1f°, TGD/BGD %+6.2f нс\n", SYSC[S[s].sys], S[s].prn, S[s].el * 180 / GPI,
               S[s].e.tgd * 1e9);
    corr_sim_init(2);
    corr_init();
    rx_t rx;
    rx_init(&rx);
    rx.pcfg.trop = 0;                                   /* имитатор без атмосферы */
    enum { NSNAP = 4 };
    static uint8_t x4[NSNAP][65536];
    const uint8_t *xsn[NSNAP];
    uint32_t t0s[NSNAP];
    int len = 49152;
    corr_sim_run(1000, src);
    for (int s = 0; s < NSNAP; s++) {
        acq_snap_start(0, len, 0);
        corr_sim_run((uint64_t)len + 16, src);
        acq_snap_read(len, x4[s], &t0s[s]);
        xsn[s] = x4[s];
        corr_sim_run(8000, src);
    }
    acq_cfg_t ac = {.dop_max = 6000, .dop_step = 250, .nper = 2, .thresh = 2.0};
    uint64_t t_start = (corr_sim_nsmp() + 24000) & ~3ull;
    const int sigs[3] = {SIG_L1CA, SIG_E1B, SIG_B1I};
    int ok = 1;
    for (int g = 0; g < 3; g++) {
        int nch = rx_acquire(&rx, xsn, t0s, NSNAP, len, sigs[g], t_start, &ac);
        int sys = SIGS[sigs[g]].sys, nhit = 0;
        for (int k = 0; k < CORR_MAXCH; k++) if (rx.ch[k].used && rx.ch[k].sig == sigs[g])
            for (int s = 0; s < NS; s++) nhit += S[s].sys == sys && S[s].prn == rx.ch[k].prn;
        printf("Захват %s: каналов %d, из них КА имитатора %d из %d\n", SIGS[sigs[g]].id, nch, nhit, nsys[sys]);
    }
    int nsol = 0, nfull = 0, ngal = 0, nbds = 0;
    double maxerr = 0, sum_full = 0, maxterr = 0, maxdclk = 0, maxe_gal = 0, maxe_bds = 0, maxt_1 = 0;
    uint64_t next = ((corr_sim_nsmp() / 24000000) + 1) * 24000000ull;
    while (t_true(corr_sim_nsmp()) < T0 + DUR - 0.01) {
        corr_sim_run(4096, src);
        rx_process(&rx, corr_sim_nsmp());
        if (corr_sim_nsmp() < next) continue;
        uint64_t nm = next;
        next += 24000000ull;
        int nlk[SYS_N] = {0}, neph[SYS_N] = {0};
        for (int k = 0; k < CORR_MAXCH; k++) if (rx.ch[k].used && rx.ch[k].trk.state == TRK_LOCK) {
            int sys = SIGS[rx.ch[k].sig].sys;
            nlk[sys]++;
            neph[sys] += rx_eph(&rx, sys, rx.ch[k].prn)->valid;
        }
        if (getenv("GB_DBG"))
            for (int k = 0; k < CORR_MAXCH; k++) if (rx.ch[k].used && SIGS[rx.ch[k].sig].sys != SYS_GPS) {
                rx_ch_t *c = &rx.ch[k];
                const sat_t *p = NULL;
                for (int s = 0; s < NS; s++) if (S[s].sig == c->sig && S[s].prn == c->prn) p = &S[s];
                if (!p) continue;
                int L = SIGS[c->sig].code_len;
                double cp, tt = t_true(nm), ts = tsv_sig(p, tt);
                corr_phase_at(c->ch, nm, &cp, NULL);
                double de = cp - fmod(ts * SIGS[c->sig].chip_rate, L);
                if (de > L / 2) de -= L;
                if (de < -L / 2) de += L;
                long kk = (long)((tt - T0) * 1e3);
                /* частота в единицах приёмника (отсчёты идут с частотой FS·(1 + δ)) */
                long kb = kk < (long)(DUR * 1000) - 98 ? kk : (long)(DUR * 1000) - 98;
                double fd = p->fc * ((p->tsv[kb + 100] - p->tsv[kb]) * 10 / (1 + DELTA) - 1);
                printf("    %c%02d: сост. %d, lock %.2f, C/N0 %.1f, доплер %+.1f (ист. %+.1f), ошибка кода %+.3f чипа",
                       SYSC[p->sys], c->prn, c->trk.state, c->trk.lock, c->trk.cn0, trk_doppler(&c->trk), fd, de);
                if (p->sys == SYS_GAL) {
                    const inav_t *g = &c->msg->inav;
                    printf("; I/NAV: синхр. %d, стр. %d, CRC ош. %d, TOW %d, IOD %d %d %d %d\n", g->sync, g->n_page,
                           g->n_crc_err, g->tow_ok, g->iod[0], g->iod[1], g->iod[2], g->iod[3]);
                } else {
                    const bdsnav_t *b = &c->msg->bnav;
                    printf("; NH %d, D1: синхр. %d, подкадров %d, испр. %d, ош. SOW %d\n", c->trk.sec_sync, b->sync,
                           b->n_sf, b->n_corr, b->n_sow_err);
                }
            }
        if (!rx_measure(&rx, nm)) {
            printf("  t=%5.1f с: в захвате G %d, E %d, C %d; с эфемеридами G %d, E %d, C %d — решения нет\n",
                   t_true(nm) - T0, nlk[SYS_GPS], nlk[SYS_GAL], nlk[SYS_BDS], neph[SYS_GPS], neph[SYS_GAL],
                   neph[SYS_BDS]);
            continue;
        }
        nsol++;
        int nu[SYS_N] = {0};
        for (int i = 0; i < rx.nobs; i++) nu[rx.obs[i].sys]++;
        double err = dist(rx.sol.pos, RR), terr = rx.sol.t_rx - t_true(nm);
        /* шкалы систем совмещены в имитаторе: смещения часов по системам должны совпасть */
        double dg = nu[SYS_GAL] && nu[SYS_GPS] ? rx.sol.clk[SYS_GAL] - rx.sol.clk[SYS_GPS] : 0;
        double dc = nu[SYS_BDS] && nu[SYS_GPS] ? rx.sol.clk[SYS_BDS] - rx.sol.clk[SYS_GPS] : 0;
        printf("  t=%5.1f с: КА G %d, E %d, C %d; ошибка коорд. %6.2f м, времени %+6.1f нс; шкалы E−G %+6.2f м, "
               "C−G %+6.2f м; PDOP %.2f", t_true(nm) - T0, nu[SYS_GPS], nu[SYS_GAL], nu[SYS_BDS], err, terr * 1e9,
               dg, dc, rx.sol.pdop);
        if (err > maxerr) maxerr = err;
        if (fabs(terr) > maxterr) maxterr = fabs(terr);
        if (nu[SYS_GAL] == nsys[SYS_GAL] && nu[SYS_BDS] == nsys[SYS_BDS] && nu[SYS_GPS] == nsys[SYS_GPS]) {
            nfull++;
            sum_full += err;
            if (fabs(dg) > maxdclk) maxdclk = fabs(dg);
            if (fabs(dc) > maxdclk) maxdclk = fabs(dc);
        }
        double e1, t1;
        int n1;
        if (solve_sys(&rx, nm, SYS_GAL, &e1, &t1, &n1)) {
            ngal++;
            printf("; только E (%d): %.2f м, %+.1f нс", n1, e1, t1 * 1e9);
            if (e1 > maxe_gal) maxe_gal = e1;
            if (fabs(t1) > maxt_1) maxt_1 = fabs(t1);
        }
        if (solve_sys(&rx, nm, SYS_BDS, &e1, &t1, &n1)) {
            nbds++;
            printf("; только C (%d): %.2f м, %+.1f нс", n1, e1, t1 * 1e9);
            if (e1 > maxe_bds) maxe_bds = e1;
            if (fabs(t1) > maxt_1) maxt_1 = fabs(t1);
        }
        printf("\n");
    }
    /* состояние каналов, эфемериды (сверка координат и часов КА с исходными), ошибки ПД на последней
     * эпохе относительно истинного времени КА в сигнале (общая ошибка шкалы исключена по среднему) */
    int nlock = 0, neph_ok = 0;
    double m = 0;
    int nmn = 0;
    for (int i = 0; i < rx.nobs; i++)
        for (int s = 0; s < NS; s++) if (S[s].sys == rx.obs[i].sys && S[s].prn == rx.obs[i].prn) {
            m += rx.obs[i].pr - CLIGHT * (rx_time(&rx, rx.sol_n) - tsv_sig(&S[s], t_true(rx.sol_n)));
            nmn++;
        }
    m = nmn ? m / nmn : 0;
    for (int s = 0; s < NS; s++) {
        sat_t *p = &S[s];
        const rx_ch_t *c = NULL;
        for (int k = 0; k < CORR_MAXCH; k++)
            if (rx.ch[k].used && rx.ch[k].sig == p->sig && rx.ch[k].prn == p->prn) c = &rx.ch[k];
        const eph_t *d = rx_eph(&rx, p->sys, p->prn);
        double de = -1, dt = 0;
        if (d->valid) {
            double r0[3], r1[3], c0, c1, t = T0 + DUR;
            eph_satpos(&p->e, t, r0, &c0, NULL, NULL);
            eph_satpos(d, t, r1, &c1, NULL, NULL);
            de = dist(r0, r1);
            dt = (c1 - d->tgd) - (c0 - p->e.tgd);
        }
        int eok = de >= 0 && de < 0.1 && fabs(dt) < 0.5e-9;
        double pe = NAN;
        for (int i = 0; i < rx.nobs; i++) if (rx.obs[i].sys == p->sys && rx.obs[i].prn == p->prn)
            pe = rx.obs[i].pr - CLIGHT * (rx_time(&rx, rx.sol_n) - tsv_sig(p, t_true(rx.sol_n))) - m;
        printf("  %c%02d: %s, C/N0 %.1f дБГц; эфемериды %s (коорд. %.3f м, часы %+.3f нс); ошибка ПД %+.2f м\n",
               SYSC[p->sys], p->prn, !c ? "нет канала" : c->trk.state == TRK_LOCK ? "захват" : "нет захвата",
               c ? c->trk.cn0 : 0.0, eok ? "верны" : d->valid ? "НЕ СОВПАДАЮТ" : "нет", de, dt * 1e9, pe);
        nlock += c && c->trk.state == TRK_LOCK;
        neph_ok += eok;
    }
    printf("Решений %d, по всем КА трёх систем %d: средняя ошибка коорд. %.2f м; макс. ошибка коорд. %.2f м, "
           "времени %.1f нс; макс. расхождение шкал %.2f м\n", nsol, nfull, nfull ? sum_full / nfull : 0.0, maxerr,
           maxterr * 1e9, maxdclk);
    printf("Решений только по Galileo %d (макс. ошибка %.2f м), только по BeiDou %d (%.2f м); макс. ошибка времени "
           "%.1f нс\n", ngal, maxe_gal, nbds, maxe_bds, maxt_1 * 1e9);
    /* критерии: все каналы в захвате и эфемериды приняты; не менее 3 решений по всем КА, средняя
     * ошибка ≤ 3 м, макс. ≤ 15 м, времени ≤ 20 нс; расхождение шкал ≤ 3 м (по ПД — ошибок шкалы в
     * десятки нс нет); по одной системе — ошибка ≤ 15 м, времени ≤ 50 нс */
    if (nlock < NS || neph_ok < NS || nfull < 3 || sum_full / nfull > 3 || maxerr > 15 || maxterr > 20e-9 ||
        maxdclk > 3 || ngal < 1 || nbds < 1 || maxe_gal > 15 || maxe_bds > 15 || maxt_1 > 50e-9) ok = 0;
    printf("ИТОГ: %s\n", ok ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    return !ok;
}
