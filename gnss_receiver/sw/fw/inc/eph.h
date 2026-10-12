/* МГП-8: бортовые эфемериды и координаты КА (GPS, Galileo, BeiDou, QZSS — кеплеровы элементы;
 * ГЛОНАСС — численное интегрирование в ПЗ-90). Время — секунды недели GPST. */
#ifndef EPH_H
#define EPH_H
#include <stdint.h>

#define GPST_BDT   14.0          /* GPST − BDT, с */
#define GPST_UTC   18.0          /* GPST − UTC, с (с 01.01.2017) */

typedef struct {
    uint8_t sys, prn, valid;
    int8_t  fcn;                 /* литера ГЛОНАСС */
    int     week;                /* неделя GPS */
    double  toc, toe;            /* секунды недели GPST */
    double  af0, af1, af2, tgd;
    double  sqrtA, e, i0, OMG0, omg, M0, dn, OMGd, idot, cuc, cus, crc, crs, cic, cis;
    int     iode, iodc, svh, sva;
    /* ГЛОНАСС: ПЗ-90, м, м/с, м/с² на момент toc; −τn (с), γn */
    double  pos[3], vel[3], acc[3], taun, gamn;
} eph_t;

/* координаты (ECEF, м) и поправка часов КА (с, вкл. релятивистскую) на момент t (GPST sow);
 * vs, ddts — скорость (м/с) и дрейф часов (с/с), могут быть NULL. Возвращает 0 при ошибке. */
int  eph_satpos(const eph_t *e, double t, double rs[3], double *dts, double vs[3], double *ddts);
/* выбор эфемерид, ближайших к t, с проверкой срока действия */
const eph_t *eph_select(const eph_t *eph, int n, int sys, int prn, double t);
double eph_tdiff(double t1, double t0);          /* разность секунд недели с учётом перехода */

#endif
