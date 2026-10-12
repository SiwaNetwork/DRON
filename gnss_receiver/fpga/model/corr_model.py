"""Битово-точная модель канала коррелятора ПЛИС МГП-8 (спецификация для fpga/rtl/corr_engine.v).

Арифметика (все величины целые):
  вход:   2-битные I/Q в формате «знак/модуль» (бит 1 — знак, 1 = минус; бит 0 — модуль) -> {±1, ±3}
  несущая: фаза 32 бит, шаг carr_rate (доп. код, 32 бит), индекс таблицы = фаза[31:26] (64 точки),
           cos/sin = round(7·cos/sin(2π(k+0.5)/64)) ∈ [−7, 7]
           перенос: bb_i = x_i·c + x_q·s;  bb_q = x_q·c − x_i·s   (умножение на exp(−jφ))
  код:     фаза = int[15:0].frac[31:0], шаг code_rate (32 бит, доли чипа на отсчёт · 2^32),
           длина кода L (чипов); ранний = фаза + spacing, поздний = фаза − spacing (по модулю L)
           чип: бит памяти 1 -> −1, 0 -> +1; BOC: × (frac[31] ? −1 : +1); TDM: 0 при frac[31] = 1
  накопители: 6 × 32 бит (EI, EQ, PI, PQ, LI, LQ), сброс по эпохе кода через n_int периодов
  ПЛИС обрабатывает отсчёты группами по P = 4 (группа начинается с отсчёта n, кратного P), поэтому:
  - смещение ранней/поздней копии задаётся с разрешением 2^-16 чипа (мл. 16 бит spacing = 0);
  - шаги NCO, записанные МК, вступают в силу с конца группы, в которой произошёл сброс
    (с отсчёта, кратного P, следующего за отсчётом сброса).
"""
import numpy as np

COS = np.array([int(round(7 * np.cos(2 * np.pi * (k + 0.5) / 64))) for k in range(64)], dtype=np.int64)
SIN = np.array([int(round(7 * np.sin(2 * np.pi * (k + 0.5) / 64))) for k in range(64)], dtype=np.int64)
M32 = (1 << 32) - 1
P = 4          # отсчётов в группе (шаг движка ПЛИС)


def decode_sample(code4):
    """4-битное слово канала (I1 I0 Q1 Q0) -> (xi, xq)."""
    i1, i0, q1, q0 = (code4 >> 3) & 1, (code4 >> 2) & 1, (code4 >> 1) & 1, code4 & 1
    xi = (3 if i0 else 1) * (-1 if i1 else 1)
    xq = (3 if q0 else 1) * (-1 if q1 else 1)
    return xi, xq


def encode_sample(xi, xq):
    """(xi, xq) ∈ {±1,±3} -> 4-битное слово."""
    def f(v):
        return ((1 if v < 0 else 0) << 1) | (1 if abs(v) == 3 else 0)
    return (f(xi) << 2) | f(xq)


def wrap32s(v):
    v &= M32
    return v - (1 << 32) if v & 0x80000000 else v


class Channel:
    def __init__(self, code_bits, L, carr_rate, code_rate, code_int=0, code_frac=0, carr_phase=0,
                 spacing=1 << 31, boc=False, tdm=False, n_int=1, rf=0):
        self.mem = np.asarray(code_bits, dtype=np.int64)
        self.L = L
        self.carr_rate = carr_rate & M32
        self.code_rate = code_rate & M32
        self.carr_phase = carr_phase & M32
        self.ci, self.cf = code_int, code_frac & M32
        self.spacing = spacing & 0xFFFF0000
        self.boc, self.tdm, self.n_int, self.rf = boc, tdm, n_int, rf
        self.acc = [0] * 6
        self.epoch = 0
        self.dumps = []          # (номер отсчёта, EI, EQ, PI, PQ, LI, LQ)
        self.pending = None      # (carr_rate, code_rate) — применяется на границе интервала
        self.apply = False       # в текущей группе был сброс

    def _chip(self, ci, cf):
        b = int(self.mem[ci])
        c = -1 if b else 1
        msb = (cf >> 31) & 1
        if self.boc and msb:
            c = -c
        if self.tdm and msb:
            c = 0
        return c

    def step(self, n, xi, xq):
        k = self.carr_phase >> 26
        c, s = int(COS[k]), int(SIN[k])
        bi = xi * c + xq * s
        bq = xq * c - xi * s
        # ранний / пунктуальный / поздний
        ef = self.cf + self.spacing
        ei = self.ci + (ef >> 32)
        ef &= M32
        if ei >= self.L:
            ei -= self.L
        lf = self.cf - self.spacing
        li = self.ci + (lf >> 32 if lf >= 0 else -1)
        lf &= M32
        if li < 0:
            li += self.L
        ce, cp, cl = self._chip(ei, ef), self._chip(self.ci, self.cf), self._chip(li, lf)
        for j, (cc, v) in enumerate(((ce, bi), (ce, bq), (cp, bi), (cp, bq), (cl, bi), (cl, bq))):
            self.acc[j] += cc * v
        # обновление NCO
        self.carr_phase = (self.carr_phase + self.carr_rate) & M32
        nf = self.cf + self.code_rate
        self.ci += nf >> 32
        self.cf = nf & M32
        if self.ci >= self.L:
            self.ci -= self.L
            self.epoch += 1
            if self.epoch >= self.n_int:
                self.epoch = 0
                self.dumps.append((n, *[wrap32s(a) for a in self.acc]))
                self.acc = [0] * 6
                self.apply = True
        if n % P == P - 1 and self.apply:
            self.apply = False
            if self.pending:
                self.carr_rate, self.code_rate = self.pending
                self.pending = None


def code_words(code_bits, L):
    """Слова записи CODE_WDATA (16 чипов, мл. бит — первый) для памяти с дополнением
    mem[a] = code[(a − 1) mod L], a = 0 .. L+7 (см. rtl/corr_engine.v)."""
    n = L + 8
    mem = [int(code_bits[(a - 1) % L]) for a in range(n)]
    mem += [0] * (-n % 16)
    return [sum(mem[i + b] << b for b in range(16)) for i in range(0, len(mem), 16)]


def run(samples4, chans):
    """samples4: массив [N, 8] 4-битных слов по ВЧ-каналам; chans: список Channel."""
    for n in range(samples4.shape[0]):
        row = samples4[n]
        for ch in chans:
            xi, xq = decode_sample(int(row[ch.rf]))
            ch.step(n, xi, xq)
    return chans


def rate_carrier(f_hz, fs):
    return int(round(f_hz / fs * (1 << 32))) & M32


def rate_code(chips_per_s, fs):
    return int(round(chips_per_s / fs * (1 << 32))) & M32
