/* МГП-8: спектральный контроль ВЧ-каналов по снимку отсчётов (МК, по запросу и периодически). */
#include <math.h>
#include <string.h>
#include "gnss.h"
#include "fft.h"
#include "spectrum.h"
#include "acq.h"
#include "fpga.h"

/* k-я порядковая статистика: выбор Хоара без рекурсии (стек МК ограничен), массив переставляется */
static float kth(float *a, int n, int k)
{
    int lo = 0, hi = n - 1;
    while (lo < hi) {
        float p = a[(lo + hi) / 2];
        int i = lo, j = hi;
        while (i <= j) {
            while (a[i] < p) i++;
            while (a[j] > p) j--;
            if (i <= j) { float t = a[i]; a[i] = a[j]; a[j] = t; i++; j--; }
        }
        if (k <= j) hi = j;
        else if (k >= i) lo = i;
        else break;
    }
    return a[k];
}

void spec_psd(const uint8_t *x4, int n, float *psd)
{
    static cpx_t X[SPEC_N];
    static float w[SPEC_N];
    static double acc[SPEC_N];
    for (int k = 0; k < SPEC_N; k++) w[k] = (float)(0.5 - 0.5 * cos(2 * GPI * k / SPEC_N));
    memset(acc, 0, sizeof(acc));
    int nseg = 0;
    for (int s = 0; s + SPEC_N <= n; s += SPEC_N / 2, nseg++) {
        for (int k = 0; k < SPEC_N; k++) {
            unsigned x = snap_x(x4, s + k);
            int xi = ((x >> 2) & 1 ? 3 : 1) * ((x >> 3) & 1 ? -1 : 1);
            int xq = ((x & 1) ? 3 : 1) * ((x >> 1) & 1 ? -1 : 1);
            X[k].re = w[k] * xi; X[k].im = w[k] * xq;
        }
        fft(X, SPEC_N, 0);
        for (int k = 0; k < SPEC_N; k++) acc[k] += X[k].re * X[k].re + X[k].im * X[k].im;
    }
    static float tmp[SPEC_N];
    for (int k = 0; k < SPEC_N; k++) {                 /* сдвиг: нулевая частота — в центре */
        int j = (k + SPEC_N / 2) % SPEC_N;
        psd[k] = (float)(10 * log10(acc[j] / (nseg ? nseg : 1) + 1e-30));
        tmp[k] = psd[k];
    }
    float med = kth(tmp, SPEC_N, SPEC_N / 2);
    for (int k = 0; k < SPEC_N; k++) psd[k] -= med;
}

int spec_detect_cw(const float *psd, double thr_db, cw_t *cw, int max)
{
    int n = 0;
    for (int k = 2; k < SPEC_N - 2 && n < max; k++) {
        if (psd[k] < thr_db || psd[k] < psd[k - 1] || psd[k] < psd[k + 1]) continue;
        /* узкополосность: соседние ячейки через одну заметно ниже пика */
        if (psd[k - 2] > psd[k] - 6 && psd[k + 2] > psd[k] - 6) continue;
        double a = psd[k - 1], b = psd[k], c = psd[k + 1], den = a - 2 * b + c, d = den < 0 ? 0.5 * (a - c) / den : 0;
        cw[n].f_hz = ((k + d) - SPEC_N / 2) * FS_HZ / SPEC_N;
        /* мощность помехи относительно шума в полосе Fд: пик в ячейке + потери окна Ханна (1,76 дБ)
         * − отношение полосы ячейки к Fд */
        cw[n].jn_db = b + 1.76 + 10 * log10(1.5 / SPEC_N);
        n++;
    }
    return n;
}

/* |ДПФ|² снимка на частоте f */
static double dft_pow(const uint8_t *x4, int n, double f)
{
    double re = 0, im = 0, w = -2 * GPI * f / FS_HZ;
    double cr = 1, ci = 0, dr = cos(w), di = sin(w);
    for (int k = 0; k < n; k++) {
        unsigned x = snap_x(x4, k);
        int xi = ((x >> 2) & 1 ? 3 : 1) * ((x >> 3) & 1 ? -1 : 1);
        int xq = ((x & 1) ? 3 : 1) * ((x >> 1) & 1 ? -1 : 1);
        re += xi * cr - xq * ci;
        im += xi * ci + xq * cr;
        double t = cr * dr - ci * di;
        ci = cr * di + ci * dr; cr = t;
        if ((k & 1023) == 1023) {                    /* нормировка поворота (накопление ошибки) */
            double m = 1.0 / sqrt(cr * cr + ci * ci);
            cr *= m; ci *= m;
        }
    }
    return re * re + im * im;
}

double spec_refine_cw(const uint8_t *x4, int n, double f0)
{
    double best = f0, pb = -1;
    for (double f = f0 - 12e3; f <= f0 + 12e3; f += 250) {
        double p = dft_pow(x4, n, f);
        if (p > pb) { pb = p; best = f; }
    }
    const double g = 0.6180339887;
    double a = best - 250, b = best + 250;
    double c = b - g * (b - a), d = a + g * (b - a), pc = dft_pow(x4, n, c), pd = dft_pow(x4, n, d);
    while (b - a > 2.0) {
        if (pc > pd) { b = d; d = c; pd = pc; c = b - g * (b - a); pc = dft_pow(x4, n, c); }
        else         { a = c; c = d; pc = pd; d = a + g * (b - a); pd = dft_pow(x4, n, d); }
    }
    return 0.5 * (a + b);
}

int notch_plan(notch_cfg_t *nc, int rf, const cw_t *cw, int n)
{
    int best = -1;
    for (int k = 0; k < n; k++)
        if (cw[k].jn_db >= NOTCH_JN_MIN && (best < 0 || cw[k].jn_db > cw[best].jn_db)) best = k;
    nc->mu = (nc->mu & ~(0xFu << (4 * rf))) | ((uint32_t)NOTCH_MU_DEF << (4 * rf));
    if (best < 0) {
        nc->en &= ~(1u << rf);
        nc->dith &= ~(1u << rf);
        nc->dphi[rf] = 0; nc->f_hz[rf] = 0; nc->jn_db[rf] = 0;
        return 0;
    }
    nc->en |= 1u << rf;
    if (cw[best].jn_db < NOTCH_JN_DITH) nc->dith |= 1u << rf;
    else nc->dith &= ~(1u << rf);
    nc->f_hz[rf] = cw[best].f_hz;
    nc->jn_db[rf] = cw[best].jn_db;
    nc->dphi[rf] = (uint32_t)(int64_t)llround(cw[best].f_hz / FS_HZ * 4294967296.0);
    return 1;
}

void notch_write(const notch_cfg_t *nc, int snap_raw)
{
    fpga_wr(R_NOTCH_MU, nc->mu);
    for (int k = 0; k < 8; k++) fpga_wr(R_NOTCH_DPHI(k), nc->dphi[k]);
    fpga_wr(R_NOTCH_EN, (nc->en & 0xFFu) | ((nc->dith & 0xFFu) << 16) | (snap_raw ? NOTCH_SNAP_RAW : 0u));
}
