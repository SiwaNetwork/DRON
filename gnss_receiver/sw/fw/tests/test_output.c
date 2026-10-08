/* Формирование выходных сообщений для внешней проверки (tests/check_output.py — pyrtcm, pynmeagps):
 * RTCM 3.3 MSM7 (1077, 1087, 1097, 1127), 1005; NMEA GGA, RMC, GSA, GSV, GST, ZDA. */
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "gnss.h"
#include "rtcm3.h"
#include "nmea.h"
#include "pvt.h"

int main(void)
{
    FILE *fb = fopen("build/out.rtcm", "wb"), *ft = fopen("build/out_ref.txt", "w"), *fn = fopen("build/out.nmea", "w");
    uint8_t buf[1200];
    msm_obs_t o[8];
    const int sys[4] = {SYS_GPS, SYS_GLO, SYS_GAL, SYS_BDS};
    const double lam[4] = {CLIGHT / 1575.42e6, CLIGHT / 1602e6, CLIGHT / 1575.42e6, CLIGHT / 1561.098e6};
    for (int k = 0; k < 4; k++) {
        int n = 5;
        for (int j = 0; j < n; j++) {
            memset(&o[j], 0, sizeof(o[j]));
            o[j].prn = 3 + 4 * j + k; o[j].sig = 2; o[j].fcn = (k == 1) ? j - 3 : 0;
            double l = k == 1 ? CLIGHT / (1602e6 + o[j].fcn * 562.5e3) : lam[k];
            o[j].lam = l;
            o[j].pr = 20.0e6 + 1.234567e6 * j + 0.123 * k;
            o[j].cp = o[j].pr / l + 0.37 + j;                /* фаза — с произвольным сдвигом */
            o[j].dop = -1234.5 + 777.25 * j;
            o[j].cn0 = 38.0 + 2.25 * j;
            o[j].lock = 0.5 * (j + 1) * (j + 1);
            fprintf(ft, "%d %d %d %.4f %.4f %.4f %.4f %.2f\n", 1077 + 10 * k + (k == 3 ? 20 : 0), o[j].prn, o[j].fcn,
                    o[j].pr, o[j].cp * l, -o[j].dop * l, o[j].cn0, o[j].lock);
        }
        uint32_t ep = k == 1 ? (uint32_t)((2u << 27) | 43200123u) : 345600123u;
        int len = rtcm_msm7(buf, sys[k], 1234, ep, k < 3, o, n);
        fwrite(buf, 1, (size_t)len, fb);
    }
    double r[3] = {2849547.7960, 2195818.2064, 5249314.2744};
    int len = rtcm_1005(buf, 1234, r);
    fwrite(buf, 1, (size_t)len, fb);
    fprintf(ft, "1005 %.4f %.4f %.4f\n", r[0], r[1], r[2]);
    /* NMEA */
    sol_t s;
    memset(&s, 0, sizeof(s));
    s.ok = 1; s.nsat = 21; s.lat = 55.7558 * GPI / 180; s.lon = 37.6173 * GPI / 180; s.h = 150.25;
    s.hdop = 0.67; s.pdop = 1.28; s.vdop = 1.09; s.rms = 1.1; s.q_e = 0.2; s.q_n = 0.25; s.q_u = 1.2; s.q_en = 0.05;
    double ve = 10, vn = 20;
    s.vel[0] = -sin(s.lon) * ve - sin(s.lat) * cos(s.lon) * vn;
    s.vel[1] = cos(s.lon) * ve - sin(s.lat) * sin(s.lon) * vn;
    s.vel[2] = cos(s.lat) * vn;
    obs_t ob[3];
    memset(ob, 0, sizeof(ob));
    for (int j = 0; j < 3; j++) { ob[j].sys = SYS_GPS; ob[j].prn = 5 + j; ob[j].el = 0.5 + 0.2 * j; ob[j].az = 1.0 * j; ob[j].cn0 = 40 + j; ob[j].used = 1; }
    char nb[2048];
    int week = 2163;
    double tow = 345600.5;
    nmea_gga(nb, &s, week, tow, 18); fputs(nb, fn);
    nmea_rmc(nb, &s, week, tow, 18); fputs(nb, fn);
    int l = nmea_gsa(nb, &s, ob, 3); nb[l] = 0; fputs(nb, fn);
    l = nmea_gsv(nb, ob, 3); nb[l] = 0; fputs(nb, fn);
    nmea_gst(nb, &s, week, tow, 18); fputs(nb, fn);
    nmea_zda(nb, week, tow, 18); fputs(nb, fn);
    fclose(fb); fclose(ft); fclose(fn);
    printf("сформированы build/out.rtcm, build/out.nmea\n");
    return 0;
}
