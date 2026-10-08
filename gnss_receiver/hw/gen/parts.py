"""Каталог комплектующих МГП-8: УГО, позиционное обозначение (ГОСТ 2.710), наименование
для ПЭ3 и ВП (ГОСТ 2.701, 2.106), производитель, артикул, посадочное место."""
import re
from dataclasses import dataclass, field

import symlib
from sexp import Q

LIB = "mgp8"


@dataclass
class PartDef:
    key: str                 # ключ УГО в библиотеке проекта
    prefix: str              # позиционное обозначение (буквенный код)
    group: str               # группа ПЭ3/ВП («Резисторы», «Микросхемы» …)
    name: str                # наименование в ПЭ3
    pn: str                  # обозначение изготовителя (артикул)
    mfr: str
    fp: str
    value: str = ""
    pins: dict = field(default_factory=dict)   # имя вывода -> [номера]
    units: int = 1
    note: str = ""
    all_pins: set = field(default_factory=set)
    pin_type: dict = field(default_factory=dict)
    pin_unit: dict = field(default_factory=dict)


SYMBOLS = {}      # key -> узел символа
_DEFS = {}


def _reg_symbol(key, node):
    if key not in SYMBOLS:
        SYMBOLS[key] = node
    return key


def _pins_of(key):
    tab = symlib.pin_table(SYMBOLS[key])
    d = {}
    for p in tab:
        d.setdefault(p["name"], []).append(p["num"])
        d.setdefault("#" + p["num"], [p["num"]])
    return d


def _mk(key, prefix, group, name, pn, mfr, fp, value="", note="", src_pins=None):
    tab = symlib.pin_table(SYMBOLS[key])
    pd = PartDef(key, prefix, group, name, pn, mfr, fp, value or pn, note=note)
    srcp = src_pins or [dict(num=p["num"], name=p["name"], type=p["type"]) for p in tab]
    for p in srcp:
        pd.pins.setdefault(p["name"], []).append(p["num"])
        pd.pins.setdefault("#" + p["num"], [p["num"]])
        pd.all_pins.add(p["num"])
        pd.pin_type[p["num"]] = p["type"]
    for p in tab:
        pd.pin_unit[p["num"]] = p["unit"] or 1
    return pd


# ------------------------------------------------------------------ пассивные
_SI = [("G", 1e9), ("M", 1e6), ("k", 1e3), ("", 1), ("m", 1e-3), ("u", 1e-6), ("n", 1e-9), ("p", 1e-12)]
_RU = {"G": "Г", "M": "М", "k": "к", "": "", "m": "м", "u": "мк", "n": "н", "p": "п"}


def parse_val(s):
    m = re.fullmatch(r"([\d.]+)\s*([GMkmunp]?)", s)
    num, mul = float(m.group(1)), m.group(2)
    return num * dict(_SI)[mul]


def ru_val(v, unit):
    for p, m in _SI:
        if v >= m * 0.999:
            x = v / m
            s = f"{x:.3g}".replace(".", ",")
            return f"{s} {_RU[p]}{unit}"
    return f"{v} {unit}"


def _yageo(v, tol):
    """Артикул Yageo RC0402: 10k -> 10KL, 4.7k -> 4K7L, 49.9 -> 49R9L, 0 -> 0RL."""
    if v == 0:
        return "RC0402JR-070RL"
    for suf, m in (("M", 1e6), ("K", 1e3), ("R", 1)):
        if v >= m:
            x = v / m
            s = f"{x:.3g}"
            if "." in s:
                a, b = s.split(".")
                code = f"{a}{suf}{b}"
            else:
                code = f"{s}{suf}"
            return f"RC0402{'F' if tol == 1 else 'J'}R-07{code}L"
    return "?"


def resistor(val, tol=1, size="0402", power="0,063 Вт"):
    v = parse_val(val)
    key = _reg_symbol("R", _eskd("R"))
    pn = _yageo(v, tol) if size == "0402" else f"RC0603FR-07{val.upper()}L"
    vtxt = "0 Ом" if v == 0 else ru_val(v, "Ом")
    name = f"Резистор {size} {vtxt} ±{tol} % {power}" if v else f"Перемычка {size} 0 Ом"
    pd = _mk(key, "R", "Резисторы", name, pn, "Yageo", f"Resistor_SMD:R_{size}_{_metric(size)}Metric", value=vtxt.replace(" ", ""))
    return pd


_C_PN = {  # значение -> (артикул, производитель, корпус, диэлектрик, напряжение)
    "1.7p": ("GJM1555C1H1R7BB01D", "Murata", "0402", "C0G", "50 В"),
    "10p": ("GRM1555C1H100JA01D", "Murata", "0402", "C0G", "50 В"),
    "13p": ("GJM1555C1H130FB01D", "Murata", "0402", "C0G", "50 В"),
    "15p": ("GRM1555C1H150JA01D", "Murata", "0402", "C0G", "50 В"),
    "22p": ("GRM1555C1H220JA01D", "Murata", "0402", "C0G", "50 В"),
    "100p": ("GRM1555C1H101JA01D", "Murata", "0402", "C0G", "50 В"),
    "470p": ("GRM1555C1H471JA01D", "Murata", "0402", "C0G", "50 В"),
    "750p": ("UMK105CH751JVHF", "Taiyo Yuden", "0402", "C0G (CH)", "50 В"),
    "10n": ("GRM155R71H103KA88D", "Murata", "0402", "X7R", "50 В"),
    "100n": ("GRM155R71C104KA88D", "Murata", "0402", "X7R", "16 В"),
    "1u": ("GRM155R61A105KE15D", "Murata", "0402", "X5R", "10 В"),
    "2.2u": ("GRM155R61A225KE95D", "Murata", "0402", "X5R", "10 В"),
    "4.7u": ("GRM155R60J475ME47D", "Murata", "0402", "X5R", "6,3 В"),
    "10u": ("GRM188R61A106KE69D", "Murata", "0603", "X5R", "10 В"),
    "22u": ("GRM188R61A226ME15D", "Murata", "0603", "X5R", "10 В"),
}


def capacitor(val):
    pn, mfr, size, diel, volt = _C_PN[val]
    key = _reg_symbol("C", _eskd("C"))
    v = parse_val(val)
    vtxt = ru_val(v, "Ф")
    return _mk(key, "C", "Конденсаторы", f"Конденсатор {size} {diel} {volt} {vtxt}", pn, mfr,
               f"Capacitor_SMD:C_{size}_{_metric(size)}Metric", value=vtxt.replace(" ", ""))


_L_PN = {
    "5.6n": ("LQW15AN5N6C8ZD", "Murata", "0402", "Катушка индуктивности 0402 5,6 нГн ±0,2 нГн"),
    "68n": ("LQW18AN68NJ00D", "Murata", "0603", "Катушка индуктивности 0603 68 нГн ±5 %"),
    "2.2u": ("XFL4020-222MEC", "Coilcraft", "4020", "Дроссель 4×4 мм 2,2 мкГн ±20 % 3,5 А"),
    "FB220": ("BLM18PG221SN1D", "Murata", "0603", "Фильтр помехоподавляющий 0603 220 Ом/100 МГц 1,4 А"),
}


def inductor(val):
    pn, mfr, size, name = _L_PN[val]
    if val == "FB220":
        key = _reg_symbol("FB", _eskd("FB"))
        return _mk(key, "L", "Фильтры и дроссели", name, pn, mfr, "Inductor_SMD:L_0603_1608Metric", value="220Ом")
    key = _reg_symbol("L", _eskd("L"))
    fp = {"0402": "Inductor_SMD:L_0402_1005Metric", "0603": "Inductor_SMD:L_0603_1608Metric",
          "4020": "Inductor_SMD:L_Coilcraft_XxL4020"}[size]
    return _mk(key, "L", "Катушки индуктивности", name, pn, mfr, fp, value=ru_val(parse_val(val), "Гн").replace(" ", ""))


def _metric(size):
    return {"0201": "0603", "0402": "1005", "0603": "1608", "0805": "2012", "1206": "3216"}[size]


_eskd_cache = {}


def _eskd(key):
    if not _eskd_cache:
        for s in symlib.eskd_symbols():
            _eskd_cache[str(s[1])] = s
    return _eskd_cache[key]


def led(color):
    pn = {"зелёный": "APT1608SGC", "красный": "APT1608EC", "жёлтый": "APT1608YC", "синий": "APT1608QBC/D"}[color]
    key = _reg_symbol("LED", _eskd("LED"))
    return _mk(key, "HL", "Индикаторы", f"Светодиод 0603 {color} {pn}", pn, "Kingbright",
               "LED_SMD:LED_0603_1608Metric", value=pn)


def diode(kind):
    data = {
        "TVS5": ("D_TVS", "SMAJ5.0A", "Littelfuse", "Diode_SMD:D_SMA", "Ограничитель напряжения SMAJ5.0A 5 В 400 Вт"),
        "ESDRF": ("D_TVS", "ESD131-B1-W0201", "Infineon", "Diode_SMD:Infineon_SG-WLL-2-3_0.58x0.28_P0.36mm",
                  "Диод защитный ESD131-B1-W0201 ±5,5 В 0,23 пФ"),
        "SCH": ("D_Schottky", "BAT54J", "Nexperia", "Diode_SMD:D_SOD-323F", "Диод Шоттки BAT54J 30 В 0,2 А"),
    }[kind]
    key = _reg_symbol(data[0], _eskd(data[0]))
    return _mk(key, "VD", "Диоды", data[4], data[1], data[2], data[3], value=data[1])


def fuse():
    key = _reg_symbol("Fuse", _eskd("Fuse"))
    return _mk(key, "FU", "Предохранители", "Предохранитель самовосстанавливающийся 0,1 А FEMTOSMDC010F-2",
               "FEMTOSMDC010F-2", "Littelfuse", "Fuse:Fuse_0603_1608Metric", value="0,1А")


def crystal(kind):
    if kind == "19.2M":
        key = _reg_symbol("Crystal_GND24", _eskd("Crystal_GND24"))
        return _mk(key, "ZQ", "Резонаторы", "Резонатор кварцевый 19,2 МГц 2,5×2,0 мм CS05400-19.2M", "CS05400-19.2M",
                   "NDK", f"{LIB}:XTAL_SMD", value="19,2МГц")
    key = _reg_symbol("Crystal", _eskd("Crystal"))
    return _mk(key, "ZQ", "Резонаторы", "Резонатор кварцевый 32,768 кГц ABS07-32.768KHZ-7-T", "ABS07-32.768KHZ-7-T",
               "Abracon", "Crystal:Crystal_SMD_3215-2Pin_3.2x1.5mm", value="32,768кГц")


def coax(note=""):
    key = _reg_symbol("Coax", _eskd("Coax"))
    return _mk(key, "XW", "Соединители", "Розетка SMA угловая на край платы SMA-J-P-H-ST-EM1", "SMA-J-P-H-ST-EM1",
               "Samtec", "Connector_Coaxial:SMA_Samtec_SMA-J-P-X-ST-EM1_EdgeMount", value="SMA", note=note)


# ------------------------------------------------------------------ микросхемы
def _pins_list(src, libfile, name):
    sym = symlib.kicad(libfile, name) if src == "kicad" else symlib.pocket(name)
    return [dict(num=p["num"], name=p["name"].replace("~{", "").replace("}", ""), type=p["type"])
            for p in symlib.pin_table(sym)], sym


def _arrange(pins, left_names, right_names):
    """Расстановка выводов по сторонам. Имена: точное имя или '#номер'; '' — промежуток.
    Одноимённые выводы питания, заданные с префиксом '*', объединяются в стопку."""
    by_name, by_num, used = {}, {}, set()
    for p in pins:
        by_name.setdefault(p["name"], []).append(p)
        by_num[p["num"]] = p

    def take(spec):
        out = []
        for n in spec:
            if n == "":
                out.append(None)
                continue
            if n.startswith("*"):
                group = by_name[n[1:]]
                for g in group:
                    used.add(g["num"])
                out.append(dict(name=n[1:], num=group[0]["num"], type="power_in",
                                stack=[g["num"] for g in group]))
                continue
            p = by_num[n[1:]] if n.startswith("#") else by_name[n][0]
            used.add(p["num"])
            out.append(dict(p))
        return out
    L, R = take(left_names), take(right_names)
    rest = [p for p in pins if p["num"] not in used]
    return L, R, rest


def ic(key, prefix, group, name, pn, mfr, fp, src, libfile, srcname, units, rename=None):
    """units: [(title, left_names, right_names)]."""
    pins, _ = _pins_list(src, libfile, srcname)
    if rename:
        for p in pins:
            p["name"] = rename(p)
    if key not in SYMBOLS:
        us, all_rest = [], None
        for u in units:
            title, ln, rn = u[:3]
            extra = u[3] if len(u) > 3 else {}
            L, R, rest = _arrange(pins, ln, rn)
            us.append(dict(left=L, right=R, title=title, subtitle=extra.get("sub", ""),
                           spacing=extra.get("spacing", 2 * symlib.GRID)))
        # контроль: все выводы распределены по частям
        assigned = set()
        for u in us:
            for p in u["left"] + u["right"]:
                if p:
                    assigned.update(p.get("stack", [p["num"]]))
        missing = [p for p in pins if p["num"] not in assigned]
        if missing:
            raise ValueError(f"{key}: не распределены выводы {[(m['num'], m['name']) for m in missing][:20]}")
        SYMBOLS[key] = symlib.ic_symbol(key, prefix, us, value=pn, footprint=fp)
    pd = _mk(key, prefix, group, name, pn, mfr, fp, value=pn, src_pins=pins)
    pd.units = len(units)
    return pd
