/* МГП-8: драйвер аппаратного коррелятора (ПЛИС) и «зеркало» NCO.
 *
 * ПО ведёт точную целочисленную копию состояния NCO каждого канала: фаза кода (чипы·2^32) и
 * накопленная доплеровская фаза несущей (циклы·2^32, 64 бит; шаг NCO минус номинальный шаг ПЧ). Шаги NCO меняются только в известные моменты
 * (в конце группы из 4 отсчётов, где произошёл сброс), поэтому копия совпадает с ПЛИС точно,
 * и фазы кода/несущей на любой отсчёт (эпоха измерений) вычисляются без чтения ПЛИС. */
#ifndef CORR_H
#define CORR_H
#include <stdint.h>
#include "gnss.h"

#define CORR_MAXCH (7 * 16)

typedef struct {
    int      used;
    int      sig, prn, fcn;
    uint32_t ctrl;            /* CTRL без бита en */
    uint32_t L;               /* длина кода, чипов */
    uint32_t nint;            /* эпох кода в интервале накопления */
    /* зеркало NCO */
    uint64_t t_ref;           /* отсчёт, к началу которого отнесено состояние */
    uint64_t code_fx;         /* фаза кода, чипы·2^32, в [0, L·2^32) */
    int64_t  dop_fx;          /* доплеровская фаза несущей, циклы·2^32 (без номинальной ПЧ) */
    uint32_t code_rate, carr_rate;
    uint32_t if_rate;         /* шаг NCO номинальной ПЧ сигнала */
    int      pend;
    uint32_t code_rate_n, carr_rate_n;
    uint64_t last_dump;       /* отсчёт последнего сброса */
} corr_ch_t;

typedef struct {
    int32_t  EI, EQ, PI, PQ, LI, LQ;
    uint64_t n;               /* номер последнего отсчёта интервала (полный, восстановлен) */
} corr_dump_t;

extern corr_ch_t CORR[CORR_MAXCH];
extern int corr_nch;          /* число аппаратных каналов */

int      corr_init(void);                     /* возвращает число каналов */
int      corr_alloc(int sig);                 /* занять свободный канал, −1 — нет */
void     corr_free(int ch);
int      corr_load_code(int ch, int sig, int prn);
/* настройка выключенного канала: фазы задаются на отсчёт t_start (кратен 4) */
void     corr_config(int ch, int sig, int prn, int fcn, int nint, double spacing_chips,
                     double f_carr_hz, double code_cps, double code_phase_chips, double carr_phase_cyc,
                     uint64_t t_start);
/* одновременный пуск каналов (маска по каналам) с отсчёта t_start */
void     corr_start(const int *chs, int n, uint64_t t_start);
void     corr_stop(int ch);
/* новые частоты (вступают в силу в конце группы следующего сброса) */
void     corr_set_rates(int ch, double f_carr_hz, double code_cps);
/* прочитать результат готового канала; 1 — прочитан */
int      corr_read(int ch, corr_dump_t *d, uint64_t n_now);
/* фаза кода (чипы, по модулю L) и доплеровская фаза несущей (циклы) на начало отсчёта n ≥ t_ref */
void     corr_phase_at(int ch, uint64_t n, double *code_chips, double *carr_cyc);
uint32_t corr_rate_carr(double f_hz);
uint32_t corr_rate_code(double cps);
uint64_t corr_time_now(void);                 /* текущий номер отсчёта (по T96) */

#endif
