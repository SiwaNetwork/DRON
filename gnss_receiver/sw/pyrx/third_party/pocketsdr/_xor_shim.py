"""Замена sdr_func.xor_bits из Pocket SDR (чётность числа единичных битов)."""


def xor_bits(x):
    return bin(int(x)).count("1") & 1
