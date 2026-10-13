/* Формирование выходных сообщений для внешней проверки (tests/check_output.py — pyrtcm, pynmeagps,
 * декодер собственного протокола на struct): RTCM 3.3 MSM7 (1077, 1087, 1097, 1127), 1005;
 * NMEA GGA, RMC, GSA, GSV, GST, ZDA; двоичный протокол (решение, измерения, эфемериды, каналы, ИТМ).
 * Здесь же — разбор кадров двоичного протокола (mbp_parse), в том числе с повреждённым байтом. */
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "gnss.h"
#include "rtcm3.h"
#include "nmea.h"
#include "pvt.h"
#include "proto.h"

int main(void)
{
    FILE *fb = fopen("build/out.rtcm", "wb"), *ft = fopen("build/out_ref.txt", "w"), *fn = fopen("build/out.nmea", "wb");
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
    /* двоичный протокол */
    static uint8_t mb[8192];
    int mn = 0;
    s.t_rx = 345600.5; s.nsys = 2; s.ok = 1; s.tdop = 0.71;
    s.pos[0] = 2849547.796; s.pos[1] = 2195818.206; s.pos[2] = 5249314.274;
    s.clk[0] = 1234.5; s.clk[1] = 1240.25; s.clkd = -3.5;
    mn += mbp_pvt(mb + mn, week, &s);
    mbp_meas_t mm[3];
    for (int j = 0; j < 3; j++) {
        memset(&mm[j], 0, sizeof(mm[j]));
        mm[j].sys = j == 2 ? SYS_GLO : SYS_GPS; mm[j].prn = (uint8_t)(5 + j); mm[j].sig = j == 2 ? SIG_G1CA : SIG_L1CA;
        mm[j].fcn = (int8_t)(j == 2 ? -3 : 0); mm[j].pr = 2.1e7 + 1e5 * j; mm[j].cp = 1.1e8 + 0.25 * j;
        mm[j].dop = -1234.5f + j; mm[j].cn0 = 41.25f + j; mm[j].lock = 12.5f * j; mm[j].flags = (uint8_t)(j & 1);
        fprintf(ft, "M %d %d %d %d %.3f %.3f %.3f %.2f %.3f %d\n", mm[j].sys, mm[j].prn, mm[j].sig, mm[j].fcn, mm[j].pr,
                mm[j].cp, mm[j].dop, mm[j].cn0, mm[j].lock, mm[j].flags);
    }
    mn += mbp_meas(mb + mn, week, tow, mm, 3);
    eph_t eg;
    memset(&eg, 0, sizeof(eg));
    eg.sys = SYS_GPS; eg.prn = 7; eg.week = week; eg.iode = 33; eg.toc = eg.toe = 345600; eg.sqrtA = 5153.7;
    eg.e = 0.0123; eg.M0 = 1.1; eg.af0 = 1.5e-5;
    mn += mbp_eph(mb + mn, &eg);
    eph_t er;
    memset(&er, 0, sizeof(er));
    er.sys = SYS_GLO; er.prn = 11; er.fcn = -3; er.toc = er.toe = 345618; er.pos[0] = 1.2e7; er.vel[1] = 3100.5;
    er.taun = -2.5e-5; er.gamn = 1.8e-12;
    mn += mbp_eph(mb + mn, &er);
    mbp_ch_t cc[2] = {{3, SIG_L1CA, 7, 2, 0, 0x3, 44.5f, -1500.25f}, {17, SIG_G1CA, 11, 2, -3, 0x9, 39.75f, 812.5f}};
    mn += mbp_ch(mb + mn, cc, 2);
    mbp_tm_t tm = {48.5f, 31.25f, 1, 0xFF, 0x02, 0x00, 5010, 3600, 1, 1};
    mn += mbp_tm(mb + mn, &tm);
    FILE *fm = fopen("build/out.mbp", "wb");
    fwrite(mb, 1, (size_t)mn, fm);
    fclose(fm);
    /* разбор потока: все кадры; затем с повреждённым байтом — кадр отбрасывается, следующие находятся */
    int ok = 1, nfr = 0, cls, id, plen, used;
    const uint8_t *pl;
    for (int i = 0; i < mn;) {
        int r = mbp_parse(mb + i, mn - i, &cls, &id, &pl, &plen, &used);
        if (r <= 0) { ok = 0; break; }
        nfr++; i += used;
    }
    mb[20] ^= 0x10;                                   /* данные первого кадра */
    int ngood = 0, nskip = 0;
    for (int i = 0; i < mn;) {
        int r = mbp_parse(mb + i, mn - i, &cls, &id, &pl, &plen, &used);
        if (r == 0) break;
        if (r < 0) nskip++; else ngood++;
        i += used;
    }
    printf("двоичный протокол: кадров %d, разобрано %d; с повреждённым байтом — верных %d (пропусков %d)\n",
           6, nfr, ngood, nskip);
    if (nfr != 6 || ngood != 5) ok = 0;
    fclose(fb); fclose(ft); fclose(fn);
    printf("сформированы build/out.rtcm, build/out.nmea, build/out.mbp\n");
    return !ok;
}
