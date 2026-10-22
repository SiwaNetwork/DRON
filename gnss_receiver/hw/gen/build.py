"""Сборка проекта KiCad схемы МГП-8 и проверка списка соединений.

Запуск: python3 hw/gen/build.py [--pdf]  (из каталога gnss_receiver);
--pdf — дополнительно выгрузить kd/ШИВА.468157.001 Э3.pdf через kicad-cli со шрифтом tools/fonts/osifont-mgp8.ttf."""
import json
import os
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import design  # noqa: E402
import footprints  # noqa: E402
import kicad_out  # noqa: E402

ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
OUT = os.path.join(ROOT, "hw", "kicad")

META = dict(
    title="Модуль приёмника ГНСС МГП-8",
    doctype="Схема электрическая принципиальная",
    designation="ШИВА.468157.001 Э3",
    company="ООО ШИВА НЕТВОРК",
    date="08.10.2026",
    lit="Э",
    dev="Разработчик",
    chk="", app="", tch="", nch="",
    notes=[
        "Технические требования",
        "1. Позиционные обозначения элементов — по ГОСТ 2.710-81. Перечень элементов — ШИВА.468157.001 ПЭ3.",
        "2. Многовыводные микросхемы показаны по частям (DD1.1 … DD1.8); одноимённые выводы питания "
        "и общего провода объединены, номера выводов приведены в таблицах на листах.",
        "3. Связи между листами показаны глобальными метками цепей; цепи питания — знаками питания.",
        "4. Знаком «X» отмечены неподключаемые выводы. Неиспользуемые выводы ПЛИС и МК не подключены.",
        "5. Элементы с пометкой «DNP» в ПЭ3 устанавливаются по заказу.",
        "6. Линии RF_ANT, RF_DIV_IN, RF_S*, RF1…RF8 выполнять с волновым сопротивлением 50 Ом (копланарная линия "
        "с заземлённым основанием), длины от делителя до каналов выравнивать с точностью ±0,5 мм.",
        "7. ВЧ-каналы 1–4 и 5–8 закрывать экранами (рамка MS448-10F с крышкой MS448-10C).",
        "8. Цепи MAX_I*, MAX_Q*, ADC_CLK_*, ADC_SCLK трассировать с выравниванием длин ±2 мм внутри группы.",
        "9. Цепи USB 3.0 (SS*) — дифференциальные пары 90 Ом; USB 2.0 (USB_DP/DM) — 90 Ом.",
    ],
)


def main():
    d = design.build()
    errs, warns = d.erc()
    proj, layouts = kicad_out.write_project(d, OUT, META)
    print("Листы:", {k: v[0] for k, v in layouts.items()})
    print(f"Компонентов: {len(d.comps)}, цепей: {len(d.nets())}")
    print("ERC модели: ошибок", len(errs), "предупреждений", len(warns))
    for e in errs + warns:
        print("  ", e)
    # распиновка ПЛИС для сборки конфигурации
    with open(os.path.join(ROOT, "hw", "gen", "data", "fpga_pinout.json"), "w") as f:
        json.dump(d.fpga_pins, f, indent=1, sort_keys=True)
    # узлы схемы по позиционным обозначениям — для размещения на плате (hw/gen/pcb.py)
    blocks = {c.ref: [c.sheet, c.block] for c in d.comps}
    with open(os.path.join(ROOT, "hw", "gen", "data", "blocks.json"), "w") as f:
        json.dump(blocks, f, indent=0, sort_keys=True)
    print("Посадочные места mgp8.pretty:", len(footprints.write_lib()))
    return d


def export_pdf():
    """Э3 в PDF. Шрифт osifont подключается своим fonts.conf только для kicad-cli (в систему не ставится)."""
    import symlib
    from verify_netlist import kicad_cli
    cli = kicad_cli()
    kicad_fc = os.path.join(os.path.dirname(os.path.dirname(cli)), "etc", "fonts", "fonts.conf")
    base = kicad_fc if os.path.exists(kicad_fc) else "/etc/fonts/fonts.conf"
    tmp = tempfile.mkdtemp()
    conf = os.path.join(tmp, "fonts.conf")

    def fwd(path):
        return path.replace(os.sep, "/")
    lines = ['<?xml version="1.0"?>',
             '<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">',
             "<fontconfig>",
             f"  <dir>{fwd(os.path.join(ROOT, 'tools', 'fonts'))}</dir>",
             f'  <include ignore_missing="yes">{fwd(base)}</include>',
             f"  <cachedir>{fwd(tmp)}/cache</cachedir>",
             "</fontconfig>"]
    with open(conf, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")
    pdf = os.path.join(ROOT, "kd", f"{META['designation']}.pdf")
    r = subprocess.run([cli, "sch", "export", "pdf", "-o", pdf, os.path.join(OUT, "mgp8.kicad_sch")],
                       env=dict(os.environ, FONTCONFIG_FILE=conf), capture_output=True, text=True)
    if r.returncode or "not found" in (r.stdout + r.stderr):
        sys.exit(f"kicad-cli: {r.stdout}{r.stderr}")
    print("Э3:", pdf, f"(KiCad: {symlib.KICAD_SYM})")


if __name__ == "__main__":
    main()
    if "--pdf" in sys.argv[1:]:
        export_pdf()
