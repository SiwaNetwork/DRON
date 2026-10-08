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
        r = [float(x) for x in ref[-1][1:]]
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
print("ИТОГ:", "ПРОЙДЕН" if ok else "НЕ ПРОЙДЕН")
sys.exit(0 if ok else 1)
