"""Эталонные векторы для проверки ПО МК на ПК (tests/vectors):
  satpos.txt — координаты и поправки часов КА по эфемеридам RINEX (sim/gnss_orbits.py);
  pvt.txt    — псевдодальности для известной точки (Москва) с часами приёмника и смещениями шкал систем.
"""
import math
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
FW = os.path.abspath(os.path.join(HERE, ".."))
ROOT = os.path.abspath(os.path.join(FW, "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "sim"))
import gnss_orbits as O  # noqa: E402

C = O.C
EPH = os.path.join(ROOT, "sim", "data", "BRDC00IGS_R_20211700000_01D_MN_subset.rnx")
SYS = {"G": 0, "R": 1, "E": 2, "C": 3, "J": 4}


def main():
    con = O.Constellation(EPH)
    out = os.path.join(FW, "tests", "vectors")
    os.makedirs(out, exist_ok=True)
    t0 = con.ephs[0].toc + 1800.0
    with open(os.path.join(out, "satpos.txt"), "w") as f:
        for key in con.sats():
            for dt in (0.0, 600.0, 1700.0):
                p, dts = con.pos(key, t0 + dt)
                if p is None:
                    continue
                f.write(f"{SYS[key[0]]} {key[1]} {t0 + dt:.3f} {p[0]:.4f} {p[1]:.4f} {p[2]:.4f} {dts:.15e}\n")
    # псевдодальности: Москва, часы приёмника 1,234 мс, смещения шкал систем
    rx = O.llh2ecef(55.7558, 37.6173, 150.0)
    R = O.enu_matrix(55.7558, 37.6173)
    bias = {"G": 1.234e-3 * C, "R": 1.234e-3 * C + 25.0, "E": 1.234e-3 * C - 7.0, "C": 1.234e-3 * C + 13.0,
            "J": 1.234e-3 * C}
    trx = t0 + 900.0
    with open(os.path.join(out, "pvt.txt"), "w") as f:
        f.write(f"RX {rx[0]:.4f} {rx[1]:.4f} {rx[2]:.4f} {trx:.6f}\n")
        for s, b in bias.items():
            f.write(f"BIAS {SYS[s]} {b:.4f}\n")
        for key in con.sats("GREC"):
            p, dts = con.pos(key, trx)
            if p is None:
                continue
            _, el, rho = O.az_el(rx, p, R)
            if el < 12:
                continue
            # время излучения: итерации по дальности, поворот Земли за время распространения
            tau = rho / C
            for _ in range(5):
                ps, dts = con.pos(key, trx - tau)
                pr_s = O.sagnac(ps, np.linalg.norm(ps - rx))
                tau = np.linalg.norm(pr_s - rx) / C
            pr = tau * C + bias[key[0]] - C * dts
            f.write(f"OBS {SYS[key[0]]} {key[1]} {pr:.4f} {el:.2f}\n")
    print("векторы: satpos.txt, pvt.txt")


if __name__ == "__main__":
    main()
