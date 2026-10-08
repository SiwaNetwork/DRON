/* Сквозная проверка «ПЧ -> координаты и 1PPS» на модели ПЛИС.
 * Имитатор: все видимые КА GPS над Москвой по эфемеридам RINEX (геометрия, часы КА, поворот
 * Земли), навигационное сообщение LNAV с этими эфемеридами, C/N0 45 дБГц, уход ТКГ +0,3 ppm.
 * ПО МК: захват по снимкам, слежение, декодирование эфемерид, псевдодальности, решение,
 * NMEA, вычисление момента 1PPS. Проверка: ошибка координат, дрейфа часов и момента 1PPS. */
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
#include "pvt.h"
#include "nmea.h"
#include "rx.h"

#define RNX "../../sim/data/BRDC00IGS_R_20211700000_01D_MN_subset.rnx"
#define MAXS 16
#define DUR  27.0                    /* с */

static eph_t EPH[8000];
static int NE;
static double T0, DELTA = 0.3e-6, RR[3], FLO;
static float GN[65536];
static uint32_t rng = 777;
static uint32_t xs(void) { rng ^= rng << 13; rng ^= rng >> 17; rng ^= rng << 5; return rng; }

typedef struct {
    int prn;
    const eph_t *e;
    double *tsv;                     /* время КА на сетке 1 мс истинного времени */
    uint8_t code[CODE_MAX_BYTES];
    uint8_t *bits;                   /* биты LNAV, начиная с бита b0 */
    long b0, nb;
    double A, ph0;
} sat_t;
static sat_t S[MAXS];
static int NS;

static double t_true(uint64_t n) { return T0 + (double)n / (FS_HZ * (1 + DELTA)); }

/* время излучения по шкале КА для истинного момента приёма t */
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

static uint32_t src(uint64_t i)
{
    double t = t_true(i), dt = (t - T0) * 1e3;
    long k = (long)dt;
    double fr = dt - k, re = 0, im = 0;
    for (int s = 0; s < NS; s++) {
        sat_t *p = &S[s];
        double tsv = p->tsv[k] + (p->tsv[k + 1] - p->tsv[k]) * fr;
        double cms = fmod(tsv, 1e-3) * 1.023e6;
        int c = code_bit(p->code, (int)cms) ? -1 : 1;
        long bi = (long)floor(tsv / 0.02) - p->b0;
        int b = (bi >= 0 && bi < p->nb && p->bits[bi]) ? -1 : 1;
        double ph = 2 * GPI * (sig_carrier(SIG_L1CA, 0) * (tsv - T0) - FLO * (1 + DELTA) * (t - T0)) + p->ph0;
        re += p->A * c * b * cos(ph);
        im += p->A * c * b * sin(ph);
    }
    re += GN[xs() & 65535] * 0.70710678;
    im += GN[xs() & 65535] * 0.70710678;
    int qi = (re < 0 ? 2 : 0) | (fabs(re) > 0.70710678 ? 1 : 0), qq = (im < 0 ? 2 : 0) | (fabs(im) > 0.70710678 ? 1 : 0);
    return (uint32_t)(qi << 2 | qq);
}

int main(void)
{
    NE = rinex_read_nav(RNX, EPH, 8000);
    for (int i = 0; i < 65536; i += 2) {
        double u1 = (xs() + 1.0) / 4294967297.0, u2 = (xs() + 1.0) / 4294967297.0;
        GN[i] = (float)(sqrt(-2 * log(u1)) * cos(2 * GPI * u2));
        GN[i + 1] = (float)(sqrt(-2 * log(u1)) * sin(2 * GPI * u2));
    }
    llh2ecef(55.7558 * GPI / 180, 37.6173 * GPI / 180, 150.0, RR);
    FLO = RF_LO[0];
    /* начало: за 3 с до начала кадра (подкадр 1) по шкале КА */
    double tf = 0;
    for (int i = 0; i < NE; i++) if (EPH[i].sys == SYS_GPS) { tf = EPH[i].toe; break; }
    tf = floor((tf + 1800) / 30.0) * 30.0;
    T0 = tf - 3.0 + 0.075;
    /* видимые КА */
    double lat = 55.7558 * GPI / 180, lon = 37.6173 * GPI / 180;
    for (int prn = 1; prn <= 32 && NS < MAXS; prn++) {
        const eph_t *e = eph_select(EPH, NE, SYS_GPS, prn, T0);
        if (!e) continue;
        double rs[3], dts;
        eph_satpos(e, T0, rs, &dts, NULL, NULL);
        double d[3] = {rs[0] - RR[0], rs[1] - RR[1], rs[2] - RR[2]}, rho = sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
        double u = (cos(lat) * cos(lon) * d[0] + cos(lat) * sin(lon) * d[1] + sin(lat) * d[2]) / rho;
        if (asin(u) < 10 * GPI / 180) continue;
        sat_t *p = &S[NS++];
        p->prn = prn; p->e = e;
        code_gen(SIG_L1CA, prn, p->code);
        int nk = (int)(DUR * 1000) + 3;
        p->tsv = malloc(sizeof(double) * nk);
        for (int k = 0; k < nk; k++) p->tsv[k] = tsv_at(e, T0 + k * 1e-3);
        /* биты LNAV: подкадры от начала, предшествующего p->tsv[0] − 6 с */
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
        p->A = sqrt(pow(10, 45.0 / 10) / FS_HZ);
        p->ph0 = (xs() % 6283) / 1000.0;
    }
    printf("Имитатор: КА GPS %d, начало %.3f с недели, уход ТКГ %+.2f ppm, %.0f с\n", NS, T0, DELTA * 1e6, DUR);
    corr_sim_init(1);
    corr_init();
    rx_t rx;
    rx_init(&rx);
    rx.pcfg.trop = 0;                                   /* имитатор без атмосферы */
    /* снимки и захват */
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
    int nch = rx_acquire(&rx, xsn, t0s, NSNAP, len, SIG_L1CA, t_start, &ac);
    printf("Захват: найдено %d из %d КА\n", nch, NS);
    /* слежение, навигация, решение раз в секунду */
    int ok = 1, nsol = 0;
    double maxerr = 0, maxpps = 0;
    uint64_t next = ((corr_sim_nsmp() / 24000000) + 1) * 24000000ull;
    while (t_true(corr_sim_nsmp()) < T0 + DUR - 0.01) {
        corr_sim_run(4096, src);
        rx_process(&rx, corr_sim_nsmp());
        if (corr_sim_nsmp() < next) continue;
        uint64_t nm = next;
        next += 24000000ull;
        int nlk = 0, ntx = 0, neph = 0;
        for (int k = 0; k < CORR_MAXCH; k++) if (rx.ch[k].used) {
            nlk += rx.ch[k].trk.state == TRK_LOCK; ntx += rx.ch[k].tx_ok; neph += rx.eph[SYS_GPS][rx.ch[k].prn].valid;
        }
        if (!rx_measure(&rx, nm)) {
            printf("  t=%5.1f с: каналов в захвате %d, с временем %d, с эфемеридами %d — решения нет\n",
                   t_true(nm) - T0, nlk, ntx, neph);
            continue;
        }
        nsol++;
        double d[3] = {rx.sol.pos[0] - RR[0], rx.sol.pos[1] - RR[1], rx.sol.pos[2] - RR[2]};
        double err = sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
        double terr = rx.sol.t_rx - t_true(nm);
        double ddrift = rx.sol.clkd / CLIGHT - DELTA / (1 + DELTA);
        /* 1PPS: следующая секунда GPST */
        uint64_t t96;
        double qe, sec;
        rx_pps_next(&rx, nm, &t96, &qe, &sec);
        double n_true = (sec - T0) * FS_HZ * (1 + DELTA);
        double pps_err = ((double)(t96 + 1 + PPS_DELAY_T96) - 4.0 * n_true) / F96_HZ;
        double pps_err_q = pps_err + qe;                       /* с учётом qErr */
        printf("  t=%5.1f с: КА %2d, ошибка коорд. %6.2f м, времени %+7.1f нс, дрейфа %+.3f ppb, 1PPS %+6.2f нс "
               "(после qErr %+.2f нс), PDOP %.2f\n", t_true(nm) - T0, rx.sol.nsat, err, terr * 1e9, ddrift * 1e9,
               pps_err * 1e9, pps_err_q * 1e9, rx.sol.pdop);
        if (err > maxerr) maxerr = err;
        if (fabs(pps_err_q) > maxpps) maxpps = fabs(pps_err_q);
        if (nsol == 2) {
            char buf[4096];
            int week = rx.week;
            nmea_gga(buf, &rx.sol, week, rx.sol.t_rx, rx.dt_ls); printf("    %s", buf);
            nmea_rmc(buf, &rx.sol, week, rx.sol.t_rx, rx.dt_ls); printf("    %s", buf);
            nmea_zda(buf, week, rx.sol.t_rx, rx.dt_ls); printf("    %s", buf);
            int l = nmea_gsa(buf, &rx.sol, rx.obs, rx.nobs); buf[l] = 0; printf("    %s", buf);
            l = nmea_gsv(buf, rx.obs, rx.nobs); buf[l] = 0;
            for (char *p = buf; *p;) { char *q = strstr(p, "\r\n"); if (!q) break; *q = 0; printf("    %s\n", p); p = q + 2; }
        }
    }
    printf("Решений %d; макс. ошибка координат %.2f м; макс. ошибка 1PPS (с qErr) %.2f нс\n", nsol, maxerr, maxpps * 1e9);
    if (nsol < 2 || maxerr > 15 || maxpps > 20e-9) ok = 0;
    printf("ИТОГ: %s\n", ok ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    return !ok;
}
