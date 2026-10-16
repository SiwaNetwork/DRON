/* МГП-8: FDCAN1 — классический CAN (PB8 RX, PB9 TX, AF9; приёмопередатчик — CAN_STBY PB12,
 * 1 — дежурный режим). Такт ядра FDCAN — HSE 24 МГц (при его отсутствии — PLL1_Q).
 * ОЗУ сообщений (смещения от FDCAN_RAM): FIFO 0 приёма — 16 элементов по 16 байт с 0x000,
 * очередь передачи — 8 элементов с 0x100. Фильтров нет: все кадры принимаются в FIFO 0.
 * Опрос без прерываний; при отключении от шины (bus-off) can_poll запускает восстановление. */
#include "plat.h"

#define CCCR_INIT  (1u << 0)
#define CCCR_CCE   (1u << 1)
#define RX_OFF     0x000u
#define TX_OFF     0x100u
#define ELEM       16u

#define RAMW(off)  REG(FDCAN_RAM + (off))

static int can_ok;

int can_init(uint32_t bitrate)
{
    uint32_t fk = sys_hse ? 24000000u : pll1q_hz;
    if (!fk || !bitrate) return -1;
    RCC_D2CCIP1R = (RCC_D2CCIP1R & ~(3u << 28)) | (sys_hse ? 0u : 1u << 28);
    RCC_APB1HENR |= APB1H_FDCAN;
    (void)RCC_APB1HENR;
    gpio_af(PIN_CAN_RX, 9, PULL_UP, 1);
    gpio_af(PIN_CAN_TX, 9, PULL_NONE, 1);
    gpio_out(PIN_CAN_STBY, 0);
    /* делитель: целое число квантов 8…25 на бит, точка выборки 87,5 % */
    uint32_t brp = 0, nq = 0;
    for (uint32_t b = 1; b <= 512u; b++) {
        if (fk % (b * bitrate)) continue;
        uint32_t q = fk / (b * bitrate);
        if (q >= 8u && q <= 25u) { brp = b; nq = q; break; }
    }
    if (!brp) return -1;
    uint32_t tseg2 = nq / 8u < 1u ? 1u : nq / 8u, tseg1 = nq - 1u - tseg2, sjw = tseg2;
    CAN_CCCR |= CCCR_INIT;
    uint32_t t0 = sys_ms;
    while (!(CAN_CCCR & CCCR_INIT))
        if (sys_ms - t0 > 10u) return -1;
    CAN_CCCR |= CCCR_CCE;
    CAN_NBTP = (sjw - 1u) << 25 | (brp - 1u) << 16 | (tseg1 - 1u) << 8 | (tseg2 - 1u);
    CAN_SIDFC = 0;
    CAN_XIDFC = 0;
    CAN_GFC = 0;                                /* кадры без фильтра — в FIFO 0 */
    CAN_RXESC = 0;                              /* данные — 8 байт */
    CAN_TXESC = 0;
    CAN_RXF0C = 16u << 16 | RX_OFF;
    CAN_TXBC = 8u << 24 | TX_OFF;               /* очередь (FIFO) из 8 элементов */
    CAN_IR = 0xFFFFFFFFu;
    CAN_CCCR &= ~CCCR_INIT;                     /* работа после 11 рецессивных битов */
    can_ok = 1;
    return 0;
}

int can_send(uint32_t id, int ext, const uint8_t *d, int n)
{
    if (!can_ok || n < 0 || n > 8) return -1;
    uint32_t q = CAN_TXFQS;
    if (q & (1u << 21)) return -1;              /* очередь заполнена */
    uint32_t pi = q >> 16 & 0x1Fu, a = TX_OFF + pi * ELEM, w[2] = {0, 0};
    for (int i = 0; i < n; i++) w[i >> 2] |= (uint32_t)d[i] << 8 * (i & 3);
    RAMW(a) = ext ? 1u << 30 | (id & 0x1FFFFFFFu) : (id & 0x7FFu) << 18;
    RAMW(a + 4) = (uint32_t)n << 16;
    RAMW(a + 8) = w[0];
    RAMW(a + 12) = w[1];
    DSB();
    CAN_TXBAR = 1u << pi;
    return 0;
}

int can_recv(uint32_t *id, int *ext, uint8_t *d)
{
    if (!can_ok) return -1;
    uint32_t s = CAN_RXF0S;
    if (!(s & 0x7Fu)) return -1;
    uint32_t gi = s >> 8 & 0x3Fu, a = RX_OFF + gi * ELEM;
    uint32_t r0 = RAMW(a), r1 = RAMW(a + 4), w[2] = {RAMW(a + 8), RAMW(a + 12)};
    int x = (int)(r0 >> 30 & 1u), n = (int)(r1 >> 16 & 0xFu);
    if (n > 8) n = 8;
    *ext = x;
    *id = x ? r0 & 0x1FFFFFFFu : r0 >> 18 & 0x7FFu;
    for (int i = 0; i < n; i++) d[i] = (uint8_t)(w[i >> 2] >> 8 * (i & 3));
    CAN_RXF0A = gi;
    return n;
}

int can_poll(void)
{
    if (!can_ok || !(CAN_PSR & (1u << 7))) return 0;   /* BO */
    CAN_CCCR &= ~CCCR_INIT;                     /* восстановление: 128 × 11 рецессивных битов */
    return 1;
}
