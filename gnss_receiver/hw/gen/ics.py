"""Микросхемы МГП-8: источники цоколёвки и расстановка выводов на УГО (ГОСТ 2.743)."""
import json
import os
import re

from parts import ic, LIB

HERE = os.path.dirname(os.path.abspath(__file__))
ECP5_IO = json.load(open(os.path.join(HERE, "data", "ecp5_45f_cabga381_io.json")))

R = "Regulator_Linear.kicad_sym"


def max2771():
    return ic("MAX2771", "DA", "Микросхемы", "Микросхема MAX2771ETI+", "MAX2771ETI+", "Analog Devices",
              f"{LIB}:TQFN28", "pocket", None, "MAX2771",
              [("ГНСС ПРМ", ["LNAIN_HI", "LNAIN_LO", "", "LNAOUT_HI", "LNAOUT_LO", "MIXIN_HI", "MIXIN_LO", "",
                             "XTAL", "CPOUT", "ADC_CLKIN", "", "SHDN", "NC", "", "VCCRF", "VCCIF", "VCCVCO",
                             "VCCCP", "VCCD", "VCCADC"],
                ["I1", "I0", "Q1", "Q0", "", "CLKOUT", "LD", "", "SDATA", "SCLK", "CSN", "", "ANAIPOUT",
                 "ANAINOUT", "", "", "", "", "", "", "*EP"], {"sub": "MAX2771"})])


def rf_div():
    return ic("PD0922", "W", "Элементы СВЧ", "Делитель мощности СВЧ 1:2 PD0922J5050S2HF", "PD0922J5050S2HF",
              "TTM (Anaren)", f"{LIB}:RF_DIV", "pocket", None, "RF_DIV",
              [("÷2", ["INPUT", "", "GND@1", "GND@2", "GND@3"], ["OUT1", "OUT2"], {"sub": "1:2"})])


def avc9112():
    return ic("74AVC9112", "DD", "Микросхемы", "Микросхема 74AVC9112DCH", "74AVC9112DCH", "Nexperia",
              f"{LIB}:VSSOP8_SOT765-1_NEX", "pocket", None, "74AVC9112DCH",
              [("1", ["A", "#3", "", "VCC", "GND"], ["Y1", "Y2", "Y3", "Y4"])])


def fct3807():
    return ic("74FCT3807", "DD", "Микросхемы", "Микросхема 74FCT3807APYG", "74FCT3807APYG", "Renesas",
              f"{LIB}:SSOP20", "pocket", None, "74FCT3807APYG",
              [("1", ["IN", "", "*VCC", "*GND"], ["O1", "O2", "O3", "O4", "O5", "O6", "O7", "O8", "O9", "O10"])])


def at24cm01():
    return ic("AT24CM01", "DD", "Микросхемы", "Микросхема AT24CM01-XHM-T", "AT24CM01-XHM-T", "Microchip",
              f"{LIB}:TSSOP_8P", "pocket", None, "AT24C256C",
              [("EEPROM", ["A0", "A1", "A2", "WP", "", "VCC", "GND"], ["SDA", "SCL"])])


def pi3usb302():
    return ic("PI3USB302", "DD", "Микросхемы", "Микросхема PI3USB302-AZBEX", "PI3USB302-AZBEX", "Diodes Inc.",
              f"{LIB}:20TQFN-ZB_PI3USB302-A_DIO", "pocket", None, "PI3USB302-AZBEX",
              [("MUX", ["TX+", "TX-", "RX+", "RX-", "", "SEL", "PD", "", "*VDD", "*GND"],
                ["TX1+", "TX1-", "RX1+", "RX1-", "", "TX2+", "TX2-", "RX2+", "RX2-"], {"sub": "USB3"})])


def usb4080():
    return ic("USB4080", "XS", "Соединители", "Розетка USB Type-C USB4080-03-A", "USB4080-03-A", "GCT",
              f"{LIB}:USB4080-03-A_GCT", "pocket", None, "USB4080-03-A",
              [("USB-C", ["*VBUS", "CC1", "CC2", "SBU1", "SBU2", "", "DP1", "DN1", "DP2", "DN2", "", "*GND", "EP"],
                ["SSTXP1", "SSTXN1", "SSRXP1", "SSRXN1", "", "SSTXP2", "SSTXN2", "SSRXP2", "SSRXN2"])])


def fx3():
    gp = lambda n: f"GPIO[{n}]"
    data = [gp(i) for i in range(16)] + [gp(i) for i in range(33, 41)] + ["GPIO[41]/A0", "GPIO[42]/A1"] + \
           [gp(i) for i in (43, 44, 46, 47, 48, 49)]
    ctl = [gp(i) for i in range(16, 33)] + [gp(45)] + [gp(i) for i in range(50, 58)] + \
          ["I2C_GPIO[58]", "I2C_GPIO[59]", "O[60]"]
    return ic("CYUSB3014", "DD", "Микросхемы", "Микросхема CYUSB3014-BZXI", "CYUSB3014-BZXI", "Infineon",
              f"{LIB}:BGA-121", "pocket", None, "CYUSB3014-BZXC",
              [("GPIF II", data[:16], data[16:], {"sub": "FX3"}),
               ("GPIO", ctl[:15], ctl[15:]),
               ("USB/ПИТ", ["DP", "DM", "SSTXP", "SSTXM", "SSRXP", "SSRXM", "OTG_ID", "R_USB2", "R_USB3", "",
                            "XTALIN", "XTALOUT", "CLKIN", "CLKIN_32", "FSLC[0]", "FSLC[1]", "FSLC[2]", "",
                            "RESET#", "INT#", "TDI", "TDO", "TMS", "TCK", "TRST#", "NC"],
                ["VBUS", "VBATT", "", "*VIO1", "VIO2", "VIO3", "VIO4", "VIO5", "CVDDQ", "", "*VDD", "AVDD",
                 "U3TXVDDQ", "U3RXVDDQ", "", "*VSS", "AVSS", "U3VSSQ"])])


def stm32h743():
    a = [f"PA{i}" for i in range(16)]
    b = [f"PB{i}" for i in range(16)]
    c = ["PC0", "PC1", "PC2_C", "PC3_C"] + [f"PC{i}" for i in range(4, 16)]
    d = [f"PD{i}" for i in range(16)]
    e = [f"PE{i}" for i in range(16)]
    return ic("STM32H743", "DD", "Микросхемы", "Микросхема STM32H743VIT6", "STM32H743VIT6", "STMicroelectronics",
              "Package_QFP:LQFP-100_14x14mm_P0.5mm", "kicad", "MCU_ST_STM32H7.kicad_sym", "STM32H743VITx",
              [("MCU", a + [""] + b, c + [""] + ["PH0", "PH1"], {"sub": "Порты A, B, C, H"}),
               ("MCU", d, e, {"sub": "Порты D, E (FMC)"}),
               ("MCU", ["NRST", "BOOT0", "", "VBAT", "VREF+", "VDDA", "VSSA"],
                ["*VDD", "", "*VCAP", "", "*VSS"], {"sub": "Питание"})])


def _ecp5_name(ball):
    f = ECP5_IO.get(ball, {}).get("function", "")
    return f"{ball}" + (f" {f}" if f.startswith(("PCLK", "GR_PCLK")) else "")


def ecp5():
    """LFE5U-45F-6BG381I: цоколёвка CABGA381 из библиотеки KiCad (LFE5U-85F, совместим по выводам),
    принадлежность выводов банкам — по базе Project Trellis для 45F."""
    import symlib
    pins = symlib.pin_table(symlib.kicad("FPGA_Lattice.kicad_sym", "LFE5U-85F-6BG381x"))
    banks = {b: [] for b in (0, 1, 2, 3, 6, 7, 8)}
    for p in pins:
        if re.fullmatch(r"P[TBLR]\d+[A-D]", p["name"]):
            if p["num"] in ECP5_IO:
                banks[ECP5_IO[p["num"]]["bank"]].append("#" + p["num"])
            else:
                banks.setdefault("nc45", []).append("#" + p["num"])

    def half(lst):
        lst = sorted(lst, key=lambda s: (s[1], int(s[2:])))
        k = (len(lst) + 1) // 2
        return lst[:k], lst[k:]
    units = []
    for b, sub in ((0, "Банк 0"), (1, "Банк 1"), (2, "Банк 2"), (3, "Банк 3"), (6, "Банк 6"), (7, "Банк 7")):
        lst = banks[b] + (banks.get("nc45", []) if b == 2 else [])
        L, Rr = half(lst)
        units.append(("ПЛИС", L, Rr, {"sub": sub}))
    L8, R8 = half(banks[8])
    units.append(("ПЛИС", L8 + ["", "CFG_0", "CFG_1", "CFG_2", "", "PROGRAM", "INIT", "DONE", "CCLK"],
                  R8 + ["", "TCK", "TMS", "TDI", "TDO"], {"sub": "Банк 8, конфигурация"}))
    units.append(("ПЛИС", ["*VCC", "*VCCAUX", "", "*VCCIO0", "*VCCIO1", "*VCCIO2", "*VCCIO3", "*VCCIO6",
                           "*VCCIO7", "*VCCIO8"],
                  ["*GND", ""] + ["#" + b for b in ("W4", "W5", "W8", "W9", "W10", "W11", "W13", "W14", "W17", "W18")],
                  {"sub": "Питание"}))
    pd = ic("LFE5U45", "DD", "Микросхемы", "Микросхема LFE5U-45F-6BG381I", "LFE5U-45F-6BG381I", "Lattice",
            "Package_BGA:Lattice_caBGA-381_17.0x17.0mm_Layout20x20_P0.8mm_Ball0.4mm_Pad0.4mm_NSMD",
            "kicad", "FPGA_Lattice.kicad_sym", "LFE5U-85F-6BG381x", units,
            rename=lambda p: _ecp5_name(p["num"]) if re.fullmatch(r"P[TBLR]\d+[A-D]", p["name"]) else p["name"])
    pd.banks = banks
    return pd


def kicad_ic(key, prefix, name, pn, mfr, libfile, src, left, right, title, sub="", group="Микросхемы", fp=None):
    import symlib
    sym = symlib.kicad(libfile, src)
    fpk = fp
    if fpk is None:
        for p in sym:
            if isinstance(p, list) and p and p[0] == "property" and p[1] == "Footprint":
                fpk = str(p[2])
    return ic(key, prefix, group, name, pn, mfr, fpk, "kicad", libfile, src, [(title, left, right, {"sub": sub})])


def tps62130():
    return kicad_ic("TPS62130", "DA", "Микросхема TPS62130RGTR", "TPS62130RGTR", "Texas Instruments",
                    "Regulator_Switching.kicad_sym", "TPS62130",
                    ["*VIN", "EN", "", "FSW", "DEF", "SS/TR", "", "*GND"], ["*SW", "VOS", "FB", "PG"], "DC/DC", "3 А")


def lp5907(v):
    return kicad_ic(f"LP5907_{v}", "DA", f"Микросхема LP5907MFX-{v}/NOPB", f"LP5907MFX-{v}/NOPB", "Texas Instruments",
                    R, f"LP5907MFX-{v}", ["IN", "EN", "", "GND"], ["OUT", "NC"], "LDO", f"{v} В")


def spx3819(v):
    vv = v.replace(".", "-")
    return kicad_ic(f"SPX3819_{v}", "DA", f"Микросхема SPX3819M5-L-{vv}/TR", f"SPX3819M5-L-{vv}/TR", "MaxLinear",
                    R, f"SPX3819M5-L-{vv}", ["IN", "EN", "", "GND"], ["OUT", "BP"], "LDO", f"{v} В")


def max40200():
    return kicad_ic("MAX40200", "DA", "Микросхема MAX40200AUK+T", "MAX40200AUK+T", "Analog Devices",
                    "Analog_Switch.kicad_sym", "MAX40200AUK", ["VDD", "EN", "", "GND"], ["OUT", "NC"], "▷|", "1 А")


def tps22917():
    return kicad_ic("TPS22917", "DA", "Микросхема TPS22917DBVR", "TPS22917DBVR", "Texas Instruments",
                    "Power_Management.kicad_sym", "TPS22917DBV", ["VIN", "ON", "CT", "", "GND"], ["VOUT", "QOD"], "SW")


def ina181():
    return kicad_ic("INA181A1", "DA", "Микросхема INA181A1IDBVR", "INA181A1IDBVR", "Texas Instruments",
                    "Amplifier_Current.kicad_sym", "INA181", ["+", "-", "", "REF", "V+", "GND"], ["~"], "▷ I", "×20")


def mcp2562fd():
    return kicad_ic("MCP2562FD", "DA", "Микросхема MCP2562FD-E/SN", "MCP2562FD-E/SN", "Microchip",
                    "Interface_CAN_LIN.kicad_sym", "MCP2562-E-SN", ["TXD", "RXD", "STBY", "", "VDD", "Vio", "VSS"],
                    ["CANH", "CANL"], "CAN FD")


def tlv3501():
    return kicad_ic("TLV3501", "DA", "Микросхема TLV3501AIDBVR", "TLV3501AIDBVR", "Texas Instruments",
                    "Comparator.kicad_sym", "TLV3501AIDBV", ["+", "-", "SHDN", "", "V+", "V-"], ["~"], "▷", "4,5 нс")


def lvc1g125():
    return kicad_ic("LVC1G125", "DD", "Микросхема SN74LVC1G125DBVR", "SN74LVC1G125DBVR", "Texas Instruments",
                    "74xGxx.kicad_sym", "SN74LVC1G125DBV", ["#2", "#1", "", "VCC", "GND"], ["#4"], "1 ▽", "EN")


def lvc1g17():
    return kicad_ic("LVC1G17", "DD", "Микросхема SN74LVC1G17DBVR", "SN74LVC1G17DBVR", "Texas Instruments",
                    "74xGxx.kicad_sym", "74LVC1G17", ["#2", "NC", "", "VCC", "GND"], ["#4"], "1 ⎍",
                    fp="Package_TO_SOT_SMD:SOT-23-5")


def w25q128():
    return kicad_ic("W25Q128", "DD", "Микросхема W25Q128JVSIQ", "W25Q128JVSIQ", "Winbond",
                    "Memory_Flash.kicad_sym", "W25Q128JVS", ["CS", "CLK", "DI(IO0)", "DO(IO1)", "IO2", "IO3", "", "VCC", "GND"],
                    [], "FLASH", "128 Мбит")


def tcxo():
    return kicad_ic("TCXO24", "G", "Генератор кварцевый термокомпенсированный TG2520SMN 24.0000M-MCGNNM3",
                    "TG2520SMN 24.0000M-MCGNNM3", "Epson", "Oscillator.kicad_sym", "TG2520SMN-xx.xxxxxxMhz-xxxxNM",
                    ["Vcc", "GND", "NC"], ["OUT"], "G ТКГ", "24 МГц", group="Генераторы", fp=f"{LIB}:TCXO")


def usblc6():
    return kicad_ic("USBLC6", "DA", "Микросхема USBLC6-2SC6", "USBLC6-2SC6", "STMicroelectronics",
                    "Power_Protection.kicad_sym", "USBLC6-2SC6", ["#1", "#3", "", "VBUS", "GND"], ["#6", "#4"], "ESD")


def nup2105():
    return kicad_ic("NUP2105L", "VD", "Сборка диодная защитная NUP2105LT1G", "NUP2105LT1G", "onsemi",
                    "Power_Protection.kicad_sym", "NUP2105L", ["#1", "#2"], ["#3"], "ESD", "CAN", group="Диоды")


def microsd():
    return kicad_ic("MICROSD", "XS", "Держатель карты microSD DM3AT-SF-PEJM5", "DM3AT-SF-PEJM5", "Hirose",
                    "Connector.kicad_sym", "Micro_SD_Card_Det_Hirose_DM3AT",
                    ["DAT0", "DAT1", "DAT2", "DAT3/CD", "CMD", "CLK", "", "VDD", "VSS"],
                    ["DET_A", "DET_B", "", "SHIELD"], "microSD", group="Соединители")


def conn(key, pn, mfr, n, fp, name, title, labels=None):
    """Соединитель с номерами контактов (УГО по ГОСТ 2.755 в виде таблицы)."""
    from parts import SYMBOLS, _mk
    import symlib
    if key not in SYMBOLS:
        left = [dict(num=str(i + 1), name=(labels[i] if labels else str(i + 1)), type="passive") for i in range(n)]
        SYMBOLS[key] = symlib.ic_symbol(key, "X", [dict(left=left, right=[], title=title, min_w=15.24)], value=pn,
                                        footprint=fp)
    return _mk(key, "X", "Соединители", name, pn, mfr, fp, value=pn)
