/* МГП-8: декодирование навигационного сообщения GPS LNAV (IS-GPS-200, разд. 20.3). */
#ifndef LNAV_H
#define LNAV_H
#include <stdint.h>
#include "eph.h"

typedef struct {
    int      prn;
    uint8_t  win[38];        /* последние 302 бита (D29*, D30* предыдущего слова + 300 бит) */
    int      nbit;
    int      sync;           /* найдена граница подкадра */
    int      pol;            /* полярность (1 — инверсия) */
    uint8_t  sf[5][30];      /* данные подкадров 1..5 (по 24 бита слова, без чётности) */
    int      have;           /* маска принятых подкадров 1..3 одной редакции */
    eph_t    eph;            /* последние полные эфемериды */
    int      eph_new;
    double   ion[8];         /* параметры Клобучара */
    int      ion_ok;
    double   utc_a0, utc_a1; int dt_ls, ok_utc;
    /* привязка ко времени: момент конца последнего подкадра (номер отсчёта) и TOW его конца */
    uint64_t sf_end_n;
    double   sf_end_tow;
    int      week;
    int      tow_ok;
    int      n_sf, n_parity_err;
} lnav_t;

void lnav_init(lnav_t *l, int prn);
/* очередной бит данных (0/1, полярность не определена); n_end — номер последнего отсчёта бита.
 * Возвращает номер принятого подкадра (1..5) или 0. */
int  lnav_bit(lnav_t *l, int bit, uint64_t n_end);

/* кодирование (для проверок и имитатора): подкадр 1..3 из эфемерид, 300 бит с чётностью;
 * d29, d30 — последние биты предыдущего подкадра; tow — TOW (×6 с) начала следующего подкадра */
void lnav_encode(const eph_t *e, int sfid, int tow, int d29, int d30, uint8_t bits[300]);

#endif
