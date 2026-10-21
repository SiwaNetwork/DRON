/* МГП-8: тест RTL ускорителя захвата (rtl/acq_fft.v) — сценарий, воздействия и эталон по
 * битово-точной модели sw/fw/src/acqf_sim.c; сравнение с выходом стенда tb/tb_acq.v.
 * Запуск (из fpga/): gen_acq gen | check. Режим gen также пишет таблицу поворотов rtl/acq_tw.hex.
 *
 * Команды (tb/stim/acq_cmd.hex, слово 0 — число слов): тройки [оп, a, d]
 *   1 — запись регистра a (или опоры R, 0x4000 + k) значением d
 *   2 — подача отсчётов до номера a (отсчёт i: слово smp[i], номер ACQ_BASE + i, строб раз в 4 такта)
 *   3 — вывод (a — маска): [0] регистры 0x60–0x87 «R aa dddddddd», [1] пул 0x4000–0x7FFF
 *       «P aaaa ddddd», [2] CTRL «C dddddddd», [3] число строб завершения «D n»
 *   4 — запись слова снимка: wa = a, данные d
 *   5 — чтение слова снимка (окно 0x2000): «S aaaa dddddddd»
 *   0 — конец */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "fpga.h"
#include "acqf_sim.h"

#define ACQ_BASE 0xFFFFF000u     /* номер первого отсчёта (переход через 2^32 в начале сценария) */
#define SMAX     (1 << 18)
#define CMAX     (1 << 16)
#define FS       24e6
#define FCHIP    1.023e6
#define L        1023
#define PI       3.14159265358979323846

static uint32_t cmd[CMAX], smp[SMAX];
static int ncmd, nsmp;
static uint64_t rs = 0x9E3779B97F4A7C15ull;

static uint32_t rnd(void)
{
    rs ^= rs << 13; rs ^= rs >> 7; rs ^= rs << 17;
    return (uint32_t)(rs >> 16);
}
static double urand(void) { return (rnd() + 0.5) / 4294967296.0; }
static double grand(void) { return sqrt(-2.0 * log(urand())) * cos(2 * PI * urand()); }

static void op(uint32_t o, uint32_t a, uint32_t d)
{
    if (ncmd + 3 >= CMAX) { fprintf(stderr, "gen_acq: переполнен список команд\n"); exit(2); }
    cmd[1 + ncmd++] = o; cmd[1 + ncmd++] = a; cmd[1 + ncmd++] = d;
}
static void wr(uint32_t a, uint32_t d) { op(1, a, d); }
static void runto(int n) { op(2, (uint32_t)n, 0); if (n > nsmp) nsmp = n; }
static void dump(uint32_t m) { op(3, m, 0); }

/* ------------------------------------------------------------ воздействия */
static int code[L];
static uint32_t R_rep[ACQ_N];

/* канал 2 — сигнал (код ±1 L = 1023, 1,023 Мчип/с, несущая FSIG, задержка D0 чипов, амплитуда A0)
 * в шуме σ = 1/√2 на составляющую, 2 разряда с порогом 1/√2; остальные каналы — случайные */
#define FSIG 2.0015e6
#define D0   300.4
#define A0   0.15
static uint32_t qnt(double v) { return (v < 0 ? 2u : 0u) | (fabs(v) > 0.70710678 ? 1u : 0u); }

static void gen_samples(int n)
{
    for (int i = 0; i < n; i++) {
        double t = i / FS, ch = fmod(t * FCHIP + D0, (double)L);
        double ph = 2 * PI * fmod(FSIG * t, 1.0) + 0.7;
        double a = A0 * code[(int)ch];
        double re = a * cos(ph) + 0.70710678 * grand(), im = a * sin(ph) + 0.70710678 * grand();
        uint32_t w = rnd() & ~(0xFu << 8);
        smp[i] = w | (qnt(re) << 2 | qnt(im)) << 8;
    }
}

/* спектр опоры: ДПФ (−2π) копии кода в точках (k + 0,5)·L/N, ±255, {im9, re9} */
static void gen_ref(void)
{
    static double rr[ACQ_N], ri[ACQ_N];
    double mx = 0;
    for (int n = 0; n < (int)ACQ_N; n++) {
        double sr = 0, si = 0;
        for (int k = 0; k < (int)ACQ_N; k++) {
            int c = code[(int)((k + 0.5) * L / ACQ_N)];
            double w = -2 * PI * (double)((n * (long)k) % ACQ_N) / ACQ_N;
            sr += c * cos(w); si += c * sin(w);
        }
        rr[n] = sr; ri[n] = si;
        if (fabs(sr) > mx) mx = fabs(sr);
        if (fabs(si) > mx) mx = fabs(si);
    }
    for (int n = 0; n < (int)ACQ_N; n++) {
        int a = (int)lround(rr[n] * 255 / mx), b = (int)lround(ri[n] * 255 / mx);
        R_rep[n] = ((uint32_t)a & 511u) | ((uint32_t)b & 511u) << 9;
    }
}

static uint32_t scale(unsigned fm, unsigned im, unsigned psh, unsigned csh)
{
    return fm | im << 11 | psh << 22 | csh << 27;
}
static uint32_t ctrl(int start, int at, int stop, int ng, int ch)
{
    return (uint32_t)start | (uint32_t)at << 1 | (uint32_t)stop << 2 | (uint32_t)ng << 4 | (uint32_t)ch << 8;
}
/* номер отсчёта, после которого запуск заведомо обработан */
static int run_end(int start, int K, int ns, int nper, int ng)
{
    return start + (K - 1) * nper + ns + (int)ACQ_PROC_CLK(ng) / 4 + 64;
}

/* сценарий; s — номер текущего отсчёта */
static void scenario(void)
{
    static const uint32_t m1[7] = {0, 1, 2047, 1024, 513, 1500, 0x12345807u};
    static const uint32_t d1[7] = {0, 0x00123456u, 0xFFF00000u, 0x7FFFFFFFu, 0x80000000u,
                                   0x00100000u, 0x12345678u};
    int s = 0, e;

    /* 1. K = 3, 7 гипотез, пуск с отсчёта T, масштаб драйвера; R — копия кода */
    for (int k = 0; k < (int)ACQ_N; k++) wr(R_ACQ_MEM + (uint32_t)k, R_rep[k] | (rnd() & 0xFFFC0000u));
    wr(R_ACQ_DPHI, (uint32_t)llround(FSIG / FS * 4294967296.0));
    wr(R_ACQ_K, 0x10003u);
    wr(R_ACQ_NS, 0xFFFE5DC0u);           /* 24000 */
    wr(R_ACQ_NPER, 48000);
    wr(R_ACQ_SCALE, scale(0x7C0, 0x6AA, 14, 1) | 0xE0000000u);
    wr(R_ACQ_T, ACQ_BASE + 1000);
    for (int g = 0; g < 7; g++) { wr(R_ACQ_M(g), m1[g]); wr(R_ACQ_DSH(g), d1[g]); }
    wr(R_ACQ_CTRL, ctrl(1, 1, 0, 7, 2) | 0x0000F888u);
    dump(1 | 4 | 8);
    runto(50000); dump(4 | 8);
    e = run_end(1000, 3, 24000, 48000, 7);
    runto(e); dump(15);
    s = e;

    /* 2. останов во время захвата первого периода */
    wr(R_ACQ_K, 100);
    wr(R_ACQ_CTRL, ctrl(1, 0, 0, 7, 2));
    runto(s + 10000); dump(4 | 8);
    wr(R_ACQ_CTRL, ctrl(1, 0, 1, 0, 0));
    dump(1 | 8);
    s += 10000;

    /* 3. без масштабирования (насыщение), R — случайная (в т. ч. −256), канал 5 */
    for (int k = 0; k < (int)ACQ_N; k++) wr(R_ACQ_MEM + (uint32_t)k, rnd());
    wr(R_ACQ_K, 4); wr(R_ACQ_NS, 5000); wr(R_ACQ_NPER, 5800); wr(R_ACQ_SCALE, 0);
    wr(R_ACQ_DPHI, rnd()); wr(R_ACQ_M(0), 77); wr(R_ACQ_DSH(0), 0x00300000u);
    wr(R_ACQ_CTRL, ctrl(1, 0, 0, 1, 5));
    e = run_end(s, 4, 5000, 5800, 1);
    runto(e); dump(1 | 8);
    s = e;

    /* 3b. граница расписания: Ns = 2048 (ячейка на отсчёт), 4·Nper = ACQ_PROC_CLK(1), ng = 0 → 1 */
    wr(R_ACQ_K, 2); wr(R_ACQ_NS, 2048); wr(R_ACQ_NPER, 5736);
    wr(R_ACQ_SCALE, scale(0x555, 0x2AA, 31, 3)); wr(R_ACQ_M(0), 1023); wr(R_ACQ_DSH(0), 0xFFFFFFFFu);
    wr(R_ACQ_CTRL, ctrl(1, 0, 0, 0, 7));
    e = run_end(s, 2, 2048, 5736, 1);
    runto(e); dump(15);
    s = e;

    /* 3c. умеренный масштаб, 2 гипотезы, канал 2 */
    wr(R_ACQ_K, 3); wr(R_ACQ_NS, 2500); wr(R_ACQ_NPER, 9000);
    wr(R_ACQ_SCALE, scale(0x7FF, 0x0FF, 8, 2)); wr(R_ACQ_M(0), 5); wr(R_ACQ_M(1), 2040);
    wr(R_ACQ_DSH(0), 0x00080000u); wr(R_ACQ_DSH(1), 0xFFE00000u);
    wr(R_ACQ_CTRL, ctrl(1, 0, 0, 2, 2));
    e = run_end(s, 3, 2500, 9000, 2);
    runto(e); dump(1 | 8);
    s = e;

    /* 6. K = 1, 3 гипотезы, пуск с отсчёта T */
    wr(R_ACQ_K, 1); wr(R_ACQ_NS, 3000); wr(R_ACQ_NPER, 11500);
    wr(R_ACQ_SCALE, scale(0x3C0, 0x6AA, 12, 1)); wr(R_ACQ_T, ACQ_BASE + (uint32_t)s + 200);
    wr(R_ACQ_M(0), 3); wr(R_ACQ_M(1), 0); wr(R_ACQ_M(2), 2046);
    wr(R_ACQ_CTRL, ctrl(1, 1, 0, 3, 2));
    e = run_end(s + 200, 1, 3000, 11500, 3);
    runto(e); dump(15);
    s = e;

    /* 4. отказ в пуске (расписание) и пуск при занятом ускорителе */
    wr(R_ACQ_NS, 1000); wr(R_ACQ_CTRL, ctrl(1, 0, 0, 7, 1)); dump(1);
    wr(R_ACQ_NS, 24000); wr(R_ACQ_NPER, 24299); wr(R_ACQ_CTRL, ctrl(1, 0, 0, 1, 1)); dump(4);
    wr(R_ACQ_NPER, 24300); wr(R_ACQ_CTRL, ctrl(1, 0, 0, 7, 1)); dump(4);
    wr(R_ACQ_CTRL, ctrl(1, 1, 0, 2, 6)); dump(4);
    runto(s + 100); dump(4 | 8);
    wr(R_ACQ_CTRL, ctrl(0, 0, 1, 0, 0)); dump(4);
    wr(R_ACQ_NS, 2048); wr(R_ACQ_NPER, 5735); wr(R_ACQ_CTRL, ctrl(1, 0, 0, 1, 0)); dump(4);
    wr(R_ACQ_NPER, 22943 / 4 + 1); wr(R_ACQ_CTRL, ctrl(1, 0, 0, 0, 0)); dump(4);
    wr(R_ACQ_CTRL, ctrl(0, 0, 1, 0, 0)); dump(4);
    s += 100;

    /* 5. снимок в общем пуле */
    uint32_t wa[64];
    for (int i = 0; i < 64; i++) { wa[i] = (i < 8) ? (uint32_t)(i << 10) | (rnd() & 1023u) : rnd() & 0x1FFFu; op(4, wa[i], rnd()); }
    for (int i = 0; i < 64; i++) op(5, wa[i], 0);
    dump(2 | 8);
    op(0, 0, 0);
}

/* ------------------------------------------------------------ эталон */
static void expect(FILE *f)
{
    static acqf_t M;
    int si = 0, nd = 0;
    acqf_reset(&M);
    for (int p = 0; p < ncmd; p += 3) {
        uint32_t o = cmd[1 + p], a = cmd[2 + p], d = cmd[3 + p];
        switch (o) {
        case 1: acqf_wr(&M, a, d); break;
        case 2: for (; si < (int)a; si++) nd += acqf_sample(&M, ACQ_BASE + (uint32_t)si, smp[1 + si]); break;
        case 3:
            if (a & 1) for (uint32_t r = 0x60; r < 0x88; r++) fprintf(f, "R %02x %08x\n", r, acqf_rd(&M, r));
            if (a & 2) for (uint32_t r = 0; r < 0x4000; r++) fprintf(f, "P %04x %05x\n", r, acqf_rd(&M, R_ACQ_MEM + r) & 0x3FFFFu);
            if (a & 4) fprintf(f, "C %08x\n", acqf_rd(&M, R_ACQ_CTRL));
            if (a & 8) fprintf(f, "D %d\n", nd);
            break;
        case 4: acqf_snap_wr(&M, a & 0x1FFFu, d); break;
        case 5: fprintf(f, "S %04x %08x\n", a & 0x1FFFu, acqf_snap_rd(&M, a & 0x1FFFu)); break;
        default: return;
        }
    }
}

static void sanity(void)
{
    /* сценарий 1 отдельно: пик гипотезы 0 против задержки сигнала */
    static acqf_t M;
    acqf_reset(&M);
    for (int k = 0; k < (int)ACQ_N; k++) acqf_wr(&M, R_ACQ_MEM + (uint32_t)k, R_rep[k]);
    acqf_wr(&M, R_ACQ_DPHI, (uint32_t)llround(FSIG / FS * 4294967296.0));
    acqf_wr(&M, R_ACQ_K, 3); acqf_wr(&M, R_ACQ_NS, 24000); acqf_wr(&M, R_ACQ_NPER, 48000);
    acqf_wr(&M, R_ACQ_SCALE, scale(0x7C0, 0x6AA, 14, 1));
    acqf_wr(&M, R_ACQ_CTRL, ctrl(1, 0, 0, 1, 2));
    for (int i = 0; i < 3 * 48000 && M.busy; i++) acqf_sample(&M, (uint32_t)i, smp[1 + i]);
    uint32_t pk = acqf_rd(&M, R_ACQ_PEAK(0)), sm = acqf_rd(&M, R_ACQ_SUM(0));
    unsigned bk = pk >> 18;
    double cp = fmod((ACQ_N - bk) * (double)L / ACQ_N, L), mean = sm / (double)ACQ_N;
    printf("gen_acq: контроль — пик %u (среднее %.1f, %.1f раза) в ячейке %u: задержка %.1f чипа (задано %.1f)\n",
           pk & 0x3FFFFu, mean, (pk & 0x3FFFFu) / mean, bk, cp, D0);
}

static int gen(void)
{
    /* таблица поворотов T[q] = round(65536·cos(2πq/2048)), q = 0..512 */
    FILE *f = fopen("rtl/acq_tw.hex", "w");
    if (!f) { perror("rtl/acq_tw.hex"); return 1; }
    for (int q = 0; q < 1024; q++)
        fprintf(f, "%05x\n", q <= 512 ? (unsigned)lround(65536.0 * cos(2 * PI * q / ACQ_N)) : 0u);
    fclose(f);

    for (int i = 0; i < L; i++) code[i] = (rnd() & 1) ? 1 : -1;
    gen_ref();
    scenario();
    if (nsmp >= SMAX - 1) { fprintf(stderr, "gen_acq: переполнен буфер отсчётов\n"); return 2; }
    gen_samples(nsmp);
    memmove(smp + 1, smp, sizeof(uint32_t) * (size_t)nsmp);
    smp[0] = (uint32_t)nsmp;
    cmd[0] = (uint32_t)ncmd;

    f = fopen("tb/stim/acq_cmd.hex", "w");
    if (!f) { perror("tb/stim/acq_cmd.hex"); return 1; }
    for (int i = 0; i <= ncmd; i++) fprintf(f, "%08x\n", cmd[i]);
    fclose(f);
    f = fopen("tb/stim/acq_smp.hex", "w");
    if (!f) { perror("tb/stim/acq_smp.hex"); return 1; }
    for (int i = 0; i <= nsmp; i++) fprintf(f, "%08x\n", smp[i]);
    fclose(f);
    f = fopen("tb/out/acq_exp.txt", "w");
    if (!f) { perror("tb/out/acq_exp.txt"); return 1; }
    expect(f);
    fclose(f);
    printf("gen_acq: команд %d, отсчётов %d\n", ncmd / 3, nsmp);
    sanity();
    return 0;
}

static int check(void)
{
    FILE *fa = fopen("tb/out/acq_exp.txt", "r"), *fb = fopen("tb/out/acq_rtl.txt", "r");
    if (!fa || !fb) { fprintf(stderr, "gen_acq: нет tb/out/acq_exp.txt или acq_rtl.txt\n"); return 1; }
    char la[128], lb[128];
    int n = 0, bad = 0;
    for (;;) {
        char *pa = fgets(la, sizeof la, fa), *pb = fgets(lb, sizeof lb, fb);
        if (!pa && !pb) break;
        n++;
        if (!pa || !pb || strcmp(la, lb)) {
            if (bad < 20) printf("строка %d: ожидалось «%.*s», RTL «%.*s»\n", n,
                                 pa ? (int)strcspn(la, "\n") : 0, pa ? la : "",
                                 pb ? (int)strcspn(lb, "\n") : 0, pb ? lb : "");
            bad++;
            if (!pa || !pb) break;
        }
    }
    fclose(fa); fclose(fb);
    printf("ускоритель захвата: строк %d, расхождений %d — %s\n", n, bad, bad ? "FAIL" : "PASS");
    return bad ? 1 : 0;
}

int main(int argc, char **argv)
{
    if (argc > 1 && !strcmp(argv[1], "gen")) return gen();
    if (argc > 1 && !strcmp(argv[1], "check")) return check();
    fprintf(stderr, "запуск: gen_acq gen | check\n");
    return 2;
}
