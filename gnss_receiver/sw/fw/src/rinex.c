/* МГП-8: чтение навигационного файла RINEX 3.04 (GPS, ГЛОНАСС, Galileo, BeiDou, QZSS).
 * Время приводится к секундам недели GPST (sim/gnss_orbits.py, read_rinex_nav). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "gnss.h"
#include "rinex.h"

static double fld(const char *s, int off)
{
    char b[24];
    int n = (int)strlen(s);
    if (off >= n) return 0;
    memcpy(b, s + off, 19);
    b[19] = 0;
    for (char *p = b; *p; p++) if (*p == 'D' || *p == 'd') *p = 'E';
    return atof(b);
}

static void gpst(int y, int mo, int d, int h, int mi, double s, int *week, double *sow)
{
    /* дни от 06.01.1980 */
    static const int cum[12] = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};
    long days = 0;
    for (int yy = 1980; yy < y; yy++) days += (yy % 4 == 0) ? 366 : 365;
    days += cum[mo - 1] + d - 1 + ((y % 4 == 0 && mo > 2) ? 1 : 0) - 5;
    double secs = days * 86400.0 + h * 3600.0 + mi * 60.0 + s;
    *week = (int)(secs / 604800);
    *sow = secs - *week * 604800.0;
}

int rinex_read_nav(const char *path, eph_t *eph, int max)
{
    FILE *fp = fopen(path, "r");
    if (!fp) return 0;
    char ln[8][128];
    int n = 0;
    while (fgets(ln[0], sizeof ln[0], fp)) if (strstr(ln[0], "END OF HEADER")) break;
    while (n < max && fgets(ln[0], sizeof ln[0], fp)) {
        char c = ln[0][0];
        int nl = (c == 'R' || c == 'S') ? 4 : 8;
        for (int k = 1; k < nl; k++) if (!fgets(ln[k], sizeof ln[k], fp)) { nl = 0; break; }
        if (!nl || strlen(ln[0]) < 23) continue;
        int sys = c == 'G' ? SYS_GPS : c == 'R' ? SYS_GLO : c == 'E' ? SYS_GAL : c == 'C' ? SYS_BDS
                : c == 'J' ? SYS_QZS : -1;
        if (sys < 0) continue;
        double v[32] = {0};
        int nv = 0;
        for (int k = 0; k < 3; k++) v[nv++] = fld(ln[0], 23 + 19 * k);
        for (int l = 1; l < nl; l++) for (int k = 0; k < 4; k++) v[nv++] = fld(ln[l], 4 + 19 * k);
        int y, mo, d, h, mi, s;
        sscanf(ln[0] + 4, "%d %d %d %d %d %d", &y, &mo, &d, &h, &mi, &s);
        eph_t *e = &eph[n];
        memset(e, 0, sizeof(*e));
        e->sys = (uint8_t)sys;
        e->prn = (uint8_t)atoi(ln[0] + 1);
        gpst(y, mo, d, h, mi, s, &e->week, &e->toc);
        if (sys == SYS_GLO) {
            e->toc = fmod(e->toc + GPST_UTC, 604800);
            e->taun = v[0]; e->gamn = v[1];
            e->pos[0] = v[3] * 1e3; e->vel[0] = v[4] * 1e3; e->acc[0] = v[5] * 1e3; e->svh = (int)v[6];
            e->pos[1] = v[7] * 1e3; e->vel[1] = v[8] * 1e3; e->acc[1] = v[9] * 1e3; e->fcn = (int8_t)v[10];
            e->pos[2] = v[11] * 1e3; e->vel[2] = v[12] * 1e3; e->acc[2] = v[13] * 1e3;
            e->toe = e->toc;
        } else {
            if (sys == SYS_BDS) e->toc = fmod(e->toc + GPST_BDT, 604800);
            e->af0 = v[0]; e->af1 = v[1]; e->af2 = v[2]; e->iode = (int)v[3];
            e->crs = v[4]; e->dn = v[5]; e->M0 = v[6]; e->cuc = v[7]; e->e = v[8]; e->cus = v[9];
            e->sqrtA = v[10]; e->toe = v[11]; e->cic = v[12]; e->OMG0 = v[13]; e->cis = v[14];
            e->i0 = v[15]; e->crc = v[16]; e->omg = v[17]; e->OMGd = v[18]; e->idot = v[19];
            e->sva = (int)v[23]; e->svh = (int)v[24]; e->tgd = v[25]; e->iodc = (int)v[26];
            if (sys == SYS_BDS) e->toe = fmod(e->toe + GPST_BDT, 604800);
        }
        e->valid = 1;
        n++;
    }
    fclose(fp);
    return n;
}
