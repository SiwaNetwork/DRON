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
    /* вторичный код пилотной составляющей: синхронизация по знакам точного отвода */
    uint8_t  sec[SEC_MAX_LEN];
    int      sec_len, sec_sync, sec_pos, sec_sgn, sec_n;
    double   sec_hist[SEC_MAX_LEN];
} trk_t;

void trk_default_cfg(trk_cfg_t *c);
/* начальные условия: доплер (Гц), фаза кода (чипы) на отсчёт t_start */
void trk_start(trk_t *k, int ch, int sig, int prn, int fcn, double doppler, double code_phase,
               uint64_t t_start, const trk_cfg_t *cfg);
/* обработка результата интервала; пишет новые частоты в канал ПЛИС */
void trk_update(trk_t *k, const corr_dump_t *d);
double trk_doppler(const trk_t *k);

#endif
