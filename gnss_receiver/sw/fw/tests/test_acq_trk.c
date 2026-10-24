/* Сквозная проверка «ПЧ → захват на ускорителе ПЛИС → слежение» (ПЗ 9.1 п. 4) на модели ПЛИС:
 * GPS L1 C/A, C/N0 29 дБГц, навигационные биты, 2-битный АЦП. Доплер — посередине между узлами
 * сетки поиска (худший случай ошибки по частоте). Поиск — 256 периодов, при пропуске — повтор
 * (до трёх попыток, как в следующем цикле фонового поиска). По результату ускорителя канал
 * запускается так же, как в ПО МК (как rx_start: фаза кода переносится от отсчёта t_ref на момент
 * пуска), в режиме слабого сигнала (trk_cfg_t.weak). Проверка: захват фазы, синхронизация по
 * битам, ошибки частоты и фазы кода, ошибки в битах на последних 5 с.
 * Аргументы: C/N0, доплер, режим слабого сигнала (1/0), начальное число шума, диапазон поиска ±Гц. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "gnss.h"
#include "codes.h"
#include "fpga.h"
#include "corr.h"
#include "corr_sim.h"
#include "track.h"
#include "acq.h"

#define BLK 24000

static const int PRN = 3;
static double CN0 = 29.0, FD = 1125.0, DR = 1500.0;  /* доплер между узлами 1000 и 1250 Гц */
static const double CP0 = 311.7, PH0 = 0.4, T_END = 14.0;
static uint8_t CODE[CODE_MAX_BYTES], BITS[1024];
static float GN[65536];
static uint32_t rs = 777;
static uint32_t W[BLK];
static uint64_t W0;

static uint32_t xs(void) { rs ^= rs << 13; rs ^= rs >> 17; rs ^= rs << 5; return rs; }
static double rate(void) { return 1.023e6 * (1 + FD / sig_carrier(SIG_L1CA, 0)) / FS_HZ; }
static double cp_true(uint64_t n) { return CP0 + rate() * (double)n; }   /* чипы без свёртки */

static void gen(uint64_t t0)
{
    static float re[BLK], im[BLK];
    for (int i = 0; i < BLK; i++) {
        re[i] = GN[xs() & 65535] * 0.70710678f;
        im[i] = GN[xs() & 65535] * 0.70710678f;
    }
    double A = sqrt(pow(10, CN0 / 10) / FS_HZ), r = rate(), fif = sig_if(SIG_L1CA, 0);
    double cp = cp_true(t0);
    long ep = (long)floor(cp / 1023.0);
    int chip = (int)floor(cp - ep * 1023.0);
    double fr = cp - ep * 1023.0 - chip;
    double cyc = (fif + FD) * (double)t0 / FS_HZ;
    double ph = PH0 + 2 * GPI * (cyc - floor(cyc)), dph = 2 * GPI * (fif + FD) / FS_HZ;
    double cr = cos(ph), ci = sin(ph), dr = cos(dph), di = sin(dph);
    float v = (float)(A * ((code_bit(CODE, chip) ^ BITS[(ep / 20) & 1023]) ? -1 : 1));
    for (int i = 0; i < BLK; i++) {
        re[i] += v * (float)cr; im[i] += v * (float)ci;
        double t = cr * dr - ci * di; ci = cr * di + ci * dr; cr = t;
        fr += r;
        if (fr >= 1) {
            fr -= 1;
            if (++chip == 1023) { chip = 0; ep++; }
            v = (float)(A * ((code_bit(CODE, chip) ^ BITS[(ep / 20) & 1023]) ? -1 : 1));
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
static void step(void) { gen(corr_sim_nsmp()); corr_sim_run(BLK, src); }

/* биты: совпадение с истиной по блокам 50 бит (полярность Костаса — по блоку) */
static int nb, blk_m, blk_n, nerr;
static void on_bit(void *ctx, int bit, uint64_t n_end)
{
    (void)ctx;
    if ((double)n_end / FS_HZ < T_END - 5) return;
    long ci = (long)floor(cp_true(n_end - 240000));            /* середина бита */
    int truth = BITS[(ci / 1023 / 20) & 1023];
    blk_m += bit == truth; blk_n++; nb++;
    if (blk_n == 50) { nerr += 2 * blk_m >= blk_n ? blk_n - blk_m : blk_m; blk_m = blk_n = 0; }
}

int main(int argc, char **argv)
{
    if (argc > 1) CN0 = atof(argv[1]);
    if (argc > 2) FD = atof(argv[2]);
    if (argc > 4) rs = (uint32_t)atoi(argv[4]);
    if (argc > 5) DR = atof(argv[5]);
    for (int i = 0; i < 65536; i += 2) {
        double u1 = (xs() + 1.0) / 4294967297.0, u2 = (xs() + 1.0) / 4294967297.0;
        GN[i] = (float)(sqrt(-2 * log(u1)) * cos(2 * GPI * u2));
        GN[i + 1] = (float)(sqrt(-2 * log(u1)) * sin(2 * GPI * u2));
    }
    for (int i = 0; i < 1024; i++) BITS[i] = xs() & 1;
    code_gen(SIG_L1CA, PRN, CODE);
    corr_sim_init(1);
    corr_init();
    /* поиск ускорителем; при пропуске — повтор, как в фоновом поиске (вероятность обнаружения
     * за одну попытку при 29 дБГц ≈ 0,8) */
    static acq_hw_t h;
    int prn[1] = {PRN}, found = 0;
    acq_res_t a;
    uint32_t tr;
    for (int att = 1; att <= 3 && !found; att++) {
        if (!acq_hw_init(&h, SIG_L1CA, 0, prn, 1, -DR, DR, 250, 256)) { printf("ошибка init\n"); return 1; }
        while (!acq_hw_poll(&h)) step();
        found = acq_hw_result(&h, 0, &a, &tr);
        double ce0 = a.code_phase - fmod(cp_true(tr), 1023.0);
        if (ce0 > 511.5) ce0 -= 1023;
        if (ce0 < -511.5) ce0 += 1023;
        printf("Ускоритель, попытка %d: PRN %d C/N0 %.0f дБГц, доплер %.0f Гц: z = %.1f, %s к %.2f с, ошибка "
               "фазы кода %+.2f чипа, доплера %+.0f Гц\n", att, PRN, CN0, FD, a.metric,
               found ? "обнаружен" : "НЕ обнаружен", (double)corr_sim_nsmp() / FS_HZ, ce0, a.doppler - FD);
    }
    if (!found) { printf("ИТОГ: НЕ ПРОЙДЕН\n"); return 1; }
    /* пуск канала, как ch_start (src/rx.c) */
    trk_cfg_t cfg;
    trk_default_cfg(&cfg);
    cfg.weak = argc > 3 ? atoi(argv[3]) : 1;
    int ch = corr_alloc(SIG_L1CA);
    uint64_t ts = corr_start_next(ch, corr_time_now());
    double rt = 1.023e6 * (1 + a.doppler / sig_carrier(SIG_L1CA, 0));
    double cps = a.code_phase + rt * (double)(int32_t)((uint32_t)ts - tr) / FS_HZ;
    cps = fmod(cps, 1023.0);
    double ces = cps - fmod(cp_true(ts), 1023.0);
    if (ces > 511.5) ces -= 1023;
    if (ces < -511.5) ces += 1023;
    printf("Пуск канала через %.2f с после начала накопления: ошибка фазы кода %+.2f чипа\n",
           (double)(int32_t)((uint32_t)ts - tr) / FS_HZ, ces);
    corr_load_code(ch, SIG_L1CA, PRN);
    trk_t k;
    trk_start(&k, ch, SIG_L1CA, PRN, 0, a.doppler, cps, ts, &cfg);
    k.on_bit = on_bit;
    corr_start(&ch, 1, ts);
    double sf = 0, sc = 0, t_lock = -1, fe1 = 0;
    int nm = 0, nlock = 0, idle = 0;
    corr_dump_t d;
    while (corr_sim_nsmp() < (uint64_t)(T_END * FS_HZ)) {
        step();
        while (corr_read(ch, &d, corr_sim_nsmp())) {
            int w0 = k.weak;
            trk_update(&k, &d);
            double t = (double)d.n / FS_HZ;
            if (w0 == 1 && k.weak == 2) fe1 = k.f0 - k.f_if - FD;
            if (w0 == 2 && k.weak == 3)
                printf("Оценка частоты (%.1f с): ошибка доплера грубая %+.1f Гц, точная %+.1f Гц\n",
                       k.weak_time, fe1, k.f0 - k.f_if - FD);
            if (k.state == TRK_IDLE) idle = 1;
            if (k.state == TRK_LOCK && t_lock < 0) t_lock = t;
            if (t > T_END - 5) {
                double fe = trk_doppler(&k) - FD, cp;
                corr_phase_at(ch, d.n + 1, &cp, NULL);
                double ce = cp - fmod(cp_true(d.n + 1), 1023.0);
                if (ce > 511.5) ce -= 1023;
                if (ce < -511.5) ce += 1023;
                sf += fe * fe; sc += ce * ce; nm++;
                nlock += k.state == TRK_LOCK;
            }
        }
    }
    double rf = nm ? sqrt(sf / nm) : 1e9, rc = nm ? sqrt(sc / nm) : 1e9, pl = nm ? 100.0 * nlock / nm : 0;
    printf("Слежение: захват с t = %.2f с (%.2f с после пуска), %s; последние 5 с: в захвате %.1f %%, "
           "СКО частоты %.2f Гц, фазы кода %.3f чипа, C/N0 %.1f дБГц, ошибок в битах %d из %d\n",
           t_lock, t_lock - (double)ts / FS_HZ, k.bit_sync ? "синхронизация по битам" : "НЕТ синхронизации по битам",
           pl, rf, rc, k.cn0, nerr, nb);
    int ok = !idle && t_lock > 0 && k.bit_sync && pl > 90 && rf < 3.0 && rc < 0.1 && nb >= 200 && nerr < 0.05 * nb;
    printf("ИТОГ: %s\n", ok ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    return !ok;
}
