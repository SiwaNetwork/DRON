# МГП-8, ПЛИС: моделирование (Icarus Verilog) и сборка (Yosys + nextpnr-ecp5 + ecppack).
#   make sim       — все тесты RTL (движок коррелятора, режекторный фильтр, система)
#   make syn       — синтез, размещение и трассировка LFE5U-45F-6BG381I, build/mgp8.bit
#   make engine    — P&R одного движка коррелятора (оценка частоты, 3 seed)
#   make notch     — P&R режекторного фильтра (оценка частоты)
RTL    = rtl/cmem_4kx4.v rtl/corr_engine.v rtl/corr_bank.v rtl/rf_capture.v rtl/notch.v \
         rtl/timebase.v rtl/fmc_slave.v rtl/max_spi.v rtl/snapshot.v rtl/mgp8_core.v rtl/mgp8_top.v
IVFLAGS = -g2005 -Wall
B       = build
SEED   ?= 1

.PHONY: sim sim-engine sim-notch sim-sys syn engine notch clean
sim: sim-engine sim-notch sim-sys

$(B):
	mkdir -p $(B) tb/out tb/stim

sim-engine: | $(B)
	python3 tb/gen_stim.py gen
	iverilog $(IVFLAGS) -o $(B)/tb_ce.vvp tb/tb_corr_engine.v rtl/corr_engine.v rtl/cmem_4kx4.v
	vvp -n $(B)/tb_ce.vvp > $(B)/sim_engine.log
	python3 tb/gen_stim.py check

sim-notch: | $(B)
	python3 tb/gen_notch.py gen
	iverilog $(IVFLAGS) -o $(B)/tb_notch.vvp tb/tb_notch.v rtl/notch.v
	vvp -n $(B)/tb_notch.vvp > $(B)/sim_notch.log
	python3 tb/gen_notch.py check

sim-sys: | $(B)
	python3 tb/gen_sys.py gen
	iverilog $(IVFLAGS) -DSIM -o $(B)/tb_sys.vvp tb/tb_mgp8.v $(RTL)
	vvp -n $(B)/tb_sys.vvp > $(B)/sim_sys.log
	python3 tb/gen_sys.py check

$(B)/mgp8.json: $(RTL) | $(B)
	yosys -l $(B)/yosys.log -q -p "read_verilog $(RTL); synth_ecp5 -top mgp8_top -json $@"

syn/mgp8.lpf: syn/gen_lpf.py
	python3 syn/gen_lpf.py

syn: $(B)/mgp8.json syn/mgp8.lpf
	nextpnr-ecp5 --45k --package CABGA381 --speed 6 --json $(B)/mgp8.json --lpf syn/mgp8.lpf \
	    --textcfg $(B)/mgp8.config --report $(B)/pnr_report.json --seed $(SEED) > $(B)/nextpnr.log 2>&1
	grep -E "Max frequency" $(B)/nextpnr.log | tail -1
	ecppack --compress $(B)/mgp8.config $(B)/mgp8.bit

engine: | $(B)
	yosys -q -p "read_verilog rtl/corr_engine.v rtl/cmem_4kx4.v syn/engine_wrap.v; synth_ecp5 -top engine_wrap -json $(B)/ew.json"
	for s in 1 2 3; do nextpnr-ecp5 --45k --package CABGA381 --speed 6 --json $(B)/ew.json \
	    --lpf syn/engine_wrap.lpf --lpf-allow-unconstrained --seed $$s > $(B)/ew_pnr$$s.log 2>&1; \
	    grep -E "Max frequency" $(B)/ew_pnr$$s.log | tail -1; done

notch: | $(B)
	yosys -q -p "read_verilog rtl/notch.v syn/notch_wrap.v; synth_ecp5 -top notch_wrap -json $(B)/nw.json"
	nextpnr-ecp5 --45k --package CABGA381 --speed 6 --json $(B)/nw.json --lpf syn/notch_wrap.lpf \
	    --lpf-allow-unconstrained --seed 1 > $(B)/nw_pnr.log 2>&1; \
	grep -E "Max frequency" $(B)/nw_pnr.log | tail -1

clean:
	rm -rf $(B) tb/out tb/stim
