/* МГП-8: битово-точная модель ускорителя захвата ПЛИС (fpga/rtl/acq_fft.v) — для модели ПЛИС на ПК
 * (corr_sim.c) и генератора эталонов теста RTL (fpga/tb/gen_acq.c). Регистры — inc/fpga.h (R_ACQ_*). */
#ifndef ACQF_SIM_H
#define ACQF_SIM_H
#include <stdint.h>
#include "fpga.h"

#define ACQF_N     2048          /* ячеек задержки на период кода (размер БПФ) */
#define ACQF_G     7             /* гипотез доплера на запуск */
#define ACQF_PROC_CLK(ng) ACQ_PROC_CLK(ng)   /* тактов 96 МГц на обработку периода */

typedef struct {
    /* регистры */
    uint32_t ctrl, dphi, K, ns, nper, scale, t_start, m[ACQF_G], dsh[ACQF_G];
    /* память: общий пул 16 × 1K × 18 (снимок или накопители A_g — пул[2g + n[10]], ячейки
     * захвата C — пул[14 + k[10]]) и собственная X, R ({im[8:0], re[8:0]}) */
    uint32_t pool[16][1024];
    uint32_t X[ACQF_N], R[ACQF_N];
    /* состояние */
    int      busy, ovr, rec, ng, ch, cap_p, proc_p;
    uint32_t t_next, t_ref, ph, r, i, k;
    int32_t  bre, bim;
    uint32_t phi[ACQF_G];
    int      sh_cap[ACQF_G];
    uint32_t peak[ACQF_G], sum[ACQF_G];
} acqf_t;

void     acqf_reset(acqf_t *m);
/* регистры: a — адрес слова (R_ACQ_*); окно памяти R_ACQ_MEM */
void     acqf_wr(acqf_t *m, uint32_t a, uint32_t v);
uint32_t acqf_rd(const acqf_t *m, uint32_t a);
/* отсчёт: номер (мл. 32 бит) и слово восьми ВЧ-каналов; 1 — запуск завершён (строб прерывания) */
int      acqf_sample(acqf_t *m, uint32_t count, uint32_t w);
/* снимок в общем пуле: слово wa (13 бит) — пары пул[2·wa[12:10]], пул[2·wa[12:10] + 1] */
void     acqf_snap_wr(acqf_t *m, uint32_t wa, uint32_t v);
uint32_t acqf_snap_rd(const acqf_t *m, uint32_t wa);

#endif
