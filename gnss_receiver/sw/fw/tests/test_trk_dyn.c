/* Слежение при динамике носителя (ТЗ п. 5.2.10: скорость до 500 м/с, ускорение до 4g, рывок до
 * 2g/с) на модели ПЛИС: GPS L1 C/A, 45 дБГц, движение вдоль линии визирования (наихудший случай).
 * Профиль: 300 м/с, через 3 с — рывок 2g/с до 4g (2 с), 4g в течение 3 с, рывок −2g/с до нуля
 * (2 с), затем 496 м/с до конца. Сравниваются ФАП 2-го порядка (10 Гц + ЧАП) и 3-го порядка
 * (18 Гц). Проверка (3-й порядок): захват не теряется, ошибка фазы ФАП, ошибка частоты. */
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

#define T_END 14.0
#define G0    9.80665
#define NMS   14002
static const double V0 = 300.0, J = 2 * G0, CP0 = 211.6, PH0 = 0.7;
static double R[NMS + 2];                                 /* дальность на сетке 1 мс, м */
static uint8_t CODE[CODE_MAX_BYTES], BITS[1024];
static float GN[65536], SINT[1024];
static uint32_t rng = 99;
static uint32_t xs(void) { rng ^= rng << 13; rng ^= rng >> 17; rng ^= rng << 5; return rng; }

static double acc_at(double t)                        /* ускорение по линии визирования */
{
    if (t < 3) return 0;
    if (t < 5) return J * (t - 3);
    if (t < 8) return 2 * J;
    if (t < 10) return 2 * J - J * (t - 8);
    return 0;
}
static double lam(void) { return CLIGHT / sig_carrier(SIG_L1CA, 0); }
static double vel_at(double t)                        /* по сетке (трапеции) */
{
    double v = V0, dt = 1e-4;
    for (double s = 0; s < t; s += dt) v += 0.5 * (acc_at(s) + acc_at(s + dt)) * dt;
    return v;
}

/* потоковый имитатор: дальность — линейно внутри миллисекунды */
static long cur = -1;
static double cp, dcp;
static uint32_t ph, dph;
static int val;
static uint64_t next_i;
static double ts_code;                                /* время по коду (без свёртки), с */
static double A = 0;

static void ms_state(long k, uint64_t i)
{
    double t = (double)i / FS_HZ, fr = t * 1e3 - k;
    double r = R[k] + (R[k + 1] - R[k]) * fr, dr = (R[k + 1] - R[k]) * 1e3 / FS_HZ;
    /* время излучения: t − r/c; фаза кода и несущей относительно гетеродина */
    double tt = t - r / CLIGHT, dtt = 1.0 / FS_HZ - dr / CLIGHT;
    ts_code = tt;
    cp = CP0 + fmod(tt, 1e-3) * 1.023e6;
    while (cp >= 1023) cp -= 1023;
    dcp = dtt * 1.023e6;
    double fc = sig_carrier(SIG_L1CA, 0), fif = sig_if(SIG_L1CA, 0);
    double p = fif * t - r / lam() + PH0 / (2 * GPI);
    ph = (uint32_t)(int64_t)llround((p - floor(p)) * 4294967296.0);
    dph = (uint32_t)(int64_t)llround((fif / FS_HZ - dr / lam()) * 4294967296.0);
    (void)fc;
    long ci = (long)floor(tt * 1.023e6 / 1023.0);
    val = BITS[(ci / 20) & 1023] ? -1 : 1;
}

static int q2(double v) { return (v < 0 ? 2 : 0) | (fabs(v) > 0.70710678 ? 1 : 0); }

static uint32_t src(uint64_t i)
{
    if (i >= next_i || cur < 0) {
        long k = (long)floor((double)i / FS_HZ * 1e3);
        cur = k;
        ms_state(k, i);
        next_i = (uint64_t)ceil((k + 1) * 1e-3 * FS_HZ);
        if (next_i <= i) next_i = i + 1;
    }
    int c = code_bit(CODE, (int)cp) ? -1 : 1;
    float v = (float)(A * c * val);
    double re = v * SINT[((ph >> 22) + 256) & 1023] + GN[xs() & 65535] * 0.70710678;
    double im = v * SINT[ph >> 22] + GN[xs() & 65535] * 0.70710678;
    ts_code += 1.0 / FS_HZ;
    cp += dcp;
    if (cp >= 1023) {
        cp -= 1023;
        long ci = (long)floor(ts_code * 1.023e6 / 1023.0 + 0.5);
        val = BITS[(ci / 20) & 1023] ? -1 : 1;
    }
    ph += dph;
    return (uint32_t)(q2(re) << 2 | q2(im));
}

static int run(int order)
{
    cur = -1;
    corr_sim_init(1);
    corr_init();
    trk_cfg_t cfg;
    trk_default_cfg(&cfg);
    cfg.pll_order = order;
    int ch = corr_alloc(SIG_L1CA);
    corr_load_code(ch, SIG_L1CA, 7);
    uint64_t t0 = 4800;
    double ts = (double)t0 / FS_HZ, r0 = R[0] + (R[1] - R[0]) * ts * 1e3;
    double dop0 = -V0 / lam();
    trk_t k;
    double cps = fmod(CP0 + fmod(ts - r0 / CLIGHT, 1e-3) * 1.023e6, 1023.0) + 0.2;
    trk_start(&k, ch, SIG_L1CA, 7, 0, dop0 + 25.0, cps, t0, &cfg);
    int chs[1] = {ch};
    corr_start(chs, 1, t0);
    double se = 0, me = 0, sf = 0, mf = 0;
    int nm = 0, lost = 0, idle = 0;
    corr_dump_t d;
    while (corr_sim_nsmp() < (uint64_t)(T_END * FS_HZ)) {
        corr_sim_run(4096, src);
        while (corr_read(ch, &d, corr_sim_nsmp())) {
            trk_update(&k, &d);
            double t = (double)d.n / FS_HZ;
            if (k.state == TRK_IDLE) idle = 1;
            if (t > 2.5) {
                if (k.state != TRK_LOCK) lost++;
                /* скорость — по сетке дальности (линейная интерполяция производной) */
                long km = (long)(t * 1e3);
                double fr = t * 1e3 - km;
                double v0 = (R[km + 1] - R[km]) * 1e3, v1 = (R[km + 2] - R[km + 1]) * 1e3;
                double v = v0 + (v1 - v0) * fr;
                double fe = trk_doppler(&k) - (-v / lam());
                double pe = fabs(k.last_perr) * 180 / GPI;
                se += pe * pe; sf += fe * fe; nm++;
                if (pe > me) me = pe;
                if (fabs(fe) > mf) mf = fabs(fe);
            }
        }
    }
    double re = sqrt(se / nm), rf = sqrt(sf / nm);
    printf("ФАП %d-го порядка: интервалов вне захвата %d из %d, ошибка фазы СКО %.1f° (макс. %.1f°), "
           "ошибка частоты СКО %.2f Гц (макс. %.1f Гц)%s\n", order, lost, nm, re, me, rf, mf,
           idle ? ", канал освобождён" : "");
    return !idle && lost == 0 && re < 10 && me < 45 && rf < 5;
}

int main(void)
{
    for (int i = 0; i < 65536; i += 2) {
        double u1 = (xs() + 1.0) / 4294967297.0, u2 = (xs() + 1.0) / 4294967297.0;
        GN[i] = (float)(sqrt(-2 * log(u1)) * cos(2 * GPI * u2));
        GN[i + 1] = (float)(sqrt(-2 * log(u1)) * sin(2 * GPI * u2));
    }
    for (int i = 0; i < 1024; i++) { SINT[i] = (float)sin(2 * GPI * (i + 0.5) / 1024); BITS[i] = xs() & 1; }
    code_gen(SIG_L1CA, 7, CODE);
    A = sqrt(pow(10, 45.0 / 10) / FS_HZ);
    /* дальность: r(t) = 2·10^7 + ∫v */
    double r = 2.0e7, v = V0;
    R[0] = r;
    for (int k = 1; k < NMS; k++) {
        double t = (k - 1) * 1e-3;
        for (int s = 0; s < 10; s++) {
            double a0 = acc_at(t + s * 1e-4), a1 = acc_at(t + (s + 1) * 1e-4);
            double v1 = v + 0.5 * (a0 + a1) * 1e-4;
            r += 0.5 * (v + v1) * 1e-4;
            v = v1;
        }
        R[k] = r;
    }
    printf("Профиль: скорость %.0f -> %.0f м/с, ускорение до %.1fg, рывок %.1fg/с; доплер L1 %.0f -> %.0f Гц\n",
           V0, vel_at(T_END), 2 * J / G0, J / G0, -V0 / lam(), -vel_at(T_END) / lam());
    int ok2 = run(2);
    int ok3 = run(3);
    printf("ИТОГ: %s\n", ok3 ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    (void)ok2;
    return !ok3;
}
