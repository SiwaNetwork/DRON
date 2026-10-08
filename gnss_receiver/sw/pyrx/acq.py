"""Захват сигналов: параллельный поиск по задержке кода (БПФ) с некогерентным накоплением.

Тот же алгоритм выполняется блоком захвата ПЛИС (fpga/rtl/acq_*) для когерентного интервала 1 мс
и в ПО МК для длинных накоплений (слабые сигналы, ПЗ, раздел 6).
"""
import numpy as np

from .codes import replica


def search(x, spec, fs, f_if_center, dop_range=5000.0, n_coh=1, n_nc=4, dop_step=None):
    """Возвращает dict(metric, code_phase(чипы), doppler(Гц), P(матрица мощностей))."""
    T = spec.period
    N = int(round(T * fs))
    dop_step = dop_step or 1.0 / (2 * T * n_coh)
    dops = np.arange(-dop_range, dop_range + 1e-9, dop_step)
    rep = replica(spec, fs, N).astype(np.complex64)
    Rf = np.conj(np.fft.fft(rep))
    t = np.arange(N * n_coh) / fs
    P = np.zeros((len(dops), N), dtype=np.float64)
    for k, fd in enumerate(dops):
        lo = np.exp(-2j * np.pi * (f_if_center + fd) * t).astype(np.complex64)
        for m in range(n_nc):
            seg = x[m * N * n_coh:(m + 1) * N * n_coh]
            if len(seg) < N * n_coh:
                break
            mix = seg * lo
            acc = np.zeros(N, dtype=np.complex128)
            for c in range(n_coh):
                acc += np.fft.ifft(np.fft.fft(mix[c * N:(c + 1) * N]) * Rf)
            P[k] += np.abs(acc) ** 2
    k, n = np.unravel_index(np.argmax(P), P.shape)
    peak = P[k, n]
    # второй максимум вне ±1 чипа от главного
    spc = int(np.ceil(fs / spec.rate)) + 1
    mask = np.ones(N, bool)
    mask[max(0, n - spc):n + spc] = False
    second = P[k][mask].max()
    noise = np.median(P)
    # пик корреляции на сдвиге n означает x[m] = r[m − n]: фаза кода в начале блока = −n отсчётов
    return dict(metric=peak / second, snr=peak / noise, code_phase=((N - n) % N) * spec.rate / fs, doppler=dops[k],
                P=P, dops=dops, k=k, n=n)


def refine_doppler(x, spec, fs, f_if, code_phase, n_ms=40, nfft=1024):
    """Уточнение частоты после захвата: корреляции по 0,5 мс, квадрат (снимает данные и вторичный
    код, смена знака которых возможна только на границах 1 мс), БПФ. Однозначный диапазон ±500 Гц."""
    T = 0.5e-3
    N = int(round(T * fs))
    t = np.arange(N) / fs
    P = []
    for k in range(n_ms):
        seg = x[k * N:(k + 1) * N]
        if len(seg) < N:
            break
        ph = code_phase + k * N * spec.rate / fs
        rep = replica(spec, fs, N, ph)
        lo = np.exp(-2j * np.pi * f_if * (t + k * T))
        P.append(np.vdot(rep, seg * lo))
    P = np.array(P) ** 2
    S = np.abs(np.fft.fftshift(np.fft.fft(P, nfft)))
    f2 = np.fft.fftshift(np.fft.fftfreq(nfft, T))
    i = int(np.argmax(S))
    if 0 < i < nfft - 1:
        a, b, c = S[i - 1], S[i], S[i + 1]
        di = 0.5 * (a - c) / (a - 2 * b + c)
    else:
        di = 0.0
    return (f2[i] + di * (f2[1] - f2[0])) / 2
