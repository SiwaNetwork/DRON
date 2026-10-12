/* Сквозная проверка ПО МК на модели ПЛИС: GPS L1 C/A, 5 спутников (C/N0 38–48 дБГц), данные 50 бит/с.
 * Снимок отсчётов -> захват (БПФ) -> одновременный пуск каналов -> слежение 1 с ->
 * проверка: захват фазы, ошибки доплера и фазы кода (по зеркалу NCO), C/N0, синхронизация и биты. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "gnss.h"
#include "codes.h"
#include "fpga.h"
#include "corr.h"
#include "corr_sim.h"
#include "acq.h"
#include "track.h"

#define NSAT 5
static const int    PRN[NSAT]  = {3, 7, 12, 19, 25};
static const double CN0[NSAT]  = {48, 45, 42, 40, 38};
static const double DOP[NSAT]  = {-2100, 1250, 3300, -450, 800};
static double CP0[NSAT], PH0[NSAT], A[NSAT];
static uint8_t CODE[NSAT][CODE_MAX_BYTES];
static uint8_t BITS[NSAT][128];
static float GN[65536];
static uint32_t rng = 12345;

static uint32_t xs(void) { rng ^= rng << 13; rng ^= rng >> 17; rng ^= rng << 5; return rng; }

static double code_phase_true(int k, double t)   /* чипы (без свёртки), t — с от отсчёта 0 */
{
    return CP0[k] + 1.023e6 * (1 + DOP[k] / (154 * 10.23e6)) * t;
}

static int q2(double v, double thr) { return (v < 0 ? 2 : 0) | (fabs(v) > thr ? 1 : 0); }

static uint32_t src(uint64_t i)
{
    double t = (double)i / FS_HZ, re = 0, im = 0;
    double fif = sig_if(SIG_L1CA, 0);
    for (int k = 0; k < NSAT; k++) {
        double cp = code_phase_true(k, t);
        long ci = (long)floor(cp);
        int c = code_bit(CODE[k], (int)(ci % 1023)) ? -1 : 1;
        int b = (BITS[k][(ci / 1023 / 20) % 128]) ? -1 : 1;
        double th = PH0[k] + 2 * GPI * (fif + DOP[k]) * t;
        re += A[k] * c * b * cos(th);
        im += A[k] * c * b * sin(th);
    }
    re += GN[xs() & 65535] * 0.70710678;
    im += GN[xs() & 65535] * 0.70710678;
    uint32_t nib = (uint32_t)(q2(re, 0.70710678) << 2 | q2(im, 0.70710678));
    uint32_t w = nib;
    for (int r = 1; r < 8; r++) w |= (uint32_t)(q2(GN[xs() & 65535] * 0.7071, 0.7071) << 2 | q2(GN[xs() & 65535] * 0.7071, 0.7071)) << (4 * r);
    return w;
}

typedef struct { int k; int nbits; int nok; int ninv; int first; int prev; int flips; } bitlog_t;
static bitlog_t BL[NSAT];
static void on_bit(void *ctx, int bit, uint64_t n_end)
{
    bitlog_t *b = ctx;
    /* номер бита по истинной фазе кода в конце бита */
    double cp = code_phase_true(b->k, (double)n_end / FS_HZ);
    long ib = (long)floor((cp - 0.5) / 1023 / 20);
    int truth = BITS[b->k][ib % 128];
    if (!b->first) { b->first = 1; return; }      /* первый бит после синхронизации пропускаем */
    b->nbits++;
    int m = truth == bit;
    if (m) b->nok++; else b->ninv++;
    if (b->nbits > 1 && m != b->prev) { b->flips++; if (getenv("BITDBG")) printf("    PRN %d смена полярности на бите %d (t=%.3f)\n", PRN[b->k], b->nbits, (double)n_end / FS_HZ); }
    b->prev = m;
}

int main(void)
{
    for (int i = 0; i < 65536; i += 2) {          /* гауссовы отсчёты (Бокс — Мюллер) */
        double u1 = (xs() + 1.0) / 4294967297.0, u2 = (xs() + 1.0) / 4294967297.0;
        GN[i] = (float)(sqrt(-2 * log(u1)) * cos(2 * GPI * u2));
        GN[i + 1] = (float)(sqrt(-2 * log(u1)) * sin(2 * GPI * u2));
    }
    for (int k = 0; k < NSAT; k++) {
        code_gen(SIG_L1CA, PRN[k], CODE[k]);
        CP0[k] = (xs() % 102300) / 100.0;
        PH0[k] = (xs() % 6283) / 1000.0;
        A[k] = sqrt(pow(10, CN0[k] / 10) / FS_HZ);
        for (int j = 0; j < 128; j++) BITS[k][j] = xs() & 1;
    }
    corr_sim_init(1);
    if (corr_init() != 16) { printf("ПЛИС не найдена\n"); return 1; }
    /* 6 снимков по 2 мс (некогерентное накопление 12 мс) */
    corr_sim_run(1000, src);
    enum { NSNAP = 6 };
    static uint8_t x4[NSNAP][65536];
    const uint8_t *xs[NSNAP];
    uint32_t t0[NSNAP];
    int len = 49152;
    for (int s = 0; s < NSNAP; s++) {
        acq_snap_start(0, len, 0);
        corr_sim_run((uint64_t)len + 16, src);
        if (!acq_snap_read(len, x4[s], &t0[s])) { printf("снимок не готов\n"); return 1; }
        xs[s] = x4[s];
        corr_sim_run(12000, src);                     /* обработка снимка в МК */
    }
    acq_cfg_t ac = {.dop_max = 5000, .dop_step = 250, .nper = 2, .thresh = 2.0};
    int nfound = 0, ok = 1, chs[NSAT], ks[NSAT];
    trk_t trk[NSAT];
    trk_cfg_t tc;
    trk_default_cfg(&tc);
    uint64_t t_start = (corr_sim_nsmp() + 24000) & ~3ull;
    printf("Захват (%d снимков по %d отсчётов, некогерентно %d мс):\n", NSNAP, len, 2 * NSNAP);
    for (int prn = 1; prn <= 32; prn++) {
        acq_res_t r;
        acq_search_multi(xs, t0, NSNAP, len, SIG_L1CA, prn, 0, &ac, &r);
        int k = -1;
        for (int j = 0; j < NSAT; j++) if (PRN[j] == prn) k = j;
        if (!r.found) {
            if (k >= 0) { printf("  PRN %2d НЕ НАЙДЕН (пик/2-й пик %.2f)\n", prn, r.ratio); ok = 0; }
            else if (prn % 8 == 1) printf("  PRN %2d нет (пик/2-й пик %.2f)\n", prn, r.ratio);
            continue;
        }
        if (k < 0) { printf("  PRN %2d ложный захват (пик/2-й пик %.2f)\n", prn, r.ratio); ok = 0; continue; }
        double cpt = fmod(code_phase_true(k, t0[0] / FS_HZ), 1023.0), dcp = r.code_phase - cpt;
        if (dcp > 511.5) dcp -= 1023;
        if (dcp < -511.5) dcp += 1023;
        printf("  PRN %2d: доплер %+7.1f Гц (ист. %+6.0f), фаза кода %7.2f чип (ошибка %+.2f), пик/2-й %5.2f, C/N0 %.1f дБГц\n",
               prn, r.doppler, DOP[k], r.code_phase, dcp, r.ratio, r.cn0);
        if (fabs(dcp) > 0.6 || fabs(r.doppler - DOP[k]) > 60) ok = 0;
        /* фаза кода на отсчёт пуска */
        double rate = 1.023e6 * (1 + r.doppler / (154 * 10.23e6));
        double cps = r.code_phase + rate * (double)(t_start - t0[0]) / FS_HZ;
        int ch = corr_alloc(SIG_L1CA);
        corr_load_code(ch, SIG_L1CA, prn);
        trk_start(&trk[nfound], ch, SIG_L1CA, prn, 0, r.doppler, cps, t_start, &tc);
        BL[nfound].k = k;
        trk[nfound].on_bit = on_bit;
        trk[nfound].ctx = &BL[nfound];
        chs[nfound] = ch; ks[nfound] = k;
        nfound++;
    }
    corr_start(chs, nfound, t_start);
    /* слежение 1,5 с */
    corr_dump_t d;
    while (corr_sim_nsmp() < t_start + (uint64_t)(1.5 * FS_HZ)) {
        corr_sim_run(4096, src);
        for (int j = 0; j < nfound; j++)
            while (corr_read(chs[j], &d, corr_sim_nsmp())) {
                int st0 = trk[j].state;
                trk_update(&trk[j], &d);
                if (getenv("TRKDBG") && (trk[j].state != st0 || (trk[j].n_epoch % 100) == 0) && PRN[ks[j]] == atoi(getenv("TRKDBG")))
                    printf("    t=%.3f st=%d lock=%.2f perr=%+.2f f=%+.2f cn0=%.1f I=%d Q=%d\n", trk[j].t, trk[j].state, trk[j].lock,
                           trk[j].last_perr, trk_doppler(&trk[j]), trk[j].cn0, d.PI, d.PQ);
            }
    }
    printf("Слежение 1,5 с:\n");
    uint64_t nm = corr_sim_nsmp();
    for (int j = 0; j < nfound; j++) {
        int k = ks[j];
        double cp, cc;
        corr_phase_at(chs[j], nm, &cp, &cc);
        double cpt = fmod(code_phase_true(k, nm / FS_HZ), 1023.0), dcp = cp - cpt;
        if (dcp > 511.5) dcp -= 1023;
        if (dcp < -511.5) dcp += 1023;
        double dd = trk_doppler(&trk[j]) - DOP[k];
        printf("  PRN %2d: состояние %s, доплер %+8.2f Гц (ошибка %+.2f), фаза кода ошибка %+.3f чип, C/N0 %.1f (ист. %.0f), "
               "синхр. бит %s, биты %d, смен полярности %d%s\n", PRN[k], trk[j].state == TRK_LOCK ? "ЗАХВАТ" : "нет", trk_doppler(&trk[j]),
               dd, dcp, trk[j].cn0, CN0[k], trk[j].bit_sync ? "да" : "нет",
               BL[j].nbits, BL[j].flips, BL[j].nok > BL[j].ninv ? "" : " (инверсия Костаса)");
        if (trk[j].state != TRK_LOCK || fabs(dd) > 5 || fabs(dcp) > 0.08 || fabs(trk[j].cn0 - CN0[k]) > 3
            || !trk[j].bit_sync || BL[j].flips > (CN0[k] < 40 ? 1 : 0) || BL[j].nbits < 40) ok = 0;
    }
    printf("ИТОГ: %s\n", ok && nfound == NSAT ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    return !(ok && nfound == NSAT);
}
