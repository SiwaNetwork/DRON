"""Сверка собственных генераторов кодов с эталоном Pocket SDR для всех номеров КА."""
import numpy as np

from pyrx import codes
from pyrx.third_party.pocketsdr import sdr_code as ref

CASES = {"L1CA": range(1, 33), "G1CA": [1], "B1I": range(1, 64), "B3I": range(1, 64),
         "L5I": range(1, 33), "L5Q": range(1, 33)}


def test_own_vs_reference():
    for sig, prns in CASES.items():
        for prn in prns:
            own = codes.code(sig, prn, own=True).chips
            rc = ref.gen_code(sig, prn)
            assert np.array_equal(own, rc), f"{sig} PRN {prn}: расхождение"


def test_l2cm():
    for prn in range(1, 33):
        own = codes.l2cm(prn)
        rc = ref.gen_code("L2CM", prn)[0::2]
        assert np.array_equal(own, rc), f"L2CM PRN {prn}"


def test_l1ca_autocorr():
    c = codes.l1ca(1).astype(int)
    ac = [int(np.dot(c, np.roll(c, k))) for k in range(1, 1023)]
    assert set(ac) <= {-65, -1, 63}           # трёхуровневая АКФ кода Голда


def test_glo_period():
    c = codes.glo_ca().astype(int)
    assert len(c) == 511 and abs(int(c.sum())) == 1   # m-последовательность: баланс ±1


def test_boc_tdm_specs():
    e1 = codes.code("E1C", 1)
    assert e1.boc and len(e1.chips) == 4092 and abs(e1.rate - 1.023e6) < 1
    l2 = codes.code("L2CM", 1, own=False)
    assert l2.tdm and len(l2.chips) == 10230 and abs(l2.rate - 511.5e3) < 1
