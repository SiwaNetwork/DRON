"""Раскладка листов и запись проекта KiCad 7 (иерархическая схема, библиотека УГО, рамка ЕСКД)."""
import copy
import math
import os
import re
import uuid
from collections import defaultdict

import parts as P
import symlib
from sexp import Q, dumps, find, first

NS = uuid.UUID("6d3c1f0e-8a5b-4c1e-9b7a-2f1d0c9e8a77")
FONT = symlib.FONT
TXT = 2.5          # высота шрифта меток и обозначений, мм (ГОСТ 2.304)
STUB = 2.54
CW = 1.6           # оценка ширины символа osifont 2,5 мм (с запасом)
PAPER = {"A3": (420, 297), "A2": (594, 420), "A1": (841, 594)}
FRAME_L, FRAME_O = 20, 5
TB_W, TB_H = 185, 55      # основная надпись, форма 1
G26_W = 82                # графа 26 в левом верхнем углу (70 мм + 12 мм)


def uid(*parts):
    return Q(str(uuid.uuid5(NS, "/".join(str(p) for p in parts))))


def snap(v, g=2.54):
    return round(v / g) * g


def yo(s):
    return s.replace("ё", "е").replace("Ё", "Е")


def eff(size=TXT, justify=None, hide=False):
    e = ["effects", ["font", ["face", Q(FONT)], ["size", size, size]]]
    if justify:
        e.append(["justify", *justify.split()])
    if hide:
        e.append("hide")
    return e


# ------------------------------------------------------------------ геометрия выводов
def _dir_out(rot):
    """Направление наружу от точки подключения вывода (координаты листа, y вниз)."""
    return {0: (-1, 0), 90: (0, 1), 180: (1, 0), 270: (0, -1)}[int(rot) % 360]


def _xf(px, py, rot):
    """Символьные координаты (y вверх) -> смещение на листе при повороте экземпляра rot."""
    x, y = px, -py
    r = int(rot) % 360
    if r == 0:
        return x, y
    if r == 180:
        return -x, -y
    if r == 90:
        return y, -x
    if r == 270:
        return -y, x


def _rot_dir(d, rot):
    x, y = d
    r = int(rot) % 360
    if r == 0:
        return x, y
    if r == 180:
        return -x, -y
    if r == 90:
        return y, -x
    if r == 270:
        return -y, x


class SheetOut:
    def __init__(self, proj, sheet, page, paper):
        self.proj, self.sheet, self.page, self.paper = proj, sheet, page, paper
        self.items = []
        self.used_syms = set()
        self.pwr_n = 0
        self.W, self.H = PAPER[paper]

    # --- примитивы
    def wire(self, x1, y1, x2, y2):
        self.items.append(["wire", ["pts", ["xy", x1, y1], ["xy", x2, y2]],
                           ["stroke", ["width", 0], ["type", "default"]], ["uuid", uid(self.sheet.sid, "w", len(self.items))]])

    def noconn(self, x, y):
        self.items.append(["no_connect", ["at", x, y], ["uuid", uid(self.sheet.sid, "nc", len(self.items))]])

    def text(self, s, x, y, size=TXT, justify="left top", rot=0):
        self.items.append(["text", Q(yo(s)), ["at", x, y, rot], eff(size, justify), ["uuid", uid(self.sheet.sid, "t", len(self.items))]])

    def poly(self, pts, w=0.25):
        self.items.append(["polyline", ["pts", *[["xy", x, y] for x, y in pts]],
                           ["stroke", ["width", w], ["type", "default"]], ["uuid", uid(self.sheet.sid, "pl", len(self.items))]])

    def label(self, net, x, y, d, glob=False, shape="bidirectional"):
        ang = {(1, 0): 0, (-1, 0): 180, (0, -1): 90, (0, 1): 270}[d]
        just = {0: "left bottom", 180: "right bottom", 90: "left bottom", 270: "right bottom"}[ang]
        if glob:
            just = {0: "left", 180: "right", 90: "left", 270: "right"}[ang]
            self.items.append(["global_label", Q(net), ["shape", shape], ["at", x, y, ang], ["fields_autoplaced"],
                               eff(TXT, just), ["uuid", uid(self.sheet.sid, "gl", len(self.items))],
                               ["property", Q("Intersheetrefs"), Q("${INTERSHEET_REFS}"), ["at", x, y, 0],
                                eff(1.8, "left", hide=True)]])
        else:
            self.items.append(["label", Q(net), ["at", x, y, ang], ["fields_autoplaced"], eff(TXT, just),
                               ["uuid", uid(self.sheet.sid, "lb", len(self.items))]])

    def power(self, net, x, y, d):
        """Символ цепи питания/общего провода, направление d — наружу от вывода."""
        key = "GND" if net == "GND" else net
        if key not in P.SYMBOLS:
            P.SYMBOLS[key] = symlib.power_symbol(net) if net != "GND" else P._eskd("GND")
        self.used_syms.add(key)
        if net == "GND":
            rot = {(0, 1): 0, (0, -1): 180, (1, 0): 90, (-1, 0): 270}[d]
        else:
            rot = {(0, -1): 0, (0, 1): 180, (1, 0): 270, (-1, 0): 90}[d]
        self.pwr_n += 1
        ref = f"#PWR{self.page:02d}{self.pwr_n:03d}"
        path = self.proj.sheet_path(self.sheet)
        vy = -4.6 if rot == 0 else 4.6
        self.items.append(["symbol", ["lib_id", Q(f"mgp8:{key}")], ["at", x, y, rot], ["unit", 1],
                           ["in_bom", "no"], ["on_board", "no"], ["dnp", "no"],
                           ["uuid", uid(self.sheet.sid, "pwr", self.pwr_n)],
                           ["property", Q("Reference"), Q(ref), ["at", x, y, 0], eff(TXT, hide=True)],
                           ["property", Q("Value"), Q(net), ["at", x, y + (vy if net != "GND" else 0), 0],
                            eff(TXT, hide=(net == "GND"))],
                           ["property", Q("Footprint"), Q(""), ["at", x, y, 0], eff(TXT, hide=True)],
                           ["property", Q("Datasheet"), Q(""), ["at", x, y, 0], eff(TXT, hide=True)],
                           ["pin", Q("1"), ["uuid", uid(self.sheet.sid, "pwrp", self.pwr_n)]],
                           ["instances", ["project", Q(self.proj.name), ["path", Q(path), ["reference", Q(ref)], ["unit", 1]]]]])

    # --- подключение вывода
    def attach(self, net, x, y, d, ptype, glob):
        if net is None:
            self.noconn(x, y)
            return
        ex, ey = x + d[0] * STUB, y + d[1] * STUB
        self.wire(x, y, ex, ey)
        if net in self.proj.design.power_nets and d[1] == 0:
            self.label(net, ex, ey, d, glob=True, shape="passive")
        elif net in self.proj.design.power_nets or net == "GND":
            self.power(net, ex, ey, d)
        else:
            shape = {"input": "input", "output": "output", "tri_state": "output"}.get(ptype, "bidirectional")
            # боковые выводы — метки в рамке (цепи уникальны в пределах изделия), торцевые — текстовые
            self.label(net, ex, ey, d, glob=glob or d[1] == 0, shape=shape if glob else "passive")

    def symbol(self, comp, unit, x, y, rot=0):
        key = comp.pd.key
        self.used_syms.add(key)
        path = self.proj.sheet_path(self.sheet)
        sym = P.SYMBOLS[key]
        props = []
        bb = self.proj.unit_bbox(key, unit)
        is_ic = comp.pd.prefix in ("DD", "DA", "G", "X", "XS", "W") and key not in ("Coax",)
        if is_ic:
            rx, ry, rj = x + bb[0] + 5.08, y - bb[3] - 1.5, "left bottom"
            vx, vy = rx, ry
        else:
            # обозначение и номинал справа от корпуса
            rx, ry, rj = x + 3.2, y - 1.4, "left bottom"
            vx, vy = x + 3.2, y + 1.4
            if rot == 180:
                pass
        ref_txt = comp.ref
        props.append(["property", Q("Reference"), Q(ref_txt), ["at", rx, ry, 0], eff(TXT, rj)])
        props.append(["property", Q("Value"), Q(comp.pd.value), ["at", vx, vy + (0 if is_ic else 1.2), 0],
                      eff(2.0, "left top", hide=is_ic)])
        props.append(["property", Q("Footprint"), Q(comp.pd.fp), ["at", x, y, 0], eff(1.5, hide=True)])
        props.append(["property", Q("Datasheet"), Q(""), ["at", x, y, 0], eff(1.5, hide=True)])
        for k, v in (("Наименование", comp.pd.name), ("Изготовитель", comp.pd.mfr), ("Артикул", comp.pd.pn),
                     ("Примечание", comp.note)):
            props.append(["property", Q(k), Q(v), ["at", x, y, 0], eff(1.5, hide=True)])
        pins = [["pin", Q(p["num"]), ["uuid", uid(self.sheet.sid, comp.ref, unit, p["num"], p["x"], p["y"])]]
                for p in symlib.pin_table(sym) if (p["unit"] or 1) == unit or p["unit"] == 0]
        node = ["symbol", ["lib_id", Q(f"mgp8:{key}")], ["at", x, y, rot], ["unit", unit],
                ["in_bom", "no" if comp.dnp else "yes"], ["on_board", "yes"], ["dnp", "yes" if comp.dnp else "no"],
                ["uuid", uid(self.sheet.sid, "sym", comp.ref, unit)], *props, *pins,
                ["instances", ["project", Q(self.proj.name),
                               ["path", Q(path), ["reference", Q(comp.ref)], ["unit", unit]]]]]
        self.items.append(node)
        # выводы
        for p in symlib.pin_table(sym):
            if (p["unit"] or 1) != unit and p["unit"] != 0:
                continue
            if p["name"] == "~" and comp.pd.pin_unit and self.proj.is_stack_dup(key, p):
                continue
            ox, oy = _xf(p["x"], p["y"], rot)
            d = _rot_dir(_dir_out(p["rot"]), rot)
            net = comp.conns.get(p["num"])
            glob = net is not None and len(self.proj.design.net_sheets().get(net, ())) > 1
            self.attach(net, round(x + ox, 4), round(y + oy, 4), d, comp.pd.pin_type.get(p["num"], "passive"), glob)


class Project:
    def __init__(self, design, outdir, name="mgp8", meta=None):
        self.design, self.outdir, self.name = design, outdir, name
        self.meta = meta or {}
        self.root_uuid = uid("root")
        self._bbox = {}
        self._stack = {}
        self._ns = None

    def sheet_path(self, sheet):
        return f"/{self.root_uuid}/{uid('sheet', sheet.sid)}"

    def is_stack_dup(self, key, p):
        # дубликаты в стопке выводов: имя '~' и шрифт ~0
        return p["name"] == "~" and key not in ("R", "C", "L", "FB", "D", "D_Schottky", "D_TVS", "LED", "Fuse",
                                                 "Crystal", "Crystal_GND24", "Coax", "GND") and \
            self._is_tiny(key, p)

    def _is_tiny(self, key, p):
        if key not in self._stack:
            tiny = set()
            sym = P.SYMBOLS[key]

            def walk(n):
                for c in n:
                    if isinstance(c, list) and c:
                        if c[0] == "pin":
                            num = first(c, "number")
                            size = first(first(first(num, "effects"), "font"), "size")
                            if float(size[1]) < 0.1:
                                tiny.add(str(num[1]))
                        else:
                            walk(c)
            walk(sym)
            self._stack[key] = tiny
        return p["num"] in self._stack[key]

    def unit_bbox(self, key, unit):
        if (key, unit) not in self._bbox:
            xs, ys = [], []
            sym = P.SYMBOLS[key]
            for sub in find(sym, "symbol"):
                m = re.match(r".*_(\d+)_(\d+)$", sub[1])
                u = int(m.group(1))
                if u not in (0, unit):
                    continue
                for c in sub:
                    if isinstance(c, list) and c and c[0] == "rectangle":
                        s, e = first(c, "start"), first(c, "end")
                        xs += [float(s[1]), float(e[1])]
                        ys += [float(s[2]), float(e[2])]
                    if isinstance(c, list) and c and c[0] == "pin":
                        at = first(c, "at")
                        xs.append(float(at[1]))
                        ys.append(float(at[2]))
            if not xs:
                xs, ys = [-5, 5], [-5, 5]
            self._bbox[(key, unit)] = (min(xs), min(ys), max(xs), max(ys))
        return self._bbox[(key, unit)]


# ------------------------------------------------------------------ раскладка
def _ext(proj, net, d):
    """(длина вдоль направления d, полуширина поперёк) для обозначения подключения."""
    if net is None:
        return 1.5, 1.5
    if net == "GND":
        return 3.5, 2.8
    if net in proj.design.power_nets:
        if d[1] != 0:
            return 8.5, max(len(net) * CW / 2, 2.0)
        return 4.0 + len(net) * CW, 1.8
    glob = len(proj.design.net_sheets().get(net, ())) > 1 or d[1] == 0
    return len(net) * CW + (4.0 if glob else 1.0), 1.8


def unit_geom(proj, comp, unit, rot):
    key = comp.pd.key
    sym = P.SYMBOLS[key]
    bb = proj.unit_bbox(key, unit)
    pts = [_xf(bb[0], bb[1], rot), _xf(bb[2], bb[3], rot)]
    xs = [p[0] for p in pts]
    ys = [p[1] for p in pts]
    for p in symlib.pin_table(sym):
        if (p["unit"] or 1) != unit and p["unit"] != 0:
            continue
        ox, oy = _xf(p["x"], p["y"], rot)
        d = _rot_dir(_dir_out(p["rot"]), rot)
        L, wc = _ext(proj, comp.conns.get(p["num"]), d)
        ex, ey = ox + d[0] * (STUB + L), oy + d[1] * (STUB + L)
        if d[0]:
            xs.append(ex)
            ys += [oy - wc, oy + wc]
        else:
            ys.append(ey)
            xs += [ox - wc, ox + wc]
    is_ic = comp.pd.prefix in ("DD", "DA", "G", "X", "XS", "W") and key != "Coax"
    if is_ic:
        ys.append(min(ys) - 4.0)
    else:
        w = max(len(comp.ref or "XX99"), len(comp.pd.value)) * 1.35 + 4.0
        xs.append(max(xs) + w)
    return min(xs), min(ys), max(xs), max(ys)


def _rot_for(comp):
    """Ориентация двухвыводного элемента: питание сверху, общий провод снизу."""
    if len(comp.pd.all_pins) != 2:
        return 0
    n1, n2 = comp.conns.get("1"), comp.conns.get("2")
    pw = comp.pd and comp.conns
    gnd = "GND"
    if n1 == gnd and n2 != gnd:
        return 180
    return 0


def layout_sheet(proj, sheet, paper):
    W, H = PAPER[paper]
    x_min, x_max = FRAME_L + 6, W - FRAME_O - 6
    y_min, y_max = FRAME_O + 20, H - FRAME_O - 6
    reserved = [(FRAME_L, FRAME_O, FRAME_L + 140, FRAME_O + 16),                       # графа 26 и др.
                (W - FRAME_O - TB_W - 4, H - FRAME_O - TB_H - 12, W, H)]                # основная надпись
    if proj.reserve_bottom_left.get(sheet.sid):
        reserved.append((0, H - FRAME_O - proj.reserve_bottom_left[sheet.sid], W, H))
    # сборка блоков
    blocks = []
    for bname in sheet.blocks:
        comps = [c for c in proj.design.comps if c.block == bname and c.sheet == sheet.sid]
        items = []
        # части многочастных ИС, размещаемые на этом листе
        for c in proj.design.comps:
            if c.unit_sheets and c.block == bname:
                for u, sid in sorted(c.unit_sheets.items()):
                    if sid == sheet.sid:
                        items.append((c, u, 0))
        for c in comps:
            if c.unit_sheets:
                continue
            for u in range(1, c.pd.units + 1):
                items.append((c, u, _rot_for(c)))
        if not items:
            continue
        big = [it for it in items if it[0].pd.prefix in ("DD", "DA", "G", "X", "XS", "W") and it[0].pd.key != "Coax"]
        small = [it for it in items if it not in big]
        placed = []
        wmax = x_max - x_min
        cx, cy, rowh, bwid = 0.0, 0.0, 0.0, 0.0
        for it in big:
            g = unit_geom(proj, *it)
            w, h = g[2] - g[0], g[3] - g[1]
            if cx > 0 and cx + w > wmax:
                cy += rowh + 7.62
                cx, rowh = 0.0, 0.0
            placed.append((it, cx - g[0], cy - g[1]))
            cx += w + 7.62
            rowh = max(rowh, h)
            bwid = max(bwid, cx - 7.62)
        wlim = min(max(bwid, 90.0), wmax)
        y0 = cy + rowh + (5.08 if big else 0)
        rx, rh = 0.0, 0.0
        for it in small:
            g = unit_geom(proj, *it)
            w, h = g[2] - g[0], g[3] - g[1]
            if rx + w > wlim and rx > 0:
                y0 += rh + 5.08
                rx, rh = 0.0, 0.0
            placed.append((it, rx - g[0], y0 - g[1]))
            rx += w + 2.54
            rh = max(rh, h)
        bw = max(bwid, max((p[1] + unit_geom(proj, *p[0])[2] for p in placed), default=0))
        bh = y0 + rh
        if bw > wmax + 1:
            return None
        blocks.append((bname, placed, bw, bh))
    # укладка блоков: эвристика «вниз-влево» по углам уже размещённых блоков
    pos = []
    rects = []
    gap = 7.62

    def free(x0, y0, x1, y1):
        if x1 > x_max or y1 > y_max:
            return False
        for r in reserved + rects:
            if x0 < r[2] and x1 > r[0] and y0 < r[3] and y1 > r[1]:
                return False
        return True
    for bname, placed, bw, bh in blocks:
        cands = {(x_min, y_min)}
        for r in rects:
            cands.add((r[2] + gap - 0.01, r[1]))
            cands.add((r[0], r[3] + gap - 0.01))
            cands.add((x_min, r[3] + gap - 0.01))
        for r in reserved:
            cands.add((r[2] + gap, y_min))
            cands.add((x_min, r[3] + gap))
        best = None
        for (cx, cy) in sorted(cands, key=lambda c: (round(c[1] / 20), c[0])):
            if cx < x_min or cy < y_min:
                continue
            if free(cx, cy, cx + bw, cy + bh):
                best = (cx, cy)
                break
        if best is None:
            return None
        bx, by = best
        rects.append((bx - 0.01, by - 0.01, bx + bw + 0.01, by + bh + 0.01))
        pos.append((placed, bx, by))
    out = []
    for placed, bx, by in pos:
        for (it, ax, ay) in placed:
            out.append((it, round((bx + ax) / 1.27) * 1.27, round((by + ay) / 1.27) * 1.27))
    return out


# ------------------------------------------------------------------ запись проекта
LEGACY = {"%C0": "${COMMENT1}", "%C1": "${COMMENT2}", "%C2": "${COMMENT3}", "%C3": "${COMMENT4}",
          "%C4": "${COMMENT5}", "%C5": "${COMMENT6}", "%S": "${#}", "%N": "${##}", "%T": "${TITLE}",
          "%Y": "${COMPANY}", "%Z": "${PAPER}"}


def write_worksheet(path):
    """Рамка и основная надпись по ГОСТ 2.104 (формы 1 и 2а) на основе gost_landscape.kicad_wks из KiCad."""
    src = open(os.path.join(symlib.KICAD_TEMPLATE, "gost_landscape.kicad_wks"), encoding="utf-8").read()
    for k, v in LEGACY.items():
        src = src.replace(f'"{k}"', f'"{v}"').replace(f"{k}\"", f"{v}\"")
    src = src.replace("Формат %Z", "Формат ${PAPER}").replace("N°", "№")
    # знака № нет в штриховом шрифте KiCad — надписи с ним шрифтом osifont (в штампе 3 мм ≈ высоте
    # штриховых 2,5 мм; в боковых графах 2,5 мм, чтобы уложиться в 25 мм)
    for a, b in (("№докум.", "№ докум."), ("Взам.инв.№", "Взам. инв. №"), ("Инв.№дубл.", "Инв. № дубл."),
                 ("Инв.№подл.", "Инв. № подл.")):
        src = src.replace(f'"{a}"', f'"{b}"')
    src = re.sub(r'(\(tbtext "[^"\n]*№[^"\n]*"[^\n]*?) \(justify',
                 lambda m: m.group(1) + f' (font (face "{FONT}") (size {2.5 if "rotate" in m.group(1) else 3} '
                 f'{2.5 if "rotate" in m.group(1) else 3})) (justify', src)
    src = src.replace("(page_layout", "(kicad_wks (version 20220228) (generator mgp8_gen)", 1)
    # графа 1: наименование изделия и документа в две строки; литера; масштаб
    src = src.replace('(tbtext "${TITLE}" (name "text34:Text") (pos 85 27.5)',
                      '(tbtext "${TITLE}" (name "text34:Text") (pos 85 32)')
    extra = ('  (tbtext "${COMMENT8}" (name "doctype") (pos 85 22) (option page1only) (font (linewidth 0.3) (size 3.5 3.5))'
             ' (justify center) (maxlen 67))\n'
             '  (tbtext "${COMMENT7}" (name "lit") (pos 47.5 27.5) (option page1only) (justify center))\n'
             '  (tbtext "${COMMENT9}" (name "scale") (pos 9 27.5) (option page1only) (justify center))\n)')
    src = src.rstrip().rstrip(")") + "\n" + extra
    with open(path, "w", encoding="utf-8") as f:
        f.write(src + "\n")


def _title_block(meta, sheet_title):
    tb = ["title_block", ["title", Q(yo(meta["title"]))], ["date", Q(meta["date"])], ["rev", Q(meta.get("rev", ""))],
          ["company", Q(meta["company"])]]
    comments = [meta["designation"], meta.get("dev", ""), meta.get("chk", ""), meta.get("app", ""),
                meta.get("tch", ""), meta.get("nch", ""), meta.get("lit", ""), meta.get("doctype", ""), meta.get("scale", "")]
    for i, c in enumerate(comments, start=1):
        tb.append(["comment", i, Q(yo(c))])
    return tb


def _sch(proj, items, uuid_, paper, sheet_title, lib_keys, extra=()):
    libsyms = []
    for k in sorted(lib_keys):
        s = copy.deepcopy(P.SYMBOLS[k])
        s[1] = Q(f"mgp8:{k}")
        libsyms.append(s)
    root = ["kicad_sch", ["version", "20230121"], ["generator", "eeschema"], ["uuid", uuid_], ["paper", Q(paper)],
            _title_block(proj.meta, sheet_title), ["lib_symbols", *libsyms], *items, *extra]
    return dumps(root) + "\n"


def stacked_pins(comp):
    """Одноимённые выводы, объединённые в стопку на УГО: [(имя, [номера], цепь)]."""
    out = []
    for name, nums in comp.pd.pins.items():
        if name.startswith("#") or len(nums) < 2:
            continue
        nets = {comp.conns.get(n) for n in nums}
        if len(nets) == 1:
            out.append((name, sorted(nums, key=lambda s: (len(s), s)), nets.pop()))
    return out


def write_project(design, outdir, meta, papers=None):
    os.makedirs(outdir, exist_ok=True)
    proj = Project(design, outdir, meta=meta)
    proj.reserve_bottom_left = {}
    # предварительные обозначения для оценки размеров
    for c in design.comps:
        c.ref = c.ref or f"{c.pd.prefix}99"
    # таблицы подключения питания резервируют место внизу листа
    tables = defaultdict(list)
    for c in design.comps:
        for name, nums, net in stacked_pins(c):
            sid = design._pin_sheet(c, nums[0])
            tables[sid].append((c, name, nums, net))
    for sid, rows in tables.items():
        nlines = sum(1 + len(", ".join(r[2])) // 150 for r in rows) + 2
        proj.reserve_bottom_left[sid] = 8 + nlines * 4.2
    layouts = {}
    for sh in design.sheets:
        for paper in ([sh.paper] + [p for p in ("A3", "A2", "A1") if PAPER[p][0] > PAPER[sh.paper][0]]):
            lay = layout_sheet(proj, sh, paper)
            if lay is not None:
                layouts[sh.sid] = (paper, lay)
                break
        else:
            raise RuntimeError(f"Лист {sh.sid} не помещается даже на A1")
    # позиционные обозначения по ГОСТ 2.702: по листам, слева направо, сверху вниз
    order = {sh.sid: i for i, sh in enumerate(design.sheets)}
    first_pos = {}
    for sid, (paper, lay) in layouts.items():
        for (c, u, rot), x, y in lay:
            k = id(c)
            if k not in first_pos or u == 1:
                first_pos[k] = (order[sid], round(x / 25.4), y)
    counters = defaultdict(int)
    for c in sorted(design.comps, key=lambda c: (c.pd.prefix, first_pos.get(id(c), (99, 0, 0)))):
        counters[c.pd.prefix] += 1
        c.ref = f"{c.pd.prefix}{counters[c.pd.prefix]}"
    # запись листов
    sheet_files = []
    for page, sh in enumerate(design.sheets, start=2):
        paper, lay = layouts[sh.sid]
        so = SheetOut(proj, sh, page, paper)
        for (c, u, rot), x, y in lay:
            so.symbol(c, u, x, y, rot)
        W, H = PAPER[paper]
        # заголовок листа
        so.text(sh.title, FRAME_L + 150, FRAME_O + 8, 3.5, "left top")
        rows = tables.get(sh.sid, [])
        if rows:
            y = H - FRAME_O - proj.reserve_bottom_left[sh.sid] + 4
            so.text("Подключение одноимённых выводов питания и общего провода:", FRAME_L + 6, y, 2.5, "left top")
            y += 4.6
            for c, name, nums, net in sorted(rows, key=lambda r: (r[0].ref, r[1])):
                line = f"{c.ref}: {name} ({net}) — выв. {', '.join(nums)}"
                for k in range(0, len(line), 150):
                    so.text(line[k:k + 150], FRAME_L + 6, y, 2.0, "left top")
                    y += 4.2
        fname = f"{page:02d}_{sh.sid}.kicad_sch"
        with open(os.path.join(outdir, fname), "w", encoding="utf-8") as f:
            f.write(_sch(proj, so.items, uid("sheet", sh.sid), paper, sh.title, so.used_syms))
        sheet_files.append((sh, fname, page, paper))
    # корневой лист: технические требования и иерархические блоки
    items = []
    x0, y0 = FRAME_L + 10, FRAME_O + 30
    for k, (sh, fname, page, paper) in enumerate(sheet_files):
        col, row = k % 2, k // 2
        x, y = x0 + col * 125, y0 + row * 24
        w, h = 115, 16
        items.append(["sheet", ["at", x, y], ["size", w, h], ["fields_autoplaced"],
                      ["stroke", ["width", 0.3], ["type", "solid"]], ["fill", ["color", 0, 0, 0, 0.0]],
                      ["uuid", uid("sheet", sh.sid)],
                      ["property", Q("Sheetname"), Q(yo(f"Лист {page}. {sh.title}")), ["at", x + 1, y + 6, 0],
                       eff(2.5, "left top")],
                      ["property", Q("Sheetfile"), Q(fname), ["at", x + 1, y + h - 1, 0], eff(1.8, "left bottom")],
                      ["instances", ["project", Q(proj.name), ["path", Q(f"/{proj.root_uuid}"), ["page", Q(str(page))]]]]])
    notes = meta.get("notes", [])
    ty = FRAME_O + 30
    tx = FRAME_L + 270
    for n in notes:
        for k in range(0, len(n), 70):
            items.append(["text", Q(yo(n[k:k + 70])), ["at", tx, ty, 0], eff(2.5, "left top"),
                          ["uuid", uid("rootnote", ty)]])
            ty += 4.5
        ty += 1.5
    with open(os.path.join(outdir, f"{proj.name}.kicad_sch"), "w", encoding="utf-8") as f:
        f.write(_sch(proj, items, proj.root_uuid, "A3", "Схема", set(),
                     extra=[["sheet_instances", ["path", Q("/"), ["page", Q("1")]]]]))
    # библиотека, проект, рамка
    symlib.write_lib([_libsym(k) for k in sorted(P.SYMBOLS)], os.path.join(outdir, "mgp8.kicad_sym"))
    with open(os.path.join(outdir, "sym-lib-table"), "w") as f:
        f.write('(sym_lib_table\n  (lib (name "mgp8")(type "KiCad")(uri "${KIPRJMOD}/mgp8.kicad_sym")(options "")(descr "МГП-8"))\n)\n')
    write_worksheet(os.path.join(outdir, "eskd.kicad_wks"))
    import json
    pro = json.load(open(os.path.join(symlib.KICAD_TEMPLATE, "kicad.kicad_pro"), encoding="utf-8"))
    pro["meta"]["filename"] = f"{proj.name}.kicad_pro"
    pro["schematic"] = {"page_layout_descr_file": "eskd.kicad_wks", "subpart_id_separator": 46,
                        "subpart_first_id": 49, "drawing": {"default_text_size": 98.4, "default_line_thickness": 10.0}}
    pro["pcbnew"]["page_layout_descr_file"] = "eskd.kicad_wks"
    pro["sheets"] = [[str(uid("sheet", sh.sid)), f"Лист {page}"] for sh, _, page, _ in sheet_files]
    with open(os.path.join(outdir, f"{proj.name}.kicad_pro"), "w") as f:
        json.dump(pro, f, indent=2, ensure_ascii=False)
    return proj, layouts


def _libsym(k):
    s = copy.deepcopy(P.SYMBOLS[k])
    s[1] = Q(k)
    return s
