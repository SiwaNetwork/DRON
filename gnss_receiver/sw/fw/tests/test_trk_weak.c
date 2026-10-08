/* Слежение за слабыми сигналами (ТЗ п. 5.2.3, ПМ 7.2.3 в) на модели ПЛИС.
 * Сценарии: GPS L1 C/A (данные, Костас) до 24 дБГц и Galileo E1C (пилот, BOC(1,1), вторичный
 * код CS25) до 21 дБГц — уровень ТЗ −150 дБм ≈ 20,8 дБГц. C/N0 40 дБГц в течение 3 с (втягивание,
 * синхронизация по битам / вторичному коду, переход к длительному накоплению), затем снижение
 * на 4 дБ/с и удержание до конца прогона. Доплер меняется со скоростью 0,5 Гц/с.
 * Проверка на последних 5 с: канал не освобождён, доля интервалов в захвате, ошибки частоты
 * и фазы кода; для L1 C/A — ошибки в битах и полуцикловые срывы (по блокам 1 с). */
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

#define T_END 16.0
static const double D0 = 1250.0, DD = 0.5;          /* доплер, Гц; скорость, Гц/с */
static const double CP0 = 377.3, PH0 = 1.1;
static int SIG, L, PRN;
static double CN_LOW, RATE;
static uint8_t CODE[CODE_MAX_BYTES], SEC[SEC_MAX_LEN];
static int SECL;
static uint8_t BITS[1024];
static float GN[65536];
static uint32_t rng = 4242;
static double A_cur;
static long a_ms;

static uint32_t xs(void) { rng ^= rng << 13; rng ^= rng >> 17; rng ^= rng << 5; return rng; }
static double cn0_at(double t)
{
    double t1 = 3.0, t2 = t1 + (40.0 - CN_LOW) / 4.0;
    return t < t1 ? 40.0 : t < t2 ? 40.0 - 4.0 * (t - t1) : CN_LOW;
}
static double dop_at(double t) { return D0 + DD * t; }
static double cp_true(double t)                      /* чипы без свёртки */
{
    return CP0 + RATE * (t + (D0 * t + 0.5 * DD * t * t) / (154 * 10.23e6));
}
static int q2(double v, double thr) { return (v < 0 ? 2 : 0) | (fabs(v) > thr ? 1 : 0); }

static uint32_t src(uint64_t i)
{
    double t = (double)i / FS_HZ;
    long ms = (long)(t * 1e3);
    if (ms != a_ms) { a_ms = ms; A_cur = sqrt(pow(10, cn0_at(t) / 10) / FS_HZ); }
    double cp = cp_true(t);
    long ci = (long)floor(cp), ep = ci / L;
    int v = code_bit(CODE, (int)(ci % L)) ? -1 : 1;
    if (SIG == SIG_L1CA) v *= BITS[(ep / 20) % 1024] ? -1 : 1;
    if (SECL) v *= SEC[ep % SECL] ? -1 : 1;
    if (SIGS[SIG].boc && cp - ci >= 0.5) v = -v;
    double th = PH0 + 2 * GPI * (sig_if(SIG, 0) * t + D0 * t + 0.5 * DD * t * t);
    double re = A_cur * v * cos(th) + GN[xs() & 65535] * 0.70710678;
    double im = A_cur * v * sin(th) + GN[xs() & 65535] * 0.70710678;
    return (uint32_t)(q2(re, 0.70710678) << 2 | q2(im, 0.70710678));
}

/* биты L1 C/A: совпадение с истиной по блокам 50 бит (полярность Костаса — по блоку) */
static int nb, blk_m, blk_n, nerr, nslip, prev_pol;
static void on_bit(void *ctx, int bit, uint64_t n_end)
{
    (void)ctx;
    double t = (double)n_end / FS_HZ;
    if (t < T_END - 5) return;
    long ci = (long)floor(cp_true(t - 0.010));      /* истина — по середине бита */
    int truth = BITS[(ci / L / 20) % 1024];
    blk_m += bit == truth; blk_n++; nb++;
    if (blk_n == 50) {
        int pol = 2 * blk_m >= blk_n ? 1 : -1;
        nerr += pol > 0 ? blk_n - blk_m : blk_m;
        if (prev_pol && pol != prev_pol) nslip++;
        prev_pol = pol; blk_m = blk_n = 0;
    }
}

static int run(int sig, int prn, double cn_low)
{
    SIG = sig; PRN = prn; CN_LOW = cn_low;
    L = code_gen(sig, prn, CODE);
    SECL = sec_code(sig, prn, SEC);
    RATE = SIGS[sig].chip_rate;
    a_ms = -1; nb = blk_m = blk_n = nerr = nslip = prev_pol = 0;
    corr_sim_init(1);
    corr_init();
    trk_cfg_t cfg;
    trk_default_cfg(&cfg);
    int ch = corr_alloc(sig);
    corr_load_code(ch, sig, prn);
    uint64_t t0 = 4800;                              /* 0,2 мс */
    double ts = (double)t0 / FS_HZ;
    trk_t k;
    double cps = fmod(cp_true(ts), (double)L) + (SIGS[sig].boc ? 0.08 : 0.25);
    trk_start(&k, ch, sig, prn, 0, dop_at(ts) + 30.0, cps, t0, &cfg);
    k.on_bit = on_bit;
    int chs[1] = {ch};
    corr_start(chs, 1, t0);
    double sf = 0, sc = 0, maxc = 0, t_long = -1;
    int nm = 0, idle = 0, nlock = 0;
    corr_dump_t d;
    while (corr_sim_nsmp() < (uint64_t)(T_END * FS_HZ)) {
        corr_sim_run(4096, src);
        while (corr_read(ch, &d, corr_sim_nsmp())) {
            trk_update(&k, &d);
            double t = (double)d.n / FS_HZ;
            if (k.ncoh > 1 && t_long < 0) t_long = t;
            if (k.state == TRK_IDLE) idle = 1;
            if (t > T_END - 5) {
                double fe = trk_doppler(&k) - dop_at(t), cp;
                corr_phase_at(ch, d.n + 1, &cp, NULL);
                double ce = cp - fmod(cp_true((double)(d.n + 1) / FS_HZ), (double)L);
                if (ce > L / 2.0) ce -= L;
                if (ce < -L / 2.0) ce += L;
                sf += fe * fe; sc += ce * ce; nm++;
                if (fabs(ce) > maxc) maxc = fabs(ce);
                nlock += k.state == TRK_LOCK;
            }
        }
    }
    double rf = sqrt(sf / nm), rc = sqrt(sc / nm), pl = 100.0 * nlock / nm;
    printf("%s PRN %d: C/N0 40 -> %.0f дБГц; %s; длительное накопление (%d × %.0f мс) с t = %.2f с\n",
           SIGS[sig].id, prn, cn_low, SECL ? (k.sec_sync ? "синхронизация по вторичному коду" : "НЕТ синхронизации по вторичному коду")
           : (k.bit_sync ? "синхронизация по битам" : "НЕТ синхронизации по битам"), k.ncoh, k.T * 1e3, t_long);
    printf("  последние 5 с: в захвате %.1f %%, СКО ошибки частоты %.2f Гц, СКО фазы кода %.3f чипа "
           "(макс. %.3f), оценка C/N0 %.1f дБГц", pl, rf, rc, maxc, k.cn0);
    if (sig == SIG_L1CA) printf(", ошибок в битах %d из %d, полуцикловых срывов %d", nerr, nb, nslip);
    printf("\n");
    int ok = !idle && t_long > 0 && rf < 3.0 && rc < 0.1;
    if (sig == SIG_L1CA) ok = ok && pl > 90 && nb >= 200 && nerr < 0.05 * nb;
    else ok = ok && pl > 95 && k.sec_sync;
    return ok;
}

int main(void)
{
    for (int i = 0; i < 65536; i += 2) {
        double u1 = (xs() + 1.0) / 4294967297.0, u2 = (xs() + 1.0) / 4294967297.0;
        GN[i] = (float)(sqrt(-2 * log(u1)) * cos(2 * GPI * u2));
        GN[i + 1] = (float)(sqrt(-2 * log(u1)) * sin(2 * GPI * u2));
    }
    for (int i = 0; i < 1024; i++) BITS[i] = xs() & 1;
    int ok = run(SIG_L1CA, 7, 24.0);
    ok &= run(SIG_E1C, 11, 21.0);
    printf("ИТОГ: %s\n", ok ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    return !ok;
}
