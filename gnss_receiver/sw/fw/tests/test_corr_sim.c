/* Проверка модели ПЛИС (src/corr_sim.c): сценарий теста движка коррелятора fpga/tb (16 слотов,
 * BOC, TDM, n_int > 1, смена шагов NCO) — сравнение сбросов с битово-точной моделью Python. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "fpga.h"
#include "corr_sim.h"

#define STIM "../../fpga/tb/stim/"
static uint32_t *smp;
static long nsmp;
static FILE *fo;

/* файлы tb/stim: первое слово — число записей (для events.hex — число троек), далее слова */
static uint32_t *readhex(const char *fn, long *n, int words_per_rec)
{
    FILE *fp = fopen(fn, "r");
    if (!fp) { printf("нет %s (python3 ../../fpga/tb/gen_stim.py gen)\n", fn); exit(1); }
    unsigned v;
    if (fscanf(fp, "%x", &v) != 1) exit(1);
    v *= (unsigned)words_per_rec;
    uint32_t *a = malloc(sizeof(uint32_t) * (v + 1));
    long k = 0;
    while (k < (long)v && fscanf(fp, "%x", &a[k]) == 1) k++;
    fclose(fp);
    *n = k;
    return a;
}

static uint32_t src(uint64_t i) { return smp[i]; }
static void on_dump(int ch, const corr_sim_dump_t *d)
{
    fprintf(fo, "%d %llu %d %d %d %d %d %d\n", ch, (unsigned long long)d->n,
            d->v[0], d->v[1], d->v[2], d->v[3], d->v[4], d->v[5]);
}

int main(void)
{
    long ncfg, nev;
    uint32_t *cfg = readhex(STIM "cfg.hex", &ncfg, 1);
    smp = readhex(STIM "samples.hex", &nsmp, 1);
    uint32_t *ev = readhex(STIM "events.hex", &nev, 3);
    corr_sim_init(1);
    for (long i = 0; i + 1 < ncfg; i += 2) fpga_wr(CORR_BASE + (cfg[i] & 0x1FF), cfg[i + 1]);
    fo = fopen("build/dumps_c.txt", "w");
    corr_sim_set_dump_cb(on_dump);
    long e = 0;
    uint64_t n = 0;
    while (n < (uint64_t)nsmp) {
        uint64_t next = (e + 2 < nev) ? ev[e] : (uint64_t)nsmp;
        if (next > n) { corr_sim_run(next - n, src); n = next; }
        while (e + 2 < nev && ev[e] == n) { fpga_wr(CORR_BASE + (ev[e + 1] & 0x1FF), ev[e + 2]); e += 3; }
    }
    fclose(fo);
    /* сравнение с моделью Python (без учёта порядка строк) */
    char a[256];
    FILE *fm = fopen("../../fpga/tb/out/dumps_model.txt", "r"), *fc = fopen("build/dumps_c.txt", "r");
    int nm = 0, nc = 0, bad = 0;
    static char lm[256][128];
    while (fgets(a, sizeof a, fm)) strcpy(lm[nm++], a);
    while (fgets(a, sizeof a, fc)) {
        int f = 0;
        for (int i = 0; i < nm; i++) if (!strcmp(lm[i], a)) { f = 1; break; }
        if (!f) { if (bad < 5) printf("  нет в модели: %s", a); bad++; }
        nc++;
    }
    printf("Модель ПЛИС на C: сбросов %d, в модели Python %d, расхождений %d\n", nc, nm, bad);
    return (bad || nc != nm) ? 1 : 0;
}
