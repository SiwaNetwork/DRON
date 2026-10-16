/* Сквозная проверка «ПЧ -> координаты и 1PPS» на модели ПЛИС.
 * Имитатор: все видимые КА GPS над Москвой по эфемеридам RINEX (геометрия, часы КА, поворот
 * Земли), навигационное сообщение LNAV с этими эфемеридами, C/N0 45 дБГц, уход ТКГ +0,3 ppm.
 * ПО МК: захват по снимкам, слежение, декодирование эфемерид, псевдодальности, решение,
 * NMEA, вычисление момента 1PPS. Проверка: ошибка координат, дрейфа часов и момента 1PPS. */
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "gnss.h"
#include "fpga.h"
#include "corr.h"
#include "corr_sim.h"
#include "eph.h"
#include "pvt.h"
#include "nmea.h"
#include "rx.h"

#include "sim_gps.h"

#define DUR  27.0                    /* с */
#define T0    SIM_T0
#define DELTA SIM_DELTA
#define RR    SIM_RR
#define t_true sim_gps_t
#define src    sim_gps_src

int main(void)
{
    int NS = sim_gps_init(DUR);
    printf("Имитатор: КА GPS %d, начало %.3f с недели, уход ТКГ %+.2f ppm, %.0f с\n", NS, T0, DELTA * 1e6, DUR);
    corr_sim_init(1);
    corr_init();
    rx_t rx;
    rx_init(&rx);
    rx.pcfg.trop = 0;                                   /* имитатор без атмосферы */
    /* снимки и захват */
    enum { NSNAP = 4 };
    static uint8_t x4[NSNAP][65536];
    const uint8_t *xsn[NSNAP];
    uint32_t t0s[NSNAP];
    int len = 49152;
    corr_sim_run(1000, src);
    for (int s = 0; s < NSNAP; s++) {
        acq_snap_start(0, len, 0);
        corr_sim_run((uint64_t)len + 16, src);
        acq_snap_read(len, x4[s], &t0s[s]);
        xsn[s] = x4[s];
        corr_sim_run(8000, src);
    }
    acq_cfg_t ac = {.dop_max = 6000, .dop_step = 250, .nper = 2, .thresh = 2.0};
    uint64_t t_start = (corr_sim_nsmp() + 24000) & ~3ull;
    int nch = rx_acquire(&rx, xsn, t0s, NSNAP, len, SIG_L1CA, t_start, &ac);
    printf("Захват: найдено %d из %d КА\n", nch, NS);
    /* слежение, навигация, решение раз в секунду */
    int ok = 1, nsol = 0;
    double maxerr = 0, maxpps = 0;
    uint64_t next = ((corr_sim_nsmp() / 24000000) + 1) * 24000000ull;
    while (t_true(corr_sim_nsmp()) < T0 + DUR - 0.01) {
        corr_sim_run(4096, src);
        rx_process(&rx, corr_sim_nsmp());
        if (corr_sim_nsmp() < next) continue;
        uint64_t nm = next;
        next += 24000000ull;
        int nlk = 0, ntx = 0, neph = 0;
        for (int k = 0; k < CORR_MAXCH; k++) if (rx.ch[k].used) {
            nlk += rx.ch[k].trk.state == TRK_LOCK; ntx += rx.ch[k].tx_ok; neph += rx_eph(&rx, SYS_GPS, rx.ch[k].prn)->valid;
        }
        if (!rx_measure(&rx, nm)) {
            printf("  t=%5.1f с: каналов в захвате %d, с временем %d, с эфемеридами %d — решения нет\n",
                   t_true(nm) - T0, nlk, ntx, neph);
            continue;
        }
        nsol++;
        double d[3] = {rx.sol.pos[0] - RR[0], rx.sol.pos[1] - RR[1], rx.sol.pos[2] - RR[2]};
        double err = sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
        double terr = rx.sol.t_rx - t_true(nm);
        double ddrift = rx.sol.clkd / CLIGHT - DELTA / (1 + DELTA);
        /* 1PPS: следующая секунда GPST */
        uint64_t t96;
        double qe, sec;
        rx_pps_next(&rx, nm, &t96, &qe, &sec);
        double n_true = (sec - T0) * FS_HZ * (1 + DELTA);
        double pps_err = ((double)(t96 + 1 + PPS_DELAY_T96) - 4.0 * n_true) / F96_HZ;
        double pps_err_q = pps_err + qe;                       /* с учётом qErr */
        printf("  t=%5.1f с: КА %2d, ошибка коорд. %6.2f м, времени %+7.1f нс, дрейфа %+.3f ppb, 1PPS %+6.2f нс "
               "(после qErr %+.2f нс), PDOP %.2f\n", t_true(nm) - T0, rx.sol.nsat, err, terr * 1e9, ddrift * 1e9,
               pps_err * 1e9, pps_err_q * 1e9, rx.sol.pdop);
        if (err > maxerr) maxerr = err;
        if (fabs(pps_err_q) > maxpps) maxpps = fabs(pps_err_q);
        if (nsol == 2) {
            char buf[4096];
            int week = rx.week;
            nmea_gga(buf, &rx.sol, week, rx.sol.t_rx, rx.dt_ls); printf("    %s", buf);
            nmea_rmc(buf, &rx.sol, week, rx.sol.t_rx, rx.dt_ls); printf("    %s", buf);
            nmea_zda(buf, week, rx.sol.t_rx, rx.dt_ls); printf("    %s", buf);
            int l = nmea_gsa(buf, &rx.sol, rx.obs, rx.nobs); buf[l] = 0; printf("    %s", buf);
            l = nmea_gsv(buf, rx.obs, rx.nobs); buf[l] = 0;
            for (char *p = buf; *p;) { char *q = strstr(p, "\r\n"); if (!q) break; *q = 0; printf("    %s\n", p); p = q + 2; }
        }
    }
    printf("Решений %d; макс. ошибка координат %.2f м; макс. ошибка 1PPS (с qErr) %.2f нс\n", nsol, maxerr, maxpps * 1e9);
    if (nsol < 2 || maxerr > 15 || maxpps > 20e-9) ok = 0;
    printf("ИТОГ: %s\n", ok ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    return !ok;
}
