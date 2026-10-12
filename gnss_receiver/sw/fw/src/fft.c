/* МГП-8: БПФ по основанию 2 с прореживанием по времени (на месте). */
#include <math.h>
#include "fft.h"

void fft(cpx_t *x, int n, int inverse)
{
    for (int i = 1, j = 0; i < n; i++) {             /* двоично-инверсная перестановка */
        int bit = n >> 1;
        for (; j & bit; bit >>= 1) j ^= bit;
        j ^= bit;
        if (i < j) { cpx_t t = x[i]; x[i] = x[j]; x[j] = t; }
    }
    for (int len = 2; len <= n; len <<= 1) {
        double ang = (inverse ? 2.0 : -2.0) * 3.14159265358979323846 / len;
        cpx_t wl = {(float)cos(ang), (float)sin(ang)};
        for (int i = 0; i < n; i += len) {
            double wr = 1.0, wi = 0.0;
            for (int k = 0; k < len / 2; k++) {
                cpx_t *a = &x[i + k], *b = &x[i + k + len / 2];
                float tr = (float)(b->re * wr - b->im * wi), ti = (float)(b->re * wi + b->im * wr);
                b->re = a->re - tr; b->im = a->im - ti;
                a->re += tr; a->im += ti;
                double nwr = wr * wl.re - wi * wl.im;
                wi = wr * wl.im + wi * wl.re;
                wr = nwr;
            }
        }
    }
}
