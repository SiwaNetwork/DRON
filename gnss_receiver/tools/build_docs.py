"""Текстовые документы КД в PDF по ГОСТ 2.105/2.104 (рамка, основные надписи по форме 2/2а):
docs/*.md с заголовком YAML (title, designation, doctype) -> kd/<обозначение>.pdf.
Запуск: python3 tools/build_docs.py [файл.md ...]"""
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, "..")
sys.path.insert(0, HERE)
import eskd_pdf as E  # noqa: E402

DOCS = ["02_ТЗ.md", "03_ПЗ.md", "04_ПМ.md", "05_Описание_программы.md"]


def front(md):
    m = re.match(r"^---\n(.*?)\n---\n", md, re.S)
    out = {}
    if m:
        for ln in m.group(1).split("\n"):
            if ":" in ln:
                k, v = ln.split(":", 1)
                out[k.strip()] = v.strip()
    return out


def build(path):
    md = open(path, encoding="utf-8").read()
    fm = front(md)
    des = fm.get("designation", "ШИВА.468157.001")
    title = fm.get("product", "Модуль приемника ГНСС МГП-8")
    doctype = fm.get("docname", fm.get("title", "").split(". ")[-1])
    meta = E.Meta(designation=des, title=title, doctype=doctype, company="SiwaNetwork", lit="Э",
                  dev="Разработчик", date="10.2026")
    out = os.path.join(ROOT, "kd", f"{des}.pdf")
    n = E.md_to_pdf(path, out, meta)
    print(f"{os.path.basename(path)} -> kd/{des}.pdf, листов: {n}")


def main():
    files = sys.argv[1:] or [os.path.join(ROOT, "docs", f) for f in DOCS]
    for f in files:
        if os.path.exists(f):
            build(f)


if __name__ == "__main__":
    main()
