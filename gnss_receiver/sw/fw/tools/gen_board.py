"""Карта выводов МК STM32H743 для ПО МК — из схемы ШИВА.468157.001 Э3 (лист 9, hw/kicad/09_mcu.kicad_sch).

Запуск (из каталога sw/fw):
  python3 tools/gen_board.py          — записать inc/board_pins.h;
  python3 tools/gen_board.py --check  — сверить inc/board_pins.h со схемой (код возврата 1 — расхождение).

Соединения восстанавливаются по геометрии листа KiCad (концы выводов символа МК, проводники,
метки цепей), т. е. по самой схеме, а не по её модели hw/gen/design.py; KiCad не нужен.
Имя макроса — PIN_<цепь>, значение — PIN(порт, номер). Платформенная часть (src/plat/) задаёт
режимы выводов только через эти макросы, поэтому переназначение вывода на схеме без правки ПО
даёт ошибку проверки, а удаление цепи — ошибку сборки.
"""
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
FW = os.path.dirname(HERE)
HW = os.path.abspath(os.path.join(FW, "..", "..", "hw"))
SHEET = os.path.join(HW, "kicad", "09_mcu.kicad_sch")
OUT = os.path.join(FW, "inc", "board_pins.h")
LIB_ID = "mgp8:STM32H743"
sys.path.insert(0, os.path.join(HW, "gen"))
from sexp import loads, find, first  # noqa: E402


def _pt(x, y):
    return (round(float(x), 2), round(float(y), 2))


def _xf(px, py, rot):
    """Координаты вывода в символе (y вверх) -> смещение на листе (y вниз) при повороте rot."""
    x, y = px, -py
    return {0: (x, y), 90: (y, -x), 180: (-x, -y), 270: (-y, x)}[int(float(rot)) % 360]


def _on_seg(p, a, b):
    (x, y), (x1, y1), (x2, y2) = p, a, b
    if (x2 - x1) * (y - y1) != (y2 - y1) * (x - x1):
        return False
    return min(x1, x2) <= x <= max(x1, x2) and min(y1, y2) <= y <= max(y1, y2)


def mcu_pins(path=SHEET):
    root = loads(open(path, encoding="utf-8").read())
    lib = next(s for s in find(first(root, "lib_symbols"), "symbol") if str(s[1]) == LIB_ID)
    base = LIB_ID.split(":")[1]
    unit_pins = {}  # unit -> [(name, num, x, y)]
    for sub in find(lib, "symbol"):
        m = re.fullmatch(re.escape(base) + r"_(\d+)_\d+", str(sub[1]))
        for p in find(sub, "pin"):
            at = first(p, "at")
            unit_pins.setdefault(int(m.group(1)), []).append(
                (str(first(p, "name")[1]), str(first(p, "number")[1]), float(at[1]), float(at[2])))

    pins, refs = [], set()  # (точка на листе, имя вывода, номер)
    for inst in find(root, "symbol"):
        if not first(inst, "lib_id") or str(first(inst, "lib_id")[1]) != LIB_ID:
            continue
        if first(inst, "mirror"):
            raise SystemExit("зеркальное размещение символа МК не поддержано")
        refs |= {str(p[2]) for p in find(inst, "property") if str(p[1]) == "Reference"}
        at, unit = first(inst, "at"), int(first(inst, "unit")[1])
        for name, num, px, py in unit_pins.get(unit, []) + unit_pins.get(0, []):
            dx, dy = _xf(px, py, at[3])
            pins.append((_pt(float(at[1]) + dx, float(at[2]) + dy), name, num))
    if len(refs) != 1:
        raise SystemExit(f"на листе {path} символов МК: {sorted(refs)}")

    wires = [tuple(_pt(xy[1], xy[2]) for xy in find(first(w, "pts"), "xy")) for w in find(root, "wire")]
    labels = [(_pt(first(lb, "at")[1], first(lb, "at")[2]), str(lb[1]))
              for kind in ("label", "global_label", "hierarchical_label") for lb in find(root, kind)]

    parent = {}

    def top(p):
        parent.setdefault(p, p)
        while parent[p] != p:
            parent[p] = parent[parent[p]]
            p = parent[p]
        return p

    def join(a, b):
        parent[top(a)] = top(b)

    points = {p for p, *_ in pins} | {p for p, _ in labels} | {e for w in wires for e in w}
    for a, b in wires:
        join(a, b)
        for p in points:
            if _on_seg(p, a, b):
                join(p, a)
    names = {}
    for p, net in labels:
        names.setdefault(top(p), set()).add(net)

    out = []
    for p, name, num in pins:
        m = re.fullmatch(r"P([A-K])(\d+)(?:_C)?", name)
        nets = names.get(top(p), set())
        if len(nets) > 1:
            raise SystemExit(f"вывод {name} ({num}) соединён с несколькими цепями: {sorted(nets)}")
        if m and nets:
            out.append((nets.pop(), m.group(1), int(m.group(2)), num))
    return refs.pop(), sorted(out, key=lambda p: (p[1], p[2]))


def render(ref, pins):
    lines = [
        "/* МГП-8: выводы МК STM32H743VIT6 (" + ref + ") по схеме ШИВА.468157.001 Э3, лист 9.",
        " * Создан tools/gen_board.py из hw/kicad/09_mcu.kicad_sch — не править вручную;",
        " * сверка со схемой — make -C sw/fw board-check. PIN(порт, n): порт A = 0 … K = 10. */",
        "#ifndef BOARD_PINS_H",
        "#define BOARD_PINS_H",
        "",
        "#define PIN(port, n)   ((PORT_##port << 4) | (n))",
        "#define PIN_PORT(p)    ((p) >> 4)",
        "#define PIN_NUM(p)     ((p) & 15)",
        "enum { PORT_A, PORT_B, PORT_C, PORT_D, PORT_E, PORT_F, PORT_G, PORT_H, PORT_I, PORT_J, PORT_K };",
        "",
    ]
    w = max(len(n) for n, *_ in pins) + 5
    for net, port, n, num in pins:
        lines.append(f"#define {('PIN_' + net).ljust(w)} PIN({port}, {n:2d})   /* вывод {num} */")
    lines += ["", "#endif", ""]
    return "\n".join(lines)


def main():
    ref, pins = mcu_pins()
    bad = [n for n, *_ in pins if not re.fullmatch(r"[A-Z][A-Z0-9_]*", n)]
    if bad:
        raise SystemExit(f"имена цепей не годятся для макросов: {bad}")
    text = render(ref, pins)
    if "--check" in sys.argv:
        old = open(OUT, encoding="utf-8").read() if os.path.exists(OUT) else ""
        if old.replace("\r\n", "\n") != text:
            print(f"{OUT}: не совпадает со схемой (запустить python3 tools/gen_board.py)")
            sys.exit(1)
        print(f"Карта выводов МК совпадает со схемой Э3: {len(pins)} выводов")
        return
    with open(OUT, "w", encoding="utf-8", newline="\n") as f:
        f.write(text)
    print(f"{OUT}: {len(pins)} выводов")


if __name__ == "__main__":
    main()
