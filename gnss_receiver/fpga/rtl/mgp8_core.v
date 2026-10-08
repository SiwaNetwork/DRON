// =============================================================================
// МГП-8. Ядро ПЛИС (без примитивов ввода-вывода и ФАПЧ — для моделирования и синтеза).
//
// Адресное пространство шины FMC (слова 32 бит, адрес слова = HADDR[16:2]):
//   0x0000–0x00FF  системные регистры (таблица ниже)
//   0x1000–0x1FFF  корреляторы: 0x1000 + {engine[2:0], reg[8:0]} — см. corr_bank.v, corr_engine.v
//   0x2000–0x3FFF  буфер снимка (8K слов по 8 отсчётов)
// Системные регистры:
//   0x00 ID = 0x4D475038 («MGP8»)            0x01 VERSION {NENG[7:0], 8'h00, версия[15:0]}
//   0x02 CTRL: [1:0] фаза приёма отсчётов, [2] выдача отсчётов в FX3, [3] SPI у FX3,
//        [4] светодиод «Состояние», [15:8] SHDN MAX2771 (1 — включена), [16] сброс корреляторов
//   0x03 STATUS (чт.): [7:0] LD MAX2771, [8] питание FX3, [9] ФАПЧ захвачена
//   0x04 T96_LO (чт.; фиксирует T96_HI), 0x05 T96_HI — счётчик тактов 96 МГц
//   0x06 TIC_PERIOD (отсчётов; 0 — выкл.), 0x07 TIC_T_LO, 0x08 TIC_T_HI (чт.)
//   0x09 IRQ_STATUS (чт.), 0x0A IRQ_MASK, 0x0B IRQ_CLR (запись 1 — сброс):
//        [0] корреляторы (уровень), [1] TIC, [2] 1PPS выдан, [3] EXTINT, [4] REF, [5] SPI,
//        [6] снимок готов
//   0x0C PPS_T_LO, 0x0D PPS_T_HI (запись взводит импульс), 0x0E PPS_CTRL: [23:0] длительность,
//        тактов; [24] активный низкий; [31] (чт.) взведён
//   0x0F EXT_CTRL: [0] спад; 0x10 EXT_T_LO, 0x11 EXT_T_HI (чт.)
//   0x12 REF_T_LO, 0x13 REF_T_HI, 0x14 REF_CNT (чт.)
//   0x20 SPI_CMD: [2:0] канал, [3] чтение, [15:4] адрес (запись запускает обмен), [31] занят (чт.)
//   0x21 SPI_WDATA, 0x22 SPI_RDATA (чт.), 0x23 SPI_DIV (полупериод SCLK, тактов)
//   0x30 SNAP_CTRL: [2:0] канал, [3] по времени (запись запускает), [31] занят (чт.)
//   0x31 SNAP_T (номер отсчёта начала, мл. 32 бит), 0x32 SNAP_LEN, 0x33 SNAP_T0 (чт.)
//   0x40 DBG_SEL — выбор сигналов на выводы отладки
//   0x50 NOTCH_EN: [7:0] режекторный фильтр канала включён (запись обнуляет окно АРУ фильтра),
//        [8] снимок — до фильтра (1) / после фильтра (0), [23:16] дизеринг перед повторным квантованием
//   0x51 NOTCH_MU: 4 бита на канал (μ, постоянная сглаживания 2^μ отсчётов)
//   0x58–0x5F NOTCH_DPHI[0..7]: приращение фазы NCO помехи за отсчёт (f/Fд·2^32, Fд = 24 МГц)
// Корреляторы и снимок получают отсчёты после режекторного фильтра (задержка 15 тактов, номер
// отсчёта сопровождает данные); FX3 и шкала времени — непосредственно с АЦП.
// Задержка данных чтения — 4 такта (параметр RLAT ведомого FMC).
// =============================================================================
`default_nettype none

module mgp8_core #(
    parameter NENG    = 5,
    parameter VERSION = 16'h0100
) (
    input  wire        clk,              // 96 МГц
    input  wire        rst,
    input  wire        pll_lock,
    // MAX2771
    input  wire [7:0]  max_i1, max_i0, max_q1, max_q0, max_ld,
    output wire [7:0]  max_shdn,
    output wire        max_sclk,
    output wire [7:0]  max_csn,
    output wire        max_sdata_o,
    output wire        max_sdata_oe,
    input  wire        max_sdata_i,
    // FX3
    input  wire        fx3_pwr_ok,
    input  wire        fx3_sclk,
    input  wire [7:0]  fx3_csn,
    input  wire        fx3_sdata_i,
    output wire        fx3_sdata_o,
    output wire        fx3_sdata_oe,
    output reg  [31:0] fx3_d,
    output reg         fx3_pclk,
    output wire        fx3_oe,           // разрешение выходов к FX3 (FX3 включён и выдача разрешена)
    output wire [7:0]  fx3_lock,
    // FMC
    input  wire        fmc_ne, fmc_noe, fmc_nwe, fmc_nl,
    input  wire [15:0] fmc_ad_i,
    output wire [15:0] fmc_ad_o,
    output wire        fmc_ad_oe,
    output wire        fmc_nwait,
    output wire        irq,
    // время
    output wire        pps,
    input  wire        extint,
    input  wire        ref_in,
    output wire        led_pps,
    output wire        led_stat,
    output reg  [7:0]  dbg
);
    // ------------------------------------------------------------ шина
    wire        bus_we, bus_re;
    wire [14:0] bus_addr;
    wire [31:0] bus_wdata;
    reg  [31:0] bus_rdata;
    fmc_slave #(.RLAT(4)) u_fmc (
        .clk(clk), .rst(rst), .ne_pin(fmc_ne), .noe_pin(fmc_noe), .nwe_pin(fmc_nwe), .nl_pin(fmc_nl),
        .ad_in(fmc_ad_i), .ad_out(fmc_ad_o), .ad_oe(fmc_ad_oe), .nwait(fmc_nwait),
        .bus_we(bus_we), .bus_re(bus_re), .bus_addr(bus_addr), .bus_wdata(bus_wdata),
        .bus_rdata(bus_rdata));
    wire sel_sys  = (bus_addr[14:8] == 7'd0);
    wire sel_corr = (bus_addr[14:12] == 3'b001);
    wire sel_snap = (bus_addr[14:13] == 2'b01);
    wire [7:0] ra = bus_addr[7:0];

    // ------------------------------------------------------------ регистры управления
    reg [31:0] ctrl;
    reg [31:0] tic_period, irq_mask, pps_lo, pps_hi, pps_ctrl, ext_ctrl;
    reg [31:0] spi_wdata, spi_div, snap_ctrl, snap_t, snap_len, dbg_sel;
    reg [31:0] notch_ctl, notch_mu;
    reg [31:0]  notch_dp [0:7];
    wire [255:0] notch_dphi = {notch_dp[7], notch_dp[6], notch_dp[5], notch_dp[4],
                               notch_dp[3], notch_dp[2], notch_dp[1], notch_dp[0]};
    integer nk;
    reg        notch_wr;
    reg        pps_arm, spi_start, snap_arm, corr_rst;
    always @(posedge clk) begin
        pps_arm <= 1'b0; spi_start <= 1'b0; snap_arm <= 1'b0; notch_wr <= 1'b0;
        if (rst) begin
            ctrl <= 32'h0000_FF00; tic_period <= 32'd0; irq_mask <= 32'd0; pps_ctrl <= 32'd9_600_000;
            ext_ctrl <= 32'd0; spi_div <= 32'd8; dbg_sel <= 32'd0; corr_rst <= 1'b1;
            notch_ctl <= 32'd0; notch_mu <= 32'h8888_8888;
            for (nk = 0; nk < 8; nk = nk + 1) notch_dp[nk] <= 32'd0;
        end else begin
            corr_rst <= ctrl[16];
            if (bus_we && sel_sys) case (ra)
                8'h02: ctrl <= bus_wdata;
                8'h06: tic_period <= bus_wdata;
                8'h0A: irq_mask <= bus_wdata;
                8'h0C: pps_lo <= bus_wdata;
                8'h0D: begin pps_hi <= bus_wdata; pps_arm <= 1'b1; end
                8'h0E: pps_ctrl <= bus_wdata;
                8'h0F: ext_ctrl <= bus_wdata;
                8'h20: spi_start <= 1'b1;
                8'h21: spi_wdata <= bus_wdata;
                8'h23: spi_div <= bus_wdata;
                8'h30: begin snap_ctrl <= bus_wdata; snap_arm <= 1'b1; end
                8'h31: snap_t <= bus_wdata;
                8'h32: snap_len <= bus_wdata;
                8'h40: dbg_sel <= bus_wdata;
                8'h50: begin notch_ctl <= bus_wdata; notch_wr <= 1'b1; end
                8'h51: notch_mu <= bus_wdata;
                8'h58, 8'h59, 8'h5A, 8'h5B, 8'h5C, 8'h5D, 8'h5E, 8'h5F:
                    notch_dp[ra[2:0]] <= bus_wdata;
                default: ;
            endcase
        end
    end
    reg [31:0] spi_cmd;
    always @(posedge clk) if (bus_we && sel_sys && ra == 8'h20) spi_cmd <= bus_wdata;

    // ------------------------------------------------------------ приём отсчётов
    wire        smp_stb;
    wire [31:0] smp_data, usb_word;
    wire [63:0] smp_count, t96;
    rf_capture u_cap (
        .clk(clk), .rst(rst), .cap_phase(ctrl[1:0]),
        .pin_i1(max_i1), .pin_i0(max_i0), .pin_q1(max_q1), .pin_q0(max_q0),
        .smp_stb(smp_stb), .smp_data(smp_data), .smp_count(smp_count), .usb_word(usb_word), .t96(t96));

    // ------------------------------------------------------------ режекторный фильтр
    wire        f_stb;
    wire [31:0] f_data, f_count;
    notch u_notch (
        .clk(clk), .rst(rst), .smp_stb(smp_stb), .smp_data(smp_data), .smp_count(smp_count[31:0]),
        .en(notch_ctl[7:0]), .dith(notch_ctl[23:16]), .en_wr(notch_wr), .mu(notch_mu), .dphi(notch_dphi),
        .out_stb(f_stb), .out_data(f_data), .out_count(f_count));

    // ------------------------------------------------------------ корреляторы
    wire [31:0] corr_rdata;
    wire        corr_irq;
    corr_bank #(.NENG(NENG)) u_corr (
        .clk(clk), .rst(rst | corr_rst), .smp_stb(f_stb), .smp_data(f_data),
        .smp_count(f_count),
        .bus_we(bus_we && sel_corr), .bus_re(bus_re && sel_corr), .bus_addr(bus_addr[11:0]),
        .bus_wdata(bus_wdata), .bus_rdata(corr_rdata), .irq(corr_irq));

    // ------------------------------------------------------------ шкала времени
    wire        pps_armed, pps_ev, ext_ev, ref_ev, tic_ev;
    wire [63:0] ext_t, ref_t, tic_t;
    wire [31:0] ref_cnt;
    timebase u_tb (
        .clk(clk), .rst(rst), .t96(t96), .smp_stb(smp_stb),
        .pps_t({pps_hi, pps_lo}), .pps_arm(pps_arm), .pps_width(pps_ctrl[23:0]), .pps_pol(pps_ctrl[24]),
        .ext_edge(ext_ctrl[0]), .tic_period(tic_period), .ext_in(extint), .ref_in(ref_in),
        .pps_out(pps), .pps_armed(pps_armed), .pps_ev(pps_ev), .ext_t(ext_t), .ext_ev(ext_ev),
        .ref_t(ref_t), .ref_cnt(ref_cnt), .ref_ev(ref_ev), .tic_ev(tic_ev), .tic_t(tic_t));
    assign led_pps = pps ^ pps_ctrl[24];

    // ------------------------------------------------------------ SPI MAX2771
    wire        spi_busy, spi_done;
    wire [31:0] spi_rdata;
    max_spi u_spi (
        .clk(clk), .rst(rst), .start(spi_start), .ch(spi_cmd[2:0]), .rd(spi_cmd[3]),
        .addr(spi_cmd[15:4]), .wdata(spi_wdata), .div(spi_div[7:0]),
        .busy(spi_busy), .done(spi_done), .rdata(spi_rdata),
        .passthru(ctrl[3] && fx3_pwr_ok),
        .fx3_sclk(fx3_sclk), .fx3_csn(fx3_csn), .fx3_sdata_i(fx3_sdata_i), .fx3_sdata_o(fx3_sdata_o),
        .fx3_sdata_oe(fx3_sdata_oe),
        .max_sclk(max_sclk), .max_csn(max_csn), .max_sdata_o(max_sdata_o), .max_sdata_oe(max_sdata_oe),
        .max_sdata_i(max_sdata_i));
    assign max_shdn = ctrl[15:8];

    // ------------------------------------------------------------ снимок
    wire        snap_busy, snap_done;
    wire [31:0] snap_t0, snap_rdata;
    // источник снимка (до или после фильтра) — через регистр
    reg         s_stb;
    reg  [31:0] s_data;
    reg  [63:0] s_count;
    always @(posedge clk) begin
        s_stb   <= notch_ctl[8] ? smp_stb : f_stb;
        s_data  <= notch_ctl[8] ? smp_data : f_data;
        s_count <= notch_ctl[8] ? smp_count : {32'd0, f_count};
    end
    snapshot u_snap (
        .clk(clk), .rst(rst), .smp_stb(s_stb), .smp_data(s_data), .smp_count(s_count),
        .arm(snap_arm), .ch(snap_ctrl[2:0]), .at_time(snap_ctrl[3]), .t_start(snap_t),
        .len(snap_len[16:0]), .busy(snap_busy), .done(snap_done), .t0(snap_t0),
        .rd_addr(bus_addr[12:0]), .rd_data(snap_rdata));

    // ------------------------------------------------------------ прерывания
    reg [6:0] irq_st;
    always @(posedge clk) begin
        if (rst) irq_st <= 0;
        else begin
            if (bus_we && sel_sys && ra == 8'h0B) irq_st[6:1] <= irq_st[6:1] & ~bus_wdata[6:1];
            irq_st[0] <= corr_irq;
            if (tic_ev)    irq_st[1] <= 1'b1;
            if (pps_ev)    irq_st[2] <= 1'b1;
            if (ext_ev)    irq_st[3] <= 1'b1;
            if (ref_ev)    irq_st[4] <= 1'b1;
            if (spi_done)  irq_st[5] <= 1'b1;
            if (snap_done) irq_st[6] <= 1'b1;
        end
    end
    assign irq = |(irq_st & irq_mask[6:0]);

    // ------------------------------------------------------------ FX3: отсчёты в формате PocketSDR
    reg [1:0] uph;
    always @(posedge clk) begin
        uph <= smp_stb ? 2'd1 : uph + 1'b1;
        fx3_d <= usb_word;
        fx3_pclk <= (uph == 2'd2) || (uph == 2'd3);   // фронт PCLK — в середине интервала данных
    end
    assign fx3_oe   = fx3_pwr_ok && ctrl[2];
    assign fx3_lock = max_ld;

    // ------------------------------------------------------------ чтение (задержка 4 такта)
    reg [31:0] t96_hi_l;
    reg [31:0] sys_rd;
    // асинхронные входы состояния — через двухтриггерный синхронизатор
    reg [9:0]  st_s1, st_s2;
    always @(posedge clk) begin
        st_s1 <= {pll_lock, fx3_pwr_ok, max_ld};
        st_s2 <= st_s1;
    end
    always @(posedge clk) begin
        if (bus_re && sel_sys && ra == 8'h04) t96_hi_l <= t96[63:32];
        case (ra)
            8'h00: sys_rd <= 32'h4D475038;
            8'h01: sys_rd <= {NENG[7:0], 8'h00, VERSION};
            8'h02: sys_rd <= ctrl;
            8'h03: sys_rd <= {22'd0, st_s2};
            8'h04: sys_rd <= t96[31:0];
            8'h05: sys_rd <= t96_hi_l;
            8'h06: sys_rd <= tic_period;
            8'h07: sys_rd <= tic_t[31:0];
            8'h08: sys_rd <= tic_t[63:32];
            8'h09: sys_rd <= {25'd0, irq_st};
            8'h0A: sys_rd <= irq_mask;
            8'h0C: sys_rd <= pps_lo;
            8'h0D: sys_rd <= pps_hi;
            8'h0E: sys_rd <= {pps_armed, pps_ctrl[30:0]};
            8'h0F: sys_rd <= ext_ctrl;
            8'h10: sys_rd <= ext_t[31:0];
            8'h11: sys_rd <= ext_t[63:32];
            8'h12: sys_rd <= ref_t[31:0];
            8'h13: sys_rd <= ref_t[63:32];
            8'h14: sys_rd <= ref_cnt;
            8'h20: sys_rd <= {spi_busy, spi_cmd[30:0]};
            8'h21: sys_rd <= spi_wdata;
            8'h22: sys_rd <= spi_rdata;
            8'h23: sys_rd <= spi_div;
            8'h30: sys_rd <= {snap_busy, snap_ctrl[30:0]};
            8'h31: sys_rd <= snap_t;
            8'h32: sys_rd <= snap_len;
            8'h33: sys_rd <= snap_t0;
            8'h40: sys_rd <= dbg_sel;
            8'h50: sys_rd <= notch_ctl;
            8'h51: sys_rd <= notch_mu;
            8'h58, 8'h59, 8'h5A, 8'h5B, 8'h5C, 8'h5D, 8'h5E, 8'h5F:
                   sys_rd <= notch_dp[ra[2:0]];
            default: sys_rd <= 32'd0;
        endcase
    end
    // выравнивание задержек: системные регистры 1 → 3 такта, снимок 1 → 3, корреляторы 3
    reg [31:0] sys_d1, sys_d2, snap_d1, snap_d2;
    reg [1:0]  rsel0, rsel1, rsel2;
    always @(posedge clk) begin
        sys_d1 <= sys_rd;   sys_d2 <= sys_d1;
        snap_d1 <= snap_rdata; snap_d2 <= snap_d1;
        rsel0 <= sel_corr ? 2'd1 : sel_snap ? 2'd2 : 2'd0;
        rsel1 <= rsel0; rsel2 <= rsel1;
        case (rsel2)
            2'd1:    bus_rdata <= corr_rdata;
            2'd2:    bus_rdata <= snap_d2;
            default: bus_rdata <= sys_d2;
        endcase
    end

    // ------------------------------------------------------------ отладка, светодиод
    reg [23:0] hb;
    always @(posedge clk) hb <= hb + 1'b1;
    assign led_stat = ctrl[4] | (hb[23] & ~ctrl[4] & pll_lock & 1'b0);
    always @(posedge clk) begin
        case (dbg_sel[2:0])
            3'd0: dbg <= {irq, pps, smp_stb, corr_irq, bus_re, bus_we, fmc_nwait, fmc_ne};
            3'd1: dbg <= smp_data[7:0];
            3'd2: dbg <= {spi_busy, max_sclk, max_sdata_o, max_sdata_i, max_csn[3:0]};
            3'd3: dbg <= {snap_busy, tic_ev, ext_ev, ref_ev, extint, ref_in, pps_armed, pps};
            default: dbg <= t96[7:0];
        endcase
    end
endmodule
`default_nettype wire
