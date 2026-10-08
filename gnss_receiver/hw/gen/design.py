"""Схема электрическая принципиальная МГП-8 (ШИВА.468157.001 Э3) в виде кода.

Каждый лист описывает функциональный узел. Цепи именуются латиницей; цепи питания
перечислены в POWER. Назначение выводов ПЛИС формируется функцией fpga_assign() и
выгружается в файл ограничений для сборки конфигурации ПЛИС (fpga/syn/mgp8.lpf).
"""
import parts as P
import ics
from netlist import Design

POWER = ["+5V_SYS", "+5V_USB", "+5V_GPS", "+5V_CAN", "+3V3D", "+1V1", "+2V5",
         "+3V3_RF1", "+3V3_RF2", "+3V3_RF3", "+3V3_RF4", "+3V3_CLK", "+1V2_CLK",
         "+3V3_FX3", "+1V2_FX3"]
GND = "GND"
CH = "ABCDEFGH"            # обозначения ВЧ-каналов 1..8


def R(v, **k):
    return P.resistor(v, **k)


def C(v):
    return P.capacitor(v)


# ------------------------------------------------------------------ назначение выводов ПЛИС
def fpga_signals():
    """Сигналы ПЛИС по банкам. Значение None — назначить свободный вывод банка."""
    b7, b6 = [], []
    for i, ch in enumerate(CH):
        sig = [f"MAX_I1_{ch}", f"MAX_I0_{ch}", f"MAX_Q1_{ch}", f"MAX_Q0_{ch}",
               f"MAX_LD_{ch}", f"MAX_CSN_{ch}", f"MAX_SHDN_{ch}"]
        (b7 if i < 4 else b6).extend(sig)
    b7 += ["MAX_SCLK", "MAX_SDATA"]
    fixed = {"ADC_SCLK": "G2", "REF_CMP": "H2",
             "FLASH_CS": "R2", "FLASH_MOSI": "W2", "FLASH_MISO": "V2", "FLASH_WP": "Y2", "FLASH_HOLD": "W1"}
    fx3 = [f"FX3_G{i}" for i in list(range(16)) + list(range(33, 45)) + list(range(46, 50))]
    fx3 += ["FX3_PCLK", "FX3_SCLK", "FX3_SDATA"] + [f"FX3_CSN_{c}" for c in CH] + [f"FX3_LOCK_{c}" for c in CH]
    fx3 += ["FX3_PWR_OK"]
    dbg = [f"FPGA_DBG{i}" for i in range(8)]
    mcu = [f"FMC_DA{i}" for i in range(16)] + ["FMC_NOE", "FMC_NWE", "FMC_NE1", "FMC_NL", "FMC_NWAIT",
                                               "FPGA_IRQ", "MCU_CLK24", "PPS_MCU", "EXTINT_MCU",
                                               "PPS_FPGA", "EXTINT_FPGA", "LED_PPS", "LED_STAT"]
    return dict(b7=b7, b6=b6, b01=fx3 + dbg, b23=mcu, fixed=fixed)


def fpga_assign(pd):
    s = fpga_signals()
    io = ics.ECP5_IO
    used = set(s["fixed"].values())
    assign = dict(s["fixed"])

    def balls(banks):
        out = [b for b in sorted(io, key=lambda x: (x[0], int(x[1:]))) if io[b]["bank"] in banks and b not in used]
        return out
    for key, banks in (("b7", (7,)), ("b6", (6,)), ("b01", (0, 1)), ("b23", (2, 3))):
        free = balls(banks)
        for sig in s[key]:
            if not free:
                raise RuntimeError(f"ПЛИС: не хватает выводов в банках {banks} для {sig}")
            b = free.pop(0)
            assign[sig] = b
            used.add(b)
    return assign


# ------------------------------------------------------------------ схема
def build():
    d = Design("МГП-8")
    d.power_nets = set(POWER)

    # ===================================================== лист 2: питание
    s = d.sheet("power", "Вторичные источники питания")
    ideal = ics.max40200()
    for src, blk in (("+5V_USB", "or1"), ("+5V_GPS", "or2"), ("+5V_CAN", "or3")):
        s.add(P.diode("TVS5"), {"1": src, "2": GND}, blk)
        s.add(C("1u"), {"1": src, "2": GND}, blk)
        s.add(ideal, {"VDD": src, "EN": src, "GND": GND, "OUT": "+5V_SYS", "NC": None}, blk)
    for _ in range(2):
        s.add(C("22u"), {"1": "+5V_SYS", "2": GND}, "bulk5")
    buck = ics.tps62130()
    for net, rtop, sw, blk in (("+3V3D", "316k", "SW_3V3", "dc1"), ("+1V1", "37.4k", "SW_1V1", "dc2")):
        fb = f"FB_{net[1:]}"
        pg = f"PG_{net[1:]}"
        s.add(buck, {"VIN": "+5V_SYS", "EN": "+5V_SYS", "FSW": GND, "DEF": GND, "SS/TR": f"SS_{net[1:]}",
                     "GND": GND, "SW": sw, "VOS": net, "FB": fb, "PG": pg}, blk)
        s.add(C("10u"), {"1": "+5V_SYS", "2": GND}, blk)
        s.add(C("100n"), {"1": "+5V_SYS", "2": GND}, blk)
        s.add(C("10n"), {"1": f"SS_{net[1:]}", "2": GND}, blk)
        s.add(P.inductor("2.2u"), {"1": sw, "2": net}, blk)
        s.add(R(rtop), {"1": net, "2": fb}, blk)
        s.add(R("100k"), {"1": fb, "2": GND}, blk)
        s.add(R("100k"), {"1": "+3V3D", "2": pg}, blk)
        for _ in range(2):
            s.add(C("22u"), {"1": net, "2": GND}, blk)
    # LDO: ВЧ-каналы (по два MAX2771 на стабилизатор), тактирование, VCCAUX
    for i in range(1, 5):
        rail = f"+3V3_RF{i}"
        blk = f"ldo{i}"
        s.add(ics.lp5907("3.3"), {"IN": "+5V_SYS", "EN": "+5V_SYS", "GND": GND, "OUT": rail, "NC": None}, blk)
        s.add(C("1u"), {"1": "+5V_SYS", "2": GND}, blk)
        s.add(C("4.7u"), {"1": rail, "2": GND}, blk)
    s.add(ics.lp5907("3.3"), {"IN": "+5V_SYS", "EN": "+5V_SYS", "GND": GND, "OUT": "+3V3_CLK", "NC": None}, "ldoc")
    s.add(C("1u"), {"1": "+5V_SYS", "2": GND}, "ldoc")
    s.add(C("4.7u"), {"1": "+3V3_CLK", "2": GND}, "ldoc")
    s.add(ics.lp5907("1.2"), {"IN": "+3V3_CLK", "EN": "+3V3_CLK", "GND": GND, "OUT": "+1V2_CLK", "NC": None}, "ldoc12")
    s.add(C("1u"), {"1": "+1V2_CLK", "2": GND}, "ldoc12")
    s.add(ics.lp5907("2.5"), {"IN": "+3V3D", "EN": "+3V3D", "GND": GND, "OUT": "+2V5", "NC": None}, "ldoa")
    s.add(C("1u"), {"1": "+3V3D", "2": GND}, "ldoa")
    s.add(C("4.7u"), {"1": "+2V5", "2": GND}, "ldoa")
    # контроль напряжений (АЦП МК)
    s.add(R("10k"), {"1": "+5V_SYS", "2": "V5_MON"}, "mon")
    s.add(R("10k"), {"1": "V5_MON", "2": GND}, "mon")
    s.add(R("10k"), {"1": "+3V3D", "2": "V3V3_MON"}, "mon")
    s.add(R("10k"), {"1": "V3V3_MON", "2": GND}, "mon")
    s.add(R("1k"), {"1": "+1V1", "2": "V1V1_MON"}, "mon")
    s.add(C("100n"), {"1": "V1V1_MON", "2": GND}, "mon")
    s.add(R("1k"), {"1": "+3V3D", "2": "LED_PWR"}, "mon")
    s.add(P.led("зелёный"), {"2": "LED_PWR", "1": GND}, "mon")

    # ===================================================== лист 3: антенный вход и делитель
    s = d.sheet("ant", "Антенный вход, питание антенны, ВЧ-делитель 1:8")
    s.add(P.coax("Антенна"), {"1": "RF_ANT", "2": GND}, "in")
    s.add(P.diode("ESDRF"), {"1": "RF_ANT", "2": GND}, "in")
    s.add(P.inductor("68n"), {"1": "VANT_F", "2": "RF_ANT"}, "in")
    s.add(C("470p"), {"1": "RF_ANT", "2": "RF_DIV_IN"}, "in")
    s.add(C("100p"), {"1": "VANT_F", "2": GND}, "in")
    s.add(C("100n"), {"1": "VANT_F", "2": GND}, "in")
    s.add(P.fuse(), {"1": "VANT_SNS", "2": "VANT_F"}, "in")
    s.add(R("0"), {"1": "+5V_SYS", "2": "VANT_SRC"}, "sw", note="Питание антенны 5 В")
    s.add(R("0"), {"1": "+3V3D", "2": "VANT_SRC"}, "sw", dnp=True, note="Питание антенны 3,3 В")
    s.add(ics.tps22917(), {"VIN": "VANT_SRC", "ON": "ANT_EN", "CT": "ANT_CT", "GND": GND,
                           "VOUT": "VANT_SW", "QOD": "VANT_SW"}, "sw")
    s.add(C("1u"), {"1": "VANT_SRC", "2": GND}, "sw")
    s.add(C("10n"), {"1": "ANT_CT", "2": GND}, "sw")
    s.add(R("100k"), {"1": "ANT_EN", "2": GND}, "sw")
    s.add(R("1", tol=1), {"1": "VANT_SW", "2": "VANT_SNS"}, "imon")
    s.add(ics.ina181(), {"+": "VANT_SW", "-": "VANT_SNS", "REF": GND, "V+": "+3V3D", "GND": GND,
                         "~": "ANT_IMON_R"}, "imon")
    s.add(C("100n"), {"1": "+3V3D", "2": GND}, "imon")
    s.add(R("100"), {"1": "ANT_IMON_R", "2": "ANT_IMON"}, "imon")
    s.add(C("10n"), {"1": "ANT_IMON", "2": GND}, "imon")
    div = ics.rf_div()
    tree = [("RF_DIV_IN", "RF_S1A", "RF_S1B"), ("RF_S1A", "RF_S2A", "RF_S2B"), ("RF_S1B", "RF_S2C", "RF_S2D"),
            ("RF_S2A", "RF1", "RF2"), ("RF_S2B", "RF3", "RF4"), ("RF_S2C", "RF5", "RF6"), ("RF_S2D", "RF7", "RF8")]
    for k, (inp, o1, o2) in enumerate(tree):
        blk = f"div{k}"
        s.add(div, {"INPUT": inp, "OUT1": o1, "OUT2": o2, "GND@1": GND, "GND@2": GND, "GND@3": GND}, blk)
        s.add(R("100"), {"1": o1, "2": o2}, blk)

    # ===================================================== листы 4–5: ВЧ-каналы
    mx = ics.max2771()
    for half, sid, title in ((0, "rf1", "Приёмные ВЧ-каналы 1–4"), (1, "rf2", "Приёмные ВЧ-каналы 5–8")):
        s = d.sheet(sid, title)
        for i in range(half * 4, half * 4 + 4):
            n, ch = i + 1, CH[i]
            rail = f"+3V3_RF{i // 2 + 1}"
            blk = f"ch{n}"
            s.add(C("470p"), {"1": f"RF{n}", "2": f"RFM_{ch}"}, blk)
            s.add(C("1.7p"), {"1": f"RFM_{ch}", "2": GND}, blk)
            s.add(P.inductor("5.6n"), {"1": f"RFM_{ch}", "2": f"LNAIN_{ch}"}, blk)
            s.add(mx, {
                "LNAIN_HI": f"LNAIN_{ch}", "LNAIN_LO": GND, "LNAOUT_HI": f"LNAO_{ch}", "LNAOUT_LO": None,
                "MIXIN_HI": f"MIXI_{ch}", "MIXIN_LO": GND, "XTAL": f"XTAL_{ch}", "CPOUT": f"CP_{ch}",
                "ADC_CLKIN": f"ADC_CLK_{ch}", "CLKOUT": "ADC_CLK_SRC" if i == 0 else None,
                "SHDN": f"MAX_SHDN_{ch}", "NC": None, "LD": f"MAX_LD_{ch}",
                "I1": f"MAX_I1_{ch}", "I0": f"MAX_I0_{ch}", "Q1": f"MAX_Q1_{ch}", "Q0": f"MAX_Q0_{ch}",
                "SDATA": "MAX_SDATA", "SCLK": "MAX_SCLK", "CSN": f"MAX_CSN_{ch}",
                "ANAIPOUT": None, "ANAINOUT": None,
                "VCCRF": rail, "VCCIF": rail, "VCCVCO": rail, "VCCCP": rail, "VCCD": rail, "VCCADC": rail,
                "EP": GND}, blk)
            s.add(C("470p"), {"1": f"LNAO_{ch}", "2": f"MIXI_{ch}"}, blk)
            s.add(C("15p"), {"1": f"CP_{ch}", "2": GND}, blk)
            s.add(R("15k"), {"1": f"CP_{ch}", "2": f"CPR_{ch}"}, blk)
            s.add(C("750p"), {"1": f"CPR_{ch}", "2": GND}, blk)
            s.add(C("10n"), {"1": f"REFCLK_{ch}", "2": f"XTAL_{ch}"}, blk)
            s.add(R("10k"), {"1": rail, "2": f"MAX_SHDN_{ch}"}, blk)
            s.add(C("100p"), {"1": rail, "2": GND}, blk)
            for _ in range(6):
                s.add(C("100n"), {"1": rail, "2": GND}, blk)

    # ===================================================== лист 6: тактирование, 1PPS, опора
    s = d.sheet("clk", "Опорный генератор, тактирование, вход опоры 10 МГц / 1PPS, выход 1PPS")
    s.add(ics.tcxo(), {"Vcc": "+3V3_CLK", "GND": GND, "NC": None, "OUT": "TCXO_OUT"}, "tcxo")
    s.add(C("100n"), {"1": "+3V3_CLK", "2": GND}, "tcxo")
    s.add(C("10u"), {"1": "+3V3_CLK", "2": GND}, "tcxo")
    s.add(C("10n"), {"1": "TCXO_OUT", "2": "TCXO_AC"}, "tcxo")
    s.add(R("100k"), {"1": "+1V2_CLK", "2": "TCXO_AC"}, "tcxo")
    s.add(R("100k"), {"1": "TCXO_AC", "2": GND}, "tcxo")
    buf = ics.avc9112()
    for k, chs in enumerate(("ABCD", "EFGH")):
        blk = f"rbuf{k}"
        s.add(buf, {"A": "TCXO_AC", "#3": GND, "VCC": "+1V2_CLK", "GND": GND,
                    "Y4": f"REFCLK_{chs[0]}", "Y3": f"REFCLK_{chs[1]}", "Y2": f"REFCLK_{chs[2]}", "Y1": f"REFCLK_{chs[3]}"}, blk)
        s.add(C("100n"), {"1": "+1V2_CLK", "2": GND}, blk)
    fct = {"IN": "ADC_CLK_SRC", "VCC": "+3V3_CLK", "GND": GND, "O9": "ADC_SCLK_R", "O10": None}
    for k, ch in enumerate(CH):
        fct[f"O{k + 1}"] = f"ADC_CLK_{ch}"
    s.add(ics.fct3807(), fct, "adcclk")
    s.add(R("22"), {"1": "ADC_SCLK_R", "2": "ADC_SCLK"}, "adcclk")
    s.add(C("10u"), {"1": "+3V3_CLK", "2": GND}, "adcclk")
    for _ in range(4):
        s.add(C("100n"), {"1": "+3V3_CLK", "2": GND}, "adcclk")
    # вход внешней опоры 10 МГц / 1PPS
    s.add(P.coax("Опора 10 МГц / 1PPS"), {"1": "REF_IN", "2": GND}, "ref")
    s.add(P.diode("ESDRF"), {"1": "REF_IN", "2": GND}, "ref")
    s.add(R("49.9"), {"1": "REF_IN", "2": GND}, "ref")
    s.add(C("100n"), {"1": "REF_IN", "2": "REF_AC"}, "ref")
    s.add(R("10k"), {"1": "+3V3_CLK", "2": "REF_AC"}, "ref")
    s.add(R("10k"), {"1": "REF_AC", "2": GND}, "ref")
    s.add(R("10k"), {"1": "+3V3_CLK", "2": "REF_TH"}, "ref")
    s.add(R("9.53k"), {"1": "REF_TH", "2": GND}, "ref")
    s.add(C("100n"), {"1": "REF_TH", "2": GND}, "ref")
    s.add(ics.tlv3501(), {"+": "REF_AC", "-": "REF_TH", "SHDN": GND, "V+": "+3V3_CLK", "V-": GND, "~": "REF_CMP_R"}, "ref")
    s.add(C("100n"), {"1": "+3V3_CLK", "2": GND}, "ref")
    s.add(R("22"), {"1": "REF_CMP_R", "2": "REF_CMP"}, "ref")
    # выход 1PPS (SMA) и порт времени
    b125 = ics.lvc1g125()
    s.add(b125, {"#2": "PPS_FPGA", "#1": GND, "VCC": "+3V3D", "GND": GND, "#4": "PPS_SMA_R"}, "pps")
    s.add(R("33"), {"1": "PPS_SMA_R", "2": "PPS_OUT"}, "pps")
    s.add(P.diode("ESDRF"), {"1": "PPS_OUT", "2": GND}, "pps")
    s.add(P.coax("Выход 1PPS"), {"1": "PPS_OUT", "2": GND}, "pps")
    s.add(C("100n"), {"1": "+3V3D", "2": GND}, "pps")
    s.add(b125, {"#2": "PPS_FPGA", "#1": GND, "VCC": "+3V3D", "GND": GND, "#4": "PPS_PORT_R"}, "pps2")
    s.add(R("33"), {"1": "PPS_PORT_R", "2": "PPS_PORT"}, "pps2")
    s.add(C("100n"), {"1": "+3V3D", "2": GND}, "pps2")
    s.add(R("1k"), {"1": "EXTINT_IN", "2": "EXTINT_R"}, "ext")
    s.add(R("100k"), {"1": "EXTINT_R", "2": GND}, "ext")
    s.add(ics.lvc1g17(), {"#2": "EXTINT_R", "NC": None, "VCC": "+3V3D", "GND": GND, "#4": "EXTINT_FPGA"}, "ext")
    s.add(C("100n"), {"1": "+3V3D", "2": GND}, "ext")

    # ===================================================== листы 7–8: ПЛИС
    fp = ics.ecp5()
    pins = fpga_assign(fp)
    d.fpga_pins = pins
    ball2sig = {b: sig for sig, b in pins.items()}
    conns = {}
    for num in fp.all_pins:
        conns["#" + num] = None
    for b, sig in ball2sig.items():
        conns["#" + b] = sig
    conns.update({"VCC": "+1V1", "VCCAUX": "+2V5", "GND": GND, "RESERVED": None})
    for bank in ("0", "1", "2", "3", "6", "7", "8"):
        conns[f"VCCIO{bank}"] = "+3V3D"
    conns.update({"CFG_0": GND, "CFG_1": "+3V3D", "CFG_2": GND, "PROGRAM": "FPGA_PROGRAMN", "INIT": "FPGA_INITN",
                  "DONE": "FPGA_DONE", "CCLK": "FLASH_CLK", "TCK": "FPGA_TCK", "TMS": "FPGA_TMS",
                  "TDI": "FPGA_TDI", "TDO": "FPGA_TDO"})
    # сигналы, подаваемые на ПЛИС через последовательные резисторы, переименованы здесь
    s = d.sheet("fpga1", "ПЛИС: банки ввода-вывода", paper="A2")
    s2 = d.sheet("fpga2", "ПЛИС: конфигурация, питание, память конфигурации, JTAG", paper="A2")
    units = {1: "fpga1", 2: "fpga1", 3: "fpga1", 4: "fpga1", 5: "fpga1", 6: "fpga1", 7: "fpga2", 8: "fpga2"}
    s.add(fp, conns, "fpga", units=units)
    # конфигурация и флеш-память
    s2.add(ics.w25q128(), {"CS": "FLASH_CS", "CLK": "FLASH_CLK", "DI(IO0)": "FLASH_MOSI", "DO(IO1)": "FLASH_MISO",
                           "IO2": "FLASH_WP", "IO3": "FLASH_HOLD", "VCC": "+3V3D", "GND": GND}, "flash")
    s2.add(C("100n"), {"1": "+3V3D", "2": GND}, "flash")
    for net in ("FLASH_CS", "FLASH_WP", "FLASH_HOLD", "FPGA_PROGRAMN", "FPGA_INITN", "FPGA_DONE"):
        s2.add(R("10k"), {"1": "+3V3D", "2": net}, "cfgpu")
    s2.add(R("10k"), {"1": "+3V3D", "2": "FPGA_TMS"}, "jtag")
    s2.add(R("10k"), {"1": "+3V3D", "2": "FPGA_TDI"}, "jtag")
    s2.add(R("4.7k"), {"1": "FPGA_TCK", "2": GND}, "jtag")
    jt = ics.conn("JTAG10", "FTSH-105-01-L-DV-K", "Samtec", 10,
                  "Connector_PinHeader_1.27mm:PinHeader_2x05_P1.27mm_Vertical_SMD",
                  "Вилка 2×5 контактов шаг 1,27 мм FTSH-105-01-L-DV-K", "JTAG",
                  ["VREF", "TMS", "GND", "TCK", "GND", "TDO", "KEY", "TDI", "GND", "PROG"])
    s2.add(jt, {"1": "+3V3D", "2": "FPGA_TMS", "3": GND, "4": "FPGA_TCK", "5": GND, "6": "FPGA_TDO",
                "7": None, "8": "FPGA_TDI", "9": GND, "10": "FPGA_PROGRAMN"}, "jtag")
    dbg = ics.conn("DBG10", "FTSH-105-01-L-DV-K", "Samtec", 10,
                   "Connector_PinHeader_1.27mm:PinHeader_2x05_P1.27mm_Vertical_SMD",
                   "Вилка 2×5 контактов шаг 1,27 мм FTSH-105-01-L-DV-K", "ОТЛ",
                   ["D0", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "3V3", "GND"])
    s2.add(dbg, {**{str(i + 1): f"FPGA_DBG{i}" for i in range(8)}, "9": "+3V3D", "10": GND}, "dbg")
    s2.add(R("1k"), {"1": "LED_PPS", "2": "LED_PPS_A"}, "led")
    s2.add(P.led("синий"), {"2": "LED_PPS_A", "1": GND}, "led")
    s2.add(R("1k"), {"1": "LED_STAT", "2": "LED_STAT_A"}, "led")
    s2.add(P.led("красный"), {"2": "LED_STAT_A", "1": GND}, "led")
    # развязка питания ПЛИС
    for net, n100, nbig, big in (("+1V1", 10, 2, "22u"), ("+2V5", 4, 1, "10u"), ("+3V3D", 16, 2, "10u")):
        for _ in range(nbig):
            s2.add(C(big), {"1": net, "2": GND}, f"dec_{net}")
        for _ in range(n100):
            s2.add(C("100n"), {"1": net, "2": GND}, f"dec_{net}")

    # ===================================================== лист 9: микроконтроллер
    s = d.sheet("mcu", "Управляющий микроконтроллер, microSD, CAN FD", paper="A2")
    mcu = ics.stm32h743()
    mc = {f"#{n}": None for n in mcu.all_pins}
    fmc = {"PD14": 0, "PD15": 1, "PD0": 2, "PD1": 3, "PE7": 4, "PE8": 5, "PE9": 6, "PE10": 7, "PE11": 8,
           "PE12": 9, "PE13": 10, "PE14": 11, "PE15": 12, "PD8": 13, "PD9": 14, "PD10": 15}
    for pin, k in fmc.items():
        mc[pin] = f"FMC_DA{k}"
    mc.update({"PD4": "FMC_NOE", "PD5": "FMC_NWE", "PD7": "FMC_NE1", "PB7": "FMC_NL", "PD6": "FMC_NWAIT",
               "PH0": "MCU_CLK24", "PH1": None,
               "PA9": "GPS_TX", "PA10": "GPS_RX", "PD12": "GPS_SCL", "PD13": "GPS_SDA",
               "PA0": "DBG_TX", "PA1": "DBG_RX", "PA2": "PPS_MCU", "PA3": "EXTINT_MCU",
               "PB8": "CAN_RX", "PB9": "CAN_TX", "PB12": "CAN_STBY", "PB13": "SD_CD",
               "PC8": "SD_D0", "PC9": "SD_D1", "PC10": "SD_D2", "PC11": "SD_D3", "PC12": "SD_CLK_R", "PD2": "SD_CMD",
               "PC0": "ANT_IMON", "PC1": "V5_MON", "PC4": "V3V3_MON", "PC5": "V1V1_MON",
               "PE2": "FPGA_PROGRAMN", "PE3": "FPGA_INITN", "PE4": "FPGA_DONE", "PE5": "FPGA_IRQ",
               "PE6": "ANT_EN", "PB2": "FX3_RESETN", "PC13": "LED_FIX_K", "PB14": "LED_ANT_K",
               "PA13": "SWDIO", "PA14": "SWCLK", "PB3": "SWO", "PA15": "MCU_TDI",
               "PC14": "OSC32_IN", "PC15": "OSC32_OUT",
               "NRST": "MCU_NRST", "BOOT0": "MCU_BOOT0", "VBAT": "+3V3D", "VREF+": "VDDA", "VDDA": "VDDA",
               "VSSA": GND, "VDD": "+3V3D", "VCAP": "VCAP", "VSS": GND})
    s.add(mcu, mc, "mcu", units={1: "mcu", 2: "mcu", 3: "mcu"})
    s.add(P.crystal("32k"), {"1": "OSC32_IN", "2": "OSC32_OUT"}, "osc")
    s.add(C("10p"), {"1": "OSC32_IN", "2": GND}, "osc")
    s.add(C("10p"), {"1": "OSC32_OUT", "2": GND}, "osc")
    s.add(C("100n"), {"1": "MCU_NRST", "2": GND}, "sys")
    s.add(R("10k"), {"1": "MCU_BOOT0", "2": GND}, "sys")
    s.add(C("2.2u"), {"1": "VCAP", "2": GND}, "sys")
    s.add(C("2.2u"), {"1": "VCAP", "2": GND}, "sys")
    s.add(P.inductor("FB220"), {"1": "+3V3D", "2": "VDDA"}, "sys")
    s.add(C("1u"), {"1": "VDDA", "2": GND}, "sys")
    s.add(C("100n"), {"1": "VDDA", "2": GND}, "sys")
    s.add(C("4.7u"), {"1": "+3V3D", "2": GND}, "sys")
    for _ in range(6):
        s.add(C("100n"), {"1": "+3V3D", "2": GND}, "sys")
    swd10 = ics.conn("SWD10", "FTSH-105-01-L-DV-K", "Samtec", 10,
                     "Connector_PinHeader_1.27mm:PinHeader_2x05_P1.27mm_Vertical_SMD",
                     "Вилка 2×5 контактов шаг 1,27 мм FTSH-105-01-L-DV-K", "SWD",
                     ["VREF", "SWDIO", "GND", "SWCLK", "GND", "SWO", "KEY", "TDI", "GND", "RST"])
    s.add(swd10, {"1": "+3V3D", "2": "SWDIO", "3": GND, "4": "SWCLK", "5": GND, "6": "SWO", "7": None,
                  "8": "MCU_TDI", "9": GND, "10": "MCU_NRST"}, "swd")
    s.add(P.led("зелёный"), {"2": "LED_FIX_A", "1": "LED_FIX_K"}, "leds")
    s.add(R("1k"), {"1": "+3V3D", "2": "LED_FIX_A"}, "leds")
    s.add(P.led("жёлтый"), {"2": "LED_ANT_A", "1": "LED_ANT_K"}, "leds")
    s.add(R("1k"), {"1": "+3V3D", "2": "LED_ANT_A"}, "leds")
    # microSD
    sd = ics.microsd()
    s.add(sd, {"DAT0": "SD_D0", "DAT1": "SD_D1", "DAT2": "SD_D2", "DAT3/CD": "SD_D3", "CMD": "SD_CMD",
               "CLK": "SD_CLK", "VDD": "+3V3D", "VSS": GND, "DET_A": "SD_CD", "DET_B": GND, "SHIELD": GND}, "sd")
    s.add(R("33"), {"1": "SD_CLK_R", "2": "SD_CLK"}, "sd")
    for net in ("SD_D0", "SD_D1", "SD_D2", "SD_D3", "SD_CMD", "SD_CD"):
        s.add(R("47k"), {"1": "+3V3D", "2": net}, "sd")
    s.add(C("10u"), {"1": "+3V3D", "2": GND}, "sd")
    # CAN FD
    s.add(ics.mcp2562fd(), {"TXD": "CAN_TX", "RXD": "CAN_RX", "STBY": "CAN_STBY", "VDD": "+5V_SYS", "Vio": "+3V3D",
                            "VSS": GND, "CANH": "CAN_H", "CANL": "CAN_L"}, "can")
    s.add(R("10k"), {"1": "+3V3D", "2": "CAN_STBY"}, "can")
    s.add(C("100n"), {"1": "+5V_SYS", "2": GND}, "can")
    s.add(C("100n"), {"1": "+3V3D", "2": GND}, "can")
    s.add(R("120"), {"1": "CAN_H", "2": "CAN_L"}, "can", dnp=True, note="Оконечная нагрузка шины, по заказу")
    s.add(ics.nup2105(), {"#1": "CAN_H", "#2": "CAN_L", "#3": GND}, "can")

    # ===================================================== лист 10: USB 3.0 (FX3)
    s = d.sheet("usb", "Контроллер USB 3.0 (режим выдачи отсчётов ПЧ)", paper="A2")
    fx = ics.fx3()
    fc = {f"#{n}": None for n in fx.all_pins}
    gpio_net = {}
    for i in list(range(16)) + list(range(33, 45)) + list(range(46, 50)):
        gpio_net[i] = f"FX3_G{i}"
    for k, c in enumerate(CH):
        gpio_net[17 + k] = f"FX3_CSN_{c}"
        gpio_net[50 + k] = f"FX3_LOCK_{c}"
    gpio_net.update({16: "FX3_PCLK", 25: "FX3_SCLK", 26: "FX3_SDATA", 27: "FX3_LED1", 28: "FX3_LED2",
                     29: None, 30: None, 31: "FX3_PMODE1", 32: None, 45: "USB3_PORT_SEL"})
    for name, nums in fx.pins.items():
        import re as _re
        m = _re.fullmatch(r"(?:I2C_)?GPIO\[(\d+)\](?:/A\d)?", name)
        if m and int(m.group(1)) in gpio_net:
            fc[name] = gpio_net[int(m.group(1))]
    fc.update({"I2C_GPIO[58]": "FX3_SCL", "I2C_GPIO[59]": "FX3_SDA", "O[60]": None,
               "DP": "USB_DP", "DM": "USB_DM", "SSTXP": "SSTX_P_C", "SSTXM": "SSTX_N_C", "SSRXP": "SSRX_P",
               "SSRXM": "SSRX_N", "OTG_ID": None, "R_USB2": "FX3_RUSB2", "R_USB3": "FX3_RUSB3",
               "XTALIN": "FX3_XI", "XTALOUT": "FX3_XO", "CLKIN": None, "CLKIN_32": None,
               "FSLC[0]": GND, "FSLC[1]": GND, "FSLC[2]": GND, "RESET#": "FX3_RESETN", "INT#": None,
               "TDI": None, "TDO": None, "TMS": None, "TCK": None, "TRST#": None, "NC": None,
               "VBUS": "+5V_USB", "VBATT": "+5V_USB", "VIO1": "+3V3_FX3", "VIO2": "+3V3_FX3", "VIO3": "+3V3_FX3",
               "VIO4": "+3V3_FX3", "VIO5": "+3V3_FX3", "CVDDQ": "+3V3_FX3", "VDD": "+1V2_FX3", "AVDD": "+1V2_FX3",
               "U3TXVDDQ": "+1V2_FX3", "U3RXVDDQ": "+1V2_FX3", "VSS": GND, "AVSS": GND, "U3VSSQ": GND})
    s.add(fx, fc, "fx3", units={1: "usb", 2: "usb", 3: "usb"})
    s.add(P.crystal("19.2M"), {"1": "FX3_XO", "3": "FX3_XI", "2": GND, "4": GND}, "fx3x")
    s.add(C("13p"), {"1": "FX3_XI", "2": GND}, "fx3x")
    s.add(C("13p"), {"1": "FX3_XO", "2": GND}, "fx3x")
    s.add(R("6.04k"), {"1": "FX3_RUSB2", "2": GND}, "fx3x")
    s.add(R("200"), {"1": "FX3_RUSB3", "2": GND}, "fx3x")
    s.add(R("100k"), {"1": "+3V3_FX3", "2": "FX3_RESETN"}, "fx3x")
    s.add(C("1u"), {"1": "FX3_RESETN", "2": GND}, "fx3x")
    s.add(R("10k"), {"1": "+3V3_FX3", "2": "FX3_PMODE1"}, "fx3x")
    s.add(R("10k"), {"1": "USB3_PORT_SEL", "2": GND}, "fx3x")
    s.add(R("10k"), {"1": "+3V3_FX3", "2": "FX3_PWR_OK"}, "fx3x")
    s.add(R("1k"), {"1": "+3V3_FX3", "2": "FX3_LED1_A"}, "fx3led")
    s.add(P.led("зелёный"), {"2": "FX3_LED1_A", "1": "FX3_LED1"}, "fx3led")
    s.add(R("1k"), {"1": "+3V3_FX3", "2": "FX3_LED2_A"}, "fx3led")
    s.add(P.led("жёлтый"), {"2": "FX3_LED2_A", "1": "FX3_LED2"}, "fx3led")
    s.add(ics.at24cm01(), {"A0": "EEPROM_A", "A1": "EEPROM_A", "A2": GND, "WP": GND, "VCC": "+3V3_FX3", "GND": GND,
                           "SDA": "FX3_SDA", "SCL": "FX3_SCL"}, "eep")
    s.add(R("2.2k"), {"1": "+3V3_FX3", "2": "FX3_SDA"}, "eep")
    s.add(R("2.2k"), {"1": "+3V3_FX3", "2": "FX3_SCL"}, "eep")
    s.add(R("10k"), {"1": "EEPROM_A", "2": GND}, "eep")
    jp = ics.conn("JP2", "M22-2510205", "Harwin", 2, "Connector_PinHeader_2.00mm:PinHeader_1x02_P2.00mm_Vertical",
                  "Вилка 1×2 контакта шаг 2,0 мм M22-2510205", "BOOT", ["3V3", "A"])
    s.add(jp, {"1": "+3V3_FX3", "2": "EEPROM_A"}, "eep")
    s.add(C("100n"), {"1": "+3V3_FX3", "2": GND}, "eep")
    # USB Type-C
    s.add(ics.usb4080(), {"VBUS": "+5V_USB", "CC1": "USB_CC1", "CC2": "USB_CC2", "SBU1": None, "SBU2": None,
                          "DP1": "USB_DP", "DN1": "USB_DM", "DP2": "USB_DP", "DN2": "USB_DM", "GND": GND, "EP": GND,
                          "SSTXP1": "SSTXP1", "SSTXN1": "SSTXN1", "SSRXP1": "SSRXP1", "SSRXN1": "SSRXN1",
                          "SSTXP2": "SSTXP2", "SSTXN2": "SSTXN2", "SSRXP2": "SSRXP2", "SSRXN2": "SSRXN2"}, "usbc")
    s.add(R("5.1k"), {"1": "USB_CC1", "2": GND}, "usbc")
    s.add(R("5.1k"), {"1": "USB_CC2", "2": GND}, "usbc")
    s.add(ics.usblc6(), {"#1": "USB_DP", "#6": "USB_DP", "#3": "USB_DM", "#4": "USB_DM", "VBUS": "+5V_USB",
                         "GND": GND}, "usbc")
    s.add(ics.pi3usb302(), {"TX+": "SSTX_P", "TX-": "SSTX_N", "RX+": "SSRX_P", "RX-": "SSRX_N",
                            "SEL": "USB3_PORT_SEL", "PD": GND, "VDD": "+3V3_FX3", "GND": GND,
                            "TX1+": "SSTXP2", "TX1-": "SSTXN2", "RX1+": "SSRXP2", "RX1-": "SSRXN2",
                            "TX2+": "SSTXP1", "TX2-": "SSTXN1", "RX2+": "SSRXP1", "RX2-": "SSRXN1"}, "mux")
    s.add(C("100n"), {"1": "SSTX_P_C", "2": "SSTX_P"}, "mux")
    s.add(C("100n"), {"1": "SSTX_N_C", "2": "SSTX_N"}, "mux")
    s.add(C("100n"), {"1": "+3V3_FX3", "2": GND}, "mux")
    # питание FX3 от VBUS
    s.add(ics.spx3819("3.3"), {"IN": "+5V_USB", "EN": "+5V_USB", "GND": GND, "OUT": "+3V3_FX3", "BP": "FX3_BP33"}, "ldo")
    s.add(C("10n"), {"1": "FX3_BP33", "2": GND}, "ldo")
    s.add(ics.spx3819("1.2"), {"IN": "+5V_USB", "EN": "+5V_USB", "GND": GND, "OUT": "+1V2_FX3", "BP": "FX3_BP12"}, "ldo")
    s.add(C("10n"), {"1": "FX3_BP12", "2": GND}, "ldo")
    s.add(C("10u"), {"1": "+5V_USB", "2": GND}, "ldo")
    for net in ("+3V3_FX3", "+1V2_FX3"):
        s.add(C("22u"), {"1": net, "2": GND}, f"dec{net}")
        for _ in range(6):
            s.add(C("100n"), {"1": net, "2": GND}, f"dec{net}")

    # ===================================================== лист 11: внешние интерфейсы
    s = d.sheet("io", "Внешние интерфейсы")
    gps = ics.conn("GH6", "SM06B-GHS-TB", "JST", 6, "Connector_JST:JST_GH_SM06B-GHS-TB_1x06-1MP_P1.25mm_Horizontal",
                   "Розетка 6 контактов шаг 1,25 мм SM06B-GHS-TB", "GPS", ["+5V", "RX", "TX", "SCL", "SDA", "GND"])
    s.add(gps, {"1": "+5V_GPS", "2": "GPS_P_RX", "3": "GPS_P_TX", "4": "GPS_SCL", "5": "GPS_SDA", "6": GND}, "gps")
    s.add(R("100"), {"1": "GPS_P_RX", "2": "GPS_RX"}, "gps")
    s.add(R("100"), {"1": "GPS_P_TX", "2": "GPS_TX"}, "gps")
    lc = ics.usblc6()
    s.add(lc, {"#1": "GPS_P_RX", "#6": "GPS_P_RX", "#3": "GPS_P_TX", "#4": "GPS_P_TX", "VBUS": "+3V3D", "GND": GND}, "gps")
    s.add(lc, {"#1": "GPS_SCL", "#6": "GPS_SCL", "#3": "GPS_SDA", "#4": "GPS_SDA", "VBUS": "+3V3D", "GND": GND}, "gps")
    s.add(R("2.2k"), {"1": "+3V3D", "2": "GPS_SCL"}, "gps", dnp=True, note="Подтяжка I2C, по заказу")
    s.add(R("2.2k"), {"1": "+3V3D", "2": "GPS_SDA"}, "gps", dnp=True, note="Подтяжка I2C, по заказу")
    tm = ics.conn("GH4T", "SM04B-GHS-TB", "JST", 4, "Connector_JST:JST_GH_SM04B-GHS-TB_1x04-1MP_P1.25mm_Horizontal",
                  "Розетка 4 контакта шаг 1,25 мм SM04B-GHS-TB", "TIME", ["1PPS", "EXT", "GND", "GND"])
    s.add(tm, {"1": "PPS_PORT", "2": "EXTINT_IN", "3": GND, "4": GND}, "time")
    s.add(lc, {"#1": "PPS_PORT", "#6": "PPS_PORT", "#3": "EXTINT_IN", "#4": "EXTINT_IN", "VBUS": "+3V3D", "GND": GND}, "time")
    cn = ics.conn("GH4C", "SM04B-GHS-TB", "JST", 4, "Connector_JST:JST_GH_SM04B-GHS-TB_1x04-1MP_P1.25mm_Horizontal",
                  "Розетка 4 контакта шаг 1,25 мм SM04B-GHS-TB", "CAN", ["+5V", "CANH", "CANL", "GND"])
    s.add(cn, {"1": "+5V_CAN", "2": "CAN_H", "3": "CAN_L", "4": GND}, "can")
    db = ics.conn("SH4", "SM04B-SRSS-TB", "JST", 4, "Connector_JST:JST_SH_SM04B-SRSS-TB_1x04-1MP_P1.00mm_Horizontal",
                  "Розетка 4 контакта шаг 1,0 мм SM04B-SRSS-TB", "UART", ["3V3", "TX", "RX", "GND"])
    s.add(db, {"1": "+3V3D", "2": "DBG_TX", "3": "DBG_RX", "4": GND}, "dbg")
    return d
