"""Высота и масса модуля МГП-8 по печатной плате hw/kicad/mgp8.kicad_pcb (ТЗ п. 5.1.3, 5.1.4).

Высота: толщина платы по стеку слоёв + наибольший выступ компонентов над верхней и под нижней
стороной. Выступ — по трёхмерным моделям библиотеки KiCad (габарит STEP по оси z), для изделий без
модели — по чертежам изготовителей (таблица OWN_H). Экраны — рамка MS448-10F (3,0 мм) с крышкой.
Масса: плата (диэлектрик + медь по фактическому заполнению слоёв + маска), компоненты по типам
корпусов (типовые массы по документации изготовителей, с округлением вверх), экраны (по
геометрии рамки и крышки), припой. Корпус модуля и крепёж не учитываются (ТЗ: «без корпуса»).

Запуск: python sim/mech_budget.py [плата.kicad_pcb] -> sim/out/mech.md
"""
import fnmatch
import glob
import math
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(ROOT, "hw", "gen"))
from sexp import find, first, loads  # noqa: E402

PCB = os.path.join(ROOT, "hw", "kicad", "mgp8.kicad_pcb")
H_MAX, M_MAX = 12.0, 80.0                     # ТЗ п. 5.1.3, 5.1.4
SHUNT = 0.5                                   # перемычка на вилке X4 (шаг 2,0 мм) выше штырей, мм
CU_LAYERS = ["F.Cu"] + [f"In{i}.Cu" for i in range(1, 7)] + ["B.Cu"]
RHO = {"fr4": 1.9, "cu": 8.96, "mask": 1.4, "ns": 8.7}      # г/см³ (ns — нейзильбер экранов)

# изделия без трёхмерной модели в библиотеке KiCad: высота над платой, мм (чертёж изготовителя)
OWN_H = {"SHIELD_MS448-10F": 3.2,             # рамка 3,0 мм + крышка MS448-10C 0,2 мм
         "RF_DIV": 1.0,                       # PD0922J5050S2HF
         "USB4080-03-A_GCT": 3.5}             # GCT USB4080, с округлением вверх
# типовые массы корпусов, г (по документации изготовителей, округлены вверх); шаблон имени -> масса
MASS = [("C_0402*", 0.0015), ("R_0402*", 0.001), ("L_0402*", 0.001),
        ("C_0603*", 0.006), ("L_0603*", 0.004), ("LED_0603*", 0.004), ("Fuse_0603*", 0.004),
        ("SOT-23-5*", 0.015), ("SOT-23-6*", 0.016), ("SOT-23", 0.009),
        ("TQFN28", 0.07), ("VQFN-16*", 0.025), ("20TQFN*", 0.02), ("VSSOP8*", 0.01), ("TSSOP_8P", 0.04),
        ("SSOP20", 0.15), ("SOIC-8_3.9*", 0.08), ("SOIC-8_5.3*", 0.13),
        ("LQFP-100*", 0.65), ("Lattice_caBGA-381*", 1.2), ("BGA-121", 0.35),
        ("L_Coilcraft_XxL4020", 0.1), ("D_SMA", 0.07), ("Infineon_SG-WLL*", 0.0005),
        ("TCXO", 0.02), ("Crystal_SMD_3215*", 0.02), ("XTAL_SMD", 0.03), ("RF_DIV", 0.1),
        ("SMA_Samtec*", 3.5), ("USB4080*", 1.2), ("microSD*", 0.6),
        ("JST_GH_SM06B*", 0.25), ("JST_GH_SM04B*", 0.2), ("JST_SH_SM04B*", 0.1),
        ("PinHeader_2x05_P1.27mm*", 0.4), ("PinHeader_1x02_P2.00mm*", 0.15),
        ("SHIELD_MS448-10F", None), ("MountingHole*", 0.0)]
GROUPS = [("Разъёмы SMA", "SMA_*"), ("Прочие разъёмы", "USB4080*|microSD*|JST_*|PinHeader_*"),
          ("Микросхемы в корпусах BGA и QFP", "Lattice_caBGA*|BGA-121|LQFP-*"),
          ("Конденсаторы и резисторы 0402/0603", "C_0*|R_0*|L_0*|LED_0*|Fuse_0*"),
          ("Прочие микросхемы, кварцы, дроссели", "*")]


def models_dir():
    for p in [os.environ.get("KICAD10_3DMODEL_DIR")] + sorted(
            glob.glob(r"C:\Program Files\KiCad\*\share\kicad\3dmodels"), reverse=True) + [
            "/usr/share/kicad/3dmodels"]:
        if p and os.path.isdir(p):
            return p
    return None


_PT = re.compile(r"CARTESIAN_POINT\s*\(\s*'[^']*'\s*,\s*\(\s*([-+\d.Ee]+)\s*,\s*([-+\d.Ee]+)\s*,\s*([-+\d.Ee]+)\s*\)")
_zcache = {}


def model_z(path):
    """Габарит модели STEP по оси z (мм): (zmin, zmax) относительно верхней стороны платы."""
    if path not in _zcache:
        zs = [float(m.group(3)) for m in _PT.finditer(open(path, encoding="latin-1").read())]
        _zcache[path] = (min(zs), max(zs)) if zs else None
    return _zcache[path]


def match(name, pat):
    return any(fnmatch.fnmatch(name, p) for p in pat.split("|"))


def poly_area(pts):
    return abs(sum(x0 * y1 - x1 * y0 for (x0, y0), (x1, y1) in zip(pts, pts[1:] + pts[:1]))) / 2


def board(path=PCB):
    root = loads(open(path, encoding="utf-8").read())
    # стек слоёв
    thick, layers = 0.0, []
    st = first(first(root, "setup"), "stackup")
    if st:
        for L in find(st, "layer"):
            t = first(L, "thickness")
            typ = str(first(L, "type")[1])
            if t:
                thick += float(t[1])
                layers.append((str(L[1]), typ, float(t[1])))
    else:
        thick = float(first(first(root, "general"), "thickness")[1])
    # контур
    xs, ys = [], []
    for s in find(root, "gr_rect"):
        if str(first(s, "layer")[1]) == "Edge.Cuts":
            for k in ("start", "end"):
                p = first(s, k)
                xs.append(float(p[1]))
                ys.append(float(p[2]))
    w, h = max(xs) - min(xs), max(ys) - min(ys)
    origin = (min(xs), min(ys))
    # медь по слоям; проводники и площадки цепи, залитой на том же слое, лежат в заливке
    cu = {L: 0.0 for L in CU_LAYERS}
    poured = {L: set() for L in CU_LAYERS}

    def net(x):
        n = first(x, "net")
        return str(n[-1]) if n else ""
    for z in find(root, "zone"):
        for fp_ in find(z, "filled_polygon"):
            L = str(first(fp_, "layer")[1])
            pts = [(float(p[1]), float(p[2])) for p in find(first(fp_, "pts"), "xy")]
            if L in cu:
                cu[L] += poly_area(pts)
                poured[L].add(net(z))
    for s in find(root, "segment"):
        L = str(first(s, "layer")[1])
        if net(s) in poured.get(L, ()):
            continue
        a, b = first(s, "start"), first(s, "end")
        cu[L] = cu.get(L, 0.0) + math.hypot(float(b[1]) - float(a[1]), float(b[2]) - float(a[2])) * float(first(s, "width")[1])
    nvia = 0
    for v in find(root, "via"):
        nvia += 1
    fps = []
    for f in find(root, "footprint"):
        name = str(f[1]).split(":", 1)[1]
        side = "B" if str(first(f, "layer")[1]) == "B.Cu" else "F"
        at = first(f, "at")
        ref = next((str(p[2]) for p in find(f, "property") if str(p[1]) == "Reference"), "")
        pads = []
        for p in find(f, "pad"):
            sz = first(p, "size")
            pl = [str(x) for x in first(p, "layers")[1:]]
            area = float(sz[1]) * float(sz[2]) * (math.pi / 4 if str(p[3]) in ("circle", "oval") else 1.0)
            pads.append((pl, area))
            for L in CU_LAYERS:
                if (L in pl or "*.Cu" in pl) and net(p) not in poured[L]:
                    cu[L] += area
        m = first(f, "model")
        fps.append(dict(ref=ref, name=name, side=side, x=float(at[1]) - origin[0], y=float(at[2]) - origin[1],
                        rot=float(at[3]) if len(at) > 3 else 0.0, model=str(m[1]) if m else None))
    return dict(w=w, h=h, thick=thick, layers=layers, cu=cu, fps=fps, nvia=nvia)


def heights(B):
    mdir = models_dir()
    out = []
    for f in B["fps"]:
        if f["name"] in OWN_H:
            z0, z1 = 0.0, OWN_H[f["name"]]
            src = "чертёж изготовителя"
        elif f["model"] and mdir:
            p = f["model"].replace("${KICAD10_3DMODEL_DIR}", mdir)
            z = model_z(p) if os.path.exists(p) else None
            if z is None:
                continue
            z0, z1 = z
            src = "модель KiCad"
        else:
            continue
        t = B["thick"]
        if f["side"] == "F":
            top, bot = max(z1, 0.0), max(-z0 - t, 0.0)
        else:
            top, bot = max(-z0 - t, 0.0), max(z1, 0.0)
        out.append(dict(ref=f["ref"], name=f["name"], side=f["side"], top=top, bot=bot, src=src))
    return out


def masses(B):
    t_cu = 0.035
    area = B["w"] * B["h"]
    m_fr4 = sum(th for _, typ, th in B["layers"] if typ in ("core", "prepreg")) * area * 1e-3 * RHO["fr4"]
    if not m_fr4:
        m_fr4 = (B["thick"] - 8 * t_cu) * area * 1e-3 * RHO["fr4"]
    m_cu = sum(min(a, area) for a in B["cu"].values()) * t_cu * 1e-3 * RHO["cu"]
    m_mask = 2 * 0.02 * area * 1e-3 * RHO["mask"]
    # экран: крышка 44,8×18,2×0,2, рамка: стенка 3,0 мм и полка 1 мм по периметру, толщина 0,2
    per = 2 * (44.8 + 18.2)
    m_sh = (44.8 * 18.2 * 0.2 + per * (3.0 + 1.0) * 0.2) * 1e-3 * RHO["ns"]
    comp, unknown = {}, []
    for f in B["fps"]:
        if f["name"] == "SHIELD_MS448-10F":
            comp.setdefault("Экраны (рамка + крышка)", [0, 0.0])
            comp["Экраны (рамка + крышка)"][0] += 1
            comp["Экраны (рамка + крышка)"][1] += m_sh
            continue
        m = next((v for pat, v in MASS if match(f["name"], pat)), None)
        if m is None:
            unknown.append(f["ref"])
            continue
        if not m:
            continue
        g = next(gname for gname, pat in GROUPS if match(f["name"], pat))
        comp.setdefault(g, [0, 0.0])
        comp[g][0] += 1
        comp[g][1] += m
    n_parts = sum(v[0] for k, v in comp.items() if not k.startswith("Экраны"))
    m_solder = 1.0                                  # паста ~0,1 мм по площадкам, с запасом
    return dict(fr4=m_fr4, cu=m_cu, mask=m_mask, comp=comp, solder=m_solder, unknown=unknown,
                n_parts=n_parts, cu_cov={L: min(a, area) / area for L, a in B["cu"].items()})


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else PCB
    B = board(path)
    hs = heights(B)
    M = masses(B)
    top = sorted(hs, key=lambda r: -r["top"])
    bot = sorted(hs, key=lambda r: -r["bot"])
    h_tot = B["thick"] + top[0]["top"] + bot[0]["bot"]
    out = ["### Высота модуля (ТЗ п. 5.1.3: не более 12 мм с экранами)", "",
           f"Толщина платы по стеку слоёв: {B['thick']:.2f} мм.", "",
           "| Сторона | Позиция | Посадочное место | Выступ, мм | Источник |", "|---|---|---|---|---|"]
    for side, rows, key in (("верхняя", top, "top"), ("нижняя", bot, "bot")):
        seen = set()
        for r in rows:
            if len(seen) == 4:
                break
            if r["name"] in seen:
                continue
            seen.add(r["name"])
            out.append(f"| {side} | {r['ref']} | {r['name']} | {r[key]:.2f} | {r['src']} |")
    out += ["", f"Наибольшая высота модуля: {top[0]['top']:.2f} ({top[0]['ref']}) + {B['thick']:.2f} + "
                f"{bot[0]['bot']:.2f} ({bot[0]['ref']}) = **{h_tot:.2f} мм** при допустимой {H_MAX:.0f} мм "
                f"(запас {H_MAX - h_tot:.2f} мм). Вилки высотой более 4 мм (X1–X4) размещены на верхней стороне; "
                f"перемычка, надетая на X4, выступает над штырями не более чем на {SHUNT:.1f} мм "
                f"(высота {h_tot + SHUNT:.2f} мм).", ""]
    m_pcb = M["fr4"] + M["cu"] + M["mask"]
    out += ["### Масса модуля без корпуса (ТЗ п. 5.1.4: не более 80 г)", "",
            "| Составная часть | Кол-во | Масса, г |", "|---|---|---|",
            f"| Плата: диэлектрик FR-4 | — | {M['fr4']:.1f} |",
            f"| Плата: медь (заполнение слоёв {', '.join(f'{v * 100:.0f}' for v in M['cu_cov'].values())} %) | — | {M['cu']:.1f} |",
            f"| Плата: паяльная маска | — | {M['mask']:.1f} |"]
    for g, (n, m) in sorted(M["comp"].items(), key=lambda kv: -kv[1][1]):
        out.append(f"| {g} | {n} | {m:.1f} |")
    m_comp = sum(m for _, m in M["comp"].values())
    total = m_pcb + m_comp + M["solder"]
    out += [f"| Припой | — | {M['solder']:.1f} |",
            f"| **Итого** | {M['n_parts']} комп. | **{total:.1f}** |", "",
            f"Масса модуля без корпуса **{total:.1f} г** при допустимой {M_MAX:.0f} г (запас {M_MAX - total:.1f} г, "
            f"{(M_MAX - total) / M_MAX * 100:.0f} %)."]
    if M["unknown"]:
        out.append(f"Без оценки массы: {', '.join(M['unknown'])}.")
    os.makedirs(os.path.join(HERE, "out"), exist_ok=True)
    open(os.path.join(HERE, "out", "mech.md"), "w", encoding="utf-8").write("\n".join(out) + "\n")
    print("\n".join(out))


if __name__ == "__main__":
    main()
