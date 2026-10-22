"""Библиотека посадочных мест проекта hw/kicad/mgp8.pretty.

Посадочные места, на которые ссылается схема Э3 под именами библиотеки Pocket SDR
(mgp8:TQFN28, mgp8:BGA-121 …), строятся из стандартной библиотеки KiCad с переименованием
контактных площадок под номера выводов УГО. Делитель СВЧ PD0922 и рамка экрана MS448-10F
строятся по размерам из документации изготовителя.

Запуск: из build.py (функция write_lib) или отдельно: python3 hw/gen/footprints.py
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import symlib  # noqa: E402
from sexp import Q, loads, dumps, find, first  # noqa: E402

KICAD_FP = os.path.join(os.path.dirname(symlib.KICAD_SYM.rstrip("/\\")), "footprints")
OUT = os.path.abspath(os.path.join(HERE, "..", "kicad", "mgp8.pretty"))

# имя в mgp8 -> (библиотека KiCad, посадочное место, переименование площадок, описание)
COPIES = {
    "TQFN28": ("Package_DFN_QFN", "TQFN-28-1EP_5x5mm_P0.5mm_EP3.25x3.25mm_ThermalVias", "tqfn28",
               "MAX2771ETI+: TQFN-28 5x5 мм, теплоотводящая площадка EP, окна пасты C1-C4, переходные отверстия V1-V9"),
    "BGA-121": ("Package_BGA", "TFBGA-121_10x10mm_Layout11x11_P0.8mm", None,
                "CYUSB3014-BZXC: FBGA-121 10x10 мм, шаг 0,8 мм"),
    "SSOP20": ("Package_SO", "SSOP-20_5.3x7.2mm_P0.65mm", None, "74FCT3807APYG: SSOP-20 5,3x7,2 мм"),
    "TSSOP_8P": ("Package_SO", "TSSOP-8_4.4x3mm_P0.65mm", None, "AT24CM01: TSSOP-8 4,4x3 мм"),
    "VSSOP8_SOT765-1_NEX": ("Package_SO", "VSSOP-8_2.3x2mm_P0.5mm", None, "74AVC9112DC: VSSOP-8 (SOT765-1)"),
    "20TQFN-ZB_PI3USB302-A_DIO": ("Package_DFN_QFN", "DHVQFN-20-1EP_2.5x4.5mm_P0.5mm_EP1x3mm", None,
                                  "PI3USB302-AZBEX: TQFN-20 2,5x4,5 мм (ZB)"),
    "TCXO": ("Oscillator", "Oscillator_SMD_SeikoEpson_TG2520SMN-xxx-xxxxxx-4Pin_2.5x2.0mm", None,
             "ТКГ TG2520SMN 2,5x2,0 мм"),
    "XTAL_SMD": ("Crystal", "Crystal_SMD_2520-4Pin_2.5x2.0mm", None, "Резонатор CS05400 2,5x2,0 мм, 4 вывода"),
    "USB4080-03-A_GCT": ("Connector_USB", "USB_C_Receptacle_Amphenol_12401610E4-2A", {"SH": "EP"},
                         "USB4080-03-A: розетка USB Type-C 24 контакта, горизонтальная; "
                         "площадки по 12401610E4-2A, корпус — EP"),
    "microSD_HC_Hirose_DM3AT-SF-PEJM5": ("Connector_Card", "microSD_HC_Hirose_DM3AT-SF-PEJM5", {"SH": "11"},
                                         "DM3AT-SF-PEJM5: корпус — вывод 11 (как в УГО Э3)"),
}


def _fp_path(lib, name):
    return os.path.join(KICAD_FP, lib + ".pretty", name + ".kicad_mod")


def _rename_tqfn28(fp):
    """EP: медь EP; четыре окна пасты — площадки C1-C4 на меди EP; девять отверстий — V1-V9."""
    nv = nc = 0
    for p in find(fp, "pad"):
        layers = [str(x) for x in first(p, "layers")[1:]]
        if p[1] == "29" and p[2] == "thru_hole":
            nv += 1
            p[1] = Q(f"V{nv}")
        elif p[1] == "29":
            p[1] = Q("EP")
        elif p[1] == "" and layers == ["F.Paste"]:
            nc += 1
            p[1] = Q(f"C{nc}")
            first(p, "layers")[1:] = [Q("F.Cu"), Q("F.Paste")]
    assert (nv, nc) == (9, 4), (nv, nc)


def copy_fp(new, lib, name, rename, descr):
    fp = loads(open(_fp_path(lib, name), encoding="utf-8").read())
    fp[1] = Q(new)
    first(fp, "descr")[1] = Q(f"{descr}. Основа: {lib}:{name}")
    for prop in find(fp, "property"):
        if prop[1] == "Value":
            prop[2] = Q(new)
    if rename == "tqfn28":
        _rename_tqfn28(fp)
    elif rename:
        for p in find(fp, "pad"):
            if p[1] in rename:
                p[1] = Q(rename[p[1]])
    return fp


def _text(kind, val, x, y, layer, hide=False):
    n = ["property", Q(kind), Q(val), ["at", x, y, 0], ["layer", Q(layer)]]
    if hide:
        n.append(["hide", "yes"])
    n.append(["effects", ["font", ["size", 1, 1], ["thickness", 0.15]]])
    return n


def _rect(layer, x0, y0, x1, y1, w):
    return ["fp_rect", ["start", x0, y0], ["end", x1, y1], ["stroke", ["width", w], ["type", "solid"]],
            ["fill", "no"], ["layer", Q(layer)]]


def _pad(num, x, y, w, h, layers=("F.Cu", "F.Mask", "F.Paste"), shape="roundrect"):
    p = ["pad", Q(num), "smd", shape, ["at", x, y], ["size", w, h], ["layers"] + [Q(x) for x in layers]]
    if shape == "roundrect":
        p.append(["roundrect_rratio", 0.25])
    return p


def _head(name, descr, attrs):
    return ["footprint", Q(name), ["version", 20260206], ["generator", Q("mgp8_footprints")], ["layer", Q("F.Cu")],
            ["descr", Q(descr)], ["tags", Q(name)]] + [["attr"] + list(attrs)]


def rf_div():
    """PD0922J5050S2HF: корпус 2,0x1,25 мм, по три вывода на длинных сторонах с шагом 0,65 мм.
    1, 3, 5 — общий; 2 — вход; 4, 6 — выходы (вход и выходы — на противоположных сторонах)."""
    fp = _head("RF_DIV", "Делитель мощности 1:2 PD0922J5050S2HF, 2,0x1,25 мм, 6 выводов", ["smd"])
    fp += [_text("Reference", "REF**", 0, -1.6, "F.SilkS"), _text("Value", "RF_DIV", 0, 1.6, "F.Fab")]
    xs = (-0.65, 0, 0.65)
    for k, x in enumerate(xs):          # 1..3 — нижняя сторона слева направо
        fp.append(_pad(str(k + 1), x, 0.6, 0.35, 0.55))
    for k, x in enumerate(reversed(xs)):  # 4..6 — верхняя сторона справа налево
        fp.append(_pad(str(k + 4), x, -0.6, 0.35, 0.55))
    fp.append(_rect("F.Fab", -1.0, -0.625, 1.0, 0.625, 0.1))
    fp.append(_rect("F.CrtYd", -1.25, -1.13, 1.25, 1.13, 0.05))
    fp.append(["fp_line", ["start", -1.1, 0.95], ["end", -1.1, 0.35], ["stroke", ["width", 0.12], ["type", "solid"]],
               ["layer", Q("F.SilkS")]])
    return fp


SHIELD_W, SHIELD_H, SHIELD_LAND = 44.8, 18.2, 0.9


def shield():
    """Рамка экрана MS448-10F (Masach) 44,8x18,2x3,0 мм: сплошной контур пайки шириной 0,9 мм по периметру.
    Площадки — общий провод; посадочное место только на плате (в ВП — отдельной строкой)."""
    w, h, t = SHIELD_W / 2, SHIELD_H / 2, SHIELD_LAND
    fp = _head("SHIELD_MS448-10F", "Рамка экрана MS448-10F 44,8x18,2x3,0 мм с крышкой MS448-10C",
               ["smd", "board_only", "exclude_from_pos_files", "exclude_from_bom"])
    fp += [_text("Reference", "REF**", -w + 3, -h - 1.0, "F.SilkS"),
           _text("Value", "MS448-10F", 0, 0, "F.Fab")]
    for x, y, sx, sy in ((0, -h + t / 2, 2 * w, t), (0, h - t / 2, 2 * w, t),
                         (-w + t / 2, 0, t, 2 * h), (w - t / 2, 0, t, 2 * h)):
        fp.append(_pad("1", x, y, sx, sy, shape="rect"))
    fp.append(_rect("F.Fab", -w, -h, w, h, 0.1))
    fp.append(_rect("F.SilkS", -w - 0.15, -h - 0.15, w + 0.15, h + 0.15, 0.12))
    # контур занимаемого места — кольцо (внутри рамки размещаются ВЧ-каналы)
    fp.append(_rect("F.CrtYd", -w - 0.25, -h - 0.25, w + 0.25, h + 0.25, 0.05))
    fp.append(_rect("F.CrtYd", -w + t + 0.05, -h + t + 0.05, w - t - 0.05, h - t - 0.05, 0.05))
    return fp


def write_lib(out=OUT):
    os.makedirs(out, exist_ok=True)
    fps = {n: copy_fp(n, *v) for n, v in COPIES.items()}
    fps["RF_DIV"] = rf_div()
    fps["SHIELD_MS448-10F"] = shield()
    for name, fp in fps.items():
        with open(os.path.join(out, name + ".kicad_mod"), "w", encoding="utf-8", newline="\n") as f:
            f.write(dumps(fp) + "\n")
    return sorted(fps)


if __name__ == "__main__":
    print("mgp8.pretty:", ", ".join(write_lib()))
