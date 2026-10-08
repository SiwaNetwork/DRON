/* МГП-8: кодирование RTCM 3.3 (RTCM 10403.3): кадр (преамбула 0xD3, длина, CRC-24Q),
 * MSM7 (табл. 3.5-78…3.5-80), 1005. */
#include <math.h>
#include <string.h>
#include "gnss.h"
#include "rtcm3.h"

#define RANGE_MS (CLIGHT * 1e-3)

static void setbitu(uint8_t *b, int pos, int len, uint64_t v)
{
    for (int i = 0; i < len; i++) {
        int p = pos + i;
        if ((v >> (len - 1 - i)) & 1) b[p >> 3] |= (uint8_t)(0x80u >> (p & 7));
        else b[p >> 3] &= (uint8_t)~(0x80u >> (p & 7));
    }
}

static void setbits(uint8_t *b, int pos, int len, int64_t v)
{
    setbitu(b, pos, len, (uint64_t)v & ((len < 64) ? ((1ull << len) - 1) : ~0ull));
}

/* знаковое поле с ограничением: при выходе за диапазон — значение «недостоверно» (мин. код) */
static void setbits_lim(uint8_t *b, int pos, int len, double v)
{
    int64_t lim = (1ll << (len - 1)) - 1, x = llround(v);
    if (x > lim || x < -lim) x = -lim - 1;
    setbits(b, pos, len, x);
}

uint32_t rtcm_crc24q(const uint8_t *buf, int len)
{
    uint32_t crc = 0;
    for (int i = 0; i < len; i++) {
        crc ^= (uint32_t)buf[i] << 16;
        for (int k = 0; k < 8; k++) {
            crc <<= 1;
            if (crc & 0x1000000) crc ^= 0x1864CFB;
        }
    }
    return crc & 0xFFFFFF;
}

static int frame(uint8_t *buf, int nbits)
{
    int len = (nbits + 7) / 8;
    memmove(buf + 3, buf, (size_t)len);
    buf[0] = 0xD3;
    buf[1] = (uint8_t)((len >> 8) & 3);
    buf[2] = (uint8_t)len;
    uint32_t crc = rtcm_crc24q(buf, len + 3);
    buf[len + 3] = (uint8_t)(crc >> 16);
    buf[len + 4] = (uint8_t)(crc >> 8);
    buf[len + 5] = (uint8_t)crc;
    return len + 6;
}

/* показатель времени захвата фазы DF407 (10 бит, расширенный диапазон, табл. 3.5-74):
 * t < 64 мс — t; на интервале [2^(k+5), 2^(k+6)) мс — (t + k·2^(k+5)) / 2^k */
static int lock_ind(double t_s)
{
    long t = (long)(t_s * 1000);
    if (t < 64) return (int)t;
    for (int k = 1; k <= 20; k++)
        if (t < (1L << (k + 6))) return (int)((t + (long)k * (1L << (k + 5))) >> k);
    return 704;
}

int rtcm_msm7(uint8_t *buf, int sys, int station, uint32_t epoch_ms, int multi, const msm_obs_t *o, int n)
{
    static const int msgno[SYS_N] = {1077, 1087, 1097, 1127, 1117, 1137, 1107};
    uint8_t *b = buf;
    memset(b, 0, 1029);
    /* маски спутников и сигналов */
    uint64_t smask = 0;
    uint32_t gmask = 0;
    for (int i = 0; i < n; i++) {
        if (o[i].prn < 1 || o[i].prn > 64 || o[i].sig < 1 || o[i].sig > 32) continue;
        smask |= 1ull << (64 - o[i].prn);
        gmask |= 1u << (32 - o[i].sig);
    }
    int sats[64], ns = 0, sigs[32], ng = 0;
    for (int k = 1; k <= 64; k++) if (smask >> (64 - k) & 1) sats[ns++] = k;
    for (int k = 1; k <= 32; k++) if (gmask >> (32 - k) & 1) sigs[ng++] = k;
    int i = 0;
    setbitu(b, i, 12, (uint64_t)msgno[sys]); i += 12;
    setbitu(b, i, 12, (uint64_t)station); i += 12;
    setbitu(b, i, 30, epoch_ms); i += 30;
    setbitu(b, i, 1, (uint64_t)(multi != 0)); i += 1;
    setbitu(b, i, 3, 0); i += 3;                  /* IODS */
    setbitu(b, i, 7, 0); i += 7;                  /* резерв */
    setbitu(b, i, 2, 0); i += 2;                  /* регулировка часов: нет */
    setbitu(b, i, 2, 0); i += 2;                  /* внешние часы: нет */
    setbitu(b, i, 1, 0); i += 1;                  /* сглаживание: нет */
    setbitu(b, i, 3, 0); i += 3;
    setbitu(b, i, 64, smask); i += 64;
    setbitu(b, i, 32, gmask); i += 32;
    /* маска ячеек и индексы наблюдений */
    int cell[64][32];
    for (int s = 0; s < ns; s++)
        for (int g = 0; g < ng; g++) {
            cell[s][g] = -1;
            for (int k = 0; k < n; k++) if (o[k].prn == sats[s] && o[k].sig == sigs[g]) cell[s][g] = k;
            setbitu(b, i++, 1, cell[s][g] >= 0);
        }
    /* грубая дальность по КА: целые мс и доли 2^-10 мс; грубая скорость изменения фазовой дальности */
    double rr[64], rate[64];
    int fcn[64];
    for (int s = 0; s < ns; s++) {
        rr[s] = 0; rate[s] = 0; fcn[s] = 0;
        for (int g = 0; g < ng; g++) {
            int k = cell[s][g];
            if (k < 0) continue;
            rr[s] = floor(o[k].pr / RANGE_MS * 1024 + 0.5) / 1024;
            rate[s] = floor(-o[k].dop * o[k].lam + 0.5);
            fcn[s] = o[k].fcn;
            break;
        }
    }
    for (int s = 0; s < ns; s++) { setbitu(b, i, 8, (uint64_t)(int)floor(rr[s])); i += 8; }
    for (int s = 0; s < ns; s++) { setbitu(b, i, 4, sys == SYS_GLO ? (uint64_t)(fcn[s] + 7) : 0); i += 4; }
    for (int s = 0; s < ns; s++) { setbitu(b, i, 10, (uint64_t)llround((rr[s] - floor(rr[s])) * 1024)); i += 10; }
    for (int s = 0; s < ns; s++) { setbits_lim(b, i, 14, rate[s]); i += 14; }
    /* данные ячеек */
    for (int pass = 0; pass < 6; pass++)
        for (int s = 0; s < ns; s++)
            for (int g = 0; g < ng; g++) {
                int k = cell[s][g];
                if (k < 0) continue;
                const msm_obs_t *q = &o[k];
                switch (pass) {
                case 0: setbits_lim(b, i, 20, (q->pr / RANGE_MS - rr[s]) / ldexp(1, -29)); i += 20; break;
                case 1:
                    if (q->cp != 0) setbits_lim(b, i, 24, (q->cp * q->lam / RANGE_MS - rr[s]) / ldexp(1, -31));
                    else setbits(b, i, 24, -(1ll << 23));
                    i += 24; break;
                case 2: setbitu(b, i, 10, (uint64_t)lock_ind(q->lock)); i += 10; break;
                case 3: setbitu(b, i, 1, (uint64_t)q->half); i += 1; break;
                case 4: setbitu(b, i, 10, (uint64_t)llround(q->cn0 * 16)); i += 10; break;
                case 5: setbits_lim(b, i, 15, (-q->dop * q->lam - rate[s]) / 0.0001); i += 15; break;
                }
            }
    return frame(buf, i);
}

int rtcm_1005(uint8_t *buf, int station, const double *ecef)
{
    uint8_t *b = buf;
    memset(b, 0, 32);
    int i = 0;
    setbitu(b, i, 12, 1005); i += 12;
    setbitu(b, i, 12, (uint64_t)station); i += 12;
    setbitu(b, i, 6, 0); i += 6;                  /* ITRF год */
    setbitu(b, i, 1, 1); i += 1;                  /* GPS */
    setbitu(b, i, 1, 1); i += 1;                  /* ГЛОНАСС */
    setbitu(b, i, 1, 1); i += 1;                  /* Galileo */
    setbitu(b, i, 1, 0); i += 1;                  /* опорная станция (не виртуальная) */
    setbits(b, i, 38, llround(ecef[0] / 0.0001)); i += 38;
    setbitu(b, i, 1, 0); i += 1;                  /* одиночный генератор */
    setbitu(b, i, 1, 0); i += 1;
    setbits(b, i, 38, llround(ecef[1] / 0.0001)); i += 38;
    setbitu(b, i, 2, 0); i += 2;
    setbits(b, i, 38, llround(ecef[2] / 0.0001)); i += 38;
    return frame(buf, i);
}
