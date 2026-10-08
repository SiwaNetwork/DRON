/* МГП-8: драйвер аппаратного коррелятора (ПЛИС) и зеркало NCO. */
#include <math.h>
#include <string.h>
#include "fpga.h"
#include "codes.h"
#include "corr.h"

corr_ch_t CORR[CORR_MAXCH];
int corr_nch;

#define TWO32 4294967296.0

uint32_t corr_rate_carr(double f_hz)
{
    return (uint32_t)(int64_t)llround(f_hz / FS_HZ * TWO32);
}

uint32_t corr_rate_code(double cps)
{
    return (uint32_t)llround(cps / FS_HZ * TWO32);
}

uint64_t corr_time_now(void)
{
    uint32_t lo = fpga_rd(R_T96_LO), hi = fpga_rd(R_T96_HI);
    return (((uint64_t)hi << 32) | lo) >> 2;
}

int corr_init(void)
{
    memset(CORR, 0, sizeof(CORR));
    if (fpga_rd(R_ID) != 0x4D475038u) return 0;
    int neng = (int)(fpga_rd(R_VERSION) >> 24);
    if (neng > CORR_MAXENG) neng = CORR_MAXENG;
    corr_nch = neng * CORR_NSLOT;
    for (int ch = 0; ch < corr_nch; ch++) fpga_wr(R_CH(ch / 16, ch % 16, CH_CTRL), 0);
    return corr_nch;
}

int corr_alloc(int sig)
{
    for (int ch = 0; ch < corr_nch; ch++)
        if (!CORR[ch].used) { memset(&CORR[ch], 0, sizeof(CORR[ch])); CORR[ch].used = 1; CORR[ch].sig = sig; return ch; }
    return -1;
}

void corr_free(int ch)
{
    corr_stop(ch);
    CORR[ch].used = 0;
}

/* память кода с дополнением: mem[a] = code[(a − 1) mod L], a = 0 .. L+7 (fpga/rtl/corr_engine.v) */
int corr_load_code(int ch, int sig, int prn)
{
    static uint8_t bits[CODE_MAX_BYTES];
    int L = code_gen(sig, prn, bits);
    if (L <= 0) return 0;
    int e = ch / 16, s = ch % 16, n = L + 8;
    fpga_wr(R_ENG(e, ENG_CODE_WADDR), (uint32_t)s << 16);
    for (int a0 = 0; a0 < n; a0 += 16) {
        uint32_t w = 0;
        for (int k = 0; k < 16 && a0 + k < n; k++) {
            int i = (a0 + k - 1 + L) % L;
            w |= (uint32_t)code_bit(bits, i) << k;
        }
        while (fpga_rd(R_ENG(e, ENG_BUSY)) & 1) ;
        fpga_wr(R_ENG(e, ENG_CODE_WDATA), w);
    }
    while (fpga_rd(R_ENG(e, ENG_BUSY)) & 1) ;
    CORR[ch].L = (uint32_t)L;
    return L;
}

void corr_config(int ch, int sig, int prn, int fcn, int nint, double spacing_chips,
                 double f_carr_hz, double code_cps, double code_phase_chips, double carr_phase_cyc,
                 uint64_t t_start)
{
    corr_ch_t *c = &CORR[ch];
    const sig_info_t *si = &SIGS[sig];
    int e = ch / 16, s = ch % 16;
    c->sig = sig; c->prn = prn; c->fcn = fcn; c->nint = (uint32_t)nint;
    c->ctrl = (si->boc ? CTRL_BOC : 0) | (si->tdm ? CTRL_TDM : 0) | CTRL_RF(si->rf) | CTRL_NINT(nint);
    c->carr_rate = corr_rate_carr(f_carr_hz);
    c->code_rate = corr_rate_code(code_cps);
    double cp = fmod(code_phase_chips, (double)c->L);
    if (cp < 0) cp += c->L;
    c->code_fx = (uint64_t)llround(cp * TWO32) % ((uint64_t)c->L << 32);
    c->code_tot = c->code_fx;
    double fr = carr_phase_cyc - floor(carr_phase_cyc);
    uint32_t cp0 = (uint32_t)(llround(fr * TWO32) & 0xFFFFFFFFll);
    c->if_rate = corr_rate_carr(sig_if(sig, fcn));
    c->dop_fx = (int64_t)cp0;
    c->t_ref = t_start;
    c->pend = 0;
    c->last_dump = t_start;
    fpga_wr(R_CH(e, s, CH_CTRL), c->ctrl);
    fpga_wr(R_CH(e, s, CH_LEN), c->L);
    fpga_wr(R_CH(e, s, CH_SPACING), (uint32_t)llround(spacing_chips * 65536.0) << 16);
    fpga_wr(R_CH(e, s, CH_CARR_RATE), c->carr_rate);
    fpga_wr(R_CH(e, s, CH_CODE_RATE), c->code_rate);
    fpga_wr(R_CH(e, s, CH_CARR_PHASE), cp0);
    fpga_wr(R_CH(e, s, CH_CODE_INT), (uint32_t)(c->code_fx >> 32));
    fpga_wr(R_CH(e, s, CH_CODE_FRAC), (uint32_t)c->code_fx);
}

void corr_start(const int *chs, int n, uint64_t t_start)
{
    uint32_t mask[CORR_MAXENG] = {0};
    for (int k = 0; k < n; k++) mask[chs[k] / 16] |= 1u << (chs[k] % 16);
    for (int e = 0; e < CORR_MAXENG; e++) {
        if (!mask[e]) continue;
        fpga_wr(R_ENG(e, ENG_START_T), (uint32_t)t_start);
        fpga_wr(R_ENG(e, ENG_START_MASK), mask[e]);
    }
}

void corr_stop(int ch)
{
    fpga_wr(R_CH(ch / 16, ch % 16, CH_CTRL), CORR[ch].ctrl);
}

void corr_set_rates(int ch, double f_carr_hz, double code_cps)
{
    corr_ch_t *c = &CORR[ch];
    c->carr_rate_n = corr_rate_carr(f_carr_hz);
    c->code_rate_n = corr_rate_code(code_cps);
    c->pend = 1;
    fpga_wr(R_CH(ch / 16, ch % 16, CH_CARR_RATE), c->carr_rate_n);
    fpga_wr(R_CH(ch / 16, ch % 16, CH_CODE_RATE), c->code_rate_n);
}

/* перенос зеркала на отсчёт n, в т. ч. назад (n < t_ref: момент внутри группы, в которой уже
 * сменились шаги). Арифметика знаковая: остаток от беззнакового (−k·rate) mod L·2^32 дал бы
 * сдвиг 2^64 mod L·2^32 (для L = 1023 — ровно 4 чипа). |dn · rate| < 2^63 при |dn| < 2^31. */
static void advance(corr_ch_t *c, uint64_t n)
{
    int64_t dn = (int64_t)(n - c->t_ref);
    int64_t mod = (int64_t)c->L << 32;
    int64_t d = dn * (int64_t)c->code_rate;
    int64_t f = ((int64_t)c->code_fx + d % mod) % mod;
    if (f < 0) f += mod;
    c->code_fx = (uint64_t)f;
    c->code_tot += (uint64_t)d;
    c->dop_fx += dn * (int64_t)(int32_t)(c->carr_rate - c->if_rate);
    c->t_ref = n;
}

int corr_read(int ch, corr_dump_t *d, uint64_t n_now)
{
    corr_ch_t *c = &CORR[ch];
    int e = ch / 16, s = ch % 16;
    if (!(fpga_rd(R_CH(e, s, CH_STATUS)) & 1)) return 0;
    d->EI = (int32_t)fpga_rd(R_CH(e, s, CH_EI));
    d->EQ = (int32_t)fpga_rd(R_CH(e, s, CH_EQ));
    d->PI = (int32_t)fpga_rd(R_CH(e, s, CH_PI));
    d->PQ = (int32_t)fpga_rd(R_CH(e, s, CH_PQ));
    d->LI = (int32_t)fpga_rd(R_CH(e, s, CH_LI));
    d->LQ = (int32_t)fpga_rd(R_CH(e, s, CH_LQ));
    uint32_t t = fpga_rd(R_CH(e, s, CH_DUMP_T));
    /* восстановление старших разрядов номера отсчёта по текущему времени */
    uint64_t n = (n_now & ~0xFFFFFFFFull) | t;
    if (n > n_now) n -= 1ull << 32;
    d->n = n;
    /* зеркало: шаги, записанные до этого сброса, вступают в силу с начала следующей группы */
    if (c->pend) {
        uint64_t na = ((n >> 2) + 1) << 2;
        advance(c, na);
        c->code_rate = c->code_rate_n;
        c->carr_rate = c->carr_rate_n;
        c->pend = 0;
    }
    c->last_dump = n;
    return 1;
}

void corr_phase_at(int ch, uint64_t n, double *code_chips, double *carr_cyc)
{
    corr_ch_t t = CORR[ch];
    advance(&t, n);
    if (code_chips) *code_chips = (double)t.code_fx / TWO32;
    if (carr_cyc) *carr_cyc = (double)t.dop_fx / TWO32;
}

uint64_t corr_code_total_at(int ch, uint64_t n)
{
    corr_ch_t t = CORR[ch];
    advance(&t, n);
    return t.code_tot;
}
