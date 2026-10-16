/* МГП-8: SDMMC1 — карта microSD (D0–D3 PC8–PC11, CLK PC12, CMD PD2, AF12; SD_CD PB13, 0 — карта
 * установлена). Инициализация на 400 кГц, работа — 4 бита, 24 МГц (Default Speed); блоки по
 * 512 байт, обмен через FIFO опросом (аппаратное управление потоком останавливает такт карты
 * при заполнении FIFO — без переполнений). Такт ядра — PLL1_Q. Карты SDSC (v1, v2) и SDHC/SDXC. */
#include "plat.h"

#define CMD_TRANS   (1u << 6)
#define CMD_CPSMEN  (1u << 12)
#define R_NONE      0u
#define R_SHORT     1u
#define R_NOCRC     2u                          /* R3 */
#define R_LONG      3u
#define ST_CCRCFAIL (1u << 0)
#define ST_DCRCFAIL (1u << 1)
#define ST_CTIMEOUT (1u << 2)
#define ST_DTIMEOUT (1u << 3)
#define ST_TXUNDERR (1u << 4)
#define ST_RXOVERR  (1u << 5)
#define ST_CMDREND  (1u << 6)
#define ST_CMDSENT  (1u << 7)
#define ST_DATAEND  (1u << 8)
#define ST_TXFIFOHE (1u << 14)
#define ST_RXFIFOHF (1u << 15)
#define ST_RXFIFOE  (1u << 19)
#define ST_BUSYD0   (1u << 20)
#define ICR_ALL     0x1FE00FFFu
#define CLK_HWFC    (1u << 17)
#define CLK_WIDE4   (1u << 14)
#define DCTRL_RD    (1u << 1)
#define DCTRL_512   (9u << 4)

static struct { int ok, hc; uint32_t rca, blocks, dtimer; } sd;

int sd_present(void)
{
    gpio_in(PIN_SD_CD, PULL_UP);
    delay_us(10);
    return !gpio_get(PIN_SD_CD);
}

uint32_t sd_blocks(void) { return sd.ok ? sd.blocks : 0; }

static int wait_st(uint32_t m, uint32_t ms)
{
    uint32_t t0 = sys_ms;
    while (!(SD_STAR & m))
        if (sys_ms - t0 > ms) return -1;
    return 0;
}

static int cmd(uint32_t idx, uint32_t arg, uint32_t resp, uint32_t flags)
{
    SD_ICR = ICR_ALL;
    SD_ARGR = arg;
    SD_CMDR = idx | resp << 8 | CMD_CPSMEN | flags;
    if (resp == R_NONE) return wait_st(ST_CMDSENT, 100);
    if (wait_st(ST_CMDREND | ST_CCRCFAIL | ST_CTIMEOUT, 100)) return -1;
    uint32_t st = SD_STAR;
    if (st & ST_CTIMEOUT) return -1;
    if ((st & ST_CCRCFAIL) && resp != R_NOCRC) return -2;
    return 0;
}

static int acmd(uint32_t idx, uint32_t arg, uint32_t resp)
{
    if (cmd(55, sd.rca << 16, R_SHORT, 0)) return -1;
    return cmd(idx, arg, resp, 0);
}

static uint32_t clkdiv(uint32_t hz) { return (pll1q_hz + 2u * hz - 1u) / (2u * hz); }

static int ready(void)
{
    uint32_t t0 = sys_ms;
    for (;;) {
        if (cmd(13, sd.rca << 16, R_SHORT, 0) == 0) {
            uint32_t r = SD_RESP(0);
            if ((r & (1u << 8)) && (r >> 9 & 15u) == 4u) return 0;   /* READY_FOR_DATA, tran */
        }
        if (sys_ms - t0 > 500u) return -1;
        wdg_kick();
    }
}

int sd_init(void)
{
    sd.ok = 0;
    if (!pll1q_hz) return -1;
    RCC_AHB3ENR |= AHB3_SDMMC1;
    (void)RCC_AHB3ENR;
    gpio_af(PIN_SD_D0, 12, PULL_UP, 2); gpio_af(PIN_SD_D1, 12, PULL_UP, 2);
    gpio_af(PIN_SD_D2, 12, PULL_UP, 2); gpio_af(PIN_SD_D3, 12, PULL_UP, 2);
    gpio_af(PIN_SD_CLK_R, 12, PULL_NONE, 2);
    gpio_af(PIN_SD_CMD, 12, PULL_UP, 2);
    SD_POWER = 0;
    SD_CLKCR = clkdiv(400000u) | CLK_HWFC;
    SD_POWER = 3u;
    delay_us(1000);                             /* ≥ 74 такта до первой команды */
    sd.rca = 0;
    if (cmd(0, 0, R_NONE, 0)) return -1;
    int v2 = cmd(8, 0x1AAu, R_SHORT, 0) == 0 && (SD_RESP(0) & 0xFFFu) == 0x1AAu;
    uint32_t t0 = sys_ms, ocr = 0;
    do {
        if (sys_ms - t0 > 1000u) return -2;
        if (acmd(41, v2 ? 0x40FF8000u : 0x00FF8000u, R_NOCRC)) return -2;
        ocr = SD_RESP(0);
        wdg_kick();
    } while (!(ocr & (1u << 31)));
    sd.hc = v2 && (ocr & (1u << 30));
    if (cmd(2, 0, R_LONG, 0)) return -3;
    if (cmd(3, 0, R_SHORT, 0)) return -3;
    sd.rca = SD_RESP(0) >> 16;
    if (cmd(9, sd.rca << 16, R_LONG, 0)) return -3;
    uint32_t r2 = SD_RESP(1), r3 = SD_RESP(2);
    if (SD_RESP(0) >> 30 == 1u) {               /* CSD v2: C_SIZE[69:48] */
        sd.blocks = (((r2 & 0x3Fu) << 16 | r3 >> 16) + 1u) * 1024u;
    } else {                                    /* CSD v1 */
        uint32_t bl = r2 >> 16 & 15u, cs = (r2 & 0x3FFu) << 2 | r3 >> 30, mult = r3 >> 15 & 7u;
        sd.blocks = (cs + 1u) << (mult + 2u + bl - 9u);
    }
    if (cmd(7, sd.rca << 16, R_SHORT, 0)) return -4;
    t0 = sys_ms;
    while (SD_STAR & ST_BUSYD0)
        if (sys_ms - t0 > 500u) return -4;
    if (acmd(6, 2u, R_SHORT)) return -5;        /* шина 4 бита */
    SD_CLKCR = clkdiv(24000000u) | CLK_WIDE4 | CLK_HWFC;
    if (cmd(16, 512u, R_SHORT, 0)) return -5;
    sd.dtimer = 24000000u / 2u;                 /* 0,5 с */
    sd.ok = 1;
    return 0;
}

static void data_setup(int rd)
{
    SD_ICR = ICR_ALL;
    SD_DTIMER = sd.dtimer;
    SD_DLENR = 512u;
    SD_DCTRL = DCTRL_512 | (rd ? DCTRL_RD : 0u);
}

int sd_read(uint32_t blk, uint32_t *buf)
{
    if (!sd.ok) return -1;
    data_setup(1);
    if (cmd(17, sd.hc ? blk : blk * 512u, R_SHORT, CMD_TRANS)) return -2;
    int k = 0;
    uint32_t t0 = sys_ms, st;
    while (!((st = SD_STAR) & (ST_DATAEND | ST_DCRCFAIL | ST_DTIMEOUT | ST_RXOVERR))) {
        if ((st & ST_RXFIFOHF) && k <= 128 - 8)
            for (int i = 0; i < 8; i++) buf[k++] = SD_FIFO;
        if (sys_ms - t0 > 1000u) return -3;
    }
    if (st & (ST_DCRCFAIL | ST_DTIMEOUT | ST_RXOVERR)) return -3;
    while (k < 128 && !(SD_STAR & ST_RXFIFOE)) buf[k++] = SD_FIFO;
    SD_ICR = ICR_ALL;
    return k == 128 ? 0 : -3;
}

int sd_write(uint32_t blk, const uint32_t *buf)
{
    if (!sd.ok) return -1;
    data_setup(0);
    if (cmd(24, sd.hc ? blk : blk * 512u, R_SHORT, CMD_TRANS)) return -2;
    int k = 0;
    uint32_t t0 = sys_ms, st;
    while (!((st = SD_STAR) & (ST_DATAEND | ST_DCRCFAIL | ST_DTIMEOUT | ST_TXUNDERR))) {
        if ((st & ST_TXFIFOHE) && k <= 128 - 8)
            for (int i = 0; i < 8; i++) SD_FIFO = buf[k++];
        if (sys_ms - t0 > 1000u) return -3;
    }
    SD_ICR = ICR_ALL;
    if (st & (ST_DCRCFAIL | ST_DTIMEOUT | ST_TXUNDERR)) return -3;
    return ready();
}
