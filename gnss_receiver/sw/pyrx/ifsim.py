"""Имитатор комплексных отсчётов ПЧ одного ВЧ-канала МГП-8 (выход MAX2771: I/Q, 2 бита, Fд = 24 МГц).

Модель: s[n] = Σ A_k·d_k(t)·c_k(t − τ_k)·exp(j(2π f_k t + φ_k)) + w[n], где w — комплексный гауссов шум
с дисперсией σ² (полоса Fд); A_k задаётся отношением C/N0: A² = 10^(C/N0/10)·σ²/Fд.
Квантование: знак/модуль (±1, ±3) с порогом, устанавливаемым АРУ (по умолчанию 1,0·σ компоненты).
"""
from dataclasses import dataclass, field

import numpy as np

from .codes import CodeSpec, replica


@dataclass
class SatSignal:
    spec: CodeSpec
    f_off: float              # смещение несущей относительно гетеродина ВЧ-канала (ПЧ без доплера), Гц
    doppler: float            # доплеровский сдвиг, Гц
    code_phase: float         # начальная фаза кода, чипы
    cn0: float                # дБГц
    f_carrier: float          # несущая на входе (для доплера кода), Гц
    phase: float = 0.0        # начальная фаза несущей, рад
    bit_rate: float = 0.0     # скорость данных, бит/с (0 — пилот)
    bits: np.ndarray = None
    sec: np.ndarray = None    # вторичный код (по периодам первичного)
    meander: bool = False     # меандр ГЛОНАСС (10 мс)
    doppler_rate: float = 0.0  # Гц/с (динамика)


@dataclass
class IFConfig:
    fs: float = 24e6
    sigma: float = 1.0
    bits: int = 2             # 0 — без квантования
    agc_k: float = 1.0        # порог 2-битного АЦП в долях σ компоненты
    cw: list = field(default_factory=list)   # [(f, J/N (дБ))]


def quantize(x, bits, thr):
    if bits == 0:
        return x
    def q(v):
        if bits == 1:
            return np.sign(v).astype(np.int8)
        if bits == 2:
            return (np.sign(v) * np.where(np.abs(v) > thr, 3, 1)).astype(np.int8)
        if bits == 3:
            lv = np.clip(np.floor(np.abs(v) / (thr / 2)), 0, 3)
            return (np.sign(v) * (2 * lv + 1)).astype(np.int8)
    return q(x.real) + 1j * q(x.imag)


def generate(sats, cfg, t0, n, rng):
    """Блок из n отсчётов, начиная с момента t0 (с)."""
    t = t0 + np.arange(n) / cfg.fs
    x = (rng.normal(0, cfg.sigma / np.sqrt(2), n) + 1j * rng.normal(0, cfg.sigma / np.sqrt(2), n)).astype(np.complex64)
    for s in sats:
        A = np.sqrt(10 ** (s.cn0 / 10) * cfg.sigma ** 2 / cfg.fs)
        dop_rel = s.doppler / s.f_carrier                 # доплер кода
        ph0 = s.code_phase + t0 * s.spec.rate * (1 + dop_rel)
        r = replica(s.spec, cfg.fs, n, ph0, dop_rel)
        sig = A * r
        # номер периода первичного кода — границы бит данных и вторичного кода совпадают с эпохами кода
        si = np.floor((ph0 + np.arange(n) * s.spec.rate * (1 + dop_rel) / cfg.fs) / len(s.spec.chips)).astype(np.int64)
        if s.bit_rate:
            ppb = max(1, int(round(1.0 / (s.bit_rate * s.spec.period))))
            sig = sig * s.bits[(si // ppb) % len(s.bits)]
        if s.sec is not None:
            sig = sig * s.sec[si % len(s.sec)]
        if s.meander:
            sig = sig * np.where((np.floor(t / 0.01) % 2) == 0, 1, -1)
        phase = s.phase + 2 * np.pi * ((s.f_off + s.doppler) * t + 0.5 * s.doppler_rate * t * t)
        x += (sig * np.exp(1j * phase)).astype(np.complex64)
    for f, jn in cfg.cw:
        Aj = np.sqrt(10 ** (jn / 10)) * cfg.sigma
        x += (Aj * np.exp(2j * np.pi * f * t)).astype(np.complex64)
    return quantize(x, cfg.bits, cfg.agc_k * cfg.sigma / np.sqrt(2))
