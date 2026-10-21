/* МГП-8: захват сигналов по снимкам отсчётов.
 * Алгоритм (sw/pyrx/acq.py): для каждой ячейки доплера — перенос на нулевую частоту, усреднение
 * отсчётов периода кода в Nfft = 2^k ячеек (≥ 4 на чип, ≥ 8 для BOC; Galileo E1 — 4: 8 · 4092 больше
 * NFFT_MAX), круговая корреляция с копией кода через БПФ (период длиннее снимка — E1, 4 мс — одна
 * неполная часть периода), некогерентное накопление по периодам кода и по нескольким снимкам
 * (сдвиг пика между снимками из-за доплера кода компенсируется). Затем — уточнение доплера
 * прямой корреляцией в найденной фазе кода (сетка шаг/8 в ±1,5 шага, параболическая
 * интерполяция); блок делится эпохой кода на две части, суммы которых складываются без учёта
 * знака — смена знака на эпохе (символы E1-B через 4 мс, код NH B1I через 1 мс, биты) иначе
 * расщепляет пик по доплеру, и ошибка выходит за полосу втягивания ЧАП ±1/(4T).
 * Решение: пик / второй пик (вне ±1 чипа в той же ячейке доплера) > порога. */
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include "gnss.h"
#include "codes.h"
#include "fft.h"
#include "fpga.h"
#include "acq.h"

#define NFFT_MAX 16384

static cpx_t R[NFFT_MAX], Y[NFFT_MAX];
static float P[NFFT_MAX], PB[NFFT_MAX];
static float SIN256[256];
static uint8_t BITS[CODE_MAX_BYTES];

static void init_tab(void)
{
    static int done;
    if (done) return;
    for (int k = 0; k < 256; k++) SIN256[k] = (float)sin(2 * GPI * k / 256);
    done = 1;
}

static inline void decode(unsigned x, int *xi, int *xq)
{
    *xi = ((x >> 2) & 1 ? 3 : 1) * ((x >> 3) & 1 ? -1 : 1);
    *xq = ((x & 1) ? 3 : 1) * ((x >> 1) & 1 ? -1 : 1);
}

/* значение копии в точке u (чипы) */
static inline float rep(const sig_info_t *si, int L, double u)
{
    int i = (int)floor(u);
    double fr = u - i;
    i %= L; if (i < 0) i += L;
    float v = code_bit(BITS, i) ? -1.0f : 1.0f;
    if (si->boc && fr >= 0.5) v = -v;
    if (si->tdm && fr >= 0.5) v = 0;
    return v;
}

int acq_search_multi(const uint8_t *const *x4, const uint32_t *t0, int nsnap, int n,
                     int sig, int prn, int fcn, const acq_cfg_t *cfg, acq_res_t *r)
{
    const sig_info_t *si = &SIGS[sig];
    memset(r, 0, sizeof(*r));
    init_tab();
    int L = code_gen(sig, prn, BITS);
    if (L <= 0) return 0;
    double T = L / si->chip_rate;
    int Ns = (int)lround(T * FS_HZ);
    int nfft = 1;
    while (nfft < (si->boc ? 8 : 4) * L) nfft <<= 1;
    /* BOC с длинным кодом (E1: 4092 чипа): 4 ячейки на чип — две на полупериод поднесущей,
     * потери на сетке задержки до ≈ 4 дБ в худшем случае */
    if (nfft > NFFT_MAX && si->boc)
        for (nfft = 1; nfft < 4 * L; nfft *= 2) {}
    if (nfft > NFFT_MAX || Ns < nfft / 2) return 0;
    /* период кода длиннее снимка: когерентно — первые Nu отсчётов (остальные ячейки — нули) */
    int Nu = Ns < n ? Ns : n;
    int nper = n / Ns;
    if (cfg->nper > 0 && nper > cfg->nper) nper = cfg->nper;
    if (nper < 1) nper = 1;
    double Tu = Nu / FS_HZ;                                  /* время когерентного накопления */
    for (int k = 0; k < nfft; k++) { R[k].re = rep(si, L, (double)k * L / nfft); R[k].im = 0; }
    fft(R, nfft, 0);
    for (int k = 0; k < nfft; k++) R[k].im = -R[k].im;
    double fif = sig_if(sig, fcn), fc = sig_carrier(sig, fcn);
    double step = cfg->dop_step > 0 ? cfg->dop_step : 1.0 / (2 * Tu);
    int nd = (int)(2 * cfg->dop_max / step) + 1;
    double best = -1, sum = 0;
    long cnt = 0;
    int bk = 0, bd = 0;
    for (int d = 0; d < nd; d++) {
        double fd = -cfg->dop_max + d * step;
        double rate = si->chip_rate * (1 + fd / fc);
        memset(P, 0, sizeof(float) * nfft);
        for (int s = 0; s < nsnap; s++) {
            /* сдвиг пика относительно первого снимка: фаза кода растёт на rate·Δt */
            double dc = fmod(rate * (double)(t0[s] - t0[0]) / FS_HZ, (double)L);
            int sh = (int)lround(dc * nfft / L) % nfft;
            double ph0 = -(fif + fd) * (double)(t0[s] - t0[0]) / FS_HZ;
            uint32_t ph = (uint32_t)(int64_t)llround((ph0 - floor(ph0)) * 4294967296.0);
            uint32_t dph = (uint32_t)(int64_t)llround(-(fif + fd) / FS_HZ * 4294967296.0);
            for (int p = 0; p < nper; p++) {
                memset(Y, 0, sizeof(cpx_t) * nfft);
                const uint8_t *xp = x4[s];
                long i0 = (long)p * Ns;
                for (int i = 0; i < Nu; i++) {
                    int xi, xq;
                    decode(snap_x(xp, i0 + i), &xi, &xq);
                    float c = SIN256[((ph >> 24) + 64) & 255], sn = SIN256[ph >> 24];
                    int k = (int)((int64_t)i * nfft / Ns);
                    Y[k].re += xi * c - xq * sn;
                    Y[k].im += xi * sn + xq * c;
                    ph += dph;
                }
                fft(Y, nfft, 0);
                for (int k = 0; k < nfft; k++) {
                    float a = Y[k].re * R[k].re - Y[k].im * R[k].im;
                    float b = Y[k].re * R[k].im + Y[k].im * R[k].re;
                    Y[k].re = a; Y[k].im = b;
                }
                fft(Y, nfft, 1);
                /* пик снимка s в ячейке k соответствует ячейке k + sh первого снимка */
                for (int k = 0; k < nfft; k++)
                    P[(k + sh) % nfft] += Y[k].re * Y[k].re + Y[k].im * Y[k].im;
            }
        }
        for (int k = 0; k < nfft; k++) {
            sum += P[k]; cnt++;
            if (P[k] > best) { best = P[k]; bk = k; bd = d; memcpy(PB, P, sizeof(float) * nfft); }
        }
    }
    int w = nfft / L + 1;
    double second = 0;
    for (int k = 0; k < nfft; k++) {
        int dk = abs(k - bk);
        if (dk > nfft / 2) dk = nfft - dk;
        if (dk > w && PB[k] > second) second = PB[k];
    }
    double mean = sum / cnt;
    int K = nper * nsnap;
    r->metric = best / mean;
    r->ratio = second > 0 ? best / second : 0;
    r->code_phase = fmod((double)(nfft - bk) * L / nfft, (double)L);
    r->doppler = -cfg->dop_max + bd * step;
    double snr = (best - mean) / mean / K;
    r->cn0 = snr > 0 ? 10 * log10(snr / Tu) : 0;
    r->found = r->ratio > cfg->thresh;
    if (!r->found) return 0;
    /* уточнение доплера: прямая корреляция в найденной фазе кода, сетка step/8 в ±1,5·step;
     * части блока до и после эпохи кода a, b: max |a ± b|² = |a|² + |b|² + 2|Re a·b*| */
    enum { NF = 25 };
    double pv[NF];
    int nf = NF;
    for (int j = 0; j < nf; j++) {
        double fd = r->doppler + (j - NF / 2) * step / 8;
        double rate = si->chip_rate * (1 + fd / fc), acc = 0;
        for (int s = 0; s < nsnap; s++) {
            double cp0 = r->code_phase + rate * (double)(t0[s] - t0[0]) / FS_HZ;
            double ph0 = -(fif + fd) * (double)(t0[s] - t0[0]) / FS_HZ;
            uint32_t ph = (uint32_t)(int64_t)llround((ph0 - floor(ph0)) * 4294967296.0);
            uint32_t dph = (uint32_t)(int64_t)llround(-(fif + fd) / FS_HZ * 4294967296.0);
            for (int p = 0; p < nper; p++) {
                double re[2] = {0, 0}, im[2] = {0, 0};
                const uint8_t *xp = x4[s];
                long i0 = (long)p * Ns;
                double u = cp0 + rate * (double)p * Ns / FS_HZ, du = rate / FS_HZ;
                /* первый отсчёт следующего периода кода */
                double ie = ceil(((floor(u / L) + 1) * L - u) / du);
                for (int i = 0; i < Nu; i++, u += du) {
                    int xi, xq, h = i >= ie;
                    decode(snap_x(xp, i0 + i), &xi, &xq);
                    float c = SIN256[((ph >> 24) + 64) & 255], sn = SIN256[ph >> 24];
                    float v = rep(si, L, u);
                    re[h] += v * (xi * c - xq * sn);
                    im[h] += v * (xi * sn + xq * c);
                    ph += dph;
                }
                acc += re[0] * re[0] + im[0] * im[0] + re[1] * re[1] + im[1] * im[1] +
                       2 * fabs(re[0] * re[1] + im[0] * im[1]);
            }
        }
        pv[j] = acc;
    }
    int jm = 0;
    for (int j = 1; j < nf; j++) if (pv[j] > pv[jm]) jm = j;
    double dj = 0;
    if (jm > 0 && jm < nf - 1) {
        double a = pv[jm - 1], b = pv[jm], c = pv[jm + 1], den = a - 2 * b + c;
        if (den < 0) dj = 0.5 * (a - c) / den;
    }
    r->doppler += (jm - NF / 2 + dj) * step / 8;
    return 1;
}

/* ---------------------------------------------------------------- захват слабых сигналов */
int acq_weak_init(acq_weak_t *w, int sig, int fcn, const int *prn, int nprn, double dop_min, double dop_max,
                  double step, int K, void *rep_buf, float *acc_buf)
{
    const sig_info_t *si = &SIGS[sig];
    memset(w, 0, sizeof(*w));
    if (nprn < 1 || nprn > AW_MAXPRN || step <= 0 || K < 1) return 0;
    init_tab();
    w->sig = sig; w->fcn = fcn; w->nprn = nprn;
    memcpy(w->prn, prn, sizeof(int) * (size_t)nprn);
    w->dop_min = dop_min; w->step = step; w->K = K;
    w->nd = (int)floor((dop_max - dop_min) / step + 1e-9) + 1;
    w->thresh = 6.5;
    w->rep = rep_buf; w->acc = acc_buf;
    cpx_t *R0 = rep_buf;
    for (int i = 0; i < nprn; i++) {
        int L = code_gen(sig, prn[i], BITS);
        if (L <= 0) return 0;
        if (i == 0) {
            w->L = L;
            w->nfft = 1;
            while (w->nfft < (si->boc ? 8 : 4) * L) w->nfft <<= 1;
            w->Ns = (int)lround(L / si->chip_rate * FS_HZ);
            if (w->nfft > NFFT_MAX || w->Ns < w->nfft / 2) return 0;
        }
        cpx_t *Ri = R0 + (size_t)i * w->nfft;
        for (int k = 0; k < w->nfft; k++) { Ri[k].re = rep(si, L, (double)k * L / w->nfft); Ri[k].im = 0; }
        fft(Ri, w->nfft, 0);
        for (int k = 0; k < w->nfft; k++) Ri[k].im = -Ri[k].im;
        w->z[i] = 0;
    }
    memset(w->acc, 0, sizeof(float) * (size_t)nprn * w->nfft);
    return 1;
}

static void aw_eval(acq_weak_t *w)
{
    int nfft = w->nfft;
    for (int i = 0; i < w->nprn; i++) {
        const float *a = w->acc + (size_t)i * nfft;
        double sum = 0, best = -1;
        int bk = 0;
        for (int k = 0; k < nfft; k++) { sum += a[k]; if (a[k] > best) { best = a[k]; bk = k; } }
        double mean = sum / nfft, z = mean > 0 ? (best / mean - 1) * sqrt((double)w->k) : 0;
        if (z > w->z[i]) {
            w->z[i] = z;
            w->cp[i] = fmod((double)(nfft - bk) * w->L / nfft, (double)w->L);
            w->dop[i] = w->dop_min + w->d * w->step;
            w->tr[i] = w->t_ref;
        }
    }
    memset(w->acc, 0, sizeof(float) * (size_t)w->nprn * nfft);
}

int acq_weak_add(acq_weak_t *w, const uint8_t *x4, uint32_t t0, int n)
{
    if (w->d >= w->nd) return 1;
    const sig_info_t *si = &SIGS[w->sig];
    int nfft = w->nfft, Ns = w->Ns, L = w->L;
    if (w->k == 0) w->t_ref = t0;
    double fd = w->dop_min + w->d * w->step, fif = sig_if(w->sig, w->fcn), fc = sig_carrier(w->sig, w->fcn);
    double rate = si->chip_rate * (1 + fd / fc);
    uint32_t dph = (uint32_t)(int64_t)llround(-(fif + fd) / FS_HZ * 4294967296.0);
    const cpx_t *R0 = w->rep;
    for (int p = 0; p < n / Ns && w->k < w->K; p++, w->k++) {
        memset(Y, 0, sizeof(cpx_t) * nfft);
        const uint8_t *xp = x4;
        long i0 = (long)p * Ns;
        uint32_t ph = 0;
        for (int i = 0; i < Ns; i++) {
            int xi, xq;
            decode(snap_x(xp, i0 + i), &xi, &xq);
            float c = SIN256[((ph >> 24) + 64) & 255], sn = SIN256[ph >> 24];
            int k = (int)((int64_t)i * nfft / Ns);
            Y[k].re += xi * c - xq * sn;
            Y[k].im += xi * sn + xq * c;
            ph += dph;
        }
        fft(Y, nfft, 0);
        /* доплер кода: пик периода в ячейке k соответствует ячейке k + sh на t_ref */
        double dt = ((double)(uint32_t)(t0 - w->t_ref) + (double)p * Ns) / FS_HZ;
        int sh = (int)lround(fmod(rate * dt, (double)L) * nfft / L) % nfft;
        for (int i = 0; i < w->nprn; i++) {
            const cpx_t *Ri = R0 + (size_t)i * nfft;
            for (int k = 0; k < nfft; k++) {
                R[k].re = Y[k].re * Ri[k].re - Y[k].im * Ri[k].im;
                R[k].im = Y[k].re * Ri[k].im + Y[k].im * Ri[k].re;
            }
            fft(R, nfft, 1);
            float *a = w->acc + (size_t)i * nfft;
            for (int k = 0; k < nfft; k++) a[(k + sh) % nfft] += R[k].re * R[k].re + R[k].im * R[k].im;
        }
    }
    if (w->k >= w->K) {
        aw_eval(w);
        w->k = 0;
        w->d++;
    }
    return w->d >= w->nd;
}

int acq_weak_result(const acq_weak_t *w, int i, acq_res_t *r, uint32_t *tref)
{
    memset(r, 0, sizeof(*r));
    if (i < 0 || i >= w->nprn) return 0;
    r->metric = w->z[i];
    r->code_phase = w->cp[i];
    r->doppler = w->dop[i];
    r->found = w->z[i] > w->thresh;
    /* оценка C/N0 по z: пик/среднее − 1 = z/√K ≈ отношение с/ш за период */
    double snr = w->z[i] / sqrt((double)w->K), T = w->L / SIGS[w->sig].chip_rate;
    r->cn0 = snr > 0 ? 10 * log10(snr / T) : 0;
    if (tref) *tref = w->tr[i];
    return r->found;
}

/* ---------------------------------------------------------------- ускоритель захвата ПЛИС */
#define AH_FMASK 0x7C0u          /* ÷2 на этапах 6–10 прямого БПФ: шум X ≈ 70 из ±255 */
#define AH_IMASK 0x6AAu          /* этапы 1, 3, 5, 7, 9, 10 корреляции */
#define AH_CSH   1u

int acq_hw_init(acq_hw_t *h, int sig, int fcn, const int *prn, int nprn, double dop_min, double dop_max,
                double step, int K)
{
    const sig_info_t *si = &SIGS[sig];
    memset(h, 0, sizeof(*h));
    if (nprn < 1 || nprn > AW_MAXPRN || step <= 0 || K < 1 || K > 65536 || dop_max < dop_min) return 0;
    if (si->boc || si->tdm || si->code_ms != 1 || 2 * si->code_len > (int)ACQ_N) return 0;
    init_tab();
    h->sig = sig; h->fcn = fcn; h->rf = si->rf; h->nprn = nprn;
    memcpy(h->prn, prn, sizeof(int) * (size_t)nprn);
    h->L = si->code_len;
    h->Ns = (int)lround(h->L / si->chip_rate * FS_HZ);
    h->nper = h->Ns + 512;
    double fbin = FS_HZ / h->Ns;                       /* ячейка БПФ — 1/T */
    h->q = (int)lround(fbin / step);
    if (h->q < 1) h->q = 1;
    h->step = fbin / h->q;
    h->dop_min = dop_min; h->K = K; h->thresh = 6.5;
    h->nd = (int)floor((dop_max - dop_min) / h->step + 1e-9) + 1;
    for (int r = 0; r < h->q && r < h->nd; r++) {
        int nr = (h->nd - r + h->q - 1) / h->q;
        for (int j = 0; j < nr; j += (int)ACQ_G) {
            if (h->nrun >= AH_MAXRUN) return 0;
            h->run_d0[h->nrun] = r + j * h->q;
            h->run_ng[h->nrun] = nr - j < (int)ACQ_G ? nr - j : (int)ACQ_G;
            h->nrun++;
        }
    }
    for (int i = 0; i < nprn; i++) {
        if (code_gen(sig, prn[i], BITS) != h->L) return 0;
        h->z[i] = 0;
    }
    return 1;
}

/* спектр копии в отсчётах середин ячеек: R[k] = FFT(c((k + ½)·L/N)), ±255 */
static void ah_load_rep(const acq_hw_t *h, int prn)
{
    const sig_info_t *si = &SIGS[h->sig];
    code_gen(h->sig, prn, BITS);
    for (unsigned k = 0; k < ACQ_N; k++) { R[k].re = rep(si, h->L, (k + 0.5) * h->L / ACQ_N); R[k].im = 0; }
    fft(R, ACQ_N, 0);
    float mx = 0;
    for (unsigned k = 0; k < ACQ_N; k++) {
        if (fabsf(R[k].re) > mx) mx = fabsf(R[k].re);
        if (fabsf(R[k].im) > mx) mx = fabsf(R[k].im);
    }
    float s = mx > 0 ? 255.0f / mx : 0;
    for (unsigned k = 0; k < ACQ_N; k++) {
        int32_t re = (int32_t)lroundf(R[k].re * s), im = (int32_t)lroundf(R[k].im * s);
        fpga_wr(R_ACQ_MEM + k, ((uint32_t)re & 511u) | ((uint32_t)im & 511u) << 9);
    }
}

static int ah_start(acq_hw_t *h)
{
    const sig_info_t *si = &SIGS[h->sig];
    int d0 = h->run_d0[h->ir], ng = h->run_ng[h->ir], c = (ng - 1) / 2;
    double fif = sig_if(h->sig, h->fcn), fc = sig_carrier(h->sig, h->fcn);
    double f0 = h->dop_min + (d0 + c * h->q) * h->step;
    fpga_wr(R_ACQ_DPHI, (uint32_t)(int64_t)llround((fif + f0) / FS_HZ * 4294967296.0));
    for (int g = 0; g < ng; g++) {
        double fd = h->dop_min + (d0 + g * h->q) * h->step;
        double rate = si->chip_rate * (1 + fd / fc);
        /* сдвиг пика за шаг Nper — в ячейках БПФ, 11.21 по модулю N */
        double sh = fmod(rate * h->nper / FS_HZ * ACQ_N / h->L, (double)ACQ_N);
        fpga_wr(R_ACQ_M(g), (uint32_t)(g - c) & (ACQ_N - 1));
        fpga_wr(R_ACQ_DSH(g), (uint32_t)(int64_t)llround(sh * 2097152.0));
    }
    int psh = (int)lround(12 + log2((double)h->K));
    if (psh > 31) psh = 31;
    fpga_wr(R_ACQ_K, (uint32_t)h->K & 0xFFFFu);
    fpga_wr(R_ACQ_NS, (uint32_t)h->Ns);
    fpga_wr(R_ACQ_NPER, (uint32_t)h->nper);
    fpga_wr(R_ACQ_SCALE, AH_FMASK | AH_IMASK << 11 | (uint32_t)psh << 22 | AH_CSH << 27);
    fpga_wr(R_ACQ_CTRL, 1u | (uint32_t)ng << 4 | (uint32_t)h->rf << 8);
    uint32_t st = fpga_rd(R_ACQ_CTRL);
    if (st >> 31) return 1;
    if (st >> 30 & 1) h->nfail++;                       /* сбой расписания — запуск пропускается */
    return st >> 30 & 1 ? -1 : 0;                       /* 0 — пул занят снимком, повтор позже */
}

static void ah_collect(acq_hw_t *h)
{
    int d0 = h->run_d0[h->ir], ng = h->run_ng[h->ir], i = h->ip;
    uint32_t t0 = fpga_rd(R_ACQ_T0);
    for (int g = 0; g < ng; g++) {
        uint32_t pk = fpga_rd(R_ACQ_PEAK(g)), sum = fpga_rd(R_ACQ_SUM(g));
        double best = pk & 0x3FFFFu, mean = sum / (double)ACQ_N;
        int bk = (int)(pk >> 18 & (ACQ_N - 1));
        double z = mean > 0 ? (best / mean - 1) * sqrt((double)h->K) : 0;
        if (z > h->z[i]) {
            h->z[i] = z;
            h->cp[i] = fmod((double)(ACQ_N - bk) * h->L / ACQ_N, (double)h->L);
            h->dop[i] = h->dop_min + (d0 + g * h->q) * h->step;
            h->tr[i] = t0;
        }
    }
}

int acq_hw_poll(acq_hw_t *h)
{
    for (;;) {
        if (h->ip >= h->nprn) return 1;
        if (h->st == 1) {
            if (fpga_rd(R_ACQ_CTRL) >> 31) return 0;    /* идёт накопление */
            ah_collect(h);
        } else {
            if (h->ir == 0 && h->st == 0) { ah_load_rep(h, h->prn[h->ip]); h->st = 2; }
            int r = ah_start(h);
            if (r == 0) return 0;
            if (r > 0) { h->st = 1; return 0; }
        }
        h->st = 0;
        if (++h->ir >= h->nrun) { h->ir = 0; h->ip++; }
    }
}

int acq_hw_result(const acq_hw_t *h, int i, acq_res_t *r, uint32_t *tref)
{
    memset(r, 0, sizeof(*r));
    if (i < 0 || i >= h->nprn) return 0;
    r->metric = h->z[i];
    r->code_phase = h->cp[i];
    r->doppler = h->dop[i];
    r->found = h->z[i] > h->thresh;
    double snr = h->z[i] / sqrt((double)h->K), T = h->Ns / FS_HZ;
    r->cn0 = snr > 0 ? 10 * log10(snr / T) : 0;
    if (tref) *tref = h->tr[i];
    return r->found;
}

double acq_hw_run_time(const acq_hw_t *h)
{
    return ((double)(h->K - 1) * h->nper + h->Ns) / FS_HZ + ACQ_PROC_CLK(h->run_ng[0]) / 96e6;
}

int acq_search(const uint8_t *x4, int n, int sig, int prn, int fcn, const acq_cfg_t *cfg, acq_res_t *r)
{
    const uint8_t *xs[1] = {x4};
    uint32_t t0[1] = {0};
    return acq_search_multi(xs, t0, 1, n, sig, prn, fcn, cfg, r);
}

void acq_snap_start(int rf, int len, uint32_t t)
{
    fpga_wr(R_SNAP_T, t);
    fpga_wr(R_SNAP_LEN, (uint32_t)len);
    fpga_wr(R_SNAP_CTRL, (uint32_t)rf | (t ? 8u : 0u));
}

int acq_snap_read(int len, uint8_t *x4, uint32_t *t0)
{
    if (fpga_rd(R_SNAP_CTRL) >> 31) return 0;           /* ещё записывается */
    *t0 = fpga_rd(R_SNAP_T0);
    for (int w = 0; w < len / 8; w++) {                 /* слово — 8 отсчётов, первый — мл. тетрада */
        uint32_t v = fpga_rd(R_SNAP_DATA + (uint32_t)w);
        for (int k = 0; k < 4; k++) x4[4 * w + k] = (uint8_t)(v >> (8 * k));
    }
    return 1;
}
