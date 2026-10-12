/* МГП-8: захват сигналов по снимкам отсчётов.
 * Алгоритм (sw/pyrx/acq.py): для каждой ячейки доплера — перенос на нулевую частоту, усреднение
 * отсчётов периода кода в Nfft = 2^k ячеек (≥ 4 на чип, ≥ 8 для BOC), круговая корреляция с
 * копией кода через БПФ, некогерентное накопление по периодам кода и по нескольким снимкам
 * (сдвиг пика между снимками из-за доплера кода компенсируется). Затем — уточнение доплера
 * прямой корреляцией в найденной фазе кода (сетка шаг/8, параболическая интерполяция).
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

static inline void decode(uint8_t x, int *xi, int *xq)
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
    if (nfft > NFFT_MAX || Ns < nfft / 2) return 0;
    int nper = n / Ns;
    if (cfg->nper > 0 && nper > cfg->nper) nper = cfg->nper;
    if (nper < 1) return 0;
    for (int k = 0; k < nfft; k++) { R[k].re = rep(si, L, (double)k * L / nfft); R[k].im = 0; }
    fft(R, nfft, 0);
    for (int k = 0; k < nfft; k++) R[k].im = -R[k].im;
    double fif = sig_if(sig, fcn), fc = sig_carrier(sig, fcn);
    double step = cfg->dop_step > 0 ? cfg->dop_step : 1.0 / (2 * T);
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
                const uint8_t *xp = x4[s] + (size_t)p * Ns;
                for (int i = 0; i < Ns; i++) {
                    int xi, xq;
                    decode(xp[i], &xi, &xq);
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
    r->cn0 = snr > 0 ? 10 * log10(snr / T) : 0;
    r->found = r->ratio > cfg->thresh;
    if (!r->found) return 0;
    /* уточнение доплера: прямая корреляция в найденной фазе кода, сетка step/8 в ±step */
    double pv[17];
    int nf = 17;
    for (int j = 0; j < nf; j++) {
        double fd = r->doppler + (j - 8) * step / 8;
        double rate = si->chip_rate * (1 + fd / fc), acc = 0;
        for (int s = 0; s < nsnap; s++) {
            double cp0 = r->code_phase + rate * (double)(t0[s] - t0[0]) / FS_HZ;
            double ph0 = -(fif + fd) * (double)(t0[s] - t0[0]) / FS_HZ;
            uint32_t ph = (uint32_t)(int64_t)llround((ph0 - floor(ph0)) * 4294967296.0);
            uint32_t dph = (uint32_t)(int64_t)llround(-(fif + fd) / FS_HZ * 4294967296.0);
            for (int p = 0; p < nper; p++) {
                double re = 0, im = 0;
                const uint8_t *xp = x4[s] + (size_t)p * Ns;
                double u = cp0 + rate * (double)p * Ns / FS_HZ, du = rate / FS_HZ;
                for (int i = 0; i < Ns; i++, u += du) {
                    int xi, xq;
                    decode(xp[i], &xi, &xq);
                    float c = SIN256[((ph >> 24) + 64) & 255], sn = SIN256[ph >> 24];
                    float v = rep(si, L, u);
                    re += v * (xi * c - xq * sn);
                    im += v * (xi * sn + xq * c);
                    ph += dph;
                }
                acc += re * re + im * im;
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
    r->doppler += (jm - 8 + dj) * step / 8;
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
        const uint8_t *xp = x4 + (size_t)p * Ns;
        uint32_t ph = 0;
        for (int i = 0; i < Ns; i++) {
            int xi, xq;
            decode(xp[i], &xi, &xq);
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
    for (int w = 0; w < len / 8; w++) {
        uint32_t v = fpga_rd(R_SNAP_DATA + (uint32_t)w);
        for (int k = 0; k < 8; k++) x4[8 * w + k] = (uint8_t)((v >> (4 * k)) & 0xF);
    }
    return 1;
}
