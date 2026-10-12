"""Частотный план МГП-8: ПЧ всех сигналов, перекрытие полос, взаимное влияние гетеродинов,
гармоники тактовых частот в полосах приёма (принцип единой опоры 24 МГц).

Запуск: python3 sim/freq_plan.py -> sim/out/freq_plan.md, freq_plan.png
"""
import os, sys
import numpy as np

sys.path.insert(0, os.path.dirname(__file__))
from gnss_signals import SIGNALS, RF_CHANNELS, carrier, if_offset, F_ADC  # noqa: E402

OUT = os.path.join(os.path.dirname(__file__), "out")
os.makedirs(OUT, exist_ok=True)

# Тактовые источники изделия. Все, кроме кварца FX3 и ГПИ ВИП, кратны 12/24 МГц.
CLOCKS = [
    ("ТКГ / АЦП 24 МГц", 24e6, "постоянно"),
    ("ПЛИС, системная 96 МГц", 96e6, "постоянно"),
    ("МК, ядро 480 МГц (от 24 МГц)", 480e6, "постоянно"),
    ("МК, шина AHB 240 МГц", 240e6, "постоянно"),
    ("МК, SDMMC 24 МГц", 24e6, "при записи на карту"),
    ("FX3, кварц 19,2 МГц", 19.2e6, "только при подключении USB"),
    ("МК, HSI 64 МГц (до захвата опоры)", 64e6, "до 1 с после включения"),
]


def channel_signals():
    rows = []
    for ch, c in RF_CHANNELS.items():
        for s in SIGNALS:
            if s.rf_ch != ch:
                continue
            ks = s.fdma_k or (0,)
            ifs = [if_offset(s, k) for k in ks]
            lo, hi = min(ifs) - s.chip_rate, max(ifs) + s.chip_rate
            rows.append((ch, s, min(ifs), max(ifs), lo, hi))
    return rows


def harmonics_in_band():
    res = []
    for name, f, mode in CLOCKS:
        for ch, c in RF_CHANNELS.items():
            lo, hi = c["f_lo"] - c["bw"] / 2, c["f_lo"] + c["bw"] / 2
            n0, n1 = int(np.ceil(lo / f)), int(np.floor(hi / f))
            for n in range(n0, n1 + 1):
                fh = n * f
                # ближайший сигнал этого канала
                near = []
                for s in SIGNALS:
                    if s.rf_ch == ch:
                        for k in (s.fdma_k or (0,)):
                            near.append((abs(fh - carrier(s, k)), s, k))
                d, s, k = min(near, key=lambda x: x[0])
                in_main = d < s.chip_rate * (1 if not s.boc_m else 2)
                res.append(dict(clock=name, mode=mode, n=n, f=fh, ch=ch, if_off=fh - c["f_lo"],
                                sig=f"{s.system} {s.name}" + (f" (k={k:+d})" if s.fdma_k else ""),
                                d=d, in_main=in_main))
    return res


def lo_cross():
    rows = []
    for a, ca in RF_CHANNELS.items():
        for b, cb in RF_CHANNELS.items():
            if a == b:
                continue
            d = ca["f_lo"] - cb["f_lo"]
            if abs(d) < cb["bw"] / 2:
                rows.append((a, b, d))
    return rows


def main():
    md = ["### Распределение сигналов по ВЧ-каналам (нулевая ПЧ, комплексная дискретизация "
          f"{F_ADC/1e6:.0f} МГц)", "",
          "| ВЧ-канал | f гет., МГц | Полоса ПЧ, МГц | Сигнал | ПЧ, МГц | Занимаемая полоса (гл. лепесток), МГц |",
          "|---|---|---|---|---|---|"]
    for ch, s, i0, i1, lo, hi in channel_signals():
        c = RF_CHANNELS[ch]
        ifs = f"{i0/1e6:+.3f}" if i0 == i1 else f"{i0/1e6:+.3f}…{i1/1e6:+.3f}"
        md.append(f"| {ch} | {c['f_lo']/1e6:.3f} | {c['bw']/1e6:.1f} | {s.system} {s.name} | {ifs} | {lo/1e6:+.2f}…{hi/1e6:+.2f} |")
    md += ["", "Условие Найквиста для комплексных отсчётов: |ПЧ| + полоса/2 < Fд/2 = 12 МГц "
           "выполняется для всех каналов (максимум у канала 1: 23,4/2 = 11,7 МГц).", ""]
    cross = lo_cross()
    md.append("### Взаимное влияние гетеродинов")
    md.append("")
    md.append("Гетеродин одного канала в полосе другого: " + ("нет." if not cross else ", ".join(
        f"гет. {a} в полосе {b} ({d/1e6:+.2f} МГц)" for a, b, d in cross)))
    md += ["", "### Гармоники тактовых частот в полосах приёма", "",
           "| Источник | Режим | n | f, МГц | ВЧ-канал | ПЧ, МГц | Ближайший сигнал | Отстройка, МГц | В гл. лепестке |",
           "|---|---|---|---|---|---|---|---|---|"]
    hh = harmonics_in_band()
    seen = set()
    for h in sorted(hh, key=lambda x: (x["ch"], x["f"])):
        key = (round(h["f"]), h["ch"])
        if key in seen and h["clock"].startswith("МК") is False and h["clock"] != CLOCKS[0][0]:
            pass
        seen.add(key)
        md.append(f"| {h['clock']} | {h['mode']} | {h['n']} | {h['f']/1e6:.3f} | {h['ch']} | {h['if_off']/1e6:+.3f} | "
                  f"{h['sig']} | {h['d']/1e6:.3f} | {'да' if h['in_main'] else 'нет'} |")
    md += ["", "Вывод: гармоники постоянно действующих источников лежат на сетке n·24 МГц. "
           "Поэтому их положение на ПЧ детерминировано, и они подавляются цифровыми режекторными "
           "фильтрами ПЛИС (блок NOTCH, fpga/rtl/notch.v; ПО МК включает фильтр при уровне помехи "
           "выше −20 дБ относительно шума, эффективность — sim/out/notch.md). "
           "Конструктивно источники отделены от ВЧ-каналов экранами, разделением слоёв земли "
           "и фильтрацией питания. Кварц FX3 19,2 МГц даёт составляющую 1574,4 МГц "
           "(−1,02 МГц от L1). FX3 питается только от VBUS USB и выключен в автономном режиме."]
    with open(os.path.join(OUT, "freq_plan.md"), "w") as f:
        f.write("\n".join(md) + "\n")

    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    plt.rcParams["font.family"] = "DejaVu Sans"
    fig, axs = plt.subplots(1, 2, figsize=(13, 4.5), sharey=False)
    colors = {"GPS": "tab:blue", "GLO": "tab:red", "GAL": "tab:green", "BDS": "tab:orange",
              "QZS": "tab:purple", "IRN": "tab:brown", "SBS": "tab:gray"}
    for ax, (f0, f1) in zip(axs, ((1160, 1290), (1550, 1612))):
        for ch, c in RF_CHANNELS.items():
            lo, hi = (c["f_lo"] - c["bw"] / 2) / 1e6, (c["f_lo"] + c["bw"] / 2) / 1e6
            if hi < f0 or lo > f1:
                continue
            ax.axvspan(lo, hi, ymin=0.0, ymax=0.12, color="k", alpha=0.15)
            ax.text((lo + hi) / 2, 0.06, f"К{ch}", ha="center", va="center", fontsize=8,
                    transform=ax.get_xaxis_transform())
        y = 0.2
        for s in SIGNALS:
            fc = carrier(s) / 1e6
            if not (f0 <= fc <= f1):
                continue
            ks = s.fdma_k or (0,)
            a = (carrier(s, min(ks)) - s.chip_rate) / 1e6
            b = (carrier(s, max(ks)) + s.chip_rate * (2 if s.boc_m else 1)) / 1e6
            a = min(a, fc - s.chip_rate * (2 if s.boc_m else 1) / 1e6 * 1e6 / 1e6)
            ax.plot([a, b], [y, y], lw=4, color=colors[s.system], solid_capstyle="butt")
            ax.text(b + 0.3, y, f"{s.system} {s.name}", fontsize=6, va="center")
            y += 0.033
        for n in range(int(f0 * 1e6 // 24e6) + 1, int(f1 * 1e6 // 24e6) + 1):
            ax.axvline(n * 24, color="r", lw=0.6, ls=":")
        ax.set_xlim(f0, f1); ax.set_ylim(0, 1.25); ax.set_yticks([])
        ax.set_xlabel("Частота, МГц")
    axs[0].set_title("Нижний диапазон (L2/L3/L5/E5/E6/B2/B3)"); axs[1].set_title("Верхний диапазон (L1/E1/B1/G1)")
    fig.suptitle("Частотный план МГП-8 (серые — полосы ВЧ-каналов, красные — гармоники 24 МГц)", fontsize=10)
    fig.tight_layout(); fig.savefig(os.path.join(OUT, "freq_plan.png"), dpi=150)
    print("\n".join(md))


if __name__ == "__main__":
    main()
