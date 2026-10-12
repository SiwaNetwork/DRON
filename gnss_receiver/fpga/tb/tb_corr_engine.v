// Тестовое окружение движка коррелятора: воспроизводит сценарий из tb/stim/*.hex,
// записывает все сбросы накопителей в tb/out/dumps_rtl.txt для сверки с моделью.
`timescale 1ns/1ps
`default_nettype none
module tb_corr_engine;
    reg clk = 0, rst = 1;
    always #5.208 clk = ~clk;            // 96 МГц = 4 × 24 МГц
    reg          grp_stb = 0;
    reg  [127:0] grp_data = 0;
    reg  [31:0]  grp_count = 0;
    reg          bus_we = 0, bus_re = 0;
    reg  [8:0]   bus_addr = 0;
    reg  [31:0]  bus_wdata = 0;
    wire [31:0]  bus_rdata;
    wire         irq;
    corr_engine dut (
        .clk(clk), .rst(rst), .grp_stb(grp_stb), .grp_data(grp_data), .grp_count(grp_count),
        .bus_we(bus_we), .bus_re(bus_re), .bus_addr(bus_addr), .bus_wdata(bus_wdata),
        .bus_rdata(bus_rdata), .irq(irq));

    // cfg.hex: [0] — число слов, далее пары (адрес[8:0], данные) начальной настройки;
    // samples.hex: [0] — число отсчётов, далее слова отсчётов; events.hex: [0] — число событий,
    // далее тройки (номер отсчёта, адрес, данные) — записи по шине во время прогона
    reg [31:0] cfg [0:1<<20];
    reg [31:0] smp [0:1<<22];
    reg [31:0] tev [0:255];
    integer nsmp, ncfg, ntev, i, g, c, f, e, busy;
    initial begin
        $readmemh("tb/stim/cfg.hex", cfg);
        $readmemh("tb/stim/samples.hex", smp);
        $readmemh("tb/stim/events.hex", tev);
        nsmp = smp[0]; ncfg = cfg[0]; ntev = tev[0];
        f = $fopen("tb/out/dumps_rtl.txt", "w");
        repeat (5) @(posedge clk);
        rst = 0;
        @(posedge clk);
        // начальная настройка: отсчёты не подаются, счётчик слотов работает;
        // интервал между записями 32 такта, после записи кода — ожидание BUSY = 0
        for (i = 1; i <= ncfg; i = i + 2) begin
            bus_addr <= cfg[i][8:0]; bus_wdata <= cfg[i+1]; bus_we <= 1;
            @(posedge clk); bus_we <= 0;
            repeat (31) @(posedge clk);
            if (cfg[i][8:0] == 9'h101) begin
                busy = 1;
                while (busy) begin
                    bus_addr <= 9'h103; bus_re <= 1; @(posedge clk); bus_re <= 0; repeat (2) @(posedge clk);
                    busy = bus_rdata[0];
                end
            end
        end
        // поток групп по 4 отсчёта: строб раз в 16 тактов; события шины группы — по одному за такт
        e = 1;
        for (g = 0; g < nsmp / 4; g = g + 1) begin
            grp_data <= {smp[4*g + 4], smp[4*g + 3], smp[4*g + 2], smp[4*g + 1]};
            grp_count <= 4*g; grp_stb <= 1;
            for (c = 0; c < 16; c = c + 1) begin
                if (e <= 3*ntev && tev[e] < 4*g + 4) begin
                    bus_addr <= tev[e+1][8:0]; bus_wdata <= tev[e+2]; bus_we <= 1;
                    e = e + 3;
                end
                @(posedge clk); grp_stb <= 0; bus_we <= 0;
            end
        end
        repeat (20) @(posedge clk);
        // проверка чтения по шине: PI слота 0
        bus_addr <= 9'h00A; bus_re <= 1; @(posedge clk); bus_re <= 0; repeat (2) @(posedge clk);
        $fwrite(f, "BUS PI0 %0d\n", $signed(bus_rdata));
        $fclose(f);
        $display("tb_corr_engine: обработано %0d отсчётов", nsmp);
        $finish;
    end
    // журнал сбросов
    always @(posedge clk)
        if (dut.s4_v && dut.s4_dump)
            $fwrite(f, "%0d %0d %0d %0d %0d %0d %0d %0d\n", dut.s4_slot, dut.s4_t,
                    dut.n_ei, dut.n_eq, dut.n_pi, dut.n_pq, dut.n_li, dut.n_lq);
endmodule
`default_nettype wire
