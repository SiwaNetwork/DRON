/* МГП-8: собственный двоичный протокол (ТЗ п. 5.2.12): решение, сырые измерения, эфемериды,
 * состояние каналов, телеметрия (ИТМ).
 * Кадр: 0x4D 0x38 («M8»), класс (1 байт), идентификатор (1), длина данных (2, LE), данные,
 * CRC-16/CCITT (полином 0x1021, начальное 0xFFFF) по байтам от класса до конца данных (2, LE).
 * Числа — little-endian; вещественные — IEEE 754 (f32, f64).
 * Сообщения (класс/идентификатор: поля):
 *   01/01 решение: u16 неделя, f64 время приёма GPST, u8 решение, u8 КА, u8 систем, u8 резерв,
 *         f64 x, y, z (ECEF, м), f32 vx, vy, vz (м/с), f64 смещения шкал GPS, ГЛОНАСС, Galileo,
 *         BeiDou (м), f32 дрейф (м/с), u16 PDOP, HDOP, VDOP, TDOP (×100)
 *   02/01 измерения: u16 неделя, f64 время приёма, u8 n; n записей по 31 байт: u8 система,
 *         u8 КА, u8 сигнал, i8 литера, f64 ПД (м), f64 фаза (циклы), f32 доплер (Гц),
 *         u16 C/N0 (×100), u32 время слежения за фазой (мс), u8 признаки
 *   02/02 эфемериды: u8 система, u8 КА, i8 литера, u8 здоровье, u16 неделя, u16 IODE, 32 × f64:
 *         toc, toe, af0, af1, af2, tgd, sqrtA, e, i0, Ω0, ω, M0, Δn, Ω̇, i̇, Cuc, Cus, Crc, Crs,
 *         Cic, Cis, x, y, z, vx, vy, vz, ax, ay, az (ПЗ-90, м), −τn, γn
 *   03/01 каналы: u8 n; n записей по 12 байт: u8 канал, u8 сигнал, u8 КА, i8 литера,
 *         u8 состояние, u8 признаки, u16 C/N0 (×100), f32 доплер (Гц)
 *   04/01 ИТМ: f32 температура МК, f32 ток антенны (мА), u8 состояние антенны, u8 LD MAX2771,
 *         u8 NOTCH_EN, u8 дизеринг, u16 напряжение питания (мВ), u32 время работы (с),
 *         u8 ПЛИС загружена, u8 ФАПЧ ПЛИС
 *   10/xx загрузчик (обновление ПО МК) — inc/bootp.h */
#ifndef PROTO_H
#define PROTO_H
#include <stdint.h>
#include "pvt.h"
#include "eph.h"

#define MBP_SYNC1 0x4D
#define MBP_SYNC2 0x38
enum { MBP_NAV = 0x01, MBP_RAW = 0x02, MBP_CH = 0x03, MBP_TM = 0x04, MBP_BOOT = 0x10 };
enum { MBP_NAV_PVT = 0x01, MBP_RAW_MEAS = 0x01, MBP_RAW_EPH = 0x02, MBP_CH_STAT = 0x01, MBP_TM_STAT = 0x01 };
#define MBP_MAXLEN 2048

typedef struct {                 /* сырое измерение */
    uint8_t sys, prn, sig;
    int8_t  fcn;
    double  pr, cp;              /* м, циклы (0 — нет) */
    float   dop;                 /* Гц */
    float   cn0;                 /* дБГц */
    float   lock;                /* время непрерывного слежения за фазой, с */
    uint8_t flags;               /* [0] неразрешённая полуцикловая неоднозначность */
} mbp_meas_t;

typedef struct {                 /* состояние канала */
    uint8_t ch, sig, prn, state;
    int8_t  fcn;
    uint8_t flags;               /* [0] синхр. по битам, [1] время излучения, [2] вторичный код, [3] длит. накопление */
    float   cn0, dop;
} mbp_ch_t;

typedef struct {                 /* телеметрия (ИТМ) */
    float    t_mcu;              /* °С */
    float    ant_ma;             /* ток антенны, мА */
    uint8_t  ant_state;          /* 0 — выкл., 1 — норма, 2 — обрыв, 3 — КЗ */
    uint8_t  max_ld;             /* захват ФАПЧ MAX2771 по каналам */
    uint8_t  notch_en, notch_dith;
    uint16_t vin_mv;
    uint32_t uptime_s;
    uint8_t  fpga_ok, pll_lock;
} mbp_tm_t;

uint16_t mbp_crc16(const uint8_t *b, int n);
/* оформление кадра: данные (plen байт) уже записаны с buf + 6; возвращает длину кадра */
int mbp_frame(uint8_t *buf, int cls, int id, int plen);
/* сообщения; возвращают длину кадра */
int mbp_pvt(uint8_t *buf, int week, const sol_t *s);
int mbp_meas(uint8_t *buf, int week, double tow, const mbp_meas_t *m, int n);
int mbp_eph(uint8_t *buf, const eph_t *e);
int mbp_ch(uint8_t *buf, const mbp_ch_t *c, int n);
int mbp_tm(uint8_t *buf, const mbp_tm_t *t);
/* разбор кадра в начале буфера: 1 — кадр верный (cls, id, данные), 0 — неполный, −1 — ошибка;
 * *used — число байт кадра (или пропускаемых байт при ошибке) */
int mbp_parse(const uint8_t *b, int n, int *cls, int *id, const uint8_t **pl, int *plen, int *used);

#endif
