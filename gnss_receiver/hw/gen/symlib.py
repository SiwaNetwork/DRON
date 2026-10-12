"""Сборка библиотеки УГО проекта mgp8.kicad_sym.

Источники:
  * собственные УГО по ЕСКД (ГОСТ 2.728 — резисторы и конденсаторы, 2.723 — катушки,
    2.730 — диоды, 2.736 — кварцевые резонаторы, 2.727 — предохранители, 2.721 — корпус/общий провод);
  * стандартная библиотека KiCad (микросхемы с выверенной цоколёвкой);
  * библиотека Pocket SDR (BSD-2): MAX2771, CYUSB3014, PD0922J5050S2HF, 74AVC9112, 74FCT3807,
    PI3USB302, USB4080, AT24C (цоколёвка подтверждена серийной платой FE 8CH v4.1).

Все тексты переводятся на шрифт osifont (ISO 3098 / ГОСТ 2.304).
"""
import copy
import os
import re

from sexp import Q, loads, dumps, find, first, remove

KICAD_SYM = "/usr/share/kicad/symbols"
HERE = os.path.dirname(os.path.abspath(__file__))
POCKET_LIB = os.path.join(HERE, "data", "pocket_sdr_v2.3-eagle-import.kicad_sym")
FONT = "osifont"

_cache = {}


def _load(path):
    if path not in _cache:
        root = loads(open(path, encoding="utf-8").read())
        _cache[path] = {c[1]: c for c in root if isinstance(c, list) and c and c[0] == "symbol"}
    return _cache[path]


def _flatten(lib, name):
    sym = copy.deepcopy(lib[name])
    ext = first(sym, "extends")
    if not ext:
        return sym
    parent = _flatten(lib, ext[1])
    # свойства потомка заменяют свойства родителя, графика и выводы — от родителя
    props = {p[1]: p for p in find(sym, "property")}
    out = [parent[0], Q(name)]
    for item in parent[2:]:
        if isinstance(item, list) and item and item[0] == "property" and item[1] in props:
            out.append(props.pop(item[1]))
        elif isinstance(item, list) and item and item[0] == "symbol":
            sub = copy.deepcopy(item)
            sub[1] = Q(re.sub(r"^.*?(_\d+_\d+)$", name.replace("\\", "") + r"\1", sub[1]))
            out.append(sub)
        else:
            out.append(item)
    out.extend(props.values())
    return out


def _restyle(node):
    """Перевод шрифтов в osifont, удаление атрибутов KiCad 8, отсутствующих в KiCad 7."""
    if not isinstance(node, list):
        return node
    remove(node, "exclude_from_sim")
    remove(node, "generator_version")
    remove(node, "embedded_fonts")
    for i, c in enumerate(node):
        if isinstance(c, list) and c:
            if c[0] == "hide" and len(c) == 2:          # KiCad 9: (hide yes) -> атом hide
                node[i] = "hide" if c[1] == "yes" else None
                continue
            if c[0] == "font":
                remove(c, "face")
                c.insert(1, ["face", Q(FONT)])
            _restyle(c)
    node[:] = [c for c in node if c is not None]
    return node


def _rename(sym, new):
    old = sym[1]
    sym[1] = Q(new)
    for sub in find(sym, "symbol"):
        m = re.match(r".*(_\d+_\d+)$", sub[1])
        sub[1] = Q(new + m.group(1))
    return sym


def kicad(libfile, name, new=None):
    sym = _flatten(_load(os.path.join(KICAD_SYM, libfile)), name)
    return _restyle(_rename(sym, new or name))


def pocket(name, new=None):
    sym = _flatten(_load(POCKET_LIB), name)
    return _restyle(_rename(sym, new or name))


# ---------------------------------------------------------------- УГО по ЕСКД
def _props(ref, val, ref_at=(0, 0, 0), val_at=(0, 0, 0), hide_val=False, extra=()):
    def eff(hide=False, justify=None):
        e = ["effects", ["font", ["face", Q(FONT)], ["size", 2.5, 2.5]]]
        if justify:
            e.append(["justify", justify])
        if hide:
            e.append("hide")
        return e
    out = [["property", Q("Reference"), Q(ref), ["at", *ref_at], eff()],
           ["property", Q("Value"), Q(val), ["at", *val_at], eff(hide_val)],
           ["property", Q("Footprint"), Q(""), ["at", 0, 0, 0], eff(True)],
           ["property", Q("Datasheet"), Q(""), ["at", 0, 0, 0], eff(True)]]
    for k, v in extra:
        out.append(["property", Q(k), Q(v), ["at", 0, 0, 0], eff(True)])
    return out


def _pin(num, x, y, rot, length, typ="passive", name="~"):
    f = ["effects", ["font", ["face", Q(FONT)], ["size", 1.8, 1.8]]]
    return ["pin", typ, "line", ["at", x, y, rot], ["length", length],
            ["name", Q(name), f], ["number", Q(num), copy.deepcopy(f)]]


def _poly(pts, w=0.3, fill="none"):
    return ["polyline", ["pts", *[["xy", x, y] for x, y in pts]],
            ["stroke", ["width", w], ["type", "default"]], ["fill", ["type", fill]]]


def _rect(x0, y0, x1, y1, w=0.3):
    return ["rectangle", ["start", x0, y0], ["end", x1, y1],
            ["stroke", ["width", w], ["type", "default"]], ["fill", ["type", "none"]]]


def _arc(sx, sy, mx, my, ex, ey, w=0.3):
    return ["arc", ["start", sx, sy], ["mid", mx, my], ["end", ex, ey],
            ["stroke", ["width", w], ["type", "default"]], ["fill", ["type", "none"]]]


def _circle(x, y, r, w=0.3, fill="none"):
    return ["circle", ["center", x, y], ["radius", r],
            ["stroke", ["width", w], ["type", "default"]], ["fill", ["type", fill]]]


def _sym(name, ref, graphics, pins, ref_at, val_at, pin_numbers=False, power=False, hide_val=False):
    s = ["symbol", Q(name)]
    if power:
        s.append(["power"])
    if not pin_numbers:
        s.append(["pin_numbers", "hide"])
    s.append(["pin_names", ["offset", 0], "hide"])
    s += [["in_bom", "no" if power else "yes"], ["on_board", "no" if power else "yes"]]
    s += _props(ref, name, ref_at, val_at, hide_val)
    s.append(["symbol", Q(name + "_0_1"), *graphics])
    s.append(["symbol", Q(name + "_1_1"), *pins])
    return s


def eskd_symbols():
    out = []
    # Резистор ГОСТ 2.728: прямоугольник 10x4 мм, вертикально
    out.append(_sym("R", "R", [_rect(-2.032, -5.08, 2.032, 5.08)],
                    [_pin("1", 0, 7.62, 270, 2.54), _pin("2", 0, -7.62, 90, 2.54)],
                    (3.2, 1.5, 0), (3.2, -1.5, 0)))
    # Конденсатор ГОСТ 2.728: обкладки 6 мм, зазор 1,5 мм
    out.append(_sym("C", "C", [_poly([(-3.048, 0.762), (3.048, 0.762)], 0.5),
                               _poly([(-3.048, -0.762), (3.048, -0.762)], 0.5)],
                    [_pin("1", 0, 3.81, 270, 3.048), _pin("2", 0, -3.81, 90, 3.048)],
                    (3.8, 1.5, 0), (3.8, -1.5, 0)))
    # Катушка ГОСТ 2.723: 4 полуокружности
    arcs = []
    for k in range(4):
        y0 = 5.08 - k * 2.54
        arcs.append(_arc(0, y0, 1.27, y0 - 1.27, 0, y0 - 2.54))
    out.append(_sym("L", "L", arcs, [_pin("1", 0, 7.62, 270, 2.54), _pin("2", 0, -7.62, 90, 2.54)],
                    (3.2, 1.5, 0), (3.2, -1.5, 0)))
    # Ферритовый фильтр (катушка с магнитопроводом)
    out.append(_sym("FB", "L", arcs + [_poly([(2.3, 5.08), (2.3, -5.08)], 0.3)],
                    [_pin("1", 0, 7.62, 270, 2.54), _pin("2", 0, -7.62, 90, 2.54)],
                    (3.6, 1.5, 0), (3.6, -1.5, 0)))
    # Диод ГОСТ 2.730 (катод — вывод 1 сверху)
    tri = _poly([(-2.54, -1.905), (2.54, -1.905), (0, 1.905), (-2.54, -1.905)], 0.3)
    bar = _poly([(-2.54, 1.905), (2.54, 1.905)], 0.3)
    dpins = [_pin("1", 0, 5.08, 270, 3.175), _pin("2", 0, -5.08, 90, 3.175)]
    out.append(_sym("D", "VD", [tri, bar], dpins, (4.0, 1.5, 0), (4.0, -1.5, 0)))
    sch = _poly([(-3.3, 2.7), (-2.54, 2.7), (-2.54, 1.905), (2.54, 1.905), (2.54, 1.1), (3.3, 1.1)], 0.3)
    out.append(_sym("D_Schottky", "VD", [tri, sch], copy.deepcopy(dpins), (4.0, 1.5, 0), (4.0, -1.5, 0)))
    # Ограничитель напряжения двунаправленный
    t1 = _poly([(-2.54, 0), (2.54, 0), (0, 3.4), (-2.54, 0)], 0.3)
    t2 = _poly([(-2.54, 0), (2.54, 0), (0, -3.4), (-2.54, 0)], 0.3)
    z = _poly([(-3.3, 0.6), (-2.54, 0), (2.54, 0), (3.3, -0.6)], 0.3)
    out.append(_sym("D_TVS", "VD", [t1, t2, z], [_pin("1", 0, 6.35, 270, 2.95), _pin("2", 0, -6.35, 90, 2.95)],
                    (4.0, 1.5, 0), (4.0, -1.5, 0)))
    # Светодиод: диод + две стрелки излучения
    arr = [_poly([(3.0, 0.5), (5.0, 2.5)], 0.25), _poly([(5.0, 2.5), (4.0, 2.3), (4.8, 1.5), (5.0, 2.5)], 0.25, "outline"),
           _poly([(3.0, -1.0), (5.0, 1.0)], 0.25), _poly([(5.0, 1.0), (4.0, 0.8), (4.8, 0.0), (5.0, 1.0)], 0.25, "outline")]
    out.append(_sym("LED", "HL", [copy.deepcopy(tri), copy.deepcopy(bar), *arr], copy.deepcopy(dpins),
                    (6.0, 1.5, 0), (6.0, -1.5, 0)))
    # Предохранитель ГОСТ 2.727 (самовосстанавливающийся)
    out.append(_sym("Fuse", "FU", [_rect(-1.524, -3.81, 1.524, 3.81), _poly([(0, 3.81), (0, -3.81)], 0.3),
                                   _poly([(-2.6, -3.2), (-1.524, -3.2), (1.524, 3.2), (2.6, 3.2)], 0.25)],
                    [_pin("1", 0, 6.35, 270, 2.54), _pin("2", 0, -6.35, 90, 2.54)], (3.6, 1.5, 0), (3.6, -1.5, 0)))
    # Кварцевый резонатор ГОСТ 2.736 (2 вывода) и с выводами корпуса (4 вывода, как Crystal_GND24)
    xq = [_rect(-1.27, -2.286, 1.27, 2.286), _poly([(-2.54, 3.3), (2.54, 3.3)], 0.5), _poly([(-2.54, -3.3), (2.54, -3.3)], 0.5)]
    out.append(_sym("Crystal", "ZQ", xq, [_pin("1", 0, 6.35, 270, 3.05), _pin("2", 0, -6.35, 90, 3.05)],
                    (4.0, 1.5, 0), (4.0, -1.5, 0)))
    out.append(_sym("Crystal_GND24", "ZQ", copy.deepcopy(xq) + [_poly([(-3.81, -0.0), (-2.0, 0)], 0.15)],
                    [_pin("1", 0, 6.35, 270, 3.05), _pin("3", 0, -6.35, 90, 3.05),
                     _pin("2", -6.35, 0, 0, 2.54), _pin("4", 6.35, 0, 180, 5.08)], (4.0, 4.5, 0), (4.0, -4.5, 0)))
    # Соединитель коаксиальный (гнездо): центральный вывод 1, корпус 2
    out.append(_sym("Coax", "XW", [_circle(0, 0, 2.2), _circle(0, 0, 0.7, 0.3, "outline"), _poly([(0, -2.2), (0, -2.54)])],
                    [_pin("1", -5.08, 0, 0, 4.4), _pin("2", 0, -5.08, 90, 2.54)], (0, 4.0, 0), (0, -6.0, 0),
                    pin_numbers=False))
    # Общий провод (ГОСТ 2.721): горизонтальная черта
    out.append(_sym("GND", "#PWR", [_poly([(0, 0), (0, -1.27)], 0.3), _poly([(-2.54, -1.27), (2.54, -1.27)], 0.5),
                                    _poly([(-1.5, -1.9), (1.5, -1.9)], 0.3), _poly([(-0.6, -2.5), (0.6, -2.5)], 0.3)],
                    [_pin("1", 0, 0, 270, 0, "power_in", "GND")], (0, -5.0, 0), (0, -4.2, 0), power=True,
                    hide_val=True))
    return out


def power_symbol(net):
    """Символ цепи питания: стрелка вверх с наименованием цепи (наименование = Value)."""
    s = _sym(net, "#PWR", [_poly([(0, 0), (0, 1.905)], 0.3), _poly([(-1.27, 1.905), (1.27, 1.905), (0, 3.175), (-1.27, 1.905)], 0.3, "outline")],
             [_pin("1", 0, 0, 90, 0, "power_in", net)], (0, 6.5, 0), (0, 4.3, 0), power=True)
    # видимая надпись — наименование цепи
    for p in find(s, "property"):
        if p[1] == "Reference":
            eff = first(p, "effects")
            eff.append("hide")
    return s


def pin_table(sym):
    """[(номер, имя, тип, unit, x, y, rot)] по символу."""
    out = []

    def walk(n, unit):
        for c in n:
            if isinstance(c, list) and c:
                if c[0] == "pin":
                    at = first(c, "at")
                    out.append(dict(num=str(first(c, "number")[1]), name=str(first(c, "name")[1]), type=c[1],
                                    unit=unit, x=float(at[1]), y=float(at[2]), rot=float(at[3]) if len(at) > 3 else 0.0))
                elif c[0] == "symbol":
                    m = re.match(r".*_(\d+)_(\d+)$", c[1])
                    walk(c, int(m.group(1)) if m else 0)
    walk(sym, 0)
    return out


def write_lib(symbols, path):
    root = ["kicad_symbol_lib", ["version", "20220914"], ["generator", "mgp8_gen"]] + symbols
    with open(path, "w", encoding="utf-8") as f:
        f.write(dumps(root) + "\n")


# ---------------------------------------------------------------- УГО микросхем (ГОСТ 2.743)
CHAR_W = 1.35   # оценка ширины символа osifont при высоте 2,0 мм
PIN_FONT = 2.0
PIN_LEN = 5.08
GRID = 2.54


def _snap(v):
    return round(v / GRID) * GRID


def ic_unit(unit, left, right, title, subtitle="", spacing=2 * GRID, top_pad=2, min_w=25.4):
    """Графика и выводы одной части микросхемы.

    left/right: списки элементов {num, name, type} либо None (промежуток),
    элемент с ключом 'stack': [num,...] — несколько выводов в одной точке (цепи питания).
    """
    maxl = max([len(p["name"]) for p in left if p] + [0])
    maxr = max([len(p["name"]) for p in right if p] + [0])
    title_w = max(len(title), len(subtitle)) * CHAR_W * 1.3 + 4
    w = max(min_w, (maxl + maxr) * CHAR_W + title_w + 4)
    w = 2 * _snap(w / 2 + 1.27)
    n = max(len(left), len(right))
    h = (n + top_pad + 1) * spacing
    h = 2 * _snap(h / 2 + 1.27)
    x0, x1 = -w / 2, w / 2
    y0 = h / 2
    gr = [_rect(x0, -h / 2, x1, h / 2, 0.35)]
    # дополнительные поля (вертикальные линии полей меток)
    lf = x0 + maxl * CHAR_W + 2.5 if maxl else None
    rf = x1 - maxr * CHAR_W - 2.5 if maxr else None
    if lf:
        gr.append(_poly([(lf, h / 2), (lf, -h / 2)], 0.25))
    if rf:
        gr.append(_poly([(rf, h / 2), (rf, -h / 2)], 0.25))
    fx = ((lf or x0) + (rf or x1)) / 2

    def txt(s, x, y, size=2.5, justify=None):
        e = ["effects", ["font", ["face", Q(FONT)], ["size", size, size]]]
        if justify:
            e.append(["justify", justify])
        return ["text", Q(s.replace("ё", "е")), ["at", x, y, 0], e]
    gr.append(txt(title, fx, y0 - 3.0, 2.5))
    if subtitle:
        gr.append(txt(subtitle, fx, y0 - 6.0, 2.0))
    pins = []
    for side, items, x, rot in (("L", left, x0 - PIN_LEN, 0), ("R", right, x1 + PIN_LEN, 180)):
        for i, p in enumerate(items):
            if not p:
                continue
            y = y0 - (i + top_pad) * spacing
            nums = p.get("stack") or [p["num"]]
            for k, num in enumerate(nums):
                big = k == 0
                f = ["effects", ["font", ["face", Q(FONT)], ["size", PIN_FONT if big else 0.01, PIN_FONT if big else 0.01]]]
                pins.append(["pin", p.get("type", "passive"), "line", ["at", x, y, rot], ["length", PIN_LEN],
                             ["name", Q(p["name"] if big else "~"), f],
                             ["number", Q(str(num)), copy.deepcopy(f)]] + ([] if big else []))
    return gr, pins, (x0 - PIN_LEN, -h / 2, x1 + PIN_LEN, h / 2)


def ic_symbol(name, ref, units, value=None, footprint=""):
    """units: [dict(left=[], right=[], title=, subtitle=)]. Возвращает символ KiCad."""
    s = ["symbol", Q(name), ["pin_names", ["offset", 0.762]], ["in_bom", "yes"], ["on_board", "yes"]]
    bbox0 = None
    parts = []
    for k, u in enumerate(units, start=1):
        gr, pins, bb = ic_unit(u.get("unit_no", k), u["left"], u["right"], u["title"], u.get("subtitle", ""),
                               u.get("spacing", 2 * GRID), u.get("top_pad", 2), u.get("min_w", 25.4))
        if bbox0 is None:
            bbox0 = bb
        parts.append((k, gr, pins))
    top = bbox0[3]
    s += _props(ref, value or name, (0, top + 2.5, 0), (0, top + 5.5, 0), hide_val=True)
    for p in find(s, "property"):
        if p[1] == "Footprint":
            p[2] = Q(footprint)
    for k, gr, pins in parts:
        s.append(["symbol", Q(f"{name}_{k}_1"), *gr, *pins])
    return s
