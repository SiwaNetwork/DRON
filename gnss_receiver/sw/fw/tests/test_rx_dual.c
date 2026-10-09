/* Сквозная проверка двухчастотного режима GPS L1 C/A + L2C (ТЗ п. 5.2.5) на модели ПЛИС.
 * Имитатор: видимые КА GPS над Москвой по эфемеридам RINEX; L1 C/A (45 дБГц, LNAV) — ВЧ-канал 1,
 * L2C (43,5 дБГц, CM с символами 50 с⁻¹ и CL во временном уплотнении) — ВЧ-канал 3; ионосфера —
 * однослойная модель (350 км) с ВПЭС 50 TECU и горизонтальным градиентом ±30 %: групповая
 * задержка I на L1 и γ·I на L2 (γ = (f1/f2)²); часы КА — Δt − TGD на L1 и Δt − γ·TGD на L2
 * (IS-GPS-200); уход ТКГ +0,3 ppm. Код CL — псевдослучайная последовательность (в коррелятор
 * не попадает: половины чипов CL обнуляются в канале L2CM).
 * ПО МК: захват L1 по снимкам, слежение, LNAV, запуск L2CM по каналу L1 (без поиска),
 * ПД на двух частотах, ионосферно-свободная комбинация, решение.
 * Проверка: каналы L2CM в захвате для всех КА, ошибка координат по ионосферно-свободной
 * комбинации, оценка наклонной ионосферной задержки по P2 − P1; для сравнения — решение
 * только по L1 (без модели ионосферы: параметры Клобучара в имитаторе не передаются). */
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
#include "rx.h"

#define RNX "../../sim/data/BRDC00IGS_R_20211700000_01D_MN_subset.rnx"
#define MAXS 16
#define DUR  28.0                    /* с */
#define VTEC 50.0                    /* TECU */

static eph_t EPH[8000];
static int NE;
static double T0, DELTA = 0.3e-6, RR[3], F1, F2, G12, FLO1, FLO2;
static float GN[65536], SINT[1024];
static uint32_t rng = 4242;
static uint32_t xs(void) { rng ^= rng << 13; rng ^= rng >> 17; rng ^= rng << 5; return rng; }

typedef struct {                     /* состояние сигнала одной частоты на текущей миллисекунде */
    int64_t  idx;                    /* номер чипа (L1 — 1,023 МГц; L2 — полу-чипы TDM 1,023 МГц) */
    double   x, dx;                  /* положение внутри чипа и шаг на отсчёт */
    uint32_t ph, dph;                /* фаза несущей (циклы·2^32) */
    float    v;                      /* текущее значение чипа с данными, ±A */
} band_t;

typedef struct {
    int prn;
    const eph_t *e;
    double *tsv;                     /* время КА (без ионосферы и TGD) на сетке 1 мс истинного времени */
    uint8_t code1[CODE_MAX_BYTES], code2[CODE_MAX_BYTES];
    uint8_t *bits;                   /* биты LNAV, начиная с бита b0 */
    long b0, nb;
    uint8_t *sym2;                   /* символы CNAV (L2CM), начиная с символа s0 */
    long s0, ns2;
    double I1;                       /* наклонная ионосферная задержка на L1, м */
    double A1, A2, ph1, ph2, el;
    band_t b[2];
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

/* псевдослучайный чип CL (номер в периоде 767250) */
static int cl_chip(int64_t j)
{
    uint32_t h = (uint32_t)(j % 767250) * 2654435761u;
    h ^= h >> 15; h *= 2246822519u; h ^= h >> 13;
    return (h >> 7) & 1;
}

static void chip_value(sat_t *p, int f)
{
    band_t *b = &p->b[f];
    if (f == 0) {
        int c = code_bit(p->code1, (int)(b->idx % 1023));
        long bi = (long)(b->idx / 20460) - p->b0;
        int d = (bi >= 0 && bi < p->nb) ? p->bits[bi] : 0;
        b->v = (float)((c ^ d) ? -p->A1 : p->A1);
    } else if (!(b->idx & 1)) {                          /* чётный полу-чип — CM с символом */
        int c = code_bit(p->code2, (int)((b->idx >> 1) % 10230));
        long si = (long)(b->idx / 20460) - p->s0;
        int d = (si >= 0 && si < p->ns2) ? p->sym2[si] : 0;
        b->v = (float)((c ^ d) ? -p->A2 : p->A2);
    } else {
        b->v = (float)(cl_chip(b->idx >> 1) ? -p->A2 : p->A2);
    }
}

/* состояние на отсчёт i (начало миллисекунды k истинного времени) */
static void ms_state(sat_t *p, long k, uint64_t i)
{
    double t = t_true(i), fr = (t - T0) * 1e3 - k;
    double tsv = p->tsv[k] + (p->tsv[k + 1] - p->tsv[k]) * fr;
    double dts = (p->tsv[k + 1] - p->tsv[k]) * 1e3 / (FS_HZ * (1 + DELTA));   /* на отсчёт */
    double tg = p->e->tgd;
    for (int f = 0; f < 2; f++) {
        band_t *b = &p->b[f];
        double g = f ? G12 : 1.0;
        double ts = tsv - g * (p->I1 / CLIGHT + tg);                /* время КА в сигнале */
        double u = ts * 1.023e6;
        b->idx = (int64_t)floor(u);
        b->x = u - (double)b->idx;
        b->dx = dts * 1.023e6;
        /* несущая: опережение фазы в ионосфере постоянно (I не меняется) — в начальной фазе */
        double fc = f ? F2 : F1, flo = f ? FLO2 : FLO1;
        double ph = fc * (tsv - T0) - flo * (1 + DELTA) * (t - T0) + (f ? p->ph2 : p->ph1);
        b->ph = (uint32_t)(int64_t)llround((ph - floor(ph)) * 4294967296.0);
        b->dph = (uint32_t)(int64_t)llround((fc * dts - flo / FS_HZ) * 4294967296.0);
        chip_value(p, f);
    }
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
    double re[2] = {0, 0}, im[2] = {0, 0};
    for (int s = 0; s < NS; s++) {
        sat_t *p = &S[s];
        for (int f = 0; f < 2; f++) {
            band_t *b = &p->b[f];
            re[f] += b->v * SINT[((b->ph >> 22) + 256) & 1023];
            im[f] += b->v * SINT[b->ph >> 22];
            b->ph += b->dph;
            b->x += b->dx;
            if (b->x >= 1.0) { b->x -= 1.0; b->idx++; chip_value(p, f); }
        }
    }
    uint32_t w = 0;
    const int rf[2] = {SIGS[SIG_L1CA].rf, SIGS[SIG_L2CM].rf};
    for (int f = 0; f < 2; f++) {
        double xr = re[f] + GN[xs() & 65535] * 0.70710678, xq = im[f] + GN[xs() & 65535] * 0.70710678;
        w |= (uint32_t)(q2(xr) << 2 | q2(xq)) << (4 * rf[f]);
    }
    return w;
}

int main(void)
{
    NE = rinex_read_nav(RNX, EPH, 8000);
    for (int i = 0; i < 65536; i += 2) {
        double u1 = (xs() + 1.0) / 4294967297.0, u2 = (xs() + 1.0) / 4294967297.0;
        GN[i] = (float)(sqrt(-2 * log(u1)) * cos(2 * GPI * u2));
        GN[i + 1] = (float)(sqrt(-2 * log(u1)) * sin(2 * GPI * u2));
    }
    for (int i = 0; i < 1024; i++) SINT[i] = (float)sin(2 * GPI * (i + 0.5) / 1024);
    double lat = 55.7558 * GPI / 180, lon = 37.6173 * GPI / 180;
    llh2ecef(lat, lon, 150.0, RR);
    F1 = sig_carrier(SIG_L1CA, 0); F2 = sig_carrier(SIG_L2CM, 0); G12 = F1 * F1 / (F2 * F2);
    FLO1 = RF_LO[SIGS[SIG_L1CA].rf]; FLO2 = RF_LO[SIGS[SIG_L2CM].rf];
    double tf = 0;
    for (int i = 0; i < NE; i++) if (EPH[i].sys == SYS_GPS) { tf = EPH[i].toe; break; }
    tf = floor((tf + 1800) / 30.0) * 30.0;
    T0 = tf - 3.0 + 0.075;
    for (int prn = 1; prn <= 32 && NS < MAXS; prn++) {
        const eph_t *e = eph_select(EPH, NE, SYS_GPS, prn, T0);
        if (!e) continue;
        double rs[3], dts;
        eph_satpos(e, T0, rs, &dts, NULL, NULL);
        double d[3] = {rs[0] - RR[0], rs[1] - RR[1], rs[2] - RR[2]}, rho = sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
        double ue = (-sin(lon) * d[0] + cos(lon) * d[1]) / rho;
        double un = (-sin(lat) * cos(lon) * d[0] - sin(lat) * sin(lon) * d[1] + cos(lat) * d[2]) / rho;
        double uu = (cos(lat) * cos(lon) * d[0] + cos(lat) * sin(lon) * d[1] + sin(lat) * d[2]) / rho;
        double el = asin(uu), az = atan2(ue, un);
        if (el < 10 * GPI / 180) continue;
        sat_t *p = &S[NS++];
        p->prn = prn; p->e = e; p->el = el;
        code_gen(SIG_L1CA, prn, p->code1);
        code_gen(SIG_L2CM, prn, p->code2);
        int nk = (int)(DUR * 1000) + 3;
        p->tsv = malloc(sizeof(double) * nk);
        for (int k = 0; k < nk; k++) p->tsv[k] = tsv_at(e, T0 + k * 1e-3);
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
        p->s0 = (long)floor(p->tsv[0] / 0.02) - 10;
        p->ns2 = (long)(DUR / 0.02) + 40;
        p->sym2 = malloc((size_t)p->ns2);
        for (long s = 0; s < p->ns2; s++) p->sym2[s] = xs() & 1;
        /* ионосфера: однослойная модель, точка прокола на 350 км, градиент по азимуту */
        double Re = 6371e3, z = Re * cos(el) / (Re + 350e3);
        double vtec = VTEC * (1 + 0.3 * sin(az));
        p->I1 = 40.3 * vtec * 1e16 / (F1 * F1) / sqrt(1 - z * z);
        p->A1 = sqrt(pow(10, 45.0 / 10) / FS_HZ);
        p->A2 = sqrt(pow(10, 43.5 / 10) / FS_HZ);
        p->ph1 = (xs() % 6283) / 6283.0;
        p->ph2 = (xs() % 6283) / 6283.0;
    }
    printf("Имитатор: КА GPS %d, L1 C/A 45 дБГц + L2C (CM+CL) 43,5 дБГц, ВПЭС %.0f TECU, начало %.3f с недели, "
           "уход ТКГ %+.2f ppm, %.0f с\n", NS, VTEC, T0, DELTA * 1e6, DUR);
    for (int s = 0; s < NS; s++)
        printf("  G%02d: угол места %4.1f°, ионосфера L1 %5.2f м, L2 %5.2f м, TGD %+5.2f нс\n", S[s].prn,
               S[s].el * 180 / GPI, S[s].I1, S[s].I1 * G12, S[s].e->tgd * 1e9);
    corr_sim_init(2);
    corr_init();
    rx_t rx;
    rx_init(&rx);
    rx.pcfg.trop = 0;                                   /* имитатор без тропосферы */
    rx.dual = 1;
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
    printf("Захват L1: найдено %d из %d КА\n", nch, NS);
    int ok = 1, nsol = 0, nfull = 0, nl2 = 0;
    double maxerr = 0, sum_if = 0, sum_l1 = 0, si2 = 0;
    int nie = 0;
    uint64_t next = ((corr_sim_nsmp() / 24000000) + 1) * 24000000ull;
    while (t_true(corr_sim_nsmp()) < T0 + DUR - 0.01) {
        corr_sim_run(4096, src);
        rx_process(&rx, corr_sim_nsmp());
        if (corr_sim_nsmp() < next) continue;
        uint64_t nm = next;
        next += 24000000ull;
        int nl1 = 0;
        nl2 = 0;
        for (int k = 0; k < CORR_MAXCH; k++) if (rx.ch[k].used && rx.ch[k].trk.state == TRK_LOCK) {
            nl1 += rx.ch[k].sig == SIG_L1CA;
            nl2 += rx.ch[k].sig == SIG_L2CM;
        }
        if (!rx_measure(&rx, nm)) {
            printf("  t=%5.1f с: каналов L1 в захвате %d, L2CM %d — решения нет\n", t_true(nm) - T0, nl1, nl2);
            continue;
        }
        nsol++;
        int nif = 0;
        for (int i = 0; i < rx.nobs; i++) nif += rx.obs[i].iono_free;
        double d[3] = {rx.sol.pos[0] - RR[0], rx.sol.pos[1] - RR[1], rx.sol.pos[2] - RR[2]};
        double err = sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
        /* для сравнения: решение только по L1 C/A (без модели ионосферы) */
        obs_t o1[PVT_MAXOBS];
        memcpy(o1, rx.obs, sizeof(obs_t) * (size_t)rx.nobs);
        for (int i = 0; i < rx.nobs; i++) { o1[i].pr = o1[i].pr1; o1[i].iono_free = 0; }
        sol_t s1 = rx.sol;
        double err1 = -1;
        if (pvt_solve(o1, rx.nobs, rx_time(&rx, nm), &rx.pcfg, &s1)) {
            double e1[3] = {s1.pos[0] - RR[0], s1.pos[1] - RR[1], s1.pos[2] - RR[2]};
            err1 = sqrt(e1[0] * e1[0] + e1[1] * e1[1] + e1[2] * e1[2]);
        }
        /* оценка наклонной ионосферной задержки на L1: (P2 − P1)/(γ − 1) − c·TGD */
        double ie = 0;
        int ni = 0;
        for (int i = 0; i < rx.nobs; i++) {
            obs_t *o = &rx.obs[i];
            if (!o->iono_free) continue;
            for (int s = 0; s < NS; s++) if (S[s].prn == o->prn) {
                double est = (o->pr2 - o->pr1) / (G12 - 1) - CLIGHT * o->eph->tgd;
                double de = est - S[s].I1;
                ie += de * de; ni++;
                if (nif == rx.nobs) { si2 += de * de; nie++; }
            }
        }
        printf("  t=%5.1f с: КА %2d (двухчаст. %2d), L2CM в захвате %2d; ошибка коорд.: ИСК %6.2f м, только L1 %6.2f м; "
               "ошибка оценки ионосферы СКО %.2f м, PDOP %.2f\n", t_true(nm) - T0, rx.sol.nsat, nif, nl2, err, err1,
               ni ? sqrt(ie / ni) : 0.0, rx.sol.pdop);
        if (nif == rx.nobs && nif >= 4) {
            nfull++;
            sum_if += err; sum_l1 += err1;
            if (err > maxerr) maxerr = err;
        }
    }
    double rms_i = nie ? sqrt(si2 / nie) : 1e9;
    printf("Решений %d, по ионосферно-свободной комбинации на всех КА %d; средняя ошибка коорд.: ИСК %.2f м, "
           "только L1 %.2f м; макс. (ИСК) %.2f м; СКО оценки ионосферной задержки %.2f м\n", nsol, nfull,
           nfull ? sum_if / nfull : 0.0, nfull ? sum_l1 / nfull : 0.0, maxerr, rms_i);
    if (nfull < 3 || maxerr > 10 || rms_i > 3 || nl2 < NS || sum_if >= sum_l1) ok = 0;
    printf("ИТОГ: %s\n", ok ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    return !ok;
}
