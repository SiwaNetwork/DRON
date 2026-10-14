"""Генерация таблиц дальномерных кодов для ПО МК МГП-8 (src/gen/code_tab.c, inc/gen/code_tab.h)
и эталонных векторов для проверки генераторов на C (tests/vectors/codes.txt).

Источник — эталонная реализация Pocket SDR (BSD-2, sw/pyrx/third_party/pocketsdr) через
sw/pyrx/codes.py. Генераторы на РСЛОС реализованы в src/codes.c; здесь — только их таблицы
(начальные состояния, задержки) и коды, хранимые в памяти (Galileo E1/E6), и коды Вейля
(GPS L1C, BeiDou B1C) — упакованные биты первичного кода (1 = чип −1, младший бит — первый);
вторичные коды, задаваемые таблицей (Galileo E5a-Q — CS100, свой для каждого КА), и эталонные
векторы вторичных кодов (tests/vectors/sec.txt).
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
FW = os.path.abspath(os.path.join(HERE, ".."))
sys.path.insert(0, os.path.abspath(os.path.join(FW, "..")))
from pyrx import codes  # noqa: E402
from pyrx.third_party.pocketsdr import sdr_code as ref  # noqa: E402

# коды в памяти: сигнал -> список PRN
MEM = {
    "E1B": list(range(1, 37)), "E1C": list(range(1, 37)),
    "E6B": list(range(1, 37)), "E6C": list(range(1, 37)),
    "L1CP": list(range(1, 33)) + list(range(193, 203)),
    "L1CD": list(range(1, 33)) + list(range(193, 203)),
    "B1CP": list(range(1, 64)), "B1CD": list(range(1, 64)),
}
# коды, генерируемые на C, и проверяемые PRN
LFSR = {
    "L1CA": list(range(1, 33)) + list(range(120, 159)) + list(range(193, 203)),
    "L2CM": list(range(1, 33)), "L5I": list(range(1, 33)), "L5Q": list(range(1, 33)),
    "G1CA": [1], "G2CA": [1],
    "E5AI": list(range(1, 37)), "E5AQ": list(range(1, 37)),
    "E5BI": list(range(1, 37)), "E5BQ": list(range(1, 37)),
    "B1I": list(range(1, 64)), "B2I": list(range(1, 64)), "B3I": list(range(1, 64)),
    "B2AD": list(range(1, 64)), "B2AP": list(range(1, 64)), "B2BI": list(range(1, 64)),
    "I5S": list(range(1, 15)),
}
# вторичные коды в памяти: сигнал -> PRN (CS100 Galileo E5a-Q, 100 чипов)
SEC_MEM = {"E5AQ": list(range(1, 37))}
# эталонные вторичные коды для проверки sec_code() на C
SEC_REF = {"E1C": list(range(1, 37)), "L5Q": list(range(1, 33)), "E5AQ": list(range(1, 37)),
           "B1I": list(range(6, 59)), "B3I": list(range(6, 59))}
TABLES = ["L1CA_G2_delay", "L2CM_R_init_1", "L5I_XB_adv", "L5Q_XB_adv", "E5AI_X2_init",
          "E5AQ_X2_init", "E5BI_X2_init", "E5BQ_X2_init", "B2AD_G2_init", "B2AP_G2_init",
          "B2BI_G2_init", "B3I_G2_init", "I5S_G2_init"]


def chips(sig, prn):
    if sig in ("G1CA", "G2CA", "L1CA", "B1I", "B2I", "B3I", "L5I", "L5Q", "L2CM"):
        return codes.code(sig, prn).chips
    return codes.code(sig, prn, own=False).chips


def pack(c):
    bits = [1 if v < 0 else 0 for v in c]
    bits += [0] * (-len(bits) % 8)
    return bytes(sum(bits[i + k] << k for k in range(8)) for i in range(0, len(bits), 8))


def carr(name, vals, ctype="uint32_t"):
    body = ",".join(str(int(v)) for v in vals)
    return f"const {ctype} {name}[{len(vals)}] = {{{body}}};\n"


def main():
    os.makedirs(os.path.join(FW, "src", "gen"), exist_ok=True)
    os.makedirs(os.path.join(FW, "inc", "gen"), exist_ok=True)
    os.makedirs(os.path.join(FW, "tests", "vectors"), exist_ok=True)
    c = ["/* Сгенерировано tools/gen_tables.py — не редактировать.",
         " * Таблицы кодов из Pocket SDR (BSD-2, (c) T. Takasu), см. sw/pyrx/third_party/pocketsdr. */",
         '#include "gen/code_tab.h"', ""]
    h = ["/* Сгенерировано tools/gen_tables.py — не редактировать. */", "#ifndef CODE_TAB_H",
         "#define CODE_TAB_H", "#include <stdint.h>", ""]
    for t in TABLES:
        v = getattr(ref, t)
        c.append(carr(t, v))
        h.append(f"extern const uint32_t {t}[{len(v)}];")
    sel = ref.B1I_ph_sel
    c.append("const uint8_t B1I_ph_sel[63][3] = {" +
             ",".join("{" + ",".join(str(x) for x in (list(s) + [0, 0, 0])[:3]) + "}" for s in sel) + "};\n")
    h.append("extern const uint8_t B1I_ph_sel[63][3];")
    # коды в памяти
    h.append("")
    h.append("typedef struct { const char *sig; uint16_t len; uint16_t nprn; const uint16_t *prn; "
             "const uint8_t *bits; } mem_code_t;")
    h.append("extern const mem_code_t MEM_CODES[];")
    h.append("extern const int N_MEM_CODES;")
    entries = []
    for sig, prns in MEM.items():
        L = len(chips(sig, prns[0]))
        nb = (L + 7) // 8
        blob = b"".join(pack(chips(sig, p)) for p in prns)
        assert len(blob) == nb * len(prns)
        c.append(f"static const uint16_t PRN_{sig}[{len(prns)}] = {{{','.join(map(str, prns))}}};")
        lines = []
        for i in range(0, len(blob), 32):
            lines.append(",".join(f"0x{b:02x}" for b in blob[i:i + 32]))
        c.append(f"static const uint8_t BITS_{sig}[{len(blob)}] = {{\n" + ",\n".join(lines) + "};\n")
        entries.append(f'    {{"{sig}", {L}, {len(prns)}, PRN_{sig}, BITS_{sig}}}')
    c.append("const mem_code_t MEM_CODES[] = {\n" + ",\n".join(entries) + "\n};")
    c.append(f"const int N_MEM_CODES = {len(entries)};")
    # вторичные коды в памяти: SEC_<сигнал>[PRN − 1][байт]
    h.append("")
    for sig, prns in SEC_MEM.items():
        L = len(ref.sec_code(sig, prns[0]))
        nb = (L + 7) // 8
        rows = [pack(ref.sec_code(sig, p)) for p in prns]
        assert all(len(r) == nb for r in rows) and prns == list(range(1, len(prns) + 1))
        c.append(f"const uint8_t SEC_{sig}[{len(prns)}][{nb}] = {{\n" +
                 ",\n".join("{" + ",".join(f"0x{b:02x}" for b in r) + "}" for r in rows) + "};\n")
        h.append(f"#define SEC_{sig}_LEN {L}")
        h.append(f"extern const uint8_t SEC_{sig}[{len(prns)}][{nb}];")
    h += ["", "#endif"]
    open(os.path.join(FW, "src", "gen", "code_tab.c"), "w").write("\n".join(c) + "\n")
    open(os.path.join(FW, "inc", "gen", "code_tab.h"), "w").write("\n".join(h) + "\n")
    # эталонные векторы: «сигнал PRN длина hex»
    with open(os.path.join(FW, "tests", "vectors", "codes.txt"), "w") as f:
        for sig, prns in list(LFSR.items()) + list(MEM.items()):
            for p in prns:
                ch = chips(sig, p)
                f.write(f"{sig} {p} {len(ch)} {pack(ch).hex()}\n")
    with open(os.path.join(FW, "tests", "vectors", "sec.txt"), "w") as f:
        for sig, prns in SEC_REF.items():
            for p in prns:
                sc = ref.sec_code(sig, p)
                f.write(f"{sig} {p} {len(sc)} {pack(sc).hex()}\n")
    print("code_tab.c:", os.path.getsize(os.path.join(FW, "src", "gen", "code_tab.c")) // 1024, "КБ")


if __name__ == "__main__":
    main()
