// Обёртка для оценки ресурсов и Fmax одного движка коррелятора (входы — ГПСЧ, шина — сдвиговый регистр)
`default_nettype none
module engine_wrap (
    input  wire clk, rst, sdi, sld,
    output wire sdo, irq
);
    reg [127:0] lfsr = 128'h1;
    reg [3:0]   div = 0;
    reg [31:0]  cnt = 0;
    always @(posedge clk) begin
        lfsr <= {lfsr[126:0], lfsr[127] ^ lfsr[125] ^ lfsr[100] ^ lfsr[98]};
        div <= div + 1'b1;
        if (div == 4'd15) cnt <= cnt + 32'd4;
    end
    reg [42:0] sh;                       // {we, re, addr[8:0], data[31:0]}
    reg [42:0] cmd;
    always @(posedge clk) begin
        sh <= {sh[41:0], sdi};
        cmd <= sld ? sh : {2'b00, cmd[40:0]};
    end
    wire [31:0] rd;
    corr_engine u (.clk(clk), .rst(rst), .grp_stb(div == 4'd15), .grp_data(lfsr), .grp_count(cnt),
                   .bus_we(cmd[42]), .bus_re(cmd[41]), .bus_addr(cmd[40:32]), .bus_wdata(cmd[31:0]),
                   .bus_rdata(rd), .irq(irq));
    reg [31:0] rsh;
    always @(posedge clk) rsh <= sld ? rd : {rsh[30:0], 1'b0};
    assign sdo = rsh[31];
endmodule
`default_nettype wire
