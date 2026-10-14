/* МГП-8: навигационное сообщение Galileo I/NAV (E1-B) — синхронизация по частям страницы,
 * обратное перемежение 30 × 8, мягкий декодер Витерби (K = 7, 171/133, G2 инвертирован),
 * CRC-24Q, разбор слов 0–6 (Galileo OS SIS ICD, п. 4.3, табл. 40–50). Соглашения сверены
 * с GNSS-SDR (galileo_telemetry_decoder_gs.cc, galileo_inav_message.cc, viterbi_decoder.cc). */
#include <math.h>
#include <string.h>
#include "gnss.h"
#include "inav.h"

#define SC2RAD 3.1415926535898          /* полуокружности -> радианы (значение π по ИКД) */
#define P2(n)  ldexp(1.0, n)
#define G1     0171                     /* образующие свёрточного кода; старший разряд — вход */
#define G2     0133
#define NBIT   120                      /* бит в части страницы (114 + 6 хвостовых) */
#define NBUF   (INAV_PART + INAV_SYNC)

static const uint8_t SYNC[INAV_SYNC] = {0, 1, 0, 1, 1, 0, 0, 0, 0, 0};
/* ионосфера и UTC в кодере (в имитаторе — постоянные) */
static const double AI_SIM[3] = {62.75, 0.25, 0.0};

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

static int par(uint32_t x) { x ^= x >> 4; x ^= x >> 2; x ^= x >> 1; return (int)(x & 1); }

uint32_t inav_crc24q(const uint8_t *b, int nbit)
{
    uint32_t crc = 0;
    for (int i = 0; i < nbit; i++) {
        crc ^= ((uint32_t)(b[i >> 3] >> (7 - (i & 7))) & 1u) << 23;
        crc = (crc & 0x800000u) ? (crc << 1) ^ 0x864CFBu : crc << 1;
    }
    return crc & 0xFFFFFFu;
}

/* свёрточный код: 2·nb символов (0/1), выход G2 инвертирован; начальное состояние 0 */
static void conv_enc(const uint8_t *bit, int nb, uint8_t *sym)
{
    int s = 0;
    for (int t = 0; t < nb; t++) {
        int reg = (bit[t] << 6) | s;
        sym[2 * t] = (uint8_t)par((uint32_t)reg & G1);
        sym[2 * t + 1] = (uint8_t)(par((uint32_t)reg & G2) ^ 1);
        s = reg >> 1;
    }
}

/* мягкий декодер Витерби: y — 2·nb значений (> 0 — символ 0, инверсия G2 уже снята),
 * начало и конец в состоянии 0 (хвостовые биты) */
static void viterbi(const float *y, int nb, uint8_t *bit)
{
    float pm[64], nm[64];
    uint64_t dec[NBIT];
    for (int s = 0; s < 64; s++) pm[s] = s ? -1e30f : 0.0f;
    for (int t = 0; t < nb; t++) {
        float y1 = y[2 * t], y2 = y[2 * t + 1];
        uint64_t d = 0;
        for (int ns = 0; ns < 64; ns++) {
            int in = ns >> 5;
            float best = 0;
            for (int b = 0; b < 2; b++) {
                int s = ((ns & 31) << 1) | b, reg = (in << 6) | s;
                float m = pm[s] + (par((uint32_t)reg & G1) ? -y1 : y1) + (par((uint32_t)reg & G2) ? -y2 : y2);
                if (b == 0 || m > best) { best = m; if (b) d |= 1ull << ns; }
            }
            nm[ns] = best;
        }
        dec[t] = d;
        memcpy(pm, nm, sizeof pm);
    }
    for (int t = nb - 1, s = 0; t >= 0; t--) {
        bit[t] = (uint8_t)(s >> 5);
        s = ((s & 31) << 1) | (int)((dec[t] >> s) & 1);
    }
}

void inav_init(inav_t *g, int prn)
{
    memset(g, 0, sizeof(*g));
    g->prn = prn;
    for (int k = 0; k < 4; k++) g->iod[k] = -1;
}

/* число несовпадений символов с синхрокомбинацией при полярности pol */
static int sync_err(const float *s, int pol)
{
    int n = 0;
    for (int i = 0; i < INAV_SYNC; i++) n += ((s[i] < 0) ^ pol) != SYNC[i];
    return n;
}

/* полярность по синхрокомбинации без ошибок или −1 */
static int sync_pol(const float *s)
{
    return sync_err(s, 0) == 0 ? 0 : sync_err(s, 1) == 0 ? 1 : -1;
}

static void decode_word(inav_t *g, const uint8_t *w, int type)
{
    eph_t *e = &g->cur;
    int iod = (int)getbitu(w, 6, 10);
    switch (type) {
    case 1:
        e->toe = getbitu(w, 16, 14) * 60.0;
        e->M0 = getbits(w, 30, 32) * P2(-31) * SC2RAD;
        e->e = getbitu(w, 62, 32) * P2(-33);
        e->sqrtA = getbitu(w, 94, 32) * P2(-19);
        break;
    case 2:
        e->OMG0 = getbits(w, 16, 32) * P2(-31) * SC2RAD;
        e->i0 = getbits(w, 48, 32) * P2(-31) * SC2RAD;
        e->omg = getbits(w, 80, 32) * P2(-31) * SC2RAD;
        e->idot = getbits(w, 112, 14) * P2(-43) * SC2RAD;
        break;
    case 3:
        e->OMGd = getbits(w, 16, 24) * P2(-43) * SC2RAD;
        e->dn = getbits(w, 40, 16) * P2(-43) * SC2RAD;
        e->cuc = getbits(w, 56, 16) * P2(-29);
        e->cus = getbits(w, 72, 16) * P2(-29);
        e->crc = getbits(w, 88, 16) * P2(-5);
        e->crs = getbits(w, 104, 16) * P2(-5);
        e->sva = (int)getbitu(w, 120, 8);
        break;
    case 4:
        if ((int)getbitu(w, 16, 6) != g->prn) return;          /* SVID — не тот КА */
        e->cic = getbits(w, 22, 16) * P2(-29);
        e->cis = getbits(w, 38, 16) * P2(-29);
        e->toc = getbitu(w, 54, 14) * 60.0;
        e->af0 = getbits(w, 68, 31) * P2(-34);
        e->af1 = getbits(w, 99, 21) * P2(-46);
        e->af2 = getbits(w, 120, 6) * P2(-59);
        break;
    case 5:
        g->ai[0] = getbitu(w, 6, 11) * P2(-2);
        g->ai[1] = getbits(w, 17, 11) * P2(-8);
        g->ai[2] = getbits(w, 28, 14) * P2(-15);
        g->ai_ok = 1;
        /* BGD(E1, E5b) — для одночастотного E1 по часам I/NAV */
        e->tgd = getbits(w, 57, 10) * P2(-32);
        /* состояние в разрядах RINEX: 0 — E1-B DVS, 1–2 — E1-B HS, 6 — E5b DVS, 7–8 — E5b HS */
        e->svh = (int)(getbitu(w, 72, 1) | getbitu(w, 69, 2) << 1 | getbitu(w, 71, 1) << 6 |
                       getbitu(w, 67, 2) << 7);
        g->week = (int)getbitu(w, 73, 12) + 1024;
        g->w5 = 1;
        break;
    case 6:
        g->utc_a0 = getbits(w, 6, 32) * P2(-30);
        g->utc_a1 = getbits(w, 38, 24) * P2(-50);
        g->dt_ls = getbits(w, 62, 8);
        g->utc_ok = 1;
        return;
    case 0:
        if (getbitu(w, 6, 2) == 2) g->week = (int)getbitu(w, 96, 12) + 1024;
        return;
    default:
        return;
    }
    /* полные эфемериды: слова 1–4 одной редакции IODnav и слово 5 (BGD, состояние, неделя;
     * неделя может прийти раньше в слове 0 — без слова 5 часы для E1 были бы без BGD) */
    if (type <= 4) g->iod[type - 1] = iod;
    iod = g->iod[0];
    if (iod >= 0 && g->iod[1] == iod && g->iod[2] == iod && g->iod[3] == iod && g->w5 && g->week) {
        e->sys = SYS_GAL; e->prn = (uint8_t)g->prn; e->valid = 1; e->week = g->week;
        e->iode = e->iodc = iod;
        g->eph = *e;
        g->eph_new = 1;
        for (int k = 0; k < 4; k++) g->iod[k] = -1;
    }
}

/* TOW слова (GST начала страницы) или −1 */
static int word_tow(const uint8_t *w, int type)
{
    if (type == 5) return (int)getbitu(w, 85, 20);
    if (type == 6) return (int)getbitu(w, 105, 20);
    if (type == 0 && getbitu(w, 6, 2) == 2) return (int)getbitu(w, 108, 20);
    return -1;
}

/* часть страницы: s — 250 символов (синхрокомбинация и 240 кодовых) */
static int decode_part(inav_t *g, const float *s, uint64_t n_end)
{
    float y[2 * NBIT];
    uint8_t bit[NBIT];
    float sg = g->pol ? -1.0f : 1.0f;
    for (int r = 0; r < 8; r++)
        for (int c = 0; c < 30; c++) y[c * 8 + r] = sg * s[INAV_SYNC + r * 30 + c];
    for (int i = 1; i < 2 * NBIT; i += 2) y[i] = -y[i];      /* инверсия G2 */
    viterbi(y, NBIT, bit);
    if (bit[0] == 0) {                                       /* чётная часть */
        memset(g->even, 0, sizeof g->even);
        for (int i = 0; i < 114; i++) setbitu(g->even, i, 1, bit[i]);
        g->even_part = g->part;
        g->even_ok = 1;
        return 0;
    }
    if (!g->even_ok || g->even_part + 1 != g->part) return 0;
    g->even_ok = 0;
    uint8_t pg[30] = {0};                                    /* страница: 114 + 120 бит */
    memcpy(pg, g->even, sizeof g->even);
    for (int i = 0; i < NBIT; i++) setbitu(pg, 114 + i, 1, bit[i]);
    if (inav_crc24q(pg, 196) != getbitu(pg, 196, 24)) { g->n_crc_err++; return 0; }
    if (getbitu(pg, 1, 1) || getbitu(pg, 115, 1)) return 0;  /* страница тревоги */
    for (int i = 0; i < 112; i++) setbitu(g->word, i, 1, getbitu(pg, 2 + i, 1));
    for (int i = 0; i < 16; i++) setbitu(g->word, 112 + i, 1, getbitu(pg, 116 + i, 1));
    g->wtype = (int)getbitu(g->word, 0, 6);
    g->n_page++;
    int tow = word_tow(g->word, g->wtype);
    if (tow >= 0 && tow < 604800) {
        g->tow_ref = tow;
        g->tow_part = g->even_part;
        g->tow_ok = 1;
    }
    if (g->tow_ok) g->page_tow = fmod(g->tow_ref + (double)(g->even_part - g->tow_part), 604800.0);
    g->page_end_n = n_end;
    decode_word(g, g->word, g->wtype);
    return 1;
}

int inav_sym(inav_t *g, double v, uint64_t n_end)
{
    memmove(g->sym, g->sym + 1, (NBUF - 1) * sizeof(g->sym[0]));
    g->sym[NBUF - 1] = (float)v;
    if (g->nsym < NBUF) g->nsym++;
    if (!g->sync) {
        /* поиск: синхрокомбинации в начале двух соседних частей с одной полярностью */
        if (g->nsym < NBUF) return 0;
        int p0 = sync_pol(g->sym), p1 = sync_pol(g->sym + INAV_PART);
        if (p0 < 0 || p0 != p1) return 0;
        g->sync = 1;
        g->pol = p0;
        g->part = 0;
        g->cnt = INAV_SYNC;
        g->miss = 0;
        g->even_ok = g->tow_ok = 0;
        decode_part(g, g->sym, n_end);                       /* страницу не завершает: нет чётной */
        return 0;
    }
    if (++g->cnt < INAV_PART) return 0;
    g->cnt = 0;
    g->part++;
    /* синхрокомбинация на ожидаемом месте: полярность — по знаку корреляции (скачок фазы
     * на полпериода в петле Костаса), три пропуска подряд — потеря синхронизации */
    const float *s = g->sym + INAV_SYNC;
    float c = 0;
    for (int i = 0; i < INAV_SYNC; i++) c += SYNC[i] ? -s[i] : s[i];
    g->pol = c < 0;
    if (sync_err(s, g->pol) > 3) {
        if (++g->miss >= 3) {
            g->sync = 0;
            g->even_ok = g->tow_ok = 0;
            return 0;
        }
    } else g->miss = 0;
    return decode_part(g, s, n_end);
}

/* слово 128 бит по эфемеридам */
static void encode_word(const eph_t *e, int type, int tow, int week, uint8_t *w)
{
    memset(w, 0, 16);
    setbitu(w, 0, 6, (uint32_t)type);
    int iod = e->iode & 0x3FF;
    switch (type) {
    case 1:
        setbitu(w, 6, 10, (uint32_t)iod);
        setbitu(w, 16, 14, (uint32_t)lround(e->toe / 60.0));
        setbits(w, 30, 32, (int32_t)llround(e->M0 / SC2RAD / P2(-31)));
        setbitu(w, 62, 32, (uint32_t)llround(e->e / P2(-33)));
        setbitu(w, 94, 32, (uint32_t)llround(e->sqrtA / P2(-19)));
        break;
    case 2:
        setbitu(w, 6, 10, (uint32_t)iod);
        setbits(w, 16, 32, (int32_t)llround(e->OMG0 / SC2RAD / P2(-31)));
        setbits(w, 48, 32, (int32_t)llround(e->i0 / SC2RAD / P2(-31)));
        setbits(w, 80, 32, (int32_t)llround(e->omg / SC2RAD / P2(-31)));
        setbits(w, 112, 14, (int32_t)lround(e->idot / SC2RAD / P2(-43)));
        break;
    case 3:
        setbitu(w, 6, 10, (uint32_t)iod);
        setbits(w, 16, 24, (int32_t)lround(e->OMGd / SC2RAD / P2(-43)));
        setbits(w, 40, 16, (int32_t)lround(e->dn / SC2RAD / P2(-43)));
        setbits(w, 56, 16, (int32_t)lround(e->cuc / P2(-29)));
        setbits(w, 72, 16, (int32_t)lround(e->cus / P2(-29)));
        setbits(w, 88, 16, (int32_t)lround(e->crc / P2(-5)));
        setbits(w, 104, 16, (int32_t)lround(e->crs / P2(-5)));
        setbitu(w, 120, 8, (uint32_t)e->sva);
        break;
    case 4:
        setbitu(w, 6, 10, (uint32_t)iod);
        setbitu(w, 16, 6, e->prn);
        setbits(w, 22, 16, (int32_t)lround(e->cic / P2(-29)));
        setbits(w, 38, 16, (int32_t)lround(e->cis / P2(-29)));
        setbitu(w, 54, 14, (uint32_t)lround(e->toc / 60.0));
        setbits(w, 68, 31, (int32_t)llround(e->af0 / P2(-34)));
        setbits(w, 99, 21, (int32_t)lround(e->af1 / P2(-46)));
        setbits(w, 120, 6, (int32_t)lround(e->af2 / P2(-59)));
        break;
    case 5:
        setbitu(w, 6, 11, (uint32_t)lround(AI_SIM[0] / P2(-2)));
        setbits(w, 17, 11, (int32_t)lround(AI_SIM[1] / P2(-8)));
        setbits(w, 28, 14, (int32_t)lround(AI_SIM[2] / P2(-15)));
        setbits(w, 47, 10, (int32_t)lround(e->tgd / P2(-32)));
        setbits(w, 57, 10, (int32_t)lround(e->tgd / P2(-32)));
        setbitu(w, 67, 2, (uint32_t)(e->svh >> 7) & 3);
        setbitu(w, 69, 2, (uint32_t)(e->svh >> 1) & 3);
        setbitu(w, 71, 1, (uint32_t)(e->svh >> 6) & 1);
        setbitu(w, 72, 1, (uint32_t)e->svh & 1);
        setbitu(w, 73, 12, (uint32_t)(week - 1024) & 0xFFF);
        setbitu(w, 85, 20, (uint32_t)tow);
        break;
    case 6:
        setbits(w, 62, 8, (int32_t)GPST_UTC);
        setbitu(w, 70, 8, (uint32_t)((tow / 3600) & 0xFF));
        setbitu(w, 78, 8, (uint32_t)(week - 1024) & 0xFF);
        setbitu(w, 86, 8, (uint32_t)(week - 1024) & 0xFF);
        setbitu(w, 94, 3, 7);
        setbits(w, 97, 8, (int32_t)GPST_UTC);
        setbitu(w, 105, 20, (uint32_t)tow);
        break;
    case 0:
        setbitu(w, 6, 2, 2);
        setbitu(w, 96, 12, (uint32_t)(week - 1024) & 0xFFF);
        setbitu(w, 108, 20, (uint32_t)tow);
        break;
    default: {
        /* прочие слова (альманах, резерв): в имитаторе — псевдослучайные данные */
        uint32_t r = (uint32_t)tow * 2654435761u + (uint32_t)type * 40503u + e->prn;
        for (int k = 6; k < 128; k += 16) {
            r ^= r << 13; r ^= r >> 17; r ^= r << 5;
            setbitu(w, k, 128 - k < 16 ? 128 - k : 16, r & 0xFFFF);
        }
    }
    }
}

void inav_encode_page(const eph_t *e, int wtype, int tow, int week, uint8_t sym[500])
{
    uint8_t w[16], pg[30] = {0};
    encode_word(e, wtype, tow, week, w);
    /* чётная часть: E/O = 0, тип 0, данные 112; нечётная: E/O = 1, тип 0, данные 16, OSNMA 40,
     * SAR 22, резерв 2, CRC 24, SSP 8, хвост 6 (OSNMA, SAR, SSP — нули) */
    for (int i = 0; i < 112; i++) setbitu(pg, 2 + i, 1, getbitu(w, i, 1));
    setbitu(pg, 114, 1, 1);
    for (int i = 0; i < 16; i++) setbitu(pg, 116 + i, 1, getbitu(w, 112 + i, 1));
    setbitu(pg, 196, 24, inav_crc24q(pg, 196));
    for (int p = 0; p < 2; p++) {
        uint8_t bit[NBIT] = {0}, enc[2 * NBIT];
        int nb = p ? NBIT : 114;
        for (int i = 0; i < nb; i++) bit[i] = (uint8_t)getbitu(pg, 114 * p + i, 1);
        conv_enc(bit, NBIT, enc);
        uint8_t *o = sym + 250 * p;
        memcpy(o, SYNC, INAV_SYNC);
        for (int r = 0; r < 8; r++)
            for (int c = 0; c < 30; c++) o[INAV_SYNC + r * 30 + c] = enc[c * 8 + r];
    }
}
