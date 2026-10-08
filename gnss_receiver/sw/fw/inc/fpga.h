/* МГП-8: карта регистров ПЛИС (fpga/rtl/mgp8_core.v, corr_engine.v) и доступ к ним.
 * Адреса — номера 32-битных слов на шине FMC (байтовый адрес = FMC_BASE + 4·адрес). */
#ifndef FPGA_H
#define FPGA_H
#include <stdint.h>

/* --- системные регистры */
#define R_ID          0x0000u   /* 0x4D475038 */
#define R_VERSION     0x0001u
#define R_CTRL        0x0002u   /* [1:0] фаза приёма, [2] FX3, [3] SPI у FX3, [4] LED, [15:8] SHDN */
#define R_STATUS      0x0003u   /* [7:0] LD, [8] FX3, [9] ФАПЧ */
#define R_T96_LO      0x0004u
#define R_T96_HI      0x0005u
#define R_TIC_PERIOD  0x0006u
#define R_TIC_T_LO    0x0007u
#define R_TIC_T_HI    0x0008u
#define R_IRQ_STATUS  0x0009u
#define R_IRQ_MASK    0x000Au
#define R_IRQ_CLR     0x000Bu
#define R_PPS_T_LO    0x000Cu
#define R_PPS_T_HI    0x000Du
#define R_PPS_CTRL    0x000Eu
#define R_EXT_CTRL    0x000Fu
#define R_EXT_T_LO    0x0010u
#define R_EXT_T_HI    0x0011u
#define R_REF_T_LO    0x0012u
#define R_REF_T_HI    0x0013u
#define R_REF_CNT     0x0014u
#define R_SPI_CMD     0x0020u
#define R_SPI_WDATA   0x0021u
#define R_SPI_RDATA   0x0022u
#define R_SPI_DIV     0x0023u
#define R_SNAP_CTRL   0x0030u
#define R_SNAP_T      0x0031u
#define R_SNAP_LEN    0x0032u
#define R_SNAP_T0     0x0033u
#define R_DBG_SEL     0x0040u
#define R_SNAP_DATA   0x2000u   /* 8K слов, 8 отсчётов {sI,mI,sQ,mQ} в слове, первый — мл. */

#define IRQ_CORR      (1u << 0)
#define IRQ_TIC       (1u << 1)
#define IRQ_PPS       (1u << 2)
#define IRQ_EXT       (1u << 3)
#define IRQ_REF       (1u << 4)
#define IRQ_SPI       (1u << 5)
#define IRQ_SNAP      (1u << 6)

/* --- корреляторы: 0x1000 + {engine[2:0], reg[8:0]} */
#define CORR_BASE     0x1000u
#define CORR_NSLOT    16
#define CORR_MAXENG   7
#define R_CH(e, s, r) (CORR_BASE + ((uint32_t)(e) << 9) + ((uint32_t)(s) << 4) + (r))
#define R_ENG(e, r)   (CORR_BASE + ((uint32_t)(e) << 9) + 0x100u + (r))
#define R_BANK_IRQ    (CORR_BASE + (7u << 9))
enum {                          /* регистры канала */
    CH_CTRL = 0, CH_LEN, CH_CARR_RATE, CH_CODE_RATE, CH_CARR_PHASE, CH_CODE_INT, CH_CODE_FRAC,
    CH_SPACING, CH_EI, CH_EQ, CH_PI, CH_PQ, CH_LI, CH_LQ, CH_DUMP_T, CH_STATUS
};
enum {                          /* регистры движка */
    ENG_CODE_WADDR = 0, ENG_CODE_WDATA, ENG_IRQ, ENG_BUSY, ENG_START_T, ENG_START_MASK
};
#define CTRL_EN       (1u << 0)
#define CTRL_BOC      (1u << 1)
#define CTRL_TDM      (1u << 2)
#define CTRL_RF(n)    ((uint32_t)(n) << 3)
#define CTRL_NINT(n)  ((uint32_t)(n) << 8)

/* --- доступ: на МК — шина FMC (банк 1, NE1), на ПК — функции модели (corr_sim.c) */
#ifdef MGP8_MCU
#define FMC_BASE 0x60000000u
static inline uint32_t fpga_rd(uint32_t a) { return *(volatile uint32_t *)(FMC_BASE + 4u * a); }
static inline void fpga_wr(uint32_t a, uint32_t v) { *(volatile uint32_t *)(FMC_BASE + 4u * a) = v; }
#else
extern uint32_t (*fpga_rd_fn)(uint32_t a);
extern void (*fpga_wr_fn)(uint32_t a, uint32_t v);
static inline uint32_t fpga_rd(uint32_t a) { return fpga_rd_fn(a); }
static inline void fpga_wr(uint32_t a, uint32_t v) { fpga_wr_fn(a, v); }
#endif

#endif
