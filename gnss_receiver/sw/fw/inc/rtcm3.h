/* МГП-8: выдача сырых измерений RTCM 3.3 (MSM7: 1077 GPS, 1087 ГЛОНАСС, 1097 Galileo,
 * 1127 BeiDou; 1005 — координаты антенны). */
#ifndef RTCM3_H
#define RTCM3_H
#include <stdint.h>

typedef struct {
    int    prn;             /* номер КА (ГЛОНАСС — номер слота 1..24) */
    int    fcn;             /* литера ГЛОНАСС −7..+6 */
    int    sig;             /* идентификатор сигнала RTCM (DF395): GPS L1C/A — 2 и т. д. */
    double pr;              /* псевдодальность, м */
    double cp;              /* фаза несущей, циклы (0 — нет) */
    double dop;             /* доплер, Гц */
    double lam;             /* длина волны, м */
    double cn0;             /* дБГц */
    double lock;            /* время непрерывного слежения за фазой, с */
    int    half;            /* неразрешённая полуцикловая неоднозначность */
} msm_obs_t;

/* сообщение MSM7 системы sys (SYS_*): epoch_ms — время эпохи в шкале системы (мс недели,
 * для ГЛОНАСС — мс суток МДВ с днём недели в старших битах); multi — признак продолжения.
 * Возвращает длину кадра (байт). */
int rtcm_msm7(uint8_t *buf, int sys, int station, uint32_t epoch_ms, int multi, const msm_obs_t *o, int n);
int rtcm_1005(uint8_t *buf, int station, const double *ecef);
uint32_t rtcm_crc24q(const uint8_t *buf, int len);

#endif
