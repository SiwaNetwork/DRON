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
 * системам).
 * Двухчастотный режим (r->dual): по каналу первой частоты запускается канал второй — пары
 * L1 C/A + L2CM или L5Q, G1 + G2, E1-B + E5a-Q, B1I + B3I; ПД второй частоты — по фазе её кода
 * внутри периода и времени излучения первой, в решение — ионосферно-свободная комбинация с
 * поправкой часов КА на групповую задержку комбинации (sig_gd). */
#include <math.h>
#include <string.h>
#include "fpga.h"
#include "codes.h"
#include "rx.h"

#define TWO32 4294967296.0

void rx_init(rx_t *r)
{
    memset(r, 0, sizeof(*r));
    pvt_default_cfg(&r->pcfg);
    trk_default_cfg(&r->tcfg);
    r->dt_ls = (int)GPST_UTC;
    r->smooth = 100.0;
    for (int s = 0; s < SYS_N; s++) r->sig2[s] = -1;
    r->sig2[SYS_GPS] = SIG_L2CM;
    r->sig2[SYS_GLO] = SIG_G2CA;
    r->sig2[SYS_GAL] = SIG_E5AQ;
    r->sig2[SYS_BDS] = SIG_B3I;
}

static const int EPH_N[SYS_N] = RX_EPH_N;
typedef char eph_n_check[(33 + 32 + 37 + 64 + 11 + 15 + 40 == RX_NEPH && SYS_N == 7) ? 1 : -1];

eph_t *rx_eph(rx_t *r, int sys, int prn)
{
    if (sys < 0 || sys >= SYS_N || prn < 0 || prn >= EPH_N[sys]) return NULL;
    int off = 0;
    for (int s = 0; s < sys; s++) off += EPH_N[s];
    return &r->eph[off + prn];
}

double rx_time(const rx_t *r, uint64_t n)
{
    return r->t0_tow + (double)(int64_t)(n - r->t0_n) / FS_HZ;
}

static void on_bit(void *ctx, int bit, uint64_t n_end);
static rx_t *RX;                     /* для обратного вызова (один приёмник) */

static void lock(const rx_t *r, int on) { if (r->lock) r->lock(on); }

int rx_tracked(const rx_t *r, int sig, int q)
{
    int glo = SIGS[sig].sys == SYS_GLO;
    for (int k = 0; k < CORR_MAXCH; k++)
        if (r->ch[k].used && r->ch[k].sig == sig && (glo ? r->ch[k].fcn == q : r->ch[k].prn == q)) return 1;
    return 0;
}

static int msg_free(const rx_t *r)
{
    int m = 0;
    while (m < RX_NMSG && r->msg_busy[m]) m++;
    return m;
}

/* занятие канала и декодера, загрузка кода, пуск слежения по результату поиска a (фаза кода — на
 * отсчёт tref, мл. 32 бит) — под блокировкой; weak — втягивание слабого сигнала */
static int ch_start(rx_t *r, int sig, int q, const acq_res_t *a, uint32_t tref, uint64_t t_start, int weak,
                    int *chp)
{
    const sig_info_t *si = &SIGS[sig];
    int glo = si->sys == SYS_GLO;
    int prn = glo ? 1 : q, fcn = glo ? q : 0;            /* ГЛОНАСС: код общий, перебор литер */
    lock(r, 1);
    int m = msg_free(r);
    int ch = m < RX_NMSG ? corr_alloc(sig) : -1;
    if (ch < 0) { lock(r, 0); return -1; }
    uint64_t ts = t_start ? t_start : corr_start_next(ch, corr_time_now());
    double rate = si->chip_rate * (1 + a->doppler / sig_carrier(sig, fcn));
    /* tref — мл. 32 бит номера отсчёта (переполнение через 179 с): разность — по модулю 2^32 */
    double cps = a->code_phase + rate * (double)(int32_t)((uint32_t)ts - tref) / FS_HZ;
    corr_load_code(ch, sig, prn);
    rx_ch_t *c = &r->ch[ch];
    memset(c, 0, sizeof(*c));
    c->ch = ch; c->sig = sig; c->prn = glo ? 0 : prn; c->fcn = fcn;
    trk_cfg_t tc = r->tcfg;
    tc.weak = weak;
    trk_start(&c->trk, ch, sig, prn, fcn, a->doppler, cps, ts, &tc);
    c->trk.on_bit = on_bit;
    c->trk.ctx = c;
    r->msg_busy[m] = 1;
    c->msg = &r->msg[m];
    if (glo) glonav_init(&c->msg->gnav, fcn);
    else if (si->sys == SYS_GAL) inav_init(&c->msg->inav, prn);
    else if (si->sys == SYS_BDS) bdsnav_init(&c->msg->bnav, prn);
    else lnav_init(&c->msg->lnav, prn);
    c->used = 1;                                         /* канал готов — виден rx_process */
    if (!t_start) corr_start(&ch, 1, ts);
    lock(r, 0);
    *chp = ch;
    return 1;
}

/* поиск КА q (PRN; ГЛОНАСС — литера) и настройка канала слежения. t_start ≠ 0 — пуск на этот
 * отсчёт выполняет вызывающий (общий для группы), t_start = 0 — пуск сразу (≈ 1 мс после
 * поиска). 1 — канал настроен (*chp), 0 — КА уже в слежении или не найден, −1 — нет свободного
 * канала или декодера сообщений. Поиск — без блокировки; занятие канала и декодера, загрузка
 * кода и пуск — под блокировкой (общие с rx_process данные и регистры движка) */
static int acq_one(rx_t *r, const uint8_t *const *x4, const uint32_t *t0, int nsnap, int len, int sig,
                   int q, uint64_t t_start, const acq_cfg_t *ac, int *chp)
{
    int glo = SIGS[sig].sys == SYS_GLO;
    if (rx_tracked(r, sig, q)) return 0;
    if (msg_free(r) == RX_NMSG) return -1;
    acq_res_t a;
    if (!acq_search_multi(x4, t0, nsnap, len, sig, glo ? 1 : q, glo ? q : 0, ac, &a)) return 0;
    return ch_start(r, sig, q, &a, t0[0], t_start, 0, chp);
}

static void sig_range(int sig, int *q0, int *q1)
{
    const sig_info_t *si = &SIGS[sig];
    int glo = si->sys == SYS_GLO;
    /* BeiDou: только MEO/IGSO (D1); GEO (PRN 1–5, 59–63, сообщение D2) — не реализовано */
    *q0 = glo ? -7 : si->sys == SYS_BDS ? 6 : 1;
    *q1 = glo ? 6 : si->sys == SYS_GAL ? 36 : si->sys == SYS_BDS ? 58 : 32;
}

int rx_acquire(rx_t *r, const uint8_t *const *x4, const uint32_t *t0, int nsnap, int len, int sig,
               uint64_t t_start, const acq_cfg_t *ac)
{
    int chs[CORR_MAXCH], n = 0, q0, q1;
    RX = r;
    sig_range(sig, &q0, &q1);
    for (int q = q0; q <= q1; q++) {
        int ch, s = acq_one(r, x4, t0, nsnap, len, sig, q, t_start, ac, &ch);
        if (s < 0) break;
        if (s > 0) chs[n++] = ch;
    }
    if (n && t_start) { lock(r, 1); corr_start(chs, n, t_start); lock(r, 0); }
    return n;
}

int rx_acquire_one(rx_t *r, const uint8_t *const *x4, const uint32_t *t0, int nsnap, int len, int sig,
                   int q, const acq_cfg_t *ac)
{
    int ch;
    RX = r;
    return acq_one(r, x4, t0, nsnap, len, sig, q, 0, ac, &ch);
}

int rx_start(rx_t *r, int sig, int q, const acq_res_t *a, uint32_t tref, int weak)
{
    int ch;
    RX = r;
    if (rx_tracked(r, sig, q)) return 0;
    return ch_start(r, sig, q, a, tref, 0, weak, &ch);
}

int rx_sig_range(int sig, int *q0, int *q1) { sig_range(sig, q0, q1); return *q1 - *q0 + 1; }

/* Ложный захват взаимно-корреляционного пика. ВКФ кодов L1 C/A — до −21…−24 дБ: у КА 45 дБГц это
 * «сигнал» 21–24 дБГц, и при девяти сильных КА максимум по ячейкам ускорителя (256 мс) — у порога
 * (z ≈ 6, порог 6,5), а часть превышает его. Захват такого пика — на частоте сильного КА
 * + k·1 кГц (произведение кодов периодично с периодом 1 мс), уровень — ВКФ кодов на разности
 * фаз кода каналов с поворотом на разность частот. Канал ложный, если уровень, ожидаемый по
 * C/N0 сильного КА, не ниже C/N0 канала минус запас. Проверка — после синхронизации по битам
 * (оценка C/N0 — по когерентной сумме бита). Для случайной фазы кода уровень ВКФ ≈ −30 дБ,
 * поэтому настоящий слабый сигнал отбрасывается, лишь если его частота в пределах допуска от
 * линии сильного КА и фаза кода — на пике ВКФ (вероятность < 10^−3 при 45 и 29 дБГц) */
#define RX_XC_DELAY  0.5             /* с после синхронизации по битам */
#define RX_XC_DF     10.0            /* допуск отклонения разности частот от кратной 1 кГц, Гц */
#define RX_XC_MIN    10.0            /* сильный КА — выше по C/N0 не менее чем на, дБ */
#define RX_XC_MARGIN 6.0             /* запас по уровню, дБ */
#define RX_XC_MAX    8               /* сильных КА на проверку */

/* |ВКФ| / L кода prn_s (принятый) и кода prn_c (копия) при сдвиге копии lag (чипы, дробный —
 * линейная интерполяция) и разности частот df (Гц); коды с периодом 1 мс до 1024 чипов */
static double xc_level(int sig, int prn_s, int prn_c, double lag, double df)
{
    static uint8_t cs[CODE_MAX_BYTES], cc[CODE_MAX_BYTES];
    const sig_info_t *si = &SIGS[sig];
    int L = si->code_len;
    code_gen(sig, prn_s, cs);
    code_gen(sig, prn_c, cc);
    lag = fmod(lag, (double)L);
    if (lag < 0) lag += L;
    int l0 = (int)lag;
    double e = lag - l0, w = 2 * GPI * df / si->chip_rate, cr = cos(w), ci = sin(w), rr = 1, ri = 0;
    double ar = 0, ai = 0, br = 0, bi = 0;
    for (int m = 0, j = l0; m < L; m++) {
        int a = code_bit(cs, m), j1 = j + 1 < L ? j + 1 : 0;
        double b0 = a == code_bit(cc, j) ? 1 : -1, b1 = a == code_bit(cc, j1) ? 1 : -1;
        ar += b0 * rr; ai += b0 * ri;
        br += b1 * rr; bi += b1 * ri;
        double t = rr * cr - ri * ci; ri = rr * ci + ri * cr; rr = t;
        j = j1;
    }
    return hypot((1 - e) * ar + e * br, (1 - e) * ai + e * bi) / L;
}

int rx_xcheck(rx_t *r)
{
    int nrel = 0;
    for (int k = 0; k < CORR_MAXCH; k++) {
        rx_ch_t *c = &r->ch[k];
        /* отбор без блокировки (поля могут меняться в прерывании), проверка и копия — под ней */
        if (!c->used || c->f2 || !c->trk.weak || c->xc || !c->trk.bit_sync) continue;
        if (c->xc_t != 0 && c->trk.t < c->xc_t + RX_XC_DELAY) continue;
        lock(r, 1);
        if (!c->used || c->f2 || !c->trk.weak || c->xc || !c->trk.bit_sync || c->trk.state != TRK_LOCK ||
            SIGS[c->sig].code_len > 1024) {
            lock(r, 0);
            continue;
        }
        if (c->xc_t == 0) c->xc_t = c->trk.t;
        if (c->trk.t < c->xc_t + RX_XC_DELAY) { lock(r, 0); continue; }
        int sig = c->sig, prn = c->prn, ns = 0, ps[RX_XC_MAX];
        double t_mark = c->xc_t, cn0 = c->trk.cn0, f = trk_doppler(&c->trk), cp, dl[RX_XC_MAX], df[RX_XC_MAX],
               cn_s[RX_XC_MAX];
        uint64_t n = corr_time_now();
        corr_phase_at(c->ch, n, &cp, NULL);
        for (int j = 0; j < CORR_MAXCH && ns < RX_XC_MAX; j++) {
            const rx_ch_t *s = &r->ch[j];
            if (j == k || !s->used || s->f2 || s->sig != sig || s->trk.state != TRK_LOCK ||
                s->trk.cn0 < cn0 + RX_XC_MIN)
                continue;
            double d = f - trk_doppler(&s->trk);
            if (fabs(d - 1000.0 * floor(d / 1000.0 + 0.5)) > RX_XC_DF) continue;
            double cps;
            corr_phase_at(s->ch, n, &cps, NULL);
            ps[ns] = s->prn; dl[ns] = cp - cps; df[ns] = d; cn_s[ns] = s->trk.cn0;
            ns++;
        }
        lock(r, 0);
        /* уровни ВКФ — без блокировки */
        int bad = 0;
        for (int i = 0; i < ns && !bad; i++)
            bad = cn_s[i] + 20 * log10(xc_level(sig, ps[i], prn, dl[i], df[i]) + 1e-9) > cn0 - RX_XC_MARGIN;
        lock(r, 1);
        if (c->used && c->prn == prn && c->xc_t == t_mark) {
            if (bad) c->trk.state = TRK_IDLE;            /* канал освобождает rx_process */
            else c->xc = 1;
        }
        lock(r, 0);
        nrel += bad;
    }
    return nrel;
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
    glonav_t *g = &c->msg->gnav;
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
        eph_t *d = rx_eph(r, SYS_GLO, g->slot);
        if (d) *d = e;
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
    inav_t *g = &c->msg->inav;
    if (!inav_sym(g, c->trk.bit_acc, n_end)) return;
    if (g->eph_new) {
        eph_t *d = rx_eph(r, SYS_GAL, c->prn);
        if (d) *d = g->eph;
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
    bdsnav_t *b = &c->msg->bnav;
    if (!bdsnav_bit(b, bit, n_end)) return;
    nav_ref(r, c, n_end + 1, b->sf_end_tow);
    if (b->eph_new) {
        eph_t *d = rx_eph(r, SYS_BDS, c->prn);
        if (d) *d = b->eph;
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
    lnav_t *nv = &c->msg->lnav;
    if (!lnav_bit(nv, bit, n_end)) return;
    /* граница подкадра: конец последнего бита — эпоха кода внутри отсчёта n_end */
    nav_ref(r, c, n_end + 1, nv->sf_end_tow);
    if (nv->eph_new) {
        eph_t *d = rx_eph(r, SYS_GPS, c->prn);
        if (d) *d = nv->eph;
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

/* сигнал второй частоты для канала первой (−1 — нет) */
static int sig_second(const rx_t *r, int sig)
{
    if (!r->dual || (sig != SIG_L1CA && sig != SIG_G1CA && sig != SIG_E1B && sig != SIG_B1I)) return -1;
    return r->sig2[SIGS[sig].sys];
}

/* групповая задержка сигнала относительно опорной для часов КА в эфемеридах, с (часы КА для
 * сигнала — Δt − gd): GPS LNAV — комбинация L1/L2 (L1 — TGD, L2 — γ12·TGD; L5 — TGD при
 * ISC_L5 = 0, CNAV не декодируется); Galileo I/NAV — E1/E5b (E1 — BGD(E1,E5b), E5a —
 * BGD(E1,E5b) + (γ − 1)·BGD(E1,E5a)); BeiDou D1 — B3I (B1I — TGD1); ГЛОНАСС — L1 (L2 — Δτn) */
static double sig_gd(const eph_t *e, int sig)
{
    double f1, f2;
    switch (sig) {
    case SIG_L1CA: case SIG_L5I: case SIG_L5Q: return e->tgd;
    case SIG_L2CM:
        f1 = sig_carrier(SIG_L1CA, 0); f2 = sig_carrier(SIG_L2CM, 0);
        return f1 * f1 / (f2 * f2) * e->tgd;
    case SIG_E1B: case SIG_E1C: return e->tgd;
    case SIG_E5AI: case SIG_E5AQ:
        f1 = sig_carrier(SIG_E1B, 0); f2 = sig_carrier(SIG_E5AQ, 0);
        return e->tgd + (f1 * f1 / (f2 * f2) - 1) * e->tgd2;
    case SIG_B1I: return e->tgd;
    case SIG_G2CA: return e->tgd2;
    default: return 0;
    }
}

/* запуск канала второй частоты sig2 по каналу первой k1 того же КА без поиска: фаза кода — по
 * времени излучения на первой частоте за вычетом разности ионосферных задержек (модель
 * Клобучара по последнему решению, если есть; эпохи кода — через период кода по шкале КА,
 * вторичный код синхронизируется при слежении), доплер — пересчётом по частоте */
static void start_second(rx_t *r, int k1, int sig2, uint64_t n_now)
{
    rx_ch_t *c1 = &r->ch[k1];
    int ch = corr_alloc(sig2);
    if (ch < 0) return;
    uint64_t ns = ((n_now + 24000) >> 2) << 2;              /* через 1 мс, начало группы */
    if (corr_start_pending(ch, n_now, ns)) { CORR[ch].used = 0; return; }   /* — при следующем вызове */
    const sig_info_t *s2 = &SIGS[sig2];
    int sys = SIGS[c1->sig].sys, glo = sys == SYS_GLO;
    double f1 = sig_carrier(c1->sig, c1->fcn), f2 = sig_carrier(sig2, c1->fcn), g = f1 * f1 / (f2 * f2);
    double diono = 0;
    if (r->n_sol > 0 && r->ion_ok)
        for (int i = 0; i < r->nobs; i++)
            if (r->obs[i].sys == sys && r->obs[i].prn == c1->prn && r->obs[i].el > 0) {
                double fl1 = sig_carrier(SIG_L1CA, 0);
                double i1 = pvt_klobuchar(r->ion, r->sol.t_rx, r->sol.lat, r->sol.lon, r->obs[i].az,
                                          r->obs[i].el) * fl1 * fl1 / (f1 * f1);
                diono = (g - 1) * i1 / CLIGHT;
                break;
            }
    double per = s2->code_len / s2->chip_rate;
    double t2 = tx_time(c1, ns) - diono;
    double cp = (t2 - floor(t2 / per) * per) * s2->chip_rate;
    double dop = trk_doppler_smooth(&c1->trk) * f2 / f1;
    int prn = glo ? 1 : c1->prn;                            /* ГЛОНАСС: код общий */
    corr_load_code(ch, sig2, prn);
    rx_ch_t *c = &r->ch[ch];
    memset(c, 0, sizeof(*c));
    c->used = 1; c->ch = ch; c->sig = sig2; c->prn = c1->prn; c->fcn = c1->fcn;
    c->f2 = 1; c->pair = k1 + 1;
    trk_start(&c->trk, ch, sig2, prn, c1->fcn, dop, cp, ns, &r->tcfg);
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
        /* срыв более 1 с — канал освобождается; канал второй частоты — и без канала первой */
        if (c->trk.state == TRK_IDLE || (c->f2 && !c->pair)) {
            if (c->pair && r->ch[c->pair - 1].pair == k + 1) r->ch[c->pair - 1].pair = 0;
            corr_free(c->ch);
            if (c->msg) r->msg_busy[c->msg - r->msg] = 0;
            c->msg = NULL;
            c->used = 0;
            continue;
        }
        int s2 = c->f2 ? -1 : sig_second(r, c->sig);
        if (s2 >= 0 && !c->pair && c->tx_ok && c->trk.state == TRK_LOCK)
            start_second(r, k, s2, n_now);
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
 * в измерениях более 5 с и расхождении кода и фазы более 30 м (проскок фазы).
 * hs_m — эффективное число независимых измерений: до заполнения окна — m (среднее),
 * затем 2m − 1 (экспоненциальное среднее); при интервале короче времени корреляции шума ССЗ
 * 1/(2Bn) — с множителем 2Bn·dt */
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
            double ind = 2 * c->trk.dll_k / 4 * dt;
            c->hs_m = (c->hs_n < mmax ? c->hs_n : 2 * mmax - 1) * (ind < 1 ? ind : 1);
            if (c->hs_m < 1) c->hs_m = 1;
            return c->hs_p;
        }
    }
    c->hs_n = 1; c->hs_m = 1; c->hs_p = p; c->hs_l = phi; c->hs_t = t;
    return p;
}

/* дисперсия шума кода канала (тепловой шум ССЗ с поддержкой от несущей: когерентный
 * дискриминатор (E − L)/(E + L), Kaplan) после сглаживания, м²:
 * σ² = h·s·Bn/(C/N0)·(1 + 1/(T·C/N0·(1 − s/h)))·λc²/m + σ0²,
 * h — полуширина пика корреляции (BPSK — 1 чип, TDM L2C — 0,5, BOC(1,1) — 1/3), s — смещение
 * отводов E/L, Bn — полоса ССЗ, T — время когерентного накопления, λc — длина чипа, m — hs_m;
 * σ0 = 0,3 м — остаточные ошибки (многолучёвость, не усредняемая сглаживанием) */
static double code_var(const rx_ch_t *c)
{
    const trk_t *k = &c->trk;
    const sig_info_t *si = &SIGS[c->sig];
    double cn0 = pow(10.0, (k->cn0 > 20.0 ? k->cn0 : k->cn0 > 0 ? 20.0 : 35.0) / 10.0);
    double h = si->boc ? 1.0 / 3.0 : k->dll_hw, s = k->spacing < h / 2 ? k->spacing : h / 2;
    double bn = k->dll_k / 4, T = k->T * (k->ncoh > 1 ? k->ncoh : 1), lc = CLIGHT / si->chip_rate;
    double v = h * s * bn / cn0 * (1 + 1 / (T * cn0 * (1 - s / h))) * lc * lc;
    return v / (c->hs_m > 1 ? c->hs_m : 1) + 0.09;
}

int rx_latch(rx_t *r, uint64_t n_m)
{
    if (!r->time_ok) return -1;
    double trx = rx_time(r, n_m);
    int n = 0;
    for (int k = 0; k < CORR_MAXCH; k++) {
        rx_ch_t *c = &r->ch[k];
        if (!c->used || c->f2) continue;
        rx_ch_t *c2 = c->pair ? &r->ch[c->pair - 1] : NULL;
        if (!c->tx_ok || c->trk.state != TRK_LOCK || (c->trk.weak && !c->xc)) {
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
        /* вторая частота: время внутри периода кода — по фазе кода (с точностью до разности
         * задержек, много меньше полупериода), целые периоды — по первой частоте */
        if (c2 && c2->used && c2->trk.state == TRK_LOCK) {
            const sig_info_t *s2 = &SIGS[c2->sig];
            double per = s2->code_len / s2->chip_rate, cp2;
            corr_phase_at(c2->ch, n_m, &cp2, NULL);
            double dt = fmod(cp2 / s2->chip_rate - fmod(ttx, per), per);
            if (dt > per / 2) dt -= per;
            if (dt < -per / 2) dt += per;
            p2 = hatch(r, c2, CLIGHT * eph_tdiff(trx, ttx + dt), carr_m(c2, n_m), trx);
            dual = 1;
        } else if (c2) c2->hs_n = 0;
        eph_t *e = rx_eph(r, sys, c->prn);
        if (!e || !e->valid || n >= PVT_MAXOBS) continue;
        obs_t *o = &r->obs[n];
        memset(o, 0, sizeof(*o));
        o->sys = sys; o->prn = c->prn;
        o->pr = o->pr1 = p1;
        o->var = code_var(c);
        if (dual) {
            double f1 = sig_carrier(c->sig, c->fcn), f2 = sig_carrier(c2->sig, c2->fcn), g = f1 * f1 / (f2 * f2);
            o->pr2 = p2;
            o->pr = (g * p1 - p2) / (g - 1);
            o->gd = (g * sig_gd(e, c->sig) - sig_gd(e, c2->sig)) / (g - 1);
            o->var = (g * g * o->var + code_var(c2)) / ((g - 1) * (g - 1));
            o->iono_free = 1;
        }
        o->dop = trk_doppler(&c->trk);
        o->fc = sig_carrier(c->sig, c->fcn);
        o->cn0 = c->trk.cn0;
        o->eph = e;
        n++;
    }
    r->nobs = n;
    return n;
}

int rx_solve(rx_t *r, uint64_t n_m)
{
    if (r->nobs < 4) return 0;
    memcpy(r->pcfg.ion, r->ion, sizeof(r->ion));
    r->pcfg.iono = r->ion_ok;
    sol_t s = r->sol;
    if (!pvt_solve(r->obs, r->nobs, rx_time(r, n_m), &r->pcfg, &s)) return 0;
    r->sol = s;
    r->sol_n = n_m;
    r->n_sol++;
    return 1;
}

int rx_measure(rx_t *r, uint64_t n_m)
{
    return rx_latch(r, n_m) >= 4 && rx_solve(r, n_m);
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
