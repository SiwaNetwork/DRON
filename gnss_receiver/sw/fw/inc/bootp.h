/* МГП-8: загрузчик — проверка образа ПО МК и протокол его обновления по UART (класс 0x10
 * собственного протокола, inc/proto.h). Не зависит от периферии: на МК — plat/boot.c
 * (флеш-память STM32H743, plat/flash.c), на ПК — tests/test_boot.c (модель флеш-памяти).
 *
 * Флеш-память (2 МБ, два банка по 8 секторов по 128 КБ):
 *   0x08000000  загрузчик (сектор 0 банка 1, ld/boot.ld);
 *   0x08020000  ПО МК (1920 КБ, ld/mgp8.ld): таблица векторов, по смещению 0x400 — заголовок
 *               app_hdr_t. Поля size и crc заполняет tools/img_hdr.py после компоновки.
 * CRC-32 (zlib: полином 0xEDB88320, начальное и конечное 0xFFFFFFFF) — по образу без поля crc.
 *
 * Запуск: загрузчик проверяет образ (заголовок, указатель стека, вектор сброса, CRC-32) и 200 мс
 * ждёт кадр протокола; если его нет — сброс с ключом BOOT_RUN_KEY, после которого загрузчик сразу
 * передаёт управление ПО МК (периферия в состоянии после сброса). ПО МК по команде ENTER
 * записывает BOOT_REQ_KEY и выполняет сброс — загрузчик остаётся в режиме обновления.
 * Общая область (boot_shared_t, 256 байт в конце DTCM, не обнуляется при запуске) передаёт
 * ключи, причину сброса и запись об отказе (HardFault и др.) в ПО МК.
 *
 * Команды (класс 0x10; ответ — идентификатор | 0x80, первый байт данных — состояние BP_*):
 *   01 INFO  → u8 st, u32 версия загрузчика, u32 адрес образа, u32 объём области, u32 сектор,
 *              u8 образ верен, u32 версия образа, u32 размер образа
 *   02 ERASE u32 смещение (кратно сектору) → u8 st, u32 смещение
 *   03 WRITE u32 смещение (кратно 32), n·32 байт (n = 1…32) → u8 st, u32 смещение
 *   04 CHECK → u8 st (BP_E_IMG — образ неверен), u32 размер, u32 CRC-32 (вычисленная), u32 версия
 *   05 RUN   → u8 st; запуск ПО МК после ответа
 *   06 ENTER u32 BOOT_REQ_KEY → u8 st; ПО МК — переход в загрузчик
 * Запись — только в стёртые в этом сеансе секторы и по возрастанию адресов внутри сектора:
 * слово флеш-памяти STM32H7 (32 байта с ECC) нельзя записать повторно без стирания. */
#ifndef BOOTP_H
#define BOOTP_H
#include <stdint.h>
#include "proto.h"

#define APP_HDR_OFF   0x400u
#define APP_MIN_SIZE  (APP_HDR_OFF + 16u)
#define APP_MAGIC     0x3850474Du          /* «MGP8» */
#define BOOT_VER      0x00010000u
#define BOOT_SH_ADDR  0x2001FF00u          /* общая область в DTCM */
#define BOOT_SH_MAGIC 0x42534838u
#define BOOT_REQ_KEY  0xB007B007u          /* остаться в загрузчике */
#define BOOT_RUN_KEY  0x52554E21u          /* сразу запустить ПО МК */
#define FAULT_KEY     0xFA017EADu
#define BOOTP_WORD    32u                  /* слово записи флеш-памяти */
#define BOOTP_NSEC    16

enum { BP_INFO = 1, BP_ERASE, BP_WRITE, BP_CHECK, BP_RUN, BP_ENTER };
enum { BP_OK = 0, BP_E_LEN, BP_E_ALIGN, BP_E_RANGE, BP_E_ERASE, BP_E_FLASH, BP_E_IMG, BP_E_CMD };

typedef struct {                            /* заголовок образа (смещение 0x400) */
    uint32_t magic, size, crc, ver;
} app_hdr_t;

typedef struct {                            /* общая область загрузчика и ПО МК */
    uint32_t magic, boot_req;
    uint32_t rsr;                           /* RCC_RSR при первом входе в загрузчик */
    uint32_t n_boot;
    uint32_t fault;                         /* FAULT_KEY — записан отказ */
    uint32_t ipsr, cfsr, hfsr, mmfar, bfar, pc, lr, psr;
} boot_shared_t;

typedef struct {                            /* область ПО МК во флеш-памяти */
    int  (*erase)(uint32_t off);                    /* стирание сектора; 0 — успешно */
    int  (*prog)(uint32_t off, const uint8_t *p);   /* запись слова (32 байта) с проверкой; 0 — успешно */
    const uint8_t *img;                     /* образ (чтение) */
    uint32_t base, size, sector;            /* адрес образа на шине МК, объём области, размер сектора */
} bootp_io_t;

typedef struct {
    const bootp_io_t *io;
    void   (*send)(const uint8_t *p, int n);
    uint8_t  rx[MBP_MAXLEN + 8];
    int      n;
    uint8_t  tx[64];
    uint32_t wp[BOOTP_NSEC];                /* указатель записи в секторе (WP_NONE — не стёрт) */
    int      run;                           /* принята команда RUN */
    uint32_t n_frm, n_err;
} bootp_t;

uint32_t crc32_upd(uint32_t crc, const uint8_t *p, uint32_t n);   /* crc32_upd(0, …) — CRC-32 */
uint32_t bootp_crc(const bootp_io_t *io, uint32_t size);          /* CRC-32 образа без поля crc */
/* проверка образа: заголовок, указатель стека, вектор сброса; full — и CRC-32. 1 — образ верен */
int  bootp_valid(const bootp_io_t *io, int full, app_hdr_t *h);
void bootp_init(bootp_t *b, const bootp_io_t *io, void (*send)(const uint8_t *p, int n));
/* принятые байты; возвращает число обработанных кадров загрузчика */
int  bootp_feed(bootp_t *b, const uint8_t *d, int n);
/* для ПО МК: накопление байт в buf (size байт, *n занято) и поиск команды ENTER; 1 — найдена */
int  bootp_detect(uint8_t *buf, int *n, int size, const uint8_t *d, int nd);

#endif
