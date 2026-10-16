/* МГП-8: загрузчик на модели флеш-памяти (6 секторов по 8 КБ, NOR: запись только 1 -> 0, повторная
 * запись слова без стирания — ошибка, как ECC у STM32H7): CRC-32, проверка образа, команды
 * протокола с дроблением потока и мусором между кадрами, отказ по искажённому кадру, неверный
 * указатель стека и CRC, поиск команды ENTER в ПО МК. */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "bootp.h"

static int fails;
#define CHECK(c, ...) do { if (!(c)) { printf("FAIL: " __VA_ARGS__); printf("\n"); fails++; } } while (0)

#define SEC   8192u
#define NSEC  6u
#define BASE  0x08020000u
static uint8_t  FL[SEC * NSEC];
static uint8_t  WR[SEC * NSEC / BOOTP_WORD];   /* слово записано после стирания */
static int      n_dbl, n_erase, n_prog;

static int f_erase(uint32_t off)
{
    if (off % SEC || off >= sizeof(FL)) return 1;
    memset(FL + off, 0xFF, SEC);
    memset(WR + off / BOOTP_WORD, 0, SEC / BOOTP_WORD);
    n_erase++;
    return 0;
}

static int f_prog(uint32_t off, const uint8_t *p)
{
    if (off % BOOTP_WORD || off >= sizeof(FL)) return 1;
    if (WR[off / BOOTP_WORD]) { n_dbl++; return 1; }
    WR[off / BOOTP_WORD] = 1;
    for (uint32_t i = 0; i < BOOTP_WORD; i++) FL[off + i] &= p[i];
    n_prog++;
    return memcmp(FL + off, p, BOOTP_WORD) != 0;
}

static const bootp_io_t IO = {f_erase, f_prog, FL, BASE, sizeof(FL), SEC};

/* последний ответ */
static uint8_t RB[256];
static int     rn, n_rep;
static void send(const uint8_t *p, int n) { memcpy(RB, p, (size_t)n); rn = n; n_rep++; }

static uint32_t rd32(const uint8_t *p) { return p[0] | p[1] << 8 | p[2] << 16 | (uint32_t)p[3] << 24; }
static void wr32(uint8_t *p, uint32_t v) { for (int i = 0; i < 4; i++) p[i] = (uint8_t)(v >> 8 * i); }

/* разбор ответа: состояние (−1 — нет ответа или неверный кадр), данные — в *pl */
static int reply(int id, const uint8_t **pl, int *plen)
{
    int cls, rid, used;
    static const uint8_t *dummy;
    static int dn;
    if (!pl) { pl = &dummy; plen = &dn; }
    if (!rn || mbp_parse(RB, rn, &cls, &rid, pl, plen, &used) != 1 || cls != MBP_BOOT || rid != (id | 0x80))
        return -1;
    return (*pl)[0];
}

static uint8_t FB[MBP_MAXLEN + 8];
static int frame(int id, const uint8_t *pl, int plen)
{
    memcpy(FB + 6, pl, (size_t)plen);
    return mbp_frame(FB, MBP_BOOT, id, plen);
}

/* команда целиком; состояние ответа */
static int cmd(bootp_t *b, int id, const uint8_t *pl, int plen, const uint8_t **rpl, int *rplen)
{
    rn = 0;
    bootp_feed(b, FB, frame(id, pl, plen));
    return reply(id, rpl, rplen);
}

static int cmd32(bootp_t *b, int id, uint32_t v)
{
    uint8_t p[4];
    wr32(p, v);
    return cmd(b, id, p, 4, 0, 0);
}

/* образ: векторы (SP, сброс), заголовок, псевдослучайное содержимое */
static uint8_t IMG[3 * SEC];
static uint32_t make_img(uint32_t size, uint32_t sp, uint32_t ver)
{
    srand(7);
    for (uint32_t i = 0; i < sizeof(IMG); i++) IMG[i] = (uint8_t)rand();
    wr32(IMG, sp);
    wr32(IMG + 4, BASE + 0x501);
    wr32(IMG + APP_HDR_OFF, APP_MAGIC);
    wr32(IMG + APP_HDR_OFF + 4, size);
    wr32(IMG + APP_HDR_OFF + 12, ver);
    uint32_t c = crc32_upd(crc32_upd(0, IMG, APP_HDR_OFF + 8), IMG + APP_HDR_OFF + 12, size - APP_HDR_OFF - 12);
    wr32(IMG + APP_HDR_OFF + 8, c);
    return c;
}

/* запись образа порциями по 1 КБ; поток дробится на куски 1…97 байт с мусором между кадрами */
static int load(bootp_t *b, uint32_t size)
{
    uint8_t pl[4 + 32 * BOOTP_WORD], st[3 * SEC / 1024 + 1];
    int nf = 0, k = 0;
    for (uint32_t off = 0; off < size; off += 32 * BOOTP_WORD) {
        uint32_t n = size - off < 32 * BOOTP_WORD ? size - off : 32 * BOOTP_WORD;
        wr32(pl, off);
        memcpy(pl + 4, IMG + off, n);
        int len = frame(BP_WRITE, pl, (int)(4 + n));
        static const uint8_t junk[] = {0x00, 0x4D, 0x4D, 0x37, 0xFF, 0x38};
        bootp_feed(b, junk, sizeof(junk));
        for (int i = 0; i < len;) {
            int m = 1 + rand() % 97;
            if (m > len - i) m = len - i;
            rn = 0;
            nf += bootp_feed(b, FB + i, m);
            i += m;
        }
        st[k++] = (uint8_t)reply(BP_WRITE, 0, 0);
    }
    int bad = 0;
    for (int i = 0; i < k; i++) bad += st[i] != BP_OK;
    return bad ? -bad : nf;
}

int main(void)
{
    static bootp_t B;
    const uint8_t *pl;
    int plen;

    /* 1. CRC-32 (zlib): контрольный вектор и составной расчёт */
    CHECK(crc32_upd(0, (const uint8_t *)"123456789", 9) == 0xCBF43926u, "CRC-32 %08X",
          crc32_upd(0, (const uint8_t *)"123456789", 9));
    CHECK(crc32_upd(crc32_upd(0, (const uint8_t *)"1234", 4), (const uint8_t *)"56789", 5) == 0xCBF43926u,
          "CRC-32 по частям");

    /* 2. чистая флеш-память: образа нет */
    for (uint32_t s = 0; s < NSEC; s++) f_erase(s * SEC);
    n_erase = 0;
    bootp_init(&B, &IO, send);
    CHECK(cmd(&B, BP_INFO, 0, 0, &pl, &plen) == BP_OK && plen == 26, "INFO: длина %d", plen);
    CHECK(rd32(pl + 1) == BOOT_VER && rd32(pl + 5) == BASE && rd32(pl + 9) == sizeof(FL) && rd32(pl + 13) == SEC &&
          pl[17] == 0, "INFO: поля");
    CHECK(cmd32(&B, BP_ENTER, BOOT_REQ_KEY) == BP_OK, "ENTER");
    CHECK(cmd32(&B, BP_ENTER, 1234) == BP_E_LEN, "ENTER с неверным ключом");
    CHECK(cmd(&B, BP_RUN, 0, 0, 0, 0) == BP_E_IMG && !B.run, "RUN без образа");
    CHECK(cmd(&B, 0x3F, 0, 0, 0, 0) == BP_E_CMD, "неизвестная команда");

    /* 3. ошибки стирания и записи */
    uint8_t w[4 + 64];
    memset(w, 0x11, sizeof(w));
    wr32(w, 0);
    CHECK(cmd(&B, BP_WRITE, w, 4 + 32, 0, 0) == BP_E_ERASE, "запись без стирания");
    CHECK(cmd32(&B, BP_ERASE, 100) == BP_E_ALIGN, "стирание: выравнивание");
    CHECK(cmd32(&B, BP_ERASE, NSEC * SEC) == BP_E_RANGE, "стирание: за пределами");
    CHECK(cmd(&B, BP_ERASE, w, 2, 0, 0) == BP_E_LEN, "стирание: длина");
    CHECK(cmd32(&B, BP_ERASE, 5 * SEC) == BP_OK && n_erase == 1, "стирание сектора 5");
    wr32(w, 5 * SEC + 64);
    CHECK(cmd(&B, BP_WRITE, w, 4 + 32, 0, 0) == BP_OK, "запись в сектор 5");
    wr32(w, 5 * SEC);
    CHECK(cmd(&B, BP_WRITE, w, 4 + 32, 0, 0) == BP_E_ERASE, "запись назад");
    wr32(w, 5 * SEC + 64);
    CHECK(cmd(&B, BP_WRITE, w, 4 + 32, 0, 0) == BP_E_ERASE, "повторная запись слова");
    wr32(w, 5 * SEC + 96);
    CHECK(cmd(&B, BP_WRITE, w, 4 + 20, 0, 0) == BP_E_LEN, "длина не кратна 32");
    wr32(w, 5 * SEC + 100);
    CHECK(cmd(&B, BP_WRITE, w, 4 + 32, 0, 0) == BP_E_ALIGN, "смещение не кратно 32");
    wr32(w, NSEC * SEC - 32);
    CHECK(cmd(&B, BP_WRITE, w, 4 + 64, 0, 0) == BP_E_RANGE, "запись за пределами");
    CHECK(n_dbl == 0, "повторная запись слова дошла до флеш-памяти: %d", n_dbl);

    /* 4. запись образа 20 000 байт (3 сектора) с дроблением потока */
    uint32_t size = 20000 / BOOTP_WORD * BOOTP_WORD + BOOTP_WORD;
    uint32_t crc = make_img(size, 0x20007E00u, 0x00010203u);
    for (uint32_t s = 0; s < 3; s++) CHECK(cmd32(&B, BP_ERASE, s * SEC) == BP_OK, "стирание %u", s);
    int nf = load(&B, size);
    CHECK(nf == (int)((size + 1023) / 1024), "запись образа: кадров %d", nf);
    CHECK(memcmp(FL, IMG, size) == 0 && n_dbl == 0, "содержимое флеш-памяти");
    CHECK(cmd(&B, BP_CHECK, 0, 0, &pl, &plen) == BP_OK && rd32(pl + 1) == size && rd32(pl + 5) == crc &&
          rd32(pl + 9) == 0x00010203u, "CHECK: размер %u CRC %08X", rd32(pl + 1), rd32(pl + 5));
    CHECK(bootp_valid(&IO, 1, 0) == 1, "образ верен");
    CHECK(cmd(&B, BP_INFO, 0, 0, &pl, &plen) == BP_OK && pl[17] == 1 && rd32(pl + 18) == 0x00010203u &&
          rd32(pl + 22) == size, "INFO: образ");

    /* 5. искажённый кадр — без ответа и без записи */
    uint8_t pw[4 + 32];
    wr32(pw, 5 * SEC + 128);
    memset(pw + 4, 0x22, 32);
    int len = frame(BP_WRITE, pw, sizeof(pw));
    FB[20] ^= 0x10;
    rn = 0;
    uint32_t e0 = B.n_err;
    bootp_feed(&B, FB, len);
    CHECK(rn == 0 && B.n_err > e0 && FL[5 * SEC + 128] == 0xFF, "искажённый кадр принят");
    CHECK(cmd(&B, BP_WRITE, pw, sizeof(pw), 0, 0) == BP_OK, "запись после искажённого кадра");

    /* 6. RUN */
    CHECK(cmd(&B, BP_RUN, 0, 0, 0, 0) == BP_OK && B.run, "RUN");

    /* 7. неверный указатель стека, вектор сброса и CRC */
    bootp_init(&B, &IO, send);
    make_img(size, 0x30000000u, 0x00010203u);
    CHECK(cmd32(&B, BP_ERASE, 0) == BP_OK && load(&B, SEC) > 0, "перезапись сектора 0");
    CHECK(cmd(&B, BP_CHECK, 0, 0, 0, 0) == BP_E_IMG && !bootp_valid(&IO, 0, 0), "SP вне DTCM/AXI принят");
    CHECK(cmd(&B, BP_RUN, 0, 0, 0, 0) == BP_E_IMG && !B.run, "RUN с неверным образом");
    make_img(size, 0x20007E04u, 0x00010203u);
    CHECK(cmd32(&B, BP_ERASE, 0) == BP_OK && load(&B, SEC) > 0 && !bootp_valid(&IO, 0, 0), "SP не кратен 8 принят");
    make_img(size, 0x20007E00u, 0x00010203u);
    wr32(IMG + 4, BASE + 0x500);
    wr32(IMG + APP_HDR_OFF + 8, crc32_upd(crc32_upd(0, IMG, APP_HDR_OFF + 8), IMG + APP_HDR_OFF + 12,
                                          size - APP_HDR_OFF - 12));
    CHECK(cmd32(&B, BP_ERASE, 0) == BP_OK && load(&B, SEC) > 0 && !bootp_valid(&IO, 0, 0), "вектор ARM принят");
    make_img(size, 0x20007E00u, 0x00010203u);
    IMG[3000] ^= 1;
    CHECK(cmd32(&B, BP_ERASE, 0) == BP_OK && load(&B, SEC) > 0, "перезапись сектора 0");
    CHECK(bootp_valid(&IO, 0, 0) && !bootp_valid(&IO, 1, 0) && cmd(&B, BP_CHECK, 0, 0, 0, 0) == BP_E_IMG,
          "искажение содержимого не обнаружено");
    IMG[3000] ^= 1;
    CHECK(cmd32(&B, BP_ERASE, 0) == BP_OK && load(&B, SEC) > 0 && bootp_valid(&IO, 1, 0), "восстановление");
    CHECK(n_dbl == 0, "повторная запись слова: %d", n_dbl);

    /* 8. ПО МК: поиск ENTER в потоке */
    uint8_t db[64];
    int dn = 0, hit = 0;
    uint8_t noise[300];
    for (int i = 0; i < (int)sizeof(noise); i++) noise[i] = (uint8_t)(i % 7 ? rand() : 0x4D);
    hit += bootp_detect(db, &dn, sizeof(db), noise, sizeof(noise));
    uint8_t key[4];
    wr32(key, 1234);
    len = frame(BP_ENTER, key, 4);
    hit += bootp_detect(db, &dn, sizeof(db), FB, len);
    len = frame(BP_INFO, 0, 0);
    hit += bootp_detect(db, &dn, sizeof(db), FB, len);
    CHECK(hit == 0, "ложное обнаружение ENTER");
    wr32(key, BOOT_REQ_KEY);
    len = frame(BP_ENTER, key, 4);
    hit = bootp_detect(db, &dn, sizeof(db), FB, 5);
    CHECK(hit == 0, "ENTER по части кадра");
    hit = bootp_detect(db, &dn, sizeof(db), FB + 5, len - 5);
    CHECK(hit == 1, "ENTER не обнаружен");

    printf("стираний %d, записей слов %d, кадров %u, ошибок кадров %u\n", n_erase, n_prog, B.n_frm, B.n_err);
    printf(fails ? "test_boot: %d FAIL\n" : "test_boot: OK%.0d\n", fails);
    return fails != 0;
}
