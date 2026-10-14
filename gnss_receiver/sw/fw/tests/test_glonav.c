/* Проверка навигационного сообщения ГЛОНАСС: кодирование строк по эфемеридам RINEX, поток
 * символов (относительный код, меандр, метка времени, инверсия, шум), синхронизация,
 * проверка Хэмминга, восстановление эфемерид и времени. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "gnss.h"
#include "eph.h"
#include "rinex.h"
#include "glonav.h"

#define RNX "../../sim/data/BRDC00IGS_R_20211700000_01D_MN_subset.rnx"
static eph_t EPH[8000];

int main(void)
{
    int ne = rinex_read_nav(RNX, EPH, 8000), ok = 1, nsat = 0;
    srand(5);
    /* одиночная ошибка обнаруживается */
    uint8_t s[GLO_STR_BITS];
    glo_str_encode(&EPH[0], 6, 0, 1, s);
    int c0 = glo_str_check(s), nbad = 0;
    for (int i = 1; i < GLO_STR_BITS; i++) { s[i] ^= 1; nbad += glo_str_check(s); s[i] ^= 1; }
    printf("Код Хэмминга: верная строка %s, одиночных ошибок не обнаружено %d из 84\n", c0 ? "проходит" : "НЕ проходит", nbad);
    if (!c0 || nbad) ok = 0;
    int used[32] = {0};
    for (int i = 0; i < ne && nsat < 6; i++) {
        const eph_t *e = &EPH[i];
        if (e->sys != SYS_GLO || !e->valid || e->prn >= 32 || used[e->prn]) continue;
        used[e->prn] = 1;
        nsat++;
        EPH[i].tgd2 = ldexp((e->prn % 7) - 3, -29);        /* Δτn (в RINEX 3 нет): −6…+6 · 2^−30 с */
        /* кадр начинается за 20 мин до toc по МДВ; два кадра (60 с) */
        double tod_toc = fmod(e->toc - GPST_UTC + 10800.0 + 7 * 86400.0, 86400.0);
        double tk = fmod(tod_toc - 1200.0 + 86400.0, 86400.0);
        tk = floor(tk / 30.0) * 30.0;
        glonav_t g;
        glonav_init(&g, e->fcn);
        int inv = rand() & 1, nstr = 0, tbad = 0, dbad = 0, ndate = 0;
        uint64_t n = 0;
        for (int f = 0; f < 2; f++)
            for (int m = 1; m <= 15; m++) {
                uint8_t str[GLO_STR_BITS];
                int8_t sym[200];
                glo_str_encode(e, m, tk + 30.0 * f, e->prn, str);
                glo_str_symbols(str, sym);
                for (int k = 0; k < 200; k++) {
                    n += 240000;
                    double v = (inv ? -1 : 1) * sym[k] + 0.3 * ((rand() / (double)RAND_MAX) - 0.5);
                    int r = glonav_sym(&g, v, n - 1);
                    if (r) {
                        nstr++;
                        double tw = fmod(tk + 30.0 * f + 2.0 * m, 86400.0);
                        if (g.str_end_tod >= 0 && fabs(g.str_end_tod - tw) > 1e-9) tbad++;
                        if (g.n4 > 0 && g.na > 0 && g.str_end_tod >= 0) {   /* дата по строке 5 */
                            int wk;
                            double sow = glo_date2gpst(g.n4, g.na, g.str_end_tod, &wk);
                            double tg = glo_tod2gpst(g.str_end_tod, e->toc);
                            ndate++;
                            if (wk != e->week || fabs(sow - tg) > 1e-6) dbad++;
                        }
                    }
                }
            }
        eph_t d = g.eph;
        double tref = e->toc;
        d.toc = d.toe = glo_tod2gpst(d.toc, tref);
        double r1[3], r2[3], t1, t2, t = e->toc + 600;
        eph_satpos(&d, t, r1, &t1, NULL, NULL);
        eph_satpos(e, t, r2, &t2, NULL, NULL);
        double dp = sqrt((r1[0] - r2[0]) * (r1[0] - r2[0]) + (r1[1] - r2[1]) * (r1[1] - r2[1]) + (r1[2] - r2[2]) * (r1[2] - r2[2]));
        printf("  R%02d литера %+d: строк %d (из 30, первая — после синхронизации), инверсия %d, слот %d, "
               "toc %+.0f с, координаты через 10 мин %.2f м, часы %.2f нс, ошибок времени строк %d, "
               "дата (NA %d, N4 %d) неверна %d из %d\n",
               e->prn, e->fcn, nstr, inv, g.slot, d.toc - e->toc, dp, (t1 - t2) * 1e9, tbad, g.na, g.n4, dbad, ndate);
        if (!d.valid || g.slot != e->prn || fabs(d.toc - e->toc) > 1e-6 || dp > 2.0 || fabs(t1 - t2) > 2e-9 || d.tgd2 != e->tgd2 ||
            tbad || nstr < 28 || dbad || ndate < 10) ok = 0;
    }
    if (nsat < 3) ok = 0;
    printf("ИТОГ: %s\n", ok ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    return !ok;
}
