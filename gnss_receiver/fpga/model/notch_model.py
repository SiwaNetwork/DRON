"""Битово-точная модель режекторного фильтра ПЛИС МГП-8 (спецификация для fpga/rtl/notch.v).

Для каждого ВЧ-канала k (если включён): компенсатор узкополосной помехи известной частоты.
  x       — отсчёт {±1, ±3} (I, Q)
  φ       — фаза NCO помехи (32 бит), индекс таблицы — φ[31:24] (256 точек),
            c, s = round(127·cos, sin(2π(i+0.5)/256))
  b       = x·e^{−jφ}:  bI = xI·c + xQ·s,  bQ = xQ·c − xI·s           (|b| ≤ 3·127·√2 < 540)
  B       ← B + ((b·2^8 − B) >> μ)   — оценка помехи на нулевой частоте (19 бит со знаком, 8 дробных)
  Bh      = B >> 1                    — 18 бит со знаком (операнд умножителя MULT18X18D)
  ŝ       = Bh·e^{jφ}:  ŝI = BhI·c − BhQ·s,  ŝQ = BhQ·c + BhI·s       (масштаб x·127²·2^7)
  y       = (x·127²·2^7 − ŝ) >> 7
  дизеринг— (если включён для канала) y += d, d = r[14:0] − 2^14 (I), r[30:16] − 2^14 (Q):
            равномерный в ±1 единицу x (2^14 ≈ 127²) — линеаризует повторное квантование при
            слабой помехе (J/N < −5 дБ); r — xorshift32 дорожки (каналы 0–3 и 4–7), значение
            берётся до шага генератора, генератор делает шаг на каждый канал каждого отсчёта
            (в т. ч. выключенный), начальные значения 0x12345678 и 0x9E3779B9
  выход   — 2 бита «знак/модуль»: знак = (y < 0), модуль = (|y| > T)
  АРУ     — окно 1024 отсчёта (общий счётчик от записи NOTCH_EN): число компонент с |y| > T
            за окно (из 2048) > 683 -> T += T>>4; < 614 -> T −= T>>4 (цель ≈ 1/3, T ≤ 2^20 − 1)
  φ       ← φ + Δφ
Выключенный канал передаётся без изменений. Задержка не моделируется (сравнение по номерам отсчётов).
"""
import math

import numpy as np

COS = [int(round(127 * math.cos(2 * math.pi * (i + 0.5) / 256))) for i in range(256)]
SIN = [int(round(127 * math.sin(2 * math.pi * (i + 0.5) / 256))) for i in range(256)]
M32 = (1 << 32) - 1
TMAX = (1 << 20) - 1
SEEDS = (0x12345678, 0x9E3779B9)


class XorShift:
    def __init__(self, seed):
        self.x = seed

    def next(self):
        r = self.x
        x = r
        x ^= (x << 13) & M32
        x ^= x >> 17
        x ^= (x << 5) & M32
        self.x = x
        return r


def asr(v, n):
    return v >> n                      # арифметический сдвиг (Python — к −∞, как в Verilog >>> для signed)


class Notch:
    def __init__(self, dphi, mu=8, dith=0, t0=16129):
        self.dphi = dphi & M32
        self.mu = mu
        self.dith = dith
        self.phi = 0
        self.BI = 0
        self.BQ = 0
        self.T = t0                    # порог (в единицах y), начальное — 1·127·127
        self.cnt = 0
        self.big = 0

    def step(self, xi, xq, r=0):
        i = self.phi >> 24
        c, s = COS[i], SIN[i]
        bi = xi * c + xq * s
        bq = xq * c - xi * s
        # оценка помехи (B — масштаб b·2^8)
        self.BI += asr((bi << 8) - self.BI, self.mu)
        self.BQ += asr((bq << 8) - self.BQ, self.mu)
        # повторная модуляция: ŝ = Bh·e^{jφ}, Bh = B >> 1 (масштаб x·127²·2^7)
        bhi, bhq = asr(self.BI, 1), asr(self.BQ, 1)
        si = bhi * c - bhq * s
        sq = bhq * c + bhi * s
        yi = asr((xi * 16129 << 7) - si, 7)
        yq = asr((xq * 16129 << 7) - sq, 7)
        if self.dith:
            yi += (r & 0x7FFF) - 0x4000
            yq += ((r >> 16) & 0x7FFF) - 0x4000
        # квантование и АРУ
        mi = 1 if abs(yi) > self.T else 0
        mq = 1 if abs(yq) > self.T else 0
        self.big += mi + mq
        self.cnt += 1
        if self.cnt == 1024:
            # цель: 2/3·1024 из 2048 компонент — модуль 1 (P(|y| > σ) ≈ 0,317 -> 649 из 2048)
            if self.big > 683:
                self.T = min(self.T + (self.T >> 4), TMAX)
            elif self.big < 614:
                self.T -= self.T >> 4
            self.cnt = 0
            self.big = 0
        self.phi = (self.phi + self.dphi) & M32
        return (1 if yi < 0 else 0), mi, (1 if yq < 0 else 0), mq


def run(words, cfg):
    """words — массив 32-бит слов (8 каналов × {sI,mI,sQ,mQ}); cfg — {канал: (Δφ, μ[, дизеринг])}.
    Возвращает новые слова."""
    filt = {k: Notch(*v) for k, v in cfg.items()}
    rng = [XorShift(s) for s in SEEDS]
    out = np.zeros(len(words), dtype=np.uint32)
    for n, w in enumerate(words):
        w = int(w)
        o = w
        for k in range(8):
            r = rng[k >> 2].next()
            f = filt.get(k)
            if f is None:
                continue
            x = (w >> (4 * k)) & 0xF
            xi = (3 if (x >> 2) & 1 else 1) * (-1 if (x >> 3) & 1 else 1)
            xq = (3 if x & 1 else 1) * (-1 if (x >> 1) & 1 else 1)
            si, mi, sq, mq = f.step(xi, xq, r)
            o = (o & ~(0xF << (4 * k))) | ((si << 3 | mi << 2 | sq << 1 | mq) << (4 * k))
        out[n] = o
    return out
