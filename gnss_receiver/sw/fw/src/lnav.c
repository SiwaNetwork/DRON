/* МГП-8: навигационное сообщение GPS LNAV — синхронизация по преамбуле 10001011 (любая
 * полярность), проверка чётности (IS-GPS-200, табл. 20-XIV), разбор подкадров 1–3 (эфемериды,
 * часы) и подкадра 4 стр. 18 (Клобучар, UTC). Раскладка полей — IS-GPS-200, рис. 20-1. */
#include <math.h>
#include <string.h>
#include "gnss.h"
#include "lnav.h"

#define SC2RAD 3.1415926535898          /* полуокружности -> радианы (значение π по ИКД) */
#define P2(n)  ldexp(1.0, n)

static uint32_t getbitu(const uint8_t *b, int pos, int len)
{
    uint32_t v = 0;
    for (int i = pos; i < pos + len; i++) v = (v << 1) | ((b[i >> 3] >> (7 - (i & 7))) & 1u);
    return v;
}

static int32_t getbits(const uint8_t *b, int pos, int len)
{
    uint32_t v = getbitu(b, pos, len);
    if (len < 32 && (v & (1u << (len - 1)))) return (int32_t)(v | (~0u << len));
    return (int32_t)v;
}

static void setbitu(uint8_t *b, int pos, int len, uint32_t v)
{
    for (int i = 0; i < len; i++) {
        int bit = (v >> (len - 1 - i)) & 1, p = pos + i;
        if (bit) b[p >> 3] |= (uint8_t)(1u << (7 - (p & 7)));
        else b[p >> 3] &= (uint8_t)~(1u << (7 - (p & 7)));
    }
}

static void setbits(uint8_t *b, int pos, int len, int32_t v)
{
    setbitu(b, pos, len, (uint32_t)v & (len < 32 ? ((1u << len) - 1) : 0xFFFFFFFFu));
}

/* маски данных d1..d24 для D25..D30 (бит 23 маски = d1) */
static const uint32_t PMASK[6] = {0xEC7CD2, 0x763E69, 0xBB1F34, 0x5D8F9A, 0xAEC7CD, 0x2DEA27};

static int par(uint32_t x) { x ^= x >> 16; x ^= x >> 8; x ^= x >> 4; x ^= x >> 2; x ^= x >> 1; return (int)(x & 1); }

/* слово 30 бит (D1..D30 в разрядах 29..0) и D29*, D30* предыдущего слова -> данные 24 бит или −1 */
static int32_t word_check(uint32_t w, int d29, int d30)
{
    uint32_t d = (w >> 6) & 0xFFFFFF;
    if (d30) d ^= 0xFFFFFF;
    uint32_t p = 0;
    for (int k = 0; k < 6; k++) {
        int pre = (k == 0 || k == 2 || k == 5) ? d29 : d30;
        p = (p << 1) | (uint32_t)(pre ^ par(d & PMASK[k]));
    }
    return (p == (w & 0x3F)) ? (int32_t)d : -1;
}

static uint32_t word_encode(uint32_t d, int d29, int d30)
{
    uint32_t p = 0;
    for (int k = 0; k < 6; k++) {
        int pre = (k == 0 || k == 2 || k == 5) ? d29 : d30;
        p = (p << 1) | (uint32_t)(pre ^ par(d & PMASK[k]));
    }
    return ((d30 ? d ^ 0xFFFFFF : d) << 6) | p;
}

void lnav_init(lnav_t *l, int prn)
{
    memset(l, 0, sizeof(*l));
    l->prn = prn;
}

static int wbit(const lnav_t *l, int i) { return (l->win[i >> 3] >> (7 - (i & 7))) & 1; }

static void decode_sf(lnav_t *l, int id)
{
    const uint8_t *b = l->sf[id - 1];
    eph_t *e = &l->eph;
    if (id == 1) {
        l->week = (int)getbitu(b, 48, 10) + 1024 * 2;       /* эпоха недель с 07.04.2019 */
        e->sva = (int)getbitu(b, 60, 4);
        e->svh = (int)getbitu(b, 64, 6);
        int iodc0 = (int)getbitu(b, 70, 2);
        e->tgd = getbits(b, 160, 8) * P2(-31);
        e->iodc = (iodc0 << 8) | (int)getbitu(b, 168, 8);
        e->toc = getbitu(b, 176, 16) * 16.0;
        e->af2 = getbits(b, 192, 8) * P2(-55);
        e->af1 = getbits(b, 200, 16) * P2(-43);
        e->af0 = getbits(b, 216, 22) * P2(-31);
    } else if (id == 2) {
        e->iode = (int)getbitu(b, 48, 8);
        e->crs = getbits(b, 56, 16) * P2(-5);
        e->dn = getbits(b, 72, 16) * P2(-43) * SC2RAD;
        e->M0 = getbits(b, 88, 32) * P2(-31) * SC2RAD;
        e->cuc = getbits(b, 120, 16) * P2(-29);
        e->e = getbitu(b, 136, 32) * P2(-33);
        e->cus = getbits(b, 168, 16) * P2(-29);
        e->sqrtA = getbitu(b, 184, 32) * P2(-19);
        e->toe = getbitu(b, 216, 16) * 16.0;
    } else if (id == 3) {
        e->cic = getbits(b, 48, 16) * P2(-29);
        e->OMG0 = getbits(b, 64, 32) * P2(-31) * SC2RAD;
        e->cis = getbits(b, 96, 16) * P2(-29);
        e->i0 = getbits(b, 112, 32) * P2(-31) * SC2RAD;
        e->crc = getbits(b, 144, 16) * P2(-5);
        e->omg = getbits(b, 160, 32) * P2(-31) * SC2RAD;
        e->OMGd = getbits(b, 192, 24) * P2(-43) * SC2RAD;
        e->idot = getbits(b, 224, 14) * P2(-43) * SC2RAD;
    } else if (id == 4 && getbitu(b, 50, 6) == 56) {         /* стр. 18: ионосфера, UTC */
        l->ion[0] = getbits(b, 56, 8) * P2(-30);
        l->ion[1] = getbits(b, 64, 8) * P2(-27);
        l->ion[2] = getbits(b, 72, 8) * P2(-24);
        l->ion[3] = getbits(b, 80, 8) * P2(-24);
        l->ion[4] = getbits(b, 88, 8) * P2(11);
        l->ion[5] = getbits(b, 96, 8) * P2(14);
        l->ion[6] = getbits(b, 104, 8) * P2(16);
        l->ion[7] = getbits(b, 112, 8) * P2(16);
        l->utc_a1 = getbits(b, 120, 24) * P2(-50);
        l->utc_a0 = getbits(b, 144, 32) * P2(-30);
        l->dt_ls = getbits(b, 192, 8);
        l->ion_ok = l->ok_utc = 1;
    }
    /* полные эфемериды: подкадры 1, 2, 3 с согласованными IODC/IODE */
    if (id <= 3) l->have |= 1 << id;
    if ((l->have & 0xE) == 0xE) {
        int iode3 = (int)getbitu(l->sf[2], 216, 8);
        if (e->iode == iode3 && (e->iodc & 0xFF) == e->iode) {
            e->sys = SYS_GPS; e->prn = (uint8_t)l->prn; e->valid = 1; e->week = l->week;
            l->eph_new = 1;
        }
        l->have = 0;
    }
}

int lnav_bit(lnav_t *l, int bit, uint64_t n_end)
{
    /* окно 302 бита: сдвиг влево, новый бит — в конец */
    for (int i = 0; i < 37; i++) l->win[i] = (uint8_t)((l->win[i] << 1) | (l->win[i + 1] >> 7));
    l->win[37] = (uint8_t)((l->win[37] << 1) | (bit & 1));
    /* окно занимает разряды 302 младших бит массива 38 байт (304 бита): индексы 2..303 */
    l->nbit++;
    if (!l->sync && l->nbit < 302) return 0;
    if (l->sync && l->nbit != 300) return 0;            /* после синхронизации — каждые 300 бит */
    /* проверка подкадра: биты 2..301 окна — подкадр, 0..1 — D29*, D30* предыдущего */
    int base = 2;
    uint32_t w[10];
    for (int k = 0; k < 10; k++) {
        uint32_t v = 0;
        for (int i = 0; i < 30; i++) v = (v << 1) | (uint32_t)wbit(l, base + 2 + 30 * k + i);
        w[k] = v;
    }
    int pre = (int)(w[0] >> 22);
    int pol;
    if (pre == 0x8B) pol = 0;
    else if (pre == 0x74) pol = 1;
    else {
        if (l->sync) { l->sync = 0; l->nbit = 302; }
        return 0;
    }
    int d29 = wbit(l, base) ^ pol, d30 = wbit(l, base + 1) ^ pol;
    uint8_t data[30] = {0};
    for (int k = 0; k < 10; k++) {
        uint32_t ww = pol ? (w[k] ^ 0x3FFFFFFF) : w[k];
        int32_t d = word_check(ww, d29, d30);
        if (d < 0) {
            if (l->sync) { l->n_parity_err++; l->sync = 0; l->nbit = 302; }   /* поиск заново */
            return 0;
        }
        setbitu(data, 24 * k, 24, (uint32_t)d);
        d29 = (ww >> 1) & 1; d30 = ww & 1;
    }
    int id = (int)getbitu(data, 43, 3);
    if (id < 1 || id > 5) return 0;
    memcpy(l->sf[id - 1], data, 30);
    l->sync = 1;
    l->pol = pol;
    l->nbit = 0;
    l->n_sf++;
    /* TOW из HOW — время начала следующего подкадра */
    l->sf_end_tow = getbitu(data, 24, 17) * 6.0;
    l->sf_end_n = n_end;
    l->tow_ok = 1;
    decode_sf(l, id);
    return id;
}

void lnav_encode(const eph_t *e, int sfid, int tow, int d29, int d30, uint8_t bits[300])
{
    uint8_t b[30] = {0};
    setbitu(b, 0, 8, 0x8B);                            /* TLM: преамбула */
    setbitu(b, 24, 17, (uint32_t)tow);                 /* HOW: TOW следующего подкадра */
    setbitu(b, 43, 3, (uint32_t)sfid);
    if (sfid == 1) {
        setbitu(b, 48, 10, (uint32_t)(e->week % 1024));
        setbitu(b, 60, 4, (uint32_t)e->sva);
        setbitu(b, 64, 6, (uint32_t)e->svh);
        setbitu(b, 70, 2, (uint32_t)(e->iodc >> 8));
        setbits(b, 160, 8, (int32_t)lround(e->tgd / P2(-31)));
        setbitu(b, 168, 8, (uint32_t)(e->iodc & 0xFF));
        setbitu(b, 176, 16, (uint32_t)lround(e->toc / 16.0));
        setbits(b, 192, 8, (int32_t)lround(e->af2 / P2(-55)));
        setbits(b, 200, 16, (int32_t)lround(e->af1 / P2(-43)));
        setbits(b, 216, 22, (int32_t)lround(e->af0 / P2(-31)));
    } else if (sfid == 2) {
        setbitu(b, 48, 8, (uint32_t)e->iode);
        setbits(b, 56, 16, (int32_t)lround(e->crs / P2(-5)));
        setbits(b, 72, 16, (int32_t)lround(e->dn / SC2RAD / P2(-43)));
        setbits(b, 88, 32, (int32_t)llround(e->M0 / SC2RAD / P2(-31)));
        setbits(b, 120, 16, (int32_t)lround(e->cuc / P2(-29)));
        setbitu(b, 136, 32, (uint32_t)llround(e->e / P2(-33)));
        setbits(b, 168, 16, (int32_t)lround(e->cus / P2(-29)));
        setbitu(b, 184, 32, (uint32_t)llround(e->sqrtA / P2(-19)));
        setbitu(b, 216, 16, (uint32_t)lround(e->toe / 16.0));
    } else if (sfid == 3) {
        setbits(b, 48, 16, (int32_t)lround(e->cic / P2(-29)));
        setbits(b, 64, 32, (int32_t)llround(e->OMG0 / SC2RAD / P2(-31)));
        setbits(b, 96, 16, (int32_t)lround(e->cis / P2(-29)));
        setbits(b, 112, 32, (int32_t)llround(e->i0 / SC2RAD / P2(-31)));
        setbits(b, 144, 16, (int32_t)lround(e->crc / P2(-5)));
        setbits(b, 160, 32, (int32_t)llround(e->omg / SC2RAD / P2(-31)));
        setbits(b, 192, 24, (int32_t)lround(e->OMGd / SC2RAD / P2(-43)));
        setbitu(b, 216, 8, (uint32_t)e->iode);
        setbits(b, 224, 14, (int32_t)lround(e->idot / SC2RAD / P2(-43)));
    } else {
        /* подкадры 4, 5: в имитаторе — псевдослучайные данные (как альманах; число переходов
         * бит важно для синхронизации), номер страницы (SV ID) — не 56 (не ионосферная) */
        uint32_t r = (uint32_t)tow * 2654435761u + (uint32_t)sfid;
        for (int k = 2; k < 10; k++) {
            r ^= r << 13; r ^= r >> 17; r ^= r << 5;
            setbitu(b, 24 * k, 24, r & 0xFFFFFF);
        }
        setbitu(b, 48, 2, 1);
        setbitu(b, 50, 6, (uint32_t)(25 + tow % 25));
    }
    /* слова 2 и 10: биты 23, 24 подбираются так, чтобы D29 = D30 = 0 (IS-GPS-200, 20.3.5.2) */
    for (int k = 0; k < 10; k++) {
        uint32_t d = getbitu(b, 24 * k, 24);
        if (k == 1 || k == 9) {
            for (uint32_t t = 0; t < 4; t++) {
                uint32_t dd = (d & ~3u) | t, w = word_encode(dd, d29, d30);
                if ((w & 3) == 0) { d = dd; break; }
            }
        }
        uint32_t w = word_encode(d, d29, d30);
        for (int i = 0; i < 30; i++) bits[30 * k + i] = (uint8_t)((w >> (29 - i)) & 1);
        d29 = (w >> 1) & 1; d30 = w & 1;
    }
}
