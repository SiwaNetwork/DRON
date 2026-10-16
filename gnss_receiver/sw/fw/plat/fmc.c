/* МГП-8: шина FMC к ПЛИС и ожидание её конфигурации.
 *
 * FMC, банк 1 (NE1, 0x60000000): мультиплексированная 16-разрядная шина адреса/данных DA0–DA15,
 * строб адреса NL, асинхронный режим с ожиданием NWAIT (ПЛИС удерживает NWAIT, пока данные не
 * готовы). 32-разрядное обращение — два 16-разрядных цикла (младшее слово первым). Такт FMC —
 * HCLK3 240 МГц (4,17 нс): ADDSET 4, ADDHLD 2, DATAST 12, BUSTURN 4 — цикл ≈ 92 нс без ожидания.
 * Буфер записи FMC выключен (WFDIS): запись в регистр ПЛИС завершается до следующей команды.
 *
 * ПЛИС (LFE5U) конфигурируется сама из SPI-флеш-памяти (Master SPI) при включении питания. Если
 * DONE не установлен за 2 с — повторная конфигурация импульсом PROGRAMN; INITN = 0 после пуска
 * конфигурации — ошибка CRC потока. */
#include "plat.h"
#include "fpga.h"

static const uint8_t FMC_PINS[] = {
    PIN_FMC_DA0, PIN_FMC_DA1, PIN_FMC_DA2, PIN_FMC_DA3, PIN_FMC_DA4, PIN_FMC_DA5, PIN_FMC_DA6, PIN_FMC_DA7,
    PIN_FMC_DA8, PIN_FMC_DA9, PIN_FMC_DA10, PIN_FMC_DA11, PIN_FMC_DA12, PIN_FMC_DA13, PIN_FMC_DA14, PIN_FMC_DA15,
    PIN_FMC_NL, PIN_FMC_NOE, PIN_FMC_NWE, PIN_FMC_NWAIT, PIN_FMC_NE1,
};

void fmc_init(void)
{
    RCC_AHB3ENR |= AHB3_FMC;
    (void)RCC_AHB3ENR;
    for (unsigned i = 0; i < sizeof(FMC_PINS); i++)
        gpio_af(FMC_PINS[i], 12, FMC_PINS[i] == PIN_FMC_NWAIT ? PULL_UP : PULL_NONE, 3);
    FMC_BTR1 = 4u | 2u << 4 | 12u << 8 | 4u << 16 | 1u << 20;     /* ADDSET, ADDHLD, DATAST, BUSTURN, CLKDIV */
    /* MBKEN, MUXEN, MTYP = PSRAM, MWID = 16, резервный бит 7, WREN, ASYNCWAIT, WFDIS, FMCEN */
    FMC_BCR1 = 1u << 0 | 1u << 1 | 1u << 2 | 1u << 4 | 1u << 7 | 1u << 12 | 1u << 15 | 1u << 21 | 1u << 31;
    DSB();
}

static int wait_pin(int pin, int v, uint32_t ms)
{
    uint32_t t0 = sys_ms;
    while (gpio_get(pin) != v) {
        if (sys_ms - t0 >= ms) return -1;
        wdg_kick();
    }
    return 0;
}

int fpga_boot(void)
{
    gpio_od(PIN_FPGA_PROGRAMN, 1);
    gpio_in(PIN_FPGA_INITN, PULL_UP);
    gpio_in(PIN_FPGA_DONE, PULL_UP);
    if (wait_pin(PIN_FPGA_DONE, 1, 2000)) {
        gpio_set(PIN_FPGA_PROGRAMN, 0);
        delay_us(10);
        gpio_set(PIN_FPGA_PROGRAMN, 1);
        if (wait_pin(PIN_FPGA_INITN, 1, 50)) return FPGA_E_INIT;
        if (wait_pin(PIN_FPGA_DONE, 1, 5000)) return gpio_get(PIN_FPGA_INITN) ? FPGA_E_DONE : FPGA_E_CRC;
    }
    delay_us(1000);                             /* пуск логики пользователя после DONE */
    return fpga_rd(R_ID) == 0x4D475038u ? FPGA_OK : FPGA_E_ID;
}
