"""Проверка выходных сообщений ПО МК независимыми декодерами: pyrtcm (RTCM 3.3), pynmeagps (NMEA)."""
import math
import sys

from pyrtcm import RTCMReader
from pynmeagps import NMEAReader

C = 299792458.0
ok = True
ref = [ln.split() for ln in open("build/out_ref.txt")]
msgs = []
with open("build/out.rtcm", "rb") as f:
    for raw, parsed in RTCMReader(f, quitonerror=2):
        msgs.append(parsed)
print("RTCM: сообщений", len(msgs), [m.identity for m in msgs])
for m in msgs:
    if m.identity == "1005":
        r = [float(x) for x in next(x for x in ref if x[0] == "1005")[1:]]
        got = [m.DF025, m.DF026, m.DF027]
        e = max(abs(a - b) for a, b in zip(r, got))
        print(f"  1005: координаты, макс. расхождение {e:.4f} м")
        ok &= e < 2e-4
        continue
    rows = [x for x in ref if x[0] == m.identity]
    nsat = m.NSat
    # грубая дальность КА + точная дальность ячейки
    for j in range(nsat):
        rr = (getattr(m, f"DF397_{j + 1:02d}") + getattr(m, f"DF398_{j + 1:02d}")) * C * 1e-3
        pr = rr + getattr(m, f"DF405_{j + 1:02d}") * C * 1e-3
        cp = rr + getattr(m, f"DF406_{j + 1:02d}") * C * 1e-3
        rate = getattr(m, f"DF399_{j + 1:02d}") + getattr(m, f"DF404_{j + 1:02d}")
        cn0 = getattr(m, f"DF408_{j + 1:02d}")
        r = rows[j]
        e_pr, e_cp, e_rate, e_cn = abs(pr - float(r[3])), abs(cp - float(r[4])), abs(rate - float(r[5])), abs(cn0 - float(r[6]))
        ok &= e_pr < 0.01 and e_cp < 0.002 and e_rate < 0.001 and e_cn < 0.07
        if j == 0 or e_pr >= 0.01 or e_cp >= 0.002:
            print(f"  {m.identity} КА {r[1]}: ошибка ПД {e_pr * 1e3:.2f} мм, фазы {e_cp * 1e3:.3f} мм, "
                  f"скорости {e_rate * 1e3:.3f} мм/с, C/N0 {e_cn:.3f} дБГц")
print("NMEA:")
for ln in open("build/out.nmea"):
    msg = NMEAReader.parse(ln.strip(), validate=3)
    print("  ", msg.identity, "— разобрано")
    if msg.identity == "GNGGA":
        ok &= abs(msg.lat - 55.7558) < 1e-7 and abs(msg.lon - 37.6173) < 1e-7 and abs(msg.alt - 150.25) < 1e-3
    if msg.identity == "GNRMC":
        ok &= abs(msg.spd - math.hypot(10, 20) / 0.514444) < 0.01 and abs(msg.cog - math.degrees(math.atan2(10, 20))) < 0.1
# собственный двоичный протокол — независимый декодер (struct)
import struct


def crc16(b):
    c = 0xFFFF
    for x in b:
        c ^= x << 8
        for _ in range(8):
            c = ((c << 1) ^ 0x1021) & 0xFFFF if c & 0x8000 else (c << 1) & 0xFFFF
    return c


data = open("build/out.mbp", "rb").read()
frames, i = [], 0
while i + 8 <= len(data):
    assert data[i:i + 2] == b"M8", "синхрослово"
    cls, mid, ln = data[i + 2], data[i + 3], struct.unpack_from("<H", data, i + 4)[0]
    crc = struct.unpack_from("<H", data, i + 6 + ln)[0]
    ok &= crc == crc16(data[i + 2:i + 6 + ln])
    frames.append((cls, mid, data[i + 6:i + 6 + ln]))
    i += ln + 8
print("Двоичный протокол: кадров", len(frames), [f"{c:02X}{m:02X}" for c, m, _ in frames])
meas_ref = [x for x in ref if x[0] == "M"]
for cls, mid, p in frames:
    if (cls, mid) == (1, 1):
        wk, tow, fix, ns, nsys, _ = struct.unpack_from("<HdBBBB", p, 0)
        x, y, z = struct.unpack_from("<3d", p, 14)
        clk = struct.unpack_from("<4d", p, 50)
        pdop = struct.unpack_from("<H", p, 86)[0] / 100
        e = max(abs(x - 2849547.796), abs(y - 2195818.206), abs(z - 5249314.274))
        print(f"  PVT: неделя {wk}, tow {tow}, КА {ns}, систем {nsys}, ошибка координат {e:.1e} м, "
              f"шкалы {clk[0]:.2f}/{clk[1]:.2f} м, PDOP {pdop}")
        ok &= wk == 2163 and tow == 345600.5 and ns == 21 and nsys == 2 and e < 1e-6 and clk[1] == 1240.25 and pdop == 1.28
    elif (cls, mid) == (2, 1):
        wk, tow, n = struct.unpack_from("<HdB", p, 0)
        o = 11
        for j in range(n):
            sy, prn, sig, fcn, pr, cp, dop, cn0, lock, fl = struct.unpack_from("<BBBbddfHIB", p, o)
            o += 31
            r = meas_ref[j]
            good = (sy, prn, sig, fcn, fl) == tuple(int(v) for v in (r[1], r[2], r[3], r[4], r[10])) and \
                abs(pr - float(r[5])) < 1e-6 and abs(cp - float(r[6])) < 1e-6 and abs(dop - float(r[7])) < 1e-3 and \
                abs(cn0 / 100 - float(r[8])) < 0.006 and abs(lock / 1000 - float(r[9])) < 1e-3
            ok &= good
        print(f"  измерения: {n}, совпадение {'да' if good else 'НЕТ'}")
    elif (cls, mid) == (2, 2):
        sy, prn, fcn, svh, wk, iode = struct.unpack_from("<BBbBHH", p, 0)
        v = struct.unpack_from("<32d", p, 8)
        if sy == 0:
            ok &= prn == 7 and iode == 33 and v[6] == 5153.7 and v[7] == 0.0123
            print(f"  эфемериды GPS PRN {prn}: sqrtA {v[6]}, e {v[7]}")
        else:
            ok &= prn == 11 and fcn == -3 and v[21] == 1.2e7 and v[25] == 3100.5 and v[30] == -2.5e-5
            print(f"  эфемериды ГЛОНАСС R{prn} литера {fcn}: x {v[21]}, vy {v[25]}, −τn {v[30]}")
    elif (cls, mid) == (3, 1):
        n = p[0]
        rows = [struct.unpack_from("<BBBbBBHf", p, 1 + 12 * j) for j in range(n)]
        print("  каналы:", [(r[0], r[2], r[3], r[6] / 100, r[7]) for r in rows])
        ok &= n == 2 and rows[1][2] == 11 and rows[1][3] == -3 and rows[1][6] == 3975 and rows[1][7] == 812.5
    elif (cls, mid) == (4, 1):
        t, ia, st, ld, ne, nd, vin, up, fo, pl = struct.unpack_from("<ffBBBBHIBB", p, 0)
        print(f"  ИТМ: t {t} °С, антенна {ia} мА (состояние {st}), LD {ld:02X}, фильтр {ne:02X}, {vin} мВ, {up} с")
        ok &= t == 48.5 and ia == 31.25 and st == 1 and ld == 0xFF and ne == 2 and vin == 5010 and up == 3600
ok &= len(frames) == 6
print("ИТОГ:", "ПРОЙДЕН" if ok else "НЕ ПРОЙДЕН")
sys.exit(0 if ok else 1)
