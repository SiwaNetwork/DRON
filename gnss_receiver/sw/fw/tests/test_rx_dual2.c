/* Сквозная проверка двухчастотного режима по всем системам (ПЗ п. 9.1, п. 2; ТЗ п. 5.2.5) на модели
 * ПЛИС: пары GPS L1 C/A + L5, Galileo E1 + E5a, BeiDou B1I + B3I, ГЛОНАСС G1 + G2.
 * Имитатор: видимые КА над Москвой по эфемеридам RINEX (до 5 на систему, угол места > 15°):
 *   ВЧ-канал 0 (1568 МГц) — L1 C/A (45 дБГц, LNAV), E1 (45 дБГц: E1-B с I/NAV и E1-C с CS25),
 *     B1I (45 дБГц, NH20 и D1);
 *   ВЧ-канал 1 (1602 МГц) — G1 C/A (45 дБГц, строки ГЛОНАСС), ВЧ-канал 3 (1246 МГц) — G2 C/A
 *     (43 дБГц, те же строки);
 *   ВЧ-канал 4 (1176,45 МГц) — L5 (I5 и Q5 в квадратуре по 42 дБГц: I5 — псевдослучайные знаки
 *     1 мс вместо NH10 и символов, Q5 — код NH20) и E5a (E5a-I — так же, E5a-Q — CS100);
 *   ВЧ-канал 6 (1268,52 МГц) — B3I (45 дБГц, NH20 и биты D1 — те же, что на B1I).
 * Ионосфера — однослойная модель (350 км), ВПЭС 50 TECU с градиентом ±30 % по азимуту: задержка
 * I·(1575,42/f)². Групповые задержки КА (время в сигнале — Δt − gd): L1 и L5 — TGD (ISC = 0);
 * E1 — BGD(E1,E5b), E5a — BGD(E1,E5b) + (γ − 1)·BGD(E1,E5a); B1I — TGD1, B3I — 0; G1 — 0,
 * G2 — Δτn (в RINEX нет — задано в имитаторе, ±5,6 нс, передаётся в строке 4). Шкалы GST, BDT
 * (−14 с) и ГЛОНАСС (UTC(SU) + 3 ч) совмещены с GPST; уход ТКГ +0,3 ppm; без тропосферы.
 * Параметры Клобучара (заголовок RINEX) заданы в приёмнике до начала (как принятые по LNAV).
 * ПО МК: захват первых частот по снимкам ВЧ-каналов 0 и 1, слежение, навигационные сообщения;
 * каналы вторых частот — по каналам первых без поиска; ионосферно-свободная комбинация с поправкой
 * часов КА на групповую задержку комбинации; решение с часами по системам. Перезапуск канала L5
 * (имитация срыва) после первых решений проверяет поправку начальной фазы кода по модели
 * Клобучара. Отладочный вывод по каналам вторых частот — при переменной окружения DUAL2_DBG.
 * Проверка: все каналы обеих частот в захвате; ошибки координат и времени по комбинации и
 * сравнение с решением по первым частотам; расхождение шкал систем; оценка ионосферы по P2 − P1;
 * поправка gd по каждому КА; решения по каждой системе отдельно. */
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
#include "glonav.h"
#include "pvt.h"
#include "rx.h"

#define RNX "../../sim/data/BRDC00IGS_R_20211700000_01D_MN_subset.rnx"
#define MAXS 20
#define DUR  42.0                    /* с */
#define VTEC 50.0                    /* TECU */

static const int NMAX[SYS_N] = {[SYS_GPS] = 5, [SYS_GLO] = 5, [SYS_GAL] = 5, [SYS_BDS] = 5};
static const char SYSC[SYS_N] = {[SYS_GPS] = 'G', [SYS_GLO] = 'R', [SYS_GAL] = 'E', [SYS_BDS] = 'C'};
static const int SIG1[SYS_N] = {[SYS_GPS] = SIG_L1CA, [SYS_GLO] = SIG_G1CA, [SYS_GAL] = SIG_E1B, [SYS_BDS] = SIG_B1I};
static const int SIG2[SYS_N] = {[SYS_GPS] = SIG_L5Q, [SYS_GLO] = SIG_G2CA, [SYS_GAL] = SIG_E5AQ, [SYS_BDS] = SIG_B3I};
static const int RFS[5] = {0, 1, 3, 4, 6};
/* типы слов I/NAV по страницам подкадра 30 с (номинальная последовательность E1-B) */
static const int WT[15] = {2, 4, 6, 7, 8, 17, 19, 16, 0, 0, 1, 3, 5, 0, 16};
/* параметры Клобучара GPSA, GPSB из заголовка RINEX */
static const double ION[8] = {4.6566e-09, 1.4901e-08, -5.9605e-08, -1.1921e-07,
                              8.1920e+04, 9.8304e+04, -6.5536e+04, -5.2429e+05};

static eph_t EPH[8000];
static int NE;
static double T0, DELTA = 0.3e-6, RR[3], LAT, LON;
static float GN[65536], SINT[1024];
static uint32_t rng = 4244;
static uint32_t xs(void) { rng ^= rng << 13; rng ^= rng >> 17; rng ^= rng << 5; return rng; }

enum { BT_L1CA, BT_E1, BT_B1I, BT_GLO, BT_L5, BT_E5A, BT_B3I };

typedef struct {                     /* сигнал одной частоты */
    int type, sig, rf;
    double rate;                     /* элементов в секунду: чипы (E1 — полу-чипы BOC) */
    double fc, flo;
    double gd, I;                    /* групповая задержка КА, с; ионосферная задержка, м */
    uint8_t code[CODE_MAX_BYTES], code2[CODE_MAX_BYTES];   /* E1-B и E1-C; I и Q (L5, E5a) */
    uint8_t sec[SEC_MAX_LEN];        /* E1-C — CS25; Q5, B1I, B3I — NH20; E5a-Q — CS100 */
    double A, A2, ph0;               /* амплитуды (A2 — квадратурной составляющей) */
    long str_i;                      /* ГЛОНАСС: номер текущей строки и её символы */
    int8_t sym[200];
    /* состояние на текущей миллисекунде */
    int64_t idx;
    double x, dx;
    uint32_t ph, dph;
    float vi, vq;
} band_t;

typedef struct {
    int sys, prn, fcn;
    eph_t e;                         /* эфемериды в разрядности сообщения */
    double *tsv;                     /* время КА (GPST, без групповых задержек) на сетке 1 мс */
    uint8_t *dat;                    /* биты LNAV / символы I/NAV / биты D1, начиная с d0 */
    long d0, nd;
    double I1, el, az;               /* ионосферная задержка на 1575,42 МГц, м */
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

/* групповая задержка сигнала относительно опорной для часов КА в эфемеридах (по ИКД) */
static double gd_true(const eph_t *e, int sig)
{
    double f1 = sig_carrier(SIG_E1B, 0), f5 = sig_carrier(SIG_E5AQ, 0);
    switch (sig) {
    case SIG_L1CA: case SIG_L5Q: case SIG_E1B: case SIG_B1I: return e->tgd;
    case SIG_E5AQ: return e->tgd + (f1 * f1 / (f5 * f5) - 1) * e->tgd2;
    case SIG_G2CA: return e->tgd2;
    default: return 0;
    }
}

static int dat_at(const sat_t *p, long i) { i -= p->d0; return (i >= 0 && i < p->nd) ? p->dat[i] : 0; }

/* псевдослучайный знак на миллисекунде ms (составляющая с данными L5, E5a) */
static int rbit(const sat_t *p, int64_t ms)
{
    uint32_t h = (uint32_t)ms * 2654435761u ^ (uint32_t)(p->prn * 40503 + p->sys * 977);
    h ^= h >> 15; h *= 2246822519u; h ^= h >> 13;
    return (h >> 7) & 1;
}

/* символ ГЛОНАСС на 10-мс интервале k10 (по GPST): строки — по эфемеридам КА */
static int glo_sym(sat_t *p, band_t *b, int64_t k10)
{
    long tod10 = (long)((k10 - 1800 + 1080000) % 8640000);
    long si = tod10 / 200;
    if (si != b->str_i) {
        uint8_t str[GLO_STR_BITS];
        glo_str_encode(&p->e, (int)(si % 15) + 1, floor(tod10 / 3000.0) * 30.0, p->prn, str);
        glo_str_symbols(str, b->sym);
        b->str_i = si;
    }
    return b->sym[tod10 % 200];
}

static void chip_value(sat_t *p, band_t *b)
{
    int64_t j = b->idx;
    switch (b->type) {
    case BT_L1CA: {
        int c = code_bit(b->code, (int)(j % 1023)) ^ dat_at(p, (long)(j / 20460));
        b->vi = (float)(c ? -b->A : b->A);
        break;
    }
    case BT_E1: {
        /* полу-чип j: чип j/2, период кода (символ) — 4092 чипа; поднесущая — +1, затем −1 */
        int64_t ch = j >> 1, per = ch / 4092;
        int c = (int)(ch % 4092);
        int eb = (code_bit(b->code, c) ^ dat_at(p, (long)per)) ? -1 : 1;
        int ec = (code_bit(b->code2, c) ^ b->sec[per % 25]) ? -1 : 1;
        b->vi = (float)(b->A * 0.70710678 * (eb - ec) * ((j & 1) ? -1 : 1));
        break;
    }
    case BT_B1I: case BT_B3I: {
        /* чип по BDT: период кода 1 мс — чип кода NH, бит D1 — 20 мс */
        int L = b->type == BT_B1I ? 2046 : 10230;
        int64_t ms = j / L;
        int c = code_bit(b->code, (int)(j % L)) ^ b->sec[ms % 20] ^ dat_at(p, (long)(ms / 20));
        b->vi = (float)(c ? -b->A : b->A);
        break;
    }
    case BT_GLO: {
        int c = code_bit(b->code, (int)(j % 511));
        b->vi = (float)(b->A * (c ? -1 : 1) * glo_sym(p, b, j / 5110));
        break;
    }
    default: {
        /* L5, E5a: синфазная — с данными, квадратурная — пилот со вторичным кодом */
        int64_t ms = j / 10230;
        int c = (int)(j % 10230), L2 = b->type == BT_L5 ? 20 : 100;
        int ci = code_bit(b->code, c) ^ rbit(p, ms), cq = code_bit(b->code2, c) ^ b->sec[ms % L2];
        b->vi = (float)(ci ? -b->A : b->A);
        b->vq = (float)(cq ? -b->A2 : b->A2);
    }
    }
}

/* время КА в сигнале частоты f (по GPST) на истинный момент t */
static double tsv_sig(const sat_t *p, int f, double t)
{
    double x = (t - T0) * 1e3;
    long k = (long)x;
    return p->tsv[k] + (p->tsv[k + 1] - p->tsv[k]) * (x - k) - p->b[f].gd - p->b[f].I / CLIGHT;
}

/* состояние на отсчёт i (начало миллисекунды k истинного времени) */
static void ms_state(sat_t *p, long k, uint64_t i)
{
    double t = t_true(i), fr = (t - T0) * 1e3 - k;
    double tsv = p->tsv[k] + (p->tsv[k + 1] - p->tsv[k]) * fr;
    double dts = (p->tsv[k + 1] - p->tsv[k]) * 1e3 / (FS_HZ * (1 + DELTA));   /* на отсчёт */
    for (int f = 0; f < 2; f++) {
        band_t *b = &p->b[f];
        double ts = tsv - b->gd - b->I / CLIGHT - (p->sys == SYS_BDS ? GPST_BDT : 0.0);   /* шкала системы */
        double u = ts * b->rate;
        b->idx = (int64_t)floor(u);
        b->x = u - (double)b->idx;
        b->dx = dts * b->rate;
        /* несущая: опережение фазы в ионосфере постоянно — в начальной фазе */
        double ph = b->fc * (tsv - T0) - b->flo * (1 + DELTA) * (t - T0) + b->ph0;
        b->ph = (uint32_t)(int64_t)llround((ph - floor(ph)) * 4294967296.0);
        b->dph = (uint32_t)(int64_t)llround((b->fc * dts - b->flo / FS_HZ) * 4294967296.0);
        chip_value(p, b);
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
    double re[NRF] = {0}, im[NRF] = {0};
    for (int s = 0; s < NS; s++)
        for (int f = 0; f < 2; f++) {
            band_t *b = &S[s].b[f];
            float cs = SINT[((b->ph >> 22) + 256) & 1023], sn = SINT[b->ph >> 22];
            re[b->rf] += b->vi * cs - b->vq * sn;
            im[b->rf] += b->vi * sn + b->vq * cs;
            b->ph += b->dph;
            b->x += b->dx;
            if (b->x >= 1.0) { b->x -= 1.0; b->idx++; chip_value(&S[s], b); }
        }
    uint32_t w = 0;
    for (int r = 0; r < 5; r++) {
        int rf = RFS[r];
        double xr = re[rf] + GN[xs() & 65535] * 0.70710678, xq = im[rf] + GN[xs() & 65535] * 0.70710678;
        w |= (uint32_t)(q2(xr) << 2 | q2(xq)) << (4 * rf);
    }
    return w;
}

/* угол места и азимут КА в момент t */
static double elev(const eph_t *e, double t, double *az)
{
    double rs[3], dts;
    eph_satpos(e, t, rs, &dts, NULL, NULL);
    double d[3] = {rs[0] - RR[0], rs[1] - RR[1], rs[2] - RR[2]}, rho = sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
    double ue = (-sin(LON) * d[0] + cos(LON) * d[1]) / rho;
    double un = (-sin(LAT) * cos(LON) * d[0] - sin(LAT) * sin(LON) * d[1] + cos(LAT) * d[2]) / rho;
    double uu = (cos(LAT) * cos(LON) * d[0] + cos(LAT) * sin(LON) * d[1] + sin(LAT) * d[2]) / rho;
    if (az) *az = atan2(ue, un);
    return asin(uu);
}

/* данные навигационного сообщения на интервале имитации (ГЛОНАСС — строки по ходу имитации) */
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
        long pg0 = (long)floor(ts0 / 2.0), pg1 = (long)floor(ts1 / 2.0) + 1;
        p->d0 = pg0 * 500;
        p->nd = (pg1 - pg0) * 500;
        p->dat = malloc((size_t)p->nd);
        for (long g = pg0; g < pg1; g++) {
            int tow = (int)((2 * g) % 604800);
            inav_encode_page(&p->e, WT[(tow % 30) / 2], tow, p->e.week, p->dat + (g - pg0) * 500);
        }
    } else if (p->sys == SYS_BDS) {
        long sf0 = (long)floor((ts0 - GPST_BDT) / 6.0), sf1 = (long)floor((ts1 - GPST_BDT) / 6.0) + 1;
        p->d0 = sf0 * 300;
        p->nd = (sf1 - sf0) * 300;
        p->dat = malloc((size_t)p->nd);
        for (long s = sf0; s < sf1; s++)
            bdsnav_encode(&p->e, (int)(s % 5) + 1, (int)((6 * s) % 604800), p->dat + (s - sf0) * 300);
    }
}

static void band_init(sat_t *p, int f, int sig)
{
    band_t *b = &p->b[f];
    double fl1 = sig_carrier(SIG_L1CA, 0), a45 = sqrt(pow(10, 45.0 / 10) / FS_HZ);
    double a42 = sqrt(pow(10, 42.0 / 10) / FS_HZ), a43 = sqrt(pow(10, 43.0 / 10) / FS_HZ);
    b->sig = sig;
    b->rf = SIGS[sig].rf;
    b->fc = sig_carrier(sig, p->fcn);
    b->flo = RF_LO[b->rf];
    b->I = p->I1 * fl1 * fl1 / (b->fc * b->fc);
    b->gd = gd_true(&p->e, sig);
    b->str_i = -1;
    b->ph0 = (xs() % 6283) / 6283.0;
    b->A = a45;
    switch (sig) {
    case SIG_L1CA: b->type = BT_L1CA; b->rate = 1.023e6; code_gen(sig, p->prn, b->code); break;
    case SIG_E1B:
        b->type = BT_E1; b->rate = 2.046e6;
        code_gen(SIG_E1B, p->prn, b->code); code_gen(SIG_E1C, p->prn, b->code2); sec_code(SIG_E1C, p->prn, b->sec);
        break;
    case SIG_B1I: b->type = BT_B1I; b->rate = 2.046e6; code_gen(sig, p->prn, b->code); sec_code(sig, p->prn, b->sec); break;
    case SIG_B3I: b->type = BT_B3I; b->rate = 10.23e6; code_gen(sig, p->prn, b->code); sec_code(sig, p->prn, b->sec); break;
    case SIG_G1CA: case SIG_G2CA:
        b->type = BT_GLO; b->rate = 0.511e6; code_gen(sig, 1, b->code);
        if (sig == SIG_G2CA) b->A = a43;
        break;
    case SIG_L5Q:
        b->type = BT_L5; b->rate = 10.23e6; b->A = b->A2 = a42;
        code_gen(SIG_L5I, p->prn, b->code); code_gen(SIG_L5Q, p->prn, b->code2); sec_code(SIG_L5Q, p->prn, b->sec);
        break;
    case SIG_E5AQ:
        b->type = BT_E5A; b->rate = 10.23e6; b->A = b->A2 = a42;
        code_gen(SIG_E5AI, p->prn, b->code); code_gen(SIG_E5AQ, p->prn, b->code2); sec_code(SIG_E5AQ, p->prn, b->sec);
        break;
    }
}

typedef struct { const eph_t *e; double el; } cand_t;
static int cmp_el(const void *a, const void *b)
{
    double d = ((const cand_t *)b)->el - ((const cand_t *)a)->el;
    return d > 0 ? 1 : d < 0 ? -1 : 0;
}

static void add_sys(int sys, int q0, int q1)
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
        p->sys = sys; p->prn = c[i].e->prn; p->e = *c[i].e;
        p->fcn = sys == SYS_GLO ? p->e.fcn : 0;
        /* групповые задержки — в разрядности сообщений */
        if (sys == SYS_GPS) {
            p->e.tgd = round(ldexp(p->e.tgd, 31)) * ldexp(1, -31);
        } else if (sys == SYS_GAL) {
            p->e.iode &= 0x3FF;
            p->e.sva &= 0xFF;
            p->e.svh &= 0x1C7;
            p->e.tgd = round(ldexp(p->e.tgd, 32)) * ldexp(1, -32);
            p->e.tgd2 = round(ldexp(p->e.tgd2, 32)) * ldexp(1, -32);
        } else if (sys == SYS_BDS) {
            p->e.iode &= 31;
            p->e.iodc &= 31;
            p->e.sva &= 15;
            p->e.svh &= 1;
            p->e.tgd = round(p->e.tgd / 0.1e-9) * 0.1e-9;
            p->e.tgd2 = round(p->e.tgd2 / 0.1e-9) * 0.1e-9;
        } else {
            p->e.tgd2 = ldexp((p->prn % 7) - 3, -29);       /* Δτn */
        }
        p->el = elev(&p->e, T0, &p->az);
        /* ионосфера: однослойная модель, точка прокола на 350 км, градиент по азимуту */
        double Re = 6371e3, z = Re * cos(p->el) / (Re + 350e3), fl1 = sig_carrier(SIG_L1CA, 0);
        double vtec = VTEC * (1 + 0.3 * sin(p->az));
        p->I1 = 40.3 * vtec * 1e16 / (fl1 * fl1) / sqrt(1 - z * z);
        int nk = (int)(DUR * 1000) + 3;
        p->tsv = malloc(sizeof(double) * nk);
        for (int k = 0; k < nk; k++) p->tsv[k] = tsv_at(&p->e, T0 + k * 1e-3);
        make_data(p, nk);
        band_init(p, 0, SIG1[sys]);
        band_init(p, 1, SIG2[sys]);
    }
}

static double dist(const double *a, const double *b)
{
    return sqrt((a[0] - b[0]) * (a[0] - b[0]) + (a[1] - b[1]) * (a[1] - b[1]) + (a[2] - b[2]) * (a[2] - b[2]));
}

/* КА имитатора по каналу первой частоты (ГЛОНАСС — по литере) */
static sat_t *sat_of(const rx_ch_t *c)
{
    int sys = SIGS[c->sig].sys;
    for (int s = 0; s < NS; s++)
        if (S[s].sys == sys && (sys == SYS_GLO ? S[s].fcn == c->fcn : S[s].prn == c->prn)) return &S[s];
    return NULL;
}

static sat_t *sat_obs(const obs_t *o)
{
    for (int s = 0; s < NS; s++) if (S[s].sys == o->sys && S[s].prn == o->prn) return &S[s];
    return NULL;
}

static double gamma_of(const sat_t *p) { return p->b[0].fc * p->b[0].fc / (p->b[1].fc * p->b[1].fc); }

/* групповая задержка ионосферно-свободной комбинации (истинная) */
static double gd_if(const sat_t *p)
{
    double g = gamma_of(p);
    return (g * p->b[0].gd - p->b[1].gd) / (g - 1);
}

/* ошибка фазы кода канала второй частоты на отсчёт n, чипы */
static double code_err(const rx_ch_t *c, const sat_t *p, uint64_t n)
{
    const sig_info_t *si = &SIGS[c->sig];
    double cp, L = si->code_len;
    corr_phase_at(c->ch, n, &cp, NULL);
    double ts = tsv_sig(p, 1, t_true(n)) - (p->sys == SYS_BDS ? GPST_BDT : 0.0);
    double de = cp - fmod(ts * si->chip_rate, L);
    if (de > L / 2) de -= L;
    if (de < -L / 2) de += L;
    return de;
}

/* решение только по КА системы sys (≥ 4 КА); ошибка координат, времени */
static int solve_sys(const rx_t *rx, uint64_t nm, int sys, double *err, double *terr, int *n)
{
    obs_t o[PVT_MAXOBS];
    *n = 0;
    for (int i = 0; i < rx->nobs; i++) if (rx->obs[i].sys == sys && rx->obs[i].iono_free) o[(*n)++] = rx->obs[i];
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
    setvbuf(stdout, NULL, _IONBF, 0);
    NE = rinex_read_nav(RNX, EPH, 8000);
    for (int i = 0; i < 65536; i += 2) {
        double u1 = (xs() + 1.0) / 4294967297.0, u2 = (xs() + 1.0) / 4294967297.0;
        GN[i] = (float)(sqrt(-2 * log(u1)) * cos(2 * GPI * u2));
        GN[i + 1] = (float)(sqrt(-2 * log(u1)) * sin(2 * GPI * u2));
    }
    for (int i = 0; i < 1024; i++) SINT[i] = (float)sin(2 * GPI * (i + 0.5) / 1024);
    LAT = 55.7558 * GPI / 180; LON = 37.6173 * GPI / 180;
    llh2ecef(LAT, LON, 150.0, RR);
    double tf = 0;
    for (int i = 0; i < NE; i++) if (EPH[i].sys == SYS_GPS) { tf = EPH[i].toe; break; }
    tf = floor((tf + 1800) / 30.0) * 30.0;
    /* начало — за 3 с до кадра GPS и подкадра I/NAV (кадр ГЛОНАСС — через 18 с, D1 — через 14 с) */
    T0 = tf - 3.0 + 0.075;
    add_sys(SYS_GPS, 1, 32);
    add_sys(SYS_GLO, 1, 24);
    add_sys(SYS_GAL, 1, 36);
    add_sys(SYS_BDS, 6, 58);
    int nsys[SYS_N] = {0};
    for (int s = 0; s < NS; s++) nsys[S[s].sys]++;
    printf("Имитатор: КА GPS %d, ГЛОНАСС %d, Galileo %d, BeiDou %d; пары L1 C/A + L5, G1 + G2, E1 + E5a, B1I + B3I; "
           "ВПЭС %.0f TECU, начало %.3f с недели, уход ТКГ %+.2f ppm, %.0f с\n", nsys[SYS_GPS], nsys[SYS_GLO],
           nsys[SYS_GAL], nsys[SYS_BDS], VTEC, T0, DELTA * 1e6, DUR);
    for (int s = 0; s < NS; s++) {
        const sat_t *p = &S[s];
        double dch = (p->b[1].I - p->b[0].I + CLIGHT * (p->b[1].gd - p->b[0].gd)) / CLIGHT * SIGS[p->b[1].sig].chip_rate;
        printf("  %c%02d", SYSC[p->sys], p->prn);
        if (p->sys == SYS_GLO) printf("(%+d)", p->fcn); else printf("    ");
        printf(": угол места %4.1f°, ионосфера %s %5.2f м, %s %5.2f м (разность %.2f чипа %s); gd %+6.2f / %+6.2f нс\n",
               p->el * 180 / GPI, SIGS[p->b[0].sig].id, p->b[0].I, SIGS[p->b[1].sig].id, p->b[1].I, dch,
               SIGS[p->b[1].sig].id, p->b[0].gd * 1e9, p->b[1].gd * 1e9);
    }
    corr_sim_init(4);
    corr_init();
    rx_t rx;
    rx_init(&rx);
    rx.pcfg.trop = 0;                                   /* имитатор без тропосферы */
    rx.dual = 1;
    rx.sig2[SYS_GPS] = SIG_L5Q;
    memcpy(rx.ion, ION, sizeof(ION));
    rx.ion_ok = 1;
    /* снимки ВЧ-каналов 0 (L1, E1, B1I) и 1 (G1) и захват */
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
    const int sigs[4] = {SIG_L1CA, SIG_E1B, SIG_B1I, SIG_G1CA};
    int nmiss[4] = {0};
    for (int g = 0; g < 4; g++) {
        int r = sigs[g] == SIG_G1CA;
        int nch = rx_acquire(&rx, xsn[r], t0s[r], NSNAP, len, sigs[g], t_start, &ac);
        int sys = SIGS[sigs[g]].sys, nhit = 0;
        for (int k = 0; k < CORR_MAXCH; k++) if (rx.ch[k].used && rx.ch[k].sig == sigs[g]) nhit += sat_of(&rx.ch[k]) != NULL;
        nmiss[g] = nsys[sys] - nhit;
        printf("Захват %s: каналов %d, из них КА имитатора %d из %d\n", SIGS[sigs[g]].id, nch, nhit, nsys[sys]);
    }
    /* повторный поиск по новым снимкам (как периодический поиск в приёмнике): E1-B обнаруживается по
     * половине периода кода 4 мс и при пороговом накоплении может быть пропущен */
    for (int g = 0, rep = 0; g < 4; g++, rep = 0)
        while (nmiss[g] > 0 && rep++ < 2) {
            int r = sigs[g] == SIG_G1CA, sys = SIGS[sigs[g]].sys, nhit = 0;
            for (int s = 0; s < NSNAP; s++) {           /* каналы в слежении — без пропуска сбросов */
                acq_snap_start(r, len, 0);
                for (int m = 0; m < 14; m++) { corr_sim_run(4096, src); rx_process(&rx, corr_sim_nsmp()); }
                acq_snap_read(len, x4[r][s], &t0s[r][s]);
            }
            uint64_t ts = (corr_sim_nsmp() + 24000) & ~3ull;
            int nch = rx_acquire(&rx, xsn[r], t0s[r], NSNAP, len, sigs[g], ts, &ac);
            for (int k = 0; k < CORR_MAXCH; k++) if (rx.ch[k].used && rx.ch[k].sig == sigs[g]) nhit += sat_of(&rx.ch[k]) != NULL;
            nmiss[g] = nsys[sys] - nhit;
            printf("Повторный захват %s: каналов %d, КА имитатора %d из %d\n", SIGS[sigs[g]].id, nch, nhit, nsys[sys]);
        }
    int ok = 1, nsol = 0, nfull = 0, ngd_bad = 0, nsys_sol[SYS_N] = {0};
    double sum_if = 0, sum_1 = 0, maxerr = 0, maxterr = 0, maxdclk[SYS_N] = {0}, si2[2] = {0}, maxe_sys[SYS_N] = {0};
    double laste_sys[SYS_N] = {0};
    int nie[2] = {0};
    /* перезапуск канала L5 (имитация срыва): КА, канал первой частоты, начальная ошибка кода */
    int rs_state = 0, rs_k1 = -1, rs_relock = 0;
    double rs_err = NAN, rs_exp = NAN, rs_diff = NAN, rs_t0 = 0, rs_tlock = -1;
    sat_t *rs_p = NULL;
    uint64_t next = ((corr_sim_nsmp() / 24000000) + 1) * 24000000ull;
    while (t_true(corr_sim_nsmp()) < T0 + DUR - 0.01) {
        corr_sim_run(4096, src);
        rx_process(&rx, corr_sim_nsmp());
        if (rs_state == 1 && rx.ch[rs_k1].pair) {
            /* перезапущен: начальная фаза кода — до первого интервала */
            const rx_ch_t *c2 = &rx.ch[rx.ch[rs_k1].pair - 1];
            rs_err = code_err(c2, rs_p, CORR[c2->ch].t_ref);
            rs_state = 2;
        }
        if (rs_state == 2 && rx.ch[rs_k1].pair && rx.ch[rx.ch[rs_k1].pair - 1].trk.state == TRK_LOCK) {
            rs_tlock = t_true(corr_sim_nsmp()) - rs_t0;
            rs_relock = 1;
            rs_state = 3;
        }
        if (corr_sim_nsmp() < next) continue;
        uint64_t nm = next;
        next += 24000000ull;
        int nl[2][SYS_N] = {{0}};
        for (int k = 0; k < CORR_MAXCH; k++) if (rx.ch[k].used && rx.ch[k].trk.state == TRK_LOCK) {
            const rx_ch_t *c = &rx.ch[k];
            nl[c->f2][SIGS[c->sig].sys]++;
        }
        if (getenv("DUAL2_DBG"))
            for (int k = 0; k < CORR_MAXCH; k++) if (rx.ch[k].used && rx.ch[k].f2 && rx.ch[k].pair) {
                const rx_ch_t *c = &rx.ch[k];
                sat_t *p = sat_of(&rx.ch[c->pair - 1]);
                if (!p) continue;
                printf("    %s %c%02d: сост. %d, t %.2f, lock %.2f, C/N0 %.1f, втор. код %d, ошибка кода %+.3f чипа\n",
                       SIGS[c->sig].id, SYSC[p->sys], p->prn, c->trk.state, c->trk.t, c->trk.lock, c->trk.cn0,
                       c->trk.sec_sync, code_err(c, p, nm));
            }
        if (!rx_measure(&rx, nm)) {
            printf("  t=%5.1f с: в захвате G %d/%d, R %d/%d, E %d/%d, C %d/%d — решения нет\n", t_true(nm) - T0,
                   nl[0][SYS_GPS], nl[1][SYS_GPS], nl[0][SYS_GLO], nl[1][SYS_GLO], nl[0][SYS_GAL], nl[1][SYS_GAL],
                   nl[0][SYS_BDS], nl[1][SYS_BDS]);
            continue;
        }
        nsol++;
        int nu[SYS_N] = {0}, nif = 0;
        for (int i = 0; i < rx.nobs; i++) { nu[rx.obs[i].sys]++; nif += rx.obs[i].iono_free; }
        double err = dist(rx.sol.pos, RR), terr = rx.sol.t_rx - t_true(nm);
        /* шкалы систем совмещены в имитаторе: смещения часов по системам должны совпасть */
        double dclk = 0, dclk_s[SYS_N] = {0};
        for (int s = SYS_GLO; s <= SYS_BDS; s++)
            if (nu[s] && nu[SYS_GPS]) {
                dclk_s[s] = rx.sol.clk[s] - rx.sol.clk[SYS_GPS];
                if (fabs(dclk_s[s]) > fabs(dclk)) dclk = dclk_s[s];
            }
        /* для сравнения: решение только по первым частотам (с моделью Клобучара) */
        obs_t o1[PVT_MAXOBS];
        memcpy(o1, rx.obs, sizeof(obs_t) * (size_t)rx.nobs);
        for (int i = 0; i < rx.nobs; i++) { o1[i].pr = o1[i].pr1; o1[i].iono_free = 0; }
        sol_t s1 = rx.sol;
        double err1 = pvt_solve(o1, rx.nobs, rx_time(&rx, nm), &rx.pcfg, &s1) ? dist(s1.pos, RR) : -1;
        /* оценка ионосферной задержки на первой частоте: (P2 − P1 − c·(gd2 − gd1))/(γ − 1); поправка
         * часов КА комбинации — с истинной */
        double ie = 0;
        int ni = 0;
        for (int i = 0; i < rx.nobs; i++) {
            const obs_t *o = &rx.obs[i];
            const sat_t *p = sat_obs(o);
            if (!o->iono_free || !p) continue;
            double est = (o->pr2 - o->pr1 - CLIGHT * (p->b[1].gd - p->b[0].gd)) / (gamma_of(p) - 1);
            double de = est - p->b[0].I;
            ie += de * de; ni++;
            if (nif == NS && rx.nobs == NS) { si2[p->sys == SYS_GLO] += de * de; nie[p->sys == SYS_GLO]++; }
            if (fabs(o->gd - gd_if(p)) > 1e-11) {
                if (ngd_bad < 10) printf("  ОШИБКА gd %c%02d: %.3f нс, ожидалось %.3f нс\n", SYSC[p->sys], p->prn,
                                         o->gd * 1e9, gd_if(p) * 1e9);
                ngd_bad++;
            }
        }
        printf("  t=%5.1f с: КА G %d, R %d, E %d, C %d (двухчаст. %d); ошибка коорд.: ИСК %6.2f м, первые частоты "
               "%6.2f м; времени %+6.1f нс; шкалы %+6.2f м; ионосфера СКО %.2f м; PDOP %.2f", t_true(nm) - T0,
               nu[SYS_GPS], nu[SYS_GLO], nu[SYS_GAL], nu[SYS_BDS], nif, err, err1, terr * 1e9, dclk,
               ni ? sqrt(ie / ni) : 0.0, rx.sol.pdop);
        if (nif == NS && rx.nobs == NS) {
            nfull++;
            sum_if += err; sum_1 += err1;
            if (err > maxerr) maxerr = err;
            if (fabs(terr) > maxterr) maxterr = fabs(terr);
            for (int s = SYS_GLO; s <= SYS_BDS; s++) if (fabs(dclk_s[s]) > maxdclk[s]) maxdclk[s] = fabs(dclk_s[s]);
        }
        for (int s = SYS_GPS; s <= SYS_BDS; s++) {
            double e1, t1;
            int n1;
            if (!solve_sys(&rx, nm, s, &e1, &t1, &n1)) continue;
            nsys_sol[s]++;
            printf("; %c (%d): %.1f м", SYSC[s], n1, e1);
            if (e1 > maxe_sys[s]) maxe_sys[s] = e1;
            laste_sys[s] = e1;
        }
        printf("\n");
        /* перезапуск канала L5 КА GPS с наименьшим углом места — после второго решения */
        if (rs_state == 0 && nsol >= 2) {
            for (int k = 0; k < CORR_MAXCH; k++) {
                rx_ch_t *c = &rx.ch[k];
                sat_t *p = c->used && !c->f2 && c->sig == SIG_L1CA && c->pair ? sat_of(c) : NULL;
                if (p && (!rs_p || p->el < rs_p->el)) { rs_p = p; rs_k1 = k; }
            }
            if (rs_p) {
                rx.ch[rx.ch[rs_k1].pair - 1].trk.state = TRK_IDLE;
                double g = gamma_of(rs_p), r2 = SIGS[SIG_L5Q].chip_rate;
                rs_diff = (rs_p->b[1].I - rs_p->b[0].I + CLIGHT * (rs_p->b[1].gd - rs_p->b[0].gd)) / CLIGHT * r2;
                double az, el = elev(&rs_p->e, t_true(nm), &az);
                rs_exp = rs_diff - (g - 1) * pvt_klobuchar(ION, t_true(nm), LAT, LON, az, el) / CLIGHT * r2;
                rs_t0 = t_true(nm);
                rs_state = 1;
                printf("  перезапуск канала L5Q G%02d (угол места %.1f°)\n", rs_p->prn, el * 180 / GPI);
            }
        }
    }
    /* итог по КА: состояние каналов, ионосфера, ошибки ПД относительно истинного времени КА в сигнале
     * (общая ошибка шкалы приёмника исключена по среднему ИСК), поправка gd */
    double m = 0;
    int nmn = 0, nlock1 = 0, nlock2 = 0, neph = 0;
    double tr = rx_time(&rx, rx.sol_n), tt = t_true(rx.sol_n);
    for (int i = 0; i < rx.nobs; i++) {
        const sat_t *p = sat_obs(&rx.obs[i]);
        if (!p || !rx.obs[i].iono_free) continue;
        double tif = tsv_sig(p, 0, tt) + p->b[0].gd + p->b[0].I / CLIGHT - gd_if(p);
        m += rx.obs[i].pr - CLIGHT * (tr - tif);
        nmn++;
    }
    m = nmn ? m / nmn : 0;
    for (int s = 0; s < NS; s++) {
        sat_t *p = &S[s];
        const rx_ch_t *c1 = NULL, *c2 = NULL;
        for (int k = 0; k < CORR_MAXCH; k++)
            if (rx.ch[k].used && !rx.ch[k].f2 && sat_of(&rx.ch[k]) == p) c1 = &rx.ch[k];
        if (c1 && c1->pair) c2 = &rx.ch[c1->pair - 1];
        int l1 = c1 && c1->trk.state == TRK_LOCK, l2 = c2 && c2->trk.state == TRK_LOCK;
        nlock1 += l1; nlock2 += l2;
        neph += rx_eph(&rx, p->sys, p->prn)->valid;
        printf("  %c%02d: %s %s (%.1f дБГц), %s %s (%.1f дБГц)", SYSC[p->sys], p->prn, SIGS[p->b[0].sig].id,
               l1 ? "захват" : "НЕТ", c1 ? c1->trk.cn0 : 0.0, SIGS[p->b[1].sig].id, l2 ? "захват" : "НЕТ",
               c2 ? c2->trk.cn0 : 0.0);
        for (int i = 0; i < rx.nobs; i++) {
            const obs_t *o = &rx.obs[i];
            if (o->sys != p->sys || o->prn != p->prn || !o->iono_free) continue;
            double tif = tsv_sig(p, 0, tt) + p->b[0].gd + p->b[0].I / CLIGHT - gd_if(p);
            double est = (o->pr2 - o->pr1 - CLIGHT * (p->b[1].gd - p->b[0].gd)) / (gamma_of(p) - 1);
            printf("; ионосфера %.2f м, оценка %.2f м; ошибка P1 %+.2f, P2 %+.2f, ИСК %+.2f м; gd %+.2f нс",
                   p->b[0].I, est, o->pr1 - CLIGHT * (tr - tsv_sig(p, 0, tt)) - m,
                   o->pr2 - CLIGHT * (tr - tsv_sig(p, 1, tt)) - m, o->pr - CLIGHT * (tr - tif) - m,
                   o->gd * 1e9);
        }
        printf("\n");
    }
    double rms_i = nie[0] ? sqrt(si2[0] / nie[0]) : 1e9, rms_ig = nie[1] ? sqrt(si2[1] / nie[1]) : 1e9;
    printf("Решений %d, по комбинации на всех %d КА %d: средняя ошибка коорд.: ИСК %.2f м, первые частоты %.2f м; "
           "макс. (ИСК) %.2f м, времени %.1f нс; макс. расхождение шкал R %.2f, E %.2f, C %.2f м; СКО оценки "
           "ионосферы: L5, E5a, B3I %.2f м, G2 %.2f м\n", nsol, NS, nfull, nfull ? sum_if / nfull : 0.0,
           nfull ? sum_1 / nfull : 0.0, maxerr, maxterr * 1e9, maxdclk[SYS_GLO], maxdclk[SYS_GAL], maxdclk[SYS_BDS],
           rms_i, rms_ig);
    printf("Решения по одной системе (ИСК): G %d (макс. %.1f м, посл. %.1f м), R %d (%.1f, %.1f м), E %d (%.1f, "
           "%.1f м), C %d (%.1f, %.1f м)\n", nsys_sol[SYS_GPS], maxe_sys[SYS_GPS], laste_sys[SYS_GPS],
           nsys_sol[SYS_GLO], maxe_sys[SYS_GLO], laste_sys[SYS_GLO], nsys_sol[SYS_GAL], maxe_sys[SYS_GAL],
           laste_sys[SYS_GAL], nsys_sol[SYS_BDS], maxe_sys[SYS_BDS], laste_sys[SYS_BDS]);
    printf("Перезапуск L5Q: начальная ошибка кода %+.3f чипа (ожидалось %+.3f, без поправки %+.3f), захват через "
           "%.2f с; ошибок gd %d; каналы в захвате %d/%d из %d, эфемериды %d\n", rs_err, rs_exp, rs_diff, rs_tlock,
           ngd_bad, nlock1, nlock2, NS, neph);
    /* критерии: все каналы обеих частот в захвате, эфемериды приняты; не менее 3 решений по комбинации
     * на всех КА — средняя ошибка ≤ 3 м и меньше, чем по первым частотам, макс. ≤ 6 м, времени ≤ 20 нс;
     * расхождение шкал Galileo, BeiDou с GPS ≤ 3 м, ГЛОНАСС ≤ 6 м (чип G2 — 587 м); СКО оценки ионосферы
     * по парам с L5, E5a, B3I ≤ 1 м, G1/G2 ≤ 4 м; поправка gd верна по всем КА; решения по одной системе:
     * GPS, Galileo, BeiDou — ошибка ≤ 15 м во всех эпохах, ГЛОНАСС — в последней (код сглажен
     * за ≈ 20 с) ≤ 15 м; перезапуск: начальная фаза — с поправкой по модели Клобучара
     * (±0,05 чипа), повторный захват */
    if (nlock1 < NS || nlock2 < NS || neph < NS || nfull < 3 || sum_if / nfull > 3 || sum_if >= sum_1 ||
        maxerr > 6 || maxterr > 20e-9 || maxdclk[SYS_GAL] > 3 || maxdclk[SYS_BDS] > 3 || maxdclk[SYS_GLO] > 6 ||
        rms_i > 1 || rms_ig > 4 || ngd_bad) ok = 0;
    for (int s = SYS_GPS; s <= SYS_BDS; s++)
        if (!nsys_sol[s] || (s == SYS_GLO ? laste_sys[s] : maxe_sys[s]) > 15) ok = 0;
    if (!rs_relock || !(fabs(rs_err - rs_exp) <= 0.05)) ok = 0;
    printf("ИТОГ: %s\n", ok ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    return !ok;
}
