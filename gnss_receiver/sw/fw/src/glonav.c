/* МГП-8: навигационное сообщение ГЛОНАСС L1OF/L2OF (ИКД ГЛОНАСС ред. 5.1).
 * Демодуляция — как в Pocket SDR (sdr_nav.py, decode_G1CA): окно 230 символов с меткой времени
 * на обоих концах (прямой или инверсной), данные — разность соседних кодовых бит (относительный
 * код), бит 85 строки — 0. Маски кода Хэмминга — RTKLIB (rcvraw.c, test_glostr), лицензия BSD-2. */
#include <math.h>
#include <string.h>
#include "gnss.h"
#include "glonav.h"

#define P2(n) ldexp(1.0, n)

/* метка времени (укороченная ПСП, 30 символов по 10 мс) */
static const uint8_t TM[GLO_TM_LEN] = {1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 0,
                                       0, 1, 0, 0, 1, 0, 1, 1, 0};

/* маски проверок β1..β8 по упакованной строке (бит 85 — старший бит байта 0) */
static const uint8_t HMASK[8][11] = {
    {0x55, 0x55, 0x5A, 0xAA, 0xAA, 0xAA, 0xB5, 0x55, 0x6A, 0xD8, 0x08},
    {0x66, 0x66, 0x6C, 0xCC, 0xCC, 0xCC, 0xD9, 0x99, 0xB3, 0x68, 0x10},
    {0x87, 0x87, 0x8F, 0x0F, 0x0F, 0x0F, 0x1E, 0x1E, 0x3C, 0x70, 0x20},
    {0x07, 0xF8, 0x0F, 0xF0, 0x0F, 0xF0, 0x1F, 0xE0, 0x3F, 0x80, 0x40},
    {0xF8, 0x00, 0x0F, 0xFF, 0xF0, 0x00, 0x1F, 0xFF, 0xC0, 0x00, 0x80},
    {0x00, 0x00, 0x0F, 0xFF, 0xFF, 0xFF, 0xE0, 0x00, 0x00, 0x01, 0x00},
    {0xFF, 0xFF, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00},
    {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xF8}};

static int hrow(const uint8_t *s, int r)
{
    int p = 0;
    for (int i = 0; i < GLO_STR_BITS; i++)
        if (s[i] && (HMASK[r][i >> 3] >> (7 - (i & 7)) & 1)) p ^= 1;
    return p;
}

int glo_str_check(const uint8_t *s)
{
    for (int r = 0; r < 8; r++) if (hrow(s, r)) return 0;
    return 1;
}

/* поля по номерам бит ИКД (85..1): s[85 − k] — бит k */
static uint32_t gb(const uint8_t *s, int hi, int len)
{
    uint32_t v = 0;
    for (int i = 0; i < len; i++) v = (v << 1) | s[85 - hi + i];
    return v;
}
static double gsm(const uint8_t *s, int hi, int len)          /* знак и модуль */
{
    double v = gb(s, hi - 1, len - 1);
    return s[85 - hi] ? -v : v;
}
static void sb(uint8_t *s, int hi, int len, uint32_t v)
{
    for (int i = 0; i < len; i++) s[85 - hi + i] = (uint8_t)((v >> (len - 1 - i)) & 1);
}
static void ssm(uint8_t *s, int hi, int len, double v, double scale)
{
    double a = floor(fabs(v) / scale + 0.5), lim = ldexp(1.0, len - 1) - 1;
    if (a > lim) a = lim;
    s[85 - hi] = v < 0 && a > 0;
    sb(s, hi - 1, len - 1, (uint32_t)a);
}

void glo_str_encode(const eph_t *e, int m, double tk, int slot, uint8_t *s)
{
    memset(s, 0, GLO_STR_BITS);
    sb(s, 84, 4, (uint32_t)m);
    /* tb — время эфемерид в сутках МДВ, кратно 15 мин */
    double tod = fmod(e->toc - GPST_UTC + 10800.0 + 7 * 86400.0, 86400.0);
    int tb = (int)floor(tod / 900.0 + 0.5) % 96;
    switch (m) {
    case 1: {
        int t = (int)floor(tk + 0.5), h = t / 3600, mi = (t / 60) % 60, s30 = (t % 60) >= 30;
        sb(s, 76, 5, (uint32_t)h); sb(s, 71, 6, (uint32_t)mi); sb(s, 65, 1, (uint32_t)s30);
        ssm(s, 64, 24, e->vel[0] * 1e-3, P2(-20)); ssm(s, 40, 5, e->acc[0] * 1e-3, P2(-30));
        ssm(s, 35, 27, e->pos[0] * 1e-3, P2(-11));
        break; }
    case 2:
        sb(s, 76, 7, (uint32_t)tb);
        ssm(s, 64, 24, e->vel[1] * 1e-3, P2(-20)); ssm(s, 40, 5, e->acc[1] * 1e-3, P2(-30));
        ssm(s, 35, 27, e->pos[1] * 1e-3, P2(-11));
        break;
    case 3:
        ssm(s, 79, 11, e->gamn, P2(-40));
        ssm(s, 64, 24, e->vel[2] * 1e-3, P2(-20)); ssm(s, 40, 5, e->acc[2] * 1e-3, P2(-30));
        ssm(s, 35, 27, e->pos[2] * 1e-3, P2(-11));
        break;
    case 4:
        ssm(s, 80, 22, -e->taun, P2(-30));         /* в eph_t хранится −τn */
        sb(s, 15, 5, (uint32_t)slot); sb(s, 10, 2, 1);
        break;
    default:
        break;
    }
    /* код Хэмминга: β1..β7 (позиции бит 1..7), затем общая чётность β8 (бит 8) */
    for (int r = 0; r < 7; r++) s[84 - r] = (uint8_t)hrow(s, r);
    s[77] = (uint8_t)hrow(s, 7);
}

void glo_str_symbols(const uint8_t *s, int8_t *sym)
{
    /* относительный код: c0 = 0, c(j+1) = c(j) ⊕ d(84 − j); символы бита — (c, c ⊕ 1) */
    int c = 0;
    for (int j = 0; j < 85; j++) {
        if (j > 0) c ^= s[j];
        sym[2 * j] = (int8_t)(c ? -1 : 1);
        sym[2 * j + 1] = (int8_t)(c ? 1 : -1);
    }
    for (int i = 0; i < GLO_TM_LEN; i++) sym[170 + i] = (int8_t)(TM[i] ? -1 : 1);
}

void glonav_init(glonav_t *g, int fcn)
{
    memset(g, 0, sizeof(*g));
    g->fcn = fcn;
    g->tk = -1;
    g->str_end_tod = -1;
}

double glo_tod2gpst(double tod, double t_ref)
{
    double tg = fmod(tod - 10800.0 + GPST_UTC + 2 * 86400.0, 86400.0);   /* сутки GPST */
    double day = floor(t_ref / 86400.0) * 86400.0, t = day + tg;
    if (t - t_ref > 43200) t -= 86400;
    if (t - t_ref < -43200) t += 86400;
    return fmod(t + 604800.0, 604800.0);
}

/* проверка окна 230 символов: метка времени в начале и в конце; 0 — прямая, 1 — инверсная */
static int frame_sync(const float *w)
{
    int nn = 1, nr = 1;
    for (int i = 0; i < GLO_TM_LEN && (nn || nr); i++) {
        int a = w[i] < 0, b = w[200 + i] < 0;
        if (a != TM[i] || b != TM[i]) nn = 0;
        if (a == TM[i] || b == TM[i]) nr = 0;
    }
    return nn ? 0 : nr ? 1 : -1;
}

static void decode_eph(glonav_t *g)
{
    const uint8_t *s1 = g->str[1], *s2 = g->str[2], *s3 = g->str[3], *s4 = g->str[4];
    eph_t *e = &g->eph;
    memset(e, 0, sizeof(*e));
    e->sys = SYS_GLO;
    e->fcn = (int8_t)g->fcn;
    e->vel[0] = gsm(s1, 64, 24) * P2(-20) * 1e3; e->acc[0] = gsm(s1, 40, 5) * P2(-30) * 1e3;
    e->pos[0] = gsm(s1, 35, 27) * P2(-11) * 1e3;
    e->svh = (int)gb(s2, 80, 1);
    int tb = (int)gb(s2, 76, 7);
    e->vel[1] = gsm(s2, 64, 24) * P2(-20) * 1e3; e->acc[1] = gsm(s2, 40, 5) * P2(-30) * 1e3;
    e->pos[1] = gsm(s2, 35, 27) * P2(-11) * 1e3;
    e->gamn = gsm(s3, 79, 11) * P2(-40);
    e->vel[2] = gsm(s3, 64, 24) * P2(-20) * 1e3; e->acc[2] = gsm(s3, 40, 5) * P2(-30) * 1e3;
    e->pos[2] = gsm(s3, 35, 27) * P2(-11) * 1e3;
    e->taun = -gsm(s4, 80, 22) * P2(-30);
    g->slot = (int)gb(s4, 15, 5);
    e->prn = (uint8_t)g->slot;
    e->iode = tb;
    e->toc = e->toe = tb * 900.0;                  /* сутки МДВ; в GPST переводит rx (glo_tod2gpst) */
    e->valid = g->slot >= 1 && g->slot <= 24;
    g->eph_new = e->valid;
}

int glonav_sym(glonav_t *g, double v, uint64_t n_end)
{
    memmove(g->sym, g->sym + 1, sizeof(float) * 229);
    g->sym[229] = (float)v;
    g->nsym++;
    if (g->nsym < 230) return 0;
    /* после синхронизации окно проверяется раз в 200 символов (2 с) */
    if (g->sync && (g->nsym - g->sync) % 200 != 0) return 0;
    int rev = frame_sync(g->sym);
    if (rev < 0) { if (g->sync) { g->sync = 0; g->n_err++; } return 0; }
    uint8_t s[GLO_STR_BITS], c[85];
    const float *d = g->sym + 30;
    for (int j = 0; j < 85; j++) c[j] = (uint8_t)(d[2 * j] - d[2 * j + 1] < 0);
    s[0] = 0;
    for (int k = 0; k < 84; k++) s[1 + k] = c[k] ^ c[k + 1];
    if (!glo_str_check(s)) { g->sync = 0; g->n_err++; return 0; }
    g->sync = g->nsym;                             /* символов на конце этой строки */
    g->rev = rev;
    int m = (int)gb(s, 84, 4);
    if (m < 1 || m > 15) return 0;
    memcpy(g->str[m], s, GLO_STR_BITS);
    g->n_str++;
    /* время: строка 1 — tk (начало кадра); иначе — смена кадра по убыванию номера строки */
    if (m == 1) {
        g->tk = gb(s, 76, 5) * 3600.0 + gb(s, 71, 6) * 60.0 + gb(s, 65, 1) * 30.0;
        g->have = 0;
    } else if (g->tk >= 0 && m <= g->str_m) {
        g->tk = fmod(g->tk + 30.0, 86400.0);
        g->have = 0;
    }
    g->have |= 1 << m;
    g->str_m = m;
    g->str_end_n = n_end;
    g->str_end_tod = g->tk >= 0 ? fmod(g->tk + 2.0 * m, 86400.0) : -1;
    if (m == 4 && (g->have & 0x1E) == 0x1E) decode_eph(g);
    if (m == 5) { g->na = (int)gb(s, 80, 11); g->n4 = (int)gb(s, 36, 5); }
    return m;
}
