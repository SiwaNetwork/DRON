# МГП-8: ПО МК — сборка и тесты на ПК (gcc). Сборка для STM32H743 — цель mcu (arm-none-eabi-gcc).
CC      ?= gcc
CFLAGS  ?= -std=c99 -O2 -g -Wall -Wextra -Wno-unused-parameter -Iinc -Isrc
LDLIBS  = -lm
SRC     = src/signals.c src/codes.c src/gen/code_tab.c src/corr_sim.c src/corr.c src/fft.c src/acq.c src/track.c
TESTS   = build/test_codes build/test_corr_sim build/test_rx_l1

all: $(TESTS)

src/gen/code_tab.c inc/gen/code_tab.h tests/vectors/codes.txt: tools/gen_tables.py
	python3 tools/gen_tables.py

build/%: tests/%.c $(SRC) src/gen/code_tab.c | build
	$(CC) $(CFLAGS) -o $@ $< $(SRC) $(LDLIBS)

build:
	mkdir -p build

test: $(TESTS)
	@for t in $(TESTS); do echo "== $$t"; ./$$t || exit 1; done

clean:
	rm -rf build

.PHONY: all test clean
