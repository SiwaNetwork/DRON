"""Сценарий проверки движка коррелятора: сигналы GPS L1 C/A, Galileo E1C (BOC), ГЛОНАСС L1OF,
GPS L2CM (уплотнение) на модели ПЧ; расчёт эталонных сбросов битово-точной моделью и сверка с RTL.

  python3 tb/gen_stim.py gen      -> tb/stim/*.hex, tb/out/dumps_model.txt
  python3 tb/gen_stim.py check    -> сравнение tb/out/dumps_rtl.txt с моделью
"""
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "sw"))
sys.path.insert(0, os.path.join(ROOT, "fpga", "model"))
from pyrx import codes, ifsim  # noqa: E402
import corr_model as M  # noqa: E402

FS = 24e6
NSMP = int(os.environ.get("NSMP", 144000))     # 6 мс
STIM = os.path.join(HERE, "stim")
OUTD = os.path.join(HERE, "out")


def scenario():
    rng = np.random.default_rng(11)
    c_ca = codes.code("L1CA", 5)
    c_e1 = codes.code("E1C", 11, own=False)
    c_g1 = codes.code("G1CA", 1)
    c_l2 = codes.code("L2CM", 7)
    l2_short = codes.CodeSpec("L2CM", 7, c_l2.chips[:1023], c_l2.rate, False, True, 1023 / c_l2.rate)
    rf = {0: [], 1: [], 2: []}
    sats = [  # (ВЧ-канал, спецификация кода, смещение ПЧ, доплер, фаза кода, C/N0, несущая)
        (0, c_ca, 7.42e6, 1200.0, 300.25, 50.0, 1575.42e6),
        (0, c_e1, 7.42e6, -900.0, 1000.6, 50.0, 1575.42e6),
        (1, c_g1, 1.125e6, 2500.0, 100.1, 50.0, 1603.125e6),
        (2, l2_short, 0.0, -300.0, 500.4, 50.0, 1227.6e6),
    ]
    sig = []
    for r, spec, foff, dop, cp, cn0, fc in sats:
        rf[r].append(ifsim.SatSignal(spec, foff, dop, cp, cn0, fc, phase=rng.uniform(0, 6.28)))
        sig.append((r, spec, foff, dop, cp, fc))
    cfg = ifsim.IFConfig(fs=FS, bits=2)
    # отсчёты по ВЧ-каналам (неиспользуемые — шум)
    words = np.zeros(NSMP, dtype=np.uint32)
    for r in range(8):
        x = ifsim.generate(rf.get(r, []), cfg, 0.0, NSMP, rng)
        xi = x.real.astype(int)
        xq = x.imag.astype(int)
        nib = ((xi < 0).astype(np.uint32) << 3) | ((np.abs(xi) == 3).astype(np.uint32) << 2) | \
              ((xq < 0).astype(np.uint32) << 1) | (np.abs(xq) == 3).astype(np.uint32)
        words |= nib << (4 * r)
    return sig, words


# слоты движка: (номер сигнала сценария, boc, tdm, n_int, spacing, ошибка фазы кода, ошибка частоты)
SLOTS = [
    (0, False, False, 1, 0.5, 0.10, 20.0),     # GPS L1 C/A
    (1, True, False, 1, 0.15, 0.10, 20.0),     # Galileo E1C, BOC(1,1)
    (2, False, False, 1, 0.5, 0.10, 20.0),     # ГЛОНАСС L1OF
    (3, False, True, 2, 0.5, 0.10, 20.0),      # GPS L2CM (укороченный), уплотнение, 2 эпохи
    (0, False, False, 5, 0.25, -0.30, -150.0),
    (1, True, False, 1, 0.5, 0.40, 0.0),
    (2, False, False, 3, 0.5, 0.0, 0.0),
    (3, False, True, 1, 0.1, -0.2, 50.0),
    (4, False, False, 1, 0.5, 0.0, 0.0),       # только шум (ВЧ-каналы 3..7)
    (5, False, False, 1, 0.5, 0.0, 0.0),
    (6, False, False, 2, 0.5, 0.0, 0.0),
    (7, True, False, 1, 0.5, 0.0, 0.0),
    (0, False, False, 1, 0.5, 0.45, 300.0),
    (0, False, False, 1, 0.5, -0.45, -300.0),
    (0, False, False, 1, 0.0, 1.5, 0.0),       # нулевой разнос, вне пика
    None,                                       # слот выключен
]


def noise_sigs():
    """Сигналы-«пустышки» на ВЧ-каналах только с шумом."""
    out = []
    for r, (sys_, prn, rate_, fc) in zip((3, 4, 5, 6), (("L1CA", 9, 1.023e6, 1575.42e6),
                                                       ("G1CA", 3, 0.511e6, 1602e6),
                                                       ("L5I", 4, 10.23e6, 1176.45e6),
                                                       ("E1C", 2, 1.023e6, 1575.42e6))):
        spec = codes.code(sys_, prn, own=False) if sys_ == "E1C" else codes.code(sys_, prn)
        out.append((r, spec, 1.0e6, 0.0, 123.4, fc))
    return out


def channels(sig):
    """Конфигурация 16 слотов и объекты модели (None — слот выключен)."""
    allsig = sig + noise_sigs()
    chans, cfgw = [], []
    for slot, sc in enumerate(SLOTS):
        base = slot << 4
        if sc is None:
            chans.append(None)
            cfgw += [(base + 0, 0)]
            continue
        isig, boc, tdm, nint, sp, dcp, dfr = sc
        r, spec, foff, dop, cp, fc = allsig[isig]
        L = len(spec.chips)
        bits = (spec.chips < 0).astype(int)
        cr = M.rate_carrier(foff + dop + dfr, FS)
        kr = M.rate_code(spec.rate * (1 + dop / fc), FS)
        pos = (cp + dcp) % L
        ci = int(np.floor(pos)) % L
        cf = int((pos % 1.0) * 2 ** 32) & M.M32
        spc = int(sp * 2 ** 32) & M.M32
        ch = M.Channel(bits, L, cr, kr, ci, cf, 0, spc, boc, tdm, nint, r)
        ctrl = (nint << 8) | (r << 3) | (int(tdm) << 2) | (int(boc) << 1)
        ch.ctrl = ctrl
        chans.append(ch)
        cfgw += [(base + 0, ctrl), (base + 1, L), (base + 2, cr), (base + 3, kr), (base + 4, 0),
                 (base + 5, ci), (base + 6, cf), (base + 7, spc)]
        cfgw.append((0x100, slot << 16))
        for w in M.code_words(bits, L):
            cfgw.append((0x101, w))
    for slot, ch in enumerate(chans):
        if ch is not None:
            cfgw.append(((slot << 4) + 0, ch.ctrl | 1))
    return chans, cfgw


def gen():
    os.makedirs(STIM, exist_ok=True)
    os.makedirs(OUTD, exist_ok=True)
    sig, words = scenario()
    chans, cfgw = channels(sig)
    # смена шагов NCO во время работы: слот 0 (на отсчёте 50000) и слот 6 (на отсчёте 80001)
    ev = [(50000, 0x02, M.rate_carrier(7.42e6 + 1200.0, FS)),
          (50000, 0x03, M.rate_code(1.023e6 * (1 + 1200.0 / 1575.42e6), FS) + 7),
          (80001, 0x62, M.rate_carrier(1.125e6 + 2500.0 + 3.0, FS)),
          (80001, 0x63, chans[6].code_rate - 1000)]
    with open(os.path.join(STIM, "cfg.hex"), "w") as f:
        f.write(f"{2 * len(cfgw):08x}\n")
        for a, d in cfgw:
            f.write(f"{a:08x}\n{d & M.M32:08x}\n")
    with open(os.path.join(STIM, "samples.hex"), "w") as f:
        f.write(f"{NSMP:08x}\n")
        f.write("\n".join(f"{w:08x}" for w in words) + "\n")
    with open(os.path.join(STIM, "events.hex"), "w") as f:
        f.write(f"{len(ev):08x}\n")
        for n, a, d in ev:
            f.write(f"{n:08x}\n{a:08x}\n{d & M.M32:08x}\n")
        f.write("00000000\n" * (255 - 3 * len(ev)))
    # эталон
    pend = {}
    for n, a, d in ev:
        pend.setdefault(n, []).append((a, d))
    act = [(s, ch) for s, ch in enumerate(chans) if ch is not None]
    for n in range(NSMP):
        for a, d in pend.get(n, []):
            ch = chans[a >> 4]
            cr, kr = ch.pending or (ch.carr_rate, ch.code_rate)
            ch.pending = (d & M.M32, kr) if (a & 15) == 2 else (cr, d & M.M32)
        row = int(words[n])
        for s, ch in act:
            xi, xq = M.decode_sample((row >> (4 * ch.rf)) & 0xF)
            ch.step(n, xi, xq)
    with open(os.path.join(OUTD, "dumps_model.txt"), "w") as f:
        for s, ch in act:
            for d in ch.dumps:
                f.write(" ".join(str(v) for v in (s, *d)) + "\n")
    print("Сценарий:", NSMP, "отсчётов, слотов:", len(act), "; сбросов в модели:",
          sum(len(c.dumps) for _, c in act), "; слов настройки:", len(cfgw))
    for s, ch in act:
        if ch.dumps:
            d = ch.dumps[-1]
            print(f"  слот {s:2d}: сбросов {len(ch.dumps):2d}, последний n={d[0]}, |P| = {np.hypot(d[3], d[4]):.0f}, "
                  f"|E| = {np.hypot(d[1], d[2]):.0f}, |L| = {np.hypot(d[5], d[6]):.0f}")


def check():
    def load(p):
        rows = set()
        for ln in open(p):
            if ln.startswith("BUS"):
                continue
            rows.add(tuple(int(v) for v in ln.split()))
        return rows
    m = load(os.path.join(OUTD, "dumps_model.txt"))
    r = load(os.path.join(OUTD, "dumps_rtl.txt"))
    bus = [ln for ln in open(os.path.join(OUTD, "dumps_rtl.txt")) if ln.startswith("BUS")]
    ok = m == r and len(m) > 0
    print(f"Сбросов: модель {len(m)}, RTL {len(r)}; совпадение: {'ДА' if ok else 'НЕТ'}")
    if not ok:
        print("  только в модели:", sorted(m - r)[:5])
        print("  только в RTL:", sorted(r - m)[:5])
        sys.exit(1)
    last0 = max((x for x in m if x[0] == 0), key=lambda x: x[1])
    print(f"Проверка чтения по шине: {bus[0].strip()} (ожидается PI слота 0 = {last0[4]})")
    if int(bus[0].split()[-1]) != last0[4]:
        sys.exit(1)


if __name__ == "__main__":
    {"gen": gen, "check": check}[sys.argv[1]]()
