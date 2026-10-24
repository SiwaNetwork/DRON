/* Имитатор сигналов GPS L1 C/A — см. sim_gps.h. */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "gnss.h"
#include "codes.h"
#include "eph.h"
#include "rinex.h"
#include "lnav.h"
#include "pvt.h"
#include "sim_gps.h"

#define RNX "../../sim/data/BRDC00IGS_R_20211700000_01D_MN_subset.rnx"
#define MAXS 16

double SIM_T0, SIM_DELTA = 0.3e-6, SIM_RR[3];

static eph_t EPH[8000];
static int NE;
static double FLO;
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

double sim_gps_t(uint64_t n) { return SIM_T0 + (double)n / (FS_HZ * (1 + SIM_DELTA)); }

/* время излучения по шкале КА для истинного момента приёма t */
static double tsv_at(const eph_t *e, double t)
{
    double tau = 0.075, rs[3], dts;
    const double *RR = SIM_RR;
    for (int it = 0; it < 4; it++) {
        eph_satpos(e, t - tau, rs, &dts, NULL, NULL);
        double th = 7.2921151467e-5 * tau;
        double x = rs[0] * cos(th) + rs[1] * sin(th), y = -rs[0] * sin(th) + rs[1] * cos(th);
        tau = sqrt((x - RR[0]) * (x - RR[0]) + (y - RR[1]) * (y - RR[1]) + (rs[2] - RR[2]) * (rs[2] - RR[2])) / CLIGHT;
    }
    eph_satpos(e, t - tau, rs, &dts, NULL, NULL);
    return t - tau + dts - e->tgd;                      /* L1 C/A: Δt − TGD */
}

uint32_t sim_gps_src(uint64_t i)
{
    double t = sim_gps_t(i), dt = (t - SIM_T0) * 1e3;
    long k = (long)dt;
    double fr = dt - k, re = 0, im = 0;
    for (int s = 0; s < NS; s++) {
        sat_t *p = &S[s];
        double tsv = p->tsv[k] + (p->tsv[k + 1] - p->tsv[k]) * fr;
        double cms = fmod(tsv, 1e-3) * 1.023e6;
        int c = code_bit(p->code, (int)cms) ? -1 : 1;
        long bi = (long)floor(tsv / 0.02) - p->b0;
        int b = (bi >= 0 && bi < p->nb && p->bits[bi]) ? -1 : 1;
        double ph = 2 * GPI * (sig_carrier(SIG_L1CA, 0) * (tsv - SIM_T0) - FLO * (1 + SIM_DELTA) * (t - SIM_T0)) + p->ph0;
        re += p->A * c * b * cos(ph);
        im += p->A * c * b * sin(ph);
    }
    re += GN[xs() & 65535] * 0.70710678;
    im += GN[xs() & 65535] * 0.70710678;
    int qi = (re < 0 ? 2 : 0) | (fabs(re) > 0.70710678 ? 1 : 0), qq = (im < 0 ? 2 : 0) | (fabs(im) > 0.70710678 ? 1 : 0);
    return (uint32_t)(qi << 2 | qq);
}

int sim_gps_init(double dur)
{
    NE = rinex_read_nav(RNX, EPH, 8000);
    for (int i = 0; i < 65536; i += 2) {
        double u1 = (xs() + 1.0) / 4294967297.0, u2 = (xs() + 1.0) / 4294967297.0;
        GN[i] = (float)(sqrt(-2 * log(u1)) * cos(2 * GPI * u2));
        GN[i + 1] = (float)(sqrt(-2 * log(u1)) * sin(2 * GPI * u2));
    }
    llh2ecef(55.7558 * GPI / 180, 37.6173 * GPI / 180, 150.0, SIM_RR);
    FLO = RF_LO[0];
    /* начало: за 3 с до начала кадра (подкадр 1) по шкале КА */
    double tf = 0;
    for (int i = 0; i < NE; i++) if (EPH[i].sys == SYS_GPS) { tf = EPH[i].toe; break; }
    tf = floor((tf + 1800) / 30.0) * 30.0;
    SIM_T0 = tf - 3.0 + 0.075;
    /* видимые КА */
    double lat = 55.7558 * GPI / 180, lon = 37.6173 * GPI / 180;
    const double *RR = SIM_RR;
    for (int prn = 1; prn <= 32 && NS < MAXS; prn++) {
        const eph_t *e = eph_select(EPH, NE, SYS_GPS, prn, SIM_T0);
        if (!e) continue;
        double rs[3], dts;
        eph_satpos(e, SIM_T0, rs, &dts, NULL, NULL);
        double d[3] = {rs[0] - RR[0], rs[1] - RR[1], rs[2] - RR[2]}, rho = sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
        double u = (cos(lat) * cos(lon) * d[0] + cos(lat) * sin(lon) * d[1] + sin(lat) * d[2]) / rho;
        if (asin(u) < 10 * GPI / 180) continue;
        sat_t *p = &S[NS++];
        p->prn = prn; p->e = e;
        code_gen(SIG_L1CA, prn, p->code);
        int nk = (int)(dur * 1000) + 3;
        p->tsv = malloc(sizeof(double) * nk);
        for (int k = 0; k < nk; k++) p->tsv[k] = tsv_at(e, SIM_T0 + k * 1e-3);
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
    return NS;
}

int sim_gps_prn(int i) { return i >= 0 && i < NS ? S[i].prn : 0; }

void sim_gps_cn0(int i, double cn0)
{
    if (i >= 0 && i < NS) S[i].A = sqrt(pow(10, cn0 / 10) / FS_HZ);
}
