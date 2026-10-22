"""Тепловая модель печатной платы МГП-8 при температуре окружающей среды +85 °С (ТЗ п. 5.6.1).

Плата — тонкая пластина: в плоскости тепло растекается по медным слоям (теплопроводность каждого
слоя — по фактическому заполнению медью в данной точке: полигоны, проводники, площадки), с обеих
сторон отводится естественной конвекцией и излучением к окружению с температурой Ta. Перепад
температуры по толщине платы (1,6 мм) мал и не учитывается. Сетка 0,5 мм, метод конечных
разностей (разреженная система, scipy).

Каждая микросхема — узел кристалла, связанный с платой под корпусом через θJB (ψJB) и, для ПЛИС
в варианте с отводом тепла на крышку, — с крышкой через θJC (верх корпуса) и теплопроводящую
прокладку. Мощности — по ПЗ 5.7 (sim/power_budget.py). Не учитываются (в запас): теплоотвод через
крепёжные стойки, площадь поверхности корпусов, разъёмов и экранов сверх площади платы.

Запуск: python sim/thermal_board.py [плата.kicad_pcb] -> sim/out/thermal.md, sim/out/thermal.png
"""
import math
import os
import sys

import numpy as np
import scipy.sparse as sp
import scipy.sparse.linalg as spla
from matplotlib.path import Path

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(ROOT, "hw", "gen"))
from sexp import find, first, loads  # noqa: E402

PCB = os.path.join(ROOT, "hw", "kicad", "mgp8.kicad_pcb")
TA = 85.0                      # температура окружающей среды, °С (ТЗ п. 5.6.1)
DX = 0.5                       # шаг сетки, мм
K_CU, K_FR4 = 385.0, 0.8       # теплопроводность меди и FR-4 (в плоскости), Вт/(м·К)
EPS_MASK, EPS_SHIELD = 0.85, 0.1   # степень черноты: паяльная маска / нейзильбер экранов
SIGMA = 5.67e-8
# воздух при ~95 °С: теплопроводность, кинематическая вязкость, температуропроводность
K_AIR, NU_AIR, A_AIR = 0.031, 2.3e-5, 3.3e-5
CU_LAYERS = ["F.Cu"] + [f"In{i}.Cu" for i in range(1, 7)] + ["B.Cu"]

# отвод тепла на крышку корпуса: θJC верха корпуса (оценка) + теплопроводящая прокладка
# 3 Вт/(м·К) толщиной 1 мм на всю площадь корпуса
K_PAD, T_PAD = 3.0, 1.0e-3


def r_pad(a):
    return T_PAD / (K_PAD * (a * 1e-3) ** 2)


LID_R = {"DD7": 6.0 + r_pad(17), "DD9": 12.0 + r_pad(14), "DD10": 10.0 + r_pad(10)}
LID_NOTE = "θJC верха корпуса: ПЛИС (caBGA381) 6, МК (LQFP100) 12, FX3 (BGA121) 10 °С/Вт"

# источник: позиционное обозначение -> (наименование, габарит корпуса мм, ψJB °С/Вт, Tj доп., режимы)
# мощности, Вт: ключ "nav" — навигационный режим, "usb" — выдача отсчётов по USB 3.0;
# МК — при 480 МГц; при 400 МГц мощность МК 0,46 Вт (ПЗ 5.7.2)
SRC = {
    "DD7": ("ПЛИС LFE5U-45", 17, 9.0, 100, 0.67, 0.67),
    "DD9": ("МК STM32H743", 16, 20.0, 105, 0.61, 0.61),
    "DD10": ("FX3 CYUSB3014", 10, 12.0, 100, 0.0, 0.40),
    **{f"DA{i}": ("MAX2771", 5, 10.0, 125, 0.063, 0.063) for i in range(15, 23)},
    **{r: ("LP5907 3,3 В (ВЧ)", 3, 45.0, 125, 0.065, 0.065) for r in ("DA2", "DA6", "DA8", "DA11")},
    "DA12": ("LP5907 3,3 В (такт.)", 3, 45.0, 125, 0.060, 0.060),
    "DA3": ("LP5907 1,2 В", 3, 45.0, 125, 0.017, 0.017),
    "DA4": ("LP5907 2,5 В", 3, 45.0, 125, 0.020, 0.020),
    "DA9": ("TPS62130 +3V3D", 3, 21.0, 125, 0.141, 0.141),
    "DA10": ("TPS62130 +1V1", 3, 21.0, 125, 0.115, 0.115),
    "DA26": ("TPS62130 1,2 В FX3", 3, 21.0, 125, 0.0, 0.063),
    "DA25": ("SPX3819 3,3 В FX3", 3, 45.0, 125, 0.0, 0.077),
    "DD5": ("74FCT3807", 7, 30.0, 125, 0.083, 0.083),
    "DA24": ("MCP2562FD", 5, 40.0, 125, 0.050, 0.050),
    "XS1": ("Карта microSD", 12, 0.0, 85, 0.130, 0.130),
}
P_REST = 0.09          # флеш-память, EEPROM, датчики, буферы, ТКГ, светодиоды — равномерно по плате, Вт
P_MCU_400 = 0.46
SHOW = ["DD7", "DD9", "DD10", "DA9", "DA10", "DA11", "DA2", "DA6", "DA8", "DA12", "DA26", "DA25", "DD5",
        "DA17", "XS1"]


# --- разбор платы ---------------------------------------------------------------------------
def parse(path):
    root = loads(open(path, encoding="utf-8").read())
    xs, ys = [], []
    for s in find(root, "gr_rect"):
        if str(first(s, "layer")[1]) == "Edge.Cuts":
            for k in ("start", "end"):
                p = first(s, k)
                xs.append(float(p[1]))
                ys.append(float(p[2]))
    ox, oy = min(xs), min(ys)
    w, h = max(xs) - ox, max(ys) - oy
    nx, ny = int(round(w / DX)), int(round(h / DX))
    # доля меди в ячейке по слоям: выборка 2×2 точки на ячейку
    sub = DX / 2
    gx = ox + (np.arange(2 * nx) + 0.5) * sub
    gy = oy + (np.arange(2 * ny) + 0.5) * sub
    PX, PY = np.meshgrid(gx, gy)
    cov = {L: np.zeros((2 * ny, 2 * nx)) for L in CU_LAYERS}
    for z in find(root, "zone"):
        for fp_ in find(z, "filled_polygon"):
            L = str(first(fp_, "layer")[1])
            if L not in cov:
                continue
            pts = np.array([(float(p[1]), float(p[2])) for p in find(first(fp_, "pts"), "xy")])
            x0, y0 = pts.min(0)
            x1, y1 = pts.max(0)
            j0, j1 = max(0, int((x0 - ox) / sub)), min(2 * nx, int((x1 - ox) / sub) + 1)
            i0, i1 = max(0, int((y0 - oy) / sub)), min(2 * ny, int((y1 - oy) / sub) + 1)
            if i1 <= i0 or j1 <= j0:
                continue
            q = np.column_stack([PX[i0:i1, j0:j1].ravel(), PY[i0:i1, j0:j1].ravel()])
            m = Path(pts).contains_points(q).reshape(i1 - i0, j1 - j0)
            cov[L][i0:i1, j0:j1] = np.maximum(cov[L][i0:i1, j0:j1], m)
    cov = {L: c.reshape(ny, 2, nx, 2).mean((1, 3)) for L, c in cov.items()}

    def add(L, x, y, a):
        j, i = int((x - ox) / DX), int((y - oy) / DX)
        if 0 <= i < ny and 0 <= j < nx:
            cov[L][i, j] += a / DX ** 2
    for s in find(root, "segment"):
        L = str(first(s, "layer")[1])
        if L not in cov:
            continue
        a, b = first(s, "start"), first(s, "end")
        x0, y0, x1, y1 = float(a[1]), float(a[2]), float(b[1]), float(b[2])
        wd = float(first(s, "width")[1])
        n = max(1, int(math.hypot(x1 - x0, y1 - y0) / (DX / 2)))
        step = math.hypot(x1 - x0, y1 - y0) / n
        for k in range(n):
            t = (k + 0.5) / n
            add(L, x0 + t * (x1 - x0), y0 + t * (y1 - y0), step * wd)
    fps = {}
    for f in find(root, "footprint"):
        at = first(f, "at")
        fx, fy = float(at[1]), float(at[2])
        rot = math.radians(float(at[3]) if len(at) > 3 else 0.0)
        ref = next((str(p[2]) for p in find(f, "property") if str(p[1]) == "Reference"), "")
        side = "B" if str(first(f, "layer")[1]) == "B.Cu" else "F"
        fps[ref] = dict(x=fx - ox, y=fy - oy, side=side, name=str(f[1]).split(":", 1)[1])
        for p in find(f, "pad"):
            pa, sz = first(p, "at"), first(p, "size")
            px, py = float(pa[1]), float(pa[2])
            gxp = fx + px * math.cos(rot) + py * math.sin(rot)
            gyp = fy - px * math.sin(rot) + py * math.cos(rot)
            area = float(sz[1]) * float(sz[2]) * (math.pi / 4 if str(p[3]) in ("circle", "oval") else 1.0)
            pl = [str(x) for x in first(p, "layers")[1:]]
            for L in CU_LAYERS:
                if L in pl or "*.Cu" in pl:
                    add(L, gxp, gyp, area)
    cov = {L: np.clip(c, 0.0, 1.0) for L, c in cov.items()}
    # толщины меди и диэлектрика из стека слоёв
    t_cu, t_d = {L: 0.035 for L in CU_LAYERS}, 1.6 - 8 * 0.035
    st = first(first(root, "setup"), "stackup")
    if st:
        t_d = 0.0
        for L in find(st, "layer"):
            t, typ = first(L, "thickness"), str(first(L, "type")[1])
            if t and typ == "copper":
                t_cu[str(L[1])] = float(t[1])
            elif t and typ in ("core", "prepreg"):
                t_d += float(t[1])
    return dict(w=w, h=h, nx=nx, ny=ny, cov=cov, fps=fps, t_cu=t_cu, t_d=t_d)


# --- решение -----------------------------------------------------------------------------------
def h_conv(dT, w, h):
    """Естественная конвекция горизонтальной пластины: верх 0,54·Ra^¼, низ 0,27·Ra^¼, L = A/P."""
    L = w * h / (2 * (w + h)) * 1e-3
    ra = 9.81 / (273.15 + TA + dT / 2) * max(dT, 0.1) * L ** 3 / (NU_AIR * A_AIR)
    return 0.54 * K_AIR / L * ra ** 0.25, 0.27 * K_AIR / L * ra ** 0.25


def solve(B, power, lid=(), t_lid=TA, eps_scale=1.0, hc_scale=1.0):
    """power: ref -> Вт; lid: микросхемы с отводом тепла на крышку при температуре t_lid, °С."""
    nx, ny = B["nx"], B["ny"]
    N = nx * ny
    G = K_FR4 * B["t_d"] * 1e-3 + sum(K_CU * B["t_cu"][L] * 1e-3 * B["cov"][L] for L in CU_LAYERS)  # Вт/К
    eps_top = np.full((ny, nx), EPS_MASK)
    for r, f in B["fps"].items():
        if f["name"].startswith("SHIELD"):
            i0, i1 = int((f["y"] - 9.1) / DX), int((f["y"] + 9.1) / DX)
            j0, j1 = int((f["x"] - 22.4) / DX), int((f["x"] + 22.4) / DX)
            eps_top[max(0, i0):i1, max(0, j0):j1] = EPS_SHIELD
    eps_top *= eps_scale
    eps_bot = np.full((ny, nx), EPS_MASK * eps_scale)
    idx = np.arange(N).reshape(ny, nx)
    rows, cols, vals = [], [], []
    for a, b, ga, gb in ((idx[:, :-1], idx[:, 1:], G[:, :-1], G[:, 1:]), (idx[:-1, :], idx[1:, :], G[:-1, :], G[1:, :])):
        g = (2 * ga * gb / (ga + gb)).ravel()
        a, b = a.ravel(), b.ravel()
        rows += [a, b, a, b]
        cols += [a, b, b, a]
        vals += [g, g, -g, -g]
    K0 = sp.csr_matrix((np.concatenate(vals), (np.concatenate(rows), np.concatenate(cols))), shape=(N, N))
    # узлы кристаллов
    refs = [r for r, p in power.items() if p > 0 and r in B["fps"]]
    ns = len(refs)
    cr, cc, cv = [], [], []
    q = np.zeros(N + ns)
    q[:N] = P_REST / N
    lid_g = np.zeros(ns)
    for k, r in enumerate(refs):
        f, (name, size, psi, _, _, _) = B["fps"][r], SRC[r]
        i0, i1 = int((f["y"] - size / 2) / DX), int(math.ceil((f["y"] + size / 2) / DX))
        j0, j1 = int((f["x"] - size / 2) / DX), int(math.ceil((f["x"] + size / 2) / DX))
        cells = idx[max(0, i0):min(ny, i1), max(0, j0):min(nx, j1)].ravel()
        n = N + k
        if psi <= 0:                         # карта памяти: мощность прямо в плату под ней
            q[cells] += power[r] / len(cells)
            cr.append(n), cc.append(n), cv.append(1.0)
            cr += [n] * len(cells)
            cc += list(cells)
            cv += [-1.0 / len(cells)] * len(cells)
            continue
        g = 1.0 / psi / len(cells)
        q[n] = power[r]
        for c in cells:
            cr += [n, c, n, c]
            cc += [n, c, c, n]
            cv += [g, g, -g, -g]
        if r in lid:
            lid_g[k] = 1.0 / LID_R[r]
    Kj = sp.csr_matrix((cv, (cr, cc)), shape=(N + ns, N + ns))
    K = sp.block_diag([K0, sp.csr_matrix((ns, ns))]).tocsr() + Kj
    T = np.full(N + ns, TA + 10.0)
    A = (B["w"] * B["h"]) * 1e-6 / N            # площадь ячейки, м²
    for _ in range(8):
        tb = T[:N].reshape(ny, nx)
        dT = float(tb.mean() - TA)
        ht, hb = (hc_scale * v for v in h_conv(dT, B["w"], B["h"]))
        Tk, Tak = tb + 273.15, TA + 273.15
        hr = SIGMA * (Tk ** 2 + Tak ** 2) * (Tk + Tak)
        gs = (ht + hb + hr * (eps_top + eps_bot)).ravel() * A
        D = np.concatenate([gs, lid_g])
        rhs = q + np.concatenate([gs * TA, lid_g * t_lid])
        T = spla.spsolve((K + sp.diags(D)).tocsc(), rhs)
    tb = T[:N].reshape(ny, nx)
    tj = {r: T[N + k] for k, r in enumerate(refs)}
    p_lid = sum(lid_g[k] * (T[N + k] - t_lid) for k in range(ns))
    return dict(tb=tb, tj=tj, mean=float(tb.mean()), max=float(tb.max()), h=(ht, hb), p_lid=p_lid,
                G=G, ptot=sum(power[r] for r in refs) + P_REST)


def powers(mode, mcu400=False):
    p = {r: (v[4] if mode == "nav" else v[5]) for r, v in SRC.items()}
    if mcu400:
        p["DD9"] = P_MCU_400
    return p


ALL3 = ("DD7", "DD9", "DD10")
CASES = [  # (заголовок, режим, МК 400 МГц, микросхемы с отводом на крышку)
    ("USB, МК 480 МГц, без отвода на крышку", "usb", False, ()),
    ("USB, МК 400 МГц, на крышку только ПЛИС", "usb", True, ("DD7",)),
    ("USB, МК 480 МГц, на крышку ПЛИС, МК, FX3", "usb", False, ALL3),
    ("USB, МК 400 МГц, на крышку ПЛИС, МК, FX3", "usb", True, ALL3),
    ("Навиг., МК 480 МГц, на крышку ПЛИС, МК", "nav", False, ALL3),
]
FIG = (0, 3)          # варианты на рисунке


def plot(B, ra, rb, ta, tb_, out):
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    from matplotlib.colors import LinearSegmentedColormap
    ramp = ["#cde2fb", "#b7d3f6", "#9ec5f4", "#86b6ef", "#6da7ec", "#5598e7", "#3987e5", "#2a78d6",
            "#256abf", "#1c5cab", "#184f95", "#104281", "#0d366b"]
    cmap = LinearSegmentedColormap.from_list("seq", ramp)
    ink, ink2, grid = "#0b0b0b", "#52514e", "#d9d8d4"
    vmin = math.floor(min(ra["tb"].min(), rb["tb"].min()))
    vmax = math.ceil(max(ra["tb"].max(), rb["tb"].max()))
    fig, axs = plt.subplots(1, 2, figsize=(11.5, 4.6), constrained_layout=True)
    for ax, r, t in ((axs[0], ra, ta), (axs[1], rb, tb_)):
        im = ax.imshow(r["tb"], extent=(0, B["w"], B["h"], 0), cmap=cmap, vmin=vmin, vmax=vmax,
                       interpolation="bilinear")
        for ref, lab in (("DD7", "ПЛИС"), ("DD9", "МК"), ("DD10", "FX3"), ("DA9", "DA9"), ("DA10", "DA10")):
            f = B["fps"][ref]
            s = SRC[ref][1]
            ax.add_patch(plt.Rectangle((f["x"] - s / 2, f["y"] - s / 2), s, s, fill=False, lw=0.8,
                                       ec="white" if r["tb"][int(f["y"] / DX), int(f["x"] / DX)] > (vmin + vmax) / 2 else ink2))
            ax.text(f["x"], f["y"] - s / 2 - 1.0, f"{lab}: Tj {r['tj'][ref]:.0f} °С", ha="center", va="bottom",
                    fontsize=7.5, color=ink)
        ax.set_title(t, fontsize=9.5, color=ink, loc="left")
        ax.set_xlabel("x, мм", fontsize=8, color=ink2)
        ax.tick_params(labelsize=7, colors=ink2, length=2)
        for sp_ in ax.spines.values():
            sp_.set_color(grid)
    cb = fig.colorbar(im, ax=axs, shrink=0.85, pad=0.01)
    cb.set_label("Температура платы, °С", fontsize=8, color=ink2)
    cb.ax.tick_params(labelsize=7, colors=ink2, length=2)
    cb.outline.set_edgecolor(grid)
    axs[0].set_ylabel("y, мм", fontsize=8, color=ink2)
    fig.savefig(out, dpi=150)
    plt.close(fig)


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else PCB
    B = parse(path)
    res = [solve(B, powers(m, f4), lid) for _, m, f4, lid in CASES]
    pess = solve(B, powers("usb", True), ALL3, eps_scale=0.5, hc_scale=0.7)
    lid10 = solve(B, powers("usb", True), ALL3, t_lid=TA + 10.0)
    cov = {L: float(B["cov"][L].mean()) for L in CU_LAYERS}
    G = res[0]["G"]
    out = ["### Тепловая модель платы (Ta = +85 °С)", "",
           f"Плата {B['w']:.0f} × {B['h']:.0f} мм, медь 8 слоёв; заполнение слоёв медью, %: "
           + ", ".join(f"{L.replace('.Cu', '')} {100 * c:.0f}" for L, c in cov.items())
           + f". Теплопроводность платы в плоскости {G.mean():.3f} Вт/К (среднее, ≈ {G.mean() / (K_CU * 35e-6):.1f} "
           "сплошного слоя 35 мкм). Коэффициенты теплоотдачи (при перегреве платы в первом варианте): "
           f"конвекция {res[0]['h'][0]:.1f} Вт/(м²·К) сверху, {res[0]['h'][1]:.1f} снизу; излучение "
           f"≈ {SIGMA * 4 * (TA + 273.15 + res[0]['mean'] - TA) ** 3 * EPS_MASK:.1f} Вт/(м²·К) при ε = {EPS_MASK} "
           f"(над экранами ε = {EPS_SHIELD}).", "",
           "| Элемент | ψJB, °С/Вт | Tj доп., °С | " + " | ".join(c[0] for c in CASES) + " |",
           "|---|---|---|" + "---|" * len(CASES)]
    for r in SHOW:
        name, _, psi, lim, _, _ = SRC[r]
        cells = []
        for (_, m, f4, _), x in zip(CASES, res):
            if r in x["tj"]:
                v = x["tj"][r]
                cells.append(f"**{v:.1f}**" if v > lim else f"{v:.1f}")
            else:
                cells.append("—")
        out.append(f"| {r} {name} | {psi:.0f} | {lim} | " + " | ".join(cells) + " |")
    out.append("| Плата: средняя / наибольшая, °С | | | " + " | ".join(f"{x['mean']:.1f} / {x['max']:.1f}" for x in res) + " |")
    out.append("| Мощность, Вт (в т. ч. через крышку) | | | " + " | ".join(
        f"{x['ptot']:.2f}" + (f" ({x['p_lid']:.2f})" if x["p_lid"] else "") for x in res) + " |")
    out += ["", "Жирным — превышение допустимой температуры кристалла (для карты microSD — температуры "
            "корпуса по документации изготовителя). Для карты приведена температура платы под ней.", "",
            f"Чувствительность (USB, МК 400 МГц, ПЛИС, МК и FX3 на крышку): при конвекции −30 % и степени черноты −50 % — "
            f"ПЛИС {pess['tj']['DD7']:.1f} °С, МК {pess['tj']['DD9']:.1f} °С, плата до {pess['max']:.1f} °С; "
            f"при крышке на 10 °С теплее окружающей среды — ПЛИС {lid10['tj']['DD7']:.1f} °С, "
            f"МК {lid10['tj']['DD9']:.1f} °С, FX3 {lid10['tj']['DD10']:.1f} °С.", "",
            f"Допущения: {LID_NOTE} (оценка); прокладка {K_PAD:.0f} Вт/(м·К) толщиной {T_PAD * 1e3:.0f} мм на всю "
            f"площадь корпуса ({r_pad(17):.2f} / {r_pad(14):.2f} / {r_pad(10):.2f} °С/Вт); крышка — металлическая "
            "стенка корпуса изделия (с выступами над микросхемами) при температуре окружающей "
            "среды; ψJB — по документации изготовителей на корпуса данного типа (оценка); теплоотвод через "
            "крепёжные стойки, поверхности корпусов, разъёмов и экранов не учитывается (в запас)."]
    os.makedirs(os.path.join(HERE, "out"), exist_ok=True)
    open(os.path.join(HERE, "out", "thermal.md"), "w", encoding="utf-8").write("\n".join(out) + "\n")
    a, b = FIG
    plot(B, res[a], res[b], CASES[a][0], CASES[b][0], os.path.join(HERE, "out", "thermal.png"))
    print("\n".join(out))


if __name__ == "__main__":
    main()
