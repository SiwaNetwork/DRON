/* Проверка декодера GPS LNAV: кодирование подкадров 1–5 по эфемеридам RINEX, поток бит
 * с произвольным началом и инверсией полярности, декодирование, сверка полей и координат КА. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "gnss.h"
#include "eph.h"
#include "rinex.h"
#include "lnav.h"

#define RNX "../../sim/data/BRDC00IGS_R_20211700000_01D_MN_subset.rnx"
static eph_t EPH[8000];

int main(void)
{
    int ne = rinex_read_nav(RNX, EPH, 8000), ok = 1, ntest = 0, seen[40] = {0};
    for (int i = 0; i < ne && ntest < 8; i++) {
        eph_t e = EPH[i];
        if (e.sys != SYS_GPS || e.prn % 4 != 1 || seen[e.prn]) continue;
        seen[e.prn] = 1;
        e.iodc = e.iode;                                   /* IODC (мл. 8 бит) = IODE */
        lnav_t l;
        lnav_init(&l, e.prn);
        int pol = ntest & 1, d29 = 0, d30 = 0, got = 0;
        uint64_t n = 0;
        srand((unsigned)e.prn);
        for (int k = 0; k < 137; k++) lnav_bit(&l, (rand() & 1) ^ pol, n++);   /* мусор до начала */
        int tow0 = (int)(e.toe / 6) + 2;
        for (int sf = 0; sf < 10; sf++) {
            uint8_t bits[300];
            int id = sf % 5 + 1;
            lnav_encode(&e, id, (tow0 + sf + 1) % 100800, d29, d30, bits);
            for (int k = 0; k < 300; k++) {
                int r = lnav_bit(&l, bits[k] ^ pol, n++);
                if (r) got++;
            }
            d29 = bits[298]; d30 = bits[299];
        }
        double r0[3], r1[3], c0, c1, t = e.toe + 300;
        eph_t d = l.eph;
        d.toe = fmod(d.toe, 604800);
        int full = l.eph_new && eph_satpos(&e, t, r0, &c0, NULL, NULL) && eph_satpos(&d, t, r1, &c1, NULL, NULL);
        double dr = full ? sqrt((r0[0] - r1[0]) * (r0[0] - r1[0]) + (r0[1] - r1[1]) * (r0[1] - r1[1]) + (r0[2] - r1[2]) * (r0[2] - r1[2])) : 1e9;
        printf("  PRN %2d: полярность %s, подкадров %d, ошибок чётности %d, эфемериды %s, TOW %.0f, "
               "расхождение координат %.4f м, часов %.2e с\n", e.prn, l.pol ? "инв." : "прям.", got, l.n_parity_err,
               l.eph_new ? "да" : "нет", l.sf_end_tow, dr, full ? fabs(c0 - c1) : 0.0);
        if (got < 9 || l.n_parity_err || !l.eph_new || dr > 0.05 || fabs(c0 - c1) > 1e-10 || l.pol != pol) ok = 0;
        ntest++;
    }
    printf("ИТОГ: %s\n", ok ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    return !ok;
}
