/* МГП-8: функциональная модель ПЛИС для проверки ПО на ПК (только для сборки на ПК).
 * Регистры — как в fpga/rtl (mgp8_core.v, corr_engine.v); арифметика коррелятора — битово-точная
 * (спецификация fpga/model/corr_model.py): группы по 4 отсчёта, отложенное применение шагов NCO,
 * память кода с дополнением mem[a] = code[(a − 1) mod L], смещение E/L с разрешением 2^-16 чипа. */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "fpga.h"
#include "corr_sim.h"
#include "acqf_sim.h"

uint32_t (*fpga_rd_fn)(uint32_t a);
void (*fpga_wr_fn)(uint32_t a, uint32_t v);

static int COS64[64];                    /* round(7·cos(2π(k+0.5)/64)) */

typedef struct {
    uint32_t ctrl, len, crn, krn, sp;
    uint32_t cp, cr, kr, cf, ci, ep;
    int64_t  acc[6];
    int32_t  res[6];
    uint32_t dump_t;
    int en, en_next, pend, ready, ovr, apply;
} sslot_t;

typedef struct {
    sslot_t s[CORR_NSLOT];
    uint8_t mem[CORR_NSLOT][16384];     /* по одному чипу в байте (1 = −1) */
    uint32_t w_slot, w_word, st_t, st_mask;
    int st_v;
} seng_t;

static seng_t *E;
static int NE;
static uint64_t t96, nsmp;
static uint32_t regs[256];
static uint32_t irq_st;
/* снимок (память — общий пул ускорителя захвата) и ускоритель захвата */
static acqf_t ACQ;
static int snap_busy, snap_rec, snap_nib;
static uint32_t snap_left, snap_wa, snap_sr, snap_t0;
/* журнал сбросов (для тестов) */
static void (*dump_cb)(int ch, const corr_sim_dump_t *d);
/* MAX2771 ×8 за ведущим SPI ПЛИС (max_spi.v): регистры 0x0–0xA, LD — после записи синтезатора
 * (регистр 0x4) включённой микросхемы; значения по умолчанию — условные (CONF1 — по документации) */
static const uint32_t MX_DEF[11] = {0xBEA41603u, 0x20550288u, 0x0EAFE1DCu, 0x698C0008u, 0x0C000080u,
                                    0x00000070u, 0x08000000u, 0x10061B20u, 0x01E0F401u, 0x014C0402u,
                                    0x10061B20u};
#define MX_DIEID 0x1u                    /* CONF2[1:0] — только чтение */
static uint32_t mx[8][11];
static uint8_t  mx_ld, mx_dead;
static int      mx_busy, mx_frames, mx_bad;
/* шкала времени (timebase.v): TIC — каждые TIC_PERIOD отсчётов, 1PPS — в такт PPS_T */
static uint32_t tic_cnt, tic_prev;
static uint64_t tic_t, pps_t, pps_last;
static int      pps_armed, pps_n;

static uint32_t sim_rd(uint32_t a);
static void sim_wr(uint32_t a, uint32_t v);

void corr_sim_init(int n_eng)
{
    free(E);
    NE = n_eng;
    E = calloc((size_t)n_eng, sizeof(seng_t));
    for (int k = 0; k < 64; k++) COS64[k] = (int)lround(7.0 * cos(2.0 * 3.14159265358979 * (k + 0.5) / 64.0));
    for (int e = 0; e < n_eng; e++)
        for (int s = 0; s < CORR_NSLOT; s++) E[e].s[s].en_next = -1;
    t96 = 0; nsmp = 0; irq_st = 0;
    memset(regs, 0, sizeof(regs));
    regs[R_CTRL] = 0xFF00;
    snap_busy = 0;
    acqf_reset(&ACQ);
    for (int c = 0; c < 8; c++)
        for (int k = 0; k < 11; k++) mx[c][k] = MX_DEF[k];
    for (int c = 0; c < 8; c++) mx[c][1] = (mx[c][1] & ~3u) | MX_DIEID;
    mx_ld = 0; mx_dead = 0; mx_busy = 0; mx_frames = 0; mx_bad = 0;
    tic_cnt = 0; tic_prev = 0; tic_t = 0; pps_t = 0; pps_last = 0; pps_armed = 0; pps_n = 0;
    regs[R_PPS_CTRL] = 9600000u;
    fpga_rd_fn = sim_rd;
    fpga_wr_fn = sim_wr;
}

void corr_sim_set_dump_cb(void (*cb)(int ch, const corr_sim_dump_t *d)) { dump_cb = cb; }
uint32_t corr_sim_max_reg(int ch, int addr) { return mx[ch & 7][addr % 11]; }
void corr_sim_max_fault(uint8_t dead) { mx_dead = dead; }
int corr_sim_max_frames(void) { return mx_frames; }
int corr_sim_max_bad(void) { return mx_bad; }
int corr_sim_pps(uint64_t *t96_last) { if (t96_last) *t96_last = pps_last; return pps_n; }

/* кадр SPI: ответ — только включённая (SHDN = 1) исправная микросхема при SPI у МК */
static void mx_frame(uint32_t cmd)
{
    int ch = (int)(cmd & 7), rd = (int)(cmd >> 3 & 1), a = (int)(cmd >> 4 & 0xFFF);
    int on = (regs[R_CTRL] >> (8 + ch) & 1) && !(regs[R_CTRL] & 8u) && !(mx_dead >> ch & 1);
    if (mx_busy) mx_bad++;               /* пуск при занятом ведущем ПЛИС не выполняется */
    mx_frames++;
    mx_busy = 3;
    if (rd) { regs[R_SPI_RDATA] = on && a < 11 ? mx[ch][a] : 0u; return; }
    if (!on || a >= 11) return;
    uint32_t v = regs[R_SPI_WDATA];
    if (a == 0 && (v >> 22 & 0xFFu) != 0xFAu) mx_bad++;    /* CONF1[29:22] = 11111010 */
    if (a == 1) v = (v & ~3u) | MX_DIEID;
    mx[ch][a] = v;
    if (a == 4) mx_ld |= (uint8_t)(1u << ch);
}
uint64_t corr_sim_nsmp(void) { return nsmp; }

static int chip(const seng_t *e, int s, const sslot_t *c, uint32_t ci, uint32_t cf)
{
    int b = e->mem[s][(ci + 1) & 16383];
    int v = b ? -1 : 1;
    int msb = (int)(cf >> 31);
    if ((c->ctrl & CTRL_BOC) && msb) v = -v;
    if ((c->ctrl & CTRL_TDM) && msb) v = 0;
    return v;
}

static void step(seng_t *e, int s, sslot_t *c, uint64_t n, int xi, int xq, int ch)
{
    int k = (int)(c->cp >> 26);
    int co = COS64[k], si = COS64[(k - 16) & 63];
    int bi = xi * co + xq * si, bq = xq * co - xi * si;
    uint32_t L = c->len;
    uint64_t ef = (uint64_t)c->cf + c->sp;
    uint32_t ei = c->ci + (uint32_t)(ef >> 32);
    if (ei >= L) ei -= L;
    int64_t lf = (int64_t)c->cf - (int64_t)c->sp;
    uint32_t li = c->ci;
    if (lf < 0) li = (li == 0) ? L - 1 : li - 1;
    int ce = chip(e, s, c, ei, (uint32_t)ef), cp = chip(e, s, c, c->ci, c->cf), cl = chip(e, s, c, li, (uint32_t)lf);
    c->acc[0] += ce * bi; c->acc[1] += ce * bq;
    c->acc[2] += cp * bi; c->acc[3] += cp * bq;
    c->acc[4] += cl * bi; c->acc[5] += cl * bq;
    c->cp += c->cr;
    uint64_t nf = (uint64_t)c->cf + c->kr;
    c->ci += (uint32_t)(nf >> 32);
    c->cf = (uint32_t)nf;
    if (c->ci >= L) {
        c->ci -= L;
        c->ep++;
        uint32_t nint = (c->ctrl >> 8) & 0xFF;
        if (c->ep >= nint) {
            c->ep = 0;
            for (int j = 0; j < 6; j++) { c->res[j] = (int32_t)(uint32_t)c->acc[j]; c->acc[j] = 0; }
            c->dump_t = (uint32_t)n;
            if (c->ready) c->ovr = 1;
            c->ready = 1;
            c->apply = 1;
            if (dump_cb) {
                corr_sim_dump_t d;
                d.n = n;
                memcpy(d.v, c->res, sizeof(d.v));
                dump_cb(ch, &d);
            }
        }
    }
}

void corr_sim_run(uint64_t n, uint32_t (*src)(uint64_t i))
{
    for (uint64_t i = 0; i < n; i++, nsmp++) {
        uint32_t w = src(nsmp);
        if ((nsmp & 3) == 0) {
            for (int e = 0; e < NE; e++) {
                seng_t *g = &E[e];
                for (int s = 0; s < CORR_NSLOT; s++) {
                    sslot_t *c = &g->s[s];
                    if (c->en_next >= 0) { c->en = c->en_next; c->en_next = -1; if (!c->en) { c->ep = 0; memset(c->acc, 0, sizeof(c->acc)); } }
                }
                if (g->st_v && (uint32_t)nsmp == g->st_t) {
                    for (int s = 0; s < CORR_NSLOT; s++) if (g->st_mask >> s & 1) g->s[s].en = 1;
                    g->st_v = 0;
                }
            }
        }
        for (int e = 0; e < NE; e++) {
            seng_t *g = &E[e];
            for (int s = 0; s < CORR_NSLOT; s++) {
                sslot_t *c = &g->s[s];
                if (!c->en) continue;
                int rf = (c->ctrl >> 3) & 7;
                uint32_t x = (w >> (4 * rf)) & 0xF;
                int xi = ((x >> 2) & 1 ? 3 : 1) * ((x >> 3) & 1 ? -1 : 1);
                int xq = ((x & 1) ? 3 : 1) * ((x >> 1) & 1 ? -1 : 1);
                step(g, s, c, nsmp, xi, xq, e * CORR_NSLOT + s);
                if ((nsmp & 3) == 3 && c->apply) {
                    c->apply = 0;
                    if (c->pend) { c->cr = c->crn; c->kr = c->krn; c->pend = 0; }
                }
            }
        }
        /* снимок */
        if (snap_busy) {
            uint32_t ch = regs[R_SNAP_CTRL] & 7;
            int at = (regs[R_SNAP_CTRL] >> 3) & 1;
            if (!snap_rec && (!at || (uint32_t)nsmp == regs[R_SNAP_T])) { snap_rec = 1; snap_t0 = (uint32_t)nsmp; }
            if (snap_rec) {
                snap_sr |= ((w >> (4 * ch)) & 0xF) << (4 * snap_nib);
                if (++snap_nib == 8) { acqf_snap_wr(&ACQ, snap_wa++ & 8191, snap_sr); snap_sr = 0; snap_nib = 0; }
                if (--snap_left == 0) { snap_busy = 0; snap_rec = 0; irq_st |= IRQ_SNAP; }
            }
        }
        if (acqf_sample(&ACQ, (uint32_t)nsmp, w)) irq_st |= IRQ_ACQ;
        /* TIC: смена периода сбрасывает счётчик */
        uint32_t per = regs[R_TIC_PERIOD];
        if (per != tic_prev) { tic_prev = per; tic_cnt = 0; }
        else if (per && ++tic_cnt == per) { tic_cnt = 0; tic_t = t96; irq_st |= IRQ_TIC; }
        /* 1PPS: такты 96 МГц между отсчётами — t96 … t96 + 3 */
        if (pps_armed && pps_t >= t96 && pps_t < t96 + 4) {
            pps_armed = 0; pps_last = pps_t; pps_n++; irq_st |= IRQ_PPS;
        } else if (pps_armed && pps_t < t96) pps_armed = 0;    /* момент в прошлом — не выдаётся */
        t96 += 4;
    }
}

static int any_ready(void)
{
    for (int e = 0; e < NE; e++)
        for (int s = 0; s < CORR_NSLOT; s++) if (E[e].s[s].ready) return 1;
    return 0;
}

static uint32_t sim_rd(uint32_t a)
{
    if (a >= R_SNAP_DATA && a < R_SNAP_DATA + 8192) return acqf_snap_rd(&ACQ, a - R_SNAP_DATA);
    if ((a >= R_ACQ_CTRL && a < R_ACQ_SUM(ACQ_G)) || (a >= R_ACQ_MEM && a < 0x8000u)) return acqf_rd(&ACQ, a);
    if (a >= CORR_BASE && a < CORR_BASE + 0x1000) {
        uint32_t e = (a >> 9) & 7, r = a & 0x1FF;
        if (e == 7) {
            uint32_t m = 0;
            for (int k = 0; k < NE; k++)
                for (int s = 0; s < CORR_NSLOT; s++) if (E[k].s[s].ready) m |= 1u << k;
            return m;
        }
        if ((int)e >= NE) return 0;
        seng_t *g = &E[e];
        if (r & 0x100) {
            if ((r & 15) == ENG_IRQ) {
                uint32_t m = 0;
                for (int s = 0; s < CORR_NSLOT; s++) if (g->s[s].ready) m |= 1u << s;
                return m;
            }
            return 0;
        }
        sslot_t *c = &g->s[r >> 4];
        switch (r & 15) {
        case CH_CTRL: return c->ctrl;
        case CH_EI: case CH_EQ: case CH_PI: case CH_PQ: case CH_LI: case CH_LQ:
            return (uint32_t)c->res[(r & 15) - CH_EI];
        case CH_DUMP_T: c->ready = 0; return c->dump_t;
        case CH_STATUS: { uint32_t v = (uint32_t)(c->ready | c->ovr << 1); c->ovr = 0; return v; }
        default: return 0;
        }
    }
    switch (a) {
    case R_ID: return 0x4D475038u;
    case R_VERSION: return ((uint32_t)NE << 24) | 0x0100;
    case R_STATUS: return 0x300u | (mx_ld & (uint8_t)(regs[R_CTRL] >> 8));
    case R_T96_LO: regs[R_T96_HI] = (uint32_t)(t96 >> 32); return (uint32_t)t96;
    case R_IRQ_STATUS: return irq_st | (any_ready() ? IRQ_CORR : 0);
    case R_SNAP_CTRL: return regs[a] | ((uint32_t)snap_busy << 31);
    case R_SNAP_T0: return snap_t0;
    case R_TIC_T_LO: return (uint32_t)tic_t;
    case R_TIC_T_HI: return (uint32_t)(tic_t >> 32);
    case R_PPS_CTRL: return (regs[a] & 0x7FFFFFFFu) | ((uint32_t)pps_armed << 31);
    case R_SPI_CMD:
        if (mx_busy) { mx_busy--; return regs[a] | 0x80000000u; }
        return regs[a] & 0x7FFFFFFFu;
    default: return a < 256 ? regs[a] : 0;
    }
}

static void sim_wr(uint32_t a, uint32_t v)
{
    if (a >= CORR_BASE && a < CORR_BASE + 0x1000) {
        uint32_t e = (a >> 9) & 7, r = a & 0x1FF;
        if ((int)e >= NE) return;
        seng_t *g = &E[e];
        if (r & 0x100) {
            switch (r & 15) {
            case ENG_CODE_WADDR: g->w_slot = (v >> 16) & 15; g->w_word = v & 0xFFF; break;
            case ENG_CODE_WDATA:
                for (int k = 0; k < 16; k++) g->mem[g->w_slot][(4 * g->w_word + k) & 16383] = (v >> k) & 1;
                g->w_word += 4;
                break;
            case ENG_START_T: g->st_t = v; break;
            case ENG_START_MASK: g->st_mask = v & 0xFFFF; g->st_v = 1; break;
            default: break;
            }
            return;
        }
        sslot_t *c = &g->s[r >> 4];
        switch (r & 15) {
        case CH_CTRL: c->ctrl = v & 0xFFFF; c->en_next = (int)(v & 1); break;
        case CH_LEN: c->len = v & 0x7FFF; break;
        case CH_CARR_RATE: c->crn = v; c->pend = 1; if (!c->en) { c->cr = c->crn; c->kr = c->krn; } break;
        case CH_CODE_RATE: c->krn = v; c->pend = 1; if (!c->en) { c->cr = c->crn; c->kr = c->krn; } break;
        case CH_CARR_PHASE: if (!c->en) c->cp = v; break;
        case CH_CODE_INT: if (!c->en) c->ci = v & 0x3FFF; break;
        case CH_CODE_FRAC: if (!c->en) c->cf = v; break;
        case CH_SPACING: c->sp = v & 0xFFFF0000u; break;
        default: break;
        }
        return;
    }
    if ((a >= R_ACQ_CTRL && a < R_ACQ_SUM(ACQ_G)) || (a >= R_ACQ_MEM && a < 0x8000u)) {
        if (a == R_ACQ_CTRL && snap_busy) v &= ~1u;          /* снимок и ускоритель — общий пул */
        acqf_wr(&ACQ, a, v);
        return;
    }
    if (a >= 256) return;
    switch (a) {
    case R_IRQ_CLR: irq_st &= ~v; break;
    case R_SNAP_CTRL:
        if (ACQ.busy) break;
        regs[a] = v; snap_busy = 1; snap_rec = 0; snap_left = regs[R_SNAP_LEN]; snap_wa = 0;
        snap_nib = 0; snap_sr = 0;
        break;
    case R_SPI_CMD: regs[a] = v; mx_frame(v); irq_st |= IRQ_SPI; break;
    case R_SPI_RDATA: break;
    case R_PPS_T_HI:
        regs[a] = v; pps_t = (uint64_t)v << 32 | regs[R_PPS_T_LO]; pps_armed = 1;
        break;
    default: regs[a] = v; break;
    }
}
