/* Проверка декодера BeiDou D1 (B1I, КА MEO/IGSO): BCH(15,11) — сверка с независимым
 * кодером на сдвиговом регистре и исправление всех одиночных ошибок; кодирование кадров
 * (подкадры 1–3 по эфемеридам RINEX, 4–5 — псевдослучайные) в поток бит с произвольным
 * началом, инверсией полярности, одиночными и двойными ошибками в словах и искажением
 * синхрокомбинации; декодирование, сверка полей, координат КА, ионосферы и привязки ко времени. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "gnss.h"
#include "eph.h"
#include "rinex.h"
#include "bdsnav.h"

#define RNX "../../sim/data/BRDC00IGS_R_20211700000_01D_MN_subset.rnx"
#define NSF 20                                   /* подкадров (четыре кадра по 30 с) */
static eph_t EPH[8000];
static uint8_t BIT[NSF * 300];
/* коды ионосферы в кодере (bdsnav.c) и их масштабы */
static const int ION_SIM[8] = {12, 2, -10, 3, 70, 10, -3, -2};
static const int ION_SC[8] = {-30, -27, -24, -24, 11, 14, 16, 16};

/* систематический кодер BCH(15,11) на сдвиговом регистре (ИКД, рис. 5-3) */
static uint32_t bch_lfsr(uint32_t info)
{
    uint32_t r = 0;
    for (int i = 10; i >= 0; i--) {
        uint32_t fb = ((info >> i) & 1) ^ (r >> 3 & 1);
        r = (r << 1) & 0xF;
        if (fb) r ^= 0x3;                                /* g(x) = x⁴ + x + 1 */
    }
    return (info << 4) | r;
}

/* бит i кодового слова A (c = 0) или B (c = 1) слова j (1–9) подкадра — в позиции линии */
static int pos(int j, int c, int i) { return 30 * j + 2 * i + c; }

/* искажения подкадра k прогона run; возвращает число искажённых кодовых слов BCH и
 * признак искажения синхрокомбинации (*pre) */
static int corrupt(uint8_t *w, int run, int k, int *pre)
{
    int nw = 0;
    *pre = 0;
    if (run == 1 && k < 10 && k % 5 < 3) {               /* кадры 0, 1: по ошибке в каждом слове */
        for (int j = 1; j < 10; j++) {
            w[pos(j, 0, (j + k) % 15)] ^= 1;
            w[pos(j, 1, (2 * j + k) % 15)] ^= 1;
            nw += 2;
        }
    } else if (run == 2 && k == 1) {                     /* кадр 0: двойная ошибка в слове 5 */
        w[pos(4, 0, 3)] ^= 1;
        w[pos(4, 0, 9)] ^= 1;
        nw++;
    } else if (run == 3 && k < 5 && k % 5 < 3) {         /* кадр 0: одиночная ошибка */
        w[pos(5, 0, (3 * k) % 15)] ^= 1;
        nw++;
    } else if (run >= 4) {
        if ((run == 4 && k == 7) || (run == 5 && k == 8)) {
            /* три ошибки синхрокомбинации — пропуск подкадра; одна — допустима */
            w[0] ^= 1;
            if (run == 4) { w[3] ^= 1; w[5] ^= 1; *pre = 1; return 0; }
        }
        for (int j = 0; j < 10; j++)
            for (int c = 0; c < 2; c++) {
                if (j == 0 && c) continue;               /* слово 1: одно кодовое слово (биты 15–29) */
                if (rand() & 1) continue;
                int i = rand() % 15;
                w[j ? pos(j, c, i) : 15 + i] ^= 1;
                nw++;
            }
    }
    return nw;
}

int main(void)
{
    int ok = 1;
    /* BCH(15,11): все 2048 информационных слов, все одиночные ошибки */
    int bch_bad = 0;
    for (uint32_t i = 0; i < 2048; i++) {
        uint32_t c = bdsnav_bch_enc(i);
        int ne = 0;
        if (c != bch_lfsr(i) || bdsnav_bch_dec(c, &ne) != c || ne) bch_bad++;
        for (int k = 0; k < 15; k++) {
            ne = 0;
            if (bdsnav_bch_dec(c ^ (1u << k), &ne) != c || ne != 1) bch_bad++;
        }
    }
    printf("  BCH(15,11): 2048 слов, кодер сверен с регистровым, одиночные ошибки исправлены: %s\n",
           bch_bad ? "НЕТ" : "да");
    if (bch_bad) ok = 0;

    /* кадр с эфемеридами, ожидаемый для прогона (см. corrupt) */
    static const int EPH_FRAME[6] = {0, 1, 1, 1, 2, 1};
    int ne = rinex_read_nav(RNX, EPH, 8000), ntest = 0, seen[64] = {0};
    for (int i = 0; i < ne && ntest < 6; i++) {
        eph_t e = EPH[i];
        if (e.sys != SYS_BDS || e.prn < 6 || e.prn > 58 || e.prn % 3 || seen[e.prn]) continue;
        seen[e.prn] = 1;
        e.iode &= 31;
        e.iodc &= 31;
        e.sva &= 15;
        e.svh &= 1;
        e.tgd = round(e.tgd / 0.1e-9) * 0.1e-9;
        int run = ntest, pol = run & 1;
        int toe_bdt = (int)fmod(e.toe - GPST_BDT + 604800, 604800), sow0 = toe_bdt / 30 * 30 + 60;
        int nw = 0, npre = 0;
        srand((unsigned)e.prn * 7 + 1);
        for (int k = 0; k < NSF; k++) {
            int pre;
            bdsnav_encode(&e, k % 5 + 1, (sow0 + 6 * k) % 604800, BIT + 300 * k);
            int n = corrupt(BIT + 300 * k, run, k, &pre);
            nw += n;
            npre += pre;
        }
        bdsnav_t b;
        bdsnav_init(&b, e.prn);
        int off = 137 + 41 * run, got = 0, terr = 0, eph_k = -1;
        uint64_t n = 0;
        for (int k = 0; k < off; k++) bdsnav_bit(&b, rand() & 1, n++);          /* мусор до начала */
        for (int k = 0; k < NSF * 300; k++) {
            int id = bdsnav_bit(&b, BIT[k] ^ pol, n++);
            if (b.eph_new && eph_k < 0) eph_k = k;
            if (!id) continue;
            got++;
            /* подкадр завершён на бите k: k + 1 — начало следующего */
            int sf = (k + 1) / 300 - 1;
            double tow = fmod((sow0 + 6.0 * (sf + 1)) + GPST_BDT, 604800);
            if ((k + 1) % 300 || id != sf % 5 + 1 || fabs(b.sf_end_tow - tow) > 1e-9 ||
                b.sf_end_n != (uint64_t)(off + k)) terr++;
        }
        double r0[3], r1[3], d0, d1, t = e.toe + 300;
        eph_t d = b.eph;
        int full = b.eph_new && eph_satpos(&e, t, r0, &d0, NULL, NULL) && eph_satpos(&d, t, r1, &d1, NULL, NULL);
        double dr = full ? sqrt((r0[0] - r1[0]) * (r0[0] - r1[0]) + (r0[1] - r1[1]) * (r0[1] - r1[1]) +
                                (r0[2] - r1[2]) * (r0[2] - r1[2])) : 1e9;
        int fld = full && d.sys == SYS_BDS && d.prn == e.prn && d.week == e.week && d.iode == e.iode &&
                  d.iodc == e.iodc && d.svh == e.svh && d.sva == e.sva && fabs(d.tgd - e.tgd) < 1e-12 &&
                  fabs(d.toe - e.toe) < 1e-9 && fabs(d.toc - e.toc) < 1e-9;
        int ion = b.ion_ok;
        for (int k = 0; k < 8; k++) if (b.ion[k] != ldexp(ION_SIM[k], ION_SC[k])) ion = 0;
        int eph_f = eph_k < 0 ? -1 : eph_k / 1500;
        printf("  C%02d: полярность %s, подкадров с привязкой %d, исправлений BCH %d (искажено слов %d), "
               "ошибок SOW %d, привязка %s, эфемериды %s (кадр %d), неделя %d, ионосфера %s, "
               "расхождение координат %.4f м, часов %.2e с\n", e.prn, b.pol ? "инв." : "прям.", got,
               b.n_corr, nw, b.n_sow_err, terr ? "ОШИБКА" : "верна", fld ? "да" : "НЕТ", eph_f, b.week,
               ion ? "да" : "НЕТ", dr, full ? fabs(d0 - d1) : 0.0);
        if (got != NSF - 1 - npre || terr || b.n_sow_err || !fld || !ion || dr > 0.05 || fabs(d0 - d1) > 1e-10 ||
            b.pol != pol || eph_f != EPH_FRAME[run] || b.n_corr != nw) ok = 0;
        ntest++;
    }
    if (ntest < 6) ok = 0;
    printf("ИТОГ: %s\n", ok ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    return !ok;
}
