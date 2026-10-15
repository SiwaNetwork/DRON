/* Проверка захвата слабых сигналов (ТЗ п. 5.2.3, холодный старт −142 дБм ≈ 29 дБГц):
 * GPS L1 C/A, КА с C/N0 29, 31, 33 дБГц и навигационными битами, 2-битный АЦП; поиск по 7 PRN
 * (4 отсутствуют — проверка ложных обнаружений), доплер ±1,5 кГц с шагом 250 Гц, K = 256 периодов
 * по снимкам 49152 отсчёта (2 периода на снимок). Оценивается также трудоёмкость на МК. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include "gnss.h"
#include "codes.h"
#include "fft.h"
#include "acq.h"

#define NSNAP_LEN 49152
#define SPACING   (NSNAP_LEN + 3 * 24000)         /* снимки через ≈ 5 мс */

typedef struct { int prn; double cn0, fd, cp0, ph0; uint8_t code[CODE_MAX_BYTES]; uint32_t bits; } sat_t;

static float GN[65536];
static uint32_t rs = 12345;
static uint32_t xs(void) { rs ^= rs << 13; rs ^= rs >> 17; rs ^= rs << 5; return rs; }

static void gen(const sat_t *S, int ns, uint32_t t0, uint8_t *x4)
{
    static float re[NSNAP_LEN], im[NSNAP_LEN];
    for (int i = 0; i < NSNAP_LEN; i++) {
        re[i] = GN[xs() & 65535] * 0.70710678f;
        im[i] = GN[xs() & 65535] * 0.70710678f;
    }
    double fif = sig_if(SIG_L1CA, 0), fc = sig_carrier(SIG_L1CA, 0);
    for (int s = 0; s < ns; s++) {
        const sat_t *p = &S[s];
        double A = sqrt(pow(10, p->cn0 / 10) / FS_HZ);
        double rate = 1.023e6 * (1 + p->fd / fc) / FS_HZ;
        double cp = p->cp0 + rate * t0;
        double ph = p->ph0 + 2 * GPI * (fif + p->fd) * t0 / FS_HZ, dph = 2 * GPI * (fif + p->fd) / FS_HZ;
        double cr = cos(ph), ci = sin(ph), dr = cos(dph), di = sin(dph);
        for (int i = 0; i < NSNAP_LEN; i++) {
            long ep = (long)floor(cp / 1023.0);
            int chip = (int)(cp - ep * 1023.0);
            int bit = (p->bits >> ((ep / 20) & 31)) & 1;
            float v = (float)(A * ((code_bit(p->code, chip) ^ bit) ? -1 : 1));
            re[i] += v * (float)cr; im[i] += v * (float)ci;
            double t = cr * dr - ci * di; ci = cr * di + ci * dr; cr = t;
            cp += rate;
        }
    }
    for (int i = 0; i < NSNAP_LEN; i++) {
        int qi = (re[i] < 0 ? 2 : 0) | (fabsf(re[i]) > 0.70710678f ? 1 : 0);
        int qq = (im[i] < 0 ? 2 : 0) | (fabsf(im[i]) > 0.70710678f ? 1 : 0);
        snap_put(x4, i, (unsigned)(qi << 2 | qq));
    }
}

int main(void)
{
    for (int i = 0; i < 65536; i += 2) {
        double u1 = (xs() + 1.0) / 4294967297.0, u2 = (xs() + 1.0) / 4294967297.0;
        GN[i] = (float)(sqrt(-2 * log(u1)) * cos(2 * GPI * u2));
        GN[i + 1] = (float)(sqrt(-2 * log(u1)) * sin(2 * GPI * u2));
    }
    sat_t S[3] = {{3, 29.0, 1234.0, 311.7, 0.4, {0}, 0x5A3C96E1u},
                  {17, 31.0, -640.0, 870.2, 2.1, {0}, 0x1F2E3D4Cu},
                  {25, 33.0, 40.0, 12.9, 5.0, {0}, 0xA5A5F00Fu}};
    for (int s = 0; s < 3; s++) code_gen(SIG_L1CA, S[s].prn, S[s].code);
    int prn[7] = {3, 17, 25, 5, 9, 12, 30};
    acq_weak_t w;
    static cpx_t rep[7 * 4096];
    static float acc[7 * 4096];
    if (!acq_weak_init(&w, SIG_L1CA, 0, prn, 7, -1500, 1500, 250, 256, rep, acc)) { printf("ошибка init\n"); return 1; }
    static uint8_t x4[NSNAP_LEN];
    uint32_t t0 = 1000;
    int nsnap = 0;
    clock_t c0 = clock();
    double tproc = 0;
    for (;;) {
        gen(S, 3, t0, x4);
        clock_t c1 = clock();
        int done = acq_weak_add(&w, x4, t0, NSNAP_LEN);
        tproc += (double)(clock() - c1) / CLOCKS_PER_SEC;
        nsnap++;
        t0 += SPACING;
        if (done) break;
    }
    printf("Снимков %d (ячеек доплера %d × %d периодов), время ПК: всего %.1f с, обработка %.2f с\n",
           nsnap, w.nd, w.K, (double)(clock() - c0) / CLOCKS_PER_SEC, tproc);
    int ok = 1;
    for (int i = 0; i < 7; i++) {
        acq_res_t r;
        uint32_t tr;
        int f = acq_weak_result(&w, i, &r, &tr);
        const sat_t *p = NULL;
        for (int s = 0; s < 3; s++) if (S[s].prn == prn[i]) p = &S[s];
        if (p) {
            double rate = 1.023e6 * (1 + p->fd / sig_carrier(SIG_L1CA, 0)) / FS_HZ;
            double cpt = fmod(p->cp0 + rate * tr, 1023.0);
            double e = r.code_phase - cpt;
            if (e > 511.5) e -= 1023;
            if (e < -511.5) e += 1023;
            double ed = r.doppler - p->fd;
            printf("  PRN %2d (C/N0 %.0f дБГц): z = %5.1f, %s, ошибка фазы кода %+.2f чипа, доплера %+.0f Гц, "
                   "оценка C/N0 %.1f\n", prn[i], p->cn0, r.metric, f ? "обнаружен" : "НЕ обнаружен", e, ed, r.cn0);
            /* доплер — ячейка, ближайшая или соседняя с истинным значением (остаток снимает ЧАП) */
            if (!f || fabs(e) > 0.5 || fabs(ed) > w.step) ok = 0;
        } else {
            printf("  PRN %2d (нет сигнала):    z = %5.1f, %s\n", prn[i], r.metric, f ? "ЛОЖНОЕ обнаружение" : "не обнаружен");
            if (f) ok = 0;
        }
    }
    /* трудоёмкость на МК (STM32H743, 480 МГц, CMSIS-DSP): на период кода — перенос на нулевую
     * частоту 24000 отсчётов (≈ 8 тактов на отсчёт), БПФ 4096 (≈ 0,7 мс), на PRN — ОБПФ и
     * умножение/накопление (≈ 0,85 мс); группа 8 PRN, 2 периода на снимок + запись снимка 2,7 мс */
    double t_per = 24000 * 8 / 480e6 + 0.7e-3 + 8 * 0.85e-3, t_snap = 2 * t_per + 2.7e-3;
    double t_gps = 49.0 * (w.K / 2) * 4 * t_snap;          /* ±6 кГц / 250 Гц, 32 PRN = 4 группы */
    printf("Обработка на снимок (ПК): %.2f мс на %d PRN. Оценка для МК: %.1f мс на снимок (8 PRN);\n"
           "  полный поиск 32 PRN GPS (±6 кГц, K = %d): %.0f с; при K = 32 (C/N0 ≥ 35 дБГц): %.0f с\n",
           tproc / nsnap * 1e3, w.nprn, t_snap * 1e3, w.K, t_gps, t_gps * 32 / w.K);
    printf("ИТОГ: %s\n", ok ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    return !ok;
}
