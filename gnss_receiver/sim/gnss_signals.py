"""Параметры навигационных сигналов ГНСС, используемые во всех расчётах МГП-8.

Источники: ИКД ГЛОНАСС ред. 5.1 и ИКД CDMA L1/L2/L3 ред. 1.0 (2016), IS-GPS-200/705/800,
Galileo OS SIS ICD 2.1, BDS-SIS-ICD (B1I 3.0, B3I 1.0, B1C 1.0, B2a 1.0, B2b 1.0),
IS-QZSS-PNT-006, NavIC SPS ICD 1.1, RTCA DO-229.

Мощность p_min_dbw — минимальная гарантированная мощность у поверхности Земли
на выходе изотропной антенны (0 дБи) суммарно по компонентам сигнала, принимаемым каналом.
"""
from dataclasses import dataclass, field

F0 = 10.23e6  # опорная частота GPS/Galileo/BDS-3, Гц


@dataclass(frozen=True)
class Signal:
    sid: str            # идентификатор (совместим с Pocket SDR, где возможно)
    system: str         # GPS, GLO, GAL, BDS, QZS, IRN, SBS
    name: str           # обозначение по ИКД
    fc: float           # несущая, Гц (для FDMA ГЛОНАСС — литера 0)
    chip_rate: float    # чип/с
    code_len: int       # длина первичного кода, чипов
    mod: str            # BPSK, BOC(m,n), CBOC, TMBOC, QPSK
    boc_m: float        # множитель поднесущей (0 для BPSK)
    p_min_dbw: float    # минимальная мощность, дБВт
    rf_ch: int          # номер ВЧ-канала МГП-8
    pilot: bool = False
    fdma_step: float = 0.0   # шаг литер FDMA, Гц
    fdma_k: tuple = ()       # диапазон литер


# Частотный план МГП-8 (гетеродины ВЧ-каналов), Гц.
# Заимствован из Pocket SDR conf/pocket_L1G1L2G2L5E5bB3L6_24MHz.conf (BSD-2), проверен расчётом.
RF_CHANNELS = {
    1: dict(f_lo=1568.000e6, bw=23.4e6, band="L1/E1/B1"),
    2: dict(f_lo=1602.000e6, bw=8.7e6, band="G1"),
    3: dict(f_lo=1227.600e6, bw=4.2e6, band="L2"),
    4: dict(f_lo=1246.000e6, bw=8.7e6, band="G2"),
    5: dict(f_lo=1176.450e6, bw=16.4e6, band="L5/E5a/B2a"),
    6: dict(f_lo=1207.140e6, bw=16.4e6, band="E5b/B2b/G3"),
    7: dict(f_lo=1268.520e6, bw=16.4e6, band="B3"),
    8: dict(f_lo=1278.750e6, bw=8.7e6, band="E6/L6"),
}
F_TCXO = 24.000e6
F_ADC = 24.000e6   # комплексная дискретизация I/Q

GLO_K = tuple(range(-7, 7))

SIGNALS = [
    Signal("L1CA", "GPS", "L1 C/A", 154 * F0, 1.023e6, 1023, "BPSK", 0, -158.5, 1),
    Signal("L1CP", "GPS", "L1C-P", 154 * F0, 1.023e6, 10230, "TMBOC(6,1,4/33)", 1, -158.25, 1, pilot=True),
    Signal("L1CD", "GPS", "L1C-D", 154 * F0, 1.023e6, 10230, "BOC(1,1)", 1, -163.0, 1),
    Signal("L2CM", "GPS", "L2C (CM)", 120 * F0, 0.5115e6, 10230, "BPSK", 0, -163.0, 3),
    Signal("L5I", "GPS", "L5-I", 115 * F0, 10.23e6, 10230, "BPSK", 0, -157.9, 5),
    Signal("L5Q", "GPS", "L5-Q", 115 * F0, 10.23e6, 10230, "BPSK", 0, -157.9, 5, pilot=True),
    Signal("G1CA", "GLO", "L1OF", 1602.0e6, 0.511e6, 511, "BPSK", 0, -161.0, 2,
           fdma_step=562.5e3, fdma_k=GLO_K),
    Signal("G2CA", "GLO", "L2OF", 1246.0e6, 0.511e6, 511, "BPSK", 0, -167.0, 4,
           fdma_step=437.5e3, fdma_k=GLO_K),
    Signal("G1OCD", "GLO", "L1OCd", 1600.995e6, 0.5115e6, 1023, "BPSK", 0, -161.0, 2),
    Signal("G1OCP", "GLO", "L1OCp", 1600.995e6, 0.5115e6, 4092, "BOC(1,1)", 1, -161.0, 2, pilot=True),
    Signal("G2OCP", "GLO", "L2OCp", 1248.06e6, 0.5115e6, 10230, "BOC(1,1)", 1, -161.0, 4, pilot=True),
    Signal("G3OCD", "GLO", "L3OCd", 1202.025e6, 10.23e6, 10230, "BPSK", 0, -161.0, 6),
    Signal("G3OCP", "GLO", "L3OCp", 1202.025e6, 10.23e6, 10230, "BPSK", 0, -161.0, 6, pilot=True),
    Signal("E1B", "GAL", "E1-B", 154 * F0, 1.023e6, 4092, "CBOC(6,1,1/11)", 1, -160.0, 1),
    Signal("E1C", "GAL", "E1-C", 154 * F0, 1.023e6, 4092, "CBOC(6,1,1/11)", 1, -160.0, 1, pilot=True),
    Signal("E5AI", "GAL", "E5a-I", 115 * F0, 10.23e6, 10230, "BPSK", 0, -158.0, 5),
    Signal("E5AQ", "GAL", "E5a-Q", 115 * F0, 10.23e6, 10230, "BPSK", 0, -158.0, 5, pilot=True),
    Signal("E5BI", "GAL", "E5b-I", 118 * F0, 10.23e6, 10230, "BPSK", 0, -158.0, 6),
    Signal("E5BQ", "GAL", "E5b-Q", 118 * F0, 10.23e6, 10230, "BPSK", 0, -158.0, 6, pilot=True),
    Signal("E6B", "GAL", "E6-B", 125 * F0, 5.115e6, 5115, "BPSK", 0, -158.0, 8),
    Signal("E6C", "GAL", "E6-C", 125 * F0, 5.115e6, 5115, "BPSK", 0, -158.0, 8, pilot=True),
    Signal("B1I", "BDS", "B1I", 1561.098e6, 2.046e6, 2046, "BPSK", 0, -163.0, 1),
    Signal("B1CD", "BDS", "B1C-D", 154 * F0, 1.023e6, 10230, "BOC(1,1)", 1, -165.0, 1),
    Signal("B1CP", "BDS", "B1C-P", 154 * F0, 1.023e6, 10230, "QMBOC(6,1,4/33)", 1, -160.25, 1, pilot=True),
    Signal("B2AD", "BDS", "B2a-D", 115 * F0, 10.23e6, 10230, "BPSK", 0, -159.0, 5),
    Signal("B2AP", "BDS", "B2a-P", 115 * F0, 10.23e6, 10230, "BPSK", 0, -159.0, 5, pilot=True),
    Signal("B2I", "BDS", "B2I", 118 * F0, 2.046e6, 2046, "BPSK", 0, -163.0, 6),
    Signal("B2BI", "BDS", "B2b-I", 118 * F0, 10.23e6, 10230, "BPSK", 0, -160.0, 6),
    Signal("B3I", "BDS", "B3I", 1268.52e6, 10.23e6, 10230, "BPSK", 0, -163.0, 7),
    Signal("I5S", "IRN", "NavIC L5 SPS", 115 * F0, 1.023e6, 1023, "BPSK", 0, -159.0, 5),
    Signal("L6D", "QZS", "L6D", 125 * F0, 2.5575e6, 10230, "BPSK", 0, -158.7, 8),
    Signal("L1SB", "SBS", "SBAS L1", 154 * F0, 1.023e6, 1023, "BPSK", 0, -161.0, 1),
]


def by_id(sid):
    return next(s for s in SIGNALS if s.sid == sid)


def carrier(sig, k=0):
    return sig.fc + k * sig.fdma_step


def if_offset(sig, k=0):
    """Смещение несущей относительно гетеродина своего ВЧ-канала (ПЧ при нулевой ПЧ I/Q), Гц."""
    return carrier(sig, k) - RF_CHANNELS[sig.rf_ch]["f_lo"]
