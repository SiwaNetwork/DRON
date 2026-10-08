/* МГП-8: чтение навигационного файла RINEX 3.04 (только для проверок на ПК). */
#ifndef RINEX_H
#define RINEX_H
#include "eph.h"
int rinex_read_nav(const char *path, eph_t *eph, int max);
#endif
