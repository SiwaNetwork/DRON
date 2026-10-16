/* МГП-8: драйвер MAX2771 на модели ПЛИС и микросхем (corr_sim.c): кадры SPI, поля регистров по
 * конфигурации PocketSDR с нижним диапазоном каналов C–H, сохранение зарезервированных битов,
 * гетеродины = RF_LO, захват синтезаторов, отказ канала. */
#include <stdio.h>
#include <math.h>
#include "fpga.h"
#include "corr_sim.h"
#include "max2771.h"
#include "gnss.h"
#include "corr.h"

static int fails;
#define CHECK(c, ...) do { if (!(c)) { printf("FAIL: " __VA_ARGS__); printf("\n"); fails++; } } while (0)

static uint32_t fld(int ch, int reg, int pos, int nbit)
{
    return corr_sim_max_reg(ch, reg) >> pos & ((1u << nbit) - 1u);
}

int main(void)
{
    max_status_t st;

    /* 1. все восемь каналов; SPI перед этим — у FX3 (драйвер забирает его) */
    corr_sim_init(CORR_NENG);
    fpga_wr(R_CTRL, 0xFF08u);
    int r = max2771_init(0xFF, &st);
    CHECK(r == 0 && !st.spi_err && !st.vfy_err && !st.unlock, "init: r=%d spi=%02X vfy=%02X unlock=%02X",
          r, st.spi_err, st.vfy_err, st.unlock);
    CHECK((fpga_rd(R_CTRL) & 0xFF08u) == 0xFF00u, "R_CTRL=%08X", fpga_rd(R_CTRL));
    CHECK(max2771_lock() == 0xFF, "LD=%02X", max2771_lock());
    CHECK(corr_sim_max_bad() == 0, "нарушений протокола/зарезервированных битов: %d", corr_sim_max_bad());
    printf("кадров SPI: %d\n", corr_sim_max_frames());
    for (int ch = 0; ch < MAX_NCH; ch++) {
        int low = ch >= 2;
        double lo = max2771_lo(ch);
        CHECK(fabs(lo - RF_LO[ch]) < 1e-3, "канал %c: LO %.3f != RF_LO %.3f", 'A' + ch, lo, RF_LO[ch]);
        CHECK(fld(ch, 0, 22, 8) == 0xFA, "канал %c: CONF1[29:22]=%02X", 'A' + ch, fld(ch, 0, 22, 8));
        CHECK(fld(ch, 0, 31, 1) == 1 && fld(ch, 0, 30, 1) == 0, "канал %c: CHIPEN/IDLE", 'A' + ch);
        CHECK(fld(ch, 0, 15, 2) == (uint32_t)low && fld(ch, 0, 13, 2) == (uint32_t)low &&
              fld(ch, 3, 28, 1) == (uint32_t)low,
              "канал %c: LNAMODE=%u MIXERMODE=%u LOBAND=%u", 'A' + ch, fld(ch, 0, 15, 2), fld(ch, 0, 13, 2),
              fld(ch, 3, 28, 1));
        CHECK(fld(ch, 0, 3, 3) == MAX_CFG[ch].fbw, "канал %c: FBW", 'A' + ch);
        CHECK(fld(ch, 4, 13, 15) == MAX_CFG[ch].ndiv && fld(ch, 4, 3, 10) == MAX_CFG[ch].rdiv &&
              fld(ch, 3, 3, 1) == 1, "канал %c: NDIV/RDIV/INT_PLL", 'A' + ch);
        CHECK(fld(ch, 1, 27, 1) == 1 && fld(ch, 1, 15, 12) == 170 && fld(ch, 1, 9, 2) == 1 &&
              fld(ch, 1, 6, 3) == 2, "канал %c: IQEN/GAINREF/FORMAT/BITS", 'A' + ch);
        CHECK(fld(ch, 2, 15, 1) == 0 && fld(ch, 2, 11, 1) == 0, "канал %c: FHIPEN/STRMEN", 'A' + ch);
        CHECK(fld(ch, 7, 28, 1) == 1, "канал %c: EXTADCCLK", 'A' + ch);
        CHECK(fld(ch, 3, 24, 1) == (ch == 0), "канал %c: REFOUTEN=%u", 'A' + ch, fld(ch, 3, 24, 1));
    }
    CHECK(fld(0, 3, 29, 3) == 3 && fld(0, 0xA, 2, 1) == 1 && fld(0, 7, 2, 1) == 0,
          "канал A: REFDIV/CLKOUT_SEL/ADCCLK");
    /* зарезервированные биты вне полей не изменены (CONF2: DIEID; регистры 0x6, 0x8, 0x9 не тронуты) */
    CHECK((corr_sim_max_reg(3, 1) & 3u) == 1u, "DIEID");
    CHECK(corr_sim_max_reg(5, 6) == 0x08000000u && corr_sim_max_reg(5, 8) == 0x01E0F401u,
          "регистры 0x6/0x8 изменены");

    /* 2. каналы A и B (одночастотный режим L1/G1): остальные выключены */
    corr_sim_init(CORR_NENG);
    r = max2771_init(0x03, &st);
    CHECK(r == 0 && (fpga_rd(R_CTRL) >> 8 & 0xFF) == 0x03 && max2771_lock() == 0x03,
          "A+B: r=%d SHDN=%02X LD=%02X", r, fpga_rd(R_CTRL) >> 8 & 0xFF, max2771_lock());

    /* 3. отказ канала E (нет ответа по SPI): запись не выполняется, остальные настроены */
    corr_sim_init(CORR_NENG);
    corr_sim_max_fault(0x10);
    r = max2771_init(0xFF, &st);
    CHECK(r != 0 && st.spi_err == 0x10 && st.vfy_err == 0 && st.unlock == 0x10,
          "отказ E: r=%d spi=%02X vfy=%02X unlock=%02X", r, st.spi_err, st.vfy_err, st.unlock);
    CHECK(fld(4, 4, 13, 15) != MAX_CFG[4].ndiv && fld(3, 4, 13, 15) == MAX_CFG[3].ndiv, "отказ E: регистры");
    CHECK(corr_sim_max_bad() == 0, "отказ E: нарушений %d", corr_sim_max_bad());

    printf(fails ? "test_max2771: %d FAIL\n" : "test_max2771: OK%.0d\n", fails);
    return fails != 0;
}
