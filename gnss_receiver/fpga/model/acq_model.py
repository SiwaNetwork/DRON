"""Битово-точная модель ускорителя захвата ПЛИС МГП-8 (спецификация для fpga/rtl/acq_fft.v;
модель на C — sw/fw/src/acqf_sim.c). Регистры — sw/fw/inc/fpga.h (R_ACQ_*).

Запуск — K периодов кода по Ns отсчётов, начала периодов — через Nper отсчётов (первый — сразу
или с отсчёта T). Шаги обработки:
  перенос   x = xI + j·xQ ∈ {±1, ±3}; b = x·e^{−jθ}, θ = 2π·φ[31:26]/64 (середины интервалов),
            c, s = round(15·cos, sin(2π(j + 0,5)/64)); φ += DPHI (сброс в начале периода)
  ячейки    r += 2048 за отсчёт; при r ≥ Ns ячейка k закрывается (r −= Ns): сумма b, округлённая
            со сдвигом csh, насыщение ±255 → C[k] = {im9, re9} (пул 14 + k[10], адрес k[9:0])
  БПФ       2048 точек, основание 2, прореживание по частоте, на месте; этап s — группы
            по 2D элементов, D = 1024 >> s: a = x[j, 0, i], b = x[j, 1, i];
            сумма и разность 19 бит → ÷2 с округлением (бит s маски) или насыщение до 18 бит;
            разность × (C − jS), C + jS = round(65536·e^{j2π·i·2^s/2048}), (· + 2^15) >> 16,
            насыщение до 18 бит; выход p — элемент спектра brev11(p)
  спектр    X = насыщение ±255 выхода прямого БПФ ячеек (маска fmask)
  гипотеза  Z[k] = conj(X[(k + m_g) mod N])·R[k]; БПФ (маска imask); выход p:
            P = (|Z'_p|² + 2^(psh−1)) >> psh, не более 2^18 − 1;
            A_g[(brev11(p) + sh_g) mod N] = (первый период ? P : min(A + P, 2^18 − 1))
            (A_g — пул 2g + n[10], адрес n[9:0]);
            sh_g — round(Φ_g/2^21) mod N на начало периода, Φ_g += DSH_g, Φ_g = 0 в первом периоде
  итог      в последнем периоде: PEAK_g = {ячейка, значение} первого строгого максимума A_g
            в порядке p (0, если все A_g = 0), SUM_g = Σ A_g
Расписание проверяется при пуске: Ns ≥ 2048, Nper ≥ Ns + 300, 4·Nper ≥ (1 + ng)·11·1040 + 64;
иначе — отказ (CTRL[30]). Снимок: слово wa — пул[2·wa[12:10]] (мл. 16 бит), пул[2·wa[12:10] + 1].

Запуск из fpga/: python3 model/acq_model.py — воспроизводит сценарий tb/gen_acq.c
(tb/stim/acq_cmd.hex, acq_smp.hex), пишет tb/out/acq_py.txt и сверяет с эталоном модели на C
(tb/out/acq_exp.txt).
"""
import math
import sys

import numpy as np

N = 2048
G = 7
M32 = (1 << 32) - 1
PMAX = (1 << 18) - 1
BASE = 0xFFFFF000

CTRL, STAT, DPHI, K, NS, NPER, SCALE, T, M0, T0, DSH0, PEAK0, SUM0, MEM = (
    0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x6F, 0x70, 0x78, 0x80, 0x4000)


def rnd_half_up(v):
    return int(math.floor(v + 0.5)) if v >= 0 else -int(math.floor(-v + 0.5))


COS15 = [rnd_half_up(15 * math.cos(2 * math.pi * (j + 0.5) / 64)) for j in range(64)]
SIN15 = [rnd_half_up(15 * math.sin(2 * math.pi * (j + 0.5) / 64)) for j in range(64)]
TWC = np.array([rnd_half_up(65536 * math.cos(2 * math.pi * t / N)) for t in range(1024)], np.int64)
TWS = np.array([rnd_half_up(65536 * math.sin(2 * math.pi * t / N)) for t in range(1024)], np.int64)
BREV11 = np.array([int(format(p, "011b")[::-1], 2) for p in range(N)], np.int64)


def proc_clk(ng):
    return (1 + ng) * 11 * 1040 + 64


def sat(v, lo, hi):
    return np.minimum(np.maximum(v, lo), hi)


def sx9(v):
    v = np.asarray(v, np.int64) & 511
    return v - ((v & 256) << 1)


def pk9(re, im):
    return (np.asarray(re, np.int64) & 511) | ((np.asarray(im, np.int64) & 511) << 9)


def fft(re, im, mask):
    """Прямое БПФ 2048 точек; возвращает выходы в порядке выдачи p (элемент спектра brev11(p))."""
    re = re.astype(np.int64).copy()
    im = im.astype(np.int64).copy()
    for s in range(11):
        d = 1024 >> s
        xr = re.reshape(1 << s, 2, d)
        xi = im.reshape(1 << s, 2, d)
        ar, br, ai, bi = xr[:, 0, :], xr[:, 1, :], xi[:, 0, :], xi[:, 1, :]
        sr, si, dr, di = ar + br, ai + bi, ar - br, ai - bi
        if (mask >> s) & 1:
            sr, si, dr, di = (sr + 1) >> 1, (si + 1) >> 1, (dr + 1) >> 1, (di + 1) >> 1
        else:
            sr, si, dr, di = (sat(v, -131072, 131071) for v in (sr, si, dr, di))
        tw = np.arange(d, dtype=np.int64) << s
        c, sn = TWC[tw], TWS[tw]
        pr = dr * c + di * sn
        pi = di * c - dr * sn
        xr[:, 0, :], xi[:, 0, :] = sr, si
        xr[:, 1, :] = sat((pr + 32768) >> 16, -131072, 131071)
        xi[:, 1, :] = sat((pi + 32768) >> 16, -131072, 131071)
    return re, im


class Acq:
    def __init__(self):
        self.ctrl = self.dphi = self.k = self.ns = self.nper = self.scale = self.t_start = 0
        self.m = [0] * G
        self.dsh = [0] * G
        self.pool = np.zeros((16, 1024), np.int64)
        self.R = np.zeros(N, np.int64)
        self.busy = self.ovr = self.rec = False
        self.ng = self.ch = self.cap_p = self.proc_p = 0
        self.t_next = self.t_ref = 0
        self.phi = [0] * G
        self.sh = [0] * G
        self.peak = [0] * G
        self.sum = [0] * G

    def keff(self):
        return ((self.k - 1) & 0xFFFF) + 1

    # ------------------------------------------------------------ шина
    def wr(self, a, v):
        if MEM <= a < MEM + N:
            self.R[a - MEM] = v & 0x3FFFF
        elif M0 <= a < M0 + G:
            self.m[a - M0] = v & 2047
        elif DSH0 <= a < DSH0 + G:
            self.dsh[a - DSH0] = v
        elif a == CTRL:
            if v & 4:
                self.busy = self.rec = False
            elif v & 1 and not self.busy:
                self.ctrl = v & 0x772
                self.ng = (v >> 4) & 7 or 1
                self.ch = (v >> 8) & 7
                self.rec = False
                self.cap_p = self.proc_p = 0
                self.ovr = (self.ns < N or self.nper < self.ns + 300
                            or 4 * self.nper < proc_clk(self.ng))
                self.busy = not self.ovr
        elif a == DPHI:
            self.dphi = v
        elif a == K:
            self.k = v & 0xFFFF
        elif a == NS:
            self.ns = v & 0x1FFFF
        elif a == NPER:
            self.nper = v & 0x1FFFF
        elif a == SCALE:
            self.scale = v & 0x1FFFFFFF
        elif a == T:
            self.t_start = v

    def rd(self, a):
        if MEM <= a < MEM + 0x4000:
            o = a - MEM
            return int(self.pool[o >> 10, o & 1023])
        for base, arr in ((M0, self.m), (DSH0, self.dsh), (PEAK0, self.peak), (SUM0, self.sum)):
            if base <= a < base + G:
                return arr[a - base]
        return {CTRL: self.ctrl | self.ovr << 30 | self.busy << 31, STAT: self.proc_p & 0xFFFF,
                DPHI: self.dphi, K: self.k, NS: self.ns, NPER: self.nper, SCALE: self.scale,
                T: self.t_start, T0: self.t_ref}.get(a, 0)

    def snap_wr(self, wa, v):
        p, a = (wa >> 10) & 7, wa & 1023
        self.pool[2 * p, a] = v & 0xFFFF
        self.pool[2 * p + 1, a] = v >> 16

    def snap_rd(self, wa):
        p, a = (wa >> 10) & 7, wa & 1023
        return int(self.pool[2 * p, a] & 0xFFFF) | int(self.pool[2 * p + 1, a] & 0xFFFF) << 16

    # ------------------------------------------------------------ отсчёты
    def sample(self, count, w):
        """1 — запуск завершён."""
        if not self.busy:
            return 0
        if not self.rec and self.cap_p < self.keff():
            if self.cap_p:
                go = count == self.t_next
            else:
                go = not (self.ctrl & 2) or count == self.t_start
            if go:
                if self.cap_p == 0:
                    self.t_ref = count
                    self.phi = [0] * G
                for g in range(G):
                    self.sh[g] = ((self.phi[g] >> 21) + ((self.phi[g] >> 20) & 1)) & 2047
                    self.phi[g] = (self.phi[g] + self.dsh[g]) & M32
                self.t_next = (count + self.nper) & M32
                self.rec = True
                self.i = self.kk = self.r = self.bre = self.bim = self.ph = 0
                self.cap_p += 1
        if not self.rec:
            return 0
        x = (w >> (4 * self.ch)) & 15
        xi = (3 if x & 4 else 1) * (-1 if x & 8 else 1)
        xq = (3 if x & 1 else 1) * (-1 if x & 2 else 1)
        j = self.ph >> 26
        c, s = COS15[j], SIN15[j]
        self.bre += xi * c + xq * s
        self.bim += xq * c - xi * s
        self.ph = (self.ph + self.dphi) & M32
        self.r += N
        if self.r >= self.ns:
            csh = (self.scale >> 27) & 3
            br, bi = self.bre, self.bim
            if csh:
                br = (br + (1 << (csh - 1))) >> csh
                bi = (bi + (1 << (csh - 1))) >> csh
            br, bi = max(-255, min(255, br)), max(-255, min(255, bi))
            self.pool[14 + ((self.kk >> 10) & 1), self.kk & 1023] = (br & 511) | (bi & 511) << 9
            self.r -= self.ns
            self.kk += 1
            self.bre = self.bim = 0
        self.i += 1
        if self.i == self.ns:
            self.rec = False
            return self.process()
        return 0

    def process(self):
        fmask, imask = self.scale & 0x7FF, (self.scale >> 11) & 0x7FF
        psh = (self.scale >> 22) & 31
        first, last = self.proc_p == 0, self.proc_p + 1 == self.keff()
        cells = self.pool[14:16].reshape(N)
        yr, yi = fft(sx9(cells), sx9(cells >> 9), fmask)
        X = np.zeros(N, np.int64)
        X[BREV11] = pk9(sat(yr, -255, 255), sat(yi, -255, 255))
        rr, ri = sx9(self.R), sx9(self.R >> 9)
        for g in range(self.ng):
            xs = np.roll(X, -self.m[g])                     # X[(k + m) mod N]
            xr, xi = sx9(xs), sx9(xs >> 9)
            zr = sat(xr * rr + xi * ri, -131072, 131071)
            zi = sat(xr * ri - xi * rr, -131072, 131071)
            yr, yi = fft(zr, zi, imask)
            pw = yr * yr + yi * yi
            if psh:
                pw = (pw + (1 << (psh - 1))) >> psh
            pw = np.minimum(pw, PMAX)
            idx = (BREV11 + self.sh[g]) & (N - 1)
            acc = self.pool[2 * g:2 * g + 2].reshape(N)     # вид: A_g[n] = пул[2g + n[10]][n[9:0]]
            nv = pw if first else np.minimum(acc[idx] + pw, PMAX)
            acc[idx] = nv
            if last:
                p = int(np.argmax(nv))
                best = int(nv[p])
                self.peak[g] = best | (int(idx[p]) << 18 if best else 0)
                self.sum[g] = int(nv.sum())
        self.proc_p += 1
        if last:
            self.busy = False
            return 1
        return 0


def readhex(path):
    with open(path) as f:
        v = [int(s, 16) for s in f.read().split()]
    return v[1:1 + v[0]]


def replay(cmd, smp, out):
    m = Acq()
    si = nd = 0
    for p in range(0, len(cmd), 3):
        o, a, d = cmd[p:p + 3]
        if o == 1:
            m.wr(a, d)
        elif o == 2:
            while si < a:
                nd += m.sample((BASE + si) & M32, smp[si])
                si += 1
        elif o == 3:
            if a & 1:
                for r in range(0x60, 0x88):
                    out.append("R %02x %08x" % (r, m.rd(r)))
            if a & 2:
                for r in range(0x4000):
                    out.append("P %04x %05x" % (r, m.rd(MEM + r) & 0x3FFFF))
            if a & 4:
                out.append("C %08x" % m.rd(CTRL))
            if a & 8:
                out.append("D %d" % nd)
        elif o == 4:
            m.snap_wr(a & 0x1FFF, d)
        elif o == 5:
            out.append("S %04x %08x" % (a & 0x1FFF, m.snap_rd(a & 0x1FFF)))
        else:
            break


def main():
    cmd = readhex("tb/stim/acq_cmd.hex")
    smp = readhex("tb/stim/acq_smp.hex")
    out = []
    replay(cmd, smp, out)
    with open("tb/out/acq_py.txt", "w") as f:
        f.write("\n".join(out) + "\n")
    with open("tb/out/acq_exp.txt") as f:
        exp = f.read().split("\n")[:-1]
    bad = [i for i in range(max(len(out), len(exp)))
           if i >= len(out) or i >= len(exp) or out[i] != exp[i]]
    for i in bad[:20]:
        print("строка %d: модель C «%s», модель Python «%s»"
              % (i + 1, exp[i] if i < len(exp) else "", out[i] if i < len(out) else ""))
    print("ускоритель захвата, модели Python и C: строк %d, расхождений %d — %s"
          % (len(exp), len(bad), "FAIL" if bad else "PASS"))
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
