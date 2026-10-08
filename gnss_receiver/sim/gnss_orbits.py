"""Орбиты КА по бортовым эфемеридам (RINEX 3.04 NAV): GPS, ГЛОНАСС, Galileo, BeiDou, QZSS.

Алгоритмы: IS-GPS-200 (кеплеровы элементы, GPS/QZSS), Galileo OS SIS ICD, BDS-SIS-ICD
(с поворотом для ГСО BeiDou), ИКД ГЛОНАСС ред. 5.1 (численное интегрирование в ПЗ-90
методом Рунге–Кутты 4-го порядка).
Время: секунды GPST от начала недели GPS (BDT = GPST − 14 с, UTC(SU) + 3 ч = МДВ, GPST − UTC = 18 с).
"""
import math
from dataclasses import dataclass, field

import numpy as np

C = 299792458.0
LEAP = 18.0
MU = {"G": 3.986005e14, "J": 3.986005e14, "E": 3.986004418e14, "C": 3.986004418e14}
OMEGA = {"G": 7.2921151467e-5, "J": 7.2921151467e-5, "E": 7.2921151467e-5, "C": 7.2921150e-5}
GLO = dict(mu=398600.4418e9, ae=6378136.0, j2=1.08262575e-3, we=7.292115e-5)
BDS_GEO = {1, 2, 3, 4, 5, 59, 60, 61, 62, 63}


def _f(s):
    s = s.strip().replace("D", "E").replace("d", "e")
    return float(s) if s else 0.0


def gpst_sow(y, mo, d, h, mi, s):
    """Календарная дата (шкала GPST) -> (неделя GPS, секунды недели)."""
    import datetime
    t0 = datetime.datetime(1980, 1, 6)
    dt = datetime.datetime(y, mo, d, h, mi, int(s)) - t0
    secs = dt.total_seconds() + (s - int(s))
    return int(secs // 604800), secs % 604800


@dataclass
class Eph:
    sys: str
    prn: int
    toc: float          # секунды недели GPST (для BDS — уже приведено к GPST)
    v: list = field(default_factory=list)
    k: int = 0          # литера ГЛОНАСС


def read_rinex_nav(path):
    lines = open(path).read().split("\n")
    i = next(k for k, l in enumerate(lines) if "END OF HEADER" in l) + 1
    ephs = []
    while i < len(lines):
        l0 = lines[i]
        if not l0.strip():
            i += 1
            continue
        sys = l0[0]
        n = 4 if sys in "RS" else 8
        rec = lines[i:i + n]
        i += n
        prn = int(l0[1:3])
        y, mo, d, h, mi, s = int(l0[4:8]), int(l0[9:11]), int(l0[12:14]), int(l0[15:17]), int(l0[18:20]), int(l0[21:23])
        _, sow = gpst_sow(y, mo, d, h, mi, s)
        vals = [_f(l0[23 + 19 * k:23 + 19 * (k + 1)]) for k in range(3)]
        for ln in rec[1:]:
            vals += [_f(ln[4 + 19 * k:4 + 19 * (k + 1)]) for k in range(4)]
        if sys == "R":
            sow = (sow + LEAP) % 604800
            e = Eph(sys, prn, sow, vals)
            e.k = int(vals[3 + 4 + 3]) if len(vals) > 10 else 0
        elif sys == "C":
            e = Eph(sys, prn, (sow + 14.0) % 604800, vals)
        else:
            e = Eph(sys, prn, sow, vals)
        ephs.append(e)
    return ephs


def _kepler_pos(e, t):
    v = e.v
    af0, af1, af2 = v[0:3]
    _, crs, dn, m0 = v[3:7]
    cuc, ecc, cus, sqa = v[7:11]
    toe, cic, om0, cis = v[11:15]
    i0, crc, w, omd = v[15:19]
    idot = v[19]
    mu, we = MU[e.sys], OMEGA[e.sys]
    if e.sys == "C":
        toe_g = (toe + 14.0)
    else:
        toe_g = toe
    tk = t - toe_g
    if tk > 302400:
        tk -= 604800
    if tk < -302400:
        tk += 604800
    a = sqa * sqa
    n = math.sqrt(mu / a ** 3) + dn
    M = m0 + n * tk
    E = M
    for _ in range(12):
        E = M + ecc * math.sin(E)
    nu = math.atan2(math.sqrt(1 - ecc * ecc) * math.sin(E), math.cos(E) - ecc)
    phi = nu + w
    du = cus * math.sin(2 * phi) + cuc * math.cos(2 * phi)
    dr = crs * math.sin(2 * phi) + crc * math.cos(2 * phi)
    di = cis * math.sin(2 * phi) + cic * math.cos(2 * phi)
    u = phi + du
    r = a * (1 - ecc * math.cos(E)) + dr
    inc = i0 + di + idot * tk
    xp, yp = r * math.cos(u), r * math.sin(u)
    if e.sys == "C" and e.prn in BDS_GEO:
        om = om0 + omd * tk - we * toe
        xg = xp * math.cos(om) - yp * math.cos(inc) * math.sin(om)
        yg = xp * math.sin(om) + yp * math.cos(inc) * math.cos(om)
        zg = yp * math.sin(inc)
        f5 = math.radians(-5.0)
        x1, y1, z1 = xg, yg * math.cos(f5) + zg * math.sin(f5), -yg * math.sin(f5) + zg * math.cos(f5)
        ang = we * tk
        x = x1 * math.cos(ang) + y1 * math.sin(ang)
        y = -x1 * math.sin(ang) + y1 * math.cos(ang)
        z = z1
    else:
        om = om0 + (omd - we) * tk - we * toe
        x = xp * math.cos(om) - yp * math.cos(inc) * math.sin(om)
        y = xp * math.sin(om) + yp * math.cos(inc) * math.cos(om)
        z = yp * math.sin(inc)
    # поправка часов КА (без релятивистской составляющей и групповой задержки)
    tc = t - e.toc
    dts = af0 + af1 * tc + af2 * tc * tc
    F = -4.442807633e-10
    dts += F * ecc * sqa * math.sin(E)
    return np.array([x, y, z]), dts


def _glo_deriv(s, acc):
    x, y, z, vx, vy, vz = s
    mu, ae, j2, we = GLO["mu"], GLO["ae"], GLO["j2"], GLO["we"]
    r2 = x * x + y * y + z * z
    r = math.sqrt(r2)
    r3 = r2 * r
    k = 1.5 * j2 * mu * ae * ae / (r2 * r3)
    zz = 5 * z * z / r2
    ax = -mu / r3 * x - k * x * (1 - zz) + we * we * x + 2 * we * vy + acc[0]
    ay = -mu / r3 * y - k * y * (1 - zz) + we * we * y - 2 * we * vx + acc[1]
    az = -mu / r3 * z - k * z * (3 - zz) + acc[2]
    return np.array([vx, vy, vz, ax, ay, az])


def _glo_pos(e, t):
    v = e.v
    gam = v[1]
    s = np.array([v[3], v[7], v[11], v[4], v[8], v[12]]) * 1e3
    acc = np.array([v[5], v[9], v[13]]) * 1e3
    dt = t - e.toc
    if dt > 302400:
        dt -= 604800
    if dt < -302400:
        dt += 604800
    h = 60.0 if dt >= 0 else -60.0
    n = int(abs(dt) // 60)
    for _ in range(n):
        k1 = _glo_deriv(s, acc)
        k2 = _glo_deriv(s + h / 2 * k1, acc)
        k3 = _glo_deriv(s + h / 2 * k2, acc)
        k4 = _glo_deriv(s + h * k3, acc)
        s = s + h / 6 * (k1 + 2 * k2 + 2 * k3 + k4)
    rem = dt - n * h
    if abs(rem) > 1e-6:
        k1 = _glo_deriv(s, acc)
        k2 = _glo_deriv(s + rem / 2 * k1, acc)
        k3 = _glo_deriv(s + rem / 2 * k2, acc)
        k4 = _glo_deriv(s + rem * k3, acc)
        s = s + rem / 6 * (k1 + 2 * k2 + 2 * k3 + k4)
    dts = v[0] + gam * dt   # в RINEX хранится −TauN
    return s[:3], dts


class Constellation:
    VALID = {"G": 7200, "J": 7200, "E": 4 * 3600, "C": 3600, "R": 1800}

    def __init__(self, path):
        self.ephs = read_rinex_nav(path)
        self.by = {}
        for e in self.ephs:
            self.by.setdefault((e.sys, e.prn), []).append(e)

    def sats(self, systems="GREJC"):
        return sorted(k for k in self.by if k[0] in systems)

    def pos(self, key, t):
        cands = self.by[key]
        e = min(cands, key=lambda e: abs(((t - e.toc + 302400) % 604800) - 302400))
        if abs(((t - e.toc + 302400) % 604800) - 302400) > self.VALID[key[0]]:
            return None, None
        if key[0] == "R":
            return _glo_pos(e, t)
        return _kepler_pos(e, t)

    def glo_k(self, prn):
        return self.by[("R", prn)][0].k


def llh2ecef(lat, lon, h):
    a, f = 6378137.0, 1 / 298.257223563
    e2 = f * (2 - f)
    la, lo = math.radians(lat), math.radians(lon)
    N = a / math.sqrt(1 - e2 * math.sin(la) ** 2)
    return np.array([(N + h) * math.cos(la) * math.cos(lo), (N + h) * math.cos(la) * math.sin(lo),
                     (N * (1 - e2) + h) * math.sin(la)])


def enu_matrix(lat, lon):
    la, lo = math.radians(lat), math.radians(lon)
    return np.array([[-math.sin(lo), math.cos(lo), 0],
                     [-math.sin(la) * math.cos(lo), -math.sin(la) * math.sin(lo), math.cos(la)],
                     [math.cos(la) * math.cos(lo), math.cos(la) * math.sin(lo), math.sin(la)]])


def az_el(rx, sat, R):
    d = sat - rx
    rho = np.linalg.norm(d)
    enu = R @ (d / rho)
    return math.degrees(math.atan2(enu[0], enu[1])) % 360, math.degrees(math.asin(enu[2])), rho


def sagnac(sat, rho, we=7.2921151467e-5):
    th = we * rho / C
    return np.array([sat[0] * math.cos(th) + sat[1] * math.sin(th), -sat[0] * math.sin(th) + sat[1] * math.cos(th), sat[2]])
