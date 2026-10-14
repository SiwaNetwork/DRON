/* Проверка генераторов кодов: сравнение с эталонными векторами tests/vectors/codes.txt
 * (Pocket SDR через sw/pyrx/codes.py); вторичные коды — с tests/vectors/sec.txt (Pocket SDR). */
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
    /* вторичные коды: «сигнал PRN длина hex», упаковка — как у первичных */
    fp = fopen("tests/vectors/sec.txt", "r");
    if (!fp) { printf("нет файла векторов вторичных кодов\n"); return 1; }
    int ns = 0, bad2 = 0;
    memset(nsig, 0, sizeof(nsig));
    while (fscanf(fp, "%15s %d %d %s", sid, &prn, &len, hex) == 4) {
        int sig = sig_by_id(sid);
        uint8_t sb[SEC_MAX_LEN];
        int L = sig >= 0 ? sec_code(sig, prn, sb) : 0, e = L != len;
        for (int i = 0; i < len && !e; i++) {
            unsigned v;
            sscanf(hex + 2 * (i / 8), "%2x", &v);
            e = sb[i] != ((v >> (i % 8)) & 1);
        }
        if (e) {
            if (bad2 < 10) printf("  ОШИБКА вторичного кода %s PRN %d: длина %d (ожидалось %d)\n", sid, prn, L, len);
            bad2++;
        } else if (sig >= 0) nsig[sig]++;
        ns++;
    }
    fclose(fp);
    printf("Вторичные коды: проверено %d, ошибок %d\n", ns, bad2);
    for (int s = 0; s < SIG_N; s++) if (nsig[s]) printf("  %-5s %3d PRN — совпадают\n", SIGS[s].id, nsig[s]);
    return bad != 0 || bad2 != 0 || ns == 0;
}
