"""Изображения 3D-модели платы МГП-8 (kicad-cli pcb render) — каталог hw/3d.

Запуск (из gnss_receiver): sh tools/win/run.sh 'python3 hw/gen/render3d.py'.
Плата не меняется: рендер идёт по копии в build/3d. В библиотеке 3D-моделей KiCad 10 нет
файлов для части корпусов, на которые ссылаются посадочные места (ПЛИС caBGA-381, MAX2771
TQFN-28, ТКГ TG2520SMN и др.), — в копии они заменены корпусами тех же размеров
(для ПЛИС — BGA-256 17×17 мм, шаг выводов другой). Экраны показаны рамками без крышек,
делители Уилкинсона — только площадками (моделей нет).
"""
import os
import shutil
import subprocess
import sys

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
PCB = os.path.join(ROOT, "hw", "kicad", "mgp8.kicad_pcb")
WORK = os.path.join(ROOT, "build", "3d")
OUT = os.path.join(ROOT, "hw", "3d")

SUBST = {
    "Package_BGA.3dshapes/Lattice_caBGA-381_17x17mm_Layout20x20_P0.8mm.step":
        "Package_BGA.3dshapes/BGA-256_17.0x17.0mm_Layout16x16_P1.0mm_Ball0.5mm_Pad0.4mm_NSMD.step",
    "Package_DFN_QFN.3dshapes/TQFN-28-1EP_5x5mm_P0.5mm_EP3.25x3.25mm.step":
        "Package_DFN_QFN.3dshapes/QFN-28-1EP_5x5mm_P0.5mm_EP3.35x3.35mm.step",
    "Package_DFN_QFN.3dshapes/VQFN-16-1EP_3x3mm_P0.5mm_EP1.68x1.68mm.step":
        "Package_DFN_QFN.3dshapes/WQFN-16-1EP_3x3mm_P0.5mm_EP1.68x1.68mm.step",
    "Package_DFN_QFN.3dshapes/DHVQFN-20-1EP_2.5x4.5mm_P0.5mm_EP1x3mm.step":
        "Package_DFN_QFN.3dshapes/WQFN-20-1EP_2.5x4.5mm_P0.5mm_EP1x2.9mm.step",
    "Oscillator.3dshapes/Oscillator_SMD_SeikoEpson_TG2520SMN-xxx-xxxxxx-4Pin_2.5x2.0mm.step":
        "Oscillator.3dshapes/Oscillator_SMD_SeikoEpson_SG210-4Pin_2.5x2.0mm.step",
    "Inductor_SMD.3dshapes/L_Coilcraft_XxL4020.step":
        "Inductor_SMD.3dshapes/L_Coilcraft_XAL4020-XXX.step",
}

# имя, сторона, размер, доп. параметры kicad-cli
VIEWS = [
    ("top", "top", (2400, 1800), []),
    ("bottom", "bottom", (2400, 1800), []),
    ("iso", "top", (2400, 1800), ["--perspective", "--rotate", "-55,0,-30", "--zoom", "0.85", "--floor"]),
    ("side", "front", (2400, 800), ["--zoom", "1.6"]),
]


def kicad_cli():
    for p in (os.environ.get("KICAD_CLI"), shutil.which("kicad-cli"),
              r"C:\Program Files\KiCad\10.0\bin\kicad-cli.exe"):
        if p and os.path.exists(p):
            return p
    sys.exit("kicad-cli не найден (переменная KICAD_CLI)")


def main():
    os.makedirs(WORK, exist_ok=True)
    os.makedirs(OUT, exist_ok=True)
    s = open(PCB, encoding="utf-8").read()
    for a, b in SUBST.items():
        s = s.replace(a, b)
    pcb = os.path.join(WORK, "mgp8.kicad_pcb")
    open(pcb, "w", encoding="utf-8", newline="").write(s)
    cli = kicad_cli()
    for name, side, (w, h), extra in VIEWS:
        png = os.path.join(WORK, name + ".png")
        subprocess.run([cli, "pcb", "render", "-o", png, "-w", str(w), "-h", str(h), "--side", side,
                        "--background", "opaque", "--quality", "high", *extra, pcb],
                       check=True, stdout=subprocess.DEVNULL)
        im = Image.open(png).convert("RGB")
        im = im.resize((im.width * 2 // 3, im.height * 2 // 3), Image.LANCZOS)
        jpg = os.path.join(OUT, f"mgp8_{name}.jpg")
        im.save(jpg, quality=88, optimize=True)
        print(jpg, os.path.getsize(jpg) // 1024, "КБ")


if __name__ == "__main__":
    main()
