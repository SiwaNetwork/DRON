// =============================================================================
// МГП-8. Блок корреляторов: NENG ≤ 7 движков по 16 каналов (80 каналов при NENG = 5).
// Группирует поток отсчётов (1 отсчёт за 4 такта clk) в группы по 4 отсчёта (группа начинается
// с отсчёта, номер которого кратен 4) и раздаёт их движкам.
//
// Адрес шины (слово 32 бит): {engine[2:0], addr[8:0]} — см. карту регистров corr_engine.v.
// Регистр блока (engine = 7, addr = 0): чтение — маска движков с запросом прерывания.
// Задержка чтения — 3 такта (регистр шины движка, регистр данных движка, мультиплексор блока).
// =============================================================================
`default_nettype none

module corr_bank #(
    parameter NENG = 5
) (
    input  wire        clk,
    input  wire        rst,
    input  wire        smp_stb,          // отсчёт (раз в 4 такта)
    input  wire [31:0] smp_data,         // 8 ВЧ-каналов × {I1,I0,Q1,Q0} (знак 1 = минус)
    input  wire [31:0] smp_count,        // номер отсчёта
    input  wire        bus_we,
    input  wire        bus_re,
    input  wire [11:0] bus_addr,
    input  wire [31:0] bus_wdata,
    output reg  [31:0] bus_rdata,
    output wire        irq
);
    // ------------------------------------------------------------ группы по 4 отсчёта
    reg [95:0]  g_buf;
    reg         grp_stb;
    reg [127:0] grp_data;
    reg [31:0]  grp_count;
    always @(posedge clk) begin
        grp_stb <= 1'b0;
        if (rst) begin
            g_buf <= 0;
        end else if (smp_stb) begin
            case (smp_count[1:0])
                2'd0: g_buf[31:0]  <= smp_data;
                2'd1: g_buf[63:32] <= smp_data;
                2'd2: g_buf[95:64] <= smp_data;
                2'd3: begin
                    grp_data  <= {smp_data, g_buf};
                    grp_count <= {smp_count[31:2], 2'b00};
                    grp_stb   <= 1'b1;
                end
            endcase
        end
    end

    // ------------------------------------------------------------ движки
    wire [31:0]     e_rdata [0:NENG-1];
    wire [NENG-1:0] e_irq;
    reg  [2:0]      ra1, ra2;            // номер движка для выбора данных чтения
    genvar e;
    generate
        for (e = 0; e < NENG; e = e + 1) begin : g_eng
            wire sel = (bus_addr[11:9] == e);
            corr_engine u_eng (
                .clk(clk), .rst(rst),
                .grp_stb(grp_stb), .grp_data(grp_data), .grp_count(grp_count),
                .bus_we(bus_we && sel), .bus_re(bus_re && sel), .bus_addr(bus_addr[8:0]),
                .bus_wdata(bus_wdata), .bus_rdata(e_rdata[e]), .irq(e_irq[e]));
        end
    endgenerate
    assign irq = |e_irq;

    reg [2:0] ra0;
    reg [NENG-1:0] irq_r;
    integer k;
    always @(posedge clk) begin
        ra0 <= bus_addr[11:9]; ra1 <= ra0; ra2 <= ra1;
        irq_r <= e_irq;
        bus_rdata <= 32'd0;
        if (ra1 == 3'd7)
            bus_rdata <= {{(32-NENG){1'b0}}, irq_r};
        else
            for (k = 0; k < NENG; k = k + 1)
                if (ra1 == k) bus_rdata <= e_rdata[k];
    end
endmodule
`default_nettype wire
