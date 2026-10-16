/* МГП-8: модель загрузчика на ПК для tools/mgp8_flash.py --sim — протокол src/bootp.c через
 * stdin/stdout (двоичный поток вместо UART), флеш-память как у STM32H743: область ПО МК 1920 КБ,
 * секторы 128 КБ, NOR (запись только 1 -> 0), повторная запись слова без стирания — ошибка (ECC).
 * Перед первым кадром выдаёт строку NMEA (поток ПО МК до команды ENTER). По окончании входного
 * потока записывает область флеш-памяти в файл argv[1] (для сравнения с образом).
 *
 *   boot_sim build/boot_sim.img */
#include <stdio.h>
#include <string.h>
#ifdef _WIN32
#include <io.h>
#include <fcntl.h>
#define read  _read
#define write _write
#else
#include <unistd.h>
#endif
#include "bootp.h"

#define SEC   (128u * 1024u)
#define AREA  (1920u * 1024u)
#define BASE  0x08020000u

static uint8_t FL[AREA];
static uint8_t WR[AREA / BOOTP_WORD];
static unsigned n_erase, n_prog, n_err;

static int f_erase(uint32_t off)
{
    if (off % SEC || off >= AREA) return 1;
    memset(FL + off, 0xFF, SEC);
    memset(WR + off / BOOTP_WORD, 0, SEC / BOOTP_WORD);
    n_erase++;
    return 0;
}

static int f_prog(uint32_t off, const uint8_t *p)
{
    if (off % BOOTP_WORD || off >= AREA || WR[off / BOOTP_WORD]) { n_err++; return 1; }
    WR[off / BOOTP_WORD] = 1;
    for (uint32_t i = 0; i < BOOTP_WORD; i++) FL[off + i] &= p[i];
    n_prog++;
    return memcmp(FL + off, p, BOOTP_WORD) != 0;
}

static void out(const uint8_t *p, int n)
{
    while (n > 0) {
        int k = (int)write(1, p, (unsigned)n);
        if (k <= 0) return;
        p += k; n -= k;
    }
}

int main(int argc, char **argv)
{
#ifdef _WIN32
    _setmode(0, _O_BINARY);
    _setmode(1, _O_BINARY);
#endif
    static const bootp_io_t IO = {f_erase, f_prog, FL, BASE, AREA, SEC};
    static bootp_t B;
    memset(FL, 0xFF, sizeof(FL));
    bootp_init(&B, &IO, out);
    static const char nmea[] = "$GNGGA,000000.00,,,,,0,00,99.99,,,,,,*78\r\n";
    out((const uint8_t *)nmea, (int)sizeof(nmea) - 1);
    uint8_t d[4096];
    int k, ran = 0;
    while ((k = (int)read(0, d, sizeof(d))) > 0) {
        bootp_feed(&B, d, k);
        if (B.run) ran = 1;
    }
    app_hdr_t h;
    int ok = bootp_valid(&IO, 1, &h);
    fprintf(stderr, "boot_sim: кадров %u (ошибок %u), стёрто секторов %u, записано слов %u, отказов записи %u, "
            "образ %s (%u байт), RUN %s\n", (unsigned)B.n_frm, (unsigned)B.n_err, n_erase, n_prog, n_err,
            ok ? "верен" : "неверен", ok ? (unsigned)h.size : 0u, ran ? "да" : "нет");
    if (argc > 1) {
        FILE *f = fopen(argv[1], "wb");
        if (!f || fwrite(FL, 1, sizeof(FL), f) != sizeof(FL)) { perror(argv[1]); return 2; }
        fclose(f);
    }
    return ok ? 0 : 1;
}
