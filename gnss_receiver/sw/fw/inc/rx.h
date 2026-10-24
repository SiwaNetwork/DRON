/* МГП-8: управление приёмником — каналы, навигационные данные, измерения, решение, 1PPS. */
#ifndef RX_H
#define RX_H
#include <stdint.h>
#include "gnss.h"
#include "corr.h"
#include "track.h"
#include "lnav.h"
#include "glonav.h"
#include "inav.h"
#include "bdsnav.h"
#include "eph.h"
#include "pvt.h"
#include "acq.h"

typedef union {             /* навигационное сообщение — по системе сигнала канала */
    lnav_t   lnav;           /* GPS LNAV */
    glonav_t gnav;           /* ГЛОНАСС: строки */
    inav_t   inav;           /* Galileo I/NAV (E1-B) */
    bdsnav_t bnav;           /* BeiDou D1 (B1I, КА MEO/IGSO) */
} rx_msg_t;

/* декодеров сообщений меньше, чем каналов: они нужны только каналам первой частоты (в
 * двухчастотном режиме — половина каналов), а память МК ограничена (ПЗ 4.5.3) */
#define RX_NMSG 56

/* таблица эфемерид: по системам SYS_* номера КА 0..N−1 (ГЛОНАСС — номер в группировке, QZSS —
 * PRN−192, SBAS — PRN−119); в сумме RX_NEPH */
#define RX_EPH_N {33, 32, 37, 64, 11, 15, 40}
#define RX_NEPH  232

typedef struct {
    int      used, ch, sig, prn, fcn;
    trk_t    trk;
    rx_msg_t *msg;           /* декодер из пула rx_t.msg (у канала второй частоты — нет) */
    /* привязка времени излучения: на начало отсчёта ref_n время излучения ref_tow (по шкале КА) */
    int      tx_ok;
    uint64_t ref_n;
    uint64_t ref_code;           /* фаза кода без свёртки на ref_n минус дробная часть, чипы·2^32 */
    double   ref_tow;
    int      pair;               /* канал первой частоты <-> второй того же КА: индекс + 1 (0 — нет) */
    int      f2;                 /* канал второй частоты (без навигационных данных и измерений) */
    int      xc;                 /* слабый сигнал: 1 — проверен на взаимную корреляцию (rx_xcheck) */
    double   xc_t;               /* время слежения при синхронизации по битам (0 — ещё нет), с */
    /* сглаживание кода по фазе несущей (фильтр Хэтча) */
    int      hs_n;               /* измерений в фильтре (0 — сброшен) */
    double   hs_p, hs_l, hs_t;   /* сглаженная ПД, фаза несущей (м) и время последнего измерения */
    double   hs_m;               /* эффективное число независимых измерений кода в сглаженной ПД */
} rx_ch_t;

typedef struct {
    rx_ch_t  ch[CORR_MAXCH];
    eph_t    eph[RX_NEPH];        /* эфемериды по системам и номерам КА — доступ через rx_eph() */
    double   ion[8];
    int      ion_ok, week, dt_ls;
    /* шкала приёмника: t_rx(n) = t0_tow + (n − t0_n)/fs */
    int      time_ok;
    uint64_t t0_n;
    double   t0_tow;
    /* последнее решение */
    sol_t    sol;
    uint64_t sol_n;
    obs_t    obs[PVT_MAXOBS];
    int      nobs;
    pvt_cfg_t pcfg;
    trk_cfg_t tcfg;
    int      n_sol;
    int      dual;               /* двухчастотный режим: по каждому каналу первой частоты (L1 C/A, G1,
                                    E1-B, B1I) запускается канал второй частоты sig2[система] */
    int      sig2[SYS_N];        /* сигнал второй частоты (−1 — нет); по умолчанию L2CM, G2CA, E5a-Q,
                                    B3I; L5Q для GPS — при настроенном ВЧ-канале L5 */
    double   smooth;             /* окно сглаживания кода по фазе несущей, с (0 — без сглаживания) */
    rx_msg_t msg[RX_NMSG];       /* пул декодеров сообщений */
    uint8_t  msg_busy[RX_NMSG];
    /* блокировка (на МК — запрет прерывания ПЛИС, в котором выполняется rx_process): каналы и
     * пул декодеров общие у поиска (фон) и слежения; NULL — без блокировки (проверки на ПК) */
    void   (*lock)(int on);
} rx_t;

void   rx_init(rx_t *r);
eph_t *rx_eph(rx_t *r, int sys, int prn);   /* ячейка эфемерид КА; NULL — номер вне таблицы */
/* поиск по снимкам и пуск каналов слежения с отсчёта t_start (для всех PRN сигнала sig: GPS 1–32,
 * Galileo 1–36, BeiDou 6–58 — MEO/IGSO; ГЛОНАСС — для всех литер −7…+6, номер КА — по строке 4).
 * Сигналы с навигационными данными: L1 C/A, G1CA, E1B, B1I */
int    rx_acquire(rx_t *r, const uint8_t *const *x4, const uint32_t *t0, int nsnap, int len, int sig,
                  uint64_t t_start, const acq_cfg_t *ac);
/* поиск одного КА q (PRN; ГЛОНАСС — литера −7…+6) и пуск канала сразу после поиска (на МК поиск
 * долгий — фаза кода переносится от снимка на момент пуска). 1 — запущен, 0 — уже в слежении
 * или не найден, −1 — нет свободного канала или декодера */
int    rx_acquire_one(rx_t *r, const uint8_t *const *x4, const uint32_t *t0, int nsnap, int len, int sig,
                      int q, const acq_cfg_t *ac);
int    rx_sig_range(int sig, int *q0, int *q1);     /* диапазон q для rx_acquire_one; число номеров */
int    rx_tracked(const rx_t *r, int sig, int q);   /* 1 — КА q сигнала sig в слежении */
/* пуск канала по результату внешнего поиска (ускоритель ПЛИС, acq_hw_*): доплер и фаза кода на
 * отсчёт tref (мл. 32 бит); weak — втягивание слабого сигнала (trk_cfg_t.weak). Коды возврата —
 * как у rx_acquire_one */
int    rx_start(rx_t *r, int sig, int q, const acq_res_t *a, uint32_t tref, int weak);
/* проверка каналов слабого сигнала на ложный захват взаимно-корреляционного пика сильного КА
 * (из фона; до проверки канал не даёт измерений): число освобождённых каналов */
int    rx_xcheck(rx_t *r);
/* чтение результатов коррелятора, петли, навигационные данные */
void   rx_process(rx_t *r, uint64_t n_now);
/* измерения на отсчёт n_m и навигационное решение; 1 — решение получено */
int    rx_measure(rx_t *r, uint64_t n_m);
/* то же по частям: rx_latch — измерения на отсчёт n_m в r->obs (сглаживание, веса; на МК — в
 * прерывании ПЛИС сразу после rx_process: «зеркало» NCO отнесено к моменту, близкому к n_m);
 * число измерений с эфемеридами, −1 — нет шкалы времени. rx_solve — решение по r->obs */
int    rx_latch(rx_t *r, uint64_t n_m);
int    rx_solve(rx_t *r, uint64_t n_m);
double rx_time(const rx_t *r, uint64_t n);          /* время приёмника (GPST sow, без поправки) */
/* момент (в тактах T96) ближайшей после отсчёта n_now секунды GPST по последнему решению;
 * qerr — ошибка квантования (с) */
int    rx_pps_next(const rx_t *r, uint64_t n_now, uint64_t *t96, double *qerr, double *sec);

#define PPS_DELAY_T96 0              /* калибровочная задержка 1PPS, такты 96 МГц */

#endif
