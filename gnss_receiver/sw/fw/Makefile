# МГП-8: ПО МК — сборка и тесты на ПК (gcc). Сборка для STM32H743 — цель mcu (arm-none-eabi-gcc).
CC      ?= gcc
CFLAGS  ?= -std=c99 -O2 -g -Wall -Wextra -Wno-unused-parameter -Iinc -Isrc
LDLIBS  = -lm
SRC     = src/signals.c src/codes.c src/gen/code_tab.c src/corr_sim.c src/corr.c src/fft.c src/acq.c src/track.c src/eph.c src/rinex.c src/pvt.c src/lnav.c src/nmea.c src/rx.c src/spectrum.c src/rtcm3.c
TESTS   = build/test_codes build/test_corr_sim build/test_pvt build/test_lnav build/test_spectrum build/test_output build/test_rx_l1
LONG    = build/test_rx_pvt

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

# длительный сквозной тест «ПЧ -> координаты, 1PPS» (несколько минут)
test-long: $(LONG)
	./build/test_rx_pvt

clean:
	rm -rf build

.PHONY: all test clean
