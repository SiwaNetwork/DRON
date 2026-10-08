// =============================================================================
// МГП-8. Интерфейс SPI микросхем MAX2771 (трёхпроводный: SCLK, SDATA, CSN×8).
//
// Кадр MAX2771: заголовок 16 бит {адрес[11:0], R/W (1 — чтение), 000}, затем 32 бита данных,
// старшим битом вперёд; MAX2771 принимает бит по фронту SCLK, при чтении выдаёт данные после
// спада SCLK, следующего за заголовком. (Так же работает ПО FX3 PocketSDR FE 8CH.)
//
// Режимы: passthru = 0 — ведущий — МК (через регистры ПЛИС); passthru = 1 — ведущий — FX3
// (программа PocketSDR pocket_conf по USB): SCLK, CSN и SDATA передаются с выводов FX3 через
// синхронизатор, направление SDATA переключается по заголовку кадра (чтение — от MAX2771 к FX3).
// =============================================================================
`default_nettype none

module max_spi (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,            // строб запуска (от МК)
    input  wire [2:0]  ch,
    input  wire        rd,
    input  wire [11:0] addr,
    input  wire [31:0] wdata,
    input  wire [7:0]  div,              // полупериод SCLK, тактов (≥ 2)
    output reg         busy,
    output reg         done,             // строб завершения
    output reg  [31:0] rdata,
    input  wire        passthru,
    // FX3
    input  wire        fx3_sclk,
    input  wire [7:0]  fx3_csn,
    input  wire        fx3_sdata_i,
    output wire        fx3_sdata_o,
    output wire        fx3_sdata_oe,
    // MAX2771
    output wire        max_sclk,
    output wire [7:0]  max_csn,
    output wire        max_sdata_o,
    output wire        max_sdata_oe,
    input  wire        max_sdata_i
);
    // ------------------------------------------------------------ ведущий (МК)
    reg [47:0] sh;
    reg [5:0]  nbit;
    reg [7:0]  cnt;
    reg        sclk_r, oe_r, rd_r;
    reg [7:0]  csn_r;
    always @(posedge clk) begin
        done <= 1'b0;
        if (rst) begin
            busy <= 1'b0; sclk_r <= 1'b0; oe_r <= 1'b0; csn_r <= 8'hFF;
        end else if (!busy) begin
            if (start) begin
                sh    <= {addr, rd, 3'b000, rd ? 32'd0 : wdata};
                nbit  <= 6'd48;
                rd_r  <= rd;
                csn_r <= ~(8'd1 << ch);
                oe_r  <= 1'b1;
                cnt   <= div;
                busy  <= 1'b1;
                sclk_r <= 1'b0;
            end
        end else if (cnt != 0) begin
            cnt <= cnt - 1'b1;
        end else begin
            cnt <= div;
            if (!sclk_r) begin                       // фронт SCLK
                sclk_r <= 1'b1;
                if (rd_r && nbit <= 6'd32) rdata <= {rdata[30:0], max_sdata_i};
            end else begin                           // спад SCLK
                sclk_r <= 1'b0;
                sh   <= {sh[46:0], 1'b0};
                nbit <= nbit - 1'b1;
                if (nbit == 6'd33 && rd_r) oe_r <= 1'b0;    // заголовок передан
                if (nbit == 6'd1) begin
                    busy <= 1'b0; done <= 1'b1; csn_r <= 8'hFF; oe_r <= 1'b0;
                end
            end
        end
    end

    // ------------------------------------------------------------ транзит FX3
    // Сигналы FX3 и данные MAX2771 проходят двухтриггерный синхронизатор (FX3 формирует SPI
    // программно, такт — единицы микросекунд); все сигналы задерживаются одинаково.
    (* async_reg = "true" *) reg [1:0] fs_s, fd_s, md_s;
    (* async_reg = "true" *) reg [7:0] fc_1, fc_2;
    reg       fs_3;
    reg [4:0] fcnt;
    reg       fmode, fread;
    always @(posedge clk) begin
        fs_s <= {fs_s[0], fx3_sclk};
        fd_s <= {fd_s[0], fx3_sdata_i};
        md_s <= {md_s[0], max_sdata_i};
        fc_1 <= fx3_csn; fc_2 <= fc_1;
        fs_3 <= fs_s[1];
        if (rst || !passthru || &fc_2) begin
            fcnt <= 0; fmode <= 1'b0; fread <= 1'b0;
        end else if (!fs_3 && fs_s[1]) begin         // фронт SCLK от FX3
            if (fcnt != 5'd31) fcnt <= fcnt + 1'b1;
            if (fcnt == 5'd12) fmode <= fd_s[1];      // 13-й бит — R/W
        end else if (fs_3 && !fs_s[1]) begin         // спад
            if (fcnt == 5'd16 && fmode) fread <= 1'b1;
        end
    end

    assign max_sclk     = passthru ? fs_s[1] : sclk_r;
    assign max_csn      = passthru ? fc_2 : csn_r;
    assign max_sdata_o  = passthru ? fd_s[1] : sh[47];
    assign max_sdata_oe = passthru ? !fread : oe_r;
    assign fx3_sdata_o  = md_s[1];
    assign fx3_sdata_oe = passthru && fread;
endmodule
`default_nettype wire
