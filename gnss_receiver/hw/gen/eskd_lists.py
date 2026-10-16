"""Перечень элементов (ПЭ3), спецификация и ведомость покупных изделий (ВП) по модели схемы:
kd/<обозначение>.pdf (основной экземпляр) и .docx (редактируемая копия)."""
import os
import re
import sys
from collections import OrderedDict

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(HERE, "..", "..", "tools"))
from reportlab.lib.pagesizes import A3, A4, landscape  # noqa: E402
from reportlab.lib.units import mm  # noqa: E402
from reportlab.pdfgen import canvas  # noqa: E402

import eskd_docx as D  # noqa: E402
import eskd_pdf as E  # noqa: E402

DES = "ШИВА.468157.001"
GROUP_PLURAL = {"C": "Конденсаторы", "R": "Резисторы", "L": "Катушки индуктивности и фильтры",
                "DA": "Микросхемы", "DD": "Микросхемы", "VD": "Диоды", "HL": "Светодиоды",
                "X": "Соединители", "XS": "Соединители", "XW": "Соединители", "ZQ": "Резонаторы кварцевые",
                "W": "Делители мощности СВЧ", "G": "Генераторы", "FU": "Предохранители"}


def _refkey(ref):
    m = re.match(r"([A-Z]+)(\d+)", ref)
    return m.group(1), int(m.group(2))


def full_name(pd):
    n = pd.name
    if pd.pn and pd.pn not in n:
        n += f" {pd.pn}"
    return f"{n}, {pd.mfr}" if pd.mfr else n


def _wrap(text, n=62):
    words, lines, cur = text.split(), [], ""
    for w in words:
        if len(cur) + len(w) + 1 > n and cur:
            lines.append(cur)
            cur = w
        else:
            cur = (cur + " " + w).strip()
    if cur:
        lines.append(cur)
    return lines


def _ranges(refs):
    """['C1','C2','C3','C5'] -> 'C1…C3, C5' (ГОСТ 2.701: три и более подряд — через многоточие)."""
    nums = sorted(_refkey(r) for r in refs)
    out, i = [], 0
    while i < len(nums):
        j = i
        while j + 1 < len(nums) and nums[j + 1][0] == nums[i][0] and nums[j + 1][1] == nums[j][1] + 1:
            j += 1
        p = nums[i][0]
        if j - i >= 2:
            out.append(f"{p}{nums[i][1]}…{p}{nums[j][1]}")
        else:
            out += [f"{p}{nums[k][1]}" for k in range(i, j + 1)]
        i = j + 1
    return ", ".join(out)


def pe3_rows(design):
    comps = sorted(design.comps, key=lambda c: _refkey(c.ref))
    rows = []
    prefixes = OrderedDict()
    for c in comps:
        prefixes.setdefault(_refkey(c.ref)[0], []).append(c)
    for pfx in sorted(prefixes, key=lambda p: p):
        cs = prefixes[pfx]
        kinds = {(c.pd.pn, c.dnp) for c in cs}
        if len(kinds) > 1 or len(cs) > 1:
            rows.append(["", (GROUP_PLURAL.get(pfx, pfx), "u"), "", ""])
        i = 0
        while i < len(cs):
            j = i
            while j + 1 < len(cs) and cs[j + 1].pd.pn == cs[i].pd.pn and cs[j + 1].dnp == cs[i].dnp and \
                    _refkey(cs[j + 1].ref)[1] == _refkey(cs[j].ref)[1] + 1:
                j += 1
            grp = cs[i:j + 1]
            if len(grp) == 1:
                pos = grp[0].ref
            elif len(grp) == 2:
                pos = f"{grp[0].ref}, {grp[1].ref}"
            else:
                pos = f"{grp[0].ref}…{grp[-1].ref}"
            note = "Не устанавливается" if grp[0].dnp else (grp[0].note if grp[0].note and len(grp) == 1 else "")
            lines = _wrap(full_name(grp[0].pd))
            rows.append([pos, lines[0], str(len(grp)), note])
            for ln in lines[1:]:
                rows.append(["", ln, "", ""])
            i = j + 1
        rows.append(["", "", "", ""])
    return rows


def _write(path, pw, ph, m, rows, widths, head, al, title, font=3.5):
    """Перечень в PDF (основной экземпляр) и рядом в DOCX (редактируемая копия) с теми же строками."""
    c = canvas.Canvas(path, pagesize=landscape(A3) if pw > ph else A4)
    c.setTitle(title)
    pages = E.list_pages(c, pw, ph, m, rows, widths, head, al, form_first="2", font=font)
    c.save()
    D.list_to_docx(path[:-4] + ".docx", pw, ph, dict(m, pages=pages), rows, widths, head, al, font=font)
    return pages


def write_pe3(design, path, meta):
    m = dict(meta, designation=f"{DES} ПЭ3", doctype="Перечень элементов", format="A4")
    return _write(path, 210, 297, m, pe3_rows(design), [20, 110, 10, 45],
                  ["Поз.\nобозна-\nчение", "Наименование", "Кол.", "Примечание"],
                  ["left", "left", "center", "left"], "Перечень элементов")


def purchased(design):
    """Покупные изделия: артикул -> (наименование, изготовитель, количество, обозначения, группа)."""
    items = OrderedDict()
    for c in sorted(design.comps, key=lambda c: (c.pd.group, c.pd.pn)):
        if c.dnp:
            continue
        k = c.pd.pn
        if k not in items:
            items[k] = dict(name=full_name(c.pd), mfr=c.pd.mfr, qty=0, refs=[], group=GROUP_PLURAL.get(c.pd.prefix, c.pd.group),
                            pd=c.pd)
        items[k]["qty"] += 1
        items[k]["refs"].append(c.ref)
    return items


MECH = [  # изделия, не показанные на схеме (крепёж, экраны)
    dict(name="Рамка экрана 44,8×18,2×3,0 мм MS448-10F, Masach", pn="MS448-10F", mfr="Masach", qty=2, group="Прочие"),
    dict(name="Крышка экрана 44,8×18,2 мм MS448-10C, Masach", pn="MS448-10C", mfr="Masach", qty=2, group="Прочие"),
    dict(name="Перемычка съёмная шаг 2,0 мм SPN02SYBN-RC, Sullins", pn="SPN02SYBN-RC", mfr="Sullins", qty=1, group="Прочие"),
]


def write_spec(design, path, meta):
    rows = [["", "", "", "", ("Документация", "u"), "", ""], ["", "", "", "", "", "", ""]]
    docs = [("A3", f"{DES} Э1", "Схема электрическая структурная"),
            ("A2", f"{DES} Э3", "Схема электрическая принципиальная"),
            ("A4", f"{DES} ПЭ3", "Перечень элементов"),
            ("A3", f"{DES} ВП", "Ведомость покупных изделий"),
            ("A4", f"{DES} ПЗ", "Пояснительная записка"),
            ("A4", f"{DES} ПМ", "Программа и методика испытаний")]
    for fmt, d, n in docs:
        rows.append([fmt, "", "", d, n, "", ""])
    rows += [["", "", "", "", "", "", ""], ["", "", "", "", ("Детали", "u"), "", ""], ["", "", "", "", "", "", ""]]
    rows.append(["A3", "", "1", "ШИВА.758726.001", "Плата печатная", "1", "Этап 2"])
    rows += [["", "", "", "", "", "", ""], ["", "", "", "", ("Прочие изделия", "u"), "", ""], ["", "", "", "", "", "", ""]]
    pos = 2
    group = None
    for pn, it in purchased(design).items():
        if it["group"] != group:
            group = it["group"]
        lines = _wrap(it["name"], 34)
        refs = _ranges(it["refs"])
        rlines = _wrap(refs, 14) if refs else [""]
        n = max(len(lines), len(rlines))
        for k in range(n):
            rows.append(["", "", str(pos) if k == 0 else "", "", lines[k] if k < len(lines) else "",
                         str(it["qty"]) if k == 0 else "", rlines[k] if k < len(rlines) else ""])
        pos += 1
    for it in MECH:
        for k, ln in enumerate(_wrap(it["name"], 34)):
            rows.append(["", "", str(pos) if k == 0 else "", "", ln, str(it["qty"]) if k == 0 else "", ""])
        pos += 1
    m = dict(meta, designation=DES, doctype="", format="A4")
    widths = [6, 6, 8, 70, 63, 10, 22]
    head = ["Формат", "Зона", "Поз.", "Обозначение", "Наименование", "Кол.", "Приме-\nчание"]
    al = ["center", "center", "center", "left", "left", "center", "left"]
    return _write(path, 210, 297, m, rows, widths, head, al, "Спецификация", font=3.0)


def write_vp(design, path, meta):
    rows = []
    n = 1
    group = None
    for pn, it in purchased(design).items():
        if it["group"] != group:
            group = it["group"]
            rows.append(["", (group, "u"), "", "", "", "", "", "", "", "", ""])
        nm = _wrap(it["pd"].name.replace("ё", "е"), 40)
        for k, ln in enumerate(nm):
            rows.append([str(n) if k == 0 else "", ln, it["pd"].pn if k == 0 else "", "",
                         it["mfr"] if k == 0 else "", DES if k == 0 else "", str(it["qty"]) if k == 0 else "",
                         "", "", str(it["qty"]) if k == 0 else "", ""])
        n += 1
    for it in MECH:
        rows.append([str(n), it["name"].split(",")[0], it["pn"], "", it["mfr"], DES, str(it["qty"]), "", "",
                     str(it["qty"]), "Не показано на Э3"])
        n += 1
    widths = [10, 95, 50, 45, 40, 50, 18, 18, 18, 18, 33]
    head = ["№\nстроки", "Наименование", "Код продукции\n(артикул)", "Обозначение\nдокумента\nна поставку",
            "Поставщик\n(изготовитель)", "Куда входит\n(обозначение)", "Кол. на\nизделие", "в комп-\nлекты",
            "на регу-\nлир.", "всего", "Примечание"]
    al = ["center", "left", "left", "left", "left", "left", "center", "center", "center", "center", "left"]
    m = dict(meta, designation=f"{DES} ВП", doctype="Ведомость покупных изделий", format="A3")
    return _write(path, 420, 297, m, rows, widths, head, al, "Ведомость покупных изделий", font=3.0)


def main(outdir):
    import build
    d = build.main()
    meta = E.Meta(title="Модуль приемника ГНСС МГП-8", company="ООО ШИВА НЕТВОРК", lit="Э", dev="Разработчик",
                  date="10.2026")
    os.makedirs(outdir, exist_ok=True)
    p1 = write_pe3(d, os.path.join(outdir, f"{DES} ПЭ3.pdf"), meta)
    p2 = write_spec(d, os.path.join(outdir, f"{DES} Спецификация.pdf"), meta)
    p3 = write_vp(d, os.path.join(outdir, f"{DES} ВП.pdf"), meta)
    print(f"ПЭ3: {p1} л., спецификация: {p2} л., ВП: {p3} л.")
    return d


if __name__ == "__main__":
    main(os.path.join(HERE, "..", "..", "kd"))
