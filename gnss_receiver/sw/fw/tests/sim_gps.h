/* Имитатор сигналов GPS L1 C/A для сквозных проверок (test_rx_pvt, test_app): все видимые КА
 * над Москвой по эфемеридам RINEX (геометрия, часы КА, поворот Земли), навигационное сообщение
 * LNAV с этими эфемеридами, C/N0 45 дБГц (по КА — sim_gps_cn0), уход ТКГ +0,3 ppm. Начало — за 3 с
 * до начала кадра. */
#ifndef SIM_GPS_H
#define SIM_GPS_H
#include <stdint.h>

extern double SIM_T0;                /* истинное время GPST на отсчёте 0, с недели */
extern double SIM_DELTA;             /* уход ТКГ (частота отсчётов FS·(1 + δ)) */
extern double SIM_RR[3];             /* истинные координаты антенны (ECEF), м */

int      sim_gps_init(double dur);   /* dur — длительность, с; число КА */
int      sim_gps_prn(int i);         /* PRN КА с индексом i (0..число КА − 1) */
void     sim_gps_cn0(int i, double cn0);   /* C/N0 КА с индексом i, дБГц (после sim_gps_init) */
uint32_t sim_gps_src(uint64_t i);    /* слово отсчёта i (формат ПЛИС, канал A) */
double   sim_gps_t(uint64_t n);      /* истинное время GPST отсчёта n */

#endif
