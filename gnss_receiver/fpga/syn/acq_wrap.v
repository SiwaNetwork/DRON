// Обёртка для оценки ресурсов и Fmax ускорителя захвата (отсчёты — ГПСЧ, шина и снимок —
// сдвиговый регистр, выход — свёртка в один бит)
`default_nettype none
module acq_wrap (
    input  wire clk, rst, sdi, sld,
    output wire sdo
);
    reg [31:0] lfsr = 32'h1;
    reg [1:0]  div = 0;
    reg [31:0] cnt = 0;
    always @(posedge clk) begin
        lfsr <= {lfsr[30:0], lfsr[31] ^ lfsr[21] ^ lfsr[1] ^ lfsr[0]};
        div <= div + 1'b1;
        if (div == 2'd3) cnt <= cnt + 1'b1;
    end
    reg [94:0] sh;                       // {inhibit, snap_wd, snap_wa, snap_we, bus_wdata, bus_addr, bus_we}
    reg [94:0] cfg;
    always @(posedge clk) begin
        sh <= {sh[93:0], sdi};
        if (sld) cfg <= sh; else begin cfg[0] <= 1'b0; cfg[48] <= 1'b0; end
    end
    wire [31:0] reg_q, mem_q;
    wire        busy, done;
    acq_fft u (.clk(clk), .rst(rst), .smp_stb(div == 2'd3), .smp_data(lfsr), .smp_count(cnt),
               .bus_we(cfg[0]), .bus_addr(cfg[15:1]), .bus_wdata(cfg[47:16]), .reg_q(reg_q), .mem_q(mem_q),
               .snap_we(cfg[48]), .snap_wa(cfg[61:49]), .snap_wd(cfg[93:62]), .inhibit(cfg[94]),
               .busy(busy), .done(done));
    reg r;
    always @(posedge clk) r <= ^{reg_q, mem_q, busy, done};
    assign sdo = r;
endmodule
`default_nettype wire
