"""Сценарий системного теста ПЛИС (tb/tb_mgp8.v): настройка через шину FMC, отсчёты на выводах
MAX2771, эталонные сбросы корреляторов (битово-точная модель).

  python3 tb/gen_sys.py gen    -> tb/stim/sys_*.hex, tb/out/sys_model.txt
  python3 tb/gen_sys.py check  -> сверка tb/out/sys_rtl.txt с моделью и проверка прочих блоков
"""
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(HERE, "..", "model"))
import gen_stim as G   # noqa: E402
import notch_model as NM  # noqa: E402
M = G.M

NSMP = int(os.environ.get("NSMP", 72000))       # 3 мс: ~0,8 мс настройка через FMC, далее слежение
STIM, OUTD = G.STIM, G.OUTD
CORR = 0x1000
# (движок, слот, строка таблицы gen_stim.SLOTS)
MAP = [(0, 0, 0), (0, 1, 2), (0, 2, 3), (0, 7, 12), (1, 0, 1), (1, 15, 7)]
# режекторный фильтр: ВЧ-канал 1 (ГЛОНАСС L1) — «помеха» на ПЧ +2,3 МГц, μ = 6, дизеринг
NOTCH = {1: (int(round(2.3e6 / 24e6 * 2 ** 32)), 6, 1)}


def ch_addr(e, s, r):
    return CORR + (e << 9) + (s << 4) + r


def eng_addr(e, r):
    return CORR + (e << 9) + 0x100 + r


def gen():
    os.makedirs(STIM, exist_ok=True)
    os.makedirs(OUTD, exist_ok=True)
    G.NSMP = NSMP
    sig, words = G.scenario()
    chans_all, _ = G.channels(sig)
    # выбранные каналы и команды шины FMC: (вид, адрес, данные); вид 0 — запись, 1 — запись кода
    # (после неё — ожидание BUSY движка)
    cmds = [(0, 0x0A, 0x1)]                       # IRQ_MASK: корреляторы
    mu = 0x88888888
    for k, (d, m, _) in NOTCH.items():
        mu = (mu & ~(0xF << (4 * k))) | (m << (4 * k))
        cmds.append((0, 0x58 + k, d))
    cmds.append((0, 0x51, mu))
    cmds.append((0, 0x50, sum(1 << k for k in NOTCH) | (sum(1 << k for k, v in NOTCH.items() if v[2]) << 16)))
    chans = []
    for e, s, row in MAP:
        ch = chans_all[row]
        isig = G.SLOTS[row][0]
        allsig = sig + G.noise_sigs()
        spec = allsig[isig][1]
        bits = (spec.chips < 0).astype(int)
        ctrl = ch.ctrl
        cmds += [(0, ch_addr(e, s, 0), ctrl), (0, ch_addr(e, s, 1), ch.L),
                 (0, ch_addr(e, s, 2), ch.carr_rate), (0, ch_addr(e, s, 3), ch.code_rate),
                 (0, ch_addr(e, s, 4), ch.carr_phase), (0, ch_addr(e, s, 5), ch.ci),
                 (0, ch_addr(e, s, 6), ch.cf), (0, ch_addr(e, s, 7), ch.spacing)]
        cmds.append((0, eng_addr(e, 0), s << 16))
        for w in M.code_words(bits, ch.L):
            cmds.append((1, eng_addr(e, 1), w))
        chans.append((e, s, ch))
    with open(os.path.join(STIM, "sys_cmd.hex"), "w") as f:
        f.write(f"{len(cmds):08x}\n")
        for k, a, d in cmds:
            f.write(f"{k:08x}\n{a:08x}\n{d & M.M32:08x}\n")
    with open(os.path.join(STIM, "sys_smp.hex"), "w") as f:
        f.write(f"{NSMP:08x}\n")
        f.write("\n".join(f"{w:08x}" for w in words[:NSMP]) + "\n")
    print("Системный сценарий:", NSMP, "отсчётов, каналов:", len(chans), ", команд FMC:", len(cmds))
    return words, chans


def model(st, end, n_notch):
    """Эталон: режекторный фильтр — с отсчёта n_notch, каналы включаются с отсчёта st
    (регистры START_T/START_MASK)."""
    words, chans = gen()
    words = np.array(words, dtype=np.uint32)
    words[n_notch:] = NM.run(words[n_notch:], NOTCH)
    for n in range(st, end):
        row = int(words[n])
        for e, s, ch in chans:
            xi, xq = M.decode_sample((row >> (4 * ch.rf)) & 0xF)
            ch.step(n, xi, xq)
    out = set()
    for e, s, ch in chans:
        for d in ch.dumps:
            out.add((16 * e + s, *d))
    return out


def check():
    r, other, st, end, n_notch = set(), [], None, None, None
    for ln in open(os.path.join(OUTD, "sys_rtl.txt")):
        if ln.startswith("D "):
            r.add(tuple(int(v) for v in ln.split()[1:]))
        elif ln.startswith("START"):
            st = int(ln.split()[1])
        elif ln.startswith("END"):
            end = int(ln.split()[1])
        elif ln.startswith("NOTCH"):
            n_notch = int(ln.split()[1])
        else:
            other.append(ln.strip())
    cut = end - 1500                     # сбросы у конца прогона могли не успеть прочитать
    m = {x for x in model(st, end, n_notch) if x[1] < cut}
    r = {x for x in r if x[1] < cut}
    print(f"Режекторный фильтр (ВЧ-канал 1) с отсчёта {n_notch}; пуск каналов с отсчёта {st}, "
          f"конец прогона {end}")
    ok = m == r and len(m) > 0
    print(f"Корреляторы через FMC: сбросов модель {len(m)}, прочитано МК {len(r)}; совпадение: "
          f"{'ДА' if ok else 'НЕТ'}")
    if not ok:
        print("  только в модели:", sorted(m - r)[:5])
        print("  только в RTL:", sorted(r - m)[:5])
    # снимок: сравнение с отсчётами
    words = [int(x, 16) for x in open(os.path.join(STIM, "sys_smp.hex")).read().split()[1:]]
    for ln in other:
        print(" ", ln)
        if ln.startswith("SNAP"):
            _, ch, t0, *vals = ln.split()
            ch, t0 = int(ch), int(t0)
            exp = []
            for w in range(len(vals)):
                v = 0
                for k in range(8):
                    v |= ((words[t0 + 8 * w + k] >> (4 * ch)) & 0xF) << (4 * k)
                exp.append(v)
            got = [int(x, 16) for x in vals]
            sok = exp == got
            print(f"  снимок канала {ch} с отсчёта {t0}: {len(got)} слов, совпадение: {'ДА' if sok else 'НЕТ'}")
            ok &= sok
        if ln.startswith(("PPS", "EXT", "SPI", "FX3")) and "FAIL" in ln:
            ok = False
    print("ИТОГ:", "ПРОЙДЕН" if ok else "НЕ ПРОЙДЕН")
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    {"gen": gen, "check": check}[sys.argv[1]]()
