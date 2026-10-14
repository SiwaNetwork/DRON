/* Проверка декодера Galileo I/NAV (E1-B): кодирование подкадров (15 страниц, слова 0–6 по
 * эфемеридам RINEX, прочие — псевдослучайные) в символы, мягкие значения с шумом, произвольным
 * началом и инверсией полярности; декодирование, сверка полей, координат КА и привязки ко
 * времени. CRC-24Q сверяется с независимой байтовой реализацией RTCM 3. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "gnss.h"
#include "eph.h"
#include "rinex.h"
#include "rtcm3.h"
#include "inav.h"

#define RNX "../../sim/data/BRDC00IGS_R_20211700000_01D_MN_subset.rnx"
#define NPG 30                                   /* страниц (два подкадра по 30 с) */
static eph_t EPH[8000];
static uint8_t SYM[NPG * 500];
/* слова номинального подкадра E1-B (Galileo OS SIS ICD, табл. 41) */
static const int WT[15] = {2, 4, 6, 7, 8, 17, 19, 16, 0, 0, 1, 3, 5, 0, 16};

static double gauss(void)
{
    double u1 = (rand() + 1.0) / (RAND_MAX + 2.0), u2 = (rand() + 1.0) / (RAND_MAX + 2.0);
    return sqrt(-2 * log(u1)) * cos(2 * GPI * u2);
}

int main(void)
{
    int ok = 1;
    /* CRC-24Q: побитовая (I/NAV) и байтовая (RTCM 3) на 25 байтах */
    uint8_t b[25];
    srand(7);
    for (int i = 0; i < 25; i++) b[i] = (uint8_t)rand();
    uint32_t c1 = inav_crc24q(b, 200), c2 = rtcm_crc24q(b, 25);
    printf("  CRC-24Q: %06X / %06X\n", c1, c2);
    if (c1 != c2) ok = 0;

    int ne = rinex_read_nav(RNX, EPH, 8000), ntest = 0, seen[40] = {0};
    for (int i = 0; i < ne && ntest < 6; i++) {
        eph_t e = EPH[i];
        if (e.sys != SYS_GAL || e.prn % 3 != 1 || seen[e.prn]) continue;
        seen[e.prn] = 1;
        e.iode &= 0x3FF;
        e.sva &= 0xFF;
        e.svh &= 0x1C7;                                   /* разряды E1-B и E5b */
        int pol = ntest & 1, tow0 = (int)(e.toe / 30) * 30;
        double esn0 = ntest < 4 ? 3.0 : 0.0;             /* дБ на символ */
        double sig = pow(10, -esn0 / 20) / sqrt(2.0);
        for (int p = 0; p < NPG; p++) inav_encode_page(&e, WT[p % 15], tow0 + 2 * p, e.week, SYM + 500 * p);
        inav_t g;
        inav_init(&g, e.prn);
        srand((unsigned)e.prn);
        int off = 137 + 50 * ntest, got = 0, ntow = 0, terr = 0;
        for (int k = 0; k < 300; k++) inav_sym(&g, gauss(), (uint64_t)k);       /* шум до начала */
        for (int k = off; k < NPG * 500; k++) {
            double v = (SYM[k] ? -1.0 : 1.0) * (pol ? -1.0 : 1.0) + sig * gauss();
            if (inav_sym(&g, v, (uint64_t)k)) {
                got++;
                /* страница завершена на символе k: k + 1 — начало следующей */
                double tow = tow0 + (k + 1) / 500 * 2.0;
                if ((k + 1) % 500) terr++;
                if (g.tow_ok && (ntow++, fabs(g.page_tow + 2 - tow) > 1e-9)) terr++;
            }
        }
        double r0[3], r1[3], d0, d1, t = e.toe + 300;
        eph_t d = g.eph;
        int full = g.eph_new && eph_satpos(&e, t, r0, &d0, NULL, NULL) && eph_satpos(&d, t, r1, &d1, NULL, NULL);
        double dr = full ? sqrt((r0[0] - r1[0]) * (r0[0] - r1[0]) + (r0[1] - r1[1]) * (r0[1] - r1[1]) +
                                (r0[2] - r1[2]) * (r0[2] - r1[2])) : 1e9;
        int fld = full && d.sys == SYS_GAL && d.prn == e.prn && d.week == e.week && d.iode == e.iode &&
                  d.svh == e.svh && d.sva == e.sva && fabs(d.tgd - e.tgd) < 2.4e-10 &&
                  fabs(d.tgd2 - e.tgd2) < 2.4e-10 &&
                  fabs(d.toe - e.toe) < 1e-9 && fabs(d.toc - e.toc) < 1e-9;
        printf("  E%02d: Es/N0 %.0f дБ, полярность %s, страниц %d (с TOW %d), ошибок CRC %d, привязка %s, эфемериды %s, "
               "неделя %d, ai0 %.2f, расхождение координат %.4f м, часов %.2e с\n", e.prn, esn0,
               g.pol ? "инв." : "прям.", got, ntow, g.n_crc_err, terr ? "ОШИБКА" : "верна", fld ? "да" : "НЕТ",
               g.week, g.ai[0], dr, full ? fabs(d0 - d1) : 0.0);
        /* при 0 дБ (C/N0 24 дБ·Гц) допускается одиночная ошибка CRC */
        if (got < NPG - 4 || ntow < got - 4 || g.n_crc_err > (esn0 > 1 ? 0 : 1) || terr || !fld || dr > 0.05 || fabs(d0 - d1) > 1e-10 ||
            g.pol != pol || !g.ai_ok || !g.utc_ok || g.dt_ls != (int)GPST_UTC) ok = 0;
        ntest++;
    }
    if (ntest < 6) ok = 0;
    printf("ИТОГ: %s\n", ok ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    return !ok;
}
