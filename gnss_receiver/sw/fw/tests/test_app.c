/* Сквозная проверка прикладного уровня ПО МК (app.c) на модели ПЛИС: прерывание ПЛИС (TIC 1 мс,
 * результаты корреляторов, 1PPS), решение по запросу из прерывания, поиск в фоне по одному КА.
 * Длительность поиска одного КА на МК имитируется: после каждого шага поиска модель ПЛИС
 * продолжает работу 50 мс с обслуживанием прерываний и решений (как при вытеснении фона).
 * Имитатор — sim_gps.c (GPS L1 C/A над Москвой), один КА — при C/N0 29 дБГц: его находит только
 * второй проход поиска — на ускорителе ПЛИС. Проверка: координаты, 1PPS от ПЛИС против истинной
 * секунды GPST, NMEA (контрольные суммы), отсутствие вложенных блокировок; слабый КА — пуск по
 * ускорителю, захват фазы, синхронизация по битам и по подкадрам (время излучения); КА, которых
 * нет в имитаторе, — не в слежении после проверки и не в измерениях (канал слабого сигнала даёт
 * измерения лишь после синхронизации по битам и проверки на взаимную корреляцию). */
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "gnss.h"
#include "fpga.h"
#include "corr.h"
#include "corr_sim.h"
#include "rx.h"
#include "nmea.h"
#include "app.h"
#include "sim_gps.h"

#define DUR    40.0                  /* с */
#define T_ACQ  0.05                  /* имитируемая длительность поиска одного КА, с */
#define CN0_W  29.0                  /* C/N0 слабого КА, дБГц */
#define CHUNK  4096

static app_t A;
static rx_t RX;
static uint8_t SNAP[APP_NSNAP][SNAP_BYTES(APP_SNAP_N)];
static int lk_on, lk_n, lk_bad, n_sent, n_bad_cs, n_gga;

static void lock(int on)
{
    if (on == lk_on) lk_bad++;       /* вложенная или лишняя разблокировка */
    lk_on = on;
    lk_n += on;
}

static void out(const char *s, int n)
{
    char b[4096];
    memcpy(b, s, (size_t)n);
    b[n] = 0;
    for (char *p = b; *p;) {
        char *q = strstr(p, "\r\n");
        if (!q) { n_bad_cs++; break; }
        *q = 0;
        n_sent++;
        if (!nmea_check(p)) n_bad_cs++;
        if (!strncmp(p + 3, "GGA", 3)) n_gga++;
        p = q + 2;
    }
}

static int in_sim(int ns, int prn)
{
    for (int i = 0; i < ns; i++)
        if (sim_gps_prn(i) == prn) return 1;
    return 0;
}

/* модель ПЛИС на CHUNK отсчётов; прерывание ПЛИС, затем запрошенное им решение (PendSV) */
static int pend;
static void step(void)
{
    corr_sim_run(CHUNK, sim_gps_src);
    if (fpga_rd(R_IRQ_STATUS) & fpga_rd(R_IRQ_MASK)) pend |= app_irq(&A);
    if (pend) { pend = 0; app_sol(&A); }
}

int main(void)
{
    int NS = sim_gps_init(DUR), PW = sim_gps_prn(0);
    sim_gps_cn0(0, CN0_W);                               /* меньший PRN — раньше во втором проходе */
    printf("Имитатор: КА GPS %d, %.0f с; поиск одного КА — %.0f мс; PRN %d — %.0f дБГц\n", NS, DUR, T_ACQ * 1e3,
           PW, CN0_W);
    corr_sim_init(1);
    uint8_t *snap[APP_NSNAP];
    for (int k = 0; k < APP_NSNAP; k++) snap[k] = SNAP[k];
    int e = app_init(&A, &RX, snap, lock);
    printf("app_init: %d, версия ПЛИС %08X, каналов %d\n", e, (unsigned)A.fpga_ver, A.nch);
    int ok = e == 0;
    A.nsig = 1;                                          /* имитатор — только GPS L1 C/A */
    A.out = out;
    RX.pcfg.trop = 0;                                    /* имитатор без атмосферы */
    int pps_prev = 0, n_pps = 0, nsol_prev = 0;
    double rec_sec = -1, rec_qe = 0, maxerr = 0, maxpps = 0, t_first = -1;
    static int wst[CORR_MAXCH];                          /* состояние канала слабого сигнала (для печати) */
    while (sim_gps_t(corr_sim_nsmp()) < SIM_T0 + DUR - 0.01) {
        step();
        /* импульс 1PPS выдан ПЛИС: сравнение с истинной секундой GPST (взведённой перед выдачей) */
        uint64_t t96;
        int np = corr_sim_pps(&t96);
        if (np != pps_prev) {
            pps_prev = np;
            double n_true = (rec_sec - SIM_T0) * FS_HZ * (1 + SIM_DELTA);
            double err = ((double)(t96 + 1 + PPS_DELAY_T96) - 4.0 * n_true) / F96_HZ + rec_qe;
            printf("  1PPS: секунда %.0f, ошибка (с qErr) %+.2f нс\n", rec_sec, err * 1e9);
            if (fabs(err) > maxpps) maxpps = fabs(err);
            n_pps++;
        }
        rec_sec = A.pps_sec;
        rec_qe = A.pps_qerr;
        if ((int)A.n_sol != nsol_prev) {
            nsol_prev = (int)A.n_sol;
            double d[3] = {RX.sol.pos[0] - SIM_RR[0], RX.sol.pos[1] - SIM_RR[1], RX.sol.pos[2] - SIM_RR[2]};
            double err = sqrt(d[0] * d[0] + d[1] * d[1] + d[2] * d[2]);
            if (t_first < 0) t_first = sim_gps_t(corr_sim_nsmp()) - SIM_T0;
            printf("  t=%5.1f с: решение %d, КА %2d, ошибка коорд. %6.2f м\n", sim_gps_t(RX.sol_n) - SIM_T0,
                   nsol_prev, RX.sol.nsat, err);
            if (err > maxerr) maxerr = err;
        }
        uint32_t hw_prev = A.n_hw, xc_prev = A.n_xc;
        int c_prev = A.hw_c;
        int w = app_poll(&A);
        if (w & APP_ACQ) {                               /* поиск на МК занимает время */
            for (int i = 0; i < (int)(T_ACQ * FS_HZ / CHUNK); i++) step();
        }
        double t = sim_gps_t(corr_sim_nsmp()) - SIM_T0;
        if (A.n_hw != hw_prev || (A.hw_c && !c_prev))
            printf("  t=%5.1f с: ускоритель — PRN %2d (%s): z = %4.1f%s\n", t, A.hw_q, in_sim(NS, A.hw_q) ? "есть" : "нет",
                   A.hw_z, A.hw_c ? ", подтверждение" : A.hw_s > 0 ? ", подтверждён — пуск канала" :
                   c_prev ? ", не подтверждён" : "");
        if (A.n_xc != xc_prev) printf("  t=%5.1f с: ложный захват (взаимная корреляция) — канал освобождён\n", t);
        /* каналы слабого сигнала: пуск, захват фазы, синхронизация по битам, проверка */
        for (int k = 0; k < CORR_MAXCH; k++) {
            const rx_ch_t *c = &RX.ch[k];
            int s = !c->used || !c->trk.weak ? 0 : c->xc ? 4 : c->trk.bit_sync ? 3 : c->trk.state == TRK_LOCK ? 2 : 1;
            if (s > wst[k]) {
                static const char *const EV[] = {"", "пуск", "захват фазы", "синхронизация по битам",
                                                 "проверка на взаимную корреляцию пройдена"};
                printf("  t=%5.1f с: канал %d, PRN %d (%s) — %s, C/N0 %.1f дБГц\n", t, k, c->prn,
                       in_sim(NS, c->prn) ? "есть" : "нет", EV[s], c->trk.cn0);
            }
            wst[k] = s;
        }
    }
    /* в слежении — КА имитатора; ложные (нет в имитаторе) — в захвате без проверки слабого сигнала
     * или в измерениях */
    int ntrk = 0, nfalse = 0;
    const rx_ch_t *cw = NULL;
    for (int k = 0; k < CORR_MAXCH; k++) {
        const rx_ch_t *c = &RX.ch[k];
        if (!c->used) continue;
        if (!in_sim(NS, c->prn)) nfalse += c->trk.state == TRK_LOCK && (!c->trk.weak || c->xc);
        else ntrk += c->trk.state == TRK_LOCK;
        if (c->sig == SIG_L1CA && c->prn == PW) cw = c;
    }
    for (int i = 0; i < RX.nobs; i++) nfalse += !in_sim(NS, RX.obs[i].prn);
    printf("Прерываний %u (TIC %u, 1PPS %u, опозданий фиксации %u); поисков %u, найдено %u; на ускорителе %u, "
           "найдено %u, освобождено каналов по ВКФ %u; в слежении %d КА имитатора, ложных %d\n", (unsigned)A.n_irq,
           (unsigned)A.n_tic, (unsigned)A.n_pps, (unsigned)A.n_late, (unsigned)A.n_acq, (unsigned)A.n_found,
           (unsigned)A.n_hw, (unsigned)A.n_hw_found, (unsigned)A.n_xc, ntrk, nfalse);
    printf("Решений %u (отказов %u), первое через %.1f с; NMEA: выдач %u, предложений %d, GGA %d, ошибок %d\n",
           (unsigned)A.n_sol, (unsigned)A.n_fail, t_first, (unsigned)A.n_nmea, n_sent, n_gga, n_bad_cs);
    printf("Блокировок %d, нарушений %d; макс. ошибка координат %.2f м, 1PPS (с qErr) %.2f нс по %d импульсам\n",
           lk_n, lk_bad, maxerr, maxpps * 1e9, n_pps);
    int wk = cw && cw->trk.weak && cw->trk.state == TRK_LOCK && cw->trk.bit_sync && cw->xc && cw->tx_ok, wo = 0;
    for (int i = 0; i < RX.nobs; i++) wo |= RX.obs[i].prn == PW;
    if (cw)
        printf("Слабый КА PRN %d: пуск по %s, %s, C/N0 %.1f дБГц, %s, %s, %s, %s\n", PW,
               cw->trk.weak ? "ускорителю" : "поиску на МК", cw->trk.state == TRK_LOCK ? "захват фазы" : "НЕТ захвата",
               cw->trk.cn0, cw->trk.bit_sync ? "синхронизация по битам" : "НЕТ синхронизации по битам",
               cw->xc ? "проверка на взаимную корреляцию пройдена" : "НЕТ проверки на взаимную корреляцию",
               cw->tx_ok ? "время излучения по подкадрам" : "НЕТ синхронизации по подкадрам",
               wo ? "в измерениях" : "НЕ в измерениях");
    else
        printf("Слабый КА PRN %d: НЕ в слежении\n", PW);
    if (A.n_sol < 3 || maxerr > 15 || n_pps < 2 || maxpps > 20e-9 || n_bad_cs || n_gga != (int)A.n_sol ||
        lk_bad || lk_on || A.n_late || ntrk < NS || nfalse || !wk) ok = 0;
    printf("ИТОГ: %s\n", ok ? "ПРОЙДЕН" : "НЕ ПРОЙДЕН");
    return !ok;
}
