/* МГП-8: размещение данных ПО МК по областям ОЗУ STM32H743 (ld/mgp8.ld).
 *
 * По умолчанию .data/.bss — в AXI SRAM (512 КБ, D1: буферы захвата и спектра, таблицы).
 * Явно размещаются:
 *   MEM_DTCM  — DTCM (128 КБ, без кеша, 0 тактов ожидания): снимки отсчётов, стек;
 *   MEM_D2    — SRAM1–3 (288 КБ, D2): состояние приёмника rx_t;
 *   MEM_SRAM4 — SRAM4 (64 КБ, D3): копии измерений и эфемерид для решения.
 * Имена секций начинаются с .bss — компилятор выделяет их без содержимого (NOBITS), в образ
 * прошивки они не входят; обнуляются при запуске (plat/startup.c). На ПК макросы пустые. */
#ifndef MEM_H
#define MEM_H

#if defined(MGP8_MCU)
#define MEM_DTCM   __attribute__((section(".bss.dtcm")))
#define MEM_D2     __attribute__((section(".bss.d2")))
#define MEM_SRAM4  __attribute__((section(".bss.sram4")))
#else
#define MEM_DTCM
#define MEM_D2
#define MEM_SRAM4
#endif

#endif
