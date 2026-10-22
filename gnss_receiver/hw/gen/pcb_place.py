"""Геометрия платы и размещение компонентов для hw/gen/pcb.py (модуль pcbnew KiCad).

Координаты — в миллиметрах относительно левого верхнего угла контура платы (ось y — вниз).
Занятость поверхности ведётся по сетке 0,1 мм отдельно для верхней (F) и нижней (B) стороны
по контурам занимаемого места (courtyard) с зазором; сквозные отверстия занимают обе стороны.
Пассивные компоненты размещаются жадно: ближайшая к целевой точке свободная позиция в разрешённой
области, ориентация — та, при которой сигнальная площадка ближе к выводу микросхемы.
"""
import math
import os

import numpy as np
import pcbnew

MM = pcbnew.FromMM


def mm(v):
    return pcbnew.ToMM(v)


class Placer:
    RES = 0.1        # шаг сетки занятости, мм
    GAP = 0.1        # зазор между контурами занимаемого места, мм
    EDGE = 0.5       # отступ компонентов от края платы, мм

    def __init__(self, board, ox, oy, w, h, libs):
        self.b, self.ox, self.oy, self.w, self.h, self.libs = board, ox, oy, w, h, libs
        ny, nx = int(round(h / self.RES)), int(round(w / self.RES))
        self.occ = {"F": np.zeros((ny, nx), bool), "B": np.zeros((ny, nx), bool)}
        self.fps = {}
        self.where = {}          # ref -> (x, y, rot, side)
        self._geo = {}
        self._disk = {}

    # --- координаты -------------------------------------------------------------------------
    def V(self, x, y):
        return pcbnew.VECTOR2I(MM(self.ox + x), MM(self.oy + y))

    def loc(self, v):
        return (mm(v.x) - self.ox, mm(v.y) - self.oy)

    def load(self, fpid):
        lib, name = fpid.split(":", 1)
        fp = pcbnew.FootprintLoad(self.libs[lib], name)
        if fp is None:
            raise FileNotFoundError(fpid)
        fp.SetFPID(pcbnew.LIB_ID(lib, name))
        return fp

    # --- геометрия посадочного места в заданной ориентации ----------------------------------
    def geo(self, fpid, rot, side):
        key = (fpid, rot % 360, side)
        if key in self._geo:
            return self._geo[key]
        if side == "B":
            # Flip вне платы недоступен: нижняя сторона — зеркало верхней относительно оси y
            g = self.geo(fpid, rot, "F")
            x0, y0, x1, y1 = g["box"]
            m = {"box": (-x1, y0, -x0, y1),
                 "pads": {k: [(-x, y) for x, y in v] for k, v in g["pads"].items()},
                 "th": [(-b, a2, -a, b2) for a, a2, b, b2 in g["th"]]}
            self._geo[key] = m
            return m
        f = self.load(fpid)
        f.SetPosition(pcbnew.VECTOR2I(0, 0))
        f.SetOrientationDegrees(rot)
        f.BuildCourtyardCaches()
        cy = f.GetCourtyard(pcbnew.F_CrtYd)
        bb = cy.BBox() if cy.OutlineCount() else f.GetBoundingBox(False)
        box = (mm(bb.GetX()), mm(bb.GetY()), mm(bb.GetRight()), mm(bb.GetBottom()))
        pads, th = {}, []
        for p in f.Pads():
            pos = p.GetPosition()
            pads.setdefault(p.GetNumber(), []).append((mm(pos.x), mm(pos.y)))
            if p.GetAttribute() in (pcbnew.PAD_ATTRIB_PTH, pcbnew.PAD_ATTRIB_NPTH):
                pb = p.GetBoundingBox()
                th.append((mm(pb.GetX()), mm(pb.GetY()), mm(pb.GetRight()), mm(pb.GetBottom())))
        g = {"box": box, "pads": pads, "th": th}
        self._geo[key] = g
        return g

    # --- сетка занятости ---------------------------------------------------------------------
    def _idx(self, x0, y0, x1, y1):
        r = self.RES
        return (max(0, int(math.floor(y0 / r))), min(self.occ["F"].shape[0], int(math.ceil(y1 / r))),
                max(0, int(math.floor(x0 / r))), min(self.occ["F"].shape[1], int(math.ceil(x1 / r))))

    def block(self, x0, y0, x1, y1, sides=("F", "B")):
        i0, i1, j0, j1 = self._idx(x0, y0, x1, y1)
        for s in sides:
            self.occ[s][i0:i1, j0:j1] = True

    def free(self, x0, y0, x1, y1, side):
        if x0 < self.EDGE or y0 < self.EDGE or x1 > self.w - self.EDGE or y1 > self.h - self.EDGE:
            return False
        i0, i1, j0, j1 = self._idx(x0, y0, x1, y1)
        return not self.occ[side][i0:i1, j0:j1].any()

    def fits(self, fpid, x, y, rot, side, region=None):
        i, j = int(y / self.RES), int(x / self.RES)
        if 0 <= i < self.occ[side].shape[0] and 0 <= j < self.occ[side].shape[1] and self.occ[side][i, j]:
            return False
        g = self.geo(fpid, rot, side)
        bx0, by0, bx1, by1 = g["box"]
        x0, y0, x1, y1 = x + bx0 - self.GAP / 2, y + by0 - self.GAP / 2, x + bx1 + self.GAP / 2, y + by1 + self.GAP / 2
        if region and not (x0 >= region[0] and y0 >= region[1] and x1 <= region[2] and y1 <= region[3]):
            return False
        if not self.free(x0, y0, x1, y1, side):
            return False
        other = "B" if side == "F" else "F"
        for tx0, ty0, tx1, ty1 in g["th"]:
            if not self.free(x + tx0, y + ty0, x + tx1, y + ty1, other):
                return False
        return True

    # --- установка ---------------------------------------------------------------------------
    def put(self, ref, x, y, rot=0, side="F", force=False):
        fp = self.fps[ref]
        fpid = fp.GetFPIDAsString()
        if not force and not self.fits(fpid, x, y, rot, side):
            raise RuntimeError(f"{ref}: место ({x:.2f}, {y:.2f}) rot={rot} {side} занято")
        fp.SetPosition(self.V(x, y))
        fp.SetOrientationDegrees(rot)
        if side == "B":
            fp.Flip(fp.GetPosition(), pcbnew.FLIP_DIRECTION_LEFT_RIGHT)
        g = self.geo(fpid, rot, side)
        bx0, by0, bx1, by1 = g["box"]
        self.block(x + bx0 - self.GAP / 2, y + by0 - self.GAP / 2, x + bx1 + self.GAP / 2, y + by1 + self.GAP / 2, (side,))
        for tx0, ty0, tx1, ty1 in g["th"]:
            self.block(x + tx0, y + ty0, x + tx1, y + ty1)
        self.where[ref] = (x, y, rot, side)

    def pads_at(self, ref, num):
        return [self.loc(p.GetPosition()) for p in self.fps[ref].Pads() if p.GetNumber() == num]

    def pad_xy(self, ref, num):
        return self.pads_at(ref, num)[0]

    def _offsets(self, rmax, step):
        key = (rmax, step)
        if key not in self._disk:
            n = int(rmax / step)
            a = np.arange(-n, n + 1) * step
            xx, yy = np.meshgrid(a, a)
            d = np.hypot(xx, yy)
            m = d <= rmax
            order = np.argsort(d[m], kind="stable")
            self._disk[key] = list(zip(xx[m][order], yy[m][order]))
        return self._disk[key]

    def auto(self, ref, target, region=None, sides=("F",), rots=(0, 90, 180, 270), pad=None, toward=None,
             rmax=14.0, step=0.2):
        """Ближайшая к target свободная позиция. pad — номер площадки, которую нужно приблизить
        к точке toward (вывод микросхемы); по ней выбирается ориентация."""
        fp = self.fps[ref]
        fpid = fp.GetFPIDAsString()
        tx, ty = target
        for dx, dy in self._offsets(rmax, step):
            x, y = round(float(tx + dx), 2), round(float(ty + dy), 2)
            best = None
            for side in sides:
                for rot in rots:
                    if not self.fits(fpid, x, y, rot, side, region):
                        continue
                    cost = 0.0
                    if pad is not None and toward is not None:
                        px, py = self.geo(fpid, rot, side)["pads"][pad][0]
                        cost = math.hypot(x + px - toward[0], y + py - toward[1])
                    cost += 0.5 if side == "B" else 0.0
                    if best is None or cost < best[0]:
                        best = (cost, rot, side)
            if best:
                self.put(ref, x, y, best[1], best[2])
                return True
        return False
