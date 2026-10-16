/* МГП-8: модель ПЛИС для проверки ПО на ПК. */
#ifndef CORR_SIM_H
#define CORR_SIM_H
#include <stdint.h>

typedef struct { uint64_t n; int32_t v[6]; } corr_sim_dump_t;

void     corr_sim_init(int n_eng);
/* обработать n отсчётов; src(i) — слово отсчёта i во внутреннем формате ПЛИС */
void     corr_sim_run(uint64_t n, uint32_t (*src)(uint64_t i));
uint64_t corr_sim_nsmp(void);
void     corr_sim_set_dump_cb(void (*cb)(int ch, const corr_sim_dump_t *d));
/* модель MAX2771: регистр микросхемы, отказ (нет ответа по SPI), число кадров, нарушений протокола
 * (пуск при занятом SPI, изменение зарезервированных битов CONF1) */
uint32_t corr_sim_max_reg(int ch, int addr);
void     corr_sim_max_fault(uint8_t dead);
int      corr_sim_max_frames(void);
int      corr_sim_max_bad(void);
/* выдано импульсов 1PPS и такт T96 последнего */
int      corr_sim_pps(uint64_t *t96_last);

#endif
