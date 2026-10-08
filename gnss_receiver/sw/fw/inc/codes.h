/* МГП-8: дальномерные коды (первичные, без поднесущей и уплотнения). */
#ifndef CODES_H
#define CODES_H
#include <stdint.h>

#define CODE_MAX_LEN 10230
#define CODE_MAX_BYTES ((CODE_MAX_LEN + 7) / 8)

/* Код сигнала sig (SIG_*) для PRN prn (для ГЛОНАСС — литера, код общий).
 * Результат — упакованные биты, 1 = чип −1, младший бит байта — первый чип.
 * Возвращает длину кода в чипах или 0, если код недоступен. */
int code_gen(int sig, int prn, uint8_t *bits);

static inline int code_bit(const uint8_t *bits, int i) { return (bits[i >> 3] >> (i & 7)) & 1; }

#endif
