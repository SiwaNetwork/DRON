/* МГП-8: загрузчик (сектор 0 флеш-памяти, ld/boot.ld) — протокол inc/bootp.h на обоих UART.
 *
 * Работает от HSI 64 МГц без ФАПЧ, MPU и кешей (чтение флеш-памяти после записи — без
 * устаревших строк кеша). Запуск ПО МК — только через сброс с ключом BOOT_RUN_KEY: ПО МК
 * получает периферию в состоянии после сброса. Режим обновления: команда ENTER из ПО МК
 * (BOOT_REQ_KEY), неверный образ или кадр протокола в первые 200 мс. Если в режиме обновления
 * 30 с нет кадров, а образ верен — запуск ПО МК (ошибочный ENTER не оставляет приёмник в
 * загрузчике). Индикатор FIX мигает 5 Гц. */
#include "plat.h"

static int io_erase(uint32_t off) { return flash_erase(APP_BASE + off); }
static int io_prog(uint32_t off, const uint8_t *p) { return flash_prog(APP_BASE + off, p); }

static const bootp_io_t IO = {io_erase, io_prog, (const uint8_t *)APP_BASE, APP_BASE, APP_AREA, FLASH_SECTOR};
static bootp_t B[UART_N];

static void send_gps(const uint8_t *p, int n) { uart_write(UART_GPS, p, n); }
static void send_dbg(const uint8_t *p, int n) { uart_write(UART_DBG, p, n); }

static void __attribute__((noreturn)) jump(void)
{
    const volatile uint32_t *v = (const volatile uint32_t *)APP_BASE;
    uint32_t sp = v[0], pc = v[1];
    SCB_VTOR = APP_BASE;
    DSB();
    ISB();
    __asm volatile ("msr msp, %0\n bx %1" :: "r"(sp), "r"(pc) : "memory");
    __builtin_unreachable();
}

static void __attribute__((noreturn)) run(void)
{
    uart_flush(UART_GPS);
    uart_flush(UART_DBG);
    boot_sh()->boot_req = BOOT_RUN_KEY;
    sys_reset();
}

int main(void)
{
    volatile boot_shared_t *s = boot_sh();
    uint32_t req = s->boot_req;
    s->boot_req = 0;
    if (req == BOOT_RUN_KEY && bootp_valid(&IO, 0, 0)) {
        RCC_RSR |= RSR_RMVF;
        jump();
    }
    s->rsr = RCC_RSR;
    RCC_RSR |= RSR_RMVF;
    s->n_boot++;
    int stay = req == BOOT_REQ_KEY || req == BOOT_RUN_KEY;
    int valid = bootp_valid(&IO, 1, 0);
    sys_tick_init();
    wdg_start(20000u);
    gpio_out(PIN_LED_FIX_K, 1);
    gpio_out(PIN_LED_ANT_K, 1);
    uart_init(UART_GPS, 115200u);
    uart_init(UART_DBG, 115200u);
    bootp_init(&B[UART_GPS], &IO, send_gps);
    bootp_init(&B[UART_DBG], &IO, send_dbg);
    if (stay || !valid) dbg("\r\nMGP-8 boot %x: image %s\r\n", BOOT_VER, valid ? "ok" : "invalid");
    uint32_t t0 = sys_ms, last = t0, chk = t0;
    for (;;) {
        uint8_t d[64];
        for (int u = 0; u < UART_N; u++) {
            int n = uart_read(u, d, (int)sizeof(d));
            if (n > 0 && bootp_feed(&B[u], d, n) > 0) { stay = 1; last = sys_ms; }
            if (B[u].run) run();
        }
        uint32_t now = sys_ms;
        if (!stay && now - t0 >= 200u) {
            if (valid) run();
            stay = 1;
        }
        if (stay && now - last >= 30000u && now - chk >= 30000u) {
            chk = now;
            if (bootp_valid(&IO, 1, 0)) run();
        }
        gpio_set(PIN_LED_FIX_K, stay ? (int)(now / 100u & 1u) : 1);
        wdg_kick();
    }
}
