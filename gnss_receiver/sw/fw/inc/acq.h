/* МГП-8: захват сигналов по снимку отсчётов (параллельный поиск по задержке кода с БПФ). */
#ifndef ACQ_H
#define ACQ_H
#include <stddef.h>
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

/* Снимок отсчётов одного ВЧ-канала хранится упакованным, как в памяти снимка ПЛИС: два 4-битных
 * отсчёта {sI,mI,sQ,mQ} в байте, отсчёт i — в байте i/2, чётный — в младшей тетраде. */
#define SNAP_BYTES(n) ((size_t)(n) / 2)
static inline unsigned snap_x(const uint8_t *x, long i) { return (x[i >> 1] >> ((i & 1) << 2)) & 15u; }
static inline void snap_put(uint8_t *x, long i, unsigned v)
{
    x[i >> 1] = (uint8_t)((x[i >> 1] & (0xF0u >> ((i & 1) << 2))) | ((v & 15u) << ((i & 1) << 2)));
}

/* x4 — упакованный снимок (snap_x); n — число отсчётов */
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

/* Захват на ускорителе ПЛИС (fpga/rtl/acq_fft.v, ТЗ п. 5.2.4): то же накопление K периодов и то
 * же решение, что acq_weak_*, но поток отсчётов обрабатывается в ПЛИС без снимков и пропусков.
 * Запуск — один PRN и до 7 ячеек доплера через 1/T (сдвиг спектра на целое число ячеек БПФ);
 * сетка с шагом 1/(qT) — q классами вычетов. МК загружает спектр копии, задаёт частоту переноса
 * (центральная ячейка запуска) и доплер кода ячеек, по завершении читает пик, его ячейку и сумму
 * накопителя. Сигналы: без BOC/TDM, период 1 мс, код ≤ 1024 чипов (L1 C/A, L1OF, L2OF). */
#define AH_MAXRUN 64
typedef struct {
    int      sig, fcn, rf, nprn, prn[AW_MAXPRN];
    double   dop_min, step;
    int      nd, q, K;            /* ячеек доплера, классов вычетов, периодов кода */
    double   thresh;              /* порог z (6,5, как acq_weak_*) */
    int      L, Ns, nper;
    int      nrun, run_d0[AH_MAXRUN], run_ng[AH_MAXRUN];   /* запуски: первая ячейка, ячеек (шаг q) */
    int      ip, ir, st, nfail;   /* текущий PRN, запуск, состояние; отказов в пуске */
    double   z[AW_MAXPRN], cp[AW_MAXPRN], dop[AW_MAXPRN];
    uint32_t tr[AW_MAXPRN];
} acq_hw_t;

/* подготовка (шаг округляется до 1/(qT)); 0 — сигнал или параметры не поддерживаются */
int  acq_hw_init(acq_hw_t *h, int sig, int fcn, const int *prn, int nprn, double dop_min, double dop_max,
                 double step, int K);
/* шаг конечного автомата (из основного цикла или по IRQ_ACQ): 1 — перебор завершён */
int  acq_hw_poll(acq_hw_t *h);
int  acq_hw_result(const acq_hw_t *h, int i, acq_res_t *r, uint32_t *tref);
/* длительность запуска, с */
double acq_hw_run_time(const acq_hw_t *h);

/* снимок отсчётов ПЛИС: запуск (канал rf, len отсчётов, кратно 8, ≤ 65536; с отсчёта t, 0 — сразу)
 * и чтение (0 — ещё не готов); t0 — номер первого отсчёта (мл. 32 бит) */
void acq_snap_start(int rf, int len, uint32_t t);
int  acq_snap_read(int len, uint8_t *x4, uint32_t *t0);

#endif
