/* МГП-8: общие определения ПО МК (системы, сигналы, константы). */
#ifndef GNSS_H
#define GNSS_H
#include <stdint.h>
#include <stddef.h>

#define CLIGHT      299792458.0          /* скорость света, м/с */
#define GPI         3.1415926535897932   /* число π */
#define FS_HZ       24.0e6               /* частота дискретизации, Гц */
#define F96_HZ      96.0e6               /* такт ПЛИС (единица шкалы T96) */
#define NRF         8                    /* ВЧ-каналов */

enum { SYS_GPS = 0, SYS_GLO, SYS_GAL, SYS_BDS, SYS_QZS, SYS_IRN, SYS_SBS, SYS_N };

/* сигналы (порядок совпадает с таблицей SIGS[] в signals.c) */
enum {
    SIG_L1CA = 0, SIG_L1CP, SIG_L1CD, SIG_L2CM, SIG_L5I, SIG_L5Q,
    SIG_G1CA, SIG_G2CA,
    SIG_E1B, SIG_E1C, SIG_E5AI, SIG_E5AQ, SIG_E5BI, SIG_E5BQ, SIG_E6B, SIG_E6C,
    SIG_B1I, SIG_B1CD, SIG_B1CP, SIG_B2AD, SIG_B2AP, SIG_B2I, SIG_B2BI, SIG_B3I,
    SIG_I5S, SIG_N
};

typedef struct {
    const char *id;          /* обозначение (как в Pocket SDR) */
    uint8_t  sys;            /* SYS_* */
    uint8_t  rf;             /* ВЧ-канал 0..7 */
    uint8_t  boc;            /* BOC(1,1) на поднесущей */
    uint8_t  tdm;            /* временное уплотнение (нулевая вторая половина чипа) */
    uint8_t  pilot;          /* пилотная составляющая (без данных) */
    double   fc;             /* несущая, Гц (ГЛОНАСС — литера 0) */
    double   fdma_step;      /* шаг литер ГЛОНАСС, Гц */
    double   chip_rate;      /* частота чипов первичного кода, чип/с */
    uint16_t code_len;       /* длина первичного кода, чипов */
    uint16_t code_ms;        /* период первичного кода, мс */
} sig_info_t;

extern const sig_info_t SIGS[SIG_N];
extern const double RF_LO[NRF];          /* частоты гетеродинов ВЧ-каналов, Гц */

int    sig_by_id(const char *id);
double sig_carrier(int sig, int fcn);    /* несущая с учётом литеры ГЛОНАСС */
double sig_if(int sig, int fcn);         /* смещение несущей от гетеродина (ПЧ), Гц */

#endif
