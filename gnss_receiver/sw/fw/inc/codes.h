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

/* Вторичный код (по одному чипу на период первичного кода): пилотные составляющие Galileo E1C —
 * CS25 (OS SIS ICD), E5a-Q — CS100 (свой для каждого КА, OS SIS ICD, п. 3.4.2), GPS L5Q — NH20
 * (IS-GPS-705); данные BeiDou B1I и B3I (КА MEO/IGSO, PRN 6–58) — NH20 (BDS-SIS-ICD-B1I, п. 4.2.2,
 * BDS-SIS-ICD-B3I, п. 4.2.2; период — один бит D1). bits[i] = 1 — чип −1.
 * Возвращает длину (0 — нет или не поддерживается). */
#define SEC_MAX_LEN 100
int sec_code(int sig, int prn, uint8_t *bits);

#endif
