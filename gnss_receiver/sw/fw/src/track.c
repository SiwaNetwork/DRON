/* МГП-8: слежение за сигналом по результатам аппаратного коррелятора.
 * Петли (sw/pyrx/track.py, Kaplan табл. 5.6): ФАП 2-го порядка с поддержкой ЧАП 1-го порядка
 * (ЧАП — на этапе втягивания), ССЗ 1-го порядка с поддержкой от несущей, дискриминатор
 * «ранний минус поздний» по огибающей, нормированный. Новые частоты записываются в ПЛИС и
 * вступают в силу после следующего сброса (задержка петли — один интервал).
 * Слабые сигналы: после синхронизации по битам результаты периодов кода когерентно
 * накапливаются в ПО на интервале бита (20 мс для L1 C/A), петли — раз в бит с узкими полосами
 * (ФАП 5 Гц без ЧАП, ССЗ 0,2 Гц); C/N0 и биты по-прежнему оцениваются по периодам.
 * Пилотные составляющие с вторичным кодом (E1C, L5Q): до синхронизации по вторичному коду —
 * дискриминатор Костаса; после — снятие вторичного кода, четырёхквадрантная ФАП (без
 * неоднозначности фазы), при слабом сигнале — когерентное накопление ≈ 20 мс.
 * Данные с вторичным кодом (B1I, код NH на интервале бита D1): граница бита — по синхронизации
 * по коду NH, затем код снимается (знак — данные, ФАП — Костаса). E1-B: символ — период кода. */
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include "gnss.h"
#include "corr.h"
#include "track.h"

void trk_default_cfg(trk_cfg_t *c)
{
    c->pll_bw = 15.0;
    c->pll_bw_lock = 10.0;
    c->fll_bw = 5.0;
    c->fll_bw_lock = 1.0;
    c->dll_bw = 1.0;
    c->spacing = 0.5;
    c->fll_time = 0.15;
    c->long_cn0 = 32.0;
    c->pll_bw_long = 5.0;
    c->dll_bw_long = 0.2;
    c->coast_time = 30.0;
    c->pll_order = 3;
    c->pll_bw3 = 18.0;
    c->reacq_thr = 4.5;      /* шум: P(max(E,P,L) > 4,5·среднее) ≈ 0,033; 5 из 8 — ≈ 2·10^−6 на интервал */
}

void trk_start(trk_t *k, int ch, int sig, int prn, int fcn, double doppler, double code_phase,
               uint64_t t_start, const trk_cfg_t *cfg)
{
    const sig_info_t *si = &SIGS[sig];
    memset(k, 0, sizeof(*k));
    k->ch = ch; k->sig = sig; k->prn = prn; k->fcn = fcn;
    k->state = TRK_PULLIN;
    k->T = si->code_len / si->chip_rate;
    k->f_if = sig_if(sig, fcn);
    k->fc = sig_carrier(sig, fcn);
    k->f0 = k->f_if + doppler;
    k->f_carr = k->f0;
    k->f_code = si->chip_rate * (1 + doppler / k->fc);
    /* полосы ограничены условием Bn·T ≤ 0,1 (устойчивость дискретной петли при длинном
     * периоде кода, например L2CM — 20 мс; новые шаги NCO действуют со следующего интервала,
     * и при 0,15 втягивание L2CM срывалось) */
    double bmax = 0.1 / k->T;
    double wn = (cfg->pll_bw < bmax ? cfg->pll_bw : bmax) / 0.53;
    k->a2 = 1.414 * wn;
    k->w2 = wn * wn;
    k->wf = (cfg->fll_bw < bmax ? cfg->fll_bw : bmax) / 0.25;
    /* длинный период кода (L2CM, L1C — 10…20 мс): ССЗ с поддержкой от несущей в узкой полосе
     * (динамику снимает ФАП) — шум кода, усиливаемый ионосферно-свободной комбинацией */
    k->dll_k = 4 * (k->T >= 0.01 ? cfg->dll_bw_long : cfg->dll_bw);
    k->spacing = si->boc && cfg->spacing > 0.15 ? 0.15 : cfg->spacing;   /* BOC(1,1): узкий E–L */
    /* TDM (L2C): копия CM занимает первую половину чипа — пик корреляции вдвое уже */
    k->dll_hw = si->tdm ? 0.5 : 1.0;
    if (k->spacing > k->dll_hw / 2) k->spacing = k->dll_hw / 2;
    k->fll_time = cfg->fll_time;
    k->pll_bw_lock = cfg->pll_bw_lock < bmax ? cfg->pll_bw_lock : bmax;
    k->fll_bw_lock = cfg->fll_bw_lock < bmax ? cfg->fll_bw_lock : bmax;
    k->cn0 = 0;
    k->sec_len = sec_code(sig, prn, k->sec);
    /* синхронизация по символам данных: L1 C/A — биты 20 мс, ГЛОНАСС — символы 10 мс (меандр),
     * B1I (D1, с кодом NH) — биты 20 мс, E1-B — символ на период кода (граница известна сразу) */
    k->bit_len = sig == SIG_L1CA || (sig == SIG_B1I && k->sec_len) ? 20 :
                 (sig == SIG_G1CA || sig == SIG_G2CA) ? 10 : sig == SIG_E1B ? 1 : 0;
    k->bit_sync = k->bit_len == 1;
    k->long_cn0 = cfg->long_cn0;
    k->pll_bw_long = cfg->pll_bw_long;
    k->dll_bw_long = cfg->dll_bw_long;
    k->ncoh = 1;
    k->coast_time = cfg->coast_time;
    k->pll_order = k->T >= 0.01 ? 2 : cfg->pll_order;   /* 3-й порядок — при коротком периоде */
    k->pll_bw3 = cfg->pll_bw3 < bmax ? cfg->pll_bw3 : bmax;
    k->reacq_thr = cfg->reacq_thr;
    corr_config(ch, sig, prn, fcn, 1, k->spacing, k->f_carr, k->f_code, code_phase, 0.0, t_start);
}

static void bit_sync(trk_t *k, double I, const corr_dump_t *d)
{
    int s = I >= 0 ? 1 : -1;
    if (!k->bit_sync) {
        int L = k->bit_len;
        if (k->prev_sign && s != k->prev_sign) k->bit_hist[k->n_epoch % (uint64_t)L]++;
        k->prev_sign = s;
        int best = 0, second = 0, bi = 0, tot = 0;
        for (int i = 0; i < L; i++) {
            tot += k->bit_hist[i];
            if (k->bit_hist[i] > best) { second = best; best = k->bit_hist[i]; bi = i; }
            else if (k->bit_hist[i] > second) second = k->bit_hist[i];
        }
        if (best >= 8 && best > 4 * second + 2) {
            k->bit_sync = 1;
            /* переход знака между интервалами bi−1 и bi: интервал bi — первый в бите */
            k->bit_pos = (int)((k->n_epoch - (uint64_t)bi) % (uint64_t)L);
            k->bit_acc = 0;
            (void)tot;
        }
        return;
    }
    k->bit_pos = (k->bit_pos + 1) % k->bit_len;
    if (k->bit_pos == 0) k->bit_acc = 0;
    k->bit_acc += I;
    if (k->bit_pos == k->bit_len - 1 && k->on_bit) k->on_bit(k->ctx, k->bit_acc < 0, d->n);
}

/* петли по результатам интервала Tl (один период или накопление ncoh периодов) */
/* срыв в режиме длительного накопления: NCO по прогнозу, обнаружение сигнала по мощности
 * интервала (наибольшей из E, P, L) относительно шума: 5 обнаружений из 8 интервалов —
 * повторное втягивание; дольше coast_time — канал освобождается */
static void coast(trk_t *k, double EI, double EQ, double I, double Q, double LI, double LQ)
{
    const sig_info_t *si = &SIGS[k->sig];
    double f = k->f_coast + k->f_rate * (k->t - k->t_coast);
    k->f_carr = f;
    k->f_code = si->chip_rate * (1 + (f - k->f_if) / k->fc);
    corr_set_rates(k->ch, k->f_carr, k->f_code);
    double pe = EI * EI + EQ * EQ, pp = I * I + Q * Q, pl = LI * LI + LQ * LQ;
    double pm = pp > pe ? (pp > pl ? pp : pl) : (pe > pl ? pe : pl);
    int det = k->noise1 > 0 && pm > k->reacq_thr * k->ncoh * k->noise1;
    k->det_hist = ((k->det_hist << 1) | (unsigned)det) & 0xFFu;
    int cnt = 0;
    for (unsigned h = k->det_hist; h; h >>= 1) cnt += (int)(h & 1);
    if (cnt >= 5) {
        k->state = TRK_PULLIN;
        k->int_f = f - k->f0;            /* интегратор ФАП — на прогнозную частоту */
        k->lock = 0;
        k->have_prev = 0;
        k->n_reacq++;
        k->t_pull = k->t;
    } else if (k->t - k->t_lost > k->coast_time) {
        k->state = TRK_IDLE;
    }
}

static void loops(trk_t *k, double EI, double EQ, double I, double Q, double LI, double LQ, double Tl)
{
    const sig_info_t *si = &SIGS[k->sig];
    if (k->state == TRK_LOST && k->ncoh > 1) { coast(k, EI, EQ, I, Q, LI, LQ); return; }
    /* втягивание без захвата дольше 5 с (например, запуск по другой частоте без сигнала) */
    if (k->state == TRK_PULLIN && !k->n_reacq && k->t > 5.0) { k->state = TRK_IDLE; return; }
    /* повторное втягивание без захвата за 1 с — ложное обнаружение: снова прогноз */
    if (k->state == TRK_PULLIN && k->ncoh > 1 && k->n_reacq && k->t - k->t_pull > 1.0) {
        k->state = TRK_LOST;
        k->det_hist = 0;
        coast(k, EI, EQ, I, Q, LI, LQ);
        return;
    }
    /* четырёхквадрантные дискриминаторы — только для пилота со снятым вторичным кодом */
    int pil = si->pilot && k->sec_sync;
    double e = hypot(EI, EQ), l = hypot(LI, LQ);
    /* дискриминаторы */
    double perr = pil ? atan2(Q, I) : (I != 0 ? atan(Q / I) : 0.0);
    double ferr = 0;
    if (k->have_prev && k->ncoh == 1) {
        double cross = k->pI * Q - k->pQ * I, dot = k->pI * I + k->pQ * Q;
        if (k->state == TRK_PULLIN) {
            /* втягивание: atan — линейный в ±1/(4T) */
            if (pil) ferr = atan2(cross, dot) / (2 * GPI * Tl);
            else ferr = dot != 0 ? atan(cross / dot) / (2 * GPI * Tl) : 0.0;
        } else {
            /* захват: ограниченный дискриминатор sin Δφ (устойчив к шуму при dot ≈ 0) */
            double nrm = hypot(k->pI, k->pQ) * hypot(I, Q);
            ferr = nrm > 0 ? (pil ? cross : cross * (dot >= 0 ? 1 : -1)) / nrm / (2 * GPI * Tl) : 0.0;
        }
    }
    k->pI = I; k->pQ = Q; k->have_prev = 1;
    /* фильтр петли несущей: этап 1 (t < fll_time) — только ЧАП с широкой полосой (втягивание
     * частоты из ячейки захвата), этап 2 — ФАП с поддержкой ЧАП (полоса ЧАП — номинальная) */
    if (k->t < k->fll_time) {
        double wfw = 4 * k->wf;
        /* петля 1-го порядка устойчива при K·T < 2; при длинном периоде (L2CM, 20 мс) четырёхкратная
         * полоса нарушила бы и это условие, и Bn·T ≤ 0,1 (K = 4·Bn) */
        if (wfw * Tl > 0.4) wfw = 0.4 / Tl;
        k->int_f += wfw * ferr * Tl;
        k->f_carr = k->f0 + k->int_f;
    } else if (k->pll_order == 3 && k->state == TRK_LOCK && k->ncoh == 1) {
        /* ФАП 3-го порядка (Kaplan, табл. 5.6): нулевая установившаяся ошибка при постоянном
         * ускорении, ошибка от рывка — (dω²/dt²)/ω0³ */
        double ec = perr / (2 * GPI);
        k->x1 += k->w3 * ec * Tl;
        k->int_f += (k->a3w * ec + k->x1) * Tl;
        k->f_carr = k->f0 + k->int_f + k->b3w * ec;
    } else {
        k->int_f += (k->w2 * perr / (2 * GPI) + k->wf * ferr) * Tl;
        k->f_carr = k->f0 + k->int_f + k->a2 * perr / (2 * GPI);
    }
    /* ССЗ */
    double cerr = (e + l) > 0 ? (e - l) / (e + l) * (k->dll_hw - k->spacing) : 0;
    k->f_code = si->chip_rate * (1 + (k->f_carr - k->f_if) / k->fc) + k->dll_k * cerr;
    corr_set_rates(k->ch, k->f_carr, k->f_code);
    /* индикатор захвата фазы: постоянная ≈ 20 интервалов (по периодам) или 5 интервалов
     * (при накоплении) */
    double p2 = I * I + Q * Q;
    double al = k->ncoh > 1 ? 0.2 : 0.05;
    if (p2 > 0) k->lock += al * ((I * I - Q * Q) / p2 - k->lock);
    /* состояние: втягивание -> захват (сужение полосы ФАП до pll_bw_lock) -> срыв -> повторный
     * захват по индикатору; более 1 с в срыве — канал освобождается для повторного поиска */
    if (k->state == TRK_PULLIN && k->t > k->fll_time + 0.05 && k->lock > 0.4) {
        k->state = TRK_LOCK;
        if (k->ncoh == 1) {
            double wn = k->pll_bw_lock / 0.53;
            k->a2 = 1.414 * wn;
            k->w2 = wn * wn;
            k->wf = k->fll_bw_lock / 0.25;
            double w0 = k->pll_bw3 / 0.7845;
            k->w3 = w0 * w0 * w0; k->a3w = 1.1 * w0 * w0; k->b3w = 2.4 * w0;
            k->x1 = 0;
        }
    } else if (k->state == TRK_LOCK && k->lock < 0.1 && (k->ncoh == 1 || ++k->low_cnt >= 10)) {
        /* при длительном накоплении срыв — 10 интервалов (200 мс) подряд ниже порога */
        k->state = TRK_LOST;
        k->t_lost = k->t;
        if (k->ncoh > 1) {               /* прогноз: сглаженная частота, приведённая к моменту срыва */
            k->f_coast = k->f_lp + k->f_rate * 1.0;
            k->t_coast = k->t;
            k->det_hist = 0;
        }
    } else if (k->state == TRK_LOST && k->ncoh == 1) {
        if (k->lock > 0.5) k->state = TRK_LOCK;
        else if (k->t - k->t_lost > 1.0) k->state = TRK_IDLE;
    }
    if (k->lock >= 0.1) k->low_cnt = 0;
    k->last_perr = perr;
}

/* синхронизация по вторичному коду: знаки точного отвода за последний период вторичного кода
 * сравниваются со всеми его сдвигами; принимается сдвиг с совпадением не менее L − 1 при
 * отсутствии второго близкого */
static void sec_try_sync(trk_t *k, double I)
{
    int L = k->sec_len;
    k->sec_hist[k->sec_n % L] = I;
    if (++k->sec_n < L) return;
    int best = 0, br = 0, second = 0;
    for (int r = 0; r < L; r++) {
        int c = 0;
        for (int j = 0; j < L; j++) {
            double v = k->sec_hist[(k->sec_n - L + j) % L];
            c += ((v < 0) ^ k->sec[(r + j) % L]) ? -1 : 1;
        }
        if (abs(c) > abs(best)) { second = abs(best); best = c; br = r; }
        else if (abs(c) > second) second = abs(c);
    }
    if (abs(best) >= L - 1 && second < L / 2) {
        k->sec_sync = 1;
        k->sec_pos = br;                     /* следующий период — чип br */
        k->sec_sgn = best > 0 ? 1 : -1;      /* знак снимает неоднозначность фазы Костаса */
        if (!SIGS[k->sig].pilot && k->bit_len == L) {
            /* данные (B1I): период кода NH — бит, знак — бит данных, а не фаза; текущий период —
             * чип br − 1, т. е. интервал br − 1 внутри бита */
            k->sec_sgn = 1;
            k->bit_sync = 1;
            k->bit_pos = (br + L - 1) % L;
            k->bit_acc = 0;
        }
    }
}

/* переход к длительному накоплению: интервал петель — n периодов, узкие полосы, без ЧАП */
static void go_long(trk_t *k, int n)
{
    k->ncoh = n;
    double wn = k->pll_bw_long / 0.53;
    k->a2 = 1.414 * wn;
    k->w2 = wn * wn;
    k->wf = 0;
    k->dll_k = 4 * k->dll_bw_long;
    memset(k->acc, 0, sizeof(k->acc));
    k->nacc = 0;
}

void trk_update(trk_t *k, const corr_dump_t *d)
{
    /* снятие вторичного кода (после синхронизации) */
    double sc = 1;
    if (k->sec_len && k->sec_sync) {
        sc = (k->sec[k->sec_pos] ? -1 : 1) * k->sec_sgn;
        k->sec_pos = (k->sec_pos + 1) % k->sec_len;
    }
    double I = sc * d->PI, Q = sc * d->PQ;
    double EI = sc * d->EI, EQ = sc * d->EQ, LI = sc * d->LI, LQ = sc * d->LQ;
    if (k->ncoh == 1) {
        loops(k, EI, EQ, I, Q, LI, LQ, k->T);
    } else {
        k->acc[0] += EI; k->acc[1] += EQ; k->acc[2] += I;
        k->acc[3] += Q; k->acc[4] += LI; k->acc[5] += LQ;
        /* граница бита: следующий период — первый в бите */
        if (++k->nacc == k->ncoh) {
            loops(k, k->acc[0], k->acc[1], k->acc[2], k->acc[3], k->acc[4], k->acc[5], k->ncoh * k->T);
            memset(k->acc, 0, sizeof(k->acc));
            k->nacc = 0;
        }
    }
    /* данные с вторичным кодом: граница бита — только по синхронизации по вторичному коду */
    if (k->bit_len && (!k->sec_len || k->sec_sync) &&
        (k->state == TRK_LOCK || (k->ncoh > 1 && k->state == TRK_LOST))) {
        bit_sync(k, I, d);
        /* после синхронизации, в конце бита — переход к длительному накоплению */
        if (k->ncoh == 1 && k->bit_len > 1 && k->bit_sync && k->bit_pos == k->bit_len - 1 &&
            k->long_cn0 > 0 && k->cn0 > 0 && k->cn0 < k->long_cn0)
            go_long(k, k->bit_len);
    }
    if (k->sec_len && !k->sec_sync && k->state == TRK_LOCK) sec_try_sync(k, d->PI);
    else if (SIGS[k->sig].pilot && k->sec_sync && k->ncoh == 1 && k->long_cn0 > 0 && k->cn0 > 0 &&
             k->cn0 < k->long_cn0) {
        int n = (int)lround(0.020 / k->T);
        if (n > 1) go_long(k, n);
    }
    /* сглаженная частота и её скорость — для прогноза при срыве */
    if (k->state == TRK_LOCK) {
        k->f_lp = k->f_lp != 0 ? k->f_lp + (k->T / 1.0) * (k->f_carr - k->f_lp) : k->f_carr;
        if (k->t - k->t_1s >= 1.0) {
            if (k->t_1s > 0) {
                double r = (k->f_lp - k->f_1s) / (k->t - k->t_1s);
                k->f_rate = k->f_rate != 0 ? k->f_rate + 0.3 * (r - k->f_rate) : r;
            }
            k->f_1s = k->f_lp; k->t_1s = k->t;
        }
    }
    /* C/N0 (метод NWPR, 20 периодов): до синхронизации по битам — по |I| (смещение при слабом
     * сигнале), после — когерентная сумма внутри бита */
    int coh = (k->bit_len == 20 && k->bit_sync) || k->sec_sync;
    if (k->bit_len == 20 && k->bit_sync && k->bit_pos == 0) { k->nb_i = k->nb_q = k->wbp = 0; k->nbn = 0; }
    double p2 = I * I + Q * Q;
    k->nb_i += coh ? I : fabs(I);
    k->nb_q += coh ? Q : 0;
    k->wbp += p2;
    if (++k->nbn == 20) {
        double nbp = k->nb_i * k->nb_i + k->nb_q * k->nb_q;
        double nm = k->wbp > 0 ? nbp / k->wbp : 0;
        if (nm > 1 && nm < 20) {
            double c = 10 * log10((nm - 1) / (20 - nm) / k->T);
            k->cn0 = k->cn0 > 0 ? k->cn0 + 0.2 * (c - k->cn0) : c;
        }
        /* мощность шума одного периода (при когерентном окне): N = (M·WBP − NBP) / (M(M − 1)) */
        double ne = (20 * k->wbp - nbp) / 380.0;
        if (coh && k->state == TRK_LOCK && ne > 0)
            k->noise1 = k->noise1 > 0 ? k->noise1 + 0.1 * (ne - k->noise1) : ne;
        k->nb_i = k->nb_q = k->wbp = 0;
        k->nbn = 0;
    }
    k->n_epoch++;
    k->t += k->T;
}

double trk_doppler(const trk_t *k)
{
    return k->f_carr - k->f_if;
}

double trk_doppler_smooth(const trk_t *k)
{
    if (k->f_lp == 0) return trk_doppler(k);
    return k->f_lp + k->f_rate * 1.0 - k->f_if;          /* запаздывание фильтра (τ = 1 с) — по скорости */
}
