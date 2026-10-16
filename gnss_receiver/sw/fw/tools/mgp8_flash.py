#!/usr/bin/env python3
"""МГП-8: обновление ПО МК через загрузчик по UART (протокол — inc/bootp.h, класс 0x10).

Порядок: ENTER (ПО МК уходит в загрузчик через сброс; загрузчик отвечает сам), пауза 0,5 с,
INFO с повторами, стирание нужных секторов, запись по 1 КБ (блоки из одних 0xFF пропускаются —
сектор уже стёрт), CHECK (размер и CRC-32 должны совпасть с образом), RUN. Образ — build/mcu/mgp8.bin
(с заголовком от tools/img_hdr.py). Порт — порт GPS (USART1) или отладочный (UART4), 115200 бит/с.

  mgp8_flash.py --port COM5 build/mcu/mgp8.bin
  mgp8_flash.py --info --port /dev/ttyUSB0
  mgp8_flash.py --sim build/boot_sim --dump build/boot_sim.img build/mcu/mgp8.bin   (модель на ПК)

Для работы с портом нужен pyserial (импортируется только в этом режиме).
"""
import argparse
import binascii
import queue
import struct
import subprocess
import sys
import threading
import time
import zlib

SYNC = b"\x4d\x38"
MBP_BOOT = 0x10
INFO, ERASE, WRITE, CHECK, RUN, ENTER = range(1, 7)
NAMES = {INFO: "INFO", ERASE: "ERASE", WRITE: "WRITE", CHECK: "CHECK", RUN: "RUN", ENTER: "ENTER"}
ST = ["OK", "E_LEN", "E_ALIGN", "E_RANGE", "E_ERASE", "E_FLASH", "E_IMG", "E_CMD"]
BOOT_REQ_KEY = 0xB007B007
APP_BASE = 0x08020000
HDR = 0x400
MAGIC = 0x3850474D
CHUNK = 1024                                     # 32 слова по 32 байта — наибольший кадр WRITE


def frame(cid, payload=b""):
    body = bytes([MBP_BOOT, cid]) + struct.pack("<H", len(payload)) + payload
    return SYNC + body + struct.pack("<H", binascii.crc_hqx(body, 0xFFFF))


class Serial:
    def __init__(self, port, baud):
        try:
            import serial
        except ImportError:
            sys.exit("mgp8_flash: нужен pyserial (pip install pyserial)")
        self.s = serial.Serial(port, baud, timeout=0.05)

    def write(self, b):
        self.s.write(b)

    def read(self, timeout):
        self.s.timeout = timeout
        return self.s.read(max(1, self.s.in_waiting))

    def close(self):
        self.s.close()


class Sim:
    """модель загрузчика tests/boot_sim.c (stdin/stdout)"""

    def __init__(self, exe, dump):
        self.p = subprocess.Popen([exe] + ([dump] if dump else []), stdin=subprocess.PIPE,
                                  stdout=subprocess.PIPE, bufsize=0)
        self.q = queue.Queue()
        threading.Thread(target=self._rx, daemon=True).start()

    def _rx(self):
        while True:
            b = self.p.stdout.read(4096)
            if not b:
                return
            self.q.put(b)

    def write(self, b):
        self.p.stdin.write(b)
        self.p.stdin.flush()

    def read(self, timeout):
        try:
            return self.q.get(timeout=timeout)
        except queue.Empty:
            return b""

    def close(self):
        self.p.stdin.close()
        return self.p.wait(timeout=30)


class Boot:
    def __init__(self, link, verbose=False):
        self.link, self.buf, self.verbose = link, b"", verbose

    def drain(self, t=0.2):
        end = time.monotonic() + t
        while time.monotonic() < end:
            self.link.read(0.05)
        self.buf = b""

    def reply(self, cid, timeout):
        """ответ на команду cid: данные (первый байт — состояние) или None по тайм-ауту"""
        end = time.monotonic() + timeout
        while True:
            while True:
                i = self.buf.find(SYNC)
                if i < 0:
                    self.buf = self.buf[-1:]
                    break
                self.buf = self.buf[i:]
                if len(self.buf) < 8:
                    break
                n = struct.unpack_from("<H", self.buf, 4)[0]
                if n > 2048:
                    self.buf = self.buf[1:]
                    continue
                if len(self.buf) < n + 8:
                    break
                body, crc = self.buf[2:6 + n], struct.unpack_from("<H", self.buf, 6 + n)[0]
                if binascii.crc_hqx(body, 0xFFFF) != crc:
                    self.buf = self.buf[1:]
                    continue
                self.buf = self.buf[n + 8:]
                if body[0] == MBP_BOOT and body[1] == cid | 0x80 and n >= 1:
                    return body[4:]
            left = end - time.monotonic()
            if left <= 0:
                return None
            self.buf += self.link.read(min(left, 0.1))

    def cmd(self, cid, payload=b"", timeout=1.0, tries=1):
        for _ in range(tries):
            self.link.write(frame(cid, payload))
            r = self.reply(cid, timeout)
            if r is not None:
                if self.verbose:
                    print("  %s -> %s" % (NAMES[cid], ST[r[0]] if r[0] < len(ST) else r[0]))
                return r
        sys.exit("mgp8_flash: нет ответа на %s" % NAMES[cid])

    def ok(self, cid, payload=b"", **kw):
        r = self.cmd(cid, payload, **kw)
        if r[0]:
            sys.exit("mgp8_flash: %s — %s" % (NAMES[cid], ST[r[0]] if r[0] < len(ST) else r[0]))
        return r


def progress(msg, last=False):
    """ход работы: в терминале — на месте одной строкой, иначе — только итоговая строка"""
    if sys.stdout.isatty():
        print("\r" + msg, end="\n" if last else "", flush=True)
    elif last:
        print(msg)


def image(path):
    img = open(path, "rb").read()
    if len(img) < HDR + 16 or len(img) % 32:
        sys.exit("mgp8_flash: %s — не образ tools/img_hdr.py" % path)
    magic, size, crc, ver = struct.unpack_from("<4I", img, HDR)
    if magic != MAGIC or size != len(img):
        sys.exit("mgp8_flash: %s — нет заголовка образа (magic %08X, size %d)" % (path, magic, size))
    c = zlib.crc32(img[HDR + 12:], zlib.crc32(img[:HDR + 8])) & 0xFFFFFFFF
    if c != crc:
        sys.exit("mgp8_flash: %s — CRC-32 %08X не совпадает с заголовком %08X" % (path, c, crc))
    return img, ver, crc


def info(b):
    r = b.ok(INFO, timeout=0.3, tries=20)
    bver, base, area, sec, valid, iver, isize = struct.unpack_from("<IIIIBII", r, 1)
    print("загрузчик %08X: область %08X, %d КБ, сектор %d КБ; образ %s" % (
        bver, base, area // 1024, sec // 1024,
        "верен, версия %08X, %d байт" % (iver, isize) if valid else "неверен"))
    return base, area, sec


def main():
    p = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    p.add_argument("image", nargs="?", help="образ ПО МК (build/mcu/mgp8.bin)")
    p.add_argument("--port", help="последовательный порт (COM5, /dev/ttyUSB0)")
    p.add_argument("--baud", type=int, default=115200)
    p.add_argument("--sim", help="модель загрузчика (build/boot_sim) вместо порта")
    p.add_argument("--dump", help="для --sim: файл области флеш-памяти после работы модели")
    p.add_argument("--info", action="store_true", help="только сведения о загрузчике и образе")
    p.add_argument("--no-enter", action="store_true", help="приёмник уже в загрузчике")
    p.add_argument("--no-run", action="store_true", help="не запускать ПО МК после записи")
    p.add_argument("-v", "--verbose", action="store_true")
    a = p.parse_args()
    if not a.info and not a.image:
        p.error("нужен образ или --info")
    if bool(a.port) == bool(a.sim):
        p.error("нужен один из --port или --sim")
    img = ver = crc = None
    if a.image:
        img, ver, crc = image(a.image)
    link = Sim(a.sim, a.dump) if a.sim else Serial(a.port, a.baud)
    b = Boot(link, a.verbose)
    t0 = time.monotonic()
    if not a.no_enter:
        link.write(frame(ENTER, struct.pack("<I", BOOT_REQ_KEY)))
        time.sleep(0.5)                          # сброс МК и запуск загрузчика
        b.drain()
    base, area, sec = info(b)
    if not a.info:
        if base != APP_BASE or len(img) > area:
            sys.exit("mgp8_flash: образ %d байт не помещается в область %08X (%d байт)" % (len(img), base, area))
        nsec = (len(img) + sec - 1) // sec
        for s in range(nsec):
            progress("стирание сектора %d из %d" % (s + 1, nsec))
            b.ok(ERASE, struct.pack("<I", s * sec), timeout=12.0)
        progress("стёрто секторов: %d" % nsec, True)
        nw = 0
        for off in range(0, len(img), CHUNK):
            d = img[off:off + CHUNK]
            if d.count(0xFF) == len(d):
                continue
            r = b.ok(WRITE, struct.pack("<I", off) + d, timeout=2.0)
            if struct.unpack_from("<I", r, 1)[0] != off:
                sys.exit("mgp8_flash: WRITE — ответ для другого смещения")
            nw += len(d)
            progress("запись %d%%" % (100 * (off + len(d)) // len(img)))
        progress("запись 100%", True)
        r = b.ok(CHECK, timeout=5.0)
        size, c, v = struct.unpack_from("<III", r, 1)
        if size != len(img) or c != crc or v != ver:
            sys.exit("mgp8_flash: CHECK — размер %d, CRC-32 %08X, версия %08X; ожидались %d, %08X, %08X" % (
                size, c, v, len(img), crc, ver))
        print("записано %d байт за %.1f с; образ %d байт, версия %08X, CRC-32 %08X — верен" % (
            nw, time.monotonic() - t0, size, v, c))
        if not a.no_run:
            b.ok(RUN)
            print("ПО МК запущено")
    rc = link.close()
    if a.sim and a.dump and img:
        fl = open(a.dump, "rb").read()
        if fl[:len(img)] != img or fl[len(img):len(img) + sec].count(0xFF) < min(sec, len(fl) - len(img)):
            sys.exit("mgp8_flash: --sim — содержимое флеш-памяти модели не совпадает с образом")
        print("модель: флеш-память совпадает с образом")
    if a.sim and img and rc:
        sys.exit("mgp8_flash: модель завершилась с кодом %d" % rc)


if __name__ == "__main__":
    main()
