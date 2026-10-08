/* МГП-8: сообщения NMEA 0183 версии 4.11 (идентификатор отправителя GN — совмещённое решение). */
#include <math.h>
#include <stdio.h>
#include <string.h>
#include "gnss.h"
#include "nmea.h"

static int finish(char *buf, int len)
{
    unsigned cs = 0;
    for (int i = 1; i < len; i++) cs ^= (unsigned char)buf[i];
    return len + sprintf(buf + len, "*%02X\r\n", cs);
}

int nmea_check(const char *s)
{
    const char *p = strchr(s, '*');
    if (s[0] != '$' || !p) return 0;
    unsigned cs = 0, v;
    for (const char *q = s + 1; q < p; q++) cs ^= (unsigned char)*q;
    return sscanf(p + 1, "%2X", &v) == 1 && v == cs;
}

/* GPST (неделя, с) -> календарная дата и время UTC */
static void utc(int week, double tow, int dt_ls, int *y, int *mo, int *d, int *h, int *mi, double *sec)
{
    double t = week * 604800.0 + tow - dt_ls;
    long days = (long)floor(t / 86400.0);
    double sod = t - days * 86400.0;
    days += 6;                                       /* от 01.01.1980 */
    int yy = 1980;
    for (;;) {
        int ny = (yy % 4 == 0) ? 366 : 365;
        if (days < ny) break;
        days -= ny; yy++;
    }
    static const int md[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    int m = 0;
    for (; m < 12; m++) {
        int dm = md[m] + (m == 1 && yy % 4 == 0);
        if (days < dm) break;
        days -= dm;
    }
    *y = yy; *mo = m + 1; *d = (int)days + 1;
    *h = (int)(sod / 3600); *mi = (int)((sod - *h * 3600) / 60); *sec = sod - *h * 3600 - *mi * 60;
}

static void deg(double rad, int lat, char *out)
{
    double a = fabs(rad) * 180 / GPI;
    int dd = (int)a;
    double mm = (a - dd) * 60;
    if (mm >= 59.9999995) { dd++; mm = 0; }
    if (lat) sprintf(out, "%02d%010.7f,%c", dd, mm, rad >= 0 ? 'N' : 'S');
    else sprintf(out, "%03d%010.7f,%c", dd, mm, rad >= 0 ? 'E' : 'W');
}

int nmea_gga(char *buf, const sol_t *s, int week, double tow, int dt_ls)
{
    int y, mo, d, h, mi;
    double sec, N = 0;
    char la[32], lo[32];
    utc(week, tow, dt_ls, &y, &mo, &d, &h, &mi, &sec);
    deg(s->lat, 1, la);
    deg(s->lon, 0, lo);
    /* высота над геоидом не вычисляется: N = 0 (геоид — поле 11) */
    int n = sprintf(buf, "$GNGGA,%02d%02d%06.3f,%s,%s,%d,%02d,%.1f,%.3f,M,%.3f,M,,", h, mi, sec, la, lo,
                    s->ok ? 1 : 0, s->nsat, s->hdop, s->h - N, N);
    return finish(buf, n);
}

int nmea_rmc(char *buf, const sol_t *s, int week, double tow, int dt_ls)
{
    int y, mo, d, h, mi;
    double sec;
    char la[32], lo[32];
    utc(week, tow, dt_ls, &y, &mo, &d, &h, &mi, &sec);
    deg(s->lat, 1, la);
    deg(s->lon, 0, lo);
    /* скорость и курс по составляющим ENU */
    double sl = sin(s->lat), cl = cos(s->lat), so = sin(s->lon), co = cos(s->lon);
    double ve = -so * s->vel[0] + co * s->vel[1];
    double vn = -sl * co * s->vel[0] - sl * so * s->vel[1] + cl * s->vel[2];
    double sp = hypot(ve, vn) / 0.514444, crs = atan2(ve, vn) * 180 / GPI;
    if (crs < 0) crs += 360;
    int n = sprintf(buf, "$GNRMC,%02d%02d%06.3f,%c,%s,%s,%.3f,%.1f,%02d%02d%02d,,,%c,V", h, mi, sec,
                    s->ok ? 'A' : 'V', la, lo, sp, crs, d, mo, y % 100, s->ok ? 'A' : 'N');
    return finish(buf, n);
}

int nmea_gsa(char *buf, const sol_t *s, const obs_t *obs, int n)
{
    static const int sysid[SYS_N] = {1, 2, 3, 4, 1, 6, 1};   /* NMEA 4.11: GPS 1, ГЛОНАСС 2, Galileo 3, BeiDou 4 */
    int len = 0;
    for (int sys = 0; sys < 4; sys++) {
        int k = 0, l = sprintf(buf + len, "$GNGSA,A,%d", s->ok ? 3 : 1);
        for (int i = 0; i < n && k < 12; i++) {
            if (obs[i].sys != sys || !obs[i].used) continue;
            int id = obs[i].prn + (sys == SYS_GLO ? 64 : 0);
            l += sprintf(buf + len + l, ",%02d", id);
            k++;
        }
        if (!k) continue;
        for (; k < 12; k++) l += sprintf(buf + len + l, ",");
        l += sprintf(buf + len + l, ",%.2f,%.2f,%.2f,%d", s->pdop, s->hdop, s->vdop, sysid[sys]);
        len += finish(buf + len, l);
    }
    return len;
}

int nmea_gsv(char *buf, const obs_t *obs, int n)
{
    static const char *tk[4] = {"GP", "GL", "GA", "GB"};
    int len = 0;
    for (int sys = 0; sys < 4; sys++) {
        int idx[PVT_MAXOBS], m = 0;
        for (int i = 0; i < n; i++) if (obs[i].sys == sys) idx[m++] = i;
        if (!m) continue;
        int nmsg = (m + 3) / 4;
        for (int g = 0; g < nmsg; g++) {
            int l = sprintf(buf + len, "$%sGSV,%d,%d,%02d", tk[sys], nmsg, g + 1, m);
            for (int j = 4 * g; j < m && j < 4 * g + 4; j++) {
                const obs_t *o = &obs[idx[j]];
                double az = o->az * 180 / GPI;
                if (az < 0) az += 360;
                l += sprintf(buf + len + l, ",%02d,%02d,%03d,%02d", o->prn + (sys == SYS_GLO ? 64 : 0),
                             (int)lround(o->el * 180 / GPI), (int)lround(az) % 360, (int)lround(o->cn0));
            }
            len += finish(buf + len, l);
        }
    }
    return len;
}

int nmea_zda(char *buf, int week, double tow, int dt_ls)
{
    int y, mo, d, h, mi;
    double sec;
    utc(week, tow, dt_ls, &y, &mo, &d, &h, &mi, &sec);
    int n = sprintf(buf, "$GNZDA,%02d%02d%06.3f,%02d,%02d,%04d,00,00", h, mi, sec, d, mo, y);
    return finish(buf, n);
}

/* GST: статистика погрешностей (σ по СКО невязок и матрице кофакторов ENU) */
int nmea_gst(char *buf, const sol_t *s, int week, double tow, int dt_ls)
{
    int y, mo, d, h, mi;
    double sec;
    utc(week, tow, dt_ls, &y, &mo, &d, &h, &mi, &sec);
    double s0 = s->rms, a = s->q_e, c = s->q_n, b = s->q_en;
    double tr = (a + c) / 2, dd = sqrt((a - c) * (a - c) / 4 + b * b);
    double l1 = tr + dd, l2 = tr - dd > 0 ? tr - dd : 0;
    double ori = atan2(l1 - c, b) * 180 / GPI;          /* направление большой оси от севера */
    if (fabs(b) < 1e-12) ori = a >= c ? 90 : 0;
    if (ori < 0) ori += 180;
    int n = sprintf(buf, "$GNGST,%02d%02d%06.3f,%.2f,%.2f,%.2f,%.1f,%.2f,%.2f,%.2f", h, mi, sec, s0,
                    s0 * sqrt(l1), s0 * sqrt(l2), ori, s0 * sqrt(c), s0 * sqrt(a), s0 * sqrt(s->q_u));
    return finish(buf, n);
}
