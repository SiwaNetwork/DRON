"""Исправление шрифта osifont для оформления документов МГП-8 по ЕСКД (ГОСТ 2.304).

В osifont-lgpl3fe.ttf (LGPL-3.0 с font exception) глифы «Э», «Ё», «ё» заменены пустыми
прямоугольниками-заглушками, символа «…» нет. Скрипт строит их составными глифами:
  «Э» (U+042D) — «э» (U+044D), масштабированный до высоты прописных;
  «Ё» (U+0401), «ё» (U+0451) — «Е»/«е» и надстрочный знак U+0308;
  «…» (U+2026) — три точки.
Результат — tools/fonts/osifont-mgp8.ttf (используется в tools/eskd_pdf.py и проекте KiCad).

  python3 tools/fix_osifont.py <путь к osifont-lgpl3fe.ttf> [выходной файл]
"""
import os
import sys

from fontTools.ttLib import TTFont
from fontTools.ttLib.tables._g_l_y_f import Glyph, GlyphComponent

HERE = os.path.dirname(os.path.abspath(__file__))


def gname(font, cp):
    return font.getBestCmap().get(cp)


def bounds(font, name):
    g = font["glyf"][name]
    g.recalcBounds(font["glyf"])
    return g.xMin, g.yMin, g.xMax, g.yMax


def composite(font, name, parts, advance):
    """parts: [(имя глифа, dx, dy, sx, sy)]"""
    g = Glyph()
    g.numberOfContours = -1
    g.components = []
    for base, dx, dy, sx, sy in parts:
        c = GlyphComponent()
        c.glyphName = base
        c.x, c.y = int(round(dx)), int(round(dy))
        c.flags = 0x0004                       # ROUND_XY_TO_GRID
        if sx != 1 or sy != 1:
            c.transform = [[sx, 0.0], [0.0, sy]]
        g.components.append(c)
    glyf = font["glyf"]
    if name not in glyf.glyphs:
        font.setGlyphOrder(font.getGlyphOrder() + [name])
    glyf[name] = g
    lsb = 0
    font["hmtx"][name] = (int(advance), lsb)
    g.recalcBounds(glyf)
    font["hmtx"][name] = (int(advance), int(g.xMin))


def set_cmap(font, cp, name):
    for t in font["cmap"].tables:
        if t.isUnicode():
            t.cmap[cp] = name


def main():
    src = sys.argv[1] if len(sys.argv) > 1 else os.path.join("/tmp", "osifont", "osifont-lgpl3fe.ttf")
    dst = sys.argv[2] if len(sys.argv) > 2 else os.path.join(HERE, "fonts", "osifont-mgp8.ttf")
    f = TTFont(src)
    hm = f["hmtx"]
    E_up, e_lo, e_rev = gname(f, 0x0415), gname(f, 0x0435), gname(f, 0x044D)
    diaer, period = gname(f, 0x0308), gname(f, 0x002E)
    # параметры подобраны по метрикам osifont (единицы шрифта, em = 2048)
    cap, xh = bounds(f, E_up)[3], bounds(f, e_lo)[3]
    # «Э»: «э», растянутый до высоты прописных (по ширине — 1,08)
    sy, sx = 1515.0 / bounds(f, e_rev)[3], 1.08
    composite(f, "uni042D.mgp8", [(e_rev, 0, 0, sx, sy)], hm[e_rev][0] * sx)
    set_cmap(f, 0x042D, "uni042D.mgp8")
    # «Ё», «ё»: буква + U+0308 (положение — по центру буквы, зазор над прописной/строчной)
    for cp, base, dy in ((0x0401, E_up, 195), (0x0451, e_lo, -261)):
        bx0, _, bx1, _ = bounds(f, base)
        dx0, _, dx1, _ = bounds(f, diaer)
        dx = round((bx0 + bx1) / 2 - (dx0 + dx1) / 2)
        composite(f, f"uni{cp:04X}.mgp8", [(base, 0, 0, 1, 1), (diaer, dx, dy, 1, 1)], hm[base][0])
        set_cmap(f, cp, f"uni{cp:04X}.mgp8")
    # «…»
    w = hm[period][0]
    composite(f, "ellipsis.mgp8", [(period, 0, 0, 1, 1), (period, w, 0, 1, 1), (period, 2 * w, 0, 1, 1)], 3 * w)
    set_cmap(f, 0x2026, "ellipsis.mgp8")
    # имя шрифта сохраняется («osifont»), чтобы ссылки в документах KiCad не менялись
    f["maxp"].recalc(f)
    f.save(dst)
    print("сохранено:", dst)


if __name__ == "__main__":
    main()
