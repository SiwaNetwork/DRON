"""Моделирование видимости, геометрических факторов (DOP), точности навигационного решения
и привязки 1PPS для МГП-8 по реальным бортовым эфемеридам IGS (19.06.2021).

Запуск: python3 sim/geometry_pvt.py -> sim/out/geometry.png, pvt.png, geometry_pvt.md, pvt.json
"""
import json
import math
import os
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(__file__))
import gnss_orbits as O  # noqa: E402

OUT = os.path.join(os.path.dirname(__file__), "out")
os.makedirs(OUT, exist_ok=True)
EPH = os.path.join(os.path.dirname(__file__), "data", "BRDC00IGS_R_20211700000_01D_MN_subset.rnx")
SITE = dict(name="Москва", lat=55.7558, lon=37.6173, h=150.0)
MASK = 10.0
SYSNAME = {"G": "GPS", "R": "ГЛОНАСС", "E": "Galileo", "C": "BeiDou", "J": "QZSS"}

# Бюджет ошибок псевдодальности (1σ, м) — ПЗ, раздел 5
SISRE = {"G": 0.6, "R": 1.5, "E": 0.3, "C": 0.8, "J": 0.6}   # орбита+часы КА (бортовые эфемериды)
F = {"G": (1575.42e6, 1176.45e6), "E": (1575.42e6, 1176.45e6), "C": (1575.42e6, 1176.45e6),
     "J": (1575.42e6, 1176.45e6), "R": (1602.0e6, 1246.0e6)}


def code_noise(cn0, chip, d=0.5, B=1.0, T=0.02):
    """СКО ошибки слежения ССЗ (когерентный дискриминатор ранний−поздний), м."""
    c = 10 ** (cn0 / 10)
    lam = O.C / chip
    return lam * math.sqrt(B * d / (2 * c) * (1 + 2 / ((2 - d) * T * c)))


def visibility(con, t0, hours=24, step=300):
    rx = O.llh2ecef(SITE["lat"], SITE["lon"], SITE["h"])
    R = O.enu_matrix(SITE["lat"], SITE["lon"])
    times = np.arange(t0, t0 + hours * 3600, step)
    res = []
    for t in times:
        vis = []
        for key in con.sats():
            p, _ = con.pos(key, t)
            if p is None:
                continue
            az, el, rho = O.az_el(rx, p, R)
            if el >= MASK:
                vis.append((key, az, el, (p - rx) / rho))
        res.append((t, vis))
    return times, res


def dop(vis, systems):
    rows = []
    syss = sorted({k[0] for k, *_ in vis if k[0] in systems})
    for key, az, el, u in vis:
        if key[0] not in systems:
            continue
        row = [-u[0], -u[1], -u[2]] + [1.0 if key[0] == s else 0.0 for s in syss]
        rows.append(row)
    if len(rows) < 3 + len(syss):
        return None
    G = np.array(rows)
    try:
        Q = np.linalg.inv(G.T @ G)
    except np.linalg.LinAlgError:
        return None
    Renu = O.enu_matrix(SITE["lat"], SITE["lon"])
    Qe = Renu @ Q[:3, :3] @ Renu.T
    return dict(pdop=math.sqrt(np.trace(Q[:3, :3])), hdop=math.sqrt(Qe[0, 0] + Qe[1, 1]),
                vdop=math.sqrt(Qe[2, 2]), tdop=math.sqrt(Q[3, 3]), n=len(rows))


def pvt_mc(con, vis, t, mode="dual", systems="GREC", n_mc=400, rng=None):
    """Монте-Карло решения МНК: ошибки по бюджету, оценка координат, часов и межсистемных смещений."""
    rng = rng or np.random.default_rng(1)
    rx = O.llh2ecef(SITE["lat"], SITE["lon"], SITE["h"])
    R = O.enu_matrix(SITE["lat"], SITE["lon"])
    sats = [(k, az, el, u) for k, az, el, u in vis if k[0] in systems]
    syss = sorted({k[0] for k, *_ in sats})
    errs, terr = [], []
    for _ in range(n_mc):
        G, W, y = [], [], []
        for key, az, el, u in sats:
            s = key[0]
            se = math.sin(math.radians(el))
            cn0 = 44 - 8 * (1 - se)        # C/N0 по углу места (антенна −5 дБи у горизонта)
            f1, f2 = F[s]
            chip = 10.23e6 if s != "R" else 5.11e6
            if mode in ("dual", "dual_s"):
                a = f1 ** 2 / (f1 ** 2 - f2 ** 2)
                b = f2 ** 2 / (f1 ** 2 - f2 ** 2)
                n1 = math.hypot(code_noise(cn0, 1.023e6 if s != "C" else 2.046e6, d=0.25), 0.25 / se)
                n2 = math.hypot(code_noise(cn0, chip, d=0.5), 0.15 / se)
                sig_n = math.hypot(a * n1, b * n2)
                if mode == "dual_s":
                    sig_n /= 3.0     # сглаживание кода по фазе несущей (фильтр Хэтча, окно 100 с)
                iono = 0.0
            else:
                sig_n = math.hypot(code_noise(cn0, 1.023e6 if s != "R" else 0.511e6, d=0.25), 0.3 / se)
                iono = 0.5 * 5.0 / math.sqrt(1 - (0.94 * math.cos(math.radians(el))) ** 2)  # остаток модели Клобучара 50 %
            trop = 0.1 / se
            sig = math.sqrt(SISRE[s] ** 2 + sig_n ** 2 + trop ** 2 + iono ** 2)
            e = rng.normal(0, sig)
            G.append([-u[0], -u[1], -u[2]] + [1.0 if s == q else 0.0 for q in syss])
            W.append(1 / sig ** 2)
            y.append(e)
        G, W, y = np.array(G), np.diag(W), np.array(y)
        N = G.T @ W @ G
        x = np.linalg.solve(N, G.T @ W @ y)
        errs.append(R @ x[:3])
        terr.append(x[3] / O.C * 1e9)
    errs = np.array(errs)
    h = np.hypot(errs[:, 0], errs[:, 1])
    return dict(h50=float(np.percentile(h, 50)), h95=float(np.percentile(h, 95)),
                v95=float(np.percentile(np.abs(errs[:, 2]), 95)), t_rms_ns=float(np.std(terr)), n=len(sats))


def main():
    con = O.Constellation(EPH)
    _, t0 = O.gpst_sow(2021, 6, 19, 0, 0, 0)
    times, vis = visibility(con, t0)
    combos = {"GPS": "G", "ГЛОНАСС": "R", "GPS+ГЛОНАСС": "GR", "Все системы": "GREJC"}
    series = {k: [dop(v, s) for _, v in vis] for k, s in combos.items()}
    counts = {s: [sum(1 for k, *_ in v if k[0] == s) for _, v in vis] for s in "GREJC"}
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    plt.rcParams["font.family"] = "DejaVu Sans"
    hrs = (times - t0) / 3600
    fig, ax = plt.subplots(2, 1, figsize=(10, 7), sharex=True)
    bottom = np.zeros(len(hrs))
    for s in "GREJC":
        ax[0].fill_between(hrs, bottom, bottom + np.array(counts[s]), step="mid", alpha=0.7, label=SYSNAME[s])
        bottom += np.array(counts[s])
    ax[0].set_ylabel("Видимых КА (угол места ≥ 10°)")
    ax[0].legend(ncol=5, fontsize=8)
    ax[0].grid(alpha=.3)
    for k, ser in series.items():
        ax[1].plot(hrs, [d["pdop"] if d else np.nan for d in ser], label=k)
    ax[1].set_ylim(0, 6)
    ax[1].set_ylabel("PDOP")
    ax[1].set_xlabel("Время GPST, ч (19.06.2021), Москва")
    ax[1].legend(fontsize=8)
    ax[1].grid(alpha=.3)
    fig.tight_layout()
    fig.savefig(os.path.join(OUT, "geometry.png"), dpi=140)
    plt.close(fig)
    md = ["### Видимость и геометрия (Москва, 19.06.2021, маска 10°, бортовые эфемериды IGS)", "",
          "| Конфигурация | КА в среднем (мин…макс) | PDOP средн. | PDOP макс. | HDOP средн. | VDOP средн. | TDOP средн. |",
          "|---|---|---|---|---|---|---|"]
    stat = {}
    for k, ser in series.items():
        dd = [d for d in ser if d]
        n = [d["n"] for d in dd]
        p = [d["pdop"] for d in dd]
        stat[k] = dict(n_mean=float(np.mean(n)), pdop_mean=float(np.mean(p)), pdop_max=float(np.max(p)))
        md.append(f"| {k} | {np.mean(n):.1f} ({min(n)}…{max(n)}) | {np.mean(p):.2f} | {np.max(p):.2f} | "
                  f"{np.mean([d['hdop'] for d in dd]):.2f} | {np.mean([d['vdop'] for d in dd]):.2f} | "
                  f"{np.mean([d['tdop'] for d in dd]):.2f} |")
    # навигационное решение: 8 эпох через 3 ч
    rng = np.random.default_rng(7)
    rows = []
    for mode, label in (("dual_s", "двухчастотный, сглаживание по фазе 100 с"),
                        ("dual", "двухчастотный (ионосферно-свободная комбинация)"),
                        ("single", "одночастотный L1 (модель ионосферы)")):
        for sysk, sname in (("G", "GPS"), ("GR", "GPS+ГЛОНАСС"), ("GREC", "GPS+ГЛОНАСС+Galileo+BeiDou")):
            acc = []
            for idx in range(0, len(vis), 36):
                acc.append(pvt_mc(con, vis[idx][1], times[idx], mode, sysk, 200, rng))
            r = {k: float(np.mean([a[k] for a in acc])) for k in ("h50", "h95", "v95", "t_rms_ns", "n")}
            r.update(mode=label, sys=sname)
            rows.append(r)
    md += ["", "### Погрешность автономного решения (моделирование методом Монте-Карло)", "",
           "| Режим | Системы | КА | В плане CEP50, м | В плане 95 %, м | По высоте 95 %, м | СКО шкалы времени, нс |",
           "|---|---|---|---|---|---|---|"]
    for r in rows:
        md.append(f"| {r['mode']} | {r['sys']} | {r['n']:.0f} | {r['h50']:.2f} | {r['h95']:.2f} | {r['v95']:.2f} | {r['t_rms_ns']:.1f} |")
    best = [r for r in rows if r["sys"].startswith("GPS+ГЛОНАСС+") and "сглаж" in r["mode"]][0]
    # бюджет привязки 1PPS
    pps = [("Оценка смещения шкалы приёмника (TDOP·σ, многосистемный двухчастотный)", best["t_rms_ns"]),
           ("Дискретность формирования 1PPS (96 МГц, без коррекции qErr: 10,4/√12)", 10.42 / math.sqrt(12)),
           ("Остаток после коррекции qErr (джиттер ТКГ и тактового дерева ПЛИС)", 0.3),
           ("Калибровка задержки антенна–кабель–ВЧ-тракт", 2.0),
           ("Нестабильность групповой задержки ВЧ-тракта по температуре", 1.5),
           ("Разброс задержки выходного буфера и кабеля 1PPS", 0.5)]
    tot_noq = math.sqrt(sum(v ** 2 for _, v in pps if "Остаток" not in _))
    tot_q = math.sqrt(sum(v ** 2 for k, v in pps if "Дискретность" not in k))
    md += ["", "### Бюджет погрешности привязки 1PPS (1σ)", "", "| Составляющая | нс |", "|---|---|"]
    md += [f"| {k} | {v:.2f} |" for k, v in pps]
    md += [f"| **Итого без коррекции дискретности** | **{tot_noq:.1f}** |",
           f"| **Итого с коррекцией qErr** | **{tot_q:.1f}** |"]
    fig, ax = plt.subplots(figsize=(11, 4.2))
    labels = [f"{r['sys'].replace('+Galileo+BeiDou', '+GAL+BDS')}\n" +
              ("2f+сглаж." if "сглаж" in r["mode"] else ("2 частоты" if r["mode"].startswith("двух") else "1 частота"))
              for r in rows]
    x = np.arange(len(rows))
    ax.bar(x - 0.2, [r["h95"] for r in rows], 0.4, label="в плане 95 %")
    ax.bar(x + 0.2, [r["v95"] for r in rows], 0.4, label="по высоте 95 %")
    ax.axhline(2.5, color="b", ls="--", lw=0.8, label="ТЗ: план 2,5 м")
    ax.axhline(4.0, color="orange", ls="--", lw=0.8, label="ТЗ: высота 4 м")
    ax.set_xticks(x)
    ax.set_xticklabels(labels, fontsize=7)
    ax.set_ylabel("м")
    ax.legend(fontsize=7)
    ax.grid(alpha=.3, axis="y")
    ax.set_title("Погрешность автономного решения (модель)")
    fig.tight_layout()
    fig.savefig(os.path.join(OUT, "pvt.png"), dpi=140)
    plt.close(fig)
    with open(os.path.join(OUT, "geometry_pvt.md"), "w") as f:
        f.write("\n".join(md) + "\n")
    json.dump(dict(dop=stat, pvt=rows, pps=dict(no_q=tot_noq, q=tot_q)), open(os.path.join(OUT, "pvt.json"), "w"),
              ensure_ascii=False, indent=1)
    print("\n".join(md))


if __name__ == "__main__":
    main()
