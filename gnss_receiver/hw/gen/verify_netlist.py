"""Сверка списка соединений, выгруженного KiCad (kicad-cli sch export netlist), с моделью схемы.

Проверяет, что разбиение выводов на цепи в KiCad совпадает с моделью design.py (с точностью
до имён цепей), что все компоненты присутствуют и что неподключённые выводы совпадают.
"""
import os
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from sexp import loads, find, first  # noqa: E402


def kicad_nets(netfile):
    root = loads(open(netfile, encoding="utf-8").read())
    nets = {}
    for n in find(first(root, "nets"), "net"):
        name = str(first(n, "name")[1])
        nodes = frozenset((str(first(x, "ref")[1]), str(first(x, "pin")[1])) for x in find(n, "node"))
        nets[name] = nodes
    comps = {str(first(c, "ref")[1]) for c in find(first(root, "components"), "comp")}
    return nets, comps


def compare(design, netfile):
    kn, kcomps = kicad_nets(netfile)
    model = {}
    for net, pins in design.nets().items():
        model[net] = frozenset((c.ref, p) for c, p in pins)
    msets = {v: k for k, v in model.items()}
    problems = []
    kmulti = {k: v for k, v in kn.items() if len(v) > 1 or not k.startswith("unconnected")}
    for name, nodes in kmulti.items():
        if len(nodes) == 1 and name.startswith("unconnected"):
            continue
        if nodes not in msets:
            # одиночные выводы без цепи в модели (NC) допустимы только как unconnected
            mnames = {n for n, s in model.items() if s & nodes}
            problems.append(f"KiCad цепь {name} ({len(nodes)} выв.) не совпадает с моделью: {sorted(mnames)[:5]}")
    kset = set(kmulti.values())
    for name, nodes in model.items():
        if nodes not in kset:
            problems.append(f"Цепь модели {name} не найдена в KiCad")
    mcomps = {c.ref for c in design.comps}
    if mcomps != kcomps:
        problems.append(f"Компоненты различаются: {sorted(mcomps ^ kcomps)[:10]}")
    # неподключённые выводы
    model_nc = {(c.ref, p) for c in design.comps for p, n in c.conns.items() if n is None}
    k_single = {next(iter(v)) for k, v in kn.items() if len(v) == 1}
    if model_nc != k_single:
        problems.append(f"Неподключённые выводы различаются: {len(model_nc ^ k_single)} шт., "
                        f"пример {sorted(model_nc ^ k_single)[:6]}")
    return problems


def main(outdir):
    import build
    d = build.main()
    net = os.path.join(tempfile.mkdtemp(), "mgp8.net")
    subprocess.run(["kicad-cli", "sch", "export", "netlist", "-o", net, os.path.join(outdir, "mgp8.kicad_sch")],
                   check=True, capture_output=True)
    probs = compare(d, net)
    if probs:
        print("РАСХОЖДЕНИЯ:")
        for p in probs[:50]:
            print("  ", p)
        sys.exit(1)
    print("Список соединений KiCad совпадает с моделью схемы: OK")


if __name__ == "__main__":
    main(os.path.join(HERE, "..", "kicad"))
