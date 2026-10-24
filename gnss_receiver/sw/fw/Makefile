# МГП-8: ПО МК — сборка и тесты на ПК (gcc); цель mcu — вычислительное ядро для STM32H743
# (arm-none-eabi-gcc), библиотека build/mcu/libmgp8.a и оценка объёма; цель elf — ПО МК и
# загрузчик (build/mcu/mgp8.elf, boot.elf, образы .bin/.hex для программирования).
CC      ?= gcc
CFLAGS  ?= -std=c99 -O2 -g -Wall -Wextra -Wno-unused-parameter -Iinc -Isrc
LDLIBS  = -lm
SRC     = src/signals.c src/codes.c src/gen/code_tab.c src/corr_sim.c src/acqf_sim.c src/corr.c src/fft.c src/acq.c src/track.c src/eph.c src/rinex.c src/pvt.c src/lnav.c src/nmea.c src/rx.c src/spectrum.c src/rtcm3.c src/glonav.c src/proto.c src/inav.c src/bdsnav.c src/max2771.c src/app.c src/bootp.c
TESTS   = build/test_boot build/test_max2771 build/test_glonav build/test_inav build/test_bdsnav build/test_codes build/test_corr_sim build/test_pvt build/test_lnav build/test_spectrum build/test_output build/test_acq_weak build/test_acq_fpga build/test_rx_l1
LONG    = build/test_trk_dyn build/test_trk_weak build/test_acq_trk build/test_rx_pvt build/test_rx_glo build/test_rx_dual build/test_rx_gb build/test_rx_dual2 build/test_app

all: $(TESTS)

src/gen/code_tab.c inc/gen/code_tab.h tests/vectors/codes.txt tests/vectors/sec.txt: tools/gen_tables.py
	python3 tools/gen_tables.py

tests/vectors/pvt.txt tests/vectors/satpos.txt: tools/gen_nav_vectors.py
	python3 tools/gen_nav_vectors.py

build/%: tests/%.c $(SRC) src/gen/code_tab.c tests/vectors/pvt.txt | build
	$(CC) $(CFLAGS) -o $@ $< $(EXTRA) $(SRC) $(LDLIBS)

# сквозные проверки с имитатором GPS L1 C/A
build/test_rx_pvt build/test_app: EXTRA = tests/sim_gps.c
build/test_rx_pvt build/test_app: tests/sim_gps.c tests/sim_gps.h

build:
	mkdir -p build

test: $(TESTS) board-check
	@for t in $(TESTS); do echo "== $$t"; ./$$t || exit 1; done
	python3 tests/check_output.py

# карта выводов МК inc/board_pins.h совпадает со схемой Э3 (лист 9)
board-check:
	python3 tools/gen_board.py --check

# длительные тесты: слежение за слабыми сигналами, сквозной «ПЧ -> координаты, 1PPS», четыре двухчастотные пары, прикладной уровень (≈ 80 мин)
test-long: $(LONG)
	@for t in $(LONG); do echo "== $$t"; ./$$t || exit 1; done

# вычислительное ядро ПО МК для STM32H743 (Cortex-M7, FPU двойной точности): библиотека и
# оценка объёма кода и статических данных (без драйверов периферии и модели ПЛИС)
MCU_CC     = arm-none-eabi-gcc
MCU_CFLAGS = -std=c99 -O2 -Wall -Wextra -Wno-unused-parameter -mcpu=cortex-m7 -mfpu=fpv5-d16 \
             -mfloat-abi=hard -mthumb -ffunction-sections -fdata-sections -DMGP8_MCU -Iinc -Isrc -Iplat \
             -fstack-usage -fcallgraph-info=su
MCU_SRC    = $(filter-out src/corr_sim.c src/acqf_sim.c src/rinex.c,$(SRC))
MCU_OBJ    = $(patsubst %.c,build/mcu/%.o,$(MCU_SRC))

build/mcu/%.o: %.c $(wildcard inc/*.h) $(wildcard plat/*.h)
	@mkdir -p $(dir $@)
	$(MCU_CC) $(MCU_CFLAGS) -c -o $@ $<

mcu: $(MCU_OBJ)
	arm-none-eabi-ar rcs build/mcu/libmgp8.a $(MCU_OBJ)
	arm-none-eabi-size -t $(MCU_OBJ) | tail -1

# ПО МК и загрузчик: платформа plat/*, размещение ld/*.ld; образ с заголовком (размер, CRC-32)
# и общий Intel HEX для программатора — tools/img_hdr.py; оценка стека — tools/stack_check.py
PLAT_SRC  = plat/startup.c plat/system.c plat/gpio.c plat/uart.c plat/sched.c plat/syscalls.c
APP_OBJ   = $(MCU_OBJ) $(patsubst %.c,build/mcu/%.o,$(PLAT_SRC) plat/fmc.c plat/can.c plat/sdmmc.c plat/adc.c plat/main.c)
BOOT_OBJ  = $(patsubst %.c,build/mcu/%.o,$(PLAT_SRC) plat/boot.c plat/flash.c src/bootp.c src/proto.c)
MCU_LD    = -mcpu=cortex-m7 -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -nostartfiles --specs=nano.specs \
            -Wl,--gc-sections -Wl,--print-memory-usage
OBJCOPY   = arm-none-eabi-objcopy

# скрипт компоновки — области (ld/mgp8.ld, ld/boot.ld) + секции (ld/sections.ld) одним файлом:
# ld 2.47 под Windows не различает файлы скриптов (INCLUDE, второй -T — «appears multiple times»)
build/mcu/%.ld: ld/%.ld ld/sections.ld
	@mkdir -p $(dir $@)
	cat $^ > $@

build/mcu/mgp8.elf: $(APP_OBJ) build/mcu/mgp8.ld
	$(MCU_CC) $(MCU_LD) -T build/mcu/mgp8.ld -Wl,-Map=build/mcu/mgp8.map -u _printf_float -o $@ $(APP_OBJ) -lm

build/mcu/boot.elf: $(BOOT_OBJ) build/mcu/boot.ld
	$(MCU_CC) $(MCU_LD) -T build/mcu/boot.ld -Wl,-Map=build/mcu/boot.map -o $@ $(BOOT_OBJ)

build/mcu/mgp8.bin: build/mcu/mgp8.elf build/mcu/boot.elf tools/img_hdr.py
	$(OBJCOPY) -O binary build/mcu/mgp8.elf build/mcu/mgp8.raw
	$(OBJCOPY) -O binary build/mcu/boot.elf build/mcu/boot.bin
	$(OBJCOPY) -O ihex build/mcu/boot.elf build/mcu/boot.hex
	python3 tools/img_hdr.py build/mcu/mgp8.raw --bin $@ --hex build/mcu/mgp8.hex \
	        --boot build/mcu/boot.bin --full build/mcu/mgp8_full.hex

elf: build/mcu/mgp8.bin
	arm-none-eabi-size build/mcu/mgp8.elf build/mcu/boot.elf
	python3 tools/stack_check.py build/mcu/mgp8.elf $(APP_OBJ)
	python3 tools/stack_check.py build/mcu/boot.elf $(BOOT_OBJ)

# обновление ПО МК: tools/mgp8_flash.py с моделью загрузчика tests/boot_sim.c (src/bootp.c на ПК,
# флеш-память как у STM32H743) — образ build/mcu/mgp8.bin записывается и сравнивается
boot-check: build/boot_sim build/mcu/mgp8.bin
	python3 tools/mgp8_flash.py --sim build/boot_sim --dump build/boot_sim.img build/mcu/mgp8.bin

clean:
	rm -rf build

.PHONY: all test test-long board-check mcu elf boot-check clean
