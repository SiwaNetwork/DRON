/* МГП-8: битово-точная модель ускорителя захвата ПЛИС (fpga/rtl/acq_fft.v).
 * Запуск — K периодов кода по Ns отсчётов, начала периодов — через Nper отсчётов (первый — сразу
 * или с отсчёта ACQ_T). Период: перенос на нулевую частоту (NCO 32 бит, таблица 64 × ±15),
 * усреднение в 2048 ячеек C (9 + 9 бит), прямое БПФ → спектр X (9 + 9 бит); для каждой из ng
 * гипотез доплера g — Z[k] = conj(X[(k + m_g) mod N])·R[k], прямое БПФ, |·|² со сдвигом и
 * накопление в A_g[(n + sh_g) mod N] с насыщением (18 бит). Сдвиг доплера кода sh_g — округлённая
 * сумма приращений DSH_g (ячеек·2^21) за период. БПФ — по основанию 2 с прореживанием по частоте,
 * на месте, 1 бабочка на такт: этап s — пары (a, a + D), D = 1024 >> s, поворот W^((a mod D)·2^s),
 * сумма/разность 19 бит, деление на 2 с округлением (маска этапов) или насыщение до 18 бит, поворот
 * с округлением 2^-16 и насыщением; выход последнего этапа — в двоично-инверсном порядке.
 * Из |FFT(conj(V))[n]|² = N²·|IFFT(V)[n]|² — только прямые БПФ, индексы ячеек — как в acq_weak_*. */
#include <math.h>
#include <string.h>
#include "fpga.h"
#include "acqf_sim.h"

#define N ACQF_N
static int TWC[1024], TWS[1024], CS15[64], tab_ok;

static void tabs(void)
{
    if (tab_ok) return;
    const double pi = 3.14159265358979323846;
    int T[513];
    for (int q = 0; q <= 512; q++) T[q] = (int)lround(65536.0 * cos(2 * pi * q / N));
    for (int t = 0; t < 1024; t++) {
        if (t <= 512) { TWC[t] = T[t]; TWS[t] = T[512 - t]; }
        else          { TWC[t] = -T[1024 - t]; TWS[t] = T[t - 512]; }
    }
    for (int k = 0; k < 64; k++) CS15[k] = (int)lround(15.0 * cos(2 * pi * (k + 0.5) / 64));
    tab_ok = 1;
}

static inline int32_t sat18(int64_t v) { return v > 131071 ? 131071 : v < -131072 ? -131072 : (int32_t)v; }
static inline int32_t sat9(int32_t v) { return v > 255 ? 255 : v < -255 ? -255 : v; }
static inline int32_t sx9(uint32_t v) { return (int32_t)(v & 511) - (int32_t)(v & 256) * 2; }
static inline uint32_t pk9(int32_t re, int32_t im) { return ((uint32_t)re & 511u) | ((uint32_t)im & 511u) << 9; }
static inline unsigned brev10(unsigned c)
{
    unsigned r = 0;
    for (int b = 0; b < 10; b++) r |= ((c >> b) & 1u) << (9 - b);
    return r;
}
static inline uint32_t keff(const acqf_t *m) { return ((m->K - 1) & 0xFFFFu) + 1; }

void acqf_reset(acqf_t *m)
{
    tabs();
    memset(m, 0, sizeof(*m));
}

static void fft11(int32_t *re, int32_t *im, unsigned mask)
{
    for (int s = 0; s < 11; s++) {
        int D = 1024 >> s, lm = D - 1, sc = (mask >> s) & 1;
        for (int c = 0; c < 1024; c++) {
            int a = ((c & ~lm) << 1) | (c & lm), b = a | D, t = (c << s) & 1023;
            int32_t sr = re[a] + re[b], si = im[a] + im[b], dr = re[a] - re[b], di = im[a] - im[b];
            if (sc) { sr = (sr + 1) >> 1; si = (si + 1) >> 1; dr = (dr + 1) >> 1; di = (di + 1) >> 1; }
            else    { sr = sat18(sr); si = sat18(si); dr = sat18(dr); di = sat18(di); }
            int64_t C = TWC[t], S = TWS[t];
            int64_t pr = dr * C + di * S, pi = di * C - dr * S;
            re[a] = sr; im[a] = si;
            re[b] = sat18((pr + 32768) >> 16);
            im[b] = sat18((pi + 32768) >> 16);
        }
    }
}

/* обработка периода из ячеек C; 1 — запуск завершён */
static int process(acqf_t *m)
{
    static int32_t re[N], im[N];
    unsigned fmask = m->scale & 0x7FF, imask = (m->scale >> 11) & 0x7FF;
    int psh = (int)((m->scale >> 22) & 31);
    int first = m->proc_p == 0, last = (uint32_t)m->proc_p + 1 == keff(m);
    for (int k = 0; k < N; k++) {
        uint32_t v = m->pool[14 + (k >> 10)][k & 1023];
        re[k] = sx9(v); im[k] = sx9(v >> 9);
    }
    fft11(re, im, fmask);
    for (unsigned c = 0; c < 1024; c++) {
        unsigned n = brev10(c);
        m->X[n] = pk9(sat9(re[2 * c]), sat9(im[2 * c]));
        m->X[n + 1024] = pk9(sat9(re[2 * c + 1]), sat9(im[2 * c + 1]));
    }
    for (int g = 0; g < m->ng; g++) {
        for (int k = 0; k < N; k++) {
            uint32_t x = m->X[(k + m->m[g]) & (N - 1)], r = m->R[k];
            int32_t xr = sx9(x), xi = sx9(x >> 9), rr = sx9(r), ri = sx9(r >> 9);
            re[k] = sat18((int64_t)xr * rr + (int64_t)xi * ri);
            im[k] = sat18((int64_t)xr * ri - (int64_t)xi * rr);
        }
        fft11(re, im, imask);
        uint32_t best = 0, bk = 0, sum = 0;
        for (unsigned c = 0; c < 1024; c++)
            for (unsigned h = 0; h < 2; h++) {
                unsigned p = 2 * c + h, idx = (brev10(c) + 1024 * h + (unsigned)m->sh_cap[g]) & (N - 1);
                uint64_t pw = (uint64_t)((int64_t)re[p] * re[p] + (int64_t)im[p] * im[p]);
                if (psh) pw = (pw + (1ull << (psh - 1))) >> psh;
                if (pw > 262143u) pw = 262143u;
                uint32_t *a = &m->pool[2 * g + (idx >> 10)][idx & 1023];
                uint32_t nv = first ? (uint32_t)pw : *a + (uint32_t)pw;
                if (nv > 262143u) nv = 262143u;
                *a = nv;
                if (last) {
                    if (nv > best) { best = nv; bk = idx; }
                    sum += nv;
                }
            }
        if (last) { m->peak[g] = best | bk << 18; m->sum[g] = sum; }
    }
    m->proc_p++;
    if (last) { m->busy = 0; return 1; }
    return 0;
}

int acqf_sample(acqf_t *m, uint32_t count, uint32_t w)
{
    if (!m->busy) return 0;
    if (!m->rec && (uint32_t)m->cap_p < keff(m)) {
        int go = m->cap_p ? count == m->t_next : (!(m->ctrl & 2u) || count == m->t_start);
        if (go) {
            if (m->cap_p == 0) { m->t_ref = count; memset(m->phi, 0, sizeof(m->phi)); }
            for (int g = 0; g < ACQF_G; g++) {
                m->sh_cap[g] = (int)(((m->phi[g] + (1u << 20)) >> 21) & 2047u);
                m->phi[g] += m->dsh[g];
            }
            m->t_next = count + m->nper;
            m->rec = 1; m->i = 0; m->k = 0; m->r = 0; m->bre = 0; m->bim = 0; m->ph = 0;
            m->cap_p++;
        }
    }
    if (!m->rec) return 0;
    unsigned x = (w >> (4 * m->ch)) & 15u;
    int xi = ((x >> 2) & 1 ? 3 : 1) * ((x >> 3) & 1 ? -1 : 1);
    int xq = ((x & 1) ? 3 : 1) * ((x >> 1) & 1 ? -1 : 1);
    int j = (int)(m->ph >> 26), c = CS15[j], s = CS15[(j - 16) & 63];
    m->bre += xi * c + xq * s;
    m->bim += xq * c - xi * s;
    m->ph += m->dphi;
    m->r += N;
    if (m->r >= m->ns) {
        int csh = (int)((m->scale >> 27) & 3);
        int32_t br = m->bre, bi = m->bim;
        if (csh) { br = (br + (1 << (csh - 1))) >> csh; bi = (bi + (1 << (csh - 1))) >> csh; }
        m->pool[14 + ((m->k >> 10) & 1)][m->k & 1023] = pk9(sat9(br), sat9(bi));
        m->r -= m->ns; m->k++; m->bre = 0; m->bim = 0;
    }
    if (++m->i == m->ns) { m->rec = 0; return process(m); }
    return 0;
}

void acqf_wr(acqf_t *m, uint32_t a, uint32_t v)
{
    if (a >= R_ACQ_MEM && a < R_ACQ_MEM + N) { m->R[a - R_ACQ_MEM] = v & 0x3FFFFu; return; }
    if (a >= R_ACQ_M(0) && a < R_ACQ_M(ACQF_G)) { m->m[a - R_ACQ_M(0)] = v & 2047u; return; }
    if (a >= R_ACQ_DSH(0) && a < R_ACQ_DSH(ACQF_G)) { m->dsh[a - R_ACQ_DSH(0)] = v; return; }
    switch (a) {
    case R_ACQ_CTRL:
        if (v & 4u) { m->busy = 0; m->rec = 0; break; }
        if (!(v & 1u) || m->busy) break;
        m->ctrl = v & 0x772u;
        m->ng = (int)((v >> 4) & 7u); if (m->ng == 0) m->ng = 1;
        m->ch = (int)((v >> 8) & 7u);
        m->rec = 0; m->cap_p = 0; m->proc_p = 0;
        /* расписание: следующий период начинается после чтения ячеек C прямым БПФ, обработка
         * периода укладывается в шаг Nper; иначе — отказ в пуске (сбой расписания) */
        m->ovr = m->ns < N || m->nper < m->ns + 300 || 4ull * m->nper < ACQF_PROC_CLK(m->ng);
        m->busy = !m->ovr;
        break;
    case R_ACQ_DPHI:  m->dphi = v; break;
    case R_ACQ_K:     m->K = v & 0xFFFFu; break;
    case R_ACQ_NS:    m->ns = v & 0x1FFFFu; break;
    case R_ACQ_NPER:  m->nper = v & 0x1FFFFu; break;
    case R_ACQ_SCALE: m->scale = v & 0x1FFFFFFFu; break;
    case R_ACQ_T:     m->t_start = v; break;
    default: break;
    }
}

uint32_t acqf_rd(const acqf_t *m, uint32_t a)
{
    if (a >= R_ACQ_MEM && a < R_ACQ_MEM + 0x4000u) {
        uint32_t o = a - R_ACQ_MEM;
        return m->pool[(o >> 10) & 15][o & 1023];
    }
    if (a >= R_ACQ_M(0) && a < R_ACQ_M(ACQF_G)) return m->m[a - R_ACQ_M(0)];
    if (a >= R_ACQ_DSH(0) && a < R_ACQ_DSH(ACQF_G)) return m->dsh[a - R_ACQ_DSH(0)];
    if (a >= R_ACQ_PEAK(0) && a < R_ACQ_PEAK(ACQF_G)) return m->peak[a - R_ACQ_PEAK(0)];
    if (a >= R_ACQ_SUM(0) && a < R_ACQ_SUM(ACQF_G)) return m->sum[a - R_ACQ_SUM(0)];
    switch (a) {
    case R_ACQ_CTRL:  return m->ctrl | (uint32_t)m->ovr << 30 | (uint32_t)m->busy << 31;
    case R_ACQ_STAT:  return (uint32_t)m->proc_p & 0xFFFFu;
    case R_ACQ_DPHI:  return m->dphi;
    case R_ACQ_K:     return m->K;
    case R_ACQ_NS:    return m->ns;
    case R_ACQ_NPER:  return m->nper;
    case R_ACQ_SCALE: return m->scale;
    case R_ACQ_T:     return m->t_start;
    case R_ACQ_T0:    return m->t_ref;
    default: return 0;
    }
}

void acqf_snap_wr(acqf_t *m, uint32_t wa, uint32_t v)
{
    unsigned p = (wa >> 10) & 7, a = wa & 1023;
    m->pool[2 * p][a] = v & 0xFFFFu;
    m->pool[2 * p + 1][a] = v >> 16;
}

uint32_t acqf_snap_rd(const acqf_t *m, uint32_t wa)
{
    unsigned p = (wa >> 10) & 7, a = wa & 1023;
    return (m->pool[2 * p][a] & 0xFFFFu) | (m->pool[2 * p + 1][a] & 0xFFFFu) << 16;
}
