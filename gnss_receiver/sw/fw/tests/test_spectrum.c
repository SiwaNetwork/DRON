/* Проверка обнаружения узкополосных помех (шум + две непрерывные помехи), уточнения их частоты
 * и настройки режекторного фильтра ПЛИС. */
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "gnss.h"
#include "spectrum.h"
#include "fpga.h"

static uint32_t regs[0x100];
static void cap_wr(uint32_t a, uint32_t v) { if (a < 0x100) regs[a] = v; }
static uint32_t cap_rd(uint32_t a) { return a < 0x100 ? regs[a] : 0; }

static uint8_t x4[49152];

/* шум + две непрерывные помехи (J/N, дБ), 2-битное квантование с АРУ (порог — 1σ суммы) */
static void make(double f1, double j1, double f2, double j2, unsigned seed)
{
    srand(seed);
    double a1 = sqrt(pow(10, j1 / 10)), a2 = sqrt(pow(10, j2 / 10));
    double s = sqrt(0.5 * (1 + a1 * a1 + a2 * a2));
    for (int i = 0; i < 49152; i++) {
        double u1 = (rand() + 1.0) / (RAND_MAX + 2.0), u2 = (rand() + 1.0) / (RAND_MAX + 2.0);
        double g = sqrt(-2 * log(u1)), re = g * cos(2 * GPI * u2) * 0.7071, im = g * sin(2 * GPI * u2) * 0.7071;
        double t = i / FS_HZ;
        re += a1 * cos(2 * GPI * f1 * t) + a2 * cos(2 * GPI * f2 * t + 1);
        im += a1 * sin(2 * GPI * f1 * t) + a2 * sin(2 * GPI * f2 * t + 1);
        int qi = (re < 0 ? 2 : 0) | (fabs(re) > s ? 1 : 0), qq = (im < 0 ? 2 : 0) | (fabs(im) > s ? 1 : 0);
        x4[i] = (uint8_t)(qi << 2 | qq);
    }
}

int main(void)
{
    static float psd[SPEC_N];
    const double f1 = -2.0e6, j1 = -10.0, f2 = 5.25e6, j2 = -18.0;      /* J/N, дБ */
    make(f1, j1, f2, j2, 3);
    spec_psd(x4, 49152, psd);
    cw_t cw[8];
    int n = spec_detect_cw(psd, 6.0, cw, 8), ok = n == 2;
    printf("Найдено помех: %d (ожидалось 2)\n", n);
    for (int k = 0; k < n; k++) {
        double ft = fabs(cw[k].f_hz - f1) < fabs(cw[k].f_hz - f2) ? f1 : f2, jt = ft == f1 ? j1 : j2;
        printf("  %+9.1f кГц (ист. %+9.1f), J/N %+5.1f дБ (ист. %+5.1f, после 2-битного АЦП)\n", cw[k].f_hz / 1e3, ft / 1e3, cw[k].jn_db, jt);
        if (fabs(cw[k].f_hz - ft) > 15e3 || fabs(cw[k].jn_db - jt) > 4) ok = 0;
    }
    /* режекторный фильтр: помеха J/N +5 дБ (гармоника 24 МГц на ПЧ) и слабая −12 дБ */
    const double f3 = 3141592.6, j3 = 5.0, f4 = -6.6e6, j4 = -12.0;
    make(f3, j3, f4, j4, 7);
    spec_psd(x4, 49152, psd);
    n = spec_detect_cw(psd, 6.0, cw, 8);
    for (int k = 0; k < n; k++) cw[k].f_hz = spec_refine_cw(x4, 49152, cw[k].f_hz);
    notch_cfg_t nc = {0};
    int on = notch_plan(&nc, 5, cw, n);
    fpga_wr_fn = cap_wr; fpga_rd_fn = cap_rd;
    notch_write(&nc, 0);
    uint32_t want = (uint32_t)(int64_t)llround(f3 / FS_HZ * 4294967296.0);
    double ferr = (double)(int32_t)(regs[R_NOTCH_DPHI(5)] - want) * FS_HZ / 4294967296.0;
    printf("Режекторный фильтр: найдено помех %d, канал 5 %s, f = %+.1f Гц (ист. %+.1f), ошибка %.1f Гц,\n"
           "  NOTCH_EN %03x, NOTCH_MU %08x\n", n, on ? "включён" : "выключен", nc.f_hz[5], f3, ferr,
           regs[R_NOTCH_EN], regs[R_NOTCH_MU]);
    if (!on || fabs(ferr) > 50 || regs[R_NOTCH_EN] != 0x20 || ((regs[R_NOTCH_MU] >> 20) & 0xF) != NOTCH_MU_DEF) ok = 0;
    /* слабая помеха (J/N −9 дБ) в канале 2: фильтр с дизерингом; канал 5 сохраняется */
    make(-1.5e6, -9.0, 9.0e6, -40.0, 9);
    spec_psd(x4, 49152, psd);
    n = spec_detect_cw(psd, 6.0, cw, 8);
    for (int k = 0; k < n; k++) cw[k].f_hz = spec_refine_cw(x4, 49152, cw[k].f_hz);
    on = notch_plan(&nc, 2, cw, n);
    notch_write(&nc, 1);
    printf("Слабая помеха: найдено %d, канал 2 %s, f = %+.1f Гц, J/N %.1f дБ, NOTCH_EN %06x\n", n,
           on ? "включён" : "выключен", nc.f_hz[2], nc.jn_db[2], regs[R_NOTCH_EN]);
    if (!on || fabs(nc.f_hz[2] + 1.5e6) > 50 || regs[R_NOTCH_EN] != 0x040124) ok = 0;
    printf("ИТОГ: %s\n", ok ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    return !ok;
}
