"""Печатная плата МГП-8 (ШИВА.468157.001): размещение, скриптовая трассировка ВЧ и тактовых цепей,
автотрассировка остальных цепей Freerouting, проверка DRC.

Запуск (из каталога gnss_receiver, интерпретатор Python из комплекта KiCad 10):
  python hw/gen/pcb.py place    — плата без трассировки остальных цепей + DSN для Freerouting
  python hw/gen/pcb.py route    — Freerouting (java -jar freerouting.jar), результат .ses
  python hw/gen/pcb.py more [чч:мм:сс] — доразводка от результата предыдущего прохода (переходы к слоям
                                         земли и питания скриптом, Freerouting без разводки выводов BGA)
  python hw/gen/pcb.py finish   — импорт .ses, заливки внешних слоёв, сохранение hw/kicad/mgp8.kicad_pcb, DRC
Промежуточные файлы — в %TEMP%/mgp8pcb/proj.

Стек (1,6 мм, 8 слоёв, FR-4 Tg 170, ENIG): L1 F.Cu сигналы и ВЧ (копланарная линия с землёй),
L2 In1 GND, L3 In2 сигналы (полосковые линии ВЧ-входов каналов, тактовые линии ADC_CLK), L4 In3 GND,
L5 In4 питание (островки +3V3_RF1…4, +3V3_CLK, +1V1, +1V2_FX3, остальное +3V3D), L6 In5 сигналы,
L7 In6 GND, L8 B.Cu сигналы и блокировочные конденсаторы ПЛИС.
"""
import json
import fnmatch
import glob
import math
import os
import shutil
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import pcbnew  # noqa: E402
from shapely.geometry import box  # noqa: E402
from shapely.ops import unary_union  # noqa: E402

from pcb_place import MM, Placer, mm  # noqa: E402
from sexp import find, first, loads  # noqa: E402

ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
KICAD = os.path.join(ROOT, "hw", "kicad")
TMP = os.path.join(os.environ.get("TEMP", "/tmp"), "mgp8pcb", "proj")
CLI = os.path.join(os.path.dirname(sys.executable), "kicad-cli.exe" if os.name == "nt" else "kicad-cli")
FPDIR = os.path.join(os.path.dirname(os.path.dirname(sys.executable)), "share", "kicad", "footprints")
FREEROUTING = r"C:\tools\freerouting\freerouting.jar"

OX, OY, W, H = 50.0, 50.0, 100.0, 75.0          # контур платы: левый верхний угол и размеры, мм
COMPANY = "ООО ШИВА НЕТВОРК"

# --- правила (ГОСТ Р 53429, класс точности 5) ---------------------------------------------------
RULES = dict(clearance=0.1, track=0.1, via=0.4, drill=0.2, ring=0.1, edge=0.3, hole_clr=0.2, hole_hole=0.25)
# класс: (ширина, зазор)
CLASSES = {
    "Default": (0.15, 0.1),
    "PWR": (0.2, 0.1),
    "PWR5": (0.4, 0.1),
    "RF": (0.32, 0.15),
    "CLK": (0.15, 0.15),
}
PATTERNS = {
    "PWR5": ["+5V_*", "*VANT_*", "SW_*"],
    "PWR": ["+3V3*", "+1V1", "+1V2*", "+2V5", "VDDA"],
    "RF": ["RF_ANT", "RF_DIV_IN", "RF_S*", "RF?", "*/RFM_*", "LNAIN_*", "LNAO_*", "MIXI_*"],
    "CLK": ["REFCLK_*", "TCXO_*", "ADC_CLK_*", "XTAL_*"],
}
PLANES = {"GND"}
# дополнительные правила проверки (файл mgp8.kicad_dru рядом с платой)
DRU = """(version 1)
# XS2 (USB-C): крепёжные неметаллизированные отверстия разъёма рядом с площадкой корпуса —
# геометрия посадочного места производителя; отступ меди от этих отверстий 0,25 мм
(rule "XS2_npth"
  (constraint edge_clearance (min 0.25mm))
  (condition "A.memberOfFootprint('XS2')"))
"""
# стек: (тип, толщина мм) сверху вниз; медь 35 мкм, FR-4 Tg 170 (er 4,3), покрытие ENIG
STACK = [("copper", 0.035), ("prepreg", 0.2), ("copper", 0.035), ("core", 0.2), ("copper", 0.035),
         ("prepreg", 0.2), ("copper", 0.035), ("core", 0.1), ("copper", 0.035), ("prepreg", 0.2),
         ("copper", 0.035), ("core", 0.2), ("copper", 0.035), ("prepreg", 0.2), ("copper", 0.035)]

# --- ВЧ-каналы ---------------------------------------------------------------------------------
CX = [10.275, 21.025, 31.775, 42.525, 57.475, 68.225, 78.975, 89.725]   # центры ячеек каналов
LET = "ABCDEFGH"
SHIELDS = {"SH1": (26.4, 22.6), "SH2": (73.6, 22.6)}
SH_OUT, SH_IN = (22.65, 9.35), (21.45, 8.15)    # полуразмеры наружного и внутреннего контура рамки
RF_ENTRY_Y, RF_IN_Y = 12.3, 15.2                 # переходы ВЧ-входа канала: снаружи и внутри экрана
DIV_Y0, DIV_DY = 2.8, 3.6                        # ярусы делителя
CLK_TARGET_PAD = 0.0                              # запас длины тактовых линий, мм

DIV_IN_Y = 1.5

# Размещение остальных блоков: (лист, блок, микросхема, целевая точка, стороны для микросхемы).
# Пассивные элементы блока ставятся к выводам, с которыми соединены; блокировочные конденсаторы —
# к выводам питания микросхемы DEC_IC (по кругу).
TOP = (0.5, 0.5, 99.5, 13.4)                      # полоса над экранами
PLAN = [
    ("power", "ldo1", "DA11", (15.1, 34.4), ("F",)),
    ("power", "ldo2", "DA2", (37.7, 34.4), ("F",)),
    ("power", "ldo3", "DA6", (62.3, 34.4), ("F",)),
    ("power", "ldo4", "DA8", (84.9, 34.4), ("F",)),
    ("power", "ldoc", "DA12", (44.6, 35.0), ("F",)),
    ("power", "ldoc12", "DA3", (56.2, 35.0), ("F",)),
    ("clk", "tcxo", "G1", (50.4, 34.2), ("F",)),
    ("clk", "rbuf0", "DD1", (26.4, 34.6), ("F",)),
    ("clk", "rbuf1", "DD3", (73.6, 34.6), ("F",)),
    ("clk", "adcclk", None, (50.5, 36.5), ("B",)),
    ("usb", "mux", "DD11", (85.6, 46.0), ("F",)),
    ("usb", "usbc", "DA27", (87.0, 52.5), ("F", "B")),
    ("usb", "ldo", "DA25", (91.0, 38.0), ("F", "B")),
    ("usb", "dc3", "DA26", (95.0, 36.0), ("F",)),
    ("power", "or1", "DA1", (88.0, 37.0), ("F", "B")),
    ("usb", "fx3x", None, (66.0, 46.0), ("F",)),
    ("usb", "eep", "DD12", (64.5, 53.0), ("F",)),
    ("usb", "fx3led", None, (66.0, 50.0), ("F",)),
    ("usb", "dec+1V2_FX3", None, (76.5, 46.0), ("B",)),
    ("usb", "dec+3V3_FX3", None, (76.5, 46.0), ("B",)),
    ("power", "dc1", "DA9", (20.0, 44.0), ("F",)),
    ("power", "dc2", "DA10", (30.0, 51.0), ("F",)),
    ("power", "ldoa", "DA4", (37.5, 60.0), ("F",)),
    ("power", "or2", "DA5", (12.5, 62.0), ("F",)),
    ("power", "or3", "DA7", (24.5, 62.0), ("F",)),
    ("power", "bulk5", None, (16.0, 40.0), ("F",)),
    ("power", "mon", "HL1", (8.0, 36.5), ("F",)),
    ("clk", "ref", "DA23", (9.0, 45.5), ("F",)),
    ("clk", "pps", "DD6", (9.0, 56.5), ("F",)),
    ("clk", "pps2", "DD2", (31.0, 62.0), ("F",)),
    ("clk", "ext", "DD4", (37.0, 62.5), ("F",)),
    ("io", "gps", "DA28", (10.0, 66.0), ("B", "F")),
    ("io", "time", "DA30", (34.5, 66.0), ("B", "F")),
    ("mcu", "can", "DA24", (24.5, 66.0), ("B", "F")),
    ("mcu", "osc", None, (68.5, 65.5), ("F",)),
    ("mcu", "sys", None, (68.5, 65.5), ("B",)),
    ("mcu", "sd", None, (82.0, 60.0), ("F", "B")),
    ("mcu", "swd", "X3", (50.0, 66.0), ("F",)),
    ("mcu", "leds", None, (60.0, 61.0), ("F",)),
    ("fpga2", "flash", "DD8", (36.5, 44.5), ("F", "B")),
    ("fpga2", "cfgpu", None, (50.0, 51.0), ("F", "B")),
    ("fpga2", "jtag", "X1", (14.0, 50.0), ("F",)),
    ("fpga2", "dbg", "X2", (26.0, 57.0), ("F",)),
    ("fpga2", "led", None, (50.0, 62.0), ("F",)),
    ("fpga2", "dec_+1V1", None, (50.0, 51.0), ("B",)),
    ("fpga2", "dec_+2V5", None, (50.0, 51.0), ("B",)),
    ("fpga2", "dec_+3V3D", None, (50.0, 51.0), ("B",)),
    ("ant", "in", None, (10.5, 9.0), ("F", "B")),
    ("ant", "sw", "DA13", (21.0, 4.0), ("F", "B")),
    ("ant", "imon", "DA14", (21.0, 9.5), ("F", "B")),
]
DEC_IC = {"adcclk": "DD5", "dec+1V2_FX3": "DD10", "dec+3V3_FX3": "DD10", "sys": "DD9", "bulk5": "DA9",
          "dec_+1V1": "DD7", "dec_+2V5": "DD7", "dec_+3V3D": "DD7"}
REGION = {"ant": TOP}
F_ONLY = {"dc1", "dc2", "dc3", "osc", "fx3x"}     # силовые контуры и кварцы — на одной стороне с микросхемой
TALL = {"X1", "X2", "X3", "X4"}   # вилки высотой 4,5–6,1 мм — только сверху (высота модуля не более 12 мм)


def ymax(k):
    return 20.6 if k < 2 else 21.1                # MAX2771: верхний диапазон (каналы 1–2) / нижний


def cell(k):
    x0 = (4.95 if k < 4 else 52.15) + 10.725 * (k % 4)
    return (x0 + 0.05, 14.5, x0 + 10.725 - 0.05, 30.7)


# ------------------------------------------------------------------------------------------------
class Libs(dict):
    def __missing__(self, lib):
        return os.path.join(KICAD, "mgp8.pretty") if lib == "mgp8" else os.path.join(FPDIR, lib + ".pretty")


def netlist():
    os.makedirs(TMP, exist_ok=True)
    out = os.path.join(TMP, "mgp8.net")
    subprocess.run([CLI, "sch", "export", "netlist", "--format", "kicadsexpr", "-o", out,
                    os.path.join(KICAD, "mgp8.kicad_sch")], check=True, capture_output=True)
    root = loads(open(out, encoding="utf-8").read())
    comps = {}
    for c in find(first(root, "components"), "comp"):
        ref = str(first(c, "ref")[1])
        props = {}
        for p in find(c, "property"):
            v = first(p, "value")
            props[str(first(p, "name")[1])] = str(v[1]) if v and len(v) > 1 else ""
        sp = first(c, "sheetpath")
        comps[ref] = dict(value=str(first(c, "value")[1]), fp=str(first(c, "footprint")[1]),
                          path=str(first(sp, "tstamps")[1]) + str(first(c, "tstamps")[1]),
                          sheetname=props.get("Sheetname", ""), sheetfile=props.get("Sheetfile", ""),
                          dnp="dnp" in props, nobom="exclude_from_bom" in props)
    pins, nodes = {}, {}
    for n in find(first(root, "nets"), "net"):
        name = str(first(n, "name")[1])
        for x in find(n, "node"):
            r, p = str(first(x, "ref")[1]), str(first(x, "pin")[1])
            pins.setdefault(r, {})[p] = name
            nodes.setdefault(name, []).append((r, p))
    return comps, pins, nodes


def copy_fields(b):
    """Поля символов (Наименование, Изготовитель, Артикул…) — в посадочные места, скрытыми на слое
    сборочного чертежа: иначе проверка соответствия схеме выдаёт предупреждение на каждый элемент."""
    root = loads(open(os.path.join(TMP, "mgp8.net"), encoding="utf-8").read())
    for c in find(first(root, "components"), "comp"):
        fp, fl = b.FindFootprintByReference(str(first(c, "ref")[1])), first(c, "fields")
        if fp is None or not fl:
            continue
        for f in find(fl, "field"):
            name, value = str(first(f, "name")[1]), str(f[2]) if len(f) > 2 else ""
            if fp.HasField(name):
                continue
            fp.SetField(name, value)
            pf = fp.GetField(name)
            pf.SetVisible(False)
            pf.SetLayer(pcbnew.B_Fab if fp.IsFlipped() else pcbnew.F_Fab)


def short(net):
    return net.split("/")[-1]


# ------------------------------------------------------------------------------------------------
class Board:
    def __init__(self, path):
        self.path = path
        self.b = pcbnew.NewBoard(path)
        self.comps, self.pins, self.nodes = netlist()
        self.blocks = json.load(open(os.path.join(HERE, "data", "blocks.json"), encoding="utf-8"))
        self.P = Placer(self.b, OX, OY, W, H, Libs())
        self.nets = {}
        self.items = []          # скриптовые проводники и переходы: (тип, слой/None, геометрия)
        self.setup()

    # --- плата, правила, классы цепей -------------------------------------------------------
    def setup(self):
        b = self.b
        b.SetCopperLayerCount(8)
        for L in (pcbnew.In1_Cu, pcbnew.In3_Cu, pcbnew.In4_Cu, pcbnew.In6_Cu):
            b.SetLayerType(L, pcbnew.LT_POWER)
        ds = b.GetDesignSettings()
        ds.SetBoardThickness(MM(1.6))
        ds.m_MinClearance = MM(RULES["clearance"])
        ds.m_TrackMinWidth = MM(RULES["track"])
        ds.m_ViasMinSize = MM(RULES["via"])
        ds.m_MinThroughDrill = MM(RULES["drill"])
        ds.m_ViasMinAnnularWidth = MM(RULES["ring"])
        ds.m_CopperEdgeClearance = MM(RULES["edge"])
        ds.m_HoleClearance = MM(RULES["hole_clr"])
        ds.m_HoleToHoleMin = MM(RULES["hole_hole"])
        ds.m_SolderMaskMinWidth = 0
        ns = ds.m_NetSettings
        for name, (w, clr) in CLASSES.items():
            nc = ns.GetDefaultNetclass() if name == "Default" else pcbnew.NETCLASS(name)
            nc.SetTrackWidth(MM(w))
            nc.SetClearance(MM(clr))
            nc.SetViaDiameter(MM(0.4))
            nc.SetViaDrill(MM(0.2))
            nc.SetDiffPairWidth(MM(0.15))
            nc.SetDiffPairGap(MM(0.15))
            if name != "Default":
                ns.SetNetclass(name, nc)
        for name, pats in PATTERNS.items():
            for p in pats:
                ns.SetNetclassPatternAssignment(p, name)
        tb = b.GetTitleBlock()
        tb.SetTitle("Модуль приёмника ГНСС МГП-8")
        tb.SetCompany(COMPANY)
        tb.SetComment(0, "ШИВА.468157.001")
        tb.SetRevision("1")
        tb.SetDate("21.10.2026")
        b.SetTitleBlock(tb)
        for name in sorted({n for ps in self.pins.values() for n in ps.values()}):
            ni = pcbnew.NETINFO_ITEM(b, name)
            b.Add(ni)
            self.nets[name] = ni
        # контур
        s = pcbnew.PCB_SHAPE(b)
        s.SetShape(pcbnew.SHAPE_T_RECTANGLE)
        s.SetStart(self.P.V(0, 0))
        s.SetEnd(self.P.V(W, H))
        s.SetLayer(pcbnew.Edge_Cuts)
        s.SetWidth(MM(0.1))
        b.Add(s)

    def net(self, name):
        if name not in self.nets:
            full = [n for n in self.nets if short(n) == name]
            if len(full) != 1:
                raise KeyError(f"цепь {name}: {full}")
            self.nets[name] = self.nets[full[0]]
        return self.nets[name]

    # --- посадочные места -------------------------------------------------------------------
    def add_footprints(self):
        P = self.P
        for ref, c in sorted(self.comps.items()):
            fp = P.load(c["fp"])
            fp.SetReference(ref)
            fp.SetValue(c["value"])
            fp.SetPath(pcbnew.KIID_PATH(c["path"]))
            fp.SetSheetname(c["sheetname"])
            fp.SetSheetfile(c["sheetfile"])
            if c["dnp"]:
                fp.SetDNP(True)
            if c["nobom"]:
                fp.SetExcludedFromBOM(True)
            fp.Reference().SetLayer(pcbnew.F_Fab)
            fp.SetPosition(P.V(-30, -30))
            self.b.Add(fp)
            pn = self.pins.get(ref, {})
            for pad in fp.Pads():
                num = pad.GetNumber()
                net = pn.get(num)
                if net is None and num.startswith("V") and "EP" in pn:
                    net = pn["EP"]          # тепловые переходы под корпусом TQFN — цепь центральной площадки
                if net is None and num == "" and pad.GetAttribute() == pcbnew.PAD_ATTRIB_NPTH:
                    continue
                if net:
                    pad.SetNet(self.net(net))
            P.fps[ref] = fp
        # крепёжные отверстия и рамки экранов — только на плате
        for i, (x, y) in enumerate(((3.2, 3.2), (96.8, 3.2), (3.2, 71.8), (96.8, 71.8)), 1):
            fp = P.load("MountingHole:MountingHole_2.7mm_M2.5")
            fp.SetReference(f"H{i}")
            fp.SetBoardOnly(True)
            fp.SetExcludedFromBOM(True)
            fp.SetExcludedFromPosFiles(True)
            fp.Reference().SetLayer(pcbnew.F_Fab)
            self.b.Add(fp)
            fp.SetPosition(P.V(x, y))
            P.fps[fp.GetReference()] = fp
            P.block(x - 3.0, y - 3.0, x + 3.0, y + 3.0)
            P.where[f"H{i}"] = (x, y, 0, "F")
        for ref, (x, y) in SHIELDS.items():
            fp = P.load("mgp8:SHIELD_MS448-10F")
            fp.SetReference(ref)
            fp.SetValue("MS448-10F")
            fp.Reference().SetLayer(pcbnew.F_Fab)
            self.b.Add(fp)
            fp.SetPosition(P.V(x, y))
            for pad in fp.Pads():
                pad.SetNet(self.net("GND"))
            P.fps[ref] = fp
            P.where[ref] = (x, y, 0, "F")
            (ox, oy), (ix, iy) = SH_OUT, SH_IN
            for x0, y0, x1, y1 in ((-ox, -oy, ox, -iy), (-ox, iy, ox, oy), (-ox, -oy, -ix, oy), (ix, -oy, ox, oy)):
                P.block(x + x0, y + y0, x + x1, y + y1, ("F",))

    # --- поиск элементов --------------------------------------------------------------------
    def refs_in(self, sheet, block=None):
        return sorted(r for r, (s, b) in self.blocks.items() if s == sheet and (block is None or b == block))

    def nets_of(self, ref):
        return {short(n) for n in self.pins.get(ref, {}).values()}

    def part(self, refs, nets):
        hits = [r for r in refs if self.nets_of(r) == set(nets)]
        if len(hits) != 1:
            raise RuntimeError(f"элемент с цепями {nets}: {hits}")
        return hits[0]

    # --- проводники и переходы --------------------------------------------------------------
    def track(self, net, layer, pts, w):
        P = self.P
        for (x0, y0), (x1, y1) in zip(pts, pts[1:]):
            t = pcbnew.PCB_TRACK(self.b)
            t.SetStart(P.V(x0, y0))
            t.SetEnd(P.V(x1, y1))
            t.SetWidth(MM(w))
            t.SetLayer(layer)
            t.SetNet(self.net(net))
            t.SetLocked(True)
            self.b.Add(t)
            if layer in (pcbnew.F_Cu, pcbnew.B_Cu):
                m = w / 2 + 0.15
                P.block(min(x0, x1) - m, min(y0, y1) - m, max(x0, x1) + m, max(y0, y1) + m,
                        ("F",) if layer == pcbnew.F_Cu else ("B",))
            self.items.append(("t", layer, net, (x0, y0, x1, y1), w))

    def via(self, net, x, y, block=True):
        v = pcbnew.PCB_VIA(self.b)
        v.SetPosition(self.P.V(x, y))
        v.SetWidth(MM(RULES["via"]))
        v.SetDrill(MM(RULES["drill"]))
        v.SetNet(self.net(net))
        v.SetLocked(True)
        self.b.Add(v)
        if block:
            self.P.block(x - 0.35, y - 0.35, x + 0.35, y + 0.35)
        self.items.append(("v", None, net, (x, y), RULES["via"]))

    @staticmethod
    def length(pts):
        return sum(math.hypot(x1 - x0, y1 - y0) for (x0, y0), (x1, y1) in zip(pts, pts[1:]))

    # ======================================================================================
    def place_fixed(self):
        P = self.P
        P.put("XW1", 10.5, 2.1, 90, force=True)
        P.put("XW2", 2.1, 45.5, 180, force=True)
        P.put("XW3", 2.1, 56.5, 180, force=True)
        for ref in ("XW1", "XW2", "XW3"):       # площадки земли разъёмов SMA есть и на нижней стороне
            x, y, rot, _ = P.where[ref]
            x0, y0, x1, y1 = P.geo(P.fps[ref].GetFPIDAsString(), rot, "F")["box"]
            P.block(x + x0, y + y0, x + x1, y + y1, ("B",))
        P.put("XS2", 94.27, 46.0, 90, force=True)
        P.put("XS1", 90.62, 60.1, 90, force=True)
        P.put("DD7", 50.0, 51.0, 270)
        P.put("DD10", 76.5, 46.0, 270)
        P.put("DD9", 68.5, 65.5, 180)
        P.put("DD5", 50.5, 36.5, 180, "B")
        # разъёмы внешних интерфейсов — у нижнего края, раструбом наружу
        for ref, x in (("X5", 12.5), ("X7", 24.5), ("X6", 34.5), ("X8", 44.0)):
            by1 = P.geo(P.fps[ref].GetFPIDAsString(), 0, "F")["box"][3]
            P.put(ref, x, round(H - P.EDGE - P.GAP - by1, 2), 0)

    # --- антенный вход и делитель 1:8 --------------------------------------------------------
    def rf_tree(self):
        P = self.P
        pins = self.pins
        divs = {pins[w]["2"]: w for w in self.comps if w.startswith("W")}
        entry = {f"RF{k + 1}": CX[k] + 3.3 for k in range(8)}

        def xof(net):
            if net in entry:
                return entry[net]
            w = divs[net]
            return (xof(pins[w]["4"]) + xof(pins[w]["6"])) / 2

        ant = self.refs_in("ant")
        lengths = {}

        def build(net, level, acc):
            w = divs[net]
            X, d = xof(net), DIV_Y0 + DIV_DY * level
            P.put(w, X, d, 180, force=True)
            outs = (pins[w]["4"], pins[w]["6"])
            r = self.part(ant, {short(outs[0]), short(outs[1])})
            P.put(r, X, d + 2.0, 0, force=True)
            if self.pins[r]["1"] != outs[0]:
                P.put(r, X, d + 2.0, 180, force=True)
            for gp in ("1", "3"):
                gx, gy = P.pad_xy(w, gp)
                vx = gx + (0.6 if gx > X else -0.6)
                self.track("GND", pcbnew.F_Cu, [(gx, gy), (vx, gy)], 0.3)
                self.via("GND", vx, gy)
            gx, gy = P.pad_xy(w, "5")
            self.track("GND", pcbnew.F_Cu, [(gx, gy), (gx, d + 1.15)], 0.3)
            self.via("GND", gx, d + 1.15)
            row = d + 2.3
            for pn, onet in zip(("4", "6"), outs):
                px, py = P.pad_xy(w, pn)
                xc = xof(onet)
                if onet in entry:
                    pts = [(px, py), (px, row), (xc, row)]
                    self.track(onet, pcbnew.F_Cu, pts, 0.32)
                    lengths[onet] = acc + self.length(pts)
                else:
                    cy = DIV_Y0 + DIV_DY * (level + 1) - 0.6
                    pts = [(px, py), (px, row), (xc, row), (xc, cy)]
                    self.track(onet, pcbnew.F_Cu, pts, 0.32)
                    build(onet, level + 1, acc + self.length(pts))

        # вход: XW1 -> C30 -> делитель; L3 (подача питания антенны), VD4 (защита)
        P.put("C30", 13.5, 5.3, 0, force=True)
        P.put("L3", 10.5, 7.3, 90, force=True)
        P.put("VD4", 9.86, 5.3, 180, force=True)
        ax, ay = P.pad_xy("XW1", "1")
        c1 = P.pad_xy("C30", "1")
        l2 = P.pad_xy("L3", "2")
        self.track("RF_ANT", pcbnew.F_Cu, [(ax, ay), (ax, c1[1]), c1], 0.32)
        self.track("RF_ANT", pcbnew.F_Cu, [(ax, c1[1]), l2], 0.32)
        # шаг выводов VD4 0,37 мм: отводы 0,2 мм входят в площадки с внешней стороны
        dx, dy = P.pad_xy("VD4", "1")
        self.track("RF_ANT", pcbnew.F_Cu, [(dx + 0.04, dy), (ax, c1[1])], 0.2)
        gx, gy = P.pad_xy("VD4", "2")
        self.via("GND", gx - 0.5, gy)
        self.track("GND", pcbnew.F_Cu, [(gx - 0.04, gy), (gx - 0.5, gy)], 0.2)
        c2 = P.pad_xy("C30", "2")
        X0 = xof("RF_DIV_IN")
        pts = [c2, (15.0, c2[1]), (15.0, DIV_IN_Y), (X0, DIV_IN_Y), (X0, DIV_Y0 - 0.6)]
        self.track("RF_DIV_IN", pcbnew.F_Cu, pts, 0.32)
        build("RF_DIV_IN", 0, 0.0)
        # переходы под стенку экрана: полосковая линия на L3 (In2), ограда из переходов GND
        for k in range(8):
            net, x = f"RF{k + 1}", entry[f"RF{k + 1}"]
            self.via(net, x, RF_ENTRY_Y)
            self.track(net, pcbnew.In2_Cu, [(x, RF_ENTRY_Y), (x, RF_IN_Y)], 0.14)
            self.via(net, x, RF_IN_Y)
            for dx in (-0.75, 0.75):
                self.via("GND", x + dx, RF_ENTRY_Y + 0.75)
                self.via("GND", x + dx, RF_IN_Y)
            lengths[net] += RF_IN_Y - RF_ENTRY_Y
        self.rf_len = lengths
        return lengths

    # --- шаблон ВЧ-канала ------------------------------------------------------------------
    def channels(self):
        P = self.P
        self.maxes = []
        for k in range(8):
            cx, L, ym = CX[k], LET[k], ymax(k)
            refs = self.refs_in("rf1" if k < 4 else "rf2", f"ch{k + 1}")
            mx = next(r for r in refs if r.startswith("DA"))
            self.maxes.append(mx)
            P.put(mx, cx - 0.6, ym, 0, force=True)
            rfm = next(short(n) for n in self.pins[mx].values() if short(n) == f"RFM_{L}") if False else f"RFM_{L}"
            cdc = self.part(refs, {f"RF{k + 1}", rfm})
            csh = self.part(refs, {rfm, "GND"})
            lin = self.part(refs, {rfm, f"LNAIN_{L}"})
            cln = self.part(refs, {f"LNAO_{L}", f"MIXI_{L}"})
            x = cx + 3.3
            P.put(cdc, x, 16.4, 270, force=True)
            P.put(csh, cx + 4.25, 17.9, 0, force=True)
            P.put(lin, x, 19.615, 270, force=True)
            P.put(cln, cx - 0.35, ym - 3.74, 180, force=True)
            for ref, net in ((cdc, f"RF{k + 1}"), (lin, rfm), (csh, rfm)):
                if short(self.pins[ref]["1"]) != net:
                    raise RuntimeError(f"{ref}: вывод 1 не {net}")
            # ВЧ-вход: переход -> C разделительный -> узел RFM (шунт C, L) -> LNAIN
            p1 = P.pad_xy(cdc, "1")
            self.track(f"RF{k + 1}", pcbnew.F_Cu, [(x, RF_IN_Y), p1], 0.32)
            p2, l1, s1 = P.pad_xy(cdc, "2"), P.pad_xy(lin, "1"), P.pad_xy(csh, "1")
            self.track(rfm, pcbnew.F_Cu, [p2, l1], 0.32)
            self.track(rfm, pcbnew.F_Cu, [(x, s1[1]), s1], 0.32)
            g = P.pad_xy(csh, "2")
            self.track("GND", pcbnew.F_Cu, [g, (cx + 5.35, g[1])], 0.3)
            self.via("GND", cx + 5.35, g[1])
            lnain = next(p for p, n in self.pins[mx].items() if short(n) == f"LNAIN_{L}")
            self.track(f"LNAIN_{L}", pcbnew.F_Cu, [P.pad_xy(lin, "2"), P.pad_xy(mx, lnain)], 0.25)
            lnao = next(p for p, n in self.pins[mx].items() if short(n) == f"LNAO_{L}")
            mixi = next(p for p, n in self.pins[mx].items() if short(n) == f"MIXI_{L}")
            for cp, mp, net in (("1", lnao, f"LNAO_{L}"), ("2", mixi, f"MIXI_{L}")):
                if short(self.pins[cln][cp]) != net:
                    cp = "2" if cp == "1" else "1"
                self.track(net, pcbnew.F_Cu, [P.pad_xy(cln, cp), P.pad_xy(mx, mp)], 0.2)

    # --- тактирование АЦП: FCT3807 (DD5, нижняя сторона) -> MAX2771 вывод 5 ----------------------
    def adc_clocks(self):
        P = self.P
        dd5 = "DD5"
        cxd = P.where[dd5][0]
        pn = self.pins[dd5]
        vias = {}
        for p, net in pn.items():
            if net.startswith("unconnected"):
                continue
            px, py = P.pad_xy(dd5, p)
            if short(net) == "ADC_SCLK_R":
                continue
            s = 1 if px > cxd else -1
            vx = px + s * (0.95 + 0.3)
            self.track(net, pcbnew.B_Cu, [(px, py), (vx, py)], 0.15 if net.startswith("ADC") else 0.25)
            self.via(net, vx, py)
            vias[short(net)] = (vx, py, p)
        lanes = {}
        for k in range(8):
            mx, cx, ym = self.maxes[k], CX[k], ymax(k)
            net = f"ADC_CLK_{LET[k]}"
            pin = next(p for p, n in self.pins[mx].items() if n == net)
            lanes[net] = (mx, pin, cx - 4.1)
        src = next((m, p) for m in self.maxes for p, n in self.pins[m].items() if n == "ADC_CLK_SRC")
        lanes["ADC_CLK_SRC"] = (src[0], src[1], CX[0] - 4.75)
        paths = {}
        for net, (mx, pin, xv) in lanes.items():
            vx, vy, _ = vias[net]
            tx, ty = P.pad_xy(mx, pin)
            paths[net] = [(vx, vy), (xv, vy), (xv, ty)]
            # B-сторона: вывод DD5 -> переход (уже проложено), F-сторона: переход -> вывод MAX
            self.via(net, xv, ty)
            self.track(net, pcbnew.F_Cu, [(xv, ty), (tx, ty)], 0.15)
            P.block(xv - 0.35, ty - 0.35, tx, ty + 0.35, ("F",))
        stub_b = 0.95 + 0.3
        # ADC_SCLK: DD5 вывод 18 -> R46 (B) -> переход -> L3 с меандром -> шарик ПЛИС
        rx, ry = P.pad_xy(dd5, next(p for p, n in pn.items() if short(n) == "ADC_SCLK_R"))
        apad = "1" if short(self.pins["R46"]["1"]) == "ADC_SCLK_R" else "2"
        bpad = "2" if apad == "1" else "1"
        g46 = P.geo(P.fps["R46"].GetFPIDAsString(), 0, "B")["pads"]
        rot46 = 0 if g46[apad][0][0] < g46[bpad][0][0] else 180      # вход резистора — ближе к DD5
        P.put("R46", rx + 2.9, ry, rot46, "B", force=True)
        a = P.pad_xy("R46", apad)
        b2 = P.pad_xy("R46", bpad)
        self.track("ADC_SCLK_R", pcbnew.B_Cu, [(rx, ry), a], 0.15)
        sv = (b2[0] + 0.55, b2[1])
        self.track("ADC_SCLK", pcbnew.B_Cu, [b2, sv], 0.15)
        self.via("ADC_SCLK", *sv)
        ball = next(p for p, n in self.pins["DD7"].items() if n == "ADC_SCLK")
        bx, by = P.pad_xy("DD7", ball)
        fx, fy = P.where["DD7"][:2]
        dvx, dvy = bx + (0.4 if bx >= fx else -0.4), by + (0.4 if by >= fy else -0.4)
        ret_y, x_end = 41.4, 67.5
        sclk_fixed = [sv, (x_end, sv[1]), (x_end, ret_y), (bx, ret_y), (bx, dvy - (0.4 if dvy < by else -0.4)), (dvx, dvy)]
        # длины: целевая — наибольшая из ADC_CLK_A…H
        def total(net, pts):
            if net == "ADC_SCLK":
                return self.length(pts) + math.hypot(a[0] - rx, a[1] - ry) + math.hypot(sv[0] - b2[0], 0) + 1.0 + math.hypot(dvx - bx, dvy - by)
            mx, pin, xv = lanes[net]
            tx, ty = P.pad_xy(mx, pin)
            return self.length(pts) + stub_b + abs(tx - xv)
        clk = [n for n in lanes if n != "ADC_CLK_SRC"]
        target = max(total(n, paths[n]) for n in clk) + CLK_TARGET_PAD
        self.clk_len = {}
        for net in clk:
            pts = paths[net]
            extra = target - total(net, pts)
            if extra > 0.05:
                (x0, y0), (x1, y1), (x2, y2) = pts
                pts = [(x0, y0), (x1, y1)] + meander((x1, y1), (x2, y2), extra, amp_max=3.2, pitch=0.5,
                                                     side=(-1, 0), lo=24.6, hi=32.6) + [(x2, y2)]
            self.track(net, pcbnew.In2_Cu, pts, 0.15)
            self.clk_len[net] = total(net, pts)
        self.track("ADC_CLK_SRC", pcbnew.In2_Cu, paths["ADC_CLK_SRC"], 0.15)
        self.clk_len["ADC_CLK_SRC"] = total("ADC_CLK_SRC", paths["ADC_CLK_SRC"])
        extra = target - total("ADC_SCLK", sclk_fixed)
        base = meander(sclk_fixed[0], sclk_fixed[1], extra, amp_max=2.6, pitch=0.5, side=(0, 1),
                       lo=sv[0] + 0.6, hi=x_end - 0.6)
        pts = [sclk_fixed[0]] + base + sclk_fixed[1:]
        self.track("ADC_SCLK", pcbnew.In2_Cu, pts, 0.15)
        self.clk_len["ADC_SCLK"] = total("ADC_SCLK", pts)
        self.clk_target = target
        self.dd7_sclk_via = (dvx, dvy)

    # --- переходы под шариками BGA (dog-bone) --------------------------------------------------
    def dogbones(self, ref, skip=()):
        P = self.P
        fx, fy = P.where[ref][:2]
        n = 0
        for pad in P.fps[ref].Pads():
            net = pad.GetNetname()
            if not net or net.startswith("unconnected"):
                continue
            bx, by = P.loc(pad.GetPosition())
            vx = bx + (0.4 if bx >= fx - 1e-6 else -0.4)
            vy = by + (0.4 if by >= fy - 1e-6 else -0.4)
            self.track(net, pcbnew.F_Cu, [(bx, by), (vx, vy)], 0.15)
            self.via(net, vx, vy, block=False)
            n += 1
        return n


    # --- авторазмещение остальных элементов ----------------------------------------------------
    def is_power(self, net):
        n = short(net)
        return n == "GND" or any(fnmatch.fnmatchcase(n, p) for c in ("PWR", "PWR5") for p in PATTERNS[c])

    def pads_on(self, net, exclude):
        P = self.P
        out = []
        for ref in P.where:
            if ref == exclude:
                continue
            for p, n in self.pins.get(ref, {}).items():
                if n == net:
                    out += [(ref, p, xy) for xy in P.pads_at(ref, p)]
        return out

    def target_for(self, ref, ic, anchor, dec_ic, rr):
        """Целевая точка пассивного элемента: (точка, своя площадка) или None."""
        pn = self.pins.get(ref, {})
        nets = [n for n in pn.values() if not n.startswith("unconnected")]
        sig = [n for n in nets if not self.is_power(n)]
        pwr = [n for n in nets if self.is_power(n) and short(n) != "GND"]
        if not sig and pwr and dec_ic:
            net = pwr[0]
            cand = [(p, xy) for p, n in self.pins[dec_ic].items() if n == net for xy in self.P.pads_at(dec_ic, p)]
            if cand:
                cand.sort(key=lambda t: math.atan2(t[1][1] - anchor[1], t[1][0] - anchor[0]))
                ncap = sum(1 for r in self.blk if net in self.pins.get(r, {}).values()) or 1
                i = rr.get((dec_ic, net), 0)
                rr[(dec_ic, net)] = i + 1
                p, xy = cand[(i * max(1, len(cand) // ncap)) % len(cand)]
                mine = next(q for q, n in pn.items() if n == net)
                return xy, mine
        for net in sig + pwr:
            cand = self.pads_on(net, ref)
            if not cand:
                continue
            pref = [c for c in cand if c[0] == ic] or [c for c in cand if c[0][:1] not in "RCL"] or cand
            r, p, xy = min(pref, key=lambda c: math.hypot(c[2][0] - anchor[0], c[2][1] - anchor[1]))
            mine = next(q for q, n in pn.items() if n == net)
            return xy, mine
        return None

    def area(self, ref):
        x0, y0, x1, y1 = self.P.geo(self.P.fps[ref].GetFPIDAsString(), 0, "F")["box"]
        return (x1 - x0) * (y1 - y0)

    def auto_one(self, ref, xy, region, sides, pad):
        P = self.P
        if ref in TALL:
            sides = ("F",)
        if not (P.auto(ref, xy, region=region, sides=sides, pad=pad, toward=xy, rmax=14) or
                P.auto(ref, xy, region=None, sides=sides if ref in TALL else ("F", "B"), pad=pad, toward=xy,
                       rmax=30, step=0.4)):
            raise RuntimeError(f"{ref}: нет места около {xy}")

    def auto_place(self):
        P = self.P
        rr = {}
        # 1) элементы ВЧ-каналов — в своей ячейке экрана, только верхняя сторона
        for k in range(8):
            refs = [r for r in self.refs_in("rf1" if k < 4 else "rf2", f"ch{k + 1}") if r not in P.where]
            mx = self.maxes[k]
            self.blk = refs
            anchor = P.where[mx][:2]
            for ref in sorted(refs, key=lambda r: (r[0] != "R", r)):
                t = self.target_for(ref, mx, anchor, mx, rr)
                xy, pad = t if t else (anchor, None)
                if not P.auto(ref, xy, region=cell(k), pad=pad, toward=xy, rmax=12):
                    raise RuntimeError(f"{ref}: нет места в ячейке канала {k + 1}")
        # внутри экранов на верхней стороне больше ничего не ставится
        for x, y in SHIELDS.values():
            P.block(x - SH_OUT[0], y - SH_OUT[1], x + SH_OUT[0], y + SH_OUT[1], ("F",))
        # 2) остальные блоки по плану
        left = []
        for sheet, block, ic, tgt, sides in PLAN:
            refs = [r for r in self.refs_in(sheet, block) if r not in P.where]
            self.blk = refs
            region = REGION.get(sheet)
            if ic and ic in refs:
                if not (P.auto(ic, tgt, region=region, sides=sides, rmax=16) or
                        P.auto(ic, tgt, region=region, sides=sides, rmax=40, step=0.4)):
                    raise RuntimeError(f"{ic}: нет места около {tgt}")
                refs.remove(ic)
            anchor = P.where[ic][:2] if ic else tgt
            dec = DEC_IC.get(block) or ic
            if ic:
                own = P.where[ic][3]
                sides = (own,) + tuple(s for s in ("F", "B") if s != own)
            if block in F_ONLY:
                sides = ("F",)
            for ref in sorted(refs, key=lambda r: -self.area(r)):
                t = self.target_for(ref, ic, anchor, dec, rr)
                if t is None:
                    left.append((ref, anchor, region, sides))
                    continue
                self.auto_one(ref, t[0], region, sides, t[1])
        for ref, anchor, region, sides in left:
            t = self.target_for(ref, None, anchor, None, rr)
            xy, pad = t if t else (anchor, None)
            self.auto_one(ref, xy, region, sides, pad)
        miss = [r for r in self.comps if r not in P.where]
        if miss:
            raise RuntimeError(f"не размещены: {miss}")

    # --- слои питания и земли ------------------------------------------------------------------
    def zone(self, net, layer, geom, prio=0, clr=None):
        z = pcbnew.ZONE(self.b)
        z.SetLayer(layer)
        z.SetNet(self.net(net))
        z.SetAssignedPriority(prio)
        z.SetMinThickness(MM(0.15))
        z.SetThermalReliefGap(MM(0.25))
        z.SetThermalReliefSpokeWidth(MM(0.25))
        z.SetPadConnection(pcbnew.ZONE_CONNECTION_THERMAL)
        z.SetIslandRemovalMode(pcbnew.ISLAND_REMOVAL_MODE_ALWAYS)
        if clr is not None:
            z.SetLocalClearance(MM(clr))
        o = z.Outline()
        polys = list(geom.geoms) if hasattr(geom, "geoms") else [geom]
        for g in polys:
            o.NewOutline()
            for x, y in list(g.exterior.coords)[:-1]:
                o.Append(MM(OX + x), MM(OY + y))
            for hole in g.interiors:
                h = o.NewHole()
                for x, y in list(hole.coords)[:-1]:
                    o.Append(MM(OX + x), MM(OY + y), -1, h)
        self.b.Add(z)
        return z

    def pad_box(self, refs, net, grow):
        pts = [xy for r in refs for p, n in self.pins.get(r, {}).items() if short(n) == net
               for xy in self.P.pads_at(r, p)]
        xs, ys = [p[0] for p in pts], [p[1] for p in pts]
        return box(min(xs) - grow, min(ys) - grow, max(xs) + grow, max(ys) + grow)

    def planes(self):
        """L2, L4, L7 — сплошная земля; L5 — островки питания, остальное +3V3D."""
        full = box(0.35, 0.35, W - 0.35, H - 0.35)
        for L in (pcbnew.In1_Cu, pcbnew.In3_Cu, pcbnew.In6_Cu):
            self.zone("GND", L, full)
        isl = {}
        ldo = {1: "DA11", 2: "DA2", 3: "DA6", 4: "DA8"}
        for n in range(1, 5):
            x0 = (4.0, 26.6, 51.2, 73.8)[n - 1]
            px, py = self.P.pad_xy(ldo[n], next(p for p, v in self.pins[ldo[n]].items() if short(v) == f"+3V3_RF{n}"))
            isl[f"+3V3_RF{n}"] = unary_union([box(x0, 13.5, x0 + 22.2, 31.7),
                                              box(px - 1.5, 31.0, px + 1.5, py + 1.0)])
        isl["+3V3_CLK"] = box(41.0, 32.2, 60.0, 40.0)
        core = self.pad_box(["DD7"], "+1V1", 0.6)
        dc2 = self.refs_in("power", "dc2")
        land = self.pad_box(dc2, "+1V1", 1.0)
        fy = self.P.where["DD7"][1]
        lx0, ly0, lx1, ly1 = land.bounds
        land = box(lx0, min(ly0, fy - 0.45), max(lx1, lx0 + 2.0), max(ly1, fy + 0.45))
        neck = box(land.bounds[2] - 0.1, fy - 0.45, core.bounds[0] + 0.1, fy + 0.45)
        isl["+1V1"] = unary_union([core, land, neck])
        isl["+1V2_FX3"] = self.pad_box(["DD10"], "+1V2_FX3", 0.6)
        for net, g in isl.items():
            self.zone(net, pcbnew.In4_Cu, g, prio=1)
        rest = full.difference(unary_union([g.buffer(0.3, join_style=2) for g in isl.values()]))
        self.zone("+3V3D", pcbnew.In4_Cu, rest, prio=0)
        # запрет переходов в перешейке +1V1 под ПЛИС (иначе остров распадётся)
        ka = pcbnew.ZONE(self.b)
        ka.SetIsRuleArea(True)
        ka.SetDoNotAllowVias(True)
        ka.SetDoNotAllowTracks(False)
        ka.SetDoNotAllowPads(False)
        ka.SetDoNotAllowZoneFills(False)
        ka.SetDoNotAllowFootprints(False)
        ka.SetLayerSet(pcbnew.LSET.AllCuMask())
        nx0, ny0, nx1, ny1 = neck.bounds
        o = ka.Outline()
        o.NewOutline()
        for x, y in ((nx0, ny0), (nx1, ny0), (nx1, ny1), (nx0, ny1)):
            o.Append(MM(OX + x), MM(OY + y))
        self.b.Add(ka)
        self.islands = isl


def meander(p0, p1, extra, amp_max, pitch, side, lo, hi):
    """Змейка на отрезке p0->p1 (параллелен оси): выступы в сторону side, добавочная длина extra.
    lo..hi — допустимый участок координаты вдоль отрезка. Возвращает промежуточные точки."""
    (x0, y0), (x1, y1) = p0, p1
    vert = abs(x1 - x0) < 1e-9
    a0, a1 = (y0, y1) if vert else (x0, x1)
    sgn = 1 if a1 > a0 else -1
    n = max(1, math.ceil(extra / (2 * amp_max) - 1e-9))
    amp = extra / (2 * n)
    span = 2 * n * pitch
    lo_, hi_ = max(min(a0, a1), lo), min(max(a0, a1), hi)
    if hi_ - lo_ < span + 2 * pitch:
        raise RuntimeError(f"меандр не помещается: нужно {span:.1f} мм, есть {hi_ - lo_:.1f}")
    start = (hi_ - pitch) if sgn < 0 else (lo_ + pitch)
    pts = []
    sx, sy = side
    for i in range(n):
        c0 = start + sgn * 2 * i * pitch
        c1 = c0 + sgn * pitch
        for c, out in ((c0, False), (c0, True), (c1, True), (c1, False)):
            off = amp if out else 0.0
            if vert:
                pts.append((x0 + sx * off, c))
            else:
                pts.append((c, y0 + sy * off))
    return pts


# ------------------------------------------------------------------------------------------------
def stage_place():
    shutil.rmtree(TMP, ignore_errors=True)
    os.makedirs(TMP)
    B = Board(os.path.join(TMP, "mgp8.kicad_pcb"))
    B.add_footprints()
    B.place_fixed()
    rf = B.rf_tree()
    B.channels()
    B.adc_clocks()
    nd7 = B.dogbones("DD7", skip={(round(B.dd7_sclk_via[0], 2), round(B.dd7_sclk_via[1], 2))})
    nd10 = B.dogbones("DD10")
    for ref in ("DD7", "DD10"):      # нижняя сторона под BGA занята переходами
        x, y = B.P.where[ref][:2]
        x0, y0, x1, y1 = B.P.geo(B.P.fps[ref].GetFPIDAsString(), B.P.where[ref][2], "F")["box"]
        B.P.block(x + x0, y + y0, x + x1, y + y1, ("B",))
    B.auto_place()
    B.planes()
    print("ВЧ длины:", {k: round(v, 2) for k, v in sorted(rf.items())})
    print("Такт длины:", {k: round(v, 2) for k, v in sorted(B.clk_len.items())}, "цель", round(B.clk_target, 2))
    print("dog-bone: DD7", nd7, "DD10", nd10)
    json.dump({"rf": rf, "clk": B.clk_len, "clk_target": B.clk_target},
              open(os.path.join(TMP, "lengths.json"), "w"), indent=1)
    pcbnew.ZONE_FILLER(B.b).Fill(B.b.Zones())
    pcbnew.SaveBoard(B.path, B.b)
    open(os.path.join(TMP, "mgp8.kicad_dru"), "w", encoding="utf-8", newline="\n").write(DRU)
    dsn =os.path.join(TMP, "mgp8.dsn")
    if not pcbnew.ExportSpecctraDSN(B.b, dsn):
        raise RuntimeError("экспорт DSN не выполнен")
    print("DSN:", dsn)
    return B


def java():
    cands = [os.environ.get("JAVA"), shutil.which("java")]
    cands += sorted(glob.glob(r"C:\Program Files\Eclipse Adoptium\*\bin\java.exe"), reverse=True)
    for p in cands:
        if p and os.path.exists(p):
            return p
    raise FileNotFoundError("java (переменная JAVA)")


def freerouting(timeout, fanout, passes=100, optimizer=True):
    """Freerouting по TMP/mgp8.dsn -> TMP/mgp8.ses. По истечении timeout (чч:мм:сс) сохраняется
    достигнутый результат. Проход трассировки однопоточный (-mt — только для оптимизатора)."""
    dsn, ses = os.path.join(TMP, "mgp8.dsn"), os.path.join(TMP, "mgp8.ses")
    if os.path.exists(ses):
        os.remove(ses)
    tf = lambda v: "true" if v else "false"
    subprocess.run([java(), "-jar", FREEROUTING, "-de", dsn, "-do", ses, "-mt", "4",
                    f"--router.autorouter.max_passes={passes}", f"--router.job_timeout={timeout}",
                    f"--router.fanout.enabled={tf(fanout)}", f"--router.optimizer.enabled={tf(optimizer)}",
                    "--router.neck_width_um=100", "--gui.enabled=false"], check=True)
    if not os.path.exists(ses):
        raise RuntimeError("Freerouting не создал .ses")


def stage_route():
    """Автотрассировка остальных цепей: скриптовые проводники в DSN — неподвижные (type fix),
    слои In1, In3, In4, In6 — плоскости (сигналы не трассируются)."""
    freerouting("12:00:00", True)


def import_ses(b):
    """Проводники из TMP/mgp8.ses на плату (незакреплённые заменяются, скриптовые остаются)."""
    locked = {(t.GetStart().x, t.GetStart().y, t.GetEnd().x, t.GetEnd().y, t.GetLayer())
              for t in b.GetTracks() if t.IsLocked()}
    if not pcbnew.ImportSpecctraSES(b, os.path.join(TMP, "mgp8.ses")):
        raise RuntimeError("импорт .ses не выполнен")
    # скриптовые проводники возвращаются из .ses копиями — оставляем исходные (закреплённые)
    seen = set()
    for t in list(b.GetTracks()):
        k = (t.GetStart().x, t.GetStart().y, t.GetEnd().x, t.GetEnd().y, t.GetLayer())
        if not t.IsLocked() and (k in locked or k in seen):
            b.Remove(t)
        seen.add(k)


def keepout_shapes(b):
    """Запреты для автотрассировщика: полоса вдоль края платы и окрестности неметаллизированных
    отверстий (Freerouting не учитывает отступ меди от края и от отверстий)."""
    e = RULES["edge"]
    out = [box(OX, OY, OX + W, OY + e), box(OX, OY + H - e, OX + W, OY + H),
           box(OX, OY, OX + e, OY + H), box(OX + W - e, OY, OX + W, OY + H)]
    from shapely.geometry import Point
    for fp in b.GetFootprints():
        for p in fp.Pads():
            if p.GetAttribute() == pcbnew.PAD_ATTRIB_NPTH:
                c = p.GetPosition()
                r = mm(max(p.GetDrillSize().x, p.GetDrillSize().y)) / 2 + e
                out.append(Point(mm(c.x), mm(c.y)).buffer(r, 16))
    return out


def add_keepouts(b, shapes):
    for g in shapes:
        z = pcbnew.ZONE(b)
        z.SetIsRuleArea(True)
        z.SetDoNotAllowTracks(True)
        z.SetDoNotAllowVias(True)
        z.SetDoNotAllowPads(False)
        z.SetDoNotAllowFootprints(False)
        (z.SetDoNotAllowZoneFills if hasattr(z, "SetDoNotAllowZoneFills") else z.SetDoNotAllowCopperPour)(False)
        z.SetLayerSet(pcbnew.LSET.AllCuMask())
        o = z.Outline()
        o.NewOutline()
        for x, y in list(g.exterior.coords)[:-1]:
            o.Append(MM(x), MM(y))
        b.Add(z)


def track_geom(t):
    from shapely.geometry import LineString, Point
    if t.GetClass() == "PCB_VIA":
        c = t.GetPosition()
        return Point(mm(c.x), mm(c.y)).buffer(mm(t.GetWidth(pcbnew.F_Cu)) / 2, 8)
    s, e = t.GetStart(), t.GetEnd()
    return LineString([(mm(s.x), mm(s.y)), (mm(e.x), mm(e.y))]).buffer(mm(t.GetWidth()) / 2, 4)


def plane_vias(b, unconnected):
    """Площадки цепей земли и питания, не присоединённые к своему слою (по отчёту DRC unconnected —
    uuid элементов), получают отвод 0,15 мм и переход: на земле — к L2/L4/L7, на питании — к своему
    островку L5. Место перехода — ближайшее к площадке, где нет меди других цепей на всех слоях
    (с зазором), переходов (отверстие к отверстию), запретов и края платы."""
    from shapely.geometry import LineString, Point, Polygon
    from shapely.strtree import STRtree
    clr, vr, sw = RULES["clearance"], RULES["via"] / 2, 0.15
    sig = (pcbnew.F_Cu, pcbnew.In2_Cu, pcbnew.In5_Cu, pcbnew.B_Cu)
    obst = {L: [] for L in sig}          # (геометрия, код цепи)
    holes = []                            # центры отверстий (переходы и металлизированные выводы)

    def bbox_poly(bb):
        return box(mm(bb.GetX()), mm(bb.GetY()), mm(bb.GetRight()), mm(bb.GetBottom()))

    def grow(g, name):
        # цепи классов с зазором больше общего (такты, ВЧ) — препятствие шире на разницу
        cls = next((c for c, pats in PATTERNS.items() if any(fnmatch.fnmatch(name, p) for p in pats)), None)
        extra = CLASSES[cls][1] - clr if cls else 0
        return g.buffer(extra, 4) if extra > 1e-9 else g

    def poly(o):
        return Polygon([(mm(o.CVertex(i).x), mm(o.CVertex(i).y)) for i in range(o.TotalVertices())])

    for fp in b.GetFootprints():
        for p in fp.Pads():
            g = grow(bbox_poly(p.GetBoundingBox()), p.GetNetname())
            for L in sig:
                if p.IsOnLayer(L):
                    obst[L].append((g, p.GetNetCode()))
            if p.GetAttribute() in (pcbnew.PAD_ATTRIB_PTH, pcbnew.PAD_ATTRIB_NPTH):
                c = p.GetPosition()
                holes.append((mm(c.x), mm(c.y), mm(max(p.GetDrillSize().x, p.GetDrillSize().y)) / 2))
    for t in b.GetTracks():
        g = grow(track_geom(t), t.GetNetname())
        if t.GetClass() == "PCB_VIA":
            c = t.GetPosition()
            holes.append((mm(c.x), mm(c.y), mm(t.GetDrillValue()) / 2))
            for L in sig:
                obst[L].append((g, t.GetNetCode()))
        elif t.GetLayer() in obst:
            obst[t.GetLayer()].append((g, t.GetNetCode()))
    forbid, forbid_t = keepout_shapes(b), keepout_shapes(b)     # для переходов и для отводов
    for z in [z for fp in b.GetFootprints() for z in fp.Zones()]:   # запреты посадочных мест
        if z.GetIsRuleArea():
            if z.GetDoNotAllowVias():
                forbid.append(poly(z.Outline()))
            if z.GetDoNotAllowTracks():
                forbid_t.append(poly(z.Outline()))
    island = {}
    for z in b.Zones():
        o = z.Outline()
        if z.GetIsRuleArea():
            if z.GetDoNotAllowVias():
                forbid.append(poly(o))
            if z.GetDoNotAllowTracks():
                forbid_t.append(poly(o))
        elif z.GetLayer() == pcbnew.In4_Cu:       # залитая медь островка (с вырезами)
            ps = z.GetFilledPolysList(pcbnew.In4_Cu)

            def ring(ln):
                return [(mm(ln.CPoint(i).x), mm(ln.CPoint(i).y)) for i in range(ln.PointCount())]
            for k in range(ps.OutlineCount()):
                g = Polygon(ring(ps.Outline(k)), [ring(ps.Hole(k, j)) for j in range(ps.HoleCount(k))])
                island[z.GetNetCode()] = island.get(z.GetNetCode(), Polygon()).union(g.buffer(0))
    forbid, forbid_t = unary_union(forbid), unary_union(forbid_t)
    trees = {L: STRtree([g for g, _ in obst[L]]) for L in sig}
    htree = STRtree([Point(x, y) for x, y, _ in holes])
    gnd = b.FindNet("GND").GetNetCode()
    pads = {p.m_Uuid.AsString(): p for fp in b.GetFootprints() for p in fp.Pads()}
    tracks = {t.m_Uuid.AsString(): t for t in b.GetTracks() if t.GetClass() == "PCB_TRACK"}
    plane = lambda n: n == gnd or n in island
    # (цепь, слой, точки присоединения, вынос до края элемента): площадка — от центра,
    # оторванный кусок проводника — от его концов (переход прямо на конце или с отводом)
    todo = {}
    for u in unconnected:
        for it in u["items"]:
            p, t = pads.get(it["uuid"]), tracks.get(it["uuid"])
            if p is not None and p.GetAttribute() == pcbnew.PAD_ATTRIB_SMD and plane(p.GetNetCode()):
                bb = p.GetBoundingBox()
                todo[it["uuid"]] = (p.GetNetCode(), pcbnew.F_Cu if p.IsOnLayer(pcbnew.F_Cu) else pcbnew.B_Cu,
                                    [p.GetPosition()], max(mm(bb.GetWidth()), mm(bb.GetHeight())) / 2)
            elif t is not None and t.GetLayer() in sig and plane(t.GetNetCode()):
                todo[it["uuid"]] = (t.GetNetCode(), t.GetLayer(), [t.GetStart(), t.GetEnd()], None)
    todo = list(todo.values())

    def free(L, g, net):
        return not any(obst[L][i][1] != net for i in trees[L].query(g))

    def place(net, L, c, isl, dist):
        nonlocal trees, htree
        px, py = mm(c.x), mm(c.y)
        for d in dist:
            for a in (range(0, 360, 10) if d else (0,)):
                vx, vy = px + d * math.cos(math.radians(a)), py + d * math.sin(math.radians(a))
                v = Point(vx, vy)
                if forbid.intersects(v.buffer(vr)) or (isl is not None and not isl.contains(v)):
                    continue
                if not (OX + RULES["edge"] + vr <= vx <= OX + W - RULES["edge"] - vr and
                        OY + RULES["edge"] + vr <= vy <= OY + H - RULES["edge"] - vr):
                    continue
                if any(math.hypot(holes[i][0] - vx, holes[i][1] - vy) < 0.1 + holes[i][2] + RULES["hole_hole"]
                       for i in htree.query(v.buffer(1.0))):
                    continue
                vg = v.buffer(vr + clr)
                if not all(free(Lx, vg, net) for Lx in sig):
                    continue
                if d:
                    st = LineString([(px, py), (vx, vy)]).buffer(sw / 2)
                    if forbid_t.intersects(st) or not free(L, st.buffer(clr, 4), net):
                        continue
                    t = pcbnew.PCB_TRACK(b)
                    t.SetStart(c)
                    t.SetEnd(pcbnew.VECTOR2I(MM(vx), MM(vy)))
                    t.SetLayer(L)
                    t.SetWidth(MM(sw))
                    t.SetNetCode(net)
                    t.SetLocked(True)
                    b.Add(t)
                    obst[L].append((LineString([(px, py), (vx, vy)]).buffer(sw / 2), net))
                via = pcbnew.PCB_VIA(b)
                via.SetPosition(pcbnew.VECTOR2I(MM(vx), MM(vy)))
                via.SetWidth(MM(RULES["via"]))
                via.SetDrill(MM(RULES["drill"]))
                via.SetNetCode(net)
                via.SetLocked(True)
                b.Add(via)
                # новые медь и отверстие — препятствия для следующих
                for Lx in sig:
                    obst[Lx].append((v.buffer(vr), net))
                trees = {Lx: STRtree([g for g, _ in obst[Lx]]) for Lx in sig}
                holes.append((vx, vy, RULES["drill"] / 2))
                htree = STRtree([Point(x, y) for x, y, _ in holes])
                return True
        return False

    added = 0
    for net, L, anchors, reach in todo:
        isl = island[net].buffer(-0.35) if net in island else None
        dist = [reach + 0.2 + 0.1 * k for k in range(35)] if reach is not None else             [0] + [0.4 + 0.1 * k for k in range(30)]
        added += any(place(net, L, c, isl, dist) for c in anchors)
    return added, len(todo)


def merge_ses():
    """Результат прохода Freerouting переносится на исходную плату и становится начальным для
    следующего. Проводники и переходы, попавшие в запреты keepout_shapes, и сужения тоньше нормы
    удаляются; площадки и куски проводников земли и питания, не присоединённые к своим слоям,
    получают переходы (plane_vias) — трассировщику остаются сигнальные связи."""
    src = os.path.join(TMP, "mgp8.kicad_pcb")
    b = pcbnew.LoadBoard(src)
    import_ses(b)
    ko = unary_union(keepout_shapes(b))
    bad = [t for t in b.GetTracks() if not t.IsLocked() and (
        (t.GetClass() != "PCB_VIA" and t.GetWidth() < MM(RULES["track"])) or track_geom(t).intersects(ko))]
    for t in bad:
        b.Remove(t)
    print("удалено проводников и переходов:", len(bad), flush=True)
    pcbnew.ZONE_FILLER(b).Fill(b.Zones())
    pcbnew.SaveBoard(src, b)
    d, _ = drc(src, os.path.join(TMP, "drc_more.json"))
    n0 = len(d.get("unconnected_items", []))
    added, asked = plane_vias(b, d.get("unconnected_items", []))
    pcbnew.ZONE_FILLER(b).Fill(b.Zones())
    pcbnew.SaveBoard(src, b)
    d, _ = drc(src, os.path.join(TMP, "drc_more.json"))
    print(f"переходы к слоям земли и питания: {added} из {asked}; неразведённых {n0} -> "
          f"{len(d.get('unconnected_items', []))}", flush=True)
    return b


def prepare_more():
    """Доразводка, подготовка: merge_ses и выгрузка в DSN с запретами у края и крепёжных отверстий."""
    b = merge_ses()
    add_keepouts(b, keepout_shapes(b))
    if not pcbnew.ExportSpecctraDSN(b, os.path.join(TMP, "mgp8.dsn")):
        raise RuntimeError("экспорт DSN не выполнен")


def stage_more(timeout="03:00:00"):
    """Доразводка: подготовка (prepare_more) и Freerouting без разводки выводов BGA и без
    оптимизации (20 проходов)."""
    prepare_more()
    freerouting(timeout, False, passes=20, optimizer=False)


def stackup():
    cu = ["F.Cu"] + [f"In{i}.Cu" for i in range(1, 7)] + ["B.Cu"]
    out = ['(stackup', '(layer "F.SilkS" (type "Top Silk Screen"))', '(layer "F.Paste" (type "Top Solder Paste"))',
           '(layer "F.Mask" (type "Top Solder Mask") (thickness 0.01))']
    ci = di = 0
    for kind, t in STACK:
        if kind == "copper":
            out.append(f'(layer "{cu[ci]}" (type "copper") (thickness {t}))')
            ci += 1
        else:
            di += 1
            out.append(f'(layer "dielectric {di}" (type "{kind}") (color "FR4 natural") (thickness {t}) '
                       f'(material "FR4 Tg170") (epsilon_r 4.3) (loss_tangent 0.02))')
    out += ['(layer "B.Mask" (type "Bottom Solder Mask") (thickness 0.01))',
            '(layer "B.Paste" (type "Bottom Solder Paste"))', '(layer "B.SilkS" (type "Bottom Silk Screen"))',
            '(copper_finish "ENIG")', '(dielectric_constraints no)', ')']
    return "\n".join(out)


def drc(pcb, out):
    subprocess.run([CLI, "pcb", "drc", "--format", "json", "--schematic-parity", "--refill-zones",
                    "--severity-error", "--severity-warning", "-o", out, pcb], capture_output=True)
    d = json.load(open(out, encoding="utf-8"))
    cnt = {}
    for v in d["violations"] + d.get("schematic_parity", []):
        cnt[(v["severity"], v["type"])] = cnt.get((v["severity"], v["type"]), 0) + 1
    return d, cnt


def save_out(b, out_pcb):
    """Плата со стеком слоёв -> hw/kicad; правила и классы цепей — в файл проекта."""
    fin = os.path.join(TMP, "fin")
    shutil.rmtree(fin, ignore_errors=True)
    os.makedirs(fin)
    tmp_pcb = os.path.join(fin, "mgp8.kicad_pcb")
    pcbnew.SaveBoard(tmp_pcb, b)
    text = open(tmp_pcb, encoding="utf-8").read()
    if "(stackup" not in text:
        text = text.replace("(setup", "(setup\n" + stackup(), 1)
    open(out_pcb, "w", encoding="utf-8", newline="\n").write(text)
    open(os.path.join(KICAD, "mgp8.kicad_dru"), "w", encoding="utf-8", newline="\n").write(DRU)
    # остальные разделы проекта не трогаем
    tp = json.load(open(os.path.join(fin, "mgp8.kicad_pro"), encoding="utf-8"))
    pro_path = os.path.join(KICAD, "mgp8.kicad_pro")
    pro = json.load(open(pro_path, encoding="utf-8"))
    for key in ("board", "net_settings"):
        pro[key] = tp[key]
    with open(pro_path, "w", encoding="utf-8", newline="\n") as f:
        json.dump(pro, f, indent=2, ensure_ascii=False)
        f.write("\n")


def stage_finish():
    b = merge_ses()
    copy_fields(b)
    # заливка земли на наружных слоях (копланарные ВЧ-линии, экраны, отвод тепла)
    gnd = b.FindNet("GND")
    for L in (pcbnew.F_Cu, pcbnew.B_Cu):
        z = pcbnew.ZONE(b)
        z.SetLayer(L)
        z.SetNet(gnd)
        z.SetAssignedPriority(0)
        z.SetMinThickness(MM(0.15))
        z.SetLocalClearance(MM(0.2))
        # сплошное присоединение: площадка земли между проводниками не всегда получает две спицы
        z.SetPadConnection(pcbnew.ZONE_CONNECTION_FULL)
        z.SetIslandRemovalMode(pcbnew.ISLAND_REMOVAL_MODE_ALWAYS)
        o = z.Outline()
        o.NewOutline()
        for x, y in ((0.35, 0.35), (W - 0.35, 0.35), (W - 0.35, H - 0.35), (0.35, H - 0.35)):
            o.Append(MM(OX + x), MM(OY + y))
        b.Add(z)
    out_pcb = os.path.join(KICAD, "mgp8.kicad_pcb")
    # висящие переходы и отрезки (остатки разводки выводов BGA и доразводки) удаляются по отчёту DRC
    for _ in range(12):
        pcbnew.ZONE_FILLER(b).Fill(b.Zones())
        save_out(b, out_pcb)
        d, cnt = drc(out_pcb, os.path.join(TMP, "drc_final.json"))
        dang = {i["uuid"] for v in d["violations"] if v["type"] in ("via_dangling", "track_dangling")
                for i in v["items"]}
        rm = [t for t in b.GetTracks() if not t.IsLocked() and t.m_Uuid.AsString() in dang]
        if not rm:
            break
        for t in rm:
            b.Remove(t)
        print("удалено висящих:", len(rm))
    for (sev, typ), n in sorted(cnt.items()):
        print(f"DRC {sev:8s} {typ:28s} {n}")
    print("DRC неразведённых:", len(d.get("unconnected_items", [])))
    report(pcbnew.LoadBoard(out_pcb))


def report(b):
    """Длины цепей (по проводникам) и счётчики для ПЗ — в %TEMP%/mgp8pcb/proj/routed.json."""
    lens, vias = {}, {}
    for t in b.GetTracks():
        n = short(t.GetNetname())
        if t.GetClass() == "PCB_VIA":
            vias[n] = vias.get(n, 0) + 1
        else:
            lens[n] = lens.get(n, 0.0) + mm(t.GetLength())
    ntr = sum(1 for t in b.GetTracks() if t.GetClass() != "PCB_VIA")
    nvia = sum(vias.values())
    rf = {k: round(v, 2) for k, v in lens.items() if k.startswith("RF") and k[2:].isdigit()}
    clk = {k: round(v, 2) for k, v in lens.items() if k.startswith("ADC_CLK_") or k == "ADC_SCLK"}
    iq = {k: round(v, 2) for k, v in lens.items() if fnmatch.fnmatch(k, "[IQ][01]_?")}
    res = dict(tracks=ntr, vias=nvia, total_len_m=round(sum(lens.values()) / 1000, 2), rf=rf, clk=clk, iq=iq)
    json.dump(res, open(os.path.join(TMP, "routed.json"), "w"), indent=1, ensure_ascii=False)
    print(json.dumps({k: v for k, v in res.items() if not isinstance(v, dict)}, ensure_ascii=False))
    for k in ("rf", "clk", "iq"):
        if res[k]:
            print(k, "мин", min(res[k].values()), "макс", max(res[k].values()), "шт", len(res[k]))


if __name__ == "__main__":
    stage = sys.argv[1] if len(sys.argv) > 1 else "place"
    {"place": stage_place, "route": stage_route, "more": stage_more, "finish": stage_finish}[stage](*sys.argv[2:])
