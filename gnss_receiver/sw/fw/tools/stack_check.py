#!/usr/bin/env python3
"""МГП-8: оценка наибольшей глубины стека ПО МК и загрузчика.

Граф вызовов и кадры функций проекта — из файлов GCC -fcallgraph-info=su (*.ci рядом с *.o);
функции библиотек (newlib-nano, libm, libgcc) — по дизассемблированному ELF (push/vpush/sub sp
в прологе и вызовы bl/b.w). Косвенные вызовы разрешаются таблицей INDIRECT (место вызова ->
возможные функции); неизвестный косвенный вызов или рекурсия в коде проекта — ошибка, рекурсия
в библиотеке — предупреждение (учтён один уровень).

Наихудший случай — поток (Reset_Handler -> main) и по одному вложенному обработчику на каждый
уровень приоритета (уровни — plat/plat.h) плюс кадр исключения с регистрами FPU (108 байт) на
каждый уровень. Обработчик отказов работает на отдельном стеке (вершина DTCM).

  stack_check.py build/mcu/mgp8.elf build/mcu/src/app.o ... build/mcu/plat/main.o
"""
import re
import subprocess
import sys
from pathlib import Path

FRAME = 108                                  # 26 слов кадра с FPU + выравнивание
# уровни приоритета: на каждом — наибольший из обработчиков (одного уровня не вкладываются)
LEVELS = [
    ("PendSV 0xF0", ["PendSV_Handler"]),
    ("SysTick 0x30", ["SysTick_Handler"]),
    ("ПЛИС 0x20", ["EXTI9_5_IRQHandler"]),
    ("UART 0x10", ["USART1_IRQHandler", "UART4_IRQHandler"]),
    ("АЦП 0x00", ["ADC_IRQHandler"]),
]
# косвенные вызовы: «файл:строка» места вызова -> функции
INDIRECT = {
    "src/app.c:15": ["irq_lock"],                         # rx->lock
    "src/rx.c:56": ["irq_lock"],
    "src/app.c:87": ["plat/main.c:nmea_out"],             # app->out
    "src/app.c:88": ["plat/main.c:nmea_out"],
    "src/app.c:89": ["plat/main.c:nmea_out"],
    "src/app.c:90": ["plat/main.c:nmea_out"],
    "src/app.c:91": ["plat/main.c:nmea_out"],
    "src/app.c:92": ["plat/main.c:nmea_out"],
    "src/track.c:113": ["src/rx.c:on_bit"],               # trk->on_bit
    "plat/sched.c:27": ["plat/main.c:t_acq", "plat/main.c:t_cmd", "plat/main.c:t_led", "plat/main.c:t_tm"],
    "src/bootp.c:69": ["plat/boot.c:io_prog"],            # io->prog, io->erase, b->send
    "src/bootp.c:93": ["plat/boot.c:io_erase"],
    "src/bootp.c:118": ["plat/boot.c:send_gps", "plat/boot.c:send_dbg"],
}

NODE = re.compile(r'node: \{ title: "([^"]+)" label: "([^"]*)"')
EDGE = re.compile(r'edge: \{ sourcename: "([^"]+)" targetname: "([^"]+)"(?: label: "([^"]*)")?')


def load_ci(objs):
    frame, calls, where = {}, {}, {}
    for o in objs:
        ci = Path(o).with_suffix(".ci")
        for line in ci.read_text(encoding="utf-8", errors="replace").splitlines():
            m = NODE.search(line)
            if m:
                parts = m.group(2).split("\\n")
                if len(parts) >= 3:
                    sz = re.match(r"(\d+) bytes \(([^)]*)\)", parts[2])
                    if sz:
                        if sz.group(2) != "static" and "bounded" not in sz.group(2):
                            sys.exit("stack_check: %s — динамический кадр (%s)" % (m.group(1), sz.group(2)))
                        frame[m.group(1)] = int(sz.group(1))
                        where[m.group(1)] = parts[1]
                        calls.setdefault(m.group(1), set())
                continue
            m = EDGE.search(line)
            if m:
                src, dst, lab = m.groups()
                if dst == "__indirect_call":
                    key = ":".join((lab or "?").split(":")[:2])
                    if key not in INDIRECT:
                        sys.exit("stack_check: неизвестный косвенный вызов в %s (%s)" % (src, lab))
                    calls.setdefault(src, set()).update("?" + t for t in INDIRECT[key])
                else:
                    calls.setdefault(src, set()).add(dst)
    return frame, calls, where


def load_elf(elf):
    """кадры и вызовы функций по дизассемблированию (для библиотек)"""
    out = subprocess.run(["arm-none-eabi-objdump", "-d", "--no-show-raw-insn", elf],
                         capture_output=True, text=True, check=True).stdout
    frame, calls, at, selfrec, cur = {}, {}, {}, set(), None
    fn = re.compile(r"^([0-9a-f]+) <([^>]+)>:$")
    for line in out.splitlines():
        m = fn.match(line)
        if m:
            cur = m.group(2)
            frame[cur], calls[cur] = 0, set()
            at[int(m.group(1), 16)] = cur
            continue
        if not cur or "\t" not in line:
            continue
        ins = line.split("\t", 1)[1].strip()
        op = ins.split()[0] if ins else ""
        if op in ("push", "push.w") or (op.startswith("stmdb") and ins.split()[1].startswith("sp!")):
            frame[cur] += 4 * len(regs(ins))
        elif op == "vpush":
            frame[cur] += 8 * len(regs(ins))
        elif op in ("sub", "sub.w", "subw") and re.search(r"\bsp, (sp, )?#", ins):
            frame[cur] += int(re.search(r"#(\d+)", ins).group(1))
        m = re.search(r"\b(b[a-z]*(?:\.[wn])?)\s+[0-9a-f]+ <([^>+]+)>", ins)
        if m and m.group(2) == cur:
            selfrec.add(cur)                 # самовызов (переход на свои метки — «<f+0x..>»)
        elif m:
            calls[cur].add(m.group(2))
    # псевдонимы по одному адресу (sprintf = siprintf, …): objdump подписывает один из них
    nm = subprocess.run(["arm-none-eabi-nm", elf], capture_output=True, text=True, check=True).stdout
    for a, t, name in re.findall(r"^([0-9a-f]+) ([TtWw]) (\S+)$", nm, re.M):
        a = int(a, 16) & ~1
        if name not in frame and a in at:
            frame[name], calls[name] = frame[at[a]], calls[at[a]]
            if at[a] in selfrec:
                selfrec.add(name)
    return frame, calls, selfrec


def regs(ins):
    lst = re.search(r"\{([^}]*)\}", ins).group(1)
    n = []
    for r in lst.split(","):
        r = r.strip()
        if "-" in r:
            a, b = r.split("-")
            n += range(int(a[1:]), int(b[1:]) + 1)
        elif r:
            n.append(r)
    return n


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    elf, objs = sys.argv[1], sys.argv[2:]
    frame, calls, where = load_ci(objs)
    lfr, lcalls, lself = load_elf(elf)
    syms = subprocess.run(["arm-none-eabi-nm", elf], capture_output=True, text=True, check=True).stdout
    limit = int(re.search(r"^([0-9a-f]+) \w _stack_size$", syms, re.M).group(1), 16)
    memo, warn = {}, set()

    def depth(f, path):
        indirect = f.startswith("?")
        f = f.lstrip("?")
        if f not in frame and f not in lfr:
            if indirect:
                return 0, []                 # функции нет в этом образе
            sys.exit("stack_check: нет данных о функции %s (вызов из %s)" % (f, path[-1] if path else "-"))
        if f in path:
            if f in frame:
                sys.exit("stack_check: рекурсия %s" % " -> ".join(path + [f]))
            warn.add(f)                      # рекурсия в библиотеке (qsort): один уровень
            return 0, []
        if f in memo:
            return memo[f]
        if f not in frame and f in lself:
            warn.add(f)
        own = frame[f] if f in frame else lfr[f]
        sub = calls.get(f, set()) if f in frame else lcalls.get(f, set())
        best, chain = 0, []
        for g in sorted(sub):
            d, c = depth(g, path + [f])
            if d > best:
                best, chain = d, c
        memo[f] = (own + best, [f] + chain)
        return memo[f]

    total, rows = 0, []
    d, c = depth("Reset_Handler", [])
    rows.append(("поток", d, c))
    total += d
    for name, hs in LEVELS:
        cand = [depth(h, []) for h in hs if h in frame]
        if not cand:
            continue
        d, c = max(cand)
        rows.append((name, d + FRAME, c))
        total += d + FRAME
    print("stack_check: %s" % elf)
    for name, d, c in rows:
        print("  %-13s %6d  %s" % (name, d, " -> ".join(x.split(":")[-1] for x in c[:8]) + (" …" if len(c) > 8 else "")))
    print("  итого %d из %d байт (запас %d)" % (total, limit, limit - total))
    if warn:
        print("  рекурсия в библиотеке (учтён один уровень): %s" % ", ".join(sorted(warn)))
    if total > limit:
        sys.exit("stack_check: стек переполнен")


if __name__ == "__main__":
    main()
