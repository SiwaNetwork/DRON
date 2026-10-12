/* Проверка генераторов кодов: сравнение с эталонными векторами tests/vectors/codes.txt
 * (Pocket SDR через sw/pyrx/codes.py). */
#include <stdio.h>
#include <string.h>
#include "gnss.h"
#include "codes.h"

int main(void)
{
    FILE *fp = fopen("tests/vectors/codes.txt", "r");
    if (!fp) { printf("нет файла векторов\n"); return 1; }
    static char hex[2 * CODE_MAX_BYTES + 16], sid[16];
    static uint8_t ref[CODE_MAX_BYTES], got[CODE_MAX_BYTES];
    int prn, len, n = 0, bad = 0, nsig[SIG_N] = {0};
    while (fscanf(fp, "%15s %d %d %s", sid, &prn, &len, hex) == 4) {
        int sig = sig_by_id(sid);
        int nb = (len + 7) / 8;
        for (int i = 0; i < nb; i++) { unsigned v; sscanf(hex + 2 * i, "%2x", &v); ref[i] = (uint8_t)v; }
        int L = sig >= 0 ? code_gen(sig, prn, got) : 0;
        if (L != len || memcmp(ref, got, (size_t)nb)) {
            if (bad < 10) printf("  ОШИБКА %s PRN %d: длина %d (ожидалось %d)\n", sid, prn, L, len);
            bad++;
        } else if (sig >= 0) nsig[sig]++;
        n++;
    }
    fclose(fp);
    printf("Коды: проверено %d, ошибок %d\n", n, bad);
    for (int s = 0; s < SIG_N; s++) if (nsig[s]) printf("  %-5s %3d PRN — совпадают\n", SIGS[s].id, nsig[s]);
    return bad != 0;
}
