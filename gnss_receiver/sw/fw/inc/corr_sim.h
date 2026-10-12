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

#endif
