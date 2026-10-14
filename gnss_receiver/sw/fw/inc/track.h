/* МГП-8: слежение за сигналом (петли ФАП/ЧАП/ССЗ, оценка C/N0, синхронизация по битам). */
#ifndef TRACK_H
#define TRACK_H
#include <stdint.h>
#include "corr.h"
#include "codes.h"

enum { TRK_IDLE = 0, TRK_PULLIN, TRK_LOCK, TRK_LOST };

typedef struct {
    double pll_bw;           /* Гц, втягивание */
    double pll_bw_lock;      /* Гц, после захвата фазы */
    double fll_bw;           /* Гц, поддержка ФАП при втягивании */
    double fll_bw_lock;      /* Гц, поддержка ФАП после захвата */
    double dll_bw;           /* Гц */
    double spacing;          /* смещение E/L, чипы */
    double fll_time;         /* время работы ЧАП, с */
    /* длительное накопление (слабые сигналы): после синхронизации по битам при C/N0 ниже
     * long_cn0 петли обновляются раз в бит (20 периодов, когерентно), полосы — *_long */
    double long_cn0;         /* дБГц; 0 — не применять, > 60 — всегда после синхронизации */
    double pll_bw_long, dll_bw_long;
    /* повторный захват: при срыве в режиме длительного накопления канал до coast_time с
     * ведёт NCO по прогнозу (частота и её скорость изменения) и обнаруживает появление сигнала */
    double coast_time;       /* с */
    /* ФАП 3-го порядка в захвате (динамика ТЗ п. 5.2.10: 4g, рывок 2g/с) */
    int    pll_order;        /* 2 или 3 */
    double pll_bw3;          /* Гц */
    double reacq_thr;        /* порог мощности интервала относительно шума */
} trk_cfg_t;

typedef struct {
    int      state;
    int      ch;             /* аппаратный канал */
    int      sig, prn, fcn;
    double   T;              /* интервал накопления, с */
    double   f_if;           /* номинальная ПЧ, Гц */
    double   fc;             /* несущая, Гц */
    double   f0;             /* начальная частота NCO, Гц */
    double   f_carr;         /* частота NCO несущей (ПЧ + доплер), Гц */
    double   f_code;         /* частота кода, чип/с */
    double   int_f;
    double   a2, w2, wf, dll_k, spacing, fll_time, pll_bw_lock, fll_bw_lock, t_lost;
    double   dll_hw;             /* полуширина главного пика корреляции, чипы (TDM — 0,5) */
    double   pI, pQ;
    int      have_prev;
    double   t;              /* время слежения, с */
    /* C/N0 (метод NWPR, 20 интервалов) */
    double   nb_i, nb_q, nb_a, wbp;
    int      nbn;
    double   cn0;            /* дБГц */
    double   lock;           /* индикатор захвата фазы cos 2Δφ (фильтр.) */
    /* синхронизация по битам данных (L1 C/A: 20 мс) */
    int      bit_len;        /* интервалов в бите (0 — нет данных) */
    int      bit_hist[20];
    int      bit_sync;       /* 1 — граница найдена */
    int      bit_pos;        /* номер интервала внутри бита */
    double   bit_acc;
    int      prev_sign;
    uint64_t n_epoch;        /* номер интервала накопления с начала слежения */
    void   (*on_bit)(void *ctx, int bit, uint64_t n_end);
    void    *ctx;
    double   last_perr;
    /* длительное накопление */
    double   long_cn0, pll_bw_long, dll_bw_long;
    int      ncoh;           /* периодов на обновление петель (1, bit_len или ≈ 20 мс для пилота) */
    double   acc[6];         /* E, P, L (I, Q) за интервал петли */
    int      nacc;
    /* вторичный код: синхронизация по знакам точного отвода */
    uint8_t  sec[SEC_MAX_LEN];
    int      sec_len, sec_sync, sec_pos, sec_sgn, sec_n;
    uint8_t  sec_hist[SEC_MAX_LEN];  /* знаки точного отвода за последний период (1 — минус) */
    /* прогноз и повторный захват */
    double   coast_time, reacq_thr;
    double   noise1;         /* мощность шума результата одного периода (оценка) */
    double   f_lp, f_rate;   /* сглаженная частота NCO (τ ≈ 1 с) и её скорость, Гц/с */
    double   f_1s, t_1s;     /* для оценки скорости */
    double   f_coast, t_coast;
    unsigned det_hist;       /* обнаружения сигнала в последних 8 интервалах */
    int      n_reacq;        /* число повторных захватов */
    int      low_cnt;        /* интервалов подряд с индикатором захвата ниже порога */
    double   t_pull;         /* начало повторного втягивания */
    int      pll_order;
    double   pll_bw3, w3, a3w, b3w, x1;   /* ФАП 3-го порядка: ω0³, a3·ω0², b3·ω0, интегратор, Гц/с */
} trk_t;

void trk_default_cfg(trk_cfg_t *c);
/* начальные условия: доплер (Гц), фаза кода (чипы) на отсчёт t_start */
void trk_start(trk_t *k, int ch, int sig, int prn, int fcn, double doppler, double code_phase,
               uint64_t t_start, const trk_cfg_t *cfg);
/* обработка результата интервала; пишет новые частоты в канал ПЛИС */
void trk_update(trk_t *k, const corr_dump_t *d);
double trk_doppler(const trk_t *k);
/* доплер по сглаженной частоте NCO (τ = 1 с, с поправкой на скорость изменения) — без шума ФАП;
 * для пуска сопряжённых каналов (L2 по L1) */
double trk_doppler_smooth(const trk_t *k);

#endif
