/* МГП-8: таблица сигналов и частотный план (sim/gnss_signals.py, ТЗ табл. 1). */
#include <string.h>
#include "gnss.h"

#define F0 10.23e6

const double RF_LO[NRF] = {1568.000e6, 1602.000e6, 1227.600e6, 1246.000e6,
                           1176.450e6, 1207.140e6, 1268.520e6, 1278.750e6};

/*  id      sys      rf boc tdm pil  fc            fdma     chip_rate  len    ms */
const sig_info_t SIGS[SIG_N] = {
    {"L1CA", SYS_GPS, 0, 0, 0, 0, 154 * F0,     0,       1.023e6,   1023,  1},
    {"L1CP", SYS_GPS, 0, 1, 0, 1, 154 * F0,     0,       1.023e6,  10230, 10},
    {"L1CD", SYS_GPS, 0, 1, 0, 0, 154 * F0,     0,       1.023e6,  10230, 10},
    {"L2CM", SYS_GPS, 2, 0, 1, 0, 120 * F0,     0,       0.5115e6, 10230, 20},
    {"L5I",  SYS_GPS, 4, 0, 0, 0, 115 * F0,     0,      10.23e6,   10230,  1},
    {"L5Q",  SYS_GPS, 4, 0, 0, 1, 115 * F0,     0,      10.23e6,   10230,  1},
    {"G1CA", SYS_GLO, 1, 0, 0, 0, 1602.0e6,  562.5e3,    0.511e6,   511,  1},
    {"G2CA", SYS_GLO, 3, 0, 0, 0, 1246.0e6,  437.5e3,    0.511e6,   511,  1},
    {"E1B",  SYS_GAL, 0, 1, 0, 0, 154 * F0,     0,       1.023e6,   4092,  4},
    {"E1C",  SYS_GAL, 0, 1, 0, 1, 154 * F0,     0,       1.023e6,   4092,  4},
    {"E5AI", SYS_GAL, 4, 0, 0, 0, 115 * F0,     0,      10.23e6,   10230,  1},
    {"E5AQ", SYS_GAL, 4, 0, 0, 1, 115 * F0,     0,      10.23e6,   10230,  1},
    {"E5BI", SYS_GAL, 5, 0, 0, 0, 118 * F0,     0,      10.23e6,   10230,  1},
    {"E5BQ", SYS_GAL, 5, 0, 0, 1, 118 * F0,     0,      10.23e6,   10230,  1},
    {"E6B",  SYS_GAL, 7, 0, 0, 0, 125 * F0,     0,       5.115e6,   5115,  1},
    {"E6C",  SYS_GAL, 7, 0, 0, 1, 125 * F0,     0,       5.115e6,   5115,  1},
    {"B1I",  SYS_BDS, 0, 0, 0, 0, 1561.098e6,   0,       2.046e6,   2046,  1},
    {"B1CD", SYS_BDS, 0, 1, 0, 0, 154 * F0,     0,       1.023e6,  10230, 10},
    {"B1CP", SYS_BDS, 0, 1, 0, 1, 154 * F0,     0,       1.023e6,  10230, 10},
    {"B2AD", SYS_BDS, 4, 0, 0, 0, 115 * F0,     0,      10.23e6,   10230,  1},
    {"B2AP", SYS_BDS, 4, 0, 0, 1, 115 * F0,     0,      10.23e6,   10230,  1},
    {"B2I",  SYS_BDS, 5, 0, 0, 0, 118 * F0,     0,       2.046e6,   2046,  1},
    {"B2BI", SYS_BDS, 5, 0, 0, 0, 118 * F0,     0,      10.23e6,   10230,  1},
    {"B3I",  SYS_BDS, 6, 0, 0, 0, 1268.52e6,    0,      10.23e6,   10230,  1},
    {"I5S",  SYS_IRN, 4, 0, 0, 0, 115 * F0,     0,       1.023e6,   1023,  1},
};

int sig_by_id(const char *id)
{
    for (int i = 0; i < SIG_N; i++)
        if (!strcmp(SIGS[i].id, id)) return i;
    return -1;
}

double sig_carrier(int sig, int fcn)
{
    return SIGS[sig].fc + fcn * SIGS[sig].fdma_step;
}

double sig_if(int sig, int fcn)
{
    return sig_carrier(sig, fcn) - RF_LO[SIGS[sig].rf];
}
