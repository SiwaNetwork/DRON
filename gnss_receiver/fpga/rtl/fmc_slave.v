// =============================================================================
// МГП-8. Ведомый интерфейс шины FMC STM32H743: память NOR/PSRAM, мультиплексированная шина
// адрес/данные 16 бит (AD[15:0], NADV = NL), асинхронный режим, сигнал ожидания NWAIT.
//
// На шине FMC — полуслова (адрес полуслова = HADDR[16:1]); внутренняя шина — слова 32 бит.
// Запись: младшее полуслово запоминается, запись слова выполняется при записи старшего.
// Чтение: при чтении младшего полуслова читается слово (младшее — на шину, старшее — в регистр),
// старшее полуслово выдаётся из регистра. 32-битное обращение МК — пара полуслов, младшее первым.
// Управляющие сигналы и AD проходят двухтриггерный синхронизатор (такт 96 МГц).
// NWAIT = 0 (ожидание), пока данные чтения не выставлены; выходной буфер AD включается
// комбинационно по NE1 = 0 и NOE = 0.
//
// Настройка FMC (HCLK = 240 МГц): MUXEN = 1, MWID = 16 бит, ASYNCWAIT = 1, WAITPOL = 0,
//   ADDSET ≥ 4, ADDHLD ≥ 2, DATAST ≥ 12, BUSTURN ≥ 4 тактов HCLK.
// =============================================================================
`default_nettype none

module fmc_slave #(
    parameter RLAT = 4                   // задержка данных чтения внутренней шины, тактов
) (
    input  wire        clk,
    input  wire        rst,
    input  wire        ne_pin, noe_pin, nwe_pin, nl_pin,
    input  wire [15:0] ad_in,
    output reg  [15:0] ad_out,
    output wire        ad_oe,
    output wire        nwait,
    output reg         bus_we,
    output reg         bus_re,
    output reg  [14:0] bus_addr,
    output reg  [31:0] bus_wdata,
    input  wire [31:0] bus_rdata
);
    (* async_reg = "true" *) reg [15:0] ad1, ad2;
    (* async_reg = "true" *) reg ne1, ne2, noe1, noe2, nwe1, nwe2, nl1, nl2;
    reg noe3, nwe3, nl3;
    always @(posedge clk) begin
        ad1 <= ad_in; ad2 <= ad1;
        ne1 <= ne_pin; noe1 <= noe_pin; nwe1 <= nwe_pin; nl1 <= nl_pin;
        ne2 <= ne1; noe2 <= noe1; nwe2 <= nwe1; nl2 <= nl1;
        noe3 <= noe2; nwe3 <= nwe2; nl3 <= nl2;
    end

    reg [15:0] haddr, wdat, wlo, rhi;
    reg        rdy;
    reg [RLAT:0] rp;
    always @(posedge clk) begin
        bus_we <= 1'b0;
        bus_re <= 1'b0;
        rp <= {rp[RLAT-1:0], 1'b0};
        if (rst) begin
            rdy <= 1'b0; rp <= 0;
        end else begin
            // фаза адреса
            if (!ne2 && !nl2) begin
                haddr <= ad2; rdy <= 1'b0;
            end
            // конец фазы адреса: старшее полуслово чтения выдаётся сразу из регистра
            if (!ne2 && nl2 && !nl3 && haddr[0]) begin
                ad_out <= rhi; rdy <= 1'b1;
            end
            // запись: данные — последние, принятые при NWE = 0
            if (!ne2 && !nwe2) wdat <= ad2;
            if (nwe2 && !nwe3) begin
                if (!haddr[0]) wlo <= wdat;
                else begin
                    bus_we <= 1'b1; bus_addr <= haddr[15:1]; bus_wdata <= {wdat, wlo};
                end
            end
            // чтение младшего полуслова — чтение слова
            if (!ne2 && !noe2 && noe3 && !haddr[0]) begin
                bus_re <= 1'b1; bus_addr <= haddr[15:1]; rp[0] <= 1'b1;
            end
            if (rp[RLAT]) begin
                ad_out <= bus_rdata[15:0]; rhi <= bus_rdata[31:16]; rdy <= 1'b1;
            end
        end
    end
    assign ad_oe = !ne_pin && !noe_pin;
    assign nwait = !(!ne_pin && !noe_pin && !rdy);
endmodule
`default_nettype wire
