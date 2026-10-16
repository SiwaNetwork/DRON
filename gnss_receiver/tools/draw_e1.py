"""Схема электрическая структурная МГП-8 (ШИВА.468157.001 Э1), формат A3, ГОСТ 2.702-2011."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from reportlab.lib.pagesizes import A3, landscape  # noqa: E402
from reportlab.lib.units import mm  # noqa: E402
from reportlab.pdfgen import canvas  # noqa: E402

import eskd_pdf as E  # noqa: E402

BLOCKS = {
    # имя: (x, y, w, h, обозначение, текст)
    "ant": (28, 205, 34, 26, "", "Антенна\nактивная\nмногочастотная"),
    "inp": (75, 200, 42, 36, "A1", "Антенный вход:\nзащита ESD,\nпитание антенны,\nконтроль тока"),
    "div": (130, 200, 34, 36, "A2", "Делитель\nмощности\n1:8"),
    "clk": (75, 128, 42, 40, "A11", "Опорный\nгенератор\n24 МГц,\nформирователи\nтактовых частот"),
    "fpga": (250, 120, 52, 132, "A12", "ПЛИС\n(LFE5U-45F)\n\nприём отсчётов\n8 каналов,\nкорреляторы\n≥ 64 канала,\nзахват (БПФ),\nшкала времени,\n1PPS, режекция\nпомех,\nкоммутатор\nпотока USB"),
    "mcu": (320, 170, 48, 70, "A13", "Микро-\nконтроллер\n(STM32H743)\n\nпетли слежения,\nдекодирование,\nнавигационное\nрешение,\nпротоколы"),
    "usb": (320, 112, 48, 40, "A14", "Контроллер\nUSB 3.0\n(CYUSB3014)\nпоток ПЧ\n768 Мбит/с"),
    "pwr": (75, 60, 42, 40, "A15", "Источники\nвторичного\nпитания\n5 В -> 3,3/2,5/\n1,2/1,1 В"),
    "ifc": (320, 60, 48, 40, "A16", "Интерфейсы:\nUART, I2C,\nCAN FD,\nmicroSD,\nпорт времени"),
}
BANDS = ["L1/E1/B1C/B1I 1568,000", "G1 (ГЛОНАСС L1) 1602,000", "L2C 1227,600", "G2 (ГЛОНАСС L2) 1246,000",
         "L5/E5a/B2a 1176,450", "E5b/B2b/L3OC 1207,140", "B3I 1268,520", "E6/L6 1278,750"]


def box(c, x, y, w, h, ref, text, dashed=False):
    c.setLineWidth(0.5 * mm)
    if dashed:
        c.setDash(4, 2)
    c.rect(x * mm, y * mm, w * mm, h * mm)
    c.setDash()
    lines = text.split("\n")
    n = len(lines)
    for i, ln in enumerate(lines):
        E._fit(c, ln, x + w / 2, y + h / 2 + (n / 2 - i - 0.8) * 4.3, w - 2, 3.0)
    if ref:
        E._txt(c, ref, x + 1, y + h + 1.2, 3.5)


def arrow(c, pts, label=None, lpos=0, double=False, w=0.35):
    c.setLineWidth(w * mm)
    p = c.beginPath()
    p.moveTo(pts[0][0] * mm, pts[0][1] * mm)
    for x, y in pts[1:]:
        p.lineTo(x * mm, y * mm)
    c.drawPath(p, stroke=1, fill=0)

    def head(a, b):
        import math
        ang = math.atan2(b[1] - a[1], b[0] - a[0])
        L, W = 3.0, 0.9
        x, y = b
        q = c.beginPath()
        q.moveTo(x * mm, y * mm)
        q.lineTo((x - L * math.cos(ang) + W * math.sin(ang)) * mm, (y - L * math.sin(ang) - W * math.cos(ang)) * mm)
        q.lineTo((x - L * math.cos(ang) - W * math.sin(ang)) * mm, (y - L * math.sin(ang) + W * math.cos(ang)) * mm)
        q.close()
        c.drawPath(q, stroke=1, fill=1)
    head(pts[-2], pts[-1])
    if double:
        head(pts[1], pts[0])
    if label:
        a, b = pts[lpos], pts[lpos + 1]
        E._txt(c, label, (a[0] + b[0]) / 2, (a[1] + b[1]) / 2 + 1.0, 2.5, "center")


def main(path):
    meta = E.Meta(designation="ШИВА.468157.001 Э1", title="Модуль приемника ГНСС МГП-8",
                  doctype="Схема электрическая структурная", company="ООО ШИВА НЕТВОРК", lit="Э", dev="Разработчик",
                  format="A3", date="10.2026")
    c = canvas.Canvas(path, pagesize=landscape(A3))
    c.setTitle("Схема электрическая структурная")
    for k, (x, y, w, h, ref, t) in BLOCKS.items():
        box(c, x, y, w, h, ref, t, dashed=(k == "ant"))
    # ВЧ-каналы
    y0 = 262
    for i, band in enumerate(BANDS):
        y = y0 - i * 17
        box(c, 180, y - 6, 52, 13, f"A{3 + i}", f"ВЧ-канал {i + 1}\n{band} МГц")
        arrow(c, [(164, 218), (172, 218), (172, y), (180, y)])
        arrow(c, [(232, y), (250, min(max(y, 124), 248))], None)
        # опорная частота к каналу
    arrow(c, [(62, 218), (75, 218)], "ВЧ")
    arrow(c, [(117, 218), (130, 218)], "ВЧ")
    arrow(c, [(75, 210), (62, 210)], "Uпит.ант")
    # опора и тактирование
    arrow(c, [(117, 160), (176, 160), (176, 136), (206, 136), (206, 140)], "24 МГц (8 вых.)")
    arrow(c, [(117, 140), (250, 140)], "Fд 24 МГц", lpos=0)
    E._txt(c, "Вход опоры 10 МГц / 1PPS", 28, 150, 2.5)
    arrow(c, [(28, 147), (75, 147)])
    # ПЛИС <-> МК, USB
    arrow(c, [(302, 200), (320, 200)], "FMC", double=True)
    arrow(c, [(302, 132), (320, 132)], "GPIF 32", double=False)
    arrow(c, [(368, 132), (395, 132)], "USB 3.0")
    E._txt(c, "к ПК", 385, 125, 2.5)
    arrow(c, [(302, 160), (395, 160)], "1PPS", lpos=0)
    E._txt(c, "выход 1PPS (SMA)", 372, 153, 2.5)
    arrow(c, [(344, 170), (344, 100)], "UART/CAN", double=True)
    E._txt(c, "к полётному контроллеру", 372, 74, 2.5)
    arrow(c, [(368, 80), (395, 80)], None, double=True)
    arrow(c, [(250, 126), (232, 126), (232, 110), (196, 110), (196, 112)], None)
    E._txt(c, "SPI (настройка ВЧ-каналов)", 198, 106, 2.5)
    # питание
    E._txt(c, "5 В (USB / порт GPS / порт CAN)", 28, 92, 2.5)
    arrow(c, [(28, 88), (75, 88)])
    arrow(c, [(117, 80), (140, 80)], "+3,3 / +2,5 / +1,2 / +1,1 В ко всем блокам")
    # пояснения
    notes = ["1. Обозначения блоков A1…A16 соответствуют функциональным узлам схемы ШИВА.468157.001 Э3:",
             "   A1 — лист 3; A2 — лист 3; A3…A10 — листы 4, 5; A11 — лист 6; A12 — листы 7, 8; A13 — лист 9;",
             "   A14 — лист 10; A15 — лист 2; A16 — листы 9, 11.",
             "2. Активная антенна в состав изделия не входит (показана штриховой линией).",
             "3. Частоты гетеродинов ВЧ-каналов указаны для конфигурации по умолчанию и задаются программно."]
    for i, n in enumerate(notes):
        E._txt(c, n, 28, 44 - i * 5, 3.0)
    E.draw_frame(c, 420, 297, meta, 1, 1, first=True, form_first="1")
    c.showPage()
    c.save()


if __name__ == "__main__":
    main(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "kd", "ШИВА.468157.001 Э1.pdf"))
