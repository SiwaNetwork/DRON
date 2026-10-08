/* МГП-8: генераторы дальномерных кодов.
 * Генераторы на РСЛОС — перенос эталонной реализации Pocket SDR (BSD-2, (c) T. Takasu) в форме
 * LFSR(N, R, tap, n): выход R & 1, обратная связь — чётность (R & tap) в разряд n−1.
 * Коды в памяти (Galileo E1/E6) и коды Вейля (GPS L1C, BeiDou B1C) — из таблиц
 * src/gen/code_tab.c (tools/gen_tables.py). Проверка — tests/test_codes.c. */
#include <string.h>
#include "gnss.h"
#include "codes.h"
#include "gen/code_tab.h"

static uint8_t s1[CODE_MAX_LEN], s2[CODE_MAX_LEN];

static int parity(uint32_t x)
{
    x ^= x >> 16; x ^= x >> 8; x ^= x >> 4; x ^= x >> 2; x ^= x >> 1;
    return (int)(x & 1);
}

static void lfsr(int N, uint32_t R, uint32_t tap, int n, uint8_t *out)
{
    for (int i = 0; i < N; i++) {
        out[i] = (uint8_t)(R & 1);
        R = ((uint32_t)parity(R & tap) << (n - 1)) | (R >> 1);
    }
}

static uint32_t rev_reg(uint32_t R, int N)
{
    uint32_t RR = 0;
    for (int i = 0; i < N; i++) RR = (RR << 1) | ((R >> i) & 1);
    return RR;
}

/* G1 с периодом 8190, продлённый до N чипов */
static void lfsr8190(int N, uint32_t tap, uint8_t *out)
{
    lfsr(8190, 0x1FFF, tap, 13, out);
    memcpy(out + 8190, out, (size_t)(N - 8190));
}

static int pack(const uint8_t *b, int N, uint8_t *bits)
{
    memset(bits, 0, (size_t)(N + 7) / 8);
    for (int i = 0; i < N; i++) bits[i >> 3] |= (uint8_t)(b[i] << (i & 7));
    return N;
}

static int pack_xor(const uint8_t *a, const uint8_t *b, int N, uint8_t *bits)
{
    memset(bits, 0, (size_t)(N + 7) / 8);
    for (int i = 0; i < N; i++) bits[i >> 3] |= (uint8_t)((a[i] ^ b[i]) << (i & 7));
    return N;
}

static int mem_code(const char *sig, int prn, uint8_t *bits)
{
    for (int k = 0; k < N_MEM_CODES; k++) {
        const mem_code_t *m = &MEM_CODES[k];
        if (strcmp(m->sig, sig)) continue;
        for (int j = 0; j < m->nprn; j++) {
            if (m->prn[j] != prn) continue;
            int nb = (m->len + 7) / 8;
            memcpy(bits, m->bits + (size_t)j * nb, (size_t)nb);
            return m->len;
        }
    }
    return 0;
}

int code_gen(int sig, int prn, uint8_t *bits)
{
    int N;
    switch (sig) {
    case SIG_L1CA:                                   /* IS-GPS-200; QZSS, SBAS */
        if (prn < 1 || prn > 210) return 0;
        N = 1023;
        lfsr(N, 0x3FF, 0x081, 10, s1);
        lfsr(N, 0x3FF, 0x197, 10, s2);
        {
            int d = (int)L1CA_G2_delay[prn - 1];
            memset(bits, 0, (N + 7) / 8);
            for (int i = 0; i < N; i++)
                bits[i >> 3] |= (uint8_t)((s1[i] ^ s2[(i - d + N) % N]) << (i & 7));
        }
        return N;
    case SIG_L2CM:                                   /* IS-GPS-200, модульный РСЛОС 27 разрядов */
        if (prn < 1 || prn > 63) return 0;
        {
            uint32_t R = L2CM_R_init_1[prn - 1];
            N = 10230;
            for (int i = 0; i < N; i++) {
                s1[i] = (uint8_t)(R & 1);
                R = (R >> 1) ^ (0x494953Cu * (R & 1));
            }
        }
        return pack(s1, N, bits);
    case SIG_L5I: case SIG_L5Q:                      /* IS-GPS-705 */
        if (prn < 1 || prn > 210) return 0;
        N = 10230;
        lfsr8190(N, 0x001B, s1);
        lfsr(N, 0x1FFF, 0x16E3, 13, s2);
        {
            int adv = (int)(sig == SIG_L5I ? L5I_XB_adv : L5Q_XB_adv)[prn - 1];
            memset(bits, 0, (N + 7) / 8);
            for (int i = 0; i < N; i++)
                bits[i >> 3] |= (uint8_t)((s1[i] ^ s2[(i + adv) % N]) << (i & 7));
        }
        return N;
    case SIG_G1CA: case SIG_G2CA:                    /* ИКД ГЛОНАСС ред. 5.1, код общий */
        {
            uint32_t R = 0x1FF;
            N = 511;
            for (int i = 0; i < N; i++) {
                s1[i] = (uint8_t)((R >> 2) & 1);
                R = ((uint32_t)parity(R & 0x011) << 8) | (R >> 1);
            }
        }
        return pack(s1, N, bits);
    case SIG_E5AI: case SIG_E5AQ: case SIG_E5BI: case SIG_E5BQ:   /* Galileo OS SIS ICD */
        if (prn < 1 || prn > 50) return 0;
        {
            static const uint32_t t1[4] = {040503, 040503, 064021, 064021};
            static const uint32_t t2[4] = {050661, 050661, 051445, 043143};
            const uint32_t *init[4] = {E5AI_X2_init, E5AQ_X2_init, E5BI_X2_init, E5BQ_X2_init};
            int k = sig - SIG_E5AI;
            N = 10230;
            lfsr(N, 0x3FFF, rev_reg(t1[k] >> 1, 14), 14, s1);
            lfsr(N, rev_reg(init[k][prn - 1], 14), rev_reg(t2[k] >> 1, 14), 14, s2);
        }
        return pack_xor(s1, s2, N, bits);
    case SIG_B1I: case SIG_B2I:                      /* BDS-SIS-ICD B1I 3.0 */
        if (prn < 1 || prn > 63) return 0;
        {
            uint32_t tap = 0, R = 0x2AA;
            N = 2046;
            for (int k = 0; k < 3; k++)
                if (B1I_ph_sel[prn - 1][k]) tap |= 1u << (11 - B1I_ph_sel[prn - 1][k]);
            lfsr(N, 0x2AA, 0x41F, 11, s1);
            for (int i = 0; i < N; i++) {
                s2[i] = (uint8_t)parity(R & tap);
                R = ((uint32_t)parity(R & 0x7CD) << 10) | (R >> 1);
            }
        }
        return pack_xor(s1, s2, N, bits);
    case SIG_B3I:                                    /* BDS-SIS-ICD B3I 1.0 */
        if (prn < 1 || prn > 63) return 0;
        N = 10230;
        lfsr8190(N, 0x1601, s1);
        lfsr(N, B3I_G2_init[prn - 1], 0x11DB, 13, s2);
        return pack_xor(s1, s2, N, bits);
    case SIG_B2AD: case SIG_B2AP: case SIG_B2BI:     /* BDS-SIS-ICD B2a 1.0, B2b 1.0 */
        if (prn < 1 || prn > 63) return 0;
        {
            static const uint32_t g1t[3] = {0x1105, 0x04C1, 0x1019};
            static const uint32_t g2t[3] = {0x0517, 0x1163, 0x0693};
            const uint32_t *init[3] = {B2AD_G2_init, B2AP_G2_init, B2BI_G2_init};
            int k = sig == SIG_B2AD ? 0 : sig == SIG_B2AP ? 1 : 2;
            N = 10230;
            lfsr8190(N, g1t[k], s1);
            lfsr(N, init[k][prn - 1], g2t[k], 13, s2);
        }
        return pack_xor(s1, s2, N, bits);
    case SIG_I5S:                                    /* NavIC SPS ICD 1.1 */
        if (prn < 1 || prn > 14) return 0;
        N = 1023;
        lfsr(N, 0x3FF, 0x081, 10, s1);
        lfsr(N, rev_reg(I5S_G2_init[prn - 1], 10), 0x197, 10, s2);
        return pack_xor(s1, s2, N, bits);
    default:
        return mem_code(SIGS[sig].id, prn, bits);
    }
}

int sec_code(int sig, int prn, uint8_t *bits)
{
    static const char CS25[] = "0011100000001010110110010";      /* E1C, CS25_1 = 0x380AD90 */
    static const char NH20[] = "00000100110101001110";           /* L5Q, NH20 = 0x04D4E */
    const char *c = sig == SIG_E1C ? CS25 : sig == SIG_L5Q ? NH20 : NULL;
    (void)prn;
    if (!c) return 0;
    int n = (int)strlen(c);
    for (int i = 0; i < n; i++) bits[i] = (uint8_t)(c[i] == '1');
    return n;
}
