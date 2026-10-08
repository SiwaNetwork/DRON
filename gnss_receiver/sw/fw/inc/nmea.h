/* МГП-8: выходные сообщения NMEA 0183 (GGA, RMC, GSA, GSV, ZDA). */
#ifndef NMEA_H
#define NMEA_H
#include "pvt.h"
/* время — GPST (неделя, секунды недели), dt_ls — GPST − UTC; буфер ≥ 1024 байт; возвращает длину */
int nmea_gga(char *buf, const sol_t *s, int week, double tow, int dt_ls);
int nmea_rmc(char *buf, const sol_t *s, int week, double tow, int dt_ls);
int nmea_gsa(char *buf, const sol_t *s, const obs_t *obs, int n);
int nmea_gsv(char *buf, const obs_t *obs, int n);
int nmea_zda(char *buf, int week, double tow, int dt_ls);
int nmea_check(const char *sentence);    /* 1 — контрольная сумма верна */
#endif
