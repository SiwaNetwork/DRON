/* Проверка эфемерид и навигационного решения: координаты КА по RINEX (сверка с sim/gnss_orbits.py),
 * решение по псевдодальностям GPS+ГЛОНАСС+Galileo+BeiDou для известной точки (без шума и с шумом 1 м). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "gnss.h"
#include "eph.h"
#include "rinex.h"
#include "pvt.h"

#define RNX "../../sim/data/BRDC00IGS_R_20211700000_01D_MN_subset.rnx"
static eph_t EPH[8000];

static double gauss(void)
{
    double u1 = (rand() + 1.0) / (RAND_MAX + 2.0), u2 = (rand() + 1.0) / (RAND_MAX + 2.0);
    return sqrt(-2 * log(u1)) * cos(2 * GPI * u2);
}

int main(void)
{
    int ne = rinex_read_nav(RNX, EPH, 8000), ok = 1;
    printf("RINEX: эфемерид %d\n", ne);
    /* 1. координаты КА */
    FILE *fp = fopen("tests/vectors/satpos.txt", "r");
    int sys, prn, n = 0;
    double t, x, y, z, dts, maxd[SYS_N] = {0}, maxc = 0;
    while (fscanf(fp, "%d %d %lf %lf %lf %lf %lf", &sys, &prn, &t, &x, &y, &z, &dts) == 7) {
        const eph_t *e = eph_select(EPH, ne, sys, prn, t);
        double rs[3], d;
        if (!e || !eph_satpos(e, t, rs, &d, NULL, NULL)) { printf("  нет эфемерид %d/%d\n", sys, prn); ok = 0; continue; }
        double er = sqrt((rs[0] - x) * (rs[0] - x) + (rs[1] - y) * (rs[1] - y) + (rs[2] - z) * (rs[2] - z));
        if (er > maxd[sys]) maxd[sys] = er;
        if (fabs(d - dts) > maxc) maxc = fabs(d - dts);
        n++;
    }
    fclose(fp);
    const char *nm[] = {"GPS", "ГЛОНАСС", "Galileo", "BeiDou", "QZSS"};
    printf("Координаты КА: %d точек; макс. расхождение с эталоном:", n);
    for (int s = 0; s < 5; s++) printf(" %s %.2e м;", nm[s], maxd[s]);
    printf(" часы %.1e с\n", maxc);
    for (int s = 0; s < 5; s++) if (maxd[s] > 1e-3) ok = 0;
    if (maxc > 1e-12) ok = 0;
    /* 2. навигационное решение */
    fp = fopen("tests/vectors/pvt.txt", "r");
    char tag[8];
    double rx[3] = {0}, trx = 0, bias[SYS_N] = {0};
    obs_t obs[PVT_MAXOBS];
    int no = 0;
    while (fscanf(fp, "%7s", tag) == 1) {
        if (!strcmp(tag, "RX")) { if (fscanf(fp, "%lf %lf %lf %lf", &rx[0], &rx[1], &rx[2], &trx) != 4) return 1; }
        else if (!strcmp(tag, "BIAS")) { int s; double b; if (fscanf(fp, "%d %lf", &s, &b) != 2) return 1; bias[s] = b; }
        else {
            double pr, el;
            if (fscanf(fp, "%d %d %lf %lf", &sys, &prn, &pr, &el) != 4) return 1;
            memset(&obs[no], 0, sizeof(obs[no]));
            obs[no].sys = sys; obs[no].prn = prn; obs[no].pr = pr;
            obs[no].eph = eph_select(EPH, ne, sys, prn, trx);
            obs[no].fc = sig_carrier(SIG_L1CA, 0);
            no++;
        }
    }
    fclose(fp);
    pvt_cfg_t cfg;
    pvt_default_cfg(&cfg);
    cfg.trop = cfg.iono = 0;
    for (int pass = 0; pass < 2; pass++) {
        obs_t o2[PVT_MAXOBS];
        memcpy(o2, obs, sizeof(obs_t) * no);
        if (pass) { srand(7); for (int i = 0; i < no; i++) o2[i].pr += gauss(); }
        sol_t sol;
        memset(&sol, 0, sizeof(sol));
        double t_clock = trx + bias[SYS_GPS] / CLIGHT;
        if (!pvt_solve(o2, no, t_clock, &cfg, &sol)) { printf("решение не получено\n"); return 1; }
        double d[3] = {sol.pos[0] - rx[0], sol.pos[1] - rx[1], sol.pos[2] - rx[2]};
        double err = sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
        printf("Решение %s: КА %d, систем %d, ошибка %.4f м, СКО невязок %.3f м, GDOP %.2f PDOP %.2f HDOP %.2f VDOP %.2f\n",
               pass ? "с шумом 1 м" : "без шума", sol.nsat, sol.nsys, err, sol.rms, sol.gdop, sol.pdop, sol.hdop, sol.vdop);
        printf("  широта %.7f°, долгота %.7f°, высота %.3f м; смещения шкал (м): GPS %.3f, ГЛОНАСС %+.3f, Galileo %+.3f, BeiDou %+.3f "
               "(отн. GPS; ист. +25, −7, +13); ошибка времени %.2e с\n",
               sol.lat * 180 / GPI, sol.lon * 180 / GPI, sol.h, sol.clk[0], sol.clk[1] - sol.clk[0], sol.clk[2] - sol.clk[0],
               sol.clk[3] - sol.clk[0], sol.t_rx - trx);
        if (!pass && (err > 0.01 || fabs(sol.clk[0] - bias[0]) > 0.01 || fabs(sol.t_rx - trx) > 1e-10)) ok = 0;
        if (pass && err > 5 * sol.pdop) ok = 0;
    }
    printf("ИТОГ: %s\n", ok ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    return !ok;
}
