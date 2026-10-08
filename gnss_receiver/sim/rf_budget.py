"""Энергетический расчёт приёмного тракта МГП-8: каскадный коэффициент шума (формула Фрииса),
потери от фильтрации ПЧ и квантования, отношение C/N0 для минимальных уровней сигналов,
пересчёт требований к чувствительности.

Запуск: python3 sim/rf_budget.py  ->  sim/out/rf_budget.json, rf_budget.md, rf_cascade.png
"""
import json, math, os, sys
import numpy as np

sys.path.insert(0, os.path.dirname(__file__))
from gnss_signals import SIGNALS, RF_CHANNELS, carrier, if_offset  # noqa: E402

OUT = os.path.join(os.path.dirname(__file__), "out")
os.makedirs(OUT, exist_ok=True)

T0 = 290.0
K_DBW = -228.6  # 10*log10(k), дБВт/(К*Гц)


def db(x):
    return 10 * math.log10(x)


def lin(x_db):
    return 10 ** (x_db / 10)


def cascade(stages):
    """stages: [(имя, G_дБ, NF_дБ)] -> (NF_сист, G_сумм, таблица по ступеням)."""
    f_tot, g_acc, rows = 0.0, 1.0, []
    for i, (name, g, nf) in enumerate(stages):
        f = lin(nf)
        f_tot = f if i == 0 else f_tot + (f - 1) / g_acc
        g_acc *= lin(g)
        rows.append(dict(stage=name, gain_db=g, nf_db=nf, cum_nf_db=db(f_tot), cum_gain_db=db(g_acc)))
    return db(f_tot), db(g_acc), rows


def chain(band, cable_db=3.0, ant_g=28.0, ant_nf=2.0):
    nf_max = 1.4 if band == "L1" else 1.6  # MAX2771: 1.4 дБ (верхний), 1.6 дБ (нижний диапазон)
    return [
        ("МШУ активной антенны", ant_g, ant_nf),
        ("Кабель снижения", -cable_db, cable_db),
        ("Соединитель, тройник питания, защита", -0.3, 0.3),
        ("Делитель 1:2 (1-я ступень)", -3.5, 3.5),
        ("Делитель 1:2 (2-я ступень)", -3.5, 3.5),
        ("Делитель 1:2 (3-я ступень)", -3.5, 3.5),
        ("Цепь согласования входа МШУ", -0.3, 0.3),
        ("MAX2771 (МШУ+смеситель+ПЧ)", 100.0, nf_max),
    ]


def _bpsk(f, fc):
    return np.sinc(f / fc) ** 2 / fc


def _boc(f, fs, fc):
    """СПМ синусной BOC(fs, fc) при чётном 2fs/fc (нормирована к единичной мощности)."""
    with np.errstate(divide="ignore", invalid="ignore"):
        v = fc * (np.sin(np.pi * f / fc) * np.tan(np.pi * f / (2 * fs)) / (np.pi * f)) ** 2
    v[~np.isfinite(v)] = 0.0
    return v


def spectrum(sig, f):
    """СПМ сигнала (нормированная), f — смещение от несущей, Гц."""
    fc = sig.chip_rate
    if not sig.boc_m:
        return _bpsk(f, fc)
    a = 1 / 11 if "CBOC" in sig.mod else (4 / 33 if "MBOC" in sig.mod else 0.0)
    return (1 - a) * _boc(f, 1.023e6, fc) + a * _boc(f, 6 * 1.023e6, fc)


def filter_loss_db(sig, k=0, bw=None, order=5):
    """Потеря мощности сигнала при прохождении фильтра ПЧ (Баттерворт, комплексный, центр на f_LO)."""
    ch = RF_CHANNELS[sig.rf_ch]
    bw = bw or ch["bw"]
    off = if_offset(sig, k)
    f = np.linspace(-40e6, 40e6, 400001)
    s = spectrum(sig, f)
    h2 = 1 / (1 + ((f + off) / (bw / 2)) ** (2 * order))  # АЧХ^2 полосового комплексного фильтра
    frac = np.trapezoid(s * h2, f) / np.trapezoid(s, f)
    return -db(frac)


QUANT_LOSS_DB = {1: 1.96, 2: 0.55, 3: 0.16}  # для комплексной дискретизации при оптимальной АРУ


def run(cable_db=3.0, t_ant=100.0, bits=2, impl_db=0.5):
    res = {}
    for band in ("L1", "L25"):
        nf, g, rows = cascade(chain(band, cable_db))
        res[band] = dict(nf_sys_db=nf, gain_db=g, rows=rows)
    sig_rows = []
    for s in SIGNALS:
        band = "L1" if RF_CHANNELS[s.rf_ch]["f_lo"] > 1.5e9 else "L25"
        nf = res[band]["nf_sys_db"]
        t_rx = T0 * (lin(nf) - 1)
        t_sys = t_ant + t_rx
        n0 = K_DBW + db(t_sys)
        ks = s.fdma_k if s.fdma_k else (0,)
        fl = max(filter_loss_db(s, k) for k in ks)
        ql = QUANT_LOSS_DB[bits]
        cn0 = s.p_min_dbw - n0 - fl - ql - impl_db
        sig_rows.append(dict(sid=s.sid, sys=s.system, name=s.name, rf_ch=s.rf_ch,
                             f_mhz=carrier(s) / 1e6, if_mhz=if_offset(s) / 1e6,
                             p_min_dbw=s.p_min_dbw, t_sys_k=t_sys, n0_dbw_hz=n0,
                             filt_loss_db=fl, quant_loss_db=ql, cn0_min=cn0,
                             cn0_low_elev=cn0 - 5.0))
    res["signals"] = sig_rows
    res["params"] = dict(cable_db=cable_db, t_ant=t_ant, bits=bits, impl_db=impl_db)
    # Чувствительность: мощность на входе антенного соединителя -> C/N0 (как у производителей модулей)
    nf = res["L1"]["nf_sys_db"]
    res["sens"] = {str(p): p + 174 - nf - QUANT_LOSS_DB[bits] - impl_db for p in (-130, -142, -147, -150, -153, -155)}
    return res


def sensitivity_table(res):
    lines = ["| Мощность на входе, дБм | C/N0, дБГц |", "|---|---|"]
    for p, c in res["sens"].items():
        lines.append(f"| {p} | {c:.1f} |")
    return "\n".join(lines)


def main():
    res = run()
    with open(os.path.join(OUT, "rf_budget.json"), "w") as f:
        json.dump(res, f, ensure_ascii=False, indent=1)
    md = ["### Каскад приёмного тракта (верхний диапазон L1)", "",
          "| Ступень | Kp, дБ | Kш, дБ | Kш накопл., дБ | Kp накопл., дБ |", "|---|---|---|---|---|"]
    for r in res["L1"]["rows"]:
        md.append(f"| {r['stage']} | {r['gain_db']:+.1f} | {r['nf_db']:.1f} | {r['cum_nf_db']:.2f} | {r['cum_gain_db']:.1f} |")
    md += ["", f"Коэффициент шума системы: L1 — {res['L1']['nf_sys_db']:.2f} дБ, "
                f"L2/L5/L6 — {res['L25']['nf_sys_db']:.2f} дБ.", "",
           "### Отношение C/N0 при минимальной мощности сигналов (антенна 0 дБи, Tа = 100 К)", "",
           "| Сигнал | ВЧ-канал | Несущая, МГц | ПЧ, МГц | Pmin, дБВт | Потери фильтра, дБ | C/N0 мин, дБГц | C/N0 (−5 дБи), дБГц |",
           "|---|---|---|---|---|---|---|---|"]
    for r in res["signals"]:
        md.append(f"| {r['sys']} {r['name']} | {r['rf_ch']} | {r['f_mhz']:.3f} | {r['if_mhz']:+.3f} | {r['p_min_dbw']:.1f} | "
                  f"{r['filt_loss_db']:.2f} | {r['cn0_min']:.1f} | {r['cn0_low_elev']:.1f} |")
    md += ["", "### Пересчёт мощности на входе в C/N0", "", sensitivity_table(res)]
    with open(os.path.join(OUT, "rf_budget.md"), "w") as f:
        f.write("\n".join(md) + "\n")
    # график накопления Kш и чувствительности к потерям в кабеле
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    plt.rcParams["font.family"] = "DejaVu Sans"
    fig, ax = plt.subplots(1, 2, figsize=(11, 4))
    cab = np.linspace(0, 15, 61)
    for g in (20, 26, 28, 35):
        ax[0].plot(cab, [cascade(chain("L25", c, ant_g=g))[0] for c in cab], label=f"Ку антенны {g} дБ")
    ax[0].set_xlabel("Потери в кабеле, дБ"); ax[0].set_ylabel("Kш системы, дБ"); ax[0].grid(alpha=.3)
    ax[0].legend(); ax[0].set_title("Влияние кабеля и усиления антенны (L2/L5)")
    sigs = res["signals"]
    ax[1].barh([f"{r['sys']} {r['name']}" for r in sigs], [r["cn0_min"] for r in sigs], color="#4a7")
    ax[1].axvline(35, ls="--", c="k", lw=.8); ax[1].set_xlabel("C/N0 мин, дБГц")
    ax[1].set_title("C/N0 при минимальной мощности"); ax[1].tick_params(axis="y", labelsize=6)
    ax[1].set_xlim(30, 50)
    fig.tight_layout(); fig.savefig(os.path.join(OUT, "rf_cascade.png"), dpi=150)
    print("\n".join(md))


if __name__ == "__main__":
    main()
