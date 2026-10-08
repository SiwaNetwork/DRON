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
 * неоднозначности фазы), при слабом сигнале — когерентное накопление ≈ 20 мс. */
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
    double wn = cfg->pll_bw / 0.53;
    k->a2 = 1.414 * wn;
    k->w2 = wn * wn;
    k->wf = cfg->fll_bw / 0.25;
    k->dll_k = 4 * cfg->dll_bw;
    k->spacing = si->boc && cfg->spacing > 0.15 ? 0.15 : cfg->spacing;   /* BOC(1,1): узкий E–L */
    k->fll_time = cfg->fll_time;
    k->pll_bw_lock = cfg->pll_bw_lock;
    k->fll_bw_lock = cfg->fll_bw_lock;
    k->cn0 = 0;
    k->bit_len = (sig == SIG_L1CA) ? 20 : 0;
    k->long_cn0 = cfg->long_cn0;
    k->pll_bw_long = cfg->pll_bw_long;
    k->dll_bw_long = cfg->dll_bw_long;
    k->ncoh = 1;
    k->sec_len = sec_code(sig, prn, k->sec);
    corr_config(ch, sig, prn, fcn, 1, k->spacing, k->f_carr, k->f_code, code_phase, 0.0, t_start);
}

static void bit_sync(trk_t *k, double I, const corr_dump_t *d)
{
    int s = I >= 0 ? 1 : -1;
    if (!k->bit_sync) {
        if (k->prev_sign && s != k->prev_sign) k->bit_hist[k->n_epoch % 20]++;
        k->prev_sign = s;
        int best = 0, second = 0, bi = 0, tot = 0;
        for (int i = 0; i < 20; i++) {
            tot += k->bit_hist[i];
            if (k->bit_hist[i] > best) { second = best; best = k->bit_hist[i]; bi = i; }
            else if (k->bit_hist[i] > second) second = k->bit_hist[i];
        }
        if (best >= 8 && best > 4 * second + 2) {
            k->bit_sync = 1;
            /* переход знака между интервалами bi−1 и bi: интервал bi — первый в бите */
            k->bit_pos = (int)((k->n_epoch - (uint64_t)bi) % 20);
            k->bit_acc = 0;
            (void)tot;
        }
        return;
    }
    k->bit_pos = (k->bit_pos + 1) % 20;
    if (k->bit_pos == 0) k->bit_acc = 0;
    k->bit_acc += I;
    if (k->bit_pos == 19 && k->on_bit) k->on_bit(k->ctx, k->bit_acc < 0, d->n);
}

/* петли по результатам интервала Tl (один период или накопление ncoh периодов) */
static void loops(trk_t *k, double EI, double EQ, double I, double Q, double LI, double LQ, double Tl)
{
    const sig_info_t *si = &SIGS[k->sig];
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
        k->int_f += wfw * ferr * Tl;
        k->f_carr = k->f0 + k->int_f;
    } else {
        k->int_f += (k->w2 * perr / (2 * GPI) + k->wf * ferr) * Tl;
        k->f_carr = k->f0 + k->int_f + k->a2 * perr / (2 * GPI);
    }
    /* ССЗ */
    double cerr = (e + l) > 0 ? (e - l) / (e + l) * (1 - k->spacing) : 0;
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
        double wn = k->pll_bw_lock / 0.53;
        k->a2 = 1.414 * wn;
        k->w2 = wn * wn;
        k->wf = k->fll_bw_lock / 0.25;
    } else if (k->state == TRK_LOCK && k->lock < 0.1) {
        k->state = TRK_LOST;
        k->t_lost = k->t;
    } else if (k->state == TRK_LOST) {
        if (k->lock > 0.5) k->state = TRK_LOCK;
        else if (k->t - k->t_lost > 1.0) k->state = TRK_IDLE;
    }
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
    if (k->bit_len && (k->state == TRK_LOCK || (k->ncoh > 1 && k->state == TRK_LOST))) {
        bit_sync(k, I, d);
        /* после синхронизации, в конце бита — переход к длительному накоплению */
        if (k->ncoh == 1 && k->bit_sync && k->bit_pos == k->bit_len - 1 && k->long_cn0 > 0 &&
            k->cn0 > 0 && k->cn0 < k->long_cn0)
            go_long(k, k->bit_len);
    }
    if (k->sec_len && !k->sec_sync && k->state == TRK_LOCK) sec_try_sync(k, d->PI);
    else if (k->sec_sync && k->ncoh == 1 && k->long_cn0 > 0 && k->cn0 > 0 && k->cn0 < k->long_cn0) {
        int n = (int)lround(0.020 / k->T);
        if (n > 1) go_long(k, n);
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
