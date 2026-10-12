"""Оформление документов по ЕСКД в PDF (reportlab).

* рамка и основные надписи по ГОСТ Р 2.104-2023 (ГОСТ 2.104): форма 2 (первый лист текстового
  документа, 185×40 мм), форма 2а (последующие листы, 185×15 мм), дополнительные графы 19–25;
* перечень элементов (ГОСТ 2.701-2008), спецификация (ГОСТ 2.106-2019, форма 1),
  ведомость покупных изделий (ГОСТ 2.106-2019, форма 5);
* текстовые документы (ПЗ, ПМ, ТЗ) из упрощённого Markdown (ГОСТ 2.105-2019).
"""
import os
import re

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_JUSTIFY, TA_LEFT
from reportlab.lib.pagesizes import A3, A4, landscape
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import (BaseDocTemplate, Frame, Image, KeepTogether, PageBreak, PageTemplate,
                                Paragraph, Preformatted, Spacer, Table, TableStyle, CondPageBreak)

HERE = os.path.dirname(os.path.abspath(__file__))
FONT_FILE = os.path.join(HERE, "fonts", "osifont-mgp8.ttf")
pdfmetrics.registerFont(TTFont("GOST", FONT_FILE))
for name, path in (("Serif", "/usr/share/fonts/truetype/liberation/LiberationSerif-Regular.ttf"),
                   ("Serif-B", "/usr/share/fonts/truetype/liberation/LiberationSerif-Bold.ttf"),
                   ("Serif-I", "/usr/share/fonts/truetype/liberation/LiberationSerif-Italic.ttf"),
                   ("Mono", "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf")):
    pdfmetrics.registerFont(TTFont(name, path))
pdfmetrics.registerFontFamily("Serif", normal="Serif", bold="Serif-B", italic="Serif-I", boldItalic="Serif-B")

THICK, THIN = 0.6, 0.3   # толщина линий рамки, мм (ГОСТ 2.303: основная 0,5…1,4)


class Meta(dict):
    """designation, title (наименование изделия), doctype (наименование документа), lit, company,
    dev, chk, tch, nch, app, date."""


# ------------------------------------------------------------------ рамка
def _txt(c, s, x, y, size=2.5, align="left", font="GOST"):
    c.setFont(font, size / 0.3528 * 1.0)
    if align == "center":
        c.drawCentredString(x * mm, y * mm, s)
    elif align == "right":
        c.drawRightString(x * mm, y * mm, s)
    else:
        c.drawString(x * mm, y * mm, s)


def _fit(c, s, x, y, w, size, align="center", font="GOST"):
    while size > 1.6 and pdfmetrics.stringWidth(s, font, size / 0.3528) > (w - 1) * mm:
        size -= 0.25
    _txt(c, s, x, y, size, align, font)


def _line(c, x1, y1, x2, y2, w=THIN):
    c.setLineWidth(w * mm)
    c.line(x1 * mm, y1 * mm, x2 * mm, y2 * mm)


def draw_frame(c, pw, ph, meta, page, pages, first=True, form_first="2"):
    """Рамка листа pw×ph (мм) и основная надпись. form_first: '1' (чертёж/схема) или '2' (текстовый)."""
    c.setStrokeColor(colors.black)
    c.setFillColor(colors.black)
    L, O = 20, 5
    c.setLineWidth(THICK * mm)
    c.rect(L * mm, O * mm, (pw - L - O) * mm, (ph - 2 * O) * mm)
    # дополнительные графы 19–23 (левое поле)
    x0, x1 = L - 12, L
    xs = [x0, x0 + 5, x1]
    bounds = [0, 25, 60, 85, 110, 145]
    for b in bounds:
        _line(c, x0, O + b, x1, O + b, THICK)
    for x in xs:
        _line(c, x, O, x, O + 145, THICK)
    labels = ["Инв. № подл.", "Подп. и дата", "Взам. инв. №", "Инв. № дубл.", "Подп. и дата"]
    for (a, b), lab in zip(zip(bounds[:-1], bounds[1:]), labels):
        c.saveState()
        c.translate((x0 + 3.6) * mm, (O + (a + b) / 2) * mm)
        c.rotate(90)
        _txt(c, lab, 0, 0, 2.5, "center")
        c.restoreState()
    R = pw - O   # правая граница
    if first:
        # графы 24–25 (первый лист): «Перв. примен.», «Справ. №»
        top = ph - O
        for b in (0, 60, 120):
            _line(c, x0, top - b, x1, top - b, THICK)
        for x in xs:
            _line(c, x, top - 120, x, top, THICK)
        for (a, b), lab in zip(((0, 60), (60, 120)), ("Перв. примен.", "Справ. №")):
            c.saveState()
            c.translate((x0 + 3.6) * mm, (top - (a + b) / 2) * mm)
            c.rotate(90)
            _txt(c, lab, 0, 0, 2.5, "center")
            c.restoreState()
        # графа 26 (обозначение, повёрнутое на 180°) — 70×14 в левом верхнем углу (чертежи и схемы)
        if form_first == "1":
            _g26(c, L, ph, O, meta)
        if form_first == "1":
            _stamp1(c, R, O, meta, page, pages, h=55)
        else:
            _stamp2(c, R, O, meta, page, pages)
    else:
        _stamp2a(c, R, O, meta, page)
    _txt(c, "Копировал", R - 110, O - 3.5, 2.5)
    _txt(c, f"Формат {meta.get('format', 'A4')}", R - 40, O - 3.5, 2.5)


def _g26(c, L, ph, O, meta):
    _line(c, L, ph - O - 14, L + 70, ph - O - 14, THICK)
    _line(c, L + 70, ph - O - 14, L + 70, ph - O, THICK)
    c.saveState()
    c.translate((L + 35) * mm, (ph - O - 7) * mm)
    c.rotate(180)
    _fit(c, meta["designation"], 0, -1.2, 68, 3.5)
    c.restoreState()


def _left_part(c, R, O, rows_changes, roles, meta, h):
    """Левая часть основной надписи (графы 10–18): столбцы 7/10/23/15/10 мм."""
    xL = R - 185
    cols = [0, 7, 17, 40, 55, 65]
    nrows = rows_changes + 1 + len(roles)
    for i in range(nrows + 1):
        y = O + i * 5
        w = THICK if i in (len(roles), len(roles) + 1, nrows) else THIN
        _line(c, xL, y, xL + 65, y, w)
    for k, cx in enumerate(cols):
        top = O + nrows * 5
        bot = O if k in (0, 5) else (O if k != 1 else O + len(roles) * 5)
        if k == 1:
            # граница «Изм.|Лист» только в зоне изменений
            _line(c, xL + cx, O + len(roles) * 5, xL + cx, top, THICK)
        else:
            _line(c, xL + cx, bot, xL + cx, top, THICK)
    yh = O + len(roles) * 5 + 1.4
    for cx, w, lab in ((0, 7, "Изм."), (7, 10, "Лист"), (17, 23, "№ докум."), (40, 15, "Подп."), (55, 10, "Дата")):
        _fit(c, lab, xL + cx + w / 2, yh, w, 2.5)
    vals = {"Разраб.": meta.get("dev", ""), "Пров.": meta.get("chk", ""), "Т.контр.": meta.get("tch", ""),
            "Н.контр.": meta.get("nch", ""), "Утв.": meta.get("app", "")}
    for i, role in enumerate(roles):
        y = O + (len(roles) - 1 - i) * 5 + 1.4
        if role:
            _txt(c, role, xL + 0.8, y, 2.5)
            _fit(c, vals.get(role, ""), xL + 17 + 11.5, y, 23, 2.5)
            if role == "Разраб." and meta.get("date"):
                _fit(c, meta["date"][-5:] if len(meta["date"]) > 8 else meta["date"], xL + 60, y, 10, 2.0)


def _stamp1(c, R, O, meta, page, pages, h=55):
    xL = R - 185
    _line(c, xL, O + h, R, O + h, THICK)
    _left_part(c, R, O, 4, ["Разраб.", "Пров.", "Т.контр.", "", "Н.контр.", "Утв."], meta, h)
    xr = xL + 65
    _line(c, xr, O, xr, O + h, THICK)
    _line(c, xr, O + 40, R, O + 40, THICK)
    _line(c, xr, O + 15, R, O + 15, THICK)
    _line(c, R - 50, O, R - 50, O + 40, THICK)
    _fit(c, meta["designation"], xr + 60, O + 45.5, 118, 5)
    _fit(c, meta["title"], xr + 35, O + 30, 68, 3.5)
    _fit(c, meta.get("doctype", ""), xr + 35, O + 22, 68, 3.5)
    _line(c, R - 50, O + 35, R, O + 35, THICK)
    _line(c, R - 50, O + 20, R, O + 20, THICK)
    for x in (R - 35, R - 18):
        _line(c, x, O + 20, x, O + 40, THICK)
    for x in (R - 45, R - 40):
        _line(c, x, O + 20, x, O + 35, THIN)
    _fit(c, "Лит.", R - 42.5, O + 36.4, 15, 2.5)
    _fit(c, "Масса", R - 26.5, O + 36.4, 17, 2.5)
    _fit(c, "Масштаб", R - 9, O + 36.4, 18, 2.5)
    _fit(c, meta.get("lit", ""), R - 47.5, O + 26, 5, 3.5)
    _fit(c, meta.get("scale", ""), R - 9, O + 26, 18, 3.5)
    _line(c, R - 30, O + 15, R - 30, O + 20, THICK)
    _txt(c, f"Лист {page}", R - 49, O + 16.4, 2.5)
    _txt(c, f"Листов {pages}", R - 29, O + 16.4, 2.5)
    _fit(c, meta.get("company", ""), R - 25, O + 6.5, 48, 3.5)


def _stamp2(c, R, O, meta, page, pages):
    """Форма 2 (185×40): 3 строки изменений+заголовок, 5 строк подписей."""
    xL = R - 185
    _line(c, xL, O + 40, R, O + 40, THICK)
    _left_part(c, R, O, 2, ["Разраб.", "Пров.", "", "Н.контр.", "Утв."], meta, 40)
    xr = xL + 65
    _line(c, xr, O, xr, O + 40, THICK)
    _line(c, xr, O + 25, R, O + 25, THICK)
    _line(c, R - 50, O, R - 50, O + 25, THICK)
    _line(c, R - 50, O + 20, R, O + 20, THICK)
    _line(c, R - 50, O + 15, R, O + 15, THICK)
    for x in (R - 35, R - 20):
        _line(c, x, O + 15, x, O + 25, THICK)
    for x in (R - 45, R - 40):
        _line(c, x, O + 15, x, O + 20, THIN)
    _fit(c, meta["designation"], xr + 60, O + 30.5, 118, 5)
    _fit(c, meta["title"], xr + 35, O + 15, 68, 3.5)
    _fit(c, meta.get("doctype", ""), xr + 35, O + 8, 68, 3.5)
    _fit(c, "Лит.", R - 42.5, O + 21.4, 15, 2.5)
    _fit(c, "Лист", R - 27.5, O + 21.4, 15, 2.5)
    _fit(c, "Листов", R - 10, O + 21.4, 20, 2.5)
    _fit(c, meta.get("lit", ""), R - 47.5, O + 16.2, 5, 3)
    _fit(c, str(page), R - 27.5, O + 16.2, 15, 3)
    _fit(c, str(pages), R - 10, O + 16.2, 20, 3)
    _fit(c, meta.get("company", ""), R - 25, O + 6.5, 48, 3.5)


def _stamp2a(c, R, O, meta, page):
    xL = R - 185
    _line(c, xL, O + 15, R, O + 15, THICK)
    for x, w in ((0, THICK), (7, THICK), (17, THICK), (40, THICK), (55, THICK), (65, THICK)):
        _line(c, xL + x, O, xL + x, O + 15, w)
    _line(c, xL, O + 5, xL + 65, O + 5, THICK)
    _line(c, xL, O + 10, xL + 65, O + 10, THIN)
    _line(c, R - 10, O, R - 10, O + 15, THICK)
    _line(c, R - 10, O + 8, R, O + 8, THICK)
    for cx, w, lab in ((0, 7, "Изм."), (7, 10, "Лист"), (17, 23, "№ докум."), (40, 15, "Подп."), (55, 10, "Дата")):
        _fit(c, lab, xL + cx + w / 2, O + 1.4, w, 2.5)
    _fit(c, meta["designation"], xL + 65 + 55, O + 5.5, 108, 5)
    _fit(c, "Лист", R - 5, O + 10, 10, 2.5)
    _fit(c, str(page), R - 5, O + 2.5, 10, 3.5)


# ------------------------------------------------------------------ документ с рамкой
class EskdDoc(BaseDocTemplate):
    def __init__(self, path, meta, pagesize=A4, form_first="2", **kw):
        self.meta = meta
        self.form_first = form_first
        self.total_pages = 0
        pw, ph = pagesize[0] / mm, pagesize[1] / mm
        self.pw, self.ph = pw, ph
        super().__init__(path, pagesize=pagesize, leftMargin=25 * mm, rightMargin=10 * mm,
                         topMargin=15 * mm, bottomMargin=20 * mm, title=meta.get("doctype", ""),
                         author=meta.get("company", ""), **kw)
        stamp_h = {"1": 55, "2": 40}[form_first]
        f1 = Frame(25 * mm, (5 + stamp_h + 5) * mm, (pw - 35) * mm, (ph - 15 - stamp_h - 10) * mm, id="first",
                   leftPadding=0, rightPadding=0, topPadding=0, bottomPadding=0)
        fn = Frame(25 * mm, 25 * mm, (pw - 35) * mm, (ph - 40) * mm, id="next",
                   leftPadding=0, rightPadding=0, topPadding=0, bottomPadding=0)
        self.addPageTemplates([PageTemplate("First", [f1], onPage=self._on_page, autoNextPageTemplate="Next"),
                               PageTemplate("Next", [fn], onPage=self._on_page)])

    def _on_page(self, c, doc):
        p = c.getPageNumber()
        draw_frame(c, self.pw, self.ph, self.meta, p, self.total_pages or "", first=(p == 1),
                   form_first=self.form_first)

    def build2(self, story):
        """Двухпроходная сборка: первый проход считает листы."""
        import copy
        self.build(copy.deepcopy(story))
        self.total_pages = self.page
        self.build(story)


# ------------------------------------------------------------------ стили текста
def styles(base=11):
    s = {}
    s["body"] = ParagraphStyle("body", fontName="Serif", fontSize=base, leading=base * 1.35, alignment=TA_JUSTIFY,
                               firstLineIndent=12.5 * mm, spaceAfter=2)
    s["plain"] = ParagraphStyle("plain", parent=s["body"], firstLineIndent=0)
    s["h1"] = ParagraphStyle("h1", fontName="Serif-B", fontSize=base + 3, leading=(base + 3) * 1.3, spaceBefore=8,
                             spaceAfter=6, firstLineIndent=12.5 * mm, keepWithNext=1)
    s["h2"] = ParagraphStyle("h2", fontName="Serif-B", fontSize=base + 1, leading=(base + 1) * 1.3, spaceBefore=6,
                             spaceAfter=4, firstLineIndent=12.5 * mm, keepWithNext=1)
    s["h3"] = ParagraphStyle("h3", fontName="Serif-B", fontSize=base, leading=base * 1.3, spaceBefore=4,
                             spaceAfter=3, firstLineIndent=12.5 * mm, keepWithNext=1)
    s["li"] = ParagraphStyle("li", parent=s["body"], firstLineIndent=0, leftIndent=17 * mm, bulletIndent=12.5 * mm)
    s["cell"] = ParagraphStyle("cell", fontName="Serif", fontSize=base - 2, leading=(base - 2) * 1.2, alignment=TA_LEFT)
    s["cellc"] = ParagraphStyle("cellc", parent=s["cell"], alignment=TA_CENTER)
    s["cap"] = ParagraphStyle("cap", parent=s["plain"], alignment=TA_CENTER, spaceBefore=2, spaceAfter=6)
    s["tcap"] = ParagraphStyle("tcap", parent=s["plain"], alignment=TA_LEFT, spaceBefore=4, spaceAfter=2, keepWithNext=1)
    s["code"] = ParagraphStyle("code", fontName="Mono", fontSize=base - 3, leading=(base - 3) * 1.25)
    s["center"] = ParagraphStyle("center", parent=s["plain"], alignment=TA_CENTER)
    s["title"] = ParagraphStyle("title", fontName="Serif-B", fontSize=base + 6, leading=(base + 6) * 1.3,
                                alignment=TA_CENTER, spaceAfter=6)
    return s


def inline(t):
    t = t.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
    t = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", t)
    t = re.sub(r"(?<![\w*])\*(?!\s)(.+?)(?<!\s)\*(?!\w)", r"<i>\1</i>", t)
    t = re.sub(r"`([^`]+)`", r'<font face="Mono">\1</font>', t)
    t = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", r'\1 (\2)', t)
    # степени: 2^32, 10^−2, 2^μ (вне моноширинных фрагментов)
    parts = re.split(r'(<font face="Mono">.*?</font>)', t)
    t = "".join(p if p.startswith('<font face="Mono">') else
                re.sub(r"(\d|\))\^([−-]?[0-9A-Za-zμα-ω]+)", r"\1<super>\2</super>", p) for p in parts)
    return t


def md_story(md, s, basedir, width_mm=175):
    """Упрощённый Markdown -> flowables."""
    story = []
    lines = md.split("\n")
    if lines and lines[0].strip() == "---":
        end = lines.index("---", 1)
        lines = lines[end + 1:]
    i = 0
    para = []
    tab_no = [0]

    def flush():
        if para:
            story.append(Paragraph(inline(" ".join(para)), s["body"]))
            para.clear()
    while i < len(lines):
        ln = lines[i]
        st = ln.strip()
        if st.startswith("```"):
            flush()
            j = i + 1
            buf = []
            while j < len(lines) and not lines[j].strip().startswith("```"):
                buf.append(lines[j])
                j += 1
            story.append(Preformatted("\n".join(buf), s["code"]))
            story.append(Spacer(1, 3))
            i = j + 1
            continue
        if not st:
            flush()
            i += 1
            continue
        m = re.match(r"^(#{1,3})\s+(.*)$", st)
        if m:
            flush()
            lvl = len(m.group(1))
            story.append(CondPageBreak(30 * mm))
            story.append(Paragraph(inline(m.group(2)), s[f"h{lvl}"]))
            i += 1
            continue
        m = re.match(r"^!\[(.*?)\]\((.*?)\)", st)
        if m:
            flush()
            path = os.path.join(basedir, m.group(2))
            if os.path.exists(path):
                from reportlab.lib.utils import ImageReader
                iw, ih = ImageReader(path).getSize()
                w = width_mm * mm
                h = w * ih / iw
                if h > 200 * mm:
                    h = 200 * mm
                    w = h * iw / ih
                story.append(KeepTogether([Image(path, w, h), Paragraph(inline(m.group(1)), s["cap"])]))
            else:
                story.append(Paragraph(f"[нет файла {m.group(2)}]", s["plain"]))
            i += 1
            continue
        if st.startswith("|"):
            flush()
            rows = []
            while i < len(lines) and lines[i].strip().startswith("|"):
                row = [c.strip() for c in lines[i].strip().strip("|").split("|")]
                if not all(re.fullmatch(r":?-{2,}:?", c) for c in row):
                    rows.append(row)
                i += 1
            if rows:
                ncol = max(len(r) for r in rows)
                rows = [r + [""] * (ncol - len(r)) for r in rows]
                lens = [max(len(r[k]) for r in rows) + 4 for k in range(ncol)]
                tot = sum(lens)
                widths = [max(12, width_mm * L / tot) * mm for L in lens]
                scale = width_mm * mm / sum(widths)
                widths = [w * scale for w in widths]
                data = [[Paragraph(inline(c), s["cellc"] if ri == 0 else s["cell"]) for c in r]
                        for ri, r in enumerate(rows)]
                t = Table(data, colWidths=widths, repeatRows=1)
                t.setStyle(TableStyle([("GRID", (0, 0), (-1, -1), 0.5, colors.black),
                                       ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
                                       ("TOPPADDING", (0, 0), (-1, -1), 1.5),
                                       ("BOTTOMPADDING", (0, 0), (-1, -1), 1.5)]))
                story.append(t)
                story.append(Spacer(1, 4))
            continue
        m = re.match(r"^(\s*)([-*]|\d+[.)])\s+(.*)$", ln)
        if m and not re.match(r"^\d+\.\d", st):
            flush()
            bullet = "–" if m.group(2) in "-*" else m.group(2)
            ind = len(m.group(1)) // 2
            text = m.group(3)
            j = i + 1
            while j < len(lines) and lines[j].startswith("  ") and lines[j].strip() and \
                    not re.match(r"^\s*([-*]|\d+[.)])\s+", lines[j]):
                text += " " + lines[j].strip()
                j += 1
            st_li = ParagraphStyle("lix", parent=s["li"], leftIndent=(17 + 5 * ind) * mm,
                                   bulletIndent=(12.5 + 5 * ind) * mm)
            story.append(Paragraph(inline(text), st_li, bulletText=bullet))
            i = j
            continue
        if re.match(r"^Таблица\s+\d+", st):
            flush()
            story.append(Paragraph(inline(st), s["tcap"]))
            i += 1
            continue
        para.append(st)
        i += 1
    flush()
    return story


def md_to_pdf(md_path, pdf_path, meta, form_first="2"):
    s = styles()
    md = open(md_path, encoding="utf-8").read()
    story = md_story(md, s, os.path.dirname(md_path))
    doc = EskdDoc(pdf_path, meta, A4, form_first)
    doc.build2(story)
    return doc.total_pages


# ------------------------------------------------------------------ перечни
def _grid_table(c, x0, ytop, widths, header, rows, row_h=8, head_h=15, font=3.5, wrap_cols=()):
    """Таблица в стиле ЕСКД на canvas (линии 0,6/0,3 мм)."""
    x = x0
    xs = [x0]
    for w in widths:
        x += w
        xs.append(x)
    y = ytop
    _line(c, x0, y, xs[-1], y, THICK)
    _line(c, x0, y - head_h, xs[-1], y - head_h, THICK)
    for k, h in enumerate(header):
        lines = h.split("\n")
        for j, ln in enumerate(lines):
            _fit(c, ln, (xs[k] + xs[k + 1]) / 2, y - head_h / 2 + (len(lines) / 2 - j - 0.75) * 4.2, widths[k], font)
    y -= head_h
    for r in rows:
        for k, val in enumerate(r):
            if val is None:
                continue
            al = "center" if k in r.__dict__.get("center", ()) else "left"
        y -= row_h
        _line(c, x0, y, xs[-1], y, THIN)
    for xx in xs:
        _line(c, xx, ytop, xx, y, THICK)
    return xs


class RowSpec(list):
    pass


def list_pages(c, pw, ph, meta, rows, widths, header, aligns, row_h=8, head_h=15, first_rows=None, next_rows=None,
               form_first="2", font=3.5):
    """Перечень/спецификация: строки rows (списки строк) с переносом по листам."""
    stamp_h = {"1": 55, "2": 40}[form_first]
    x0 = 20
    ytop = ph - 5
    first_rows = first_rows or int((ph - 10 - stamp_h - head_h) // row_h)
    next_rows = next_rows or int((ph - 10 - 15 - head_h) // row_h)
    chunks = [rows[:first_rows]]
    rest = rows[first_rows:]
    while rest:
        chunks.append(rest[:next_rows])
        rest = rest[next_rows:]
    pages = len(chunks)
    for pi, chunk in enumerate(chunks, start=1):
        nrow = first_rows if pi == 1 else next_rows
        xs = [x0]
        for w in widths:
            xs.append(xs[-1] + w)
        _line(c, x0, ytop - head_h, xs[-1], ytop - head_h, THICK)
        for k, h in enumerate(header):
            hl = h.split("\n")
            for j, ln in enumerate(hl):
                _fit(c, ln, (xs[k] + xs[k + 1]) / 2, ytop - head_h / 2 + (len(hl) / 2 - j - 0.75) * 4.0, widths[k], 3.0)
        ybot = ytop - head_h - nrow * row_h
        for xx in xs:
            _line(c, xx, ytop, xx, ybot, THICK)
        for j in range(nrow):
            y = ytop - head_h - (j + 1) * row_h
            _line(c, x0, y, xs[-1], y, THIN)
            if j < len(chunk):
                r = chunk[j]
                for k, val in enumerate(r):
                    if not val:
                        continue
                    al = aligns[k]
                    cx = {"left": xs[k] + 1.2, "center": (xs[k] + xs[k + 1]) / 2, "right": xs[k + 1] - 1.2}[al]
                    if isinstance(val, tuple):   # (текст, 'u') — подчёркнутый заголовок группы
                        _fit(c, val[0], (xs[k] + xs[k + 1]) / 2, y + 2.3, widths[k], font, "center")
                        tw = pdfmetrics.stringWidth(val[0], "GOST", font / 0.3528) / mm
                        _line(c, (xs[k] + xs[k + 1]) / 2 - tw / 2, y + 1.6, (xs[k] + xs[k + 1]) / 2 + tw / 2, y + 1.6, 0.25)
                    else:
                        size = font
                        while size > 2.0 and pdfmetrics.stringWidth(val, "GOST", size / 0.3528) > (widths[k] - 2.4) * mm:
                            size -= 0.25
                        _txt(c, val, cx, y + 2.3, size, al)
        draw_frame(c, pw, ph, meta, pi, pages, first=(pi == 1), form_first=form_first)
        c.showPage()
    return pages
