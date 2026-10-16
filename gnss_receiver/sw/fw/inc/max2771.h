/* МГП-8: драйвер ВЧ-приёмников MAX2771 (8 шт., каналы A–H) — настройка по SPI через ПЛИС.
 *
 * Обмен — регистры ПЛИС SPI_CMD/SPI_WDATA/SPI_RDATA (fpga/rtl/max_spi.v): кадр MAX2771 —
 * заголовок {адрес[11:0], R/W, 000} и 32 бита данных. Регистры MAX2771 0x0–0xA меняются
 * чтением-изменением-записью: зарезервированные биты (в т. ч. CONF1[29:22] = 11111010)
 * сохраняются, записанные поля проверяются обратным чтением.
 *
 * Значения полей — по конфигурации PocketSDR FE 8CH (pocket_L1G1L2G2L5E5bB3L6_24MHz.conf, те же
 * гетеродины, целочисленный синтезатор от ТКГ 24 МГц) с отличием схемы МГП-8 (ПЗ 4.2): каналы
 * C–H подключены к входам нижнего диапазона (LNAIN_LO, MIXIN_LO), поэтому у них LNAMODE = 1,
 * MIXERMODE = 1, LOBAND = 1 (как у канала L5 в pocket_L1L5_24MHz.conf).
 *
 * Тактирование АЦП: CLKOUT канала A (опорная частота ×1, REFDIV = 3) через буфер 74FCT3807
 * подаётся на ADC_CLKIN всех восьми микросхем (EXTADCCLK = 1), поэтому канал A настраивается
 * первым; выход CLKOUT остальных каналов не подключён и выключен (REFOUTEN = 0). */
#ifndef MAX2771_H
#define MAX2771_H
#include <stdint.h>

#define MAX_NCH   8
#define MAX_NREG  11                /* регистры 0x0–0xA (0x6, 0x8, 0x9 не используются) */
#define MAX_FREF  24.0e6            /* опорная частота (ТКГ), Гц */

/* поле регистра: адрес, младший бит, ширина */
typedef struct { uint8_t reg, pos, nbit; } max_fld_t;

/* настройка канала (по PocketSDR) */
typedef struct {
    uint16_t ndiv, rdiv;            /* синтезатор: f_LO = f_ref/RDIV·(NDIV + FDIV/2^20) */
    uint32_t fdiv;
    uint8_t  int_pll;               /* 1 — целочисленный режим (FDIV не используется) */
    uint8_t  fbw;                   /* полоса фильтра ПЧ (код FBW) */
    uint8_t  low;                   /* 1 — нижний диапазон: LNAMODE = MIXERMODE = LOBAND = 1 */
} max_ch_cfg_t;

extern const max_ch_cfg_t MAX_CFG[MAX_NCH];

/* результат max2771_init — маски каналов */
typedef struct {
    uint8_t spi_err;                /* нет ответа по SPI / тайм-аут обмена */
    uint8_t vfy_err;                /* обратное чтение не совпало с записанным */
    uint8_t unlock;                 /* синтезатор не захвачен (R_STATUS.LD) */
} max_status_t;

uint32_t max2771_read(int ch, int addr, int *err);
int      max2771_write(int ch, int addr, uint32_t v);        /* 0 — успешно */
/* значение регистра addr канала ch по таблице настроек с сохранением прочих битов old */
uint32_t max2771_apply(int ch, int addr, uint32_t old);
/* маска битов регистра addr канала ch, задаваемых драйвером (для проверки обратным чтением) */
uint32_t max2771_mask(int ch, int addr);
double   max2771_lo(int ch);                                 /* частота гетеродина канала, Гц */
/* включить микросхемы каналов mask (SHDN; остальные выключаются) и настроить: сначала A (тактирование АЦП), затем
 * остальные; ожидание захвата синтезаторов. 0 — все каналы mask настроены и захвачены */
int      max2771_init(uint8_t mask, max_status_t *st);
uint8_t  max2771_lock(void);                                 /* R_STATUS.LD */

#endif
