/* МГП-8: запись встроенной флеш-памяти STM32H743 (только загрузчик, кеши выключены).
 * Два банка по 1 МБ (0x08000000, 0x08100000), сектор 128 КБ, слово записи — 256 бит (32 байта
 * с ECC), параллельность 32 бита (PSIZE). Сектор 0 банка 1 (загрузчик) не стирается и не
 * записывается. После операции — проверка чтением. */
#include <string.h>
#include "plat.h"

#define FLASH_END   0x08200000u
#define BANK2       0x08100000u

static int wait(int b, uint32_t ms)
{
    uint32_t t0 = sys_ms;
    while (FLASH_SR(b) & (FSR_BSY | FSR_QW | FSR_WBNE)) {
        if (sys_ms - t0 > ms) return -1;
        wdg_kick();
    }
    return FLASH_SR(b) & FSR_ERR ? -2 : 0;
}

static void unlock(int b)
{
    if (FLASH_CR(b) & FCR_LOCK) {
        FLASH_KEYR(b) = 0x45670123u;
        FLASH_KEYR(b) = 0xCDEF89ABu;
    }
}

int flash_erase(uint32_t addr)
{
    if (addr < APP_BASE || addr >= FLASH_END || (addr & (FLASH_SECTOR - 1u))) return -1;
    int b = addr >= BANK2;
    uint32_t sn = (addr - 0x08000000u - (b ? 0x100000u : 0u)) >> 17;
    unlock(b);
    FLASH_CCR(b) = FCCR_ALL;
    FLASH_CR(b) = FCR_PSIZE32 | FCR_SER | FCR_SNB(sn);
    FLASH_CR(b) |= FCR_START;
    int r = wait(b, 10000u);                   /* сектор — до 4 с (тип. 2 с) */
    FLASH_CR(b) = FCR_LOCK;
    if (r) return r;
    const volatile uint32_t *p = (const volatile uint32_t *)addr;
    for (uint32_t i = 0; i < FLASH_SECTOR / 4u; i++)
        if (p[i] != 0xFFFFFFFFu) return -3;
    return 0;
}

int flash_prog(uint32_t addr, const uint8_t *src)
{
    if (addr < APP_BASE || addr >= FLASH_END || (addr & 31u)) return -1;
    int b = addr >= BANK2;
    uint32_t w[8];
    memcpy(w, src, sizeof(w));                  /* данные кадра могут быть не выровнены */
    unlock(b);
    FLASH_CCR(b) = FCCR_ALL;
    FLASH_CR(b) = FCR_PSIZE32 | FCR_PG;
    volatile uint32_t *d = (volatile uint32_t *)addr;
    for (int i = 0; i < 8; i++) d[i] = w[i];
    DSB();
    int r = wait(b, 100u);
    FLASH_CR(b) = FCR_LOCK;
    if (r) return r;
    return memcmp((const void *)addr, w, sizeof(w)) ? -3 : 0;
}
