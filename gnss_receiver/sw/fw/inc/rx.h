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

typedef struct {
    int      used, ch, sig, prn, fcn;
    trk_t    trk;
    union {                  /* навигационное сообщение — по системе сигнала канала */
        lnav_t   lnav;       /* GPS LNAV */
        glonav_t gnav;       /* ГЛОНАСС: строки */
        inav_t   inav;       /* Galileo I/NAV (E1-B) */
        bdsnav_t bnav;       /* BeiDou D1 (B1I, КА MEO/IGSO) */
    } msg;
    /* привязка времени излучения: на начало отсчёта ref_n время излучения ref_tow (по шкале КА) */
    int      tx_ok;
    uint64_t ref_n;
    uint64_t ref_code;           /* фаза кода без свёртки на ref_n минус дробная часть, чипы·2^32 */
    double   ref_tow;
    int      pair;               /* канал первой частоты <-> второй того же КА: индекс + 1 (0 — нет) */
    int      f2;                 /* канал второй частоты (без навигационных данных и измерений) */
    /* сглаживание кода по фазе несущей (фильтр Хэтча) */
    int      hs_n;               /* измерений в фильтре (0 — сброшен) */
    double   hs_p, hs_l, hs_t;   /* сглаженная ПД, фаза несущей (м) и время последнего измерения */
    double   hs_m;               /* эффективное число независимых измерений кода в сглаженной ПД */
} rx_ch_t;

typedef struct {
    rx_ch_t  ch[CORR_MAXCH];
    eph_t    eph[SYS_N][64];
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
} rx_t;

void   rx_init(rx_t *r);
/* поиск по снимкам и пуск каналов слежения с отсчёта t_start (для всех PRN сигнала sig: GPS 1–32,
 * Galileo 1–36, BeiDou 6–58 — MEO/IGSO; ГЛОНАСС — для всех литер −7…+6, номер КА — по строке 4).
 * Сигналы с навигационными данными: L1 C/A, G1CA, E1B, B1I */
int    rx_acquire(rx_t *r, const uint8_t *const *x4, const uint32_t *t0, int nsnap, int len, int sig,
                  uint64_t t_start, const acq_cfg_t *ac);
/* чтение результатов коррелятора, петли, навигационные данные */
void   rx_process(rx_t *r, uint64_t n_now);
/* измерения на отсчёт n_m и навигационное решение; 1 — решение получено */
int    rx_measure(rx_t *r, uint64_t n_m);
double rx_time(const rx_t *r, uint64_t n);          /* время приёмника (GPST sow, без поправки) */
/* момент (в тактах T96) ближайшей после отсчёта n_now секунды GPST по последнему решению;
 * qerr — ошибка квантования (с) */
int    rx_pps_next(const rx_t *r, uint64_t n_now, uint64_t *t96, double *qerr, double *sec);

#define PPS_DELAY_T96 0              /* калибровочная задержка 1PPS, такты 96 МГц */

#endif
