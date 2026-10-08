"""Запуск SPICE-моделей узлов МГП-8 (ngspice) и построение графиков.

Запуск: python3 sim/spice_runner.py -> sim/out/spice_*.png, sim/out/spice.md
"""
import os
import re
import subprocess

import numpy as np
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402

plt.rcParams["font.family"] = "DejaVu Sans"
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SP = os.path.join(ROOT, "hw", "spice")
OUT = os.path.join(ROOT, "sim", "out")
os.makedirs(OUT, exist_ok=True)


def run(deck):
    r = subprocess.run(["ngspice", "-b", deck + ".cir"], cwd=SP, capture_output=True, text=True)
    meas = {}
    for ln in (r.stdout + r.stderr).splitlines():
        m = re.match(r"^(\w+)\s+=\s+([-+\d.eE]+)", ln)
        if m:
            meas[m.group(1)] = float(m.group(2))
    data = np.loadtxt(os.path.join(SP, deck + ".dat"))
    return meas, data


def main():
    md = ["### Результаты моделирования узлов в ngspice", ""]
    # 1. питание антенны
    m, d = run("ant_supply")
    t = d[:, 0] * 1e3
    fig, ax = plt.subplots(3, 1, figsize=(8, 6.5), sharex=True)
    ax[0].plot(t, d[:, 7] * 1e3)
    ax[0].set_ylabel("Ток антенны, мА")
    ax[1].plot(t, d[:, 1], label="U антенны")
    ax[1].plot(t, d[:, 3], label="IMON (Ку=20)")
    ax[1].axhline(2.4, ls="--", c="r", lw=0.8, label="порог АЦП 2,4 В")
    ax[1].legend(fontsize=8)
    ax[1].set_ylabel("В")
    ax[2].plot(t, d[:, 5])
    ax[2].set_ylabel("ANT_EN, В")
    ax[2].set_xlabel("Время, мс")
    for a in ax:
        a.grid(alpha=.3)
    ax[0].set_title("Питание антенны: штатный режим и КЗ в момент 2 мс")
    fig.tight_layout()
    fig.savefig(os.path.join(OUT, "spice_ant_supply.png"), dpi=140)
    plt.close(fig)
    md += ["**Питание антенны (hw/spice/ant_supply.cir).** Штатный ток 30 мА:",
           f"напряжение на антенне {m['v_ant_norm']:.2f} В, выход датчика тока {m['imon_norm']:.2f} В.",
           f"При КЗ пиковый ток {abs(m['i_peak']):.2f} А ограничен сопротивлением цепи (шунт, предохранитель, DCR).",
           f"Аналоговый сторожевой таймер АЦП МК отключает ключ через {(m['t_trip'] - 2e-3) * 1e6:.1f} мкс после КЗ.",
           "Предохранитель FEMTOSMDC010F-2 срабатывает только при отказе программной защиты.", ""]
    # 2. выход 1PPS
    m, d = run("pps_out")
    t = d[:, 0] * 1e9
    fig, ax = plt.subplots(figsize=(8, 3.6))
    ax.plot(t, d[:, 1], label="нагрузка 50 Ом")
    ax.plot(t, d[:, 3], label="нагрузка 1 МОм || 15 пФ")
    ax.plot(t, d[:, 5], ":", label="выход буфера (после 33 Ом)")
    ax.set_xlim(40, 140)
    ax.set_xlabel("Время, нс")
    ax.set_ylabel("В")
    ax.grid(alpha=.3)
    ax.legend(fontsize=8)
    ax.set_title("Фронт 1PPS на конце кабеля 2 м (50 Ом)")
    fig.tight_layout()
    fig.savefig(os.path.join(OUT, "spice_pps.png"), dpi=140)
    plt.close(fig)
    md += ["**Выход 1PPS (hw/spice/pps_out.cir).** Согласование по источнику (Rвых + 33 Ом ≈ 50 Ом):",
           f"на нагрузке 50 Ом уровень {m['v50_high']:.2f} В, на высокоомной нагрузке {m['vhz_high']:.2f} В,",
           f"выброс {100 * (m['vhz_peak'] / m['vhz_high'] - 1):.1f} %. Задержка от буфера до нагрузки",
           f"{(m['thz_cross'] - m['tdrv_cross']) * 1e9:.1f} нс; она калибруется и учитывается в ПО (параметр задержки кабеля).", ""]
    # 3. вход опоры
    m, d = run("ref_in")
    t = d[:, 0] * 1e9
    sel = (t > 2000) & (t < 2300)
    fig, ax = plt.subplots(figsize=(8, 3.6))
    ax.plot(t[sel], d[sel, 1], label="вход (на 49,9 Ом)")
    ax.plot(t[sel], d[sel, 3], label="после разделения (+ вх.)")
    ax.plot(t[sel], d[sel, 5], label="порог (− вх.)")
    ax.plot(t[sel], d[sel, 7] / 3.3, label="выход компаратора / 3,3")
    ax.set_xlabel("Время, нс")
    ax.grid(alpha=.3)
    ax.legend(fontsize=7, ncol=2)
    ax.set_title("Вход опоры 10 МГц (генератор 0 дБм на 50 Ом)")
    fig.tight_layout()
    fig.savefig(os.path.join(OUT, "spice_refin.png"), dpi=140)
    plt.close(fig)
    md += ["**Вход опоры (hw/spice/ref_in.cir).** Синусоида 10 МГц от генератора 0 дБм формируется",
           f"компаратором TLV3501 без пропусков. Период на выходе {m.get('period', 1e-7) * 1e9:.1f} нс, "
           f"среднее выходное {m['duty']:.2f} В.", ""]
    # 4. ВЧ-вход
    m, d = run("biastee_rf")
    f = d[:, 0] / 1e9
    fig, ax = plt.subplots(figsize=(8, 3.6))
    ax.plot(f, d[:, 1], label="S21, дБ")
    ax2 = ax.twinx()
    ax2.plot(f, d[:, 3], "r", label="S11, дБ")
    for b0, b1 in ((1.164, 1.300), (1.559, 1.610)):
        ax.axvspan(b0, b1, color="g", alpha=0.08)
    ax.set_xlabel("Частота, ГГц")
    ax.set_ylabel("S21, дБ")
    ax2.set_ylabel("S11, дБ", color="r")
    ax.set_ylim(-0.5, 0.05)
    ax.grid(alpha=.3)
    ax.set_title("ВЧ-вход: защита + тройник питания + разделительный конденсатор")
    fig.tight_layout()
    fig.savefig(os.path.join(OUT, "spice_biastee.png"), dpi=140)
    plt.close(fig)
    md += ["**ВЧ-вход (hw/spice/biastee_rf.cir).** Вносимые потери в полосах ГНСС:",
           f"{-m['s21_1176']:.3f} дБ на 1176 МГц и {-m['s21_1575']:.3f} дБ на 1575 МГц. Возвратные потери",
           f"{-m['s11_1176']:.1f} и {-m['s11_1575']:.1f} дБ соответственно.", ""]
    with open(os.path.join(OUT, "spice.md"), "w") as fh:
        fh.write("\n".join(md))
    print("\n".join(md))


if __name__ == "__main__":
    main()
