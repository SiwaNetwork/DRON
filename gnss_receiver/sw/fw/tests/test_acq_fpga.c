/* Проверка захвата на ускорителе ПЛИС (ТЗ п. 5.2.3, 5.2.4): драйвер acq_hw_* (src/acq.c) и битово-
 * точная модель ускорителя (src/acqf_sim.c в модели ПЛИС corr_sim.c) на непрерывном потоке отсчётов.
 * GPS L1 C/A, КА с C/N0 29, 31, 33 дБГц и навигационными битами, 2-битный АЦП; поиск по 7 PRN
 * (4 отсутствуют — проверка ложных обнаружений), доплер ±1,5 кГц с шагом 250 Гц, K = 256 периодов.
 * Условия — как у test_acq_weak (поиск в МК по снимкам). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include "gnss.h"
#include "codes.h"
#include "fpga.h"
#include "corr_sim.h"
#include "acq.h"

#define BLK 24000

typedef struct { int prn; double cn0, fd, cp0, ph0; uint8_t code[CODE_MAX_BYTES]; uint32_t bits; } sat_t;

static float GN[65536];
static uint32_t rs = 12345;
static uint32_t xs(void) { rs ^= rs << 13; rs ^= rs >> 17; rs ^= rs << 5; return rs; }

static sat_t S[3] = {{3, 29.0, 1234.0, 311.7, 0.4, {0}, 0x5A3C96E1u},
                     {17, 31.0, -640.0, 870.2, 2.1, {0}, 0x1F2E3D4Cu},
                     {25, 33.0, 40.0, 12.9, 5.0, {0}, 0xA5A5F00Fu}};
static uint32_t W[BLK];
static uint64_t W0;

static double rate_of(const sat_t *p) { return 1.023e6 * (1 + p->fd / sig_carrier(SIG_L1CA, 0)) / FS_HZ; }

/* блок отсчётов с номера t0: ВЧ-канал 0 (L1), прочие — нули */
static void gen(uint64_t t0)
{
    static float re[BLK], im[BLK];
    for (int i = 0; i < BLK; i++) {
        re[i] = GN[xs() & 65535] * 0.70710678f;
        im[i] = GN[xs() & 65535] * 0.70710678f;
    }
    double fif = sig_if(SIG_L1CA, 0);
    for (int s = 0; s < 3; s++) {
        const sat_t *p = &S[s];
        double A = sqrt(pow(10, p->cn0 / 10) / FS_HZ), rate = rate_of(p);
        double cp = p->cp0 + rate * (double)t0;
        long ep = (long)floor(cp / 1023.0);
        int chip = (int)floor(cp - ep * 1023.0);
        double fr = cp - ep * 1023.0 - chip;
        double cyc = (fif + p->fd) * (double)t0 / FS_HZ;
        double ph = p->ph0 + 2 * GPI * (cyc - floor(cyc)), dph = 2 * GPI * (fif + p->fd) / FS_HZ;
        double cr = cos(ph), ci = sin(ph), dr = cos(dph), di = sin(dph);
        float v = (float)(A * ((code_bit(p->code, chip) ^ ((p->bits >> ((ep / 20) & 31)) & 1)) ? -1 : 1));
        for (int i = 0; i < BLK; i++) {
            re[i] += v * (float)cr; im[i] += v * (float)ci;
            double t = cr * dr - ci * di; ci = cr * di + ci * dr; cr = t;
            fr += rate;
            if (fr >= 1) {
                fr -= 1;
                if (++chip == 1023) { chip = 0; ep++; }
                v = (float)(A * ((code_bit(p->code, chip) ^ ((p->bits >> ((ep / 20) & 31)) & 1)) ? -1 : 1));
            }
        }
    }
    for (int i = 0; i < BLK; i++) {
        unsigned qi = (re[i] < 0 ? 2u : 0u) | (fabsf(re[i]) > 0.70710678f ? 1u : 0u);
        unsigned qq = (im[i] < 0 ? 2u : 0u) | (fabsf(im[i]) > 0.70710678f ? 1u : 0u);
        W[i] = qi << 2 | qq;
    }
    W0 = t0;
}

static uint32_t src(uint64_t i) { return W[i - W0]; }

int main(void)
{
    for (int i = 0; i < 65536; i += 2) {
        double u1 = (xs() + 1.0) / 4294967297.0, u2 = (xs() + 1.0) / 4294967297.0;
        GN[i] = (float)(sqrt(-2 * log(u1)) * cos(2 * GPI * u2));
        GN[i + 1] = (float)(sqrt(-2 * log(u1)) * sin(2 * GPI * u2));
    }
    for (int s = 0; s < 3; s++) code_gen(SIG_L1CA, S[s].prn, S[s].code);
    corr_sim_init(1);
    int prn[7] = {3, 17, 25, 5, 9, 12, 30};
    static acq_hw_t h;
    if (!acq_hw_init(&h, SIG_L1CA, 0, prn, 7, -1500, 1500, 250, 256)) { printf("ошибка init\n"); return 1; }
    clock_t c0 = clock();
    uint64_t n0 = corr_sim_nsmp();
    while (!acq_hw_poll(&h)) {
        gen(corr_sim_nsmp());
        corr_sim_run(BLK, src);
        if (corr_sim_nsmp() - n0 > (uint64_t)(60 * FS_HZ)) { printf("превышено время\n"); return 1; }
    }
    double t_sig = (double)(corr_sim_nsmp() - n0) / FS_HZ;
    printf("Ускоритель: %d PRN × %d запусков (ячеек доплера %d, шаг %.0f Гц, K = %d), сигнала %.2f с, "
           "время ПК %.1f с, отказов %d\n", h.nprn, h.nrun, h.nd, h.step, h.K, t_sig,
           (double)(clock() - c0) / CLOCKS_PER_SEC, h.nfail);
    int ok = h.nfail == 0;
    for (int i = 0; i < 7; i++) {
        acq_res_t r;
        uint32_t tr;
        int f = acq_hw_result(&h, i, &r, &tr);
        const sat_t *p = NULL;
        for (int s = 0; s < 3; s++) if (S[s].prn == prn[i]) p = &S[s];
        if (p) {
            double cpt = fmod(p->cp0 + rate_of(p) * tr, 1023.0);
            double e = r.code_phase - cpt;
            if (e > 511.5) e -= 1023;
            if (e < -511.5) e += 1023;
            double ed = r.doppler - p->fd;
            printf("  PRN %2d (C/N0 %.0f дБГц): z = %5.1f, %s, ошибка фазы кода %+.2f чипа, доплера %+.0f Гц, "
                   "оценка C/N0 %.1f\n", prn[i], p->cn0, r.metric, f ? "обнаружен" : "НЕ обнаружен", e, ed, r.cn0);
            if (!f || fabs(e) > 0.5 || fabs(ed) > h.step) ok = 0;
        } else {
            printf("  PRN %2d (нет сигнала):    z = %5.1f, %s\n", prn[i], r.metric, f ? "ЛОЖНОЕ обнаружение" : "не обнаружен");
            if (f) ok = 0;
        }
    }
    /* полный поиск GPS: 32 PRN, ±6 кГц (шаг 500 Гц — 25 ячеек, 4 запуска на PRN; 250 Гц — 8) */
    static acq_hw_t g5, g2;
    int all[32];
    for (int i = 0; i < 32; i++) all[i] = i + 1;
    acq_hw_init(&g5, SIG_L1CA, 0, all, 32, -6000, 6000, 500, 256);
    acq_hw_init(&g2, SIG_L1CA, 0, all, 32, -6000, 6000, 250, 256);
    double t5 = 32.0 * g5.nrun * acq_hw_run_time(&g5), t2 = 32.0 * g2.nrun * acq_hw_run_time(&g2);
    printf("Запуск K = %d: %.3f с. Полный поиск 32 PRN GPS ±6 кГц: шаг 500 Гц — %.1f с, 250 Гц — %.1f с;\n"
           "  при K = 32 (C/N0 ≥ 35 дБГц): %.1f с / %.1f с\n", g5.K, acq_hw_run_time(&g5), t5, t2,
           t5 * 32 / 256, t2 * 32 / 256);
    printf("ИТОГ: %s\n", ok ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    return !ok;
}
