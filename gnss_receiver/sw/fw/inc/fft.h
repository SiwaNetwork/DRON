/* МГП-8: БПФ по основанию 2 (комплексное, float) — на МК и на ПК (без библиотек изготовителя). */
#ifndef FFT_H
#define FFT_H
typedef struct { float re, im; } cpx_t;
/* n — степень 2 (≤ 65536); inverse ≠ 0 — обратное преобразование (без деления на n) */
void fft(cpx_t *x, int n, int inverse);
#endif
