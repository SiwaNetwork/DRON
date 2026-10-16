/* МГП-8: собственный двоичный протокол (описание — inc/proto.h). */
#include <string.h>
#include "gnss.h"
#include "proto.h"

uint16_t mbp_crc16(const uint8_t *b, int n)
{
    uint16_t c = 0xFFFF;
    for (int i = 0; i < n; i++) {
        c ^= (uint16_t)(b[i] << 8);
        for (int k = 0; k < 8; k++) c = (uint16_t)((c & 0x8000) ? (c << 1) ^ 0x1021 : c << 1);
    }
    return c;
}

/* запись полей (little-endian) */
typedef struct { uint8_t *p; int n; } wr_t;
static void w8(wr_t *w, uint32_t v) { w->p[w->n++] = (uint8_t)v; }
static void w16(wr_t *w, uint32_t v) { w8(w, v); w8(w, v >> 8); }
static void w32(wr_t *w, uint32_t v) { w16(w, v); w16(w, v >> 16); }
static void wf(wr_t *w, float v) { uint32_t u; memcpy(&u, &v, 4); w32(w, u); }
static void wd(wr_t *w, double v) { uint64_t u; memcpy(&u, &v, 8); w32(w, (uint32_t)u); w32(w, (uint32_t)(u >> 32)); }
static uint16_t u16c(double v) { return v <= 0 ? 0 : v >= 655.35 ? 65535 : (uint16_t)(v * 100 + 0.5); }

int mbp_frame(uint8_t *buf, int cls, int id, int plen)
{
    buf[0] = MBP_SYNC1; buf[1] = MBP_SYNC2;
    buf[2] = (uint8_t)cls; buf[3] = (uint8_t)id;
    buf[4] = (uint8_t)plen; buf[5] = (uint8_t)(plen >> 8);
    uint16_t c = mbp_crc16(buf + 2, plen + 4);
    buf[6 + plen] = (uint8_t)c; buf[7 + plen] = (uint8_t)(c >> 8);
    return plen + 8;
}

int mbp_pvt(uint8_t *buf, int week, const sol_t *s)
{
    wr_t w = {buf + 6, 0};
    w16(&w, (uint32_t)week); wd(&w, s->t_rx);
    w8(&w, (uint32_t)s->ok); w8(&w, (uint32_t)s->nsat); w8(&w, (uint32_t)s->nsys); w8(&w, 0);
    for (int i = 0; i < 3; i++) wd(&w, s->pos[i]);
    for (int i = 0; i < 3; i++) wf(&w, (float)s->vel[i]);
    for (int i = 0; i < 4; i++) wd(&w, s->clk[i]);                   /* GPS, ГЛОНАСС, Galileo, BeiDou */
    wf(&w, (float)s->clkd);
    w16(&w, u16c(s->pdop)); w16(&w, u16c(s->hdop)); w16(&w, u16c(s->vdop)); w16(&w, u16c(s->tdop));
    return mbp_frame(buf, MBP_NAV, MBP_NAV_PVT, w.n);
}

int mbp_meas(uint8_t *buf, int week, double tow, const mbp_meas_t *m, int n)
{
    wr_t w = {buf + 6, 0};
    if (n > 60) n = 60;
    w16(&w, (uint32_t)week); wd(&w, tow); w8(&w, (uint32_t)n);
    for (int i = 0; i < n; i++) {
        w8(&w, m[i].sys); w8(&w, m[i].prn); w8(&w, m[i].sig); w8(&w, (uint8_t)m[i].fcn);
        wd(&w, m[i].pr); wd(&w, m[i].cp); wf(&w, m[i].dop);
        w16(&w, u16c(m[i].cn0)); w32(&w, (uint32_t)(m[i].lock * 1000 + 0.5)); w8(&w, m[i].flags);
    }
    return mbp_frame(buf, MBP_RAW, MBP_RAW_MEAS, w.n);
}

int mbp_eph(uint8_t *buf, const eph_t *e)
{
    wr_t w = {buf + 6, 0};
    w8(&w, e->sys); w8(&w, e->prn); w8(&w, (uint8_t)e->fcn); w8(&w, (uint32_t)e->svh);
    w16(&w, (uint32_t)e->week); w16(&w, (uint32_t)e->iode);
    const double v[32] = {e->toc, e->toe, e->af0, e->af1, e->af2, e->tgd, e->sqrtA, e->e, e->i0, e->OMG0,
                          e->omg, e->M0, e->dn, e->OMGd, e->idot, e->cuc, e->cus, e->crc, e->crs, e->cic, e->cis,
                          e->pos[0], e->pos[1], e->pos[2], e->vel[0], e->vel[1], e->vel[2],
                          e->acc[0], e->acc[1], e->acc[2], e->taun, e->gamn};
    for (int i = 0; i < 32; i++) wd(&w, v[i]);
    return mbp_frame(buf, MBP_RAW, MBP_RAW_EPH, w.n);
}

int mbp_ch(uint8_t *buf, const mbp_ch_t *c, int n)
{
    wr_t w = {buf + 6, 0};
    if (n > 96) n = 96;
    w8(&w, (uint32_t)n);
    for (int i = 0; i < n; i++) {
        w8(&w, c[i].ch); w8(&w, c[i].sig); w8(&w, c[i].prn); w8(&w, (uint8_t)c[i].fcn);
        w8(&w, c[i].state); w8(&w, c[i].flags); w16(&w, u16c(c[i].cn0)); wf(&w, c[i].dop);
    }
    return mbp_frame(buf, MBP_CH, MBP_CH_STAT, w.n);
}

int mbp_tm(uint8_t *buf, const mbp_tm_t *t)
{
    wr_t w = {buf + 6, 0};
    wf(&w, t->t_mcu); wf(&w, t->ant_ma); w8(&w, t->ant_state); w8(&w, t->max_ld);
    w8(&w, t->notch_en); w8(&w, t->notch_dith); w16(&w, t->vin_mv); w32(&w, t->uptime_s);
    w8(&w, t->fpga_ok); w8(&w, t->pll_lock);
    return mbp_frame(buf, MBP_TM, MBP_TM_STAT, w.n);
}

int mbp_parse(const uint8_t *b, int n, int *cls, int *id, const uint8_t **pl, int *plen, int *used)
{
    int i = 0;
    while (i + 1 < n && !(b[i] == MBP_SYNC1 && b[i + 1] == MBP_SYNC2)) i++;
    if (i > 0) { *used = i; return -1; }            /* мусор до синхрослова */
    if (n < 8) return 0;
    int len = b[4] | (b[5] << 8);
    if (len > MBP_MAXLEN) { *used = 1; return -1; }
    if (n < len + 8) return 0;
    uint16_t c = (uint16_t)(b[6 + len] | (b[7 + len] << 8));
    if (c != mbp_crc16(b + 2, len + 4)) { *used = 1; return -1; }
    *cls = b[2]; *id = b[3]; *pl = b + 6; *plen = len; *used = len + 8;
    return 1;
}
