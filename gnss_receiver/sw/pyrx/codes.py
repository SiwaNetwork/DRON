"""Дальномерные коды МГП-8.

Собственные генераторы на РСЛОС (по ИКД) для GPS L1 C/A, ГЛОНАСС L1OF/L2OF, BeiDou B1I/B2I/B3I,
GPS L5 I/Q, GPS L2C (CM), Galileo E5a/E5b I/Q. Таблицы начальных состояний и отводов, которые
нельзя вычислить, берутся из Pocket SDR (BSD-2) и сверяются с первоисточниками в тестах.
Для кодов, хранимых в памяти (Galileo E1/E6), Weil-кодов (L1C, B1C) и кодов ГЛОНАСС CDMA
используется эталонная реализация Pocket SDR.

Формат для коррелятора ПЛИС (sw/fw и fpga/rtl): первичный код как последовательность чипов ±1
(без поднесущей и временного уплотнения) + признаки:
  boc     — модуляция поднесущей BOC(1,1) (меандр с периодом чипа, знак меняется в середине чипа);
  tdm     — временное уплотнение (каждый второй чип нулевой: L2C CM/CL, ГЛОНАСС L1OC/L2OC);
  rate    — частота следования чипов (до уплотнения), чип/с.
"""
from dataclasses import dataclass

import numpy as np

from .third_party.pocketsdr import sdr_code as ref

# ---------------------------------------------------------------- РСЛОС
def lfsr(n, taps, init, length, out_bit=None):
    """Фибоначчиев РСЛОС: taps — номера разрядов (1..n), участвующих в обратной связи;
    регистр — список разрядов [1..n], выход — разряд out_bit (по умолчанию n)."""
    reg = list(init)
    out = np.empty(length, dtype=np.int8)
    ob = (out_bit or n) - 1
    for i in range(length):
        out[i] = reg[ob]
        fb = 0
        for t in taps:
            fb ^= reg[t - 1]
        reg = [fb] + reg[:-1]
    return out


def to_pm(bits):
    """{0,1} -> {+1,-1}."""
    return (1 - 2 * np.asarray(bits, dtype=np.int8)).astype(np.int8)


# ---------------------------------------------------------------- GPS L1 C/A (IS-GPS-200, табл. 3-Ia)
L1CA_DELAY = (5, 6, 7, 8, 17, 18, 139, 140, 141, 251, 252, 254, 255, 256, 257, 258, 469, 470, 471, 472,
              473, 474, 509, 512, 513, 514, 515, 516, 859, 860, 861, 862)


def l1ca(prn):
    g1 = lfsr(10, (3, 10), [1] * 10, 1023)
    g2 = lfsr(10, (2, 3, 6, 8, 9, 10), [1] * 10, 1023)
    if 1 <= prn <= 32:
        d = L1CA_DELAY[prn - 1]
    else:                       # QZSS, SBAS — таблица Pocket SDR
        d = ref.L1CA_G2_delay[prn - 1]
    return to_pm(g1 ^ np.roll(g2, d))


# ---------------------------------------------------------------- ГЛОНАСС L1OF/L2OF (ИКД ред. 5.1, п. 3.3.2.2)
def glo_ca():
    # x^9 + x^5 + 1, начальное состояние «все единицы», выход — 7-й разряд
    return to_pm(lfsr(9, (5, 9), [1] * 9, 511, out_bit=7))


# ---------------------------------------------------------------- BeiDou B1I/B2I (ИКД B1I 3.0, п. 5.1.1)
def b1i(prn):
    g1 = lfsr(11, (1, 7, 8, 9, 10, 11), [0, 1] * 5 + [0], 2046)
    sel = ref.B1I_ph_sel[prn - 1]
    reg = [0, 1] * 5 + [0]
    out = np.empty(2046, dtype=np.int8)
    for i in range(2046):
        o = 0
        for t in sel:
            o ^= reg[t - 1]
        out[i] = o
        fb = reg[0] ^ reg[1] ^ reg[2] ^ reg[3] ^ reg[4] ^ reg[7] ^ reg[8] ^ reg[10]
        reg = [fb] + reg[:-1]
    return to_pm(g1 ^ out)


# ---------------------------------------------------------------- BeiDou B3I (ИКД B3I 1.0, п. 5.1.1)
def b3i(prn):
    n = 10230
    # G1: x^13+x^4+x^3+x+1, начальное «все единицы», сброс через 8190 чипов
    g1 = np.empty(n, dtype=np.int8)
    reg = [1] * 13
    for i in range(n):
        if i % 8190 == 0:
            reg = [1] * 13
        g1[i] = reg[12]
        fb = reg[0] ^ reg[2] ^ reg[3] ^ reg[12]
        reg = [fb] + reg[:-1]
    init = [int(b) for b in format(ref.B3I_G2_init[prn - 1], "013b")]
    # G2: x^13+x^12+x^10+x^9+x^7+x^6+x^5+x+1
    g2 = lfsr(13, (1, 5, 6, 7, 9, 10, 12, 13), init, n)
    return to_pm(g1 ^ g2)


# ---------------------------------------------------------------- GPS L5 (IS-GPS-705, п. 3.2.1.1)
def _l5_xa(n):
    out = np.empty(n, dtype=np.int8)
    reg = [1] * 13
    for i in range(n):
        if i % 8190 == 0:
            reg = [1] * 13
        out[i] = reg[12]
        fb = reg[8] ^ reg[9] ^ reg[11] ^ reg[12]
        reg = [fb] + reg[:-1]
    return out


def _l5_xb():
    # x^13+x^12+x^8+x^7+x^6+x^4+x^3+x+1, начальное «все единицы»; последовательность продлевается
    # до 10230 чипов (естественный период регистра 8191 не прерывается)
    return lfsr(13, (1, 3, 4, 6, 7, 8, 12, 13), [1] * 13, 10230)


def l5(prn, q=False):
    """Код L5 = XA (сброс через 8190 чипов) XOR XB, циклически сдвинутый на «XB code advance»
    по модулю 10230 (IS-GPS-705, табл. 3-Ia). Так же реализовано в GNSS-SDR и Pocket SDR."""
    adv = (ref.L5Q_XB_adv if q else ref.L5I_XB_adv)[prn - 1]
    xb = _l5_xb()
    idx = (np.arange(10230) + adv) % 10230
    return to_pm(_l5_xa(10230) ^ xb[idx])


# ---------------------------------------------------------------- GPS L2C CM (IS-GPS-200, п. 3.3.2.4)
def l2cm(prn):
    """Модульный РСЛОС 27 разрядов, 10230 чипов, начальные состояния — табл. 3-IIa."""
    R = ref.L2CM_R_init_1[prn - 1] if hasattr(ref, "L2CM_R_init_1") else ref.L2CM_R_init[prn - 1]
    n = 10230
    out = np.empty(n, dtype=np.int8)
    for i in range(n):
        out[i] = R & 1
        R = (R >> 1) ^ (0b100100101001001010100111100 * (R & 1))
    return to_pm(out)


# ---------------------------------------------------------------- Galileo E5a/E5b (OS SIS ICD, п. 3.4)
def _e5(tap1, tap2, init2, n=10230):
    def run(tap, init):
        R = init
        out = np.empty(n, dtype=np.int8)
        for i in range(n):
            out[i] = R & 1
            fb = bin(R & tap).count("1") & 1
            R = (R >> 1) | (fb << 13)
        return out
    return to_pm(run(tap1, 0x3FFF) ^ run(tap2, init2))


# ---------------------------------------------------------------- единый интерфейс
@dataclass
class CodeSpec:
    sig: str
    prn: int
    chips: np.ndarray       # первичный код ±1
    rate: float             # чип/с
    boc: bool = False
    tdm: bool = False
    period: float = 0.0     # период первичного кода, с


_OWN = {
    "L1CA": lambda p: (l1ca(p), 1.023e6, False, False),
    "G1CA": lambda p: (glo_ca(), 0.511e6, False, False),
    "G2CA": lambda p: (glo_ca(), 0.511e6, False, False),
    "B1I": lambda p: (b1i(p), 2.046e6, False, False),
    "B2I": lambda p: (b1i(p), 2.046e6, False, False),
    "B3I": lambda p: (b3i(p), 10.23e6, False, False),
    "L5I": lambda p: (l5(p, False), 10.23e6, False, False),
    "L5Q": lambda p: (l5(p, True), 10.23e6, False, False),
    "L2CM": lambda p: (l2cm(p), 0.5115e6, False, False),
}


def _from_ref(sig, prn):
    """Первичный код из эталона Pocket SDR с удалением поднесущей/уплотнения."""
    c = ref.gen_code(sig, prn).astype(np.int8)
    T = ref.code_cyc(sig)
    if sig in ("E1B", "E1C", "B1CD", "B1CP", "L1CD", "G1OCP", "G2OCP"):
        # BOC(1,1): пары полу-чипов (c, -c) — оставляем первый полу-чип
        chips = c[0::2]
        return chips, len(chips) / T, True, False
    if sig == "L1CP":     # TMBOC: 12 отсчётов на чип; знак первого отсчёта — первичный код
        chips = c[0::12]
        return chips, len(chips) / T, True, False
    if sig in ("L2CM", "G1OCD"):      # уплотнение с нулевыми чипами
        chips = c[0::2]
        return chips, len(chips) / T, False, True
    return c, len(c) / T, False, False


def code(sig, prn, own=True):
    if own and sig in _OWN:
        chips, rate, boc, tdm = _OWN[sig](prn)
    else:
        chips, rate, boc, tdm = _from_ref(sig, prn)
    return CodeSpec(sig, prn, np.asarray(chips, dtype=np.int8), rate, boc, tdm, len(chips) / rate)


def replica(spec, fs, n, code_phase=0.0, doppler_code=0.0):
    """Отсчёты локальной копии (с поднесущей и уплотнением) на частоте fs."""
    rate = spec.rate * (1 + doppler_code)
    ph = code_phase + np.arange(n) * rate / fs
    idx = np.floor(ph).astype(np.int64) % len(spec.chips)
    r = spec.chips[idx].astype(np.float32)
    if spec.boc:
        r *= np.where((ph % 1.0) < 0.5, 1.0, -1.0)
    if spec.tdm:
        r *= ((ph % 1.0) < 0.5)        # CM/данные — первая половина интервала, вторая — CL/пилот
    return r
