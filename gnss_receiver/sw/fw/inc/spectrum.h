/* МГП-8: спектр ВЧ-канала по снимку отсчётов и обнаружение узкополосных помех (ТЗ п. 5.2.11). */
#ifndef SPECTRUM_H
#define SPECTRUM_H
#include <stdint.h>

#define SPEC_N 1024              /* точек БПФ (разрешение 23,4 кГц при 24 МГц) */

typedef struct { double f_hz; double jn_db; } cw_t;

/* спектральная плотность (метод Уэлча, окно Ханна, перекрытие 50 %), дБ относительно медианы;
 * psd[SPEC_N], частоты −Fд/2..+Fд/2 */
void spec_psd(const uint8_t *x4, int n, float *psd);
/* узкополосные помехи: пики выше порога thr_db над медианным уровнем; возвращает число найденных */
int  spec_detect_cw(const float *psd, double thr_db, cw_t *cw, int max);
/* уточнение частоты помехи по всему снимку: максимум |ДПФ| в окрестности f0 ± 12 кГц
 * (сетка 250 Гц, затем золотое сечение), погрешность — единицы герц */
double spec_refine_cw(const uint8_t *x4, int n, double f0);

/* режекторный фильтр ПЛИС (регистры NOTCH_*, fpga/rtl/notch.v) */
#define NOTCH_JN_MIN  (-20.0)    /* подавляются помехи с J/N не ниже, дБ (sim/out/notch.md) */
#define NOTCH_JN_DITH (-5.0)     /* дизеринг — при J/N ниже, дБ */
#define NOTCH_MU_DEF  8          /* постоянная сглаживания 2^8 отсчётов (≈ 10,7 мкс) */
typedef struct {
    uint32_t en;                 /* маска каналов */
    uint32_t dith;               /* маска дизеринга */
    uint32_t mu;                 /* 4 бита на канал */
    uint32_t dphi[8];
    double   f_hz[8], jn_db[8];
} notch_cfg_t;
/* выбор помехи для канала rf: наиболее мощная с J/N ≥ NOTCH_JN_MIN (частота — уточнённая),
 * дизеринг — при J/N < NOTCH_JN_DITH; нет такой помехи — фильтр канала выключается.
 * Возвращает 1, если фильтр канала включён. */
int  notch_plan(notch_cfg_t *nc, int rf, const cw_t *cw, int n);
/* запись конфигурации в ПЛИС (snap_raw — снимок до фильтра) */
void notch_write(const notch_cfg_t *nc, int snap_raw);

#endif
