// =============================================================================
// МГП-8 (ШИВА.468157.001). Верхний уровень ПЛИС LFE5U-45F-6BG381I.
// Имена портов совпадают с цепями схемы Э3 (hw/gen/design.py, hw/gen/data/fpga_pinout.json);
// назначение выводов — syn/mgp8.lpf (генерируется syn/gen_lpf.py).
// Каналы MAX2771 A..H — биты 0..7 векторов. Шина данных FX3 FX3_D[31:0] = GPIO FX3
// 0..15, 33..44, 46..49 (DQ0..DQ31 GPIF II, как в PocketSDR FE 8CH).
// =============================================================================
`default_nettype none

module mgp8_top #(
    parameter NENG = 5                   // движков коррелятора (×16 каналов)
) (
    input  wire        ADC_SCLK,         // 24 МГц — тактовый сигнал АЦП MAX2771 (опорный ТКГ)
    // MAX2771
    input  wire [7:0]  MAX_I1, MAX_I0, MAX_Q1, MAX_Q0, MAX_LD,
    output wire [7:0]  MAX_CSN, MAX_SHDN,
    output wire        MAX_SCLK,
    inout  wire        MAX_SDATA,
    // FX3
    inout  wire [31:0] FX3_D,
    inout  wire        FX3_PCLK,
    input  wire        FX3_SCLK,
    inout  wire        FX3_SDATA,
    input  wire [7:0]  FX3_CSN,
    inout  wire [7:0]  FX3_LOCK,
    input  wire        FX3_PWR_OK,
    // МК: FMC и служебные сигналы
    inout  wire [15:0] FMC_DA,
    input  wire        FMC_NE1, FMC_NOE, FMC_NWE, FMC_NL,
    output wire        FMC_NWAIT,
    output wire        FPGA_IRQ,
    output wire        MCU_CLK24,
    output wire        PPS_MCU,
    output wire        EXTINT_MCU,
    // время
    output wire        PPS_FPGA,
    input  wire        EXTINT_FPGA,
    input  wire        REF_CMP,
    output wire        LED_PPS,
    output wire        LED_STAT,
    output wire [7:0]  FPGA_DBG,
    // конфигурационная флеш-память (после загрузки — не выбрана)
    output wire        FLASH_CS,
    output wire        FLASH_WP,
    output wire        FLASH_HOLD
);
    // ------------------------------------------------------------ такты и сброс
    wire clk, locked;
`ifdef SIM
    // моделирование: 96 МГц подаётся извне через иерархическую ссылку tb.clk96
    assign clk = tb.clk96;
    assign locked = 1'b1;
`else
    (* FREQUENCY_PIN_CLKI = "24" *) (* FREQUENCY_PIN_CLKOP = "96" *)
    (* ICP_CURRENT = "12" *) (* LPF_RESISTOR = "8" *) (* MFG_ENABLE_FILTEROPAMP = "1" *)
    (* MFG_GMCREF_SEL = "2" *)
    EHXPLLL #(
        .PLLRST_ENA("DISABLED"), .INTFB_WAKE("DISABLED"), .STDBY_ENABLE("DISABLED"),
        .DPHASE_SOURCE("DISABLED"), .OUTDIVIDER_MUXA("DIVA"), .OUTDIVIDER_MUXB("DIVB"),
        .OUTDIVIDER_MUXC("DIVC"), .OUTDIVIDER_MUXD("DIVD"),
        .CLKI_DIV(1), .CLKOP_ENABLE("ENABLED"), .CLKOP_DIV(6), .CLKOP_CPHASE(2), .CLKOP_FPHASE(0),
        .FEEDBK_PATH("CLKOP"), .CLKFB_DIV(4)
    ) u_pll (
        .RST(1'b0), .STDBY(1'b0), .CLKI(ADC_SCLK), .CLKOP(clk), .CLKFB(clk), .CLKINTFB(),
        .PHASESEL0(1'b0), .PHASESEL1(1'b0), .PHASEDIR(1'b1), .PHASESTEP(1'b1),
        .PHASELOADREG(1'b1), .PLLWAKESYNC(1'b0), .ENCLKOP(1'b0), .LOCK(locked));
`endif
    reg [7:0] por = 8'd0;
    reg       rst = 1'b1;
    always @(posedge clk) begin
        if (!locked) por <= 8'd0;
        else if (!por[7]) por <= por + 1'b1;
        rst <= !por[7];
    end

    // ------------------------------------------------------------ ядро
    wire        max_sdata_o, max_sdata_oe, fx3_sdata_o, fx3_sdata_oe, fx3_oe, fx3_pclk;
    wire [31:0] fx3_d;
    wire [7:0]  fx3_lock;
    wire [15:0] fmc_ad_o;
    wire        fmc_ad_oe, pps, irq;
    mgp8_core #(.NENG(NENG)) u_core (
        .clk(clk), .rst(rst), .pll_lock(locked),
        .max_i1(MAX_I1), .max_i0(MAX_I0), .max_q1(MAX_Q1), .max_q0(MAX_Q0), .max_ld(MAX_LD),
        .max_shdn(MAX_SHDN), .max_sclk(MAX_SCLK), .max_csn(MAX_CSN),
        .max_sdata_o(max_sdata_o), .max_sdata_oe(max_sdata_oe), .max_sdata_i(MAX_SDATA),
        .fx3_pwr_ok(FX3_PWR_OK), .fx3_sclk(FX3_SCLK), .fx3_csn(FX3_CSN),
        .fx3_sdata_i(FX3_SDATA), .fx3_sdata_o(fx3_sdata_o), .fx3_sdata_oe(fx3_sdata_oe),
        .fx3_d(fx3_d), .fx3_pclk(fx3_pclk), .fx3_oe(fx3_oe), .fx3_lock(fx3_lock),
        .fmc_ne(FMC_NE1), .fmc_noe(FMC_NOE), .fmc_nwe(FMC_NWE), .fmc_nl(FMC_NL),
        .fmc_ad_i(FMC_DA), .fmc_ad_o(fmc_ad_o), .fmc_ad_oe(fmc_ad_oe), .fmc_nwait(FMC_NWAIT),
        .irq(irq), .pps(pps), .extint(EXTINT_FPGA), .ref_in(REF_CMP),
        .led_pps(LED_PPS), .led_stat(LED_STAT), .dbg(FPGA_DBG));

    // ------------------------------------------------------------ двунаправленные выводы
    assign MAX_SDATA = max_sdata_oe ? max_sdata_o : 1'bz;
    assign FX3_SDATA = fx3_sdata_oe ? fx3_sdata_o : 1'bz;
    assign FMC_DA    = fmc_ad_oe ? fmc_ad_o : 16'hzzzz;
    // выходы к FX3 — только при включённом FX3 (нет питания FX3 через защитные диоды)
    assign FX3_D     = fx3_oe ? fx3_d : 32'hzzzz_zzzz;
    assign FX3_PCLK  = fx3_oe ? fx3_pclk : 1'bz;
    assign FX3_LOCK  = FX3_PWR_OK ? fx3_lock : 8'hzz;

    // ------------------------------------------------------------ прочие выходы
    reg [1:0] div4 = 2'd0;
    always @(posedge clk) div4 <= div4 + 1'b1;
    assign MCU_CLK24  = div4[1];         // 24 МГц для HSE МК (режим внешнего тактового сигнала)
    assign FPGA_IRQ   = irq;
    assign PPS_FPGA   = pps;
    assign PPS_MCU    = pps;
    assign EXTINT_MCU = EXTINT_FPGA;
    assign FLASH_CS   = 1'b1;
    assign FLASH_WP   = 1'b1;
    assign FLASH_HOLD = 1'b1;
endmodule
`default_nettype wire
