"""Генераторы дальномерных кодов Pocket SDR (T. Takasu), BSD 2-Clause — используются как эталон.
Источник: https://github.com/tomojitakasu/PocketSDR (python/sdr_code.py, python/sdr_code_gal.py).
Изменения: импорт sdr_func заменён на _xor_shim (только функция xor_bits), scipy.fftpack -> numpy.fft."""
