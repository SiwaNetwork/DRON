"""Текстовые документы КД в PDF по ГОСТ 2.105/2.104 (рамка, основные надписи по форме 2/2а):
docs/*.md с заголовком YAML (title, designation, doctype) -> kd/<обозначение>.pdf (основной
экземпляр) и kd/<обозначение>.docx (редактируемая копия для Word; правки вносятся в .md).
Запуск: python3 tools/build_docs.py [файл.md ...]"""
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, "..")
sys.path.insert(0, HERE)
import eskd_docx as D  # noqa: E402
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


def build(path, docx=True):
    md = open(path, encoding="utf-8").read()
    fm = front(md)
    des = fm.get("designation", "ШИВА.468157.001")
    title = fm.get("product", "Модуль приемника ГНСС МГП-8")
    doctype = fm.get("docname", fm.get("title", "").split(". ")[-1])
    meta = E.Meta(designation=des, title=title, doctype=doctype, company="ООО ШИВА НЕТВОРК", lit="Э",
                  dev="Разработчик", date="10.2026")
    out = os.path.join(ROOT, "kd", f"{des}.pdf")
    n = E.md_to_pdf(path, out, meta)
    if docx:
        D.md_to_docx(path, out[:-4] + ".docx", meta)
    print(f"{os.path.basename(path)} -> kd/{des}.pdf{' и .docx' if docx else ''}, листов: {n}")


NAMES = {"Э1": "Схема электрическая структурная", "Э3": "Схема электрическая принципиальная",
         "ПЭ3": "Перечень элементов", "Спецификация": "Спецификация", "ВП": "Ведомость покупных изделий",
         "ТЗ": "Техническое задание", "ПЗ": "Пояснительная записка",
         "ПМ": "Программа и методика испытаний", "13 01": "Описание программы (ПО МК)"}
ORDER = ["Спецификация", "Э1", "Э3", "ПЭ3", "ВП", "ТЗ", "ПЗ", "ПМ", "13 01"]


def pages(path):
    try:
        from pypdf import PdfReader
    except ImportError:                      # Windows: pypdf не установлен, есть pymupdf
        import pymupdf
        with pymupdf.open(path) as doc:
            return doc.page_count
    return len(PdfReader(path).pages)


def build_ep():
    """Ведомость эскизного проекта по составу kd/ (ГОСТ 2.106, в виде текстового документа)."""
    kd = os.path.join(ROOT, "kd")
    rows = []
    for key in ORDER:
        for f in sorted(os.listdir(kd)):
            if f.endswith(".pdf") and f[:-4].endswith(" " + key) and "ЭП" not in f:
                des = f[:-4].replace(" Спецификация", "")       # обозначение спецификации — без кода
                rows.append((des, NAMES[key], pages(os.path.join(kd, f))))
    md = ["---", "title: Модуль приёмника ГНСС многочастотного МГП-8. Ведомость эскизного проекта",
          "designation: ШИВА.468157.001 ЭП", "docname: Ведомость эскизного проекта", "---", "",
          "Таблица 1 — Документы эскизного проекта", "",
          "| Обозначение | Наименование | Кол. листов | Примечание |", "|---|---|---|---|"]
    for des, name, n in rows:
        note = "ЕСПД" if "13 01" in des else ""
        md.append(f"| {des} | {name} | {n} | {note} |")
    md += ["", "Исходные тексты схемы, конфигурации ПЛИС, ПО и расчётных моделей — каталог "
           "`gnss_receiver` репозитория проекта (README.md)."]
    path = os.path.join(ROOT, "docs", "00_ЭП.md")
    open(path, "w", encoding="utf-8", newline="\n").write("\n".join(md) + "\n")
    build(path, docx=False)


def main():
    files = sys.argv[1:] or [os.path.join(ROOT, "docs", f) for f in DOCS]
    for f in files:
        if os.path.exists(f):
            build(f)
    if not sys.argv[1:]:
        build_ep()


if __name__ == "__main__":
    main()
