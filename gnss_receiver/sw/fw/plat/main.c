/* МГП-8: ПО МК — инициализация платформы и приёмника, прерывание ПЛИС, задачи фона.
 *
 * Порядок запуска: тактирование 480 МГц, MPU и кеши (sys_init), UART и сообщение о запуске
 * (с записью об отказе, если она есть), сторожевой таймер 4 с, FMC и ожидание конфигурации
 * ПЛИС, сброс FX3 снимается, АЦП и питание антенны, карта microSD, FDCAN, прикладной уровень
 * (app_init: ПЛИС, MAX2771, приёмник), прерывание ПЛИС (EXTI PE5), планировщик.
 * Задачи фона (plat/sched.c):
 *   t_acq  — поиск КА (app_poll), на каждом проходе;
 *   t_cmd  — команда ENTER загрузчика с обоих UART, на каждом проходе;
 *   t_led  — индикаторы FIX и ANT, 100 мс;
 *   t_tm   — телеметрия (АЦП, ток антенны, ФАПЧ): кадр MBP_TM в порт GPS, строка в отладочный
 *            порт, контроль шины CAN; 1 с. */
#include <stddef.h>
#include "plat.h"
#include "app.h"
#include "acq.h"
#include "fpga.h"
#include "mem.h"
#include "proto.h"

#define FW_VER  0x00010000u

/* заголовок образа (смещение 0x400 от начала области ПО МК); size и crc — tools/img_hdr.py */
__attribute__((section(".app_hdr"), used))
const app_hdr_t g_app_hdr = {APP_MAGIC, 0, 0, FW_VER};

static rx_t    RX MEM_D2;
static app_t   A;
static uint8_t SNAP[APP_NSNAP][SNAP_BYTES(APP_SNAP_N)] MEM_DTCM __attribute__((aligned(32)));
static int     fpga_st = -1, app_st = -1;
static int     ant_st = ANT_OFF;               /* по последней телеметрии */

/* --- прерывание ПЛИС (уровень на PE5; фронт EXTI — повторный запрос, пока уровень не снят) */
void EXTI9_5_IRQHandler(void)
{
    EXTI_CPUPR1 = 1u << 5;
    if (app_irq(&A)) SCB_ICSR = ICSR_PENDSVSET;
    if (gpio_get(PIN_FPGA_IRQ)) irq_pend(IRQ_EXTI9_5);
}

void PendSV_Handler(void) { app_sol(&A); }

static void nmea_out(const char *s, int n) { uart_write(UART_GPS, s, n); }

static void fpga_irq_init(void)
{
    RCC_APB4ENR |= APB4_SYSCFG;
    (void)RCC_APB4ENR;
    gpio_in(PIN_FPGA_IRQ, PULL_DOWN);
    SYSCFG_EXTICR(1) = (SYSCFG_EXTICR(1) & ~(15u << 4)) | (uint32_t)PORT_E << 4;
    EXTI_RTSR1 |= 1u << 5;
    EXTI_CPUPR1 = 1u << 5;
    EXTI_CPUIMR1 |= 1u << 5;
    irq_prio(IRQ_EXTI9_5, 0x20u);
    irq_on(IRQ_EXTI9_5);
    if (gpio_get(PIN_FPGA_IRQ)) irq_pend(IRQ_EXTI9_5);
}

/* --- задачи фона */
static int t_acq(void) { return app_st >= 0 ? app_poll(&A) != APP_IDLE : 0; }

static int t_cmd(void)
{
    static uint8_t buf[UART_N][64];
    static int n[UART_N];
    uint8_t d[64];
    int work = 0;
    for (int u = 0; u < UART_N; u++) {
        int k = uart_read(u, d, (int)sizeof(d));
        if (k <= 0) continue;
        work = 1;
        if (bootp_detect(buf[u], &n[u], (int)sizeof(buf[u]), d, k)) {
            dbg("boot: ENTER\r\n");
            boot_sh()->boot_req = BOOT_REQ_KEY;
            uart_flush(UART_GPS);
            uart_flush(UART_DBG);
            sys_reset();
        }
    }
    return work;
}

static int t_led(void)
{
    static uint32_t k, sol_n, sol_t;
    k++;
    if (A.n_sol != sol_n) { sol_n = A.n_sol; sol_t = sys_ms; }
    int fix = sol_n && sys_ms - sol_t < 2000u ? 1 : (int)(k / 5u & 1u);
    int on;
    switch (ant_st) {
    case ANT_OK:    on = 1; break;
    case ANT_OPEN:  on = (int)(k / 5u & 1u); break;
    case ANT_SHORT: on = (int)(k & 1u); break;
    default:        on = 0; break;
    }
    gpio_set(PIN_LED_FIX_K, !fix);              /* катод: 0 — горит */
    gpio_set(PIN_LED_ANT_K, !on);
    return 0;
}

static int t_tm(void)
{
    static uint32_t prev;
    static uint64_t up_ms;
    static uint8_t buf[64];
    adc_tm_t t;
    up_ms += sys_ms - prev;
    prev = sys_ms;
    adc_read(&t);
    t.ant = ant_st = ant_poll(t.ant_ma);
    if (can_poll()) dbg("can: bus-off\r\n");
    uint32_t st = fpga_st == FPGA_OK ? fpga_rd(R_STATUS) : 0, ne = fpga_st == FPGA_OK ? fpga_rd(R_NOTCH_EN) : 0;
    mbp_tm_t m = {
        .t_mcu = t.t_mcu, .ant_ma = t.ant_ma, .ant_state = (uint8_t)t.ant,
        .max_ld = (uint8_t)(st & 0xFFu), .notch_en = (uint8_t)(ne & 0xFFu), .notch_dith = (uint8_t)(ne >> 16),
        .vin_mv = (uint16_t)(t.v5 * 1000.0f), .uptime_s = (uint32_t)(up_ms / 1000u),
        .fpga_ok = fpga_st == FPGA_OK, .pll_lock = (uint8_t)(st >> 9 & 1u),
    };
    uart_write(UART_GPS, buf, mbp_tm(buf, &m));
    dbg("tm: t %d C, ant %d mA st %d (kz %u), v5 %u v3v3 %u v1v1 %u mV, ld %x, irq %u, sol %u, acq %u/%u\r\n",
        (int)t.t_mcu, (int)t.ant_ma, t.ant, t.n_short, (unsigned)(t.v5 * 1000.0f),
        (unsigned)(t.v3v3 * 1000.0f), (unsigned)(t.v1v1 * 1000.0f), st & 0xFFu,
        A.n_irq, A.n_sol, A.n_found, A.n_acq);
    return 1;
}

int main(void)
{
    int clk = sys_init();
    gpio_out(PIN_LED_FIX_K, 1);
    gpio_out(PIN_LED_ANT_K, 1);
    gpio_out(PIN_FX3_RESETN, 0);
    uart_init(UART_GPS, 115200u);
    uart_init(UART_DBG, 115200u);
    volatile boot_shared_t *s = boot_sh();
    dbg("\r\nMGP-8 fw %x: %u MHz (%s), rev %x, rsr %x, boot %u\r\n", FW_VER, sys_hz / 1000000u,
        clk ? "HSI, PLL fail" : sys_hse ? "HSE" : "HSI", sys_rev, s->rsr, s->n_boot);
    if (s->fault == FAULT_KEY) {
        dbg("fault: ipsr %x cfsr %x hfsr %x mmfar %x bfar %x pc %x lr %x psr %x\r\n",
            s->ipsr, s->cfsr, s->hfsr, s->mmfar, s->bfar, s->pc, s->lr, s->psr);
        s->fault = 0;
    }
    wdg_start(4000u);
    fmc_init();
    fpga_st = fpga_boot();
    gpio_set(PIN_FX3_RESETN, 1);
    dbg("fpga: %d\r\n", fpga_st);
    adc_init();
    ant_set(1);
    if (sd_present()) {
        int r = sd_init();
        dbg("sd: %d, %u blk\r\n", r, sd_blocks());
    }
    dbg("can: %d\r\n", can_init(500000u));
    if (fpga_st == FPGA_OK) {
        uint8_t *const snap[APP_NSNAP] = {SNAP[0], SNAP[1], SNAP[2], SNAP[3]};
        app_st = app_init(&A, &RX, snap, irq_lock);
        dbg("app: %d, fpga ver %x, %d ch\r\n", app_st, A.fpga_ver, A.nch);
        if (app_st & APP_E_FPGA) app_st = -1;
        else {
            A.out = nmea_out;
            fpga_irq_init();
        }
    }
    sched_add(t_acq, 0);
    sched_add(t_cmd, 0);
    sched_add(t_led, 100u);
    sched_add(t_tm, 1000u);
    sched_run();
}
