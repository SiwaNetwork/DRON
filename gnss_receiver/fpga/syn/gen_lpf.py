"""Файл ограничений nextpnr (LPF) для mgp8_top из таблицы выводов схемы Э3
(hw/gen/data/fpga_pinout.json). Имена цепей схемы -> порты верхнего уровня (векторы)."""
import json
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
CH = "ABCDEFGH"
FX3_GPIO = list(range(16)) + list(range(33, 45)) + list(range(46, 50))


def port_of(net):
    m = re.fullmatch(r"MAX_(I1|I0|Q1|Q0|LD|CSN|SHDN)_([A-H])", net)
    if m:
        return f"MAX_{m.group(1)}[{CH.index(m.group(2))}]"
    m = re.fullmatch(r"FX3_G(\d+)", net)
    if m:
        return f"FX3_D[{FX3_GPIO.index(int(m.group(1)))}]"
    m = re.fullmatch(r"FX3_(CSN|LOCK)_([A-H])", net)
    if m:
        return f"FX3_{m.group(1)}[{CH.index(m.group(2))}]"
    m = re.fullmatch(r"FMC_DA(\d+)", net)
    if m:
        return f"FMC_DA[{m.group(1)}]"
    m = re.fullmatch(r"FPGA_DBG(\d)", net)
    if m:
        return f"FPGA_DBG[{m.group(1)}]"
    if net in ("FLASH_MOSI", "FLASH_MISO"):
        return None                       # не используются после загрузки
    return net


def main():
    pins = json.load(open(os.path.join(ROOT, "hw", "gen", "data", "fpga_pinout.json")))
    lines = ["# МГП-8: назначение выводов LFE5U-45F-6BG381I (сгенерировано syn/gen_lpf.py)",
             "BLOCK RESETPATHS;", "BLOCK ASYNCPATHS;",
             'SYSCONFIG CONFIG_IOVOLTAGE=3.3 COMPRESS_CONFIG=ON MCCLK_FREQ=62 SLAVE_SPI_PORT=DISABLE '
             'MASTER_SPI_PORT=ENABLE;']
    for net, ball in sorted(pins.items()):
        p = port_of(net)
        if p is None:
            continue
        lines.append(f'LOCATE COMP "{p}" SITE "{ball}";')
        extra = ""
        if net.startswith(("MAX_I", "MAX_Q")):
            extra = " PULLMODE=NONE"
        elif net.startswith("FMC_DA") or net.startswith("FX3_G") or net == "FX3_PCLK":
            extra = " SLEWRATE=FAST"
        lines.append(f'IOBUF PORT "{p}" IO_TYPE=LVCMOS33{extra};')
    lines.append('FREQUENCY PORT "ADC_SCLK" 24 MHZ;')
    out = os.path.join(HERE, "mgp8.lpf")
    open(out, "w").write("\n".join(lines) + "\n")
    print(out, len(pins), "выводов")


if __name__ == "__main__":
    main()
