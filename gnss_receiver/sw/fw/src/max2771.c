/* МГП-8: драйвер MAX2771 — см. inc/max2771.h.
 *
 * Поля регистров — по таблице PocketSDR (src/sdr_conf.c, BSD-2): имя, адрес, младший бит, ширина.
 * Порядок как в pocket_conf: сначала постоянные поля (set_fixed), затем поля канала из
 * конфигурации (они имеют приоритет: например, FHIPEN = 0 по конфигурации FE 8CH). */
#include "max2771.h"
#include "fpga.h"

/* постоянные поля всех каналов: {рег, бит, ширина}, значение */
typedef struct { max_fld_t f; uint32_t v; } max_fv_t;

static const max_fv_t FIXED[] = {
    /* CONF1 (0x0) */
    {{0x0, 31, 1}, 1},    /* CHIPEN */
    {{0x0, 30, 1}, 0},    /* IDLE */
    {{0x0, 17, 1}, 0},    /* MIXPOLE */
    {{0x0,  6, 7}, 0},    /* FCEN */
    {{0x0,  2, 1}, 1},    /* F3OR5: фильтр 5-го порядка */
    {{0x0,  1, 1}, 0},    /* FCENX */
    {{0x0,  0, 1}, 1},    /* FGAIN */
    /* CONF2 (0x1) */
    {{0x1, 28, 1}, 0},    /* ANAIMON */
    {{0x1, 27, 1}, 1},    /* IQEN: каналы I и Q */
    {{0x1, 15, 12}, 170}, /* GAINREF */
    {{0x1, 13, 2}, 0},    /* SPI_SDIO_CONFIG */
    {{0x1, 11, 2}, 0},    /* AGCMODE: АРУ независимо по I и Q */
    {{0x1,  9, 2}, 1},    /* FORMAT: знак-модуль */
    {{0x1,  6, 3}, 2},    /* BITS: 2 бита */
    {{0x1,  4, 2}, 0},    /* DRVCFG: КМОП */
    /* CONF3 (0x2) */
    {{0x2, 22, 6}, 58},   /* GAININ */
    {{0x2, 20, 1}, 0},    /* HILOADEN */
    {{0x2, 15, 1}, 0},    /* FHIPEN (конфигурация FE 8CH) */
    {{0x2, 13, 1}, 1},    /* PGAIEN */
    {{0x2, 12, 1}, 1},    /* PGAQEN */
    {{0x2, 11, 1}, 0},    /* STRMEN */
    {{0x2, 10, 1}, 0},    /* STRMSTART */
    {{0x2,  9, 1}, 0},    /* STRMSTOP */
    {{0x2,  4, 2}, 1},    /* STRMBITS */
    {{0x2,  3, 1}, 0},    /* STAMPEN */
    {{0x2,  2, 1}, 0},    /* TIMESYNCEN */
    {{0x2,  1, 1}, 0},    /* DATSYNCEN */
    {{0x2,  0, 1}, 0},    /* STRMRST */
    /* PLLCONF (0x3) */
    {{0x3, 19, 2}, 1},    /* IXTAL */
    {{0x3,  9, 1}, 0},    /* ICP */
    {{0x3,  2, 1}, 0},    /* PWRSAV */
    /* CLK (0x7) */
    {{0x7, 28, 1}, 1},    /* EXTADCCLK: АЦП от внешнего такта (CLKOUT канала A через буфер) */
    {{0x7,  0, 1}, 0},    /* MODE */
};

/* тактирование — только канал A (источник ADC_CLK_SRC), по [CH1] конфигурации PocketSDR */
static const max_fv_t CLK_A[] = {
    {{0x3, 29, 3}, 3},    /* REFDIV: CLKOUT = f_ref ×1 = 24 МГц */
    {{0x3, 24, 1}, 1},    /* REFOUTEN: выход CLKOUT включён */
    {{0x7, 16, 12}, 0},   /* REFCLK_L_CNT */
    {{0x7,  4, 12}, 0},   /* REFCLK_M_CNT */
    {{0x7,  3, 1}, 0},    /* FCLKIN */
    {{0x7,  2, 1}, 0},    /* ADCCLK */
    {{0xA, 16, 12}, 0},   /* ADCCLK_L_CNT */
    {{0xA,  4, 12}, 0},   /* ADCCLK_M_CNT */
    {{0xA,  3, 1}, 0},    /* PREFRACDIV_SEL */
    {{0xA,  2, 1}, 1},    /* CLKOUT_SEL */
};
static const max_fv_t CLK_X[] = {
    {{0x3, 24, 1}, 0},    /* REFOUTEN: CLKOUT каналов B–H не подключён — выключен */
};

static const max_fld_t F_LNAMODE = {0x0, 15, 2}, F_MIXERMODE = {0x0, 13, 2}, F_FBW = {0x0, 3, 3},
                       F_LOBAND = {0x3, 28, 1}, F_INT_PLL = {0x3, 3, 1}, F_NDIV = {0x4, 13, 15},
                       F_RDIV = {0x4, 3, 10}, F_FDIV = {0x5, 8, 20};

/* гетеродины = RF_LO (signals.c): L1/E1/B1C, G1, L2, G2, L5/E5a, E5b/B2I, B3I, L6 */
const max_ch_cfg_t MAX_CFG[MAX_NCH] = {
    {  392,   6, 0, 1, 3, 0},   /* A 1568.000 МГц */
    {  534,   8, 0, 1, 1, 0},   /* B 1602.000 */
    { 1023,  20, 0, 1, 2, 1},   /* C 1227.600 */
    {  623,  12, 0, 1, 1, 1},   /* D 1246.000 */
    { 7843, 160, 0, 1, 7, 1},   /* E 1176.450 */
    {20119, 400, 0, 1, 7, 1},   /* F 1207.140 */
    {10571, 200, 0, 1, 7, 1},   /* G 1268.520 */
    { 1705,  32, 0, 1, 1, 1},   /* H 1278.750 */
};

#define SPI_POLL  20000         /* опросов SPI_CMD.busy (кадр ≈ 9 мкс при SPI_DIV = 8) */
#define LOCK_POLL 200000        /* опросов R_STATUS.LD (≈ 40 мс при чтении 32 бит ≈ 0,2 мкс) */

static uint32_t fmask(max_fld_t f) { return (f.nbit >= 32 ? 0xFFFFFFFFu : ((1u << f.nbit) - 1u)) << f.pos; }
static uint32_t fset(uint32_t r, max_fld_t f, uint32_t v) { return (r & ~fmask(f)) | ((v << f.pos) & fmask(f)); }

static int spi_wait(void)
{
    for (int i = 0; i < SPI_POLL; i++)
        if (!(fpga_rd(R_SPI_CMD) & 0x80000000u)) return 0;
    return -1;
}

uint32_t max2771_read(int ch, int addr, int *err)
{
    int e = spi_wait();
    fpga_wr(R_SPI_CMD, ((uint32_t)addr & 0xFFFu) << 4 | 1u << 3 | ((uint32_t)ch & 7u));
    e |= spi_wait();
    if (err) *err = e;
    return fpga_rd(R_SPI_RDATA);
}

int max2771_write(int ch, int addr, uint32_t v)
{
    int e = spi_wait();
    fpga_wr(R_SPI_WDATA, v);
    fpga_wr(R_SPI_CMD, ((uint32_t)addr & 0xFFFu) << 4 | ((uint32_t)ch & 7u));
    return e | spi_wait();
}

static uint32_t apply_tab(uint32_t r, int addr, const max_fv_t *t, int n)
{
    for (int k = 0; k < n; k++)
        if (t[k].f.reg == addr) r = fset(r, t[k].f, t[k].v);
    return r;
}

static uint32_t mask_tab(int addr, const max_fv_t *t, int n)
{
    uint32_t m = 0;
    for (int k = 0; k < n; k++)
        if (t[k].f.reg == addr) m |= fmask(t[k].f);
    return m;
}

#define NTAB(t) ((int)(sizeof(t) / sizeof((t)[0])))

uint32_t max2771_apply(int ch, int addr, uint32_t r)
{
    const max_ch_cfg_t *c = &MAX_CFG[ch];
    r = apply_tab(r, addr, FIXED, NTAB(FIXED));
    if (ch == 0) r = apply_tab(r, addr, CLK_A, NTAB(CLK_A));
    else         r = apply_tab(r, addr, CLK_X, NTAB(CLK_X));
    const struct { max_fld_t f; uint32_t v; } cf[] = {
        {F_LNAMODE, c->low}, {F_MIXERMODE, c->low}, {F_FBW, c->fbw}, {F_LOBAND, c->low},
        {F_INT_PLL, c->int_pll}, {F_NDIV, c->ndiv}, {F_RDIV, c->rdiv}, {F_FDIV, c->fdiv},
    };
    for (int k = 0; k < NTAB(cf); k++)
        if (cf[k].f.reg == addr) r = fset(r, cf[k].f, cf[k].v);
    return r;
}

uint32_t max2771_mask(int ch, int addr)
{
    const max_fld_t cf[] = {F_LNAMODE, F_MIXERMODE, F_FBW, F_LOBAND, F_INT_PLL, F_NDIV, F_RDIV, F_FDIV};
    uint32_t m = mask_tab(addr, FIXED, NTAB(FIXED));
    m |= ch == 0 ? mask_tab(addr, CLK_A, NTAB(CLK_A)) : mask_tab(addr, CLK_X, NTAB(CLK_X));
    for (int k = 0; k < NTAB(cf); k++)
        if (cf[k].reg == addr) m |= fmask(cf[k]);
    return m;
}

double max2771_lo(int ch)
{
    const max_ch_cfg_t *c = &MAX_CFG[ch];
    double n = c->ndiv + (c->int_pll ? 0.0 : c->fdiv / 1048576.0);
    return MAX_FREF / c->rdiv * n;
}

uint8_t max2771_lock(void) { return (uint8_t)(fpga_rd(R_STATUS) & 0xFFu); }

/* настройка одного канала: 0 — успешно, 1 — нет ответа по SPI (тайм-аут или в CONF1[29:22] не
 * 11111010 — тогда запись не выполняется, чтобы не испортить зарезервированные биты),
 * 2 — расхождение при обратном чтении */
static int config_ch(int ch)
{
    for (int a = 0; a < MAX_NREG; a++) {
        uint32_t m = max2771_mask(ch, a);
        if (!m) continue;
        int e;
        uint32_t old = max2771_read(ch, a, &e);
        if (e || (a == 0 && (old >> 22 & 0xFFu) != 0xFAu)) return 1;
        uint32_t v = max2771_apply(ch, a, old);
        if (max2771_write(ch, a, v)) return 1;
        uint32_t rb = max2771_read(ch, a, &e);
        if (e) return 1;
        if ((rb ^ v) & m) return 2;
    }
    return 0;
}

int max2771_init(uint8_t mask, max_status_t *st)
{
    max_status_t s = {0, 0, 0};
    uint32_t ctrl = fpga_rd(R_CTRL);
    fpga_wr(R_CTRL, (ctrl & ~0xFF08u) | (uint32_t)mask << 8);  /* SPI — у МК; SHDN = mask */
    for (int k = 0; k < MAX_NCH; k++) {                         /* A — первым */
        if (!(mask >> k & 1)) continue;
        int r = config_ch(k);
        if (r == 1) s.spi_err |= (uint8_t)(1u << k);
        if (r == 2) s.vfy_err |= (uint8_t)(1u << k);
    }
    uint8_t want = mask & (uint8_t)~(s.spi_err | s.vfy_err), ld = 0;
    for (int i = 0; i < LOCK_POLL; i++)
        if (((ld = max2771_lock()) & want) == want) break;
    s.unlock = mask & (uint8_t)~ld;
    if (st) *st = s;
    return (s.spi_err | s.vfy_err | s.unlock) ? -1 : 0;
}
