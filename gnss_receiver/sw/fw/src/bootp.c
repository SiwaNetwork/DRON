/* МГП-8: загрузчик — проверка образа и протокол обновления (описание — inc/bootp.h). */
#include <string.h>
#include "bootp.h"

#define WP_NONE 0xFFFFFFFFu

uint32_t crc32_upd(uint32_t crc, const uint8_t *p, uint32_t n)
{
    static const uint32_t T[16] = {
        0x00000000, 0x1DB71064, 0x3B6E20C8, 0x26D930AC, 0x76DC4190, 0x6B6B51F4, 0x4DB26158, 0x5005713C,
        0xEDB88320, 0xF00F9344, 0xD6D6A3E8, 0xCB61B38C, 0x9B64C2B0, 0x86D3D2D4, 0xA00AE278, 0xBDBDF21C};
    crc = ~crc;
    for (uint32_t i = 0; i < n; i++) {
        crc ^= p[i];
        crc = (crc >> 4) ^ T[crc & 15];
        crc = (crc >> 4) ^ T[crc & 15];
    }
    return ~crc;
}

static uint32_t rd32(const uint8_t *p) { return p[0] | p[1] << 8 | p[2] << 16 | (uint32_t)p[3] << 24; }

uint32_t bootp_crc(const bootp_io_t *io, uint32_t size)
{
    uint32_t c = crc32_upd(0, io->img, APP_HDR_OFF + 8);
    return crc32_upd(c, io->img + APP_HDR_OFF + 12, size - APP_HDR_OFF - 12);
}

static void hdr(const bootp_io_t *io, app_hdr_t *h)
{
    const uint8_t *p = io->img + APP_HDR_OFF;
    h->magic = rd32(p); h->size = rd32(p + 4); h->crc = rd32(p + 8); h->ver = rd32(p + 12);
}

int bootp_valid(const bootp_io_t *io, int full, app_hdr_t *h)
{
    app_hdr_t t;
    if (!h) h = &t;
    hdr(io, h);
    if (h->magic != APP_MAGIC || h->size < APP_MIN_SIZE || h->size > io->size || h->size % BOOTP_WORD) return 0;
    uint32_t sp = rd32(io->img), rv = rd32(io->img + 4);
    int sp_ok = (sp > 0x20000000u && sp <= 0x20020000u) || (sp > 0x24000000u && sp <= 0x24080000u);
    if (!sp_ok || (sp & 7)) return 0;
    if (!(rv & 1) || (rv & ~1u) < io->base + APP_MIN_SIZE || (rv & ~1u) >= io->base + h->size) return 0;
    return !full || bootp_crc(io, h->size) == h->crc;
}

void bootp_init(bootp_t *b, const bootp_io_t *io, void (*send)(const uint8_t *p, int n))
{
    memset(b, 0, sizeof(*b));
    b->io = io; b->send = send;
    for (int i = 0; i < BOOTP_NSEC; i++) b->wp[i] = WP_NONE;
}

/* ответ: данные уже записаны с b->tx + 6 */
typedef struct { uint8_t *p; int n; } wr_t;
static void w8(wr_t *w, uint32_t v) { w->p[w->n++] = (uint8_t)v; }
static void w32(wr_t *w, uint32_t v) { for (int i = 0; i < 4; i++) w8(w, v >> 8 * i); }

static int st_write(bootp_t *b, uint32_t off, const uint8_t *d, uint32_t n)
{
    const bootp_io_t *io = b->io;
    if (n == 0 || n % BOOTP_WORD || n > 32 * BOOTP_WORD) return BP_E_LEN;
    if (off % BOOTP_WORD) return BP_E_ALIGN;
    if (off >= io->size || n > io->size - off) return BP_E_RANGE;
    for (uint32_t k = 0; k < n; k += BOOTP_WORD) {
        uint32_t o = off + k, s = o / io->sector, in = o % io->sector;
        if (s >= BOOTP_NSEC || b->wp[s] == WP_NONE || in < b->wp[s]) return BP_E_ERASE;
        if (io->prog(o, d + k)) return BP_E_FLASH;
        b->wp[s] = in + BOOTP_WORD;
    }
    return BP_OK;
}

static void cmd(bootp_t *b, int id, const uint8_t *pl, int plen)
{
    const bootp_io_t *io = b->io;
    wr_t w = {b->tx + 6, 0};
    app_hdr_t h;
    int st = BP_OK;
    uint32_t off = plen >= 4 ? rd32(pl) : 0;
    switch (id) {
    case BP_INFO: {
        int ok = bootp_valid(io, 1, &h);
        w8(&w, BP_OK); w32(&w, BOOT_VER); w32(&w, io->base); w32(&w, io->size); w32(&w, io->sector);
        w8(&w, (uint32_t)ok); w32(&w, ok ? h.ver : 0); w32(&w, ok ? h.size : 0);
        break;
    }
    case BP_ERASE:
        if (plen != 4) st = BP_E_LEN;
        else if (off % io->sector) st = BP_E_ALIGN;
        else if (off >= io->size || off / io->sector >= BOOTP_NSEC) st = BP_E_RANGE;
        else if (io->erase(off)) st = BP_E_FLASH;
        else b->wp[off / io->sector] = 0;
        w8(&w, (uint32_t)st); w32(&w, off);
        break;
    case BP_WRITE:
        st = plen < 4 ? BP_E_LEN : st_write(b, off, pl + 4, (uint32_t)plen - 4);
        w8(&w, (uint32_t)st); w32(&w, off);
        break;
    case BP_CHECK: {
        int ok = bootp_valid(io, 0, &h);
        uint32_t c = ok ? bootp_crc(io, h.size) : 0;
        w8(&w, ok && c == h.crc ? BP_OK : BP_E_IMG); w32(&w, ok ? h.size : 0); w32(&w, c); w32(&w, ok ? h.ver : 0);
        break;
    }
    case BP_RUN:
        st = bootp_valid(io, 1, 0) ? BP_OK : BP_E_IMG;
        if (st == BP_OK) b->run = 1;
        w8(&w, (uint32_t)st);
        break;
    case BP_ENTER:
        w8(&w, plen == 4 && off == BOOT_REQ_KEY ? BP_OK : BP_E_LEN);
        break;
    default:
        w8(&w, BP_E_CMD);
    }
    if (b->send) b->send(b->tx, mbp_frame(b->tx, MBP_BOOT, id | 0x80, w.n));
}

int bootp_feed(bootp_t *b, const uint8_t *d, int n)
{
    int nf = 0;
    while (n > 0) {
        int k = (int)sizeof(b->rx) - b->n;
        if (k > n) k = n;
        memcpy(b->rx + b->n, d, (size_t)k);
        b->n += k; d += k; n -= k;
        for (;;) {
            int cls, id, plen, used = 0;
            const uint8_t *pl;
            int r = mbp_parse(b->rx, b->n, &cls, &id, &pl, &plen, &used);
            if (r == 0) {
                if (b->n < (int)sizeof(b->rx)) break;
                used = 1;
            } else if (r < 0) {
                b->n_err++;
            } else if (cls == MBP_BOOT && !(id & 0x80)) {
                cmd(b, id, pl, plen);
                b->n_frm++; nf++;
            }
            memmove(b->rx, b->rx + used, (size_t)(b->n - used));
            b->n -= used;
        }
    }
    return nf;
}

int bootp_detect(uint8_t *buf, int *n, int size, const uint8_t *d, int nd)
{
    int found = 0;
    while (nd > 0) {
        int k = size - *n;
        if (k > nd) k = nd;
        memcpy(buf + *n, d, (size_t)k);
        *n += k; d += k; nd -= k;
        for (;;) {
            int cls, id, plen, used = 0;
            const uint8_t *pl;
            int r = mbp_parse(buf, *n, &cls, &id, &pl, &plen, &used);
            if (r == 0) {
                int big = *n >= 6 && (buf[4] | buf[5] << 8) > size - 8;
                if (*n < size && !big) break;
                used = 1;                   /* кадр длиннее буфера — не команда ENTER */
            } else if (r > 0 && cls == MBP_BOOT && id == BP_ENTER && plen == 4 && rd32(pl) == BOOT_REQ_KEY) {
                found = 1;
            }
            memmove(buf, buf + used, (size_t)(*n - used));
            *n -= used;
        }
    }
    return found;
}
