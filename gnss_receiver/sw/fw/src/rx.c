/* МГП-8: управление приёмником.
 * Время излучения сигнала КА (GPS L1 C/A): по границе подкадра LNAV (TOW из HOW — время начала
 * следующего подкадра) и фазе кода без свёртки из «зеркала» NCO:
 *   t_tx(n) = ref_tow + (code_tot(n) − ref_code) / 2^32 / R_code.
 * Псевдодальность: PR = c·(t_rx(n) − t_tx(n)), t_rx — шкала приёмника (номинальная Fд).
 * ГЛОНАСС: опорная эпоха — конец метки времени строки (время — tk + 2m по МДВ, переводится
 * в GPST по шкале приёмника), эфемериды — по строкам 1–4, номер КА — из строки 4.
 * Galileo E1-B: опорная эпоха — конец страницы I/NAV (2 с; GST начала страницы + 2 с, секунды
 * недели GST = GPST без GGTO); BeiDou B1I: конец подкадра D1 (6 с; SOW — BDT, GPST = BDT + 14 с).
 * Время на шкале каждой системы приведено к GPST; расхождение шкал оценивает решение (часы по
 * системам). */
#include <math.h>
#include <string.h>
#include "fpga.h"
#include "rx.h"

#define TWO32 4294967296.0

void rx_init(rx_t *r)
{
    memset(r, 0, sizeof(*r));
    pvt_default_cfg(&r->pcfg);
    trk_default_cfg(&r->tcfg);
    r->dt_ls = (int)GPST_UTC;
    r->smooth = 100.0;
}

double rx_time(const rx_t *r, uint64_t n)
{
    return r->t0_tow + (double)(int64_t)(n - r->t0_n) / FS_HZ;
}

static void on_bit(void *ctx, int bit, uint64_t n_end);
static rx_t *RX;                     /* для обратного вызова (один приёмник) */

int rx_acquire(rx_t *r, const uint8_t *const *x4, const uint32_t *t0, int nsnap, int len, int sig,
               uint64_t t_start, const acq_cfg_t *ac)
{
    int chs[CORR_MAXCH], n = 0;
    const sig_info_t *si = &SIGS[sig];
    RX = r;
    int glo = si->sys == SYS_GLO;
    /* BeiDou: только MEO/IGSO (D1); GEO (PRN 1–5, 59–63, сообщение D2) — не реализовано */
    int q0 = glo ? -7 : si->sys == SYS_BDS ? 6 : 1;
    int q1 = glo ? 6 : si->sys == SYS_GAL ? 36 : si->sys == SYS_BDS ? 58 : 32;
    for (int q = q0; q <= q1; q++) {
        int prn = glo ? 1 : q, fcn = glo ? q : 0;        /* ГЛОНАСС: код общий, перебор литер */
        int busy = 0;
        for (int k = 0; k < CORR_MAXCH; k++)
            if (r->ch[k].used && r->ch[k].sig == sig && (glo ? r->ch[k].fcn == fcn : r->ch[k].prn == prn)) busy = 1;
        if (busy) continue;
        acq_res_t a;
        if (!acq_search_multi(x4, t0, nsnap, len, sig, prn, fcn, ac, &a)) continue;
        int ch = corr_alloc(sig);
        if (ch < 0) break;
        double rate = si->chip_rate * (1 + a.doppler / sig_carrier(sig, fcn));
        double cps = a.code_phase + rate * (double)(int64_t)(t_start - t0[0]) / FS_HZ;
        corr_load_code(ch, sig, prn);
        rx_ch_t *c = &r->ch[ch];
        memset(c, 0, sizeof(*c));
        c->used = 1; c->ch = ch; c->sig = sig; c->prn = glo ? 0 : prn; c->fcn = fcn;
        trk_start(&c->trk, ch, sig, prn, fcn, a.doppler, cps, t_start, &r->tcfg);
        c->trk.on_bit = on_bit;
        c->trk.ctx = c;
        if (glo) glonav_init(&c->msg.gnav, fcn);
        else if (si->sys == SYS_GAL) inav_init(&c->msg.inav, prn);
        else if (si->sys == SYS_BDS) bdsnav_init(&c->msg.bnav, prn);
        else lnav_init(&c->msg.lnav, prn);
        chs[n++] = ch;
    }
    if (n) corr_start(chs, n, t_start);
    return n;
}

/* привязка времени излучения к эпохе кода, ближайшей к началу отсчёта n */
static void set_ref(rx_ch_t *c, uint64_t n, double tow)
{
    double cp;
    corr_phase_at(c->ch, n, &cp, NULL);
    if (cp > CORR[c->ch].L / 2) cp -= CORR[c->ch].L;          /* эпоха чуть позже начала отсчёта */
    c->ref_n = n;
    c->ref_code = corr_code_total_at(c->ch, n) - (uint64_t)(int64_t)llround(cp * TWO32);
    c->ref_tow = tow;
    c->tx_ok = 1;
}

/* опорная эпоха канала (граница подкадра, страницы, строки) на начало отсчёта n со временем
 * излучения tow (GPST); первая — начальная шкала приёмника (задержка распространения ≈ 75 мс) */
static void nav_ref(rx_t *r, rx_ch_t *c, uint64_t n, double tow)
{
    set_ref(c, n, tow);
    if (!r->time_ok) {
        r->t0_n = n;
        r->t0_tow = c->ref_tow + 0.075;
        r->time_ok = 1;
    }
}

/* ГЛОНАСС: символ 10 мс */
static void on_sym_glo(rx_ch_t *c, int sym, uint64_t n_end)
{
    rx_t *r = RX;
    glonav_t *g = &c->msg.gnav;
    if (!glonav_sym(g, sym ? -1.0 : 1.0, n_end)) return;
    if (!r->time_ok && g->n4 > 0 && g->na > 0 && g->str_end_tod >= 0) {
        /* шкала приёмника по ГЛОНАСС (без GPS): дата — из строки 5, задержка ≈ 75 мс */
        int wk;
        double sow = glo_date2gpst(g->n4, g->na, g->str_end_tod, &wk);
        r->t0_n = n_end + 1;
        r->t0_tow = sow + 0.075;
        r->week = wk;
        r->time_ok = 1;
    }
    if (!r->time_ok) return;                      /* сутки и неделя — по шкале приёмника */
    double tr = rx_time(r, n_end);
    if (g->eph_new) {
        eph_t e = g->eph;
        e.toc = e.toe = glo_tod2gpst(e.toc, tr);
        e.week = r->week;
        r->eph[SYS_GLO][g->slot] = e;
        c->prn = g->slot;
        g->eph_new = 0;
    }
    /* конец метки времени — конец строки и эпоха кода */
    if (g->str_end_tod >= 0) set_ref(c, n_end + 1, glo_tod2gpst(g->str_end_tod, tr));
}

/* Galileo E1-B: символ 4 мс, мягкое значение — точный отвод за период (> 0 — логический 0) */
static void on_sym_gal(rx_ch_t *c, uint64_t n_end)
{
    rx_t *r = RX;
    inav_t *g = &c->msg.inav;
    if (!inav_sym(g, c->trk.bit_acc, n_end)) return;
    if (g->eph_new) {
        r->eph[SYS_GAL][c->prn] = g->eph;
        r->week = g->eph.week;
        g->eph_new = 0;
    }
    if (g->utc_ok) r->dt_ls = g->dt_ls;
    /* конец страницы — эпоха кода внутри отсчёта n_end */
    if (g->tow_ok) nav_ref(r, c, n_end + 1, fmod(g->page_tow + 2.0, 604800.0));
}

/* BeiDou B1I: бит D1 20 мс (код NH снят). Ионосфера D1 (модель Клобучара по BDT в
 * географических координатах) в решение не передаётся — используются параметры GPS */
static void on_bit_bds(rx_ch_t *c, int bit, uint64_t n_end)
{
    rx_t *r = RX;
    bdsnav_t *b = &c->msg.bnav;
    if (!bdsnav_bit(b, bit, n_end)) return;
    nav_ref(r, c, n_end + 1, b->sf_end_tow);
    if (b->eph_new) {
        r->eph[SYS_BDS][c->prn] = b->eph;
        r->week = b->eph.week;
        b->eph_new = 0;
    }
}

static void on_bit(void *ctx, int bit, uint64_t n_end)
{
    rx_ch_t *c = ctx;
    rx_t *r = RX;
    int sys = SIGS[c->sig].sys;
    if (sys == SYS_GLO) { on_sym_glo(c, bit, n_end); return; }
    if (sys == SYS_GAL) { on_sym_gal(c, n_end); return; }
    if (sys == SYS_BDS) { on_bit_bds(c, bit, n_end); return; }
    lnav_t *nv = &c->msg.lnav;
    if (!lnav_bit(nv, bit, n_end)) return;
    /* граница подкадра: конец последнего бита — эпоха кода внутри отсчёта n_end */
    nav_ref(r, c, n_end + 1, nv->sf_end_tow);
    if (nv->eph_new) {
        r->eph[SYS_GPS][c->prn] = nv->eph;
        nv->eph_new = 0;
        r->week = nv->eph.week;
    }
    if (nv->ion_ok && !r->ion_ok) { memcpy(r->ion, nv->ion, sizeof(r->ion)); r->ion_ok = 1; }
    if (nv->ok_utc) r->dt_ls = nv->dt_ls;
}

/* время излучения по каналу на отсчёт n */
static double tx_time(const rx_ch_t *c, uint64_t n)
{
    uint64_t ct = corr_code_total_at(c->ch, n);
    return c->ref_tow + (double)(int64_t)(ct - c->ref_code) / TWO32 / SIGS[c->sig].chip_rate;
}

/* запуск L2CM по каналу L1 C/A того же КА: фаза кода — по времени излучения L1 (эпохи
 * L2CM — через 20 мс шкалы КА), доплер — пересчётом по частоте; поиск не нужен */
static void start_l2(rx_t *r, int k1, uint64_t n_now)
{
    rx_ch_t *c1 = &r->ch[k1];
    int ch = corr_alloc(SIG_L2CM);
    if (ch < 0) return;
    uint64_t ns = ((n_now + 24000) >> 2) << 2;              /* через 1 мс, начало группы */
    if (corr_start_pending(ch, n_now, ns)) { CORR[ch].used = 0; return; }   /* — при следующем вызове */
    double t1 = tx_time(c1, ns);
    double cp = fmod(t1, 0.020) * SIGS[SIG_L2CM].chip_rate;
    double dop = trk_doppler_smooth(&c1->trk) * sig_carrier(SIG_L2CM, 0) / sig_carrier(SIG_L1CA, 0);
    corr_load_code(ch, SIG_L2CM, c1->prn);
    rx_ch_t *c = &r->ch[ch];
    memset(c, 0, sizeof(*c));
    c->used = 1; c->ch = ch; c->sig = SIG_L2CM; c->prn = c1->prn; c->pair = k1 + 1;
    trk_start(&c->trk, ch, SIG_L2CM, c1->prn, 0, dop, cp, ns, &r->tcfg);
    int chs[1] = {ch};
    corr_start(chs, 1, ns);
    c1->pair = ch + 1;
}

void rx_process(rx_t *r, uint64_t n_now)
{
    corr_dump_t d;
    RX = r;
    for (int k = 0; k < CORR_MAXCH; k++) {
        rx_ch_t *c = &r->ch[k];
        if (!c->used) continue;
        while (corr_read(c->ch, &d, n_now)) trk_update(&c->trk, &d);
        if (c->trk.state == TRK_IDLE) {          /* срыв более 1 с — канал освобождается */
            if (c->pair && r->ch[c->pair - 1].pair == k + 1) r->ch[c->pair - 1].pair = 0;
            corr_free(c->ch);
            c->used = 0;
            continue;
        }
        if (r->dual && c->sig == SIG_L1CA && !c->pair && c->tx_ok && c->trk.state == TRK_LOCK)
            start_l2(r, k, n_now);
    }
}

/* фаза несущей канала на отсчёт n, м (знак — как у дальности) */
static double carr_m(const rx_ch_t *c, uint64_t n)
{
    double cyc;
    corr_phase_at(c->ch, n, NULL, &cyc);
    return -cyc * CLIGHT / sig_carrier(c->sig, c->fcn);
}

/* сглаживание кода по фазе несущей (фильтр Хэтча): Ps = P/m + (Ps' + ΔΦ)·(m − 1)/m,
 * m — число измерений, не более окна r->smooth. Сброс — при срыве слежения, перерыве
 * в измерениях более 5 с и расхождении кода и фазы более 30 м (проскок фазы). */
static double hatch(const rx_t *r, rx_ch_t *c, double p, double phi, double t)
{
    double dt = t - c->hs_t;
    if (r->smooth > 0 && c->hs_n > 0 && dt > 0 && dt < 5.0) {
        double pred = c->hs_p + (phi - c->hs_l);
        if (fabs(p - pred) < 30.0) {
            double mmax = r->smooth / dt, m = c->hs_n + 1 < mmax ? c->hs_n + 1 : mmax;
            if (m < 1) m = 1;
            c->hs_p = p / m + pred * (m - 1) / m;
            c->hs_l = phi; c->hs_t = t; c->hs_n++;
            return c->hs_p;
        }
    }
    c->hs_n = 1; c->hs_p = p; c->hs_l = phi; c->hs_t = t;
    return p;
}

int rx_measure(rx_t *r, uint64_t n_m)
{
    if (!r->time_ok) return 0;
    double trx = rx_time(r, n_m);
    int n = 0;
    for (int k = 0; k < CORR_MAXCH; k++) {
        rx_ch_t *c = &r->ch[k];
        if (!c->used || c->sig == SIG_L2CM) continue;
        rx_ch_t *c2 = c->pair ? &r->ch[c->pair - 1] : NULL;
        if (!c->tx_ok || c->trk.state != TRK_LOCK) {
            c->hs_n = 0;
            if (c2) c2->hs_n = 0;
            continue;
        }
        int sys = SIGS[c->sig].sys;
        if (c->prn < 1 || c->prn > 63) continue;
        const sig_info_t *si = &SIGS[c->sig];
        uint64_t ct = corr_code_total_at(c->ch, n_m);
        double ttx = c->ref_tow + (double)(int64_t)(ct - c->ref_code) / TWO32 / si->chip_rate;
        /* ПД сглаживаются и до приёма эфемерид */
        double p1 = hatch(r, c, CLIGHT * eph_tdiff(trx, ttx), carr_m(c, n_m), trx), p2 = 0;
        int dual = 0;
        /* L2CM: время внутри периода 20 мс — по фазе кода, целые периоды — по L1 */
        if (c2 && c2->used && c2->trk.state == TRK_LOCK) {
            uint64_t ct2 = corr_code_total_at(c2->ch, n_m);
            double tc = fmod((double)ct2 / TWO32 / SIGS[SIG_L2CM].chip_rate, 0.020);
            double dt = fmod(tc - ttx, 0.020);
            if (dt > 0.010) dt -= 0.020;
            if (dt < -0.010) dt += 0.020;
            p2 = hatch(r, c2, CLIGHT * eph_tdiff(trx, ttx + dt), carr_m(c2, n_m), trx);
            dual = 1;
        } else if (c2) c2->hs_n = 0;
        eph_t *e = &r->eph[sys][c->prn];
        if (!e->valid || n >= PVT_MAXOBS) continue;
        obs_t *o = &r->obs[n];
        memset(o, 0, sizeof(*o));
        o->sys = sys; o->prn = c->prn;
        o->pr = o->pr1 = p1;
        if (dual) {
            double f1 = sig_carrier(SIG_L1CA, 0), f2 = sig_carrier(SIG_L2CM, 0), g = f1 * f1 / (f2 * f2);
            o->pr2 = p2;
            o->pr = (g * p1 - p2) / (g - 1);
            o->iono_free = 1;
        }
        o->dop = trk_doppler(&c->trk);
        o->fc = sig_carrier(c->sig, c->fcn);
        o->cn0 = c->trk.cn0;
        o->eph = e;
        n++;
    }
    r->nobs = n;
    if (n < 4) return 0;
    memcpy(r->pcfg.ion, r->ion, sizeof(r->ion));
    r->pcfg.iono = r->ion_ok;
    sol_t s = r->sol;
    if (!pvt_solve(r->obs, n, trx, &r->pcfg, &s)) return 0;
    r->sol = s;
    r->sol_n = n_m;
    r->n_sol++;
    return 1;
}

int rx_pps_next(const rx_t *r, uint64_t n_now, uint64_t *t96, double *qerr, double *sec)
{
    if (!r->n_sol) return 0;
    const sol_t *s = &r->sol;
    /* GPST(n) = t_rx(n) − (b + ḃ·Δt)/c, Δt — от эпохи решения */
    double tm = s->t_rx;                                  /* GPST на отсчёте sol_n */
    double rate = 1.0 - s->clkd / CLIGHT;                 /* секунд GPST на секунду шкалы приёмника */
    double tn = tm + (double)(int64_t)(n_now - r->sol_n) / FS_HZ * rate;
    double S = floor(tn) + 1.0;
    double nx = (double)r->sol_n + (S - tm) / rate * FS_HZ; /* дробный номер отсчёта */
    double x96 = nx * 4.0;
    double xi = floor(x96 + 0.5);
    *t96 = (uint64_t)xi - 1 - PPS_DELAY_T96;              /* импульс — в конце такта PPS_T */
    *qerr = (x96 - xi) / F96_HZ;
    if (sec) *sec = S;
    return 1;
}
