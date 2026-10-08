# МГП-8: ПО МК — сборка и тесты на ПК (gcc); цель mcu — вычислительное ядро для STM32H743
# (arm-none-eabi-gcc), библиотека build/mcu/libmgp8.a и оценка объёма.
CC      ?= gcc
CFLAGS  ?= -std=c99 -O2 -g -Wall -Wextra -Wno-unused-parameter -Iinc -Isrc
LDLIBS  = -lm
SRC     = src/signals.c src/codes.c src/gen/code_tab.c src/corr_sim.c src/corr.c src/fft.c src/acq.c src/track.c src/eph.c src/rinex.c src/pvt.c src/lnav.c src/nmea.c src/rx.c src/spectrum.c src/rtcm3.c
TESTS   = build/test_codes build/test_corr_sim build/test_pvt build/test_lnav build/test_spectrum build/test_output build/test_acq_weak build/test_rx_l1
LONG    = build/test_trk_weak build/test_rx_pvt

all: $(TESTS)

src/gen/code_tab.c inc/gen/code_tab.h tests/vectors/codes.txt: tools/gen_tables.py
	python3 tools/gen_tables.py

tests/vectors/pvt.txt tests/vectors/satpos.txt: tools/gen_nav_vectors.py
	python3 tools/gen_nav_vectors.py

build/%: tests/%.c $(SRC) src/gen/code_tab.c tests/vectors/pvt.txt | build
	$(CC) $(CFLAGS) -o $@ $< $(SRC) $(LDLIBS)

build:
	mkdir -p build

test: $(TESTS)
	@for t in $(TESTS); do echo "== $$t"; ./$$t || exit 1; done
	python3 tests/check_output.py

# длительные тесты: слежение за слабыми сигналами, сквозной «ПЧ -> координаты, 1PPS» (≈ 25 мин)
test-long: $(LONG)
	@for t in $(LONG); do echo "== $$t"; ./$$t || exit 1; done

# вычислительное ядро ПО МК для STM32H743 (Cortex-M7, FPU двойной точности): библиотека и
# оценка объёма кода и статических данных (без драйверов периферии и модели ПЛИС)
MCU_CC     = arm-none-eabi-gcc
MCU_CFLAGS = -std=c99 -O2 -Wall -Wextra -Wno-unused-parameter -mcpu=cortex-m7 -mfpu=fpv5-d16 \
             -mfloat-abi=hard -mthumb -ffunction-sections -fdata-sections -DMGP8_MCU -Iinc -Isrc
MCU_SRC    = $(filter-out src/corr_sim.c src/rinex.c,$(SRC))
MCU_OBJ    = $(patsubst %.c,build/mcu/%.o,$(MCU_SRC))

build/mcu/%.o: %.c
	@mkdir -p $(dir $@)
	$(MCU_CC) $(MCU_CFLAGS) -c -o $@ $<

mcu: $(MCU_OBJ)
	arm-none-eabi-ar rcs build/mcu/libmgp8.a $(MCU_OBJ)
	arm-none-eabi-size -t $(MCU_OBJ) | tail -1

clean:
	rm -rf build

.PHONY: all test test-long mcu clean
