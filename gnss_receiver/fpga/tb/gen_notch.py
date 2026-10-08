"""Тест notch.v: стимул (8 каналов, помехи разной частоты и мощности, один канал выключен),
эталон — fpga/model/notch_model.py; сравнение выхода RTL (tb/out/notch_out.txt).
Запуск: python3 tb/gen_notch.py gen | check"""
import math
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "..", "model"))
import notch_model as NM  # noqa: E402

N = 6000
FS = 24e6
# канал: (частота помехи, Гц или None, J/N дБ, μ, включён, дизеринг)
CH = [(1.234e6, 10, 6, 1, 0), (2.0e6, 15, 8, 0, 1), (-3.3e6, -8, 8, 1, 1), (None, 0, 10, 1, 1),
      (5.5e6, 25, 4, 1, 0), (-7.9e6, 5, 0, 1, 1), (0.0, 12, 15, 1, 0), (11.99e6, 20, 3, 1, 1)]
COUNT0 = 1000


def stim():
    rng = np.random.default_rng(11)
    w = np.zeros(N, dtype=np.uint32)
    t = np.arange(N) / FS
    cfg = {}
    for k, (f, jn, mu, en, dith) in enumerate(CH):
        x = (rng.standard_normal(N) + 1j * rng.standard_normal(N)) / math.sqrt(2)
        if f is not None:
            x = x + math.sqrt(10 ** (jn / 10)) * np.exp(2j * np.pi * (f * t + rng.random()))
        sig = math.sqrt(np.mean(np.abs(x) ** 2) / 2)
        xi, xq = x.real / sig, x.imag / sig
        nib = ((xi < 0) << 3) | ((np.abs(xi) > 1) << 2) | ((xq < 0) << 1) | (np.abs(xq) > 1)
        w |= nib.astype(np.uint32) << (4 * k)
        if en:
            d = int(round((f or 0.0) / FS * 2 ** 32)) & NM.M32
            cfg[k] = (d, mu, dith)
    return w, cfg


def main():
    mode = sys.argv[1]
    w, cfg = stim()
    if mode == "gen":
        os.makedirs(os.path.join(HERE, "stim"), exist_ok=True)
        os.makedirs(os.path.join(HERE, "out"), exist_ok=True)
        en = sum(1 << k for k in cfg)
        dith = sum(1 << k for k, v in cfg.items() if v[2])
        mu = sum(v[1] << (4 * k) for k, v in cfg.items())
        lines = [f"{(N << 16) | (dith << 8) | en:08x}", f"{mu:08x}"] + \
                [f"{cfg[k][0] if k in cfg else 0:08x}" for k in range(8)]
        open(os.path.join(HERE, "stim", "notch_cfg.hex"), "w").write("\n".join(lines) + "\n")
        open(os.path.join(HERE, "stim", "notch_in.hex"), "w").write("\n".join(f"{int(v):08x}" for v in w) + "\n")
        return
    ref = NM.run(w, cfg)
    got = {}
    for ln in open(os.path.join(HERE, "out", "notch_out.txt")):
        c, v = ln.split()
        got[int(c)] = int(v, 16)
    bad = 0
    for n in range(N):
        g = got.get(COUNT0 + n)
        if g != int(ref[n]):
            if bad < 8:
                print(f"отсчёт {n}: RTL {g if g is None else f'{g:08x}'}, модель {int(ref[n]):08x}")
            bad += 1
    changed = int(np.sum(ref != w))
    print(f"Режекторный фильтр: отсчётов {N}, выходных RTL {len(got)}, изменено фильтром {changed}, "
          f"расхождений {bad}; совпадение: {'ДА' if bad == 0 and len(got) == N else 'НЕТ'}")
    sys.exit(0 if bad == 0 and len(got) == N else 1)


if __name__ == "__main__":
    main()
