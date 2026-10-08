/* Сквозная проверка «ПЧ -> координаты и 1PPS» по GPS L1 C/A и ГЛОНАСС L1OF на модели ПЛИС.
 * Имитатор: видимые КА GPS и ГЛОНАСС над Москвой по эфемеридам RINEX (геометрия, часы КА,
 * поворот Земли), навигационные сообщения LNAV и строки ГЛОНАСС с этими эфемеридами, C/N0
 * 45 дБГц, уход ТКГ +0,3 ппм; ВЧ-канал 0 — GPS (гетеродин 1568 МГц), ВЧ-канал 1 — ГЛОНАСС
 * (1602 МГц, литеры −7…+6). ПО МК: захват по снимкам обоих каналов, слежение, LNAV и строки
 * ГЛОНАСС, решение с раздельными шкалами систем, 1PPS. Проверка: число КА ГЛОНАСС в решении,
 * ошибка координат и 1PPS. Имитатор потоковый: состояние КА пересчитывается раз в 1 мс. */
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
#include "glonav.h"
#include "pvt.h"
#include "nmea.h"
#include "rx.h"

#define RNX "../../sim/data/BRDC00IGS_R_20211700000_01D_MN_subset.rnx"
#define MAXS 24
#define DUR  33.0

static eph_t EPH[8000];
static int NE;
static double T0, DELTA = 0.3e-6, RR[3];
static float GN[65536], SINT[1024];
static uint32_t rng = 777;
static uint32_t xs(void) { rng ^= rng << 13; rng ^= rng >> 17; rng ^= rng << 5; return rng; }

typedef struct {
    int sys, prn, fcn, rf, L;
    const eph_t *e;
    double *tsv;                     /* время КА (GPST) на сетке 1 мс истинного времени */
    uint8_t code[CODE_MAX_BYTES];
    double chip_rate, fc, flo;
    uint8_t *bits; long b0, nb;      /* GPS: биты LNAV */
    long str_i; int8_t str_sym[200]; /* ГЛОНАСС: символы текущей строки */
    double A, ph0;
    /* потоковое состояние (внутри миллисекунды) */
    double ts, dts, cp, dcp;
    uint32_t ph, dph;
    int val;                         /* знак данных/символа на текущем периоде кода */
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

/* знак данных на текущем периоде кода (по времени КА) */
static int data_sign(sat_t *p, double ts)
{
    if (p->sys == SYS_GPS) {
        long bi = (long)floor(ts / 0.02) - p->b0;
        return (bi >= 0 && bi < p->nb && p->bits[bi]) ? -1 : 1;
    }
    double tod = fmod(ts - GPST_UTC + 10800.0 + 7 * 86400.0, 86400.0);
    long si = (long)floor(tod / 2.0);
    if (si != p->str_i) {
        uint8_t str[GLO_STR_BITS];
        int m = (int)(si % 15) + 1;
        double tk = floor(tod / 30.0) * 30.0;
        glo_str_encode(p->e, m, tk, p->prn, str);
        glo_str_symbols(str, p->str_sym);
        p->str_i = si;
    }
    int k = (int)floor(fmod(tod, 2.0) * 100.0 + 1e-9);
    if (k > 199) k = 199;
    return p->str_sym[k];
}

/* состояние КА на начало миллисекунды k (первый отсчёт i0) */
static void sat_ms(sat_t *p, long k, uint64_t i0)
{
    double t = t_true(i0), fr = (t - T0) * 1e3 - k;
    double ts = p->tsv[k] + (p->tsv[k + 1] - p->tsv[k]) * fr;
    p->ts = ts;
    p->dts = (p->tsv[k + 1] - p->tsv[k]) * 1e3 / (FS_HZ * (1 + DELTA));
    double Tc = p->L / p->chip_rate;
    p->cp = fmod(ts, Tc) * p->chip_rate;
    p->dcp = p->dts * p->chip_rate;
    double ph = p->fc * (ts - T0) - p->flo * (1 + DELTA) * (t - T0) + p->ph0 / (2 * GPI);
    p->ph = (uint32_t)(int64_t)llround((ph - floor(ph)) * 4294967296.0);
    double dph = p->fc * p->dts - p->flo / FS_HZ;
    p->dph = (uint32_t)(int64_t)llround(dph * 4294967296.0);
    p->val = data_sign(p, ts);
}

static long cur_ms = -1;
static uint64_t next_i;

static int q2(double v) { return (v < 0 ? 2 : 0) | (fabs(v) > 0.70710678 ? 1 : 0); }

static uint32_t src(uint64_t i)
{
    if (i >= next_i || cur_ms < 0) {
        long k = (long)floor((t_true(i) - T0) * 1e3);
        cur_ms = k;
        for (int s = 0; s < NS; s++) sat_ms(&S[s], k, i);
        /* первый отсчёт следующей миллисекунды */
        next_i = (uint64_t)ceil((k + 1) * 1e-3 * FS_HZ * (1 + DELTA));
        if (next_i <= i) next_i = i + 1;
    }
    double re[2] = {0, 0}, im[2] = {0, 0};
    for (int s = 0; s < NS; s++) {
        sat_t *p = &S[s];
        int c = code_bit(p->code, (int)p->cp) ? -1 : 1;
        float v = (float)(p->A * c * p->val);
        float cs = SINT[((p->ph >> 22) + 256) & 1023], sn = SINT[p->ph >> 22];
        re[p->rf] += v * cs; im[p->rf] += v * sn;
        p->ts += p->dts;
        p->cp += p->dcp;
        if (p->cp >= p->L) { p->cp -= p->L; p->val = data_sign(p, p->ts); }
        p->ph += p->dph;
    }
    uint32_t w = 0;
    for (int r = 0; r < 2; r++) {
        double a = re[r] + GN[xs() & 65535] * 0.70710678, b = im[r] + GN[xs() & 65535] * 0.70710678;
        w |= (uint32_t)(q2(a) << 2 | q2(b)) << (4 * r);
    }
    return w;
}

static void add_sat(int sys, int prn, const eph_t *e)
{
    sat_t *p = &S[NS++];
    memset(p, 0, sizeof(*p));
    p->sys = sys; p->prn = prn; p->e = e;
    int sig = sys == SYS_GPS ? SIG_L1CA : SIG_G1CA;
    p->fcn = sys == SYS_GLO ? e->fcn : 0;
    p->rf = SIGS[sig].rf;
    p->L = code_gen(sig, prn, p->code);
    p->chip_rate = SIGS[sig].chip_rate;
    p->fc = sig_carrier(sig, p->fcn);
    p->flo = RF_LO[p->rf];
    p->str_i = -1;
    int nk = (int)(DUR * 1000) + 3;
    p->tsv = malloc(sizeof(double) * nk);
    for (int k = 0; k < nk; k++) p->tsv[k] = tsv_at(e, T0 + k * 1e-3);
    if (sys == SYS_GPS) {
        eph_t ee = *e;
        ee.iodc = ee.iode;
        long sf0 = (long)floor((p->tsv[0] - 6) / 6.0), sf1 = (long)floor(p->tsv[nk - 1] / 6.0) + 1;
        p->b0 = sf0 * 300;
        p->nb = (sf1 - sf0) * 300;
        p->bits = malloc((size_t)p->nb);
        int d29 = 0, d30 = 0;
        for (long s = sf0; s < sf1; s++) {
            int id = (int)(s % 5) + 1;
            lnav_encode(&ee, id, (int)((s + 1) % 100800), d29, d30, p->bits + (s - sf0) * 300);
            d29 = p->bits[(s - sf0) * 300 + 298]; d30 = p->bits[(s - sf0) * 300 + 299];
        }
    }
    p->A = sqrt(pow(10, 45.0 / 10) / FS_HZ);
    p->ph0 = (xs() % 6283) / 1000.0;
}

static int visible(const eph_t *e, double t)
{
    double rs[3], dts, lat = 55.7558 * GPI / 180, lon = 37.6173 * GPI / 180;
    eph_satpos(e, t, rs, &dts, NULL, NULL);
    double d[3] = {rs[0] - RR[0], rs[1] - RR[1], rs[2] - RR[2]}, rho = sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
    double u = (cos(lat) * cos(lon) * d[0] + cos(lat) * sin(lon) * d[1] + sin(lat) * d[2]) / rho;
    return asin(u) >= 10 * GPI / 180;
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
    /* начало: за 3 с до кадра GPS (подкадр 1); кадр ГЛОНАСС — через 18 с после него */
    double tf = 0;
    for (int i = 0; i < NE; i++) if (EPH[i].sys == SYS_GPS) { tf = EPH[i].toe; break; }
    tf = floor((tf + 1800) / 30.0) * 30.0;
    T0 = tf - 3.0 + 0.075;
    int ngps = 0, nglo = 0;
    for (int prn = 1; prn <= 32 && NS < MAXS; prn++) {
        const eph_t *e = eph_select(EPH, NE, SYS_GPS, prn, T0);
        if (e && visible(e, T0)) { add_sat(SYS_GPS, prn, e); ngps++; }
    }
    for (int slot = 1; slot <= 24 && NS < MAXS; slot++) {
        const eph_t *e = eph_select(EPH, NE, SYS_GLO, slot, T0);
        if (e && visible(e, T0)) { add_sat(SYS_GLO, slot, e); nglo++; }
    }
    printf("Имитатор: КА GPS %d, ГЛОНАСС %d, начало %.3f с недели, уход ТКГ %+.2f ppm, %.0f с\n", ngps, nglo, T0,
           DELTA * 1e6, DUR);
    for (int s = 0; s < NS; s++) if (S[s].sys == SYS_GLO) printf(" R%02d(%+d)", S[s].prn, S[s].fcn);
    printf("\n");
    corr_sim_init(2);
    corr_init();
    rx_t rx;
    rx_init(&rx);
    rx.pcfg.trop = 0;                                   /* имитатор без атмосферы */
    /* снимки обоих ВЧ-каналов и захват */
    enum { NSNAP = 4 };
    static uint8_t x4[2][NSNAP][65536];
    const uint8_t *xsn[2][NSNAP];
    uint32_t t0s[2][NSNAP];
    int len = 49152;
    corr_sim_run(1000, src);
    for (int r = 0; r < 2; r++)
        for (int s = 0; s < NSNAP; s++) {
            acq_snap_start(r, len, 0);
            corr_sim_run((uint64_t)len + 16, src);
            acq_snap_read(len, x4[r][s], &t0s[r][s]);
            xsn[r][s] = x4[r][s];
            corr_sim_run(8000, src);
        }
    acq_cfg_t ac = {.dop_max = 6000, .dop_step = 250, .nper = 2, .thresh = 2.0};
    uint64_t t_start = (corr_sim_nsmp() + 24000) & ~3ull;
    int na = rx_acquire(&rx, xsn[0], t0s[0], NSNAP, len, SIG_L1CA, t_start, &ac);
    int nb = rx_acquire(&rx, xsn[1], t0s[1], NSNAP, len, SIG_G1CA, t_start, &ac);
    printf("Захват: GPS %d из %d, ГЛОНАСС %d из %d (литеры:", na, ngps, nb, nglo);
    for (int k = 0; k < CORR_MAXCH; k++) if (rx.ch[k].used && rx.ch[k].sig == SIG_G1CA) printf(" %+d", rx.ch[k].fcn);
    printf(")\n");
    int ok = 1, nsol = 0, maxglo = 0;
    double maxerr = 0, maxpps = 0;
    uint64_t next = ((corr_sim_nsmp() / 24000000) + 1) * 24000000ull;
    while (t_true(corr_sim_nsmp()) < T0 + DUR - 0.01) {
        corr_sim_run(4096, src);
        rx_process(&rx, corr_sim_nsmp());
        if (corr_sim_nsmp() < next) continue;
        uint64_t nm = next;
        next += 24000000ull;
        int nl[2] = {0, 0}, nt[2] = {0, 0}, nep[2] = {0, 0};
        for (int k = 0; k < CORR_MAXCH; k++) if (rx.ch[k].used) {
            int g = rx.ch[k].sig == SIG_G1CA;
            nl[g] += rx.ch[k].trk.state == TRK_LOCK; nt[g] += rx.ch[k].tx_ok;
            nep[g] += rx.ch[k].prn > 0 && rx.eph[g ? SYS_GLO : SYS_GPS][rx.ch[k].prn].valid;
        }
        if (!rx_measure(&rx, nm)) {
            printf("  t=%5.1f с: в захвате GPS/ГЛО %d/%d, с временем %d/%d, с эфемеридами %d/%d — решения нет\n",
                   t_true(nm) - T0, nl[0], nl[1], nt[0], nt[1], nep[0], nep[1]);
            continue;
        }
        nsol++;
        double d[3] = {rx.sol.pos[0] - RR[0], rx.sol.pos[1] - RR[1], rx.sol.pos[2] - RR[2]};
        double err = sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
        int ng = 0;
        for (int i = 0; i < rx.nobs; i++) ng += rx.obs[i].used && rx.obs[i].sys == SYS_GLO;
        uint64_t t96;
        double qe, sec;
        rx_pps_next(&rx, nm, &t96, &qe, &sec);
        double n_true = (sec - T0) * FS_HZ * (1 + DELTA);
        double pps_err = ((double)(t96 + 1 + PPS_DELAY_T96) - 4.0 * n_true) / F96_HZ + qe;
        printf("  t=%5.1f с: КА %2d (ГЛОНАСС %d), систем %d, ошибка коорд. %6.2f м, 1PPS (с qErr) %+6.2f нс, "
               "смещение шкалы ГЛОНАСС %+.1f нс, PDOP %.2f\n", t_true(nm) - T0, rx.sol.nsat, ng, rx.sol.nsys, err,
               pps_err * 1e9, (rx.sol.clk[SYS_GLO] - rx.sol.clk[SYS_GPS]) / CLIGHT * 1e9, rx.sol.pdop);
        if (ng > maxglo) maxglo = ng;
        if (ng >= 4) {
            if (err > maxerr) maxerr = err;
            if (fabs(pps_err) > maxpps) maxpps = fabs(pps_err);
        }
    }
    printf("Решений %d; КА ГЛОНАСС в решении до %d; при ≥ 4 КА ГЛОНАСС: макс. ошибка координат %.2f м, "
           "1PPS %.2f нс\n", nsol, maxglo, maxerr, maxpps * 1e9);
    if (nsol < 2 || maxglo < 4 || maxerr > 15 || maxpps > 20e-9) ok = 0;
    printf("ИТОГ: %s\n", ok ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    return !ok;
}
