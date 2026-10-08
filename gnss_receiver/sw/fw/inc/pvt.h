/* МГП-8: навигационное решение (координаты, скорость, время) по кодовым и доплеровским измерениям
 * нескольких систем: взвешенный МНК, отдельная шкала времени каждой системы. */
#ifndef PVT_H
#define PVT_H
#include "gnss.h"
#include "eph.h"

#define PVT_MAXOBS 96

typedef struct {
    int    sys, prn;
    double pr;               /* псевдодальность, м */
    double dop;              /* доплер, Гц (0 — нет) */
    double fc;               /* несущая, Гц (для доплера) */
    double cn0;              /* дБГц */
    const eph_t *eph;
    /* результаты */
    double az, el, res;
    int    used;
} obs_t;

typedef struct {
    double el_mask;          /* маска угла места, рад */
    int    trop, iono;       /* учитывать тропосферу / ионосферу (Клобучар) */
    double ion[8];           /* параметры Клобучара (α0..3, β0..3) */
} pvt_cfg_t;

typedef struct {
    int    ok, nsat, nsys;
    double t_rx;             /* время приёма (GPST, секунды недели), исправленное */
    double pos[3], vel[3];   /* ECEF, м, м/с */
    double lat, lon, h;      /* рад, рад, м (WGS-84) */
    double clk[SYS_N];       /* смещение шкалы приёмника относительно шкалы системы, м */
    double clkd;             /* дрейф часов приёмника, м/с */
    double gdop, pdop, hdop, vdop, tdop;
    double rms;              /* СКО невязок, м */
} sol_t;

void pvt_default_cfg(pvt_cfg_t *c);
/* t_rx — время приёма по часам приёмника (GPST sow, со смещением часов); sol->pos — начальное
 * приближение (0 — центр Земли). sol->t_rx — время приёма по шкале GPST. */
int  pvt_solve(obs_t *obs, int n, double t_rx, const pvt_cfg_t *cfg, sol_t *sol);
void ecef2llh(const double *r, double *lat, double *lon, double *h);
void llh2ecef(double lat, double lon, double h, double *r);

#endif
