// Обёртка для оценки ресурсов и Fmax режекторного фильтра (входы — ГПСЧ, настройка — сдвиговый
// регистр, выход — свёртка в один бит)
`default_nettype none
module notch_wrap (
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
    reg [304:0] sh;                      // {en_wr, en, dith, mu, dphi}
    reg [304:0] cfg;
    always @(posedge clk) begin
        sh <= {sh[303:0], sdi};
        if (sld) cfg <= sh; else cfg[304] <= 1'b0;
    end
    wire        o_stb;
    wire [31:0] o_data, o_count;
    notch u (.clk(clk), .rst(rst), .smp_stb(div == 2'd3), .smp_data(lfsr), .smp_count(cnt),
             .en(cfg[303:296]), .dith(cfg[295:288]), .en_wr(cfg[304]), .mu(cfg[287:256]), .dphi(cfg[255:0]),
             .out_stb(o_stb), .out_data(o_data), .out_count(o_count));
    reg r;
    always @(posedge clk) r <= o_stb ? ^{o_data, o_count} : r;
    assign sdo = r;
endmodule
`default_nettype wire
