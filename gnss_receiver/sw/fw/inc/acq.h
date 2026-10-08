/* МГП-8: захват сигналов по снимку отсчётов (параллельный поиск по задержке кода с БПФ). */
#ifndef ACQ_H
#define ACQ_H
#include <stdint.h>

typedef struct {
    double dop_max;          /* диапазон поиска по доплеру ±, Гц */
    double dop_step;         /* шаг, Гц (0 — 1/(2T)) */
    int    nper;             /* число периодов кода (некогерентное накопление) */
    double thresh;           /* порог: пик / второй пик (вне ±1 чипа) */
} acq_cfg_t;

typedef struct {
    int    found;
    double code_phase;       /* фаза кода на первом отсчёте снимка, чипы */
    double doppler;          /* доплер, Гц */
    double metric;           /* пик / средний уровень */
    double ratio;            /* пик / второй пик (вне ±1 чипа) */
    double cn0;              /* оценка C/N0, дБГц */
} acq_res_t;

/* x4 — отсчёты одного ВЧ-канала, по байту на отсчёт {sI,mI,sQ,mQ}; n — число отсчётов */
int acq_search(const uint8_t *x4, int n, int sig, int prn, int fcn, const acq_cfg_t *cfg, acq_res_t *r);
/* некогерентное накопление по nsnap снимкам (t0 — номера первых отсчётов); фаза кода — на t0[0] */
int acq_search_multi(const uint8_t *const *x4, const uint32_t *t0, int nsnap, int n,
                     int sig, int prn, int fcn, const acq_cfg_t *cfg, acq_res_t *r);
/* Захват слабых сигналов (холодный старт до C/N0 ≈ 29 дБГц, ТЗ п. 5.2.3): потоковое некогерентное
 * накопление K периодов кода по последовательным снимкам для группы PRN одного сигнала.
 * Ячейки доплера перебираются по очереди: на каждую ячейку — свежие снимки (ПЛИС), общий для всех
 * PRN перенос на нулевую частоту и БПФ, для каждого PRN — умножение на спектр копии, обратное БПФ,
 * накопление |·|² со сдвигом на доплер кода. Решение — по отношению пика к среднему уровню (CFAR):
 * z = (пик / среднее − 1)·√K > порога. Память: буферы rep (nprn·nfft комплексных) и acc
 * (nprn·nfft float) выделяет вызывающий; на МК группа — до 8 PRN (384 КБ при nfft = 4096). */
#define AW_MAXPRN 32
typedef struct {
    int      sig, fcn, nprn, prn[AW_MAXPRN];
    double   dop_min, step;
    int      nd, K;               /* ячеек доплера, периодов кода на ячейку */
    double   thresh;              /* порог z (по умолчанию 6,5: Pлт ≈ 10^−3 на PRN при 50 ячейках) */
    int      L, nfft, Ns;
    int      d, k;                /* текущая ячейка доплера, накоплено периодов */
    uint32_t t_ref;               /* номер первого отсчёта первого снимка ячейки */
    void    *rep;                 /* cpx_t[nprn·nfft] — сопряжённые спектры копий */
    float   *acc;                 /* float[nprn·nfft] */
    /* лучшие ячейки по PRN */
    double   z[AW_MAXPRN], cp[AW_MAXPRN], dop[AW_MAXPRN];
    uint32_t tr[AW_MAXPRN];
} acq_weak_t;

/* подготовка (спектры копий); 0 — ошибка параметров */
int  acq_weak_init(acq_weak_t *w, int sig, int fcn, const int *prn, int nprn, double dop_min, double dop_max,
                   double step, int K, void *rep_buf, float *acc_buf);
/* добавить снимок (n отсчётов, первый — t0); 1 — перебор ячеек доплера завершён */
int  acq_weak_add(acq_weak_t *w, const uint8_t *x4, uint32_t t0, int n);
/* результат по PRN с индексом i: фаза кода на отсчёте r->... (t_ref — *tref), доплер — центр ячейки */
int  acq_weak_result(const acq_weak_t *w, int i, acq_res_t *r, uint32_t *tref);

/* снимок отсчётов ПЛИС: запуск (канал rf, len отсчётов, кратно 8, ≤ 65536; с отсчёта t, 0 — сразу)
 * и чтение (0 — ещё не готов); t0 — номер первого отсчёта (мл. 32 бит) */
void acq_snap_start(int rf, int len, uint32_t t);
int  acq_snap_read(int len, uint8_t *x4, uint32_t *t0);

#endif
