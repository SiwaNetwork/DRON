"""Сигнальное моделирование МГП-8: захват и слежение для сигналов всех систем на модели ПЧ
(MAX2771, I/Q 2 бита, 24 МГц), потери квантования, чувствительность захвата.

Запуск: python3 sim/sim_signals.py -> sim/out/signals.md, sig_*.png
"""
import json
import math
import os
import sys
import time

import numpy as np

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(ROOT, "sw"))
sys.path.insert(0, os.path.dirname(__file__))
from pyrx import codes, ifsim, acq, track  # noqa: E402
from pyrx.third_party.pocketsdr import sdr_code as ref  # noqa: E402
import gnss_signals as GS  # noqa: E402

OUT = os.path.join(ROOT, "sim", "out")
FS = 24e6

CASES = [
    # (сигнал, PRN, ВЧ-канал, литера ГЛОНАСС, пилот, бит/с, вторичный код из Pocket SDR)
    ("L1CA", 5, 1, 0, False, 50, False),
    ("E1C", 11, 1, 0, True, 0, True),
    ("B1I", 21, 1, 0, False, 50, True),
    ("G1CA", 3, 2, -4, False, 50, False),
    ("L5Q", 9, 5, 0, True, 0, True),
    ("E5AQ", 4, 5, 0, True, 0, True),
    ("B3I", 25, 7, 0, False, 50, True),
    ("L2CM", 7, 3, 0, False, 25, False),
]
FCAR = {"L1CA": 1575.42e6, "E1C": 1575.42e6, "B1I": 1561.098e6, "G1CA": 1602e6, "L5Q": 1176.45e6,
        "E5AQ": 1176.45e6, "B3I": 1268.52e6, "L2CM": 1227.6e6}


def f_offset(sig, k):
    lo = GS.RF_CHANNELS[[c for c in CASES if c[0] == sig][0][2]]["f_lo"]
    f = FCAR[sig] + (k * 562.5e3 if sig == "G1CA" else 0)
    return f - lo


def run_case(sig, prn, ch, k, pilot, bitrate, use_sec, cn0=45.0, dur=1.0, rng=None):
    rng = rng or np.random.default_rng(prn)
    own = sig in ("L1CA", "G1CA", "B1I", "B3I", "L5Q", "L2CM")
    spec = codes.code(sig, prn, own=own)
    sec = None
    if use_sec:
        sc = ref.sec_code(sig, prn)
        if len(sc):
            sec = sc.astype(np.int8)
    f_off = f_offset(sig, k)
    dop = rng.uniform(-3000, 3000)
    cp0 = rng.uniform(0, len(spec.chips))
    bits = rng.choice([-1, 1], 200).astype(np.int8)
    s = ifsim.SatSignal(spec, f_off, dop, cp0, cn0, FCAR[sig], phase=rng.uniform(0, 6.28), bit_rate=bitrate,
                        bits=bits, sec=sec, meander=(sig == "G1CA"))
    cfg = ifsim.IFConfig(fs=FS, bits=2)
    # захват: 4 мс (или 4 периода кода) некогерентно
    Tc = spec.period
    nblk = int(round(Tc * FS))
    n_nc = max(1, int(round(4e-3 / Tc)))
    x = ifsim.generate([s], cfg, 0.0, nblk * n_nc, rng)
    t0 = time.time()
    a = acq.search(x, spec, FS, f_off, dop_range=4000, n_coh=1, n_nc=n_nc, dop_step=1 / (4 * Tc))
    # уточнение частоты по 20 мс (квадратичное снятие модуляции данными/вторичным кодом)
    xr = ifsim.generate([s], cfg, 0.0, int(20e-3 * FS) + 10, np.random.default_rng(prn + 100))
    dfine = acq.refine_doppler(xr, spec, FS, f_off + a["doppler"], a["code_phase"])
    a["doppler"] += dfine
    t_acq = time.time() - t0
    true_cp = cp0 % len(spec.chips)
    cp_err = ((a["code_phase"] - true_cp + len(spec.chips) / 2) % len(spec.chips)) - len(spec.chips) / 2
    # слежение
    cfgl = track.LoopCfg(pll_bw=15.0, fll_bw=10.0, dll_bw=1.0, spacing=0.5 if not spec.boc else 0.15,
                         T=1e-3, pilot=pilot and sec is None)
    # при вторичном коде на пилоте используем Костас (без синхронизации вторичного кода)
    trk = track.Tracker(spec, FS, f_off, a["doppler"], a["code_phase"], cfgl, FCAR[sig])
    n_int = int(round(cfgl.T * FS))
    steps = int(dur / cfgl.T)
    t = 0.0
    ce, fe = [], []
    for i in range(steps):
        n_need = trk.samples_needed()
        blk = ifsim.generate([s], cfg, t, n_need, rng)
        trk.step(blk, t)
        t += n_need / FS
        true_ph = cp0 + t * spec.rate * (1 + dop / FCAR[sig])
        e = ((trk.st.code_phase - true_ph + len(spec.chips) / 2) % len(spec.chips)) - len(spec.chips) / 2
        ce.append(e)
        fe.append(trk.st.f_carr - (f_off + dop))
    ce, fe = np.array(ce), np.array(fe)
    half = len(ce) // 2
    cn = np.array(trk.st.log["cn0"], dtype=float)
    cn = cn[~np.isnan(cn)]
    lock = np.mean(np.abs(np.array(trk.st.log["Q"][half:])) < np.abs(np.array(trk.st.log["I"][half:])))
    chip_m = GS.F0 * 0 + 299792458.0 / spec.rate
    return dict(sig=sig, prn=prn, ch=ch, cn0_true=cn0, acq_metric=a["metric"], acq_cp_err=cp_err,
                acq_dop_err=a["doppler"] - dop, t_acq=t_acq,
                code_rms_m=float(np.std(ce[half:]) * chip_m), code_bias_m=float(np.mean(ce[half:]) * chip_m),
                f_rms=float(np.std(fe[half:])), cn0_est=float(np.mean(cn[len(cn) // 2:])) if len(cn) else float("nan"),
                lock=float(lock), log=trk.st.log, ce=ce, fe=fe)


def dll_theory(cn0, rate, d, B, T):
    c = 10 ** (cn0 / 10)
    lam = 299792458.0 / rate
    return lam * math.sqrt(B * d / (2 * c) * (1 + 2 / ((2 - d) * T * c)))


def quant_loss(rng=None):
    """Потери квантования при слабом сигнале (аналитически): η = (Σ Δy_k·φ(t_k))² / E[y²]."""
    from math import erf, exp, pi, sqrt
    phi = lambda x: exp(-x * x / 2) / sqrt(2 * pi)
    Phi = lambda x: 0.5 * (1 + erf(x / sqrt(2)))

    def loss(thr, levels):
        # thr — положительные пороги, levels — уровни по модулю (len(levels) = len(thr) + 1)
        d = 2 * levels[0] * phi(0)                     # скачок в нуле
        for t, a, b in zip(thr, levels[:-1], levels[1:]):
            d += 2 * (b - a) * phi(t)                  # скачки в ±t
        bounds = [0] + list(thr) + [float("inf")]
        e2 = sum(2 * (Phi(b) - Phi(a)) * lv * lv for a, b, lv in zip(bounds[:-1], bounds[1:], levels))
        return -10 * math.log10(d * d / e2)
    res = {"1 бит": loss([], [1]), "2 бита, порог 0,5σ": loss([0.5], [1, 3]), "2 бита, порог 1,0σ": loss([1.0], [1, 3]),
           "2 бита, порог 1,5σ": loss([1.5], [1, 3]), "3 бита, шаг 0,5σ": loss([0.5, 1.0, 1.5], [1, 3, 5, 7])}
    return res


def main():
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    plt.rcParams["font.family"] = "DejaVu Sans"
    os.makedirs(OUT, exist_ok=True)
    rng = np.random.default_rng(2026)
    rows = []
    for case in CASES:
        r = run_case(*case, cn0=45.0, dur=1.0, rng=rng)
        spec = codes.code(case[0], case[1], own=False)
        r["dll_theory_m"] = dll_theory(45.0, spec.rate, 1.0 if not spec.boc else 0.3, 1.0, 1e-3)
        rows.append(r)
        print(f"{r['sig']:5s} захват: метрика {r['acq_metric']:.1f}, ошибка кода {r['acq_cp_err']:+.2f} чип, "
              f"доплер {r['acq_dop_err']:+.0f} Гц; слежение: СКО кода {r['code_rms_m']:.2f} м (теор. {r['dll_theory_m']:.2f}), "
              f"СКО част. {r['f_rms']:.2f} Гц, C/N0 оценка {r['cn0_est']:.1f}, захват фазы {r['lock']:.2f}")
    fig, axs = plt.subplots(2, 4, figsize=(15, 6))
    for ax, r in zip(axs.flat, rows):
        lg = r["log"]
        ax.plot(lg["t"], lg["I"], lw=0.6, label="I (синфазная)")
        ax.plot(lg["t"], lg["Q"], lw=0.6, label="Q (квадратурная)")
        ax.set_title(f"{r['sig']} PRN{r['prn']}: C/N0 оц. {r['cn0_est']:.1f} дБГц", fontsize=9)
        ax.set_xlabel("с", fontsize=8)
        ax.tick_params(labelsize=7)
    axs[0, 0].legend(fontsize=7)
    fig.suptitle("Слежение на модели ПЧ (2 бита I/Q, 24 МГц), C/N0 = 45 дБГц: выход коррелятора P", fontsize=10)
    fig.tight_layout()
    fig.savefig(os.path.join(OUT, "sig_tracking.png"), dpi=130)
    plt.close(fig)
    # пример поверхности захвата
    spec = codes.code("E1C", 11, own=False)
    s = ifsim.SatSignal(spec, f_offset("E1C", 0), 1234.0, 1000.3, 42.0, 1575.42e6,
                        sec=ref.sec_code("E1C", 11).astype(np.int8))
    x = ifsim.generate([s], ifsim.IFConfig(), 0.0, int(4e-3 * FS) * 2, rng)
    a = acq.search(x, spec, FS, f_offset("E1C", 0), 3000, 1, 2, dop_step=125)
    fig, ax = plt.subplots(figsize=(8, 3.5))
    cp = np.arange(a["P"].shape[1]) * spec.rate / FS
    ax.plot(cp, a["P"][a["k"]] / np.median(a["P"]), lw=0.6)
    ax.set_xlabel("Задержка кода, чипы")
    ax.set_ylabel("P / медиана")
    ax.set_title(f"Захват Galileo E1C (BOC(1,1)), C/N0 = 42 дБГц, 8 мс: доплер {a['doppler']:.0f} Гц (истина 1234)")
    ax.grid(alpha=.3)
    fig.tight_layout()
    fig.savefig(os.path.join(OUT, "sig_acq_e1c.png"), dpi=130)
    plt.close(fig)
    ql = quant_loss(rng)
    md = ["### Захват и слежение на модели сигнала (C/N0 = 45 дБГц, 2 бита I/Q, Fд = 24 МГц)", "",
          "| Сигнал | ВЧ-канал | Метрика захвата (пик/2-й пик) | Ошибка задержки при захвате, чип | Ошибка доплера, Гц | СКО кода, м | Теор. СКО кода, м | СКО частоты, Гц | Оценка C/N0, дБГц |",
          "|---|---|---|---|---|---|---|---|---|"]
    for r in rows:
        md.append(f"| {r['sig']} | {r['ch']} | {r['acq_metric']:.1f} | {r['acq_cp_err']:+.2f} | {r['acq_dop_err']:+.0f} | "
                  f"{r['code_rms_m']:.2f} | {r['dll_theory_m']:.2f} | {r['f_rms']:.2f} | {r['cn0_est']:.1f} |")
    md += ["", "Слежение: ФАП 2-го порядка 15 Гц с поддержкой ЧАП 10 Гц, ССЗ 1 Гц с поддержкой от несущей, "
           "T = 1 мс (для кодов с периодом >1 мс — период кода). Теоретическая СКО — формула для когерентного "
           "дискриминатора «ранний−поздний» без учёта ограничения полосы.", "",
           "### Потери квантования (слабый сигнал, гауссов шум; ВЧ-тракт без ограничения полосы)", "",
          "| Квантование | Потери, дБ |", "|---|---|"]
    md += [f"| {k} | {v:.2f} |" for k, v in ql.items()]
    with open(os.path.join(OUT, "signals.md"), "w") as f:
        f.write("\n".join(md) + "\n")
    json.dump([{k: v for k, v in r.items() if k not in ("log", "ce", "fe")} for r in rows] + [ql],
              open(os.path.join(OUT, "signals.json"), "w"), ensure_ascii=False, indent=1, default=float)
    print("\n".join(md))


if __name__ == "__main__":
    main()
