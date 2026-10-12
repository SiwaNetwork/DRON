// Тест режекторного фильтра: входные слова из tb/stim/notch_in.hex, конфигурация —
// tb/stim/notch_cfg.hex (en, mu, dphi[0..7]); выход — tb/out/notch_out.txt (номер отсчёта, слово).
`timescale 1ns/1ps
module tb_notch;
    reg clk = 0, rst = 1;
    always #5.2 clk = ~clk;
    reg         smp_stb = 0;
    reg  [31:0] smp_data = 0, smp_count = 0;
    reg  [7:0]  en = 0, dith = 0;
    reg         en_wr = 0;
    reg  [31:0] mu = 0;
    reg  [255:0] dphi = 0;
    wire        out_stb;
    wire [31:0] out_data, out_count;
    notch dut (.clk(clk), .rst(rst), .smp_stb(smp_stb), .smp_data(smp_data), .smp_count(smp_count),
               .en(en), .dith(dith), .en_wr(en_wr), .mu(mu), .dphi(dphi),
               .out_stb(out_stb), .out_data(out_data), .out_count(out_count));
    reg [31:0] cfg [0:9];
    reg [31:0] mem [0:65535];
    integer n, nin, k, fo, nout;
    initial begin
        $readmemh("tb/stim/notch_cfg.hex", cfg);
        nin = cfg[0][31:16];
        $readmemh("tb/stim/notch_in.hex", mem);
        fo = $fopen("tb/out/notch_out.txt", "w");
        repeat (5) @(posedge clk);
        rst <= 0;
        mu <= cfg[1];
        for (k = 0; k < 8; k = k + 1) dphi[32*k +: 32] <= cfg[2 + k];
        en <= cfg[0][7:0]; dith <= cfg[0][15:8]; en_wr <= 1;
        @(posedge clk); en_wr <= 0;
        repeat (3) @(posedge clk);
        for (n = 0; n < nin; n = n + 1) begin
            smp_stb <= 1; smp_data <= mem[n]; smp_count <= 32'd1000 + n;
            @(posedge clk); smp_stb <= 0;
            repeat (3) @(posedge clk);
        end
        repeat (40) @(posedge clk);
        $fclose(fo);
        $display("notch: входных %0d, выходных %0d", nin, nout);
        $finish;
    end
    initial nout = 0;
    always @(posedge clk) if (out_stb) begin
        $fwrite(fo, "%0d %08x\n", out_count, out_data);
        nout = nout + 1;
    end
endmodule
