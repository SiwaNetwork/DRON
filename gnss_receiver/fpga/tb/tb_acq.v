// Тест ускорителя захвата acq_fft.v: сценарий и эталон — tb/gen_acq.c (битово-точная модель
// sw/fw/src/acqf_sim.c). Отсчёты — строб раз в 4 такта только во время подачи (команда 2).
// Результаты — tb/out/acq_rtl.txt.
`timescale 1ns/1ps
`default_nettype none
module tb_acq;
    localparam [31:0] BASE = 32'hFFFFF000;
    reg clk = 0, rst = 1;
    always #5 clk = ~clk;

    reg         smp_stb = 0, bus_we = 0, snap_we = 0;
    reg  [31:0] smp_data = 0, smp_count = 0, bus_wdata = 0, snap_wd = 0;
    reg  [14:0] bus_addr = 0;
    reg  [12:0] snap_wa = 0;
    wire [31:0] reg_q, mem_q;
    wire        busy, done;
    acq_fft dut (
        .clk(clk), .rst(rst), .smp_stb(smp_stb), .smp_data(smp_data), .smp_count(smp_count),
        .bus_we(bus_we), .bus_addr(bus_addr), .bus_wdata(bus_wdata), .reg_q(reg_q), .mem_q(mem_q),
        .snap_we(snap_we), .snap_wa(snap_wa), .snap_wd(snap_wd), .inhibit(1'b0),
        .busy(busy), .done(done));

    reg [31:0] cmd [0:1<<16];
    reg [31:0] smp [0:1<<18];
    integer ncmd, f, nd = 0, si = 0, pc, i;
    reg [31:0] o, a, d, v;
    reg [7:0]  r8;
    reg [13:0] p14;
    reg [17:0] v18;
    reg [12:0] w13;
    always @(posedge clk) if (done) nd <= nd + 1;

    task idle(input integer n);
        repeat (n) @(negedge clk);
    endtask
    task wr(input [14:0] ad, input [31:0] dv);
        begin
            @(negedge clk); bus_we = 1; bus_addr = ad; bus_wdata = dv;
            @(negedge clk); bus_we = 0;
        end
    endtask
    // чтение: регистры — reg_q (1 такт), окна памяти — mem_q (3 такта)
    task rd(input [14:0] ad, output [31:0] dv);
        begin
            @(negedge clk); bus_addr = ad;
            repeat (3) @(negedge clk);
            dv = (ad[14:13] != 2'b00) ? mem_q : reg_q;
        end
    endtask

    initial begin
        $readmemh("tb/stim/acq_cmd.hex", cmd);
        $readmemh("tb/stim/acq_smp.hex", smp);
        ncmd = cmd[0];
        f = $fopen("tb/out/acq_rtl.txt", "w");
        idle(4); rst = 0; idle(4);
        for (pc = 0; pc < ncmd; pc = pc + 3) begin
            o = cmd[1 + pc]; a = cmd[2 + pc]; d = cmd[3 + pc];
            idle(8);
            case (o)
                1: wr(a[14:0], d);
                2: while (si < a) begin
                    @(negedge clk); smp_stb = 1; smp_data = smp[1 + si]; smp_count = BASE + si;
                    @(negedge clk); smp_stb = 0;
                    idle(2);
                    si = si + 1;
                end
                3: begin
                    idle(64);
                    if (a[0]) for (i = 'h60; i < 'h88; i = i + 1) begin
                        rd(i, v); r8 = i; $fwrite(f, "R %h %h\n", r8, v);
                    end
                    if (a[1]) for (i = 0; i < 'h4000; i = i + 1) begin
                        rd(15'h4000 + i, v); p14 = i; v18 = v[17:0]; $fwrite(f, "P %h %h\n", p14, v18);
                    end
                    if (a[2]) begin rd(15'h60, v); $fwrite(f, "C %h\n", v); end
                    if (a[3]) $fwrite(f, "D %0d\n", nd);
                end
                4: begin
                    @(negedge clk); snap_we = 1; snap_wa = a[12:0]; snap_wd = d;
                    @(negedge clk); snap_we = 0;
                end
                5: begin
                    w13 = a[12:0]; rd({2'b01, w13}, v); $fwrite(f, "S %h %h\n", {1'b0, w13}, v);
                end
                default: pc = ncmd;
            endcase
        end
        $fclose(f);
        $display("tb_acq: команд %0d, отсчётов %0d, завершений %0d", ncmd / 3, si, nd);
        $finish;
    end
endmodule
`default_nettype wire
