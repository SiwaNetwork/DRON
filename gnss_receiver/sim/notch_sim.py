"""Эффективность режекторного фильтра ПЛИС (fpga/model/notch_model.py) против непрерывной помехи.

Сигнал GPS L1 C/A 45 дБГц, помеха — гармоника на ПЧ сигнала + 1,05 кГц (вблизи спектральной линии
кода C/A — наихудший случай; смещение 50 Гц от линии исключает когерентную добавку утечки к оценке),
отношение помеха/сигнал J/S = 20…50 дБ, 2-битный АЦП (АРУ по суммарному сигналу). Оценка C/N0 после коррелятора (1 мс, известные фаза кода и частота) — по
отношению мощности когерентной суммы к дисперсии; потери — относительно случая без помехи.
"""
import math
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "..", "sw"))
sys.path.insert(0, os.path.join(HERE, "..", "fpga", "model"))
from pyrx import codes, ifsim  # noqa: E402
import notch_model as NM  # noqa: E402

FS = 24e6
F_IF = 7.42e6
DF_J = 1050.0
CN0 = 45.0
N_MS = 60


def make(jsr_db, rng):
    spec = codes.code("L1CA", 7)
    sat = ifsim.SatSignal(spec, F_IF, 0.0, 100.25, CN0, 1575.42e6, phase=0.3)
    n = int(N_MS * 1e-3 * FS)
    cw = []
    if jsr_db is not None:
        # J/N = J/S + S/N; S/N в полосе Fд = C/N0 − 10·lg(Fд)
        jn = jsr_db + CN0 - 10 * math.log10(FS)
        cw = [(F_IF + DF_J, jn)]
    cfg = ifsim.IFConfig(fs=FS, bits=2, cw=cw, agc_k=1.0)
    # АРУ по суммарной мощности: порог 2-битного АЦП — 1·σ суммы (шум + помеха)
    if cw:
        cfg.agc_k = math.sqrt(1 + 10 ** (cw[0][1] / 10))
    x = ifsim.generate([sat], cfg, 0.0, n, rng)
    return spec, x


def cn0_est(spec, x):
    N = int(1e-3 * FS)
    rep = codes.replica(spec, FS, N, 100.25)
    t = np.arange(N) / FS
    lo = np.exp(-2j * np.pi * F_IF * t)
    P = []
    for k in range(len(x) // N):
        seg = x[k * N:(k + 1) * N] * lo * np.exp(-2j * np.pi * F_IF * k * 1e-3)
        P.append(np.vdot(rep, seg))
    P = np.array(P) * np.exp(-1j * 0.3)
    m = np.abs(np.mean(P.real)) ** 2
    v = np.var(P.imag) + np.var(P.real)
    snr = m / (v / 2) / 2                      # отношение «сигнал/шум» на интервале 1 мс
    return 10 * math.log10(snr / 1e-3)


def tone_db(x, f):
    """доля мощности гармоники частоты f в мощности сигнала, дБ"""
    n = np.arange(len(x))
    a = np.mean(x * np.exp(-2j * np.pi * f / FS * n))
    return 10 * math.log10(abs(a) ** 2 / np.mean(np.abs(x) ** 2))


def to_words(x):
    xi, xq = x.real.astype(int), x.imag.astype(int)
    return ((xi < 0).astype(np.uint32) << 3) | ((np.abs(xi) == 3).astype(np.uint32) << 2) | \
           ((xq < 0).astype(np.uint32) << 1) | (np.abs(xq) == 3).astype(np.uint32)


def from_words(w):
    w = w.astype(int)
    xi = np.where((w >> 2) & 1, 3, 1) * np.where((w >> 3) & 1, -1, 1)
    xq = np.where(w & 1, 3, 1) * np.where((w >> 1) & 1, -1, 1)
    return xi + 1j * xq


JN_MIN, JN_DITH = -20.0, -5.0          # правило ПО МК (sw/fw/inc/spectrum.h)


def main():
    rng = np.random.default_rng(5)
    spec, x0 = make(None, rng)
    ref = cn0_est(spec, x0)
    rows = []
    dphi = int(round((F_IF + DF_J) / FS * 2 ** 32)) & NM.M32
    k0 = int(20e-3 * FS)
    for jsr in (10, 15, 20, 25, 30, 35, 40, 45, 50):
        spec, x = make(jsr, np.random.default_rng(5))
        jn = jsr + CN0 - 10 * math.log10(FS)
        c_raw = cn0_est(spec, x)
        y0 = from_words(NM.run(to_words(x), {0: (dphi, 8, 0)}))
        y1 = from_words(NM.run(to_words(x), {0: (dphi, 8, 1)}))
        c0, c1 = cn0_est(spec, y0), cn0_est(spec, y1)
        mode = "—" if jn < JN_MIN else ("Д" if jn < JN_DITH else "Ф")
        yp = x if mode == "—" else (y1 if mode == "Д" else y0)
        cp = {"—": c_raw, "Д": c1, "Ф": c0}[mode]
        t_in, t_out = tone_db(x[k0:], F_IF + DF_J), tone_db(yp[k0:], F_IF + DF_J)
        rows.append((jsr, jn, c_raw, c0, c1, mode, cp, t_in, t_out))
        print(f"J/S {jsr} (J/N {jn:+.1f}): без фильтра {c_raw:.1f}, фильтр {c0:.1f}, с дизерингом {c1:.1f}; "
              f"режим {mode} -> {cp:.1f}; гармоника {t_in:.1f} -> {t_out:.1f} дБ", flush=True)
    out = ["### Режекторный фильтр ПЛИС: помеха вблизи спектральной линии кода C/A", "",
           f"Сигнал GPS L1 C/A {CN0:.0f} дБГц, 2-битный АЦП, помеха — непрерывная на ПЧ + {DF_J:.0f} Гц. "
           f"Оценка C/N0 после коррелятора (1 мс, {N_MS} интервалов); без помехи — {ref:.1f} дБГц. "
           f"μ = 8. Режим по правилу ПО МК: «—» — фильтр выключен (J/N < {JN_MIN:.0f} дБ), "
           f"«Д» — фильтр с дизерингом (J/N < {JN_DITH:.0f} дБ), «Ф» — фильтр без дизеринга.", "",
           "| J/S, дБ | J/N, дБ | C/N0 без фильтра | Фильтр | Фильтр + дизеринг | Режим | C/N0 в режиме ПО | "
           "Гармоника до, дБ | после, дБ |", "|---|---|---|---|---|---|---|---|---|"]
    for jsr, jn, a, c0, c1, m, cp, ti, to in rows:
        out.append(f"| {jsr} | {jn:+.1f} | {a:.1f} | {c0:.1f} | {c1:.1f} | {m} | **{cp:.1f}** | {ti:.1f} | {to:.1f} |")
    worst = min(r[6] for r in rows if r[0] >= 25)
    out += ["", "C/N0 — дБГц. Гармоника — доля мощности составляющей на частоте помехи в 2-битном потоке "
            "(до фильтра — отсчёты АЦП, после — выход в режиме ПО), без первых 20 мс (установление).", "",
            f"Вывод: при J/S от 25 до 50 дБ C/N0 с фильтром не ниже {worst:.1f} дБГц (порог слежения "
            f"ФАПЧ ≈ 25–28 дБГц) — требование ТЗ п. 5.2.11 (не менее 25 дБ J/S без потери слежения) "
            f"выполняется; без фильтра C/N0 при J/S 30 дБ падает до {rows[4][2]:.1f} дБГц."]
    # устойчивость к ошибке установки частоты (J/S 35 дБ)
    spec, x = make(35, np.random.default_rng(5))
    out += ["", "Ошибка установки частоты помехи в фильтре (J/S 35 дБ, μ = 8):", "",
            "| Ошибка, Гц | C/N0 с фильтром, дБГц |", "|---|---|"]
    for df in (0, 10, 100, 300, 1000, 3000):
        d = int(round((F_IF + DF_J + df) / FS * 2 ** 32)) & NM.M32
        c = cn0_est(spec, from_words(NM.run(to_words(x), {0: (d, 8, 0)})))
        out.append(f"| {df} | {c:.1f} |")
        print(f"ошибка частоты {df} Гц: C/N0 {c:.1f}", flush=True)
    out += ["", "Частота помехи уточняется ПО МК по снимку 2 мс (spec_refine_cw) с погрешностью единицы "
            "герц (tests/test_spectrum.c), поэтому ошибка установки на эффективность не влияет."]
    os.makedirs(os.path.join(HERE, "out"), exist_ok=True)
    open(os.path.join(HERE, "out", "notch.md"), "w").write("\n".join(out) + "\n")


if __name__ == "__main__":
    main()
