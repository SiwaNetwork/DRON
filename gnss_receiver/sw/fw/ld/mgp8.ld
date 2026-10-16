/* МГП-8: ПО МК — область флеш-памяти после загрузчика (1920 КБ), ОЗУ STM32H743; секции —
 * ld/sections.ld (Makefile объединяет их в build/mcu/*.ld). */
MEMORY
{
    FLASH (rx)  : ORIGIN = 0x08020000, LENGTH = 1920K
    ITCM  (rwx) : ORIGIN = 0x00000000, LENGTH = 64K
    DTCM  (rw)  : ORIGIN = 0x20000000, LENGTH = 128K - 256   /* последние 256 байт — boot_shared_t */
    AXI   (rw)  : ORIGIN = 0x24000000, LENGTH = 512K
    D2    (rw)  : ORIGIN = 0x30000000, LENGTH = 288K
    SRAM4 (rw)  : ORIGIN = 0x38000000, LENGTH = 64K
}
