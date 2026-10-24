"""Доразводка соединений, которые не развёл Freerouting (ПЗ 4.7.4): волновой трассировщик.

Сетка 0,05 мм на четырёх сигнальных слоях (F, In2, In5, B) и сквозные переходы; кратчайший путь —
scipy.sparse.csgraph.dijkstra в окне вокруг соединения (окно длинного соединения — на сетке 0,1 мм).
Обычные цифровые цепи идут ещё и по L4 (In3) в цифровой зоне — ниже ВЧ-полосы, не под островками
ВЧ- и тактового питания L5 и не ближе 0,5 мм к ВЧ- и тактовым линиям L3. Связность считается по
меди платы (площадки, проводники, переходы, залитые зоны): цепь, распавшаяся на куски, соединяется
по минимальному остовному дереву. Кусок, которому принадлежит зона внутреннего слоя (земля L2/L4/L7,
островок питания L5), достижим переходом в любом месте этой зоны.

Соединение, для которого свободного пути нет, прокладывается с перекладкой: путь может идти по
снимаемой меди чужих цепей (rippable) с наценкой; снятые цепи сразу переразводятся, и если
какая-то из них осталась разорванной — всё откатывается, так что число неразведённых не растёт.

Запуск (из gnss_receiver, Python KiCad):
  "/c/Program Files/KiCad/10.0/bin/python.exe" hw/gen/pcb_maze.py [проходов] </dev/null
  "/c/Program Files/KiCad/10.0/bin/python.exe" hw/gen/pcb_maze.py check </dev/null   — только связность
  "/c/Program Files/KiCad/10.0/bin/python.exe" hw/gen/pcb_maze.py clean </dev/null   — снять висящие, DRC
Вход и выход — hw/kicad/mgp8.kicad_pcb (после pcb.py finish). После каждого прохода — заливка
зон и DRC; новые проводники и переходы закреплены (pcb.py more/finish их не трогают).
"""
import fnmatch
import math
import os
import sys
import time

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import pcbnew  # noqa: E402
import shapely  # noqa: E402
from scipy.sparse import coo_matrix  # noqa: E402
from scipy.sparse.csgraph import dijkstra  # noqa: E402
from shapely.geometry import LineString, Point, Polygon, box  # noqa: E402
from shapely.ops import nearest_points, unary_union  # noqa: E402
from shapely.strtree import STRtree  # noqa: E402

import pcb  # noqa: E402
from pcb import CLASSES, KICAD, OX, OY, PATTERNS, RULES, TMP, H, MM, W, mm  # noqa: E402

P = 0.05                                    # шаг сетки, мм
P2 = 0.1                                    # грубая сетка: окно длинного соединения на P больше MAX_NODES
SAFE = 0.012                                # запас к зазорам на дискретность сетки (на шаг P)
VIA_COST = 1.0                              # цена перехода в мм пути
TOUCH = 0.003                               # медь одной цепи ближе этого — соединена
MAX_NODES = 600_000                         # узлов на слой в окне (память графа)
PEN = 1.0                                   # перекладка: цена шага 0,05 мм по чужому проводнику, мм
MAX_RIPS = 3                                # цепь, снятая столько раз, больше не снимается
RIPS = {}                                   # цепь -> сколько раз снимались её проводники
SIG = (pcbnew.F_Cu, pcbnew.In2_Cu, pcbnew.In5_Cu, pcbnew.B_Cu)
# обычные цифровые цепи — ещё и по L4 (In3, земля) в цифровой зоне: не под островками ВЧ и тактового
# питания L5 и не ближе IN3_GAP к ВЧ- и тактовым линиям In2 (L4 — их опорная земля)
SIGX = SIG + (pcbnew.In3_Cu,)
IN3_GAP = 0.5
ALLCU = list(pcbnew.LSET.AllCuMask().Seq())
VR = RULES["via"] / 2
DR = RULES["drill"] / 2


def net_class(name):
    return next((c for c, pats in PATTERNS.items() if any(fnmatch.fnmatch(name, p) for p in pats)), "Default")


def clr_of(name):
    return CLASSES[net_class(name)][1]


def layers_of(name):
    return SIGX if net_class(name) == "Default" and name not in pcb.PLANES else SIG


def signal(name):
    return net_class(name) == "Default" and name not in pcb.PLANES


def rippable(t):
    """Можно снять при перекладке: проводники и переходы обычных сигнальных цепей (и закреплённые —
    отводы BGA, проложенные этой программой) и незакреплённые проводники земли и питания
    (Freerouting). Не снимаются ВЧ и тактовые цепи, ADC_SCLK (ручная разводка с меандром),
    переходы земли и питания (ограды экранов, связь с плоскостями)."""
    name = t.GetNetname()
    if (t.GetNetCode() <= 0 or RIPS.get(name, 0) >= MAX_RIPS or net_class(name) in ("RF", "CLK")
            or name.startswith("ADC_SCLK")):
        return False
    return signal(name) or (t.GetClass() != "PCB_VIA" and not t.IsLocked())


def widths(name, victim=False):
    """Ширины проводника: класса цепи, затем уже — до минимальной (DRC проверяет только минимум).
    victim — переразводка снятой цепи питания или земли: не уже min(класса, 0,2)."""
    w = CLASSES[net_class(name)][0]
    ws = sorted({w, min(w, 0.2), RULES["track"]}, reverse=True)
    return [x for x in ws if x >= min(w, 0.2)] if victim and not signal(name) else ws


def ring(ln):
    return [(mm(ln.CPoint(i).x), mm(ln.CPoint(i).y)) for i in range(ln.PointCount())]


def polys(ps):
    return [Polygon(ring(ps.Outline(k)), [ring(ps.Hole(k, j)) for j in range(ps.HoleCount(k))]).buffer(0)
            for k in range(ps.OutlineCount())]


def pad_shape(p, L):
    ps = pcbnew.SHAPE_POLY_SET()
    p.TransformShapeToPolygon(ps, L, 0, MM(0.002), pcbnew.ERROR_INSIDE)
    return unary_union(polys(ps))


class Grid:
    """Узлы окна: x0 + p*i, y0 + p*j."""

    def __init__(self, x0, y0, x1, y1, p=P):
        self.p, self.safe = p, SAFE * p / P
        self.x0, self.y0 = math.floor(x0 / p) * p, math.floor(y0 / p) * p
        self.nx = int(round((x1 - self.x0) / p)) + 1
        self.ny = int(round((y1 - self.y0) / p)) + 1
        self.box = box(self.x0, self.y0, self.x0 + p * (self.nx - 1), self.y0 + p * (self.ny - 1))

    def raster(self, geoms, mask=None):
        """Узлы внутри любой из геометрий (проверка только в рамке каждой)."""
        m = np.zeros((self.ny, self.nx), bool) if mask is None else mask
        for g in geoms:
            if g.is_empty:
                continue
            a, b_, c, d = g.bounds
            p = self.p
            i0, i1 = max(0, math.ceil((a - self.x0) / p)), min(self.nx - 1, math.floor((c - self.x0) / p))
            j0, j1 = max(0, math.ceil((b_ - self.y0) / p)), min(self.ny - 1, math.floor((d - self.y0) / p))
            if i0 > i1 or j0 > j1:
                continue
            xs, ys = np.meshgrid(self.x0 + p * np.arange(i0, i1 + 1), self.y0 + p * np.arange(j0, j1 + 1))
            if (i1 - i0 + 1) * (j1 - j0 + 1) > 2000:
                shapely.prepare(g)
            m[j0:j1 + 1, i0:i1 + 1] |= shapely.intersects_xy(g, xs, ys)
        return m

    def xy(self, k):
        j, i = divmod(int(k), self.nx)
        return round(self.x0 + self.p * i, 4), round(self.y0 + self.p * j, 4)


class Board:
    """Медь платы: элементы (цепь, слой -> геометрия), связность по цепям, препятствия по слоям."""

    def __init__(self, b):
        self.b = b
        self.items = []                     # dict(net, name, geo={слой: геометрия}, kind)
        self.holes = []                     # (x, y, r, цепь, элемент-переход или -1)
        for fp in b.GetFootprints():
            for p in fp.Pads():
                if p.GetAttribute() in (pcbnew.PAD_ATTRIB_PTH, pcbnew.PAD_ATTRIB_NPTH):
                    c = p.GetPosition()
                    self.holes.append((mm(c.x), mm(c.y), mm(max(p.GetDrillSize().x, p.GetDrillSize().y)) / 2,
                                       p.GetNetCode(), -1))
                geo = {L: pad_shape(p, L) for L in ALLCU if p.IsOnLayer(L)}
                geo = {L: g for L, g in geo.items() if not g.is_empty}
                if geo and p.GetAttribute() != pcbnew.PAD_ATTRIB_NPTH:
                    kind = "smd" if p.GetAttribute() == pcbnew.PAD_ATTRIB_SMD else "th"
                    self.items.append(dict(net=p.GetNetCode(), name=p.GetNetname(), geo=geo, kind=kind))
        for t in b.GetTracks():
            g = pcb.track_geom(t)
            if t.GetClass() == "PCB_VIA":
                c = t.GetPosition()
                self.holes.append((mm(c.x), mm(c.y), mm(t.GetDrillValue()) / 2, t.GetNetCode(), len(self.items)))
                self.items.append(dict(net=t.GetNetCode(), name=t.GetNetname(), geo={L: g for L in ALLCU},
                                       kind="via", soft=rippable(t), obj=t))
            else:
                self.items.append(dict(net=t.GetNetCode(), name=t.GetNetname(), geo={t.GetLayer(): g},
                                       kind="track", soft=rippable(t), obj=t))
        for z in b.Zones():
            if z.GetIsRuleArea():
                continue
            for L in z.GetLayerSet().Seq():
                for g in polys(z.GetFilledPolysList(L)):
                    if not g.is_empty:
                        self.items.append(dict(net=z.GetNetCode(), name=z.GetNetname(), geo={L: g}, kind="zone"))
        # запреты: переходы (любой слой) и проводники (по слоям)
        ko = pcb.keepout_shapes(b)
        fv, ft = list(ko), {L: list(ko) for L in SIGX}
        for z in list(b.Zones()) + [z for fp in b.GetFootprints() for z in fp.Zones()]:
            if z.GetIsRuleArea():
                g = unary_union(polys(z.Outline()))
                if z.GetDoNotAllowVias():
                    fv.append(g)
                if z.GetDoNotAllowTracks():
                    for L in z.GetLayerSet().Seq():
                        if L in ft:
                            ft[L].append(g)
        pz = [z for z in b.Zones() if not z.GetIsRuleArea() and z.GetLayer() == pcbnew.In4_Cu
              and fnmatch.fnmatch(z.GetNetname(), "+3V3_[RC]*")]
        isl = [unary_union(polys(z.Outline())) for z in pz]
        y_rf = max(g.bounds[3] for g, z in zip(isl, pz) if "RF" in z.GetNetname())
        ft[pcbnew.In3_Cu] += [box(OX, OY, OX + W, y_rf + IN3_GAP)] + [g.buffer(IN3_GAP) for g in isl]
        ft[pcbnew.In3_Cu] += [pcb.track_geom(t).buffer(IN3_GAP) for t in b.GetTracks()
                              if t.GetClass() != "PCB_VIA" and t.GetLayer() == pcbnew.In2_Cu
                              and net_class(t.GetNetname()) in ("RF", "CLK")]
        self.forbid_v = unary_union(fv)
        self.forbid_t = {L: unary_union(g) for L, g in ft.items()}
        self.y_rf = y_rf
        # деревья поиска по исходным элементам; добавленные — в extra
        self.trees, self.extra = {}, {L: [] for L in ALLCU}
        by_layer = {}
        for i, it in enumerate(self.items):
            for L in it["geo"]:
                by_layer.setdefault(L, []).append(i)
        for L, idx in by_layer.items():
            self.trees[L] = (STRtree([self.items[i]["geo"][L] for i in idx]), np.array(idx))
        self.hole_tree, self.hole_extra = STRtree([Point(h[0], h[1]) for h in self.holes]), []
        self.dirty = set()                 # цепи со снятой медью: связность считается заново (comps)
        self.net_items = {}
        for i, it in enumerate(self.items):
            self.net_items.setdefault(it["net"], []).append(i)
        # связность: элементы одной цепи, касающиеся на одном слое
        self.par = list(range(len(self.items)))
        for L, (tree, idx) in self.trees.items():
            geoms = [self.items[i]["geo"][L] for i in idx]
            a, c = tree.query(geoms, predicate="dwithin", distance=TOUCH)
            for i, j in zip(idx[a], idx[c]):
                if i < j and self.items[i]["net"] == self.items[j]["net"] > 0:
                    self.union(i, j)

    def find(self, i):
        par = self.par
        while par[i] != i:
            par[i] = par[par[i]]
            i = par[i]
        return i

    def union(self, i, j):
        ri, rj = self.find(i), self.find(j)
        if ri != rj:
            self.par[ri] = rj

    def near(self, L, g):
        """Номера элементов, чья медь на слое L может касаться области g (по рамкам)."""
        tree, idx = self.trees.get(L, (None, None))
        out = list(idx[tree.query(g)]) if tree is not None else []
        if self.extra[L]:
            gb = g.envelope
            out += [i for i in self.extra[L] if self.items[i]["geo"][L].envelope.intersects(gb)]
        return [i for i in out if not self.items[i].get("dead")]

    def near_holes(self, g):
        """Отверстия у области g (кроме отверстий снятых переходов): (x, y, r, цепь, элемент)."""
        out = [self.holes[k] for k in self.hole_tree.query(g)]
        gb = g.envelope
        out += [self.holes[k] for k in self.hole_extra if Point(self.holes[k][:2]).buffer(1).intersects(gb)]
        return [h for h in out if h[4] < 0 or not self.items[h[4]].get("dead")]

    def soft_other(self, k, net):
        """Элемент k — снимаемый и чужой цепи."""
        return k >= 0 and self.items[k].get("soft", False) and self.items[k]["net"] != net

    def add(self, it, hole=None):
        i = len(self.items)
        self.items.append(it)
        self.par.append(i)
        self.net_items.setdefault(it["net"], []).append(i)
        for L, g in it["geo"].items():
            for j in self.near(L, g.buffer(TOUCH)):
                if self.items[j]["net"] == it["net"] and g.dwithin(self.items[j]["geo"][L], TOUCH):
                    self.union(i, j)
            self.extra[L].append(i)
        if hole:
            self.hole_extra.append(len(self.holes))
            self.holes.append(hole + (i,))

    def clusters(self, net):
        """Куски цепи (списки элементов), в которых есть что-то кроме заливки, по убыванию размера."""
        by = {}
        for i in self.net_items.get(net, []):
            by.setdefault(self.find(i), []).append(i)
        cl = [c for c in by.values() if any(self.items[i]["kind"] != "zone" for i in c)]
        return sorted(cl, key=len, reverse=True)

    def all_clusters(self):
        return {net: cl for net in self.net_items if net > 0 for cl in [self.clusters(net)] if len(cl) > 1}

    def geoms(self, cl):
        return [g for i in cl for g in self.items[i]["geo"].values()]

    def gap(self, A, B):
        """Расстояние в плане между кусками и ближайшие точки."""
        ga, gb = self.geoms(A), self.geoms(B)
        swap = len(ga) > len(gb)
        if swap:
            ga, gb = gb, ga
        tree = STRtree(gb)
        best = None
        for g in ga:
            k = tree.query_nearest(g)[0]
            d = g.distance(gb[k])
            if best is None or d < best[0]:
                best = (d, g, gb[k])
        d, g, h = best
        pa, pb = nearest_points(g, h)
        return (d, pb, pa) if swap else (d, pa, pb)

    # --- маски окна --------------------------------------------------------------------------
    def blocked(self, L, G, net, name, r, via=False, soft=False):
        """Узлы, где ось проводника полушириной r (или переход радиуса r) ближе допустимого к меди
        других цепей на слое L, к отверстиям других цепей или к запретам. soft — отдельно маска
        снимаемых проводников: (жёсткие, снимаемые)."""
        my = clr_of(name)
        win = G.box.buffer(1.0)
        gs, ds, ss = [], [], []
        for i in self.near(L, win):
            it = self.items[i]
            if it["kind"] == "zone" or (it["net"] == net and net > 0):
                continue
            gs.append(it["geo"][L])
            ds.append(max(my, clr_of(it["name"])) + r + G.safe)
            ss.append(soft and it.get("soft", False))
        for x, y, hr, hn, k in self.near_holes(win):
            if hn != net or net <= 0:
                gs.append(Point(x, y))
                ds.append(hr + RULES["hole_clr"] + r + G.safe)
                ss.append(soft and self.soft_other(k, net))
        grown = list(shapely.buffer(np.array(gs, dtype=object), np.array(ds), quad_segs=6)) if gs else []
        m = G.raster([g for g, s in zip(grown, ss) if not s])
        keep = (self.forbid_v if via else self.forbid_t[L]).intersection(G.box.buffer(r + 1))
        G.raster([keep.buffer(r + G.safe, 6)], m)
        return (m, G.raster([g for g, s in zip(grown, ss) if s])) if soft else m

    def victims(self, L, g, net, name):
        """Снимаемые проводники на слое L ближе допустимого к меди g цепи net."""
        return [i for i in self.near(L, g.buffer(0.5)) if self.items[i].get("soft") and self.items[i]["net"] != net
                and g.distance(self.items[i]["geo"][L]) < max(clr_of(name), clr_of(self.items[i]["name"])) + 0.005]

    def via_ok(self, G, net, name, soft=False):
        m = np.zeros((G.ny, G.nx), bool)
        sm = np.zeros((G.ny, G.nx), bool)
        for L in SIGX:
            if soft:
                h, s = self.blocked(L, G, net, name, VR, via=True, soft=True)
                m |= h
                sm |= s
            else:
                m |= self.blocked(L, G, net, name, VR, via=True)
        win = G.box.buffer(1.0)
        # медь внутренних слоёв кроме заливок (выводы, переходы других цепей)
        gs = []
        for L in ALLCU:
            if L in SIGX:
                continue
            gs += [(self.items[i]["geo"][L].buffer(VR + RULES["clearance"] + G.safe, 6), soft and self.soft_other(i, net))
                   for i in self.near(L, win) if self.items[i]["kind"] != "zone" and self.items[i]["net"] != net]
        # отверстие к отверстию — для всех цепей (своей — тоже)
        gs += [(Point(x, y).buffer(hr + DR + RULES["hole_hole"] + G.safe, 12), soft and self.soft_other(k, net))
               for x, y, hr, _, k in self.near_holes(win)]
        G.raster([g for g, s in gs if not s], m)
        G.raster([g for g, s in gs if s], sm)
        # не в площадках поверхностного монтажа (и своей цепи) — пайка
        for L in (pcbnew.F_Cu, pcbnew.B_Cu):
            G.raster([self.items[i]["geo"][L].buffer(VR + G.safe, 6) for i in self.near(L, win)
                      if self.items[i]["kind"] == "smd"], m)
        return (~m, sm & ~m) if soft else ~m


def route(B, net, name, src, dst, w, margin, log, dbg=None, rip=False):
    """Путь от куска src к куску dst (списки номеров элементов) проводником ширины w в окне
    вокруг ближайших точек кусков с полем margin. rip — можно идти по снимаемым проводникам
    других цепей с наценкой PEN. Возвращает (длина, проводники, переходы, снимаемые) или None."""
    d, pa, pb = B.gap(src, dst)
    x0, x1 = max(OX, min(pa.x, pb.x) - margin), min(OX + W, max(pa.x, pb.x) + margin)
    y0, y1 = max(OY, min(pa.y, pb.y) - margin), min(OY + H, max(pa.y, pb.y) + margin)
    for p in (P, P2):
        G = Grid(x0, y0, x1, y1, p)
        nn = G.nx * G.ny
        if nn <= MAX_NODES:
            break
    else:
        return None
    lay = layers_of(name)
    nl = len(lay)
    if rip:
        hs = [B.blocked(L, G, net, name, w / 2, soft=True) for L in lay]
        free = [~h for h, _ in hs]
        pen = [(s & ~h).ravel().astype(float) * PEN * G.p / P for h, s in hs]
        vok, vsoft = B.via_ok(G, net, name, soft=True)
    else:
        free = [~B.blocked(L, G, net, name, w / 2) for L in lay]
        pen = [np.zeros(nn)] * nl
        vok, vsoft = B.via_ok(G, net, name), np.zeros((G.ny, G.nx), bool)

    def ends(cl):
        """Узлы присоединения: в меди куска на сигнальном слое (прямо) и переходом в заливке
        внутреннего слоя."""
        direct = []
        for li, L in enumerate(lay):
            gs = [B.items[i]["geo"][L] for i in cl if L in B.items[i]["geo"]]
            gs = [g.intersection(G.box.buffer(0.1)).buffer(-0.01) for g in gs if g.intersects(G.box)]
            if gs:
                direct.append(np.flatnonzero(G.raster(gs) & free[li]) + li * nn)
        gs = [g.intersection(G.box.buffer(1)).buffer(-(VR + 0.05)) for i in cl if B.items[i]["kind"] == "zone"
              for L, g in B.items[i]["geo"].items() if L not in lay and g.intersects(G.box)]
        via = np.flatnonzero(G.raster(gs) & vok) if gs else np.zeros(0, int)
        return (np.concatenate(direct) if direct else np.zeros(0, int)), via

    sd, sv = ends(src)
    td, tv = ends(dst)
    if not (len(sd) or len(sv)) or not (len(td) or len(tv)):
        log(f"    нет точек присоединения (исток {len(sd)}/{len(sv)}, сток {len(td)}/{len(tv)})")
        return None
    S, T = nl * nn, nl * nn + 1
    rows, cols, wts = [], [], []
    idx = np.arange(nn, dtype=np.int64).reshape(G.ny, G.nx)
    ny, nx = G.ny, G.nx
    for li in range(nl):
        f = free[li]
        for dy, dx, c in ((0, 1, G.p), (1, 0, G.p), (1, 1, G.p * math.sqrt(2)), (1, -1, G.p * math.sqrt(2))):
            c0, c1 = max(0, -dx), nx - max(0, dx)
            ok = f[:ny - dy, c0:c1] & f[dy:, c0 + dx:c1 + dx]
            u = idx[:ny - dy, c0:c1][ok]
            v = idx[dy:, c0 + dx:c1 + dx][ok]
            wt = c + (pen[li][u] + pen[li][v]) / 2
            rows += [u + li * nn, v + li * nn]
            cols += [v + li * nn, u + li * nn]
            wts += [wt, wt]
    vv = np.flatnonzero(vok)
    vw = VIA_COST + vsoft.ravel()[vv] * PEN * 8
    for la in range(nl):
        for lb in range(nl):
            if la != lb:
                rows.append(vv + la * nn)
                cols.append(vv + lb * nn)
                wts.append(vw)
    # исток и сток: прямые узлы дешевле переходных (без дублей рёбер — coo суммирует дубли)
    s_w, t_w = {}, {}
    for e, (dv, vv_) in ((s_w, (sd, sv)), (t_w, (td, tv))):
        for v in vv_:
            for li in range(nl):
                e[int(v) + li * nn] = VIA_COST
        for v in dv:
            e[int(v)] = 0.0
    eps = 1e-6                             # нулевые веса csgraph считает отсутствием ребра
    rows.append(np.full(len(s_w), S))
    cols.append(np.fromiter(s_w.keys(), np.int64, len(s_w)))
    wts.append(np.fromiter(s_w.values(), float, len(s_w)) + eps)
    rows.append(np.fromiter(t_w.keys(), np.int64, len(t_w)))
    cols.append(np.full(len(t_w), T))
    wts.append(np.fromiter(t_w.values(), float, len(t_w)) + eps)
    Gm = coo_matrix((np.concatenate(wts), (np.concatenate(rows), np.concatenate(cols))),
                    shape=(nl * nn + 2,) * 2).tocsr()
    dist, pred = dijkstra(Gm, directed=True, indices=S, return_predecessors=True)
    if not np.isfinite(dist[T]):
        if dbg:
            dbg(G, free, vok, (sd, sv), (td, tv), dist[:nl * nn])
        return None
    path = []
    v = pred[T]
    while v != S:
        path.append(int(v))
        v = pred[v]
    path.reverse()
    pts = [(v // nn, v % nn) for v in path]                # (слой, узел)
    vias = []
    if s_w[path[0]] > 0:
        vias.append(G.xy(pts[0][1]))
    if t_w[path[-1]] > 0:
        vias.append(G.xy(pts[-1][1]))
    runs, run = [], [pts[0]]
    for p in pts[1:]:
        if p[0] != run[-1][0]:
            vias.append(G.xy(p[1]))
            runs.append(run)
            run = [p]
        else:
            run.append(p)
    runs.append(run)
    lines = []
    for run in runs:
        if len(run) < 2:
            continue
        # прямые участки: точки смены направления
        ij = [divmod(k, nx) for _, k in run]
        keep = [0]
        for k in range(1, len(ij) - 1):
            if (ij[k][0] - ij[k - 1][0], ij[k][1] - ij[k - 1][1]) != (ij[k + 1][0] - ij[k][0], ij[k + 1][1] - ij[k][1]):
                keep.append(k)
        keep.append(len(ij) - 1)
        for a, c in zip(keep, keep[1:]):
            lines.append((lay[run[0][0]], G.xy(run[a][1]), G.xy(run[c][1])))
    vias = list(dict.fromkeys(vias))
    rip_out = set()
    if rip:
        for L, p0, p1 in lines:
            rip_out.update(B.victims(L, LineString([p0, p1]).buffer(w / 2, 4), net, name))
        for x, y in vias:
            for L in ALLCU:
                rip_out.update(B.victims(L, Point(x, y).buffer(VR, 8), net, name))
    return float(dist[T]), lines, vias, sorted(rip_out)


def drop(b, o):
    """Убрать элемент с платы. Объект остаётся во владении C++ (может вернуться на плату при откате):
    уничтожение снятого объекта сборщиком Python ломает обёртки SWIG (b.Tracks() → SwigPyObject)."""
    b.Remove(o)
    o.thisown = 0


def commit(B, net, name, w, lines, vias, rip_out=()):
    b = B.b
    for i in rip_out:
        it = B.items[i]
        drop(b, it["obj"])
        it["dead"] = True
        RIPS[it["name"]] = RIPS.get(it["name"], 0) + 1
        B.dirty.add(it["net"])
    for L, (x0, y0), (x1, y1) in lines:
        t = pcbnew.PCB_TRACK(b)
        t.SetStart(pcbnew.VECTOR2I(MM(x0), MM(y0)))
        t.SetEnd(pcbnew.VECTOR2I(MM(x1), MM(y1)))
        t.SetLayer(L)
        t.SetWidth(MM(w))
        t.SetNetCode(net)
        t.SetLocked(True)
        b.Add(t)
        B.add(dict(net=net, name=name, geo={L: LineString([(x0, y0), (x1, y1)]).buffer(w / 2, 4)}, kind="track",
                   obj=t))
    for x, y in vias:
        v = pcbnew.PCB_VIA(b)
        v.SetPosition(pcbnew.VECTOR2I(MM(x), MM(y)))
        v.SetWidth(MM(RULES["via"]))
        v.SetDrill(MM(RULES["drill"]))
        v.SetNetCode(net)
        v.SetLocked(True)
        b.Add(v)
        g = Point(x, y).buffer(VR, 8)
        B.add(dict(net=net, name=name, geo={L: g for L in ALLCU}, kind="via", obj=v), hole=(x, y, DR, net))


def mst(B, cl):
    """Рёбра минимального остовного дерева кусков цепи (по расстоянию в плане): (d, i, j)."""
    n = len(cl)
    edges = sorted((B.gap(cl[i], cl[j])[0], i, j) for i in range(n) for j in range(i + 1, n))
    par = list(range(n))

    def root(i):
        while par[i] != i:
            i = par[i]
        return i
    out = []
    for d, i, j in edges:
        if root(i) != root(j):
            par[root(i)] = root(j)
            out.append((d, i, j))
    return out


def comps(B, net):
    """Куски цепи по живой меди: {элемент: корень}. Для цепей со снятой медью — заново по геометрии."""
    ids = [i for i in B.net_items.get(net, []) if not B.items[i].get("dead")]
    if net not in B.dirty:
        return {i: B.find(i) for i in ids}
    par = {i: i for i in ids}

    def f(i):
        while par[i] != i:
            par[i] = par[par[i]]
            i = par[i]
        return i
    by = {}
    for i in ids:
        for L in B.items[i]["geo"]:
            by.setdefault(L, []).append(i)
    for L, li in by.items():
        gs = [B.items[i]["geo"][L] for i in li]
        x, y = STRtree(gs).query(gs, predicate="dwithin", distance=TOUCH)
        for p, q in zip(x, y):
            rp, rq = f(li[p]), f(li[q])
            if rp != rq:
                par[rp] = rq
    return {i: f(i) for i in ids}


def pieces(B, net):
    """Куски цепи с площадкой или заливкой (висящие обрезки проводников не в счёт)."""
    by = {}
    for i, r in comps(B, net).items():
        by.setdefault(r, []).append(i)
    return [c for c in by.values() if any(B.items[i]["kind"] in ("smd", "th", "zone") for i in c)
            and any(B.items[i]["kind"] != "zone" for i in c)]


def connect(B, net, name, ia, ib, tries, log, rip=False, victim=False):
    """Соединить куски цепи с элементами ia и ib: (ширина, поле, результат route), None — пути нет,
    True — уже соединены."""
    cm = comps(B, net)
    if ia not in cm or ib not in cm:
        return None
    if cm[ia] == cm[ib]:
        return True
    a = [i for i in cm if cm[i] == cm[ia]]
    c = [i for i in cm if cm[i] == cm[ib]]
    for margin, wr in tries:
        for w in ([wr] if wr else widths(name, victim)):
            r = route(B, net, name, a, c, w, margin, log, rip=rip)
            if r:
                return w, margin, r
    return None


FREE = [(m, None) for m in (1.5, 4.0, 10.0)]


def undo(B, snap, rip_out):
    """Откат перекладки: снять добавленное после снимка, вернуть снятые проводники."""
    par, n_items, n_holes, rips = snap
    for i in range(n_items, len(B.items)):
        it = B.items[i]
        if not it.get("dead"):
            it["dead"] = True
            drop(B.b, it["obj"])
    for i in rip_out:
        B.items[i]["dead"] = False
        B.b.Add(B.items[i]["obj"])
    B.par = par + list(range(n_items, len(B.items)))
    RIPS.clear()
    RIPS.update(rips)


def transact(B, net, name, ia, ib, log):
    """Соединение с перекладкой: снятые проводники чужих цепей сразу переразводятся без перекладки;
    если у какой-то из них кусков стало больше, чем было, всё откатывается."""
    for margin in (4.0, 10.0):
        snap = (list(B.par), len(B.items), len(B.holes), dict(RIPS))
        r = connect(B, net, name, ia, ib, [(margin, RULES["track"])], log, rip=True)
        if r is True:
            return True
        if r is None:
            continue
        w, _, (length, lines, vias, rip_out) = r
        vnets = {B.items[i]["net"]: B.items[i]["name"] for i in rip_out}
        before = {x: len(pieces(B, x)) for x in vnets}
        commit(B, net, name, w, lines, vias, rip_out)
        ok = True
        for x, xname in vnets.items():
            pcs = pieces(B, x)
            for _, i, j in mst(B, pcs):
                rr = connect(B, x, xname, pcs[i][0], pcs[j][0], FREE, log, victim=True)
                if rr and rr is not True:
                    commit(B, x, xname, rr[0], rr[2][1], rr[2][2])
            if len(pieces(B, x)) > before[x]:
                ok = False
                break
        if ok:
            return length, lines, vias, rip_out, vnets
        undo(B, snap, rip_out)
        log(f"    откат (поле {margin}): не переразводится {xname}")
    return None


def one_pass(B, log):
    cls = B.all_clusters()
    todo = []
    for net, cl in cls.items():
        for d, i, j in mst(B, cl):
            # представители кусков (площадка, если есть): по ним берутся текущие куски
            rep = [next((k for k in cl[x] if B.items[k]["kind"] in ("smd", "th", "zone")), cl[x][0]) for x in (i, j)]
            todo.append((d, net, B.items[cl[i][0]]["name"], rep[0], rep[1]))
    todo.sort(key=lambda t: t[0])
    log(f"соединений по связности меди: {len(todo)} (цепей {len(cls)})")
    done, failed = 0, []
    for d, net, name, ia, ib in todo:
        t0 = time.time()
        r = connect(B, net, name, ia, ib, FREE, log)
        if r is True:
            done += 1
        elif r:
            w, margin, (length, lines, vias, _) = r
            commit(B, net, name, w, lines, vias)
            done += 1
            log(f"+ {name}: зазор {d:.2f} мм, путь {length:.2f}, ширина {w}, поле {margin}, "
                f"отрезков {len(lines)}, переходов {len(vias)} ({time.time() - t0:.1f} с)")
        else:
            failed.append((d, net, name, ia, ib))
    log(f"с перекладкой: {len(failed)}")
    left = []
    for d, net, name, ia, ib in failed:
        t0 = time.time()
        r = transact(B, net, name, ia, ib, log)
        if r is True:
            done += 1
        elif r:
            length, lines, vias, rip_out, vnets = r
            done += 1
            log(f"+ {name}: зазор {d:.2f} мм, путь {length:.2f}, отрезков {len(lines)}, переходов {len(vias)}, "
                f"снято {len(rip_out)} и переразведено ({', '.join(sorted(vnets.values()))}) "
                f"({time.time() - t0:.1f} с)")
        else:
            left.append((name, d))
            log(f"- {name}: зазор {d:.2f} мм — пути нет ({time.time() - t0:.1f} с)")
    return done, len(todo), left


def prune(b, log):
    """Снять обрезки: группы проводников и переходов цепи, не касающиеся площадок и заливок."""
    B = Board(b)
    out = []
    for net, cl in B.all_clusters().items():
        for c in cl:
            if all(B.items[i]["kind"] in ("track", "via") for i in c):
                out += [B.items[i]["obj"] for i in c]
    for o in out:
        drop(b, o)
    if out:
        log(f"сняты обрезки: {len(out)} проводников и переходов")
    return B if not out else Board(b)


def clean(b, out_pcb, log):
    """Снять висящие переходы и отрезки (остатки перекладки, отводы BGA к выводам, разведённым без
    них) по отчёту DRC — и закреплённые тоже, кроме ВЧ-цепей; затем счётчики для ПЗ (pcb.report).
    Отрезок с висящим концом, к середине которого примкнул проводник доразводки, несёт соединение:
    снимается только то, без чего цепь не распадается на большее число кусков. KiCad соединяет
    проводники только концами, а модель — любым касанием: если по DRC у цепи прибавился разрыв,
    снятое в ней возвращается."""
    rep = os.path.join(TMP, "drc_maze.json")
    pcbnew.ZONE_FILLER(b).Fill(b.Zones())
    B = Board(b)
    uid = {it["obj"].m_Uuid.AsString(): i for i, it in enumerate(B.items) if "obj" in it}
    kept, removed, base = set(), {}, None

    def unc_nets(d):
        out = {}
        for u in d.get("unconnected_items", []):
            n = u["items"][0]["description"].split("[")[1].split("]")[0]
            out[n] = out.get(n, 0) + 1
        return out
    for _ in range(40):
        pcbnew.ZONE_FILLER(b).Fill(b.Zones())
        pcb.save_out(b, out_pcb)
        if os.path.exists(rep):
            os.remove(rep)
        d, cnt = pcb.drc(out_pcb, rep)
        un = unc_nets(d)
        base = un if base is None else base
        back = [i for n, k in un.items() if k > base.get(n, 0) for i in removed.pop(n, [])]
        if back:
            for i in back:
                B.items[i]["dead"] = False
                b.Add(B.items[i]["obj"])
                kept.add(B.items[i]["obj"].m_Uuid.AsString())
            log(f"возвращено (KiCad не видит соединения без них): {len(back)}")
            continue
        dang = {i["uuid"] for v in d["violations"] if v["type"] in ("via_dangling", "track_dangling")
                for i in v["items"]}
        rm = []
        for u in sorted(dang - kept):
            i = uid.get(u)
            if i is None or B.items[i].get("dead") or net_class(B.items[i]["name"]) == "RF":
                continue
            net = B.items[i]["net"]
            n0 = len(pieces(B, net))
            B.items[i]["dead"] = True
            B.dirty.add(net)
            if len(pieces(B, net)) > n0:
                B.items[i]["dead"] = False
                kept.add(u)
            else:
                rm.append(B.items[i]["obj"])
                removed.setdefault(B.items[i]["name"], []).append(i)
        if not rm:
            break
        for t in rm:
            drop(b, t)
        log(f"удалено висящих: {len(rm)}, оставлено несущих соединение: {len(kept)}")
    for (sev, typ), k in sorted(cnt.items()):
        log(f"DRC {sev:8s} {typ:28s} {k}")
    log(f"DRC неразведённых: {len(d.get('unconnected_items', []))}")
    pcb.report(pcbnew.LoadBoard(out_pcb))


def main():
    out_pcb = os.path.join(KICAD, "mgp8.kicad_pcb")
    logf = open(os.path.join(TMP, "maze.log"), "a", encoding="utf-8")

    def log(s):
        print(s, flush=True)
        logf.write(s + "\n")
        logf.flush()
    b = pcbnew.LoadBoard(out_pcb)
    arg = sys.argv[1] if len(sys.argv) > 1 else "3"
    if arg == "clean":
        clean(b, out_pcb, log)
        return
    hist = []
    for it in range(1 if arg == "check" else int(arg)):
        pcbnew.ZONE_FILLER(b).Fill(b.Zones())
        t0 = time.time()
        B = prune(b, log)
        cls = B.all_clusters()
        log(f"модель: элементов {len(B.items)}, цепей с разрывами {len(cls)}, "
            f"соединений {sum(len(c) - 1 for c in cls.values())} ({time.time() - t0:.0f} с)")
        if arg == "check":
            for net, cl in sorted(cls.items(), key=lambda kv: B.items[kv[1][0][0]]["name"]):
                log(f"  {B.items[cl[0][0]]['name']}: {len(cl)} кусков, размеры {[len(c) for c in cl]}")
            return
        done, n, failed = one_pass(B, log)
        pcbnew.ZONE_FILLER(b).Fill(b.Zones())
        pcb.save_out(b, out_pcb)
        rep = os.path.join(TMP, "drc_maze.json")
        if os.path.exists(rep):
            os.remove(rep)                  # иначе при сбое kicad-cli читался бы прошлый отчёт
        d, cnt = pcb.drc(out_pcb, rep)
        for (sev, typ), k in sorted(cnt.items()):
            log(f"DRC {sev:8s} {typ:28s} {k}")
        unc = len(d.get("unconnected_items", []))
        log(f"проход {it + 1}: проложено {done}, не проложено {len(failed)}; DRC неразведённых: {unc}")
        hist.append(unc)
        if not done or not unc or any(s == "error" for s, _ in cnt) or (len(hist) > 1 and unc >= hist[-2]):
            break


if __name__ == "__main__":
    main()
