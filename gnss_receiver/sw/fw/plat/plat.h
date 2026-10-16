/* МГП-8: платформенная часть ПО МК (STM32H743VIT6) — тактирование, MPU и кеши, системный таймер,
 * сторожевой таймер, выводы, FMC и загрузка ПЛИС, UART, FDCAN, SDMMC, АЦП, планировщик.
 *
 * Приоритеты прерываний (старшая тетрада, меньше — важнее):
 *   0x00  АЦП: аналоговый сторожевой таймер тока антенны (отключение при КЗ)
 *   0x10  UART (кольцевые буферы)
 *   0x20  ПЛИС (EXTI PE5): app_irq — корреляторы, слежение, фиксация измерений
 *   0x30  SysTick (1 мс)
 *   0xF0  PendSV: app_sol — решение, 1PPS, NMEA
 * Блокировка irq_lock — BASEPRI 0x20: маскирует ПЛИС, SysTick и PendSV, но не UART и защиту
 * антенны; uart_write копирует сообщение в буфер под BASEPRI 0x10. Функции newlib (sprintf)
 * вызываются только из PendSV; фон пишет через dbg(). Наибольшая глубина стека — tools/stack_check.py
 * (make elf). */
#ifndef PLAT_H
#define PLAT_H
#include <stdint.h>
#include <stdarg.h>
#include "stm32h743.h"
#include "board_pins.h"
#include "bootp.h"

#define BOOT_SHARED   ((volatile boot_shared_t *)BOOT_SH_ADDR)
#define APP_BASE      0x08020000u
#define APP_AREA      (1920u * 1024u)
#define FLASH_SECTOR  (128u * 1024u)

/* --- система (plat/system.c) */
extern uint32_t sys_hz, hclk_hz, pclk_hz, pll1q_hz;   /* ядро, AXI/AHB, APB, PLL1_Q (0 — нет ФАПЧ) */
extern uint32_t sys_rev;                               /* REV_ID: 0x1003 — Y, 0x2003 — V */
extern int      sys_hse;                               /* 1 — тактирование от HSE 24 МГц */
extern volatile uint32_t sys_ms;
/* 480 МГц (рев. V) или 400 МГц (рев. Y) от HSE 24 МГц (при его отсутствии — от HSI), MPU,
 * кеши, SysTick; 0 — успешно, −1 — ФАПЧ не запущена (работа от HSI 64 МГц) */
int      sys_init(void);
void     sys_tick_init(void);                          /* SysTick 1 мс и счётчик тактов DWT */
void     delay_us(uint32_t us);
void     sys_reset(void) __attribute__((noreturn));
void     irq_prio(int irq, uint32_t prio);
void     irq_on(int irq);
void     irq_off(int irq);
void     irq_pend(int irq);
void     irq_lock(int on);
void     wdg_start(uint32_t ms);                       /* до 32 с */
void     wdg_kick(void);

/* общая область загрузчика и ПО МК (при первом обращении после включения питания — обнуление) */
static inline volatile boot_shared_t *boot_sh(void)
{
    volatile boot_shared_t *s = BOOT_SHARED;
    if (s->magic != BOOT_SH_MAGIC) {
        for (unsigned i = 0; i < sizeof(boot_shared_t) / 4; i++) ((volatile uint32_t *)s)[i] = 0;
        s->magic = BOOT_SH_MAGIC;
    }
    return s;
}

/* повышение BASEPRI до v (не понижает) с обходом ошибки ядра 837070; возвращает прежнее значение.
 * Вызывать при PRIMASK = 0 */
static inline uint32_t basepri_raise(uint32_t v)
{
    uint32_t o;
    __asm volatile ("mrs %0, basepri\n cpsid i\n msr basepri_max, %1\n cpsie i" : "=&r"(o) : "r"(v) : "memory");
    return o;
}
static inline void basepri_set(uint32_t v) { __asm volatile ("msr basepri, %0" :: "r"(v) : "memory"); }

/* --- выводы (plat/gpio.c) */
enum { PULL_NONE, PULL_UP, PULL_DOWN };
void gpio_out(int pin, int v);                         /* двухтактный выход */
void gpio_od(int pin, int v);                          /* открытый сток, подтяжка вверх */
void gpio_in(int pin, int pull);
void gpio_af(int pin, int af, int pull, int speed);    /* скорость 0…3 */
void gpio_an(int pin);
void gpio_set(int pin, int v);
int  gpio_get(int pin);

/* --- FMC и ПЛИС (plat/fmc.c) */
enum { FPGA_OK = 0, FPGA_E_INIT, FPGA_E_CRC, FPGA_E_DONE, FPGA_E_ID };
void fmc_init(void);
int  fpga_boot(void);                                  /* ожидание конфигурации ПЛИС, FPGA_* */

/* --- UART (plat/uart.c): USART1 — порт GPS (NMEA, протокол), UART4 — отладочный */
enum { UART_GPS, UART_DBG, UART_N };
typedef struct { uint32_t err, rx_ovf, tx_drop; } uart_stat_t;
extern uart_stat_t uart_st[UART_N];
void uart_init(int u, uint32_t baud);
int  uart_write(int u, const void *p, int n);          /* помещено в буфер, байт */
int  uart_read(int u, void *p, int n);
void uart_flush(int u);                                /* ожидание окончания передачи (≤ 0,5 с) */
int  fmt_v(char *b, int size, const char *fmt, va_list ap);   /* %d %u %x %X %s %c, ширина, 0 */
void dbg(const char *fmt, ...);

/* --- FDCAN1 (plat/can.c): классический CAN, приём всех кадров в FIFO 0 */
int  can_init(uint32_t bitrate);                       /* 0 — успешно */
int  can_send(uint32_t id, int ext, const uint8_t *d, int n);  /* 0 — помещён в очередь */
int  can_recv(uint32_t *id, int *ext, uint8_t *d);     /* длина данных, −1 — нет кадра */
int  can_poll(void);                                   /* 1 — шина отключена (bus-off), восстановление */

/* --- SDMMC1 (plat/sdmmc.c): карта microSD, 4 бита, блоки по 512 байт */
int      sd_present(void);
int      sd_init(void);                                /* 0 — карта готова */
int      sd_read(uint32_t blk, uint32_t *buf);
int      sd_write(uint32_t blk, const uint32_t *buf);
uint32_t sd_blocks(void);

/* --- АЦП (plat/adc.c): контроль питания, ток и защита антенны, температура МК */
enum { ANT_OFF, ANT_OK, ANT_OPEN, ANT_SHORT };         /* как mbp_tm_t.ant_state */
typedef struct {
    float t_mcu, vdda, v5, v3v3, v1v1, ant_ma;
    int   ant;
    uint32_t n_short;
} adc_tm_t;
void adc_init(void);
void adc_read(adc_tm_t *t);
void ant_set(int on);
int  ant_poll(float ma);                               /* состояние; повтор после КЗ через 10 с */

/* --- флеш-память (plat/flash.c, только загрузчик) */
int  flash_erase(uint32_t addr);                       /* сектор 128 КБ; 0 — успешно */
int  flash_prog(uint32_t addr, const uint8_t *p);      /* 32 байта с проверкой; 0 — успешно */

/* --- планировщик (plat/sched.c): задачи фона по периоду; WFI, если работы нет */
void sched_add(int (*fn)(void), uint32_t period_ms);   /* 0 — на каждом проходе; fn: 1 — была работа */
void sched_run(void) __attribute__((noreturn));

#endif
