"""Канал слежения: ФАП с помощью ЧАП (Костас), ССЗ с поддержкой от несущей, оценка C/N0.

Структура соответствует разбиению «ПЛИС — корреляторы, МК — петли»: функция correlate()
воспроизводит работу аппаратного коррелятора за интервал T, остальное — алгоритм МК (sw/fw/track.c).
"""
import math
from dataclasses import dataclass, field

import numpy as np

from .codes import replica


@dataclass
class LoopCfg:
    pll_bw: float = 15.0
    fll_bw: float = 5.0
    dll_bw: float = 1.0
    spacing: float = 0.5      # расстояние ранний−поздний / 2, чипы
    T: float = 1e-3
    pilot: bool = False
    fll_time: float = 0.1     # время работы ЧАП (втягивание), с


@dataclass
class TrackState:
    code_phase: float
    f_carr: float
    f_code: float
    phase: float = 0.0
    log: dict = field(default_factory=lambda: {k: [] for k in ("t", "I", "Q", "E", "L", "f", "code", "cn0", "pll_err")})


def correlate(x, fs, spec, st, n, spacing):
    """Корреляторы E/P/L за n отсчётов: возвращает комплексные суммы и обновляет фазы NCO."""
    t = np.arange(n) / fs
    lo = np.exp(-1j * (st.phase + 2 * np.pi * st.f_carr * t)).astype(np.complex64)
    bb = x[:n] * lo
    rel = st.f_code / spec.rate - 1
    # «ранняя» копия опережает по фазе кода (фаза больше), «поздняя» — отстаёт
    E = np.vdot(replica(spec, fs, n, st.code_phase + spacing, rel), bb)
    P = np.vdot(replica(spec, fs, n, st.code_phase, rel), bb)
    L = np.vdot(replica(spec, fs, n, st.code_phase - spacing, rel), bb)
    st.phase = (st.phase + 2 * np.pi * st.f_carr * n / fs) % (2 * np.pi)
    st.code_phase += st.f_code * n / fs
    return E, P, L


class Tracker:
    def __init__(self, spec, fs, f_off, doppler, code_phase, cfg: LoopCfg, f_carrier):
        self.spec, self.fs, self.cfg = spec, fs, cfg
        self.st = TrackState(code_phase, f_off + doppler, spec.rate * (1 + doppler / f_carrier))
        self.f_carrier = f_carrier
        self.f_off = f_off
        self.f0 = f_off + doppler
        # ФАП 2-го порядка с поддержкой ЧАП 1-го порядка (Kaplan, табл. 5.6)
        wn = cfg.pll_bw / 0.53
        self.a2, self.w2 = 1.414 * wn, wn * wn
        self.wf = cfg.fll_bw / 0.25
        self.int_f = 0.0
        self.prevP = None
        self.nbd = []

    def samples_needed(self):
        """Число отсчётов до следующей границы интервала накопления, кратной T по фазе кода
        (как в аппаратном корреляторе: сброс накопителей по эпохе кода)."""
        cpt = self.spec.rate * self.cfg.T          # чипов на интервал T
        rem = cpt - (self.st.code_phase % cpt)
        if rem < 1e-6:
            rem += cpt
        return max(1, int(math.ceil(rem * self.fs / self.st.f_code - 1e-9)))

    def step(self, x, t):
        cfg, st = self.cfg, self.st
        n = len(x)
        E, P, L = correlate(x, self.fs, self.spec, st, n, cfg.spacing)
        # дискриминаторы
        if cfg.pilot:
            perr = math.atan2(P.imag, P.real)
        else:
            perr = math.atan(P.imag / P.real) if P.real != 0 else 0.0
        ferr = 0.0
        if self.prevP is not None:
            cross = self.prevP.real * P.imag - self.prevP.imag * P.real
            dot = self.prevP.real * P.real + self.prevP.imag * P.imag
            ferr = math.atan2(cross, abs(dot) if not cfg.pilot else dot) / (2 * math.pi * cfg.T)
            if not cfg.pilot:
                ferr = math.atan(cross / dot) / (2 * math.pi * cfg.T) if dot != 0 else 0.0
        self.prevP = P
        if t > cfg.fll_time:
            ferr = 0.0
        # фильтр контура несущей
        self.int_f += (self.w2 * perr / (2 * math.pi) + self.wf * ferr) * cfg.T
        st.f_carr = self.f0 + self.int_f + self.a2 * perr / (2 * math.pi)
        # ССЗ: нормированный дискриминатор «ранний минус поздний» по огибающей
        e, l = abs(E), abs(L)
        cerr = (e - l) / (e + l) * (1 - cfg.spacing) if (e + l) > 0 else 0.0
        st.f_code = self.spec.rate * (1 + (st.f_carr - self.f_off) / self.f_carrier) + 4 * cfg.dll_bw * cerr
        # оценка C/N0 (метод отношения мощностей узкой и широкой полос, 20 интервалов)
        self.nbd.append(P)
        cn0 = float("nan")
        if len(self.nbd) == 20:
            arr = np.array(self.nbd)
            nbp = abs(arr.real.sum()) ** 2 + abs(arr.imag.sum()) ** 2 if cfg.pilot else abs(np.abs(arr.real).sum()) ** 2
            wbp = (np.abs(arr) ** 2).sum()
            nm = nbp / wbp
            cn0 = 10 * math.log10(max((nm - 1) / (20 - nm), 1e-9) / cfg.T) if nm > 1 else float("nan")
            self.nbd = []
        lg = st.log
        lg["t"].append(t)
        lg["I"].append(P.real)
        lg["Q"].append(P.imag)
        lg["E"].append(abs(E))
        lg["L"].append(abs(L))
        lg["f"].append(st.f_carr)
        lg["code"].append(st.code_phase)
        lg["cn0"].append(cn0)
        lg["pll_err"].append(perr)
        return n
