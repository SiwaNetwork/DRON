#!/usr/bin/env python3
"""МГП-8: заголовок образа ПО МК и файлы для программирования.

Образ (objcopy -O binary, начало — 0x08020000) дополняется байтами 0xFF до кратного 32 байтам
(слово флеш-памяти STM32H7); в заголовок app_hdr_t (смещение 0x400, inc/bootp.h) записываются
размер и CRC-32 (zlib) по образу без поля crc — так же проверяет загрузчик (bootp_crc).
Выходы: .bin (для tools/mgp8_flash.py), Intel HEX образа и — с --boot — общий Intel HEX
«загрузчик + ПО МК» для программатора (SWD).

  img_hdr.py build/mcu/mgp8.raw --bin build/mcu/mgp8.bin --hex build/mcu/mgp8.hex \\
             --boot build/mcu/boot.bin --full build/mcu/mgp8_full.hex
"""
import argparse
import struct
import sys
import zlib

APP_BASE = 0x08020000
BOOT_BASE = 0x08000000
APP_AREA = 1920 * 1024
BOOT_AREA = 128 * 1024
HDR = 0x400
MAGIC = 0x3850474D
WORD = 32


def crc(img):
    return zlib.crc32(img[HDR + 12:], zlib.crc32(img[:HDR + 8])) & 0xFFFFFFFF


def patch(raw):
    img = bytearray(raw)
    img += b"\xff" * (-len(img) % WORD)
    if len(img) < HDR + 16:
        sys.exit("img_hdr: образ короче заголовка")
    magic, _, _, ver = struct.unpack_from("<4I", img, HDR)
    if magic != MAGIC:
        sys.exit("img_hdr: нет заголовка app_hdr_t по смещению 0x400 (magic %08X)" % magic)
    if len(img) > APP_AREA:
        sys.exit("img_hdr: образ %d байт больше области %d" % (len(img), APP_AREA))
    struct.pack_into("<I", img, HDR + 4, len(img))
    struct.pack_into("<I", img, HDR + 8, crc(img))
    return bytes(img), ver


def ihex(segs):
    """segs: [(адрес, данные)] -> строки Intel HEX (записи 00, 04, 01)"""
    out, hi = [], None

    def rec(t, addr, data):
        b = bytes([len(data), addr >> 8 & 0xFF, addr & 0xFF, t]) + data
        return ":" + (b + bytes([-sum(b) & 0xFF])).hex().upper()

    for base, data in segs:
        for o in range(0, len(data), 16):
            a = base + o
            if a >> 16 != hi:
                hi = a >> 16
                out.append(rec(4, 0, struct.pack(">H", hi)))
            out.append(rec(0, a & 0xFFFF, data[o:o + 16]))
    out.append(rec(1, 0, b""))
    return "\n".join(out) + "\n"


def main():
    p = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    p.add_argument("raw", help="образ ПО МК (objcopy -O binary)")
    p.add_argument("--bin", required=True)
    p.add_argument("--hex", required=True)
    p.add_argument("--boot", help="образ загрузчика (objcopy -O binary)")
    p.add_argument("--full", help="общий Intel HEX: загрузчик + ПО МК")
    a = p.parse_args()
    img, ver = patch(open(a.raw, "rb").read())
    open(a.bin, "wb").write(img)
    open(a.hex, "w", newline="\n").write(ihex([(APP_BASE, img)]))
    print("img_hdr: %s — %d байт, версия %08X, CRC-32 %08X" % (a.bin, len(img), ver, crc(img)))
    if a.boot and a.full:
        boot = open(a.boot, "rb").read()
        if len(boot) > BOOT_AREA:
            sys.exit("img_hdr: загрузчик %d байт больше сектора" % len(boot))
        open(a.full, "w", newline="\n").write(ihex([(BOOT_BASE, boot), (APP_BASE, img)]))
        print("img_hdr: %s — загрузчик %d байт + ПО МК" % (a.full, len(boot)))


if __name__ == "__main__":
    main()
