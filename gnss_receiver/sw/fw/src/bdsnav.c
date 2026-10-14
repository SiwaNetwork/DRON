/* МГП-8: навигационное сообщение BeiDou D1 — синхронизация по синхрокомбинации (любая
 * полярность), обратное перемежение и исправление BCH(15,11) (g(x) = x⁴ + x + 1), контроль
 * SOW соседних подкадров, разбор подкадров 1–3 (BDS-SIS-ICD-B1I-3.0, п. 5.2.4). Соглашения
 * сверены с GNSS-SDR (beidou_dnav_telemetry_decoder_gs.cc, Beidou_DNAV.h). BCH(15,11) —
 * совершенный код: двойная ошибка в слове «исправляется» в неверное кодовое слово и не
 * обнаруживается. Поэтому эфемериды принимаются, если в подкадрах 1–3 не было исправлений, или
 * если они совпали с подкадрами предыдущего кадра. */
#include <math.h>
#include <string.h>
#include "gnss.h"
#include "bdsnav.h"

#define SC2RAD 3.1415926535898          /* полуокружности -> радианы (значение π по ИКД) */
#define P2(n)  ldexp(1.0, n)
#define NWIN   311
#define NPRE   11

static const uint8_t PRE[NPRE] = {1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0};
/* ионосфера в кодере (в имитаторе — постоянные, коды α0..α3, β0..β3) */
static const int ION_SIM[8] = {12, 2, -10, 3, 70, 10, -3, -2};

static uint32_t getbitu(const uint8_t *b, int pos, int len)
{
    uint32_t v = 0;
    for (int i = pos; i < pos + len; i++) v = (v << 1) | ((b[i >> 3] >> (7 - (i & 7))) & 1u);
    return v;
}

static int32_t sext(uint32_t v, int len)
{
    if (len < 32 && (v & (1u << (len - 1)))) return (int32_t)(v | (~0u << len));
    return (int32_t)v;
}

static int32_t getbits(const uint8_t *b, int pos, int len) { return sext(getbitu(b, pos, len), len); }

/* поле из двух частей (продолжение — в следующем слове) */
static uint32_t get2u(const uint8_t *b, int p1, int l1, int p2, int l2)
{
    return (getbitu(b, p1, l1) << l2) | getbitu(b, p2, l2);
}

static int32_t get2s(const uint8_t *b, int p1, int l1, int p2, int l2)
{
    return sext(get2u(b, p1, l1, p2, l2), l1 + l2);
}

static void setbitu(uint8_t *b, int pos, int len, uint32_t v)
{
    for (int i = 0; i < len; i++) {
        int bit = (v >> (len - 1 - i)) & 1, p = pos + i;
        if (bit) b[p >> 3] |= (uint8_t)(1u << (7 - (p & 7)));
        else b[p >> 3] &= (uint8_t)~(1u << (7 - (p & 7)));
    }
}

static void setbits(uint8_t *b, int pos, int len, int64_t v)
{
    setbitu(b, pos, len, (uint32_t)(v & (((int64_t)1 << len) - 1)));
}

static void set2s(uint8_t *b, int p1, int l1, int p2, int l2, int64_t v)
{
    uint32_t u = (uint32_t)(v & (((int64_t)1 << (l1 + l2)) - 1));
    setbitu(b, p1, l1, u >> l2);
    setbitu(b, p2, l2, u & ((1u << l2) - 1));
}

/* остаток от деления на g(x) = x⁴ + x + 1 */
static uint32_t bch_mod(uint32_t v)
{
    for (int i = 14; i >= 4; i--) if (v >> i & 1) v ^= 0x13u << (i - 4);
    return v;
}

uint32_t bdsnav_bch_enc(uint32_t info11)
{
    return (info11 << 4) | bch_mod(info11 << 4);
}

uint32_t bdsnav_bch_dec(uint32_t cw15, int *nerr)
{
    uint32_t s = bch_mod(cw15);
    if (s) {
        for (int i = 0; i < 15; i++)
            if (bch_mod(1u << i) == s) { cw15 ^= 1u << i; break; }
        (*nerr)++;
    }
    return cw15;
}

void bdsnav_init(bdsnav_t *b, int prn)
{
    memset(b, 0, sizeof(*b));
    b->prn = prn;
    b->sow_prev = -1;
    for (int k = 0; k < 3; k++) b->sow_sf[k] = -1;
}

static int pre_err(const uint8_t *w, int pol)
{
    int n = 0;
    for (int i = 0; i < NPRE; i++) n += (w[i] ^ pol) != PRE[i];
    return n;
}

static int pre_pol(const uint8_t *w)
{
    return pre_err(w, 0) == 0 ? 0 : pre_err(w, 1) == 0 ? 1 : -1;
}

/* 300 бит линии -> подкадр (раскладка ИКД, проверочные биты на местах) */
static void deint(const uint8_t *w, int pol, uint8_t *sf, int *nerr)
{
    memset(sf, 0, 38);
    for (int i = 0; i < 15; i++) setbitu(sf, i, 1, (uint32_t)(w[i] ^ pol));
    uint32_t cw = 0;
    for (int i = 15; i < 30; i++) cw = (cw << 1) | (uint32_t)(w[i] ^ pol);
    setbitu(sf, 15, 15, bdsnav_bch_dec(cw, nerr));
    for (int k = 1; k < 10; k++) {
        const uint8_t *s = w + 30 * k;
        uint32_t a = 0, c = 0;
        for (int i = 0; i < 15; i++) {
            a = (a << 1) | (uint32_t)(s[2 * i] ^ pol);
            c = (c << 1) | (uint32_t)(s[2 * i + 1] ^ pol);
        }
        a = bdsnav_bch_dec(a, nerr);
        c = bdsnav_bch_dec(c, nerr);
        setbitu(sf, 30 * k, 11, a >> 4);
        setbitu(sf, 30 * k + 11, 11, c >> 4);
        setbitu(sf, 30 * k + 22, 4, a & 15);
        setbitu(sf, 30 * k + 26, 4, c & 15);
    }
}

/* подкадр -> 300 бит линии: проверочные биты BCH и перемежение слов 2–10 */
static void inter(uint8_t *sf, uint8_t *w)
{
    setbitu(sf, 26, 4, bdsnav_bch_enc(getbitu(sf, 15, 11)) & 15);
    for (int i = 0; i < 30; i++) w[i] = (uint8_t)getbitu(sf, i, 1);
    for (int k = 1; k < 10; k++) {
        uint32_t a = bdsnav_bch_enc(getbitu(sf, 30 * k, 11)), c = bdsnav_bch_enc(getbitu(sf, 30 * k + 11, 11));
        for (int i = 0; i < 15; i++) {
            w[30 * k + 2 * i] = (uint8_t)(a >> (14 - i) & 1);
            w[30 * k + 2 * i + 1] = (uint8_t)(c >> (14 - i) & 1);
        }
    }
}

static double bdt2gpst(double t) { return fmod(t + GPST_BDT, 604800.0); }

/* эфемериды по подкадрам 1–3 одного кадра */
static void decode_eph(bdsnav_t *b)
{
    const uint8_t *s1 = b->sf[0], *s2 = b->sf[1], *s3 = b->sf[2];
    eph_t *e = &b->eph;
    memset(e, 0, sizeof(*e));
    e->svh = (int)getbitu(s1, 42, 1);
    e->iodc = (int)getbitu(s1, 43, 5);
    e->sva = (int)getbitu(s1, 48, 4);
    b->week = (int)getbitu(s1, 60, 13) + BDS_GPS_WEEK;
    e->toc = bdt2gpst(get2u(s1, 73, 9, 90, 8) * 8.0);
    e->tgd = getbits(s1, 98, 10) * 0.1e-9;                  /* TGD1 (B1I) */
    e->tgd2 = get2s(s1, 108, 4, 120, 6) * 0.1e-9;           /* TGD2 (B2I) */
    b->ion[0] = getbits(s1, 126, 8) * P2(-30);
    b->ion[1] = getbits(s1, 134, 8) * P2(-27);
    b->ion[2] = getbits(s1, 150, 8) * P2(-24);
    b->ion[3] = getbits(s1, 158, 8) * P2(-24);
    b->ion[4] = get2s(s1, 166, 6, 180, 2) * P2(11);
    b->ion[5] = getbits(s1, 182, 8) * P2(14);
    b->ion[6] = getbits(s1, 190, 8) * P2(16);
    b->ion[7] = get2s(s1, 198, 4, 210, 4) * P2(16);
    b->ion_ok = 1;
    e->af2 = getbits(s1, 214, 11) * P2(-66);
    e->af0 = get2s(s1, 225, 7, 240, 17) * P2(-33);
    e->af1 = get2s(s1, 257, 5, 270, 17) * P2(-50);
    e->iode = (int)getbitu(s1, 287, 5);
    e->dn = get2s(s2, 42, 10, 60, 6) * P2(-43) * SC2RAD;
    e->cuc = get2s(s2, 66, 16, 90, 2) * P2(-31);
    e->M0 = get2s(s2, 92, 20, 120, 12) * P2(-31) * SC2RAD;
    e->e = get2u(s2, 132, 10, 150, 22) * P2(-33);
    e->cus = getbits(s2, 180, 18) * P2(-31);
    e->crc = get2s(s2, 198, 4, 210, 14) * P2(-6);
    e->crs = get2s(s2, 224, 8, 240, 10) * P2(-6);
    e->sqrtA = get2u(s2, 250, 12, 270, 20) * P2(-19);
    e->toe = bdt2gpst(((getbitu(s2, 290, 2) << 15) | get2u(s3, 42, 10, 60, 5)) * 8.0);
    e->i0 = get2s(s3, 65, 17, 90, 15) * P2(-31) * SC2RAD;
    e->cic = get2s(s3, 105, 7, 120, 11) * P2(-31);
    e->OMGd = get2s(s3, 131, 11, 150, 13) * P2(-43) * SC2RAD;
    e->cis = get2s(s3, 163, 9, 180, 9) * P2(-31);
    e->idot = get2s(s3, 189, 13, 210, 1) * P2(-43) * SC2RAD;
    e->OMG0 = get2s(s3, 211, 21, 240, 11) * P2(-31) * SC2RAD;
    e->omg = get2s(s3, 251, 11, 270, 21) * P2(-31) * SC2RAD;
    e->sys = SYS_BDS; e->prn = (uint8_t)b->prn; e->valid = 1; e->week = b->week;
    b->eph_new = 1;
}

/* подкадры 1–3 двух кадров совпадают без SOW: биты 42–51 и слова 3–10 (проверочные биты
 * слова 2 зависят от SOW) */
static int same_frame(const uint8_t a[][38], const uint8_t c[][38])
{
    for (int k = 0; k < 3; k++) {
        if (getbitu(a[k], 42, 10) != getbitu(c[k], 42, 10)) return 0;
        for (int i = 60; i < 300; i += 30)
            if (getbitu(a[k], i, 30) != getbitu(c[k], i, 30)) return 0;
    }
    return 1;
}

/* подкадр w (300 бит линии); timed — подкадр принят в синхронизации (n_end — его конец) */
static int subframe(bdsnav_t *b, const uint8_t *w, uint64_t n_end, int timed)
{
    uint8_t sf[38];
    int nc = b->n_corr;
    deint(w, b->pol, sf, &b->n_corr);
    nc = b->n_corr - nc;
    int id = (int)getbitu(sf, 15, 3), sow = (int)((getbitu(sf, 18, 8) << 12) | getbitu(sf, 30, 12));
    if (id < 1 || id > 5 || sow >= 604800 || sow % 6) { b->sow_prev = -1; return 0; }
    int cons = b->sow_prev >= 0 && sow == (b->sow_prev + 6) % 604800;
    if (b->sow_prev >= 0 && !cons) b->n_sow_err++;
    b->sow_prev = sow;
    memcpy(b->sf[id - 1], sf, sizeof sf);
    b->n_sf++;
    if (id <= 3) {
        b->sow_sf[id - 1] = sow;
        b->nc_sf[id - 1] = nc;
        if (id == 3 && b->sow_sf[1] == (b->sow_sf[0] + 6) % 604800 && sow == (b->sow_sf[0] + 12) % 604800) {
            int clean = !b->nc_sf[0] && !b->nc_sf[1] && !b->nc_sf[2];
            int rep = b->prev_ok && same_frame((const uint8_t (*)[38])b->sf, (const uint8_t (*)[38])b->prev);
            memcpy(b->prev, b->sf, sizeof b->prev);
            b->prev_ok = 1;
            if (clean || rep) decode_eph(b);
        }
    }
    if (!timed || !cons) return 0;
    b->tow_ok = 1;
    b->sf_end_n = n_end;
    b->sf_end_tow = bdt2gpst(sow + 6.0);
    return id;
}

int bdsnav_bit(bdsnav_t *b, int bit, uint64_t n_end)
{
    memmove(b->win, b->win + 1, NWIN - 1);
    b->win[NWIN - 1] = (uint8_t)(bit & 1);
    if (b->nbit < NWIN) b->nbit++;
    if (!b->sync) {
        /* поиск: синхрокомбинации в начале двух соседних подкадров с одной полярностью */
        if (b->nbit < NWIN) return 0;
        int p0 = pre_pol(b->win), p1 = pre_pol(b->win + 300);
        if (p0 < 0 || p0 != p1) return 0;
        b->sync = 1;
        b->pol = p0;
        b->cnt = NPRE;
        b->miss = 0;
        b->sow_prev = -1;
        b->tow_ok = 0;
        subframe(b, b->win, n_end, 0);                       /* без привязки: конец был раньше */
        return 0;
    }
    if (++b->cnt < 300) return 0;
    b->cnt = 0;
    /* синхрокомбинация на ожидаемом месте: полярность — по большинству, два пропуска подряд —
     * потеря синхронизации */
    const uint8_t *w = b->win + NPRE;
    int e0 = pre_err(w, 0), e1 = pre_err(w, 1);
    b->pol = e1 < e0;
    if ((e0 < e1 ? e0 : e1) > 2) {
        if (b->sow_prev >= 0) b->sow_prev = (b->sow_prev + 6) % 604800;
        if (++b->miss >= 2) { b->sync = 0; b->tow_ok = 0; }
        return 0;
    }
    b->miss = 0;
    return subframe(b, w, n_end, 1);
}

void bdsnav_encode(const eph_t *e, int sfid, int sow, uint8_t bits[300])
{
    uint8_t s[38] = {0};
    for (int i = 0; i < NPRE; i++) setbitu(s, i, 1, PRE[i]);
    setbitu(s, 15, 3, (uint32_t)sfid);
    setbitu(s, 18, 8, (uint32_t)sow >> 12);
    setbitu(s, 30, 12, (uint32_t)sow & 0xFFF);
    double toc = fmod(e->toc - GPST_BDT + 604800, 604800) / 8, toe = fmod(e->toe - GPST_BDT + 604800, 604800) / 8;
    if (sfid == 1) {
        setbitu(s, 42, 1, (uint32_t)e->svh & 1);
        setbitu(s, 43, 5, (uint32_t)e->iodc & 31);
        setbitu(s, 48, 4, (uint32_t)e->sva & 15);
        setbitu(s, 60, 13, (uint32_t)(e->week - BDS_GPS_WEEK) & 0x1FFF);
        set2s(s, 73, 9, 90, 8, lround(toc));
        setbits(s, 98, 10, lround(e->tgd / 0.1e-9));
        set2s(s, 108, 4, 120, 6, lround(e->tgd2 / 0.1e-9));
        setbits(s, 126, 8, ION_SIM[0]);
        setbits(s, 134, 8, ION_SIM[1]);
        setbits(s, 150, 8, ION_SIM[2]);
        setbits(s, 158, 8, ION_SIM[3]);
        set2s(s, 166, 6, 180, 2, ION_SIM[4]);
        setbits(s, 182, 8, ION_SIM[5]);
        setbits(s, 190, 8, ION_SIM[6]);
        set2s(s, 198, 4, 210, 4, ION_SIM[7]);
        setbits(s, 214, 11, lround(e->af2 / P2(-66)));
        set2s(s, 225, 7, 240, 17, llround(e->af0 / P2(-33)));
        set2s(s, 257, 5, 270, 17, llround(e->af1 / P2(-50)));
        setbitu(s, 287, 5, (uint32_t)e->iode & 31);
    } else if (sfid == 2) {
        set2s(s, 42, 10, 60, 6, lround(e->dn / SC2RAD / P2(-43)));
        set2s(s, 66, 16, 90, 2, lround(e->cuc / P2(-31)));
        set2s(s, 92, 20, 120, 12, llround(e->M0 / SC2RAD / P2(-31)));
        set2s(s, 132, 10, 150, 22, llround(e->e / P2(-33)));
        setbits(s, 180, 18, lround(e->cus / P2(-31)));
        set2s(s, 198, 4, 210, 14, lround(e->crc / P2(-6)));
        set2s(s, 224, 8, 240, 10, lround(e->crs / P2(-6)));
        set2s(s, 250, 12, 270, 20, llround(e->sqrtA / P2(-19)));
        setbitu(s, 290, 2, (uint32_t)lround(toe) >> 15);
    } else if (sfid == 3) {
        set2s(s, 42, 10, 60, 5, lround(toe) & 0x7FFF);
        set2s(s, 65, 17, 90, 15, llround(e->i0 / SC2RAD / P2(-31)));
        set2s(s, 105, 7, 120, 11, lround(e->cic / P2(-31)));
        set2s(s, 131, 11, 150, 13, lround(e->OMGd / SC2RAD / P2(-43)));
        set2s(s, 163, 9, 180, 9, lround(e->cis / P2(-31)));
        set2s(s, 189, 13, 210, 1, lround(e->idot / SC2RAD / P2(-43)));
        set2s(s, 211, 21, 240, 11, llround(e->OMG0 / SC2RAD / P2(-31)));
        set2s(s, 251, 11, 270, 21, llround(e->omg / SC2RAD / P2(-31)));
    } else {
        /* подкадры 4, 5 (альманах, время систем): в имитаторе — псевдослучайные данные */
        uint32_t r = (uint32_t)sow * 2654435761u + (uint32_t)sfid * 40503u + e->prn;
        for (int k = 1; k < 10; k++) {
            r ^= r << 13; r ^= r >> 17; r ^= r << 5;
            if (k == 1) setbitu(s, 42, 10, r & 0x3FF);
            else setbitu(s, 30 * k, 22, r & 0x3FFFFF);
        }
        setbitu(s, 43, 7, (uint32_t)(sow / 30 % 24 + 1));   /* Pnum */
    }
    inter(s, bits);
}
