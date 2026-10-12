// Системный тест ПЛИС МГП-8: верхний уровень mgp8_top (-DSIM), модель шины FMC STM32H743
// (мультиплексированный асинхронный режим, NWAIT), модели MAX2771 (отсчёты и SPI) и FX3.
// Сценарий — tb/gen_sys.py. Результаты — tb/out/sys_rtl.txt.
`timescale 1ns/1ps
`default_nettype none
module tb;
    reg clk96 = 0;
    always #5.2083 clk96 = ~clk96;
    localparam real TH = 4.1667;         // такт HCLK 240 МГц

    // ------------------------------------------------------------ выводы
    reg  [7:0]  max_i1 = 0, max_i0 = 0, max_q1 = 0, max_q0 = 0;
    wire [7:0]  max_csn, max_shdn;
    wire        max_sclk, max_sdata;
    wire [31:0] fx3_d;
    wire        fx3_pclk, fx3_sdata;
    wire [7:0]  fx3_lock;
    wire [15:0] fmc_da;
    reg         ne = 1, noe = 1, nwe = 1, nl = 1;
    wire        nwait, irq, mclk, pps_mcu, ext_mcu, pps, led_pps, led_stat, fcs, fwp, fhold;
    wire [7:0]  dbg;
    reg         extint = 0, refin = 0;
    reg         ad_drv = 0;
    reg  [15:0] ad_val = 0;
    assign fmc_da = ad_drv ? ad_val : 16'hzzzz;
    pullup (fx3_sdata);

    mgp8_top #(.NENG(2)) dut (
        .ADC_SCLK(1'b0),
        .MAX_I1(max_i1), .MAX_I0(max_i0), .MAX_Q1(max_q1), .MAX_Q0(max_q0), .MAX_LD(8'hA5),
        .MAX_CSN(max_csn), .MAX_SHDN(max_shdn), .MAX_SCLK(max_sclk), .MAX_SDATA(max_sdata),
        .FX3_D(fx3_d), .FX3_PCLK(fx3_pclk), .FX3_SCLK(1'b0), .FX3_SDATA(fx3_sdata), .FX3_CSN(8'hFF),
        .FX3_LOCK(fx3_lock), .FX3_PWR_OK(1'b1),
        .FMC_DA(fmc_da), .FMC_NE1(ne), .FMC_NOE(noe), .FMC_NWE(nwe), .FMC_NL(nl), .FMC_NWAIT(nwait),
        .FPGA_IRQ(irq), .MCU_CLK24(mclk), .PPS_MCU(pps_mcu), .EXTINT_MCU(ext_mcu),
        .PPS_FPGA(pps), .EXTINT_FPGA(extint), .REF_CMP(refin), .LED_PPS(led_pps), .LED_STAT(led_stat),
        .FPGA_DBG(dbg), .FLASH_CS(fcs), .FLASH_WP(fwp), .FLASH_HOLD(fhold));

    // ------------------------------------------------------------ данные сценария
    reg [31:0] cmd [0:1<<16];
    reg [31:0] smp [0:1<<20];
    integer ncmd, nsmp, f;
    initial begin
        $readmemh("tb/stim/sys_cmd.hex", cmd);
        $readmemh("tb/stim/sys_smp.hex", smp);
        ncmd = cmd[0]; nsmp = smp[0];
        f = $fopen("tb/out/sys_rtl.txt", "w");
    end

    // ------------------------------------------------------------ MAX2771: отсчёты на выводах
    // (внутренний формат {sI, mI, sQ, mQ} -> выводы: I1 = sI, I0 = mI, Q1 = ~sQ, Q0 = mQ)
    integer k, n_next;
    always @(posedge clk96) begin
        if (dut.u_core.u_cap.t96[1:0] == 2'd2) begin
            n_next = dut.u_core.u_cap.n;
            for (k = 0; k < 8; k = k + 1) begin
                max_i1[k] <= smp[n_next + 1][4*k + 3];
                max_i0[k] <= smp[n_next + 1][4*k + 2];
                max_q1[k] <= ~smp[n_next + 1][4*k + 1];
                max_q0[k] <= smp[n_next + 1][4*k + 0];
            end
        end
    end

    // ------------------------------------------------------------ MAX2771: SPI
    reg        sd_drv = 0, sd_val = 0;
    reg [15:0] hdr;
    reg [31:0] wsh, rsh;
    integer    scnt = 0;
    reg [2:0]  spi_ch;
    reg [11:0] spi_wa;
    reg [31:0] spi_wd;
    reg        spi_wv = 0;
    assign max_sdata = sd_drv ? sd_val : 1'bz;
    always @(posedge max_sclk) if (max_csn != 8'hFF) begin
        if (scnt < 16) hdr <= {hdr[14:0], max_sdata};
        else if (!hdr[3]) wsh <= {wsh[30:0], max_sdata};
        scnt <= scnt + 1;
    end
    always @(negedge max_sclk) if (max_csn != 8'hFF) begin
        if (scnt == 16 && hdr[3]) begin
            sd_drv <= 1; rsh <= {20'hC0DE0, hdr[15:4]} << 1; sd_val <= 1'b1;   // бит 31 значения = 1
        end else if (scnt > 16 && sd_drv) begin
            sd_val <= rsh[31]; rsh <= rsh << 1;
        end
    end
    always @(max_csn) if (max_csn == 8'hFF) begin
        if (scnt == 48 && !hdr[3]) begin
            spi_wa = hdr[15:4]; spi_wd = wsh; spi_wv = 1;
        end
        scnt = 0; sd_drv = 0;
    end else begin
        for (k = 0; k < 8; k = k + 1) if (!max_csn[k]) spi_ch = k;
    end

    // ------------------------------------------------------------ шина FMC (модель STM32H743)
    task fmc_w16(input [15:0] ha, input [15:0] d);
        begin
            ne = 0; nl = 0; ad_drv = 1; ad_val = ha;
            #(4*TH) nl = 1;
            #(2*TH) ad_val = d; nwe = 0;
            #(12*TH) nwe = 1;
            #(TH) ne = 1; ad_drv = 0;
            #(4*TH);
        end
    endtask
    task fmc_r16(input [15:0] ha, output [15:0] d);
        begin
            ne = 0; nl = 0; ad_drv = 1; ad_val = ha;
            #(4*TH) nl = 1;
            #(2*TH) ad_drv = 0; noe = 0;
            #(12*TH);
            while (nwait == 1'b0) #(TH);
            #(4*TH) d = fmc_da;
            noe = 1;
            #(TH) ne = 1;
            #(4*TH);
        end
    endtask
    task wr32(input [14:0] wa, input [31:0] d);
        begin fmc_w16({wa, 1'b0}, d[15:0]); fmc_w16({wa, 1'b1}, d[31:16]); end
    endtask
    reg [15:0] lo16, hi16;
    task rd32(input [14:0] wa, output [31:0] d);
        begin fmc_r16({wa, 1'b0}, lo16); fmc_r16({wa, 1'b1}, hi16); d = {hi16, lo16}; end
    endtask

    // ------------------------------------------------------------ наблюдение 1PPS, FX3
    reg [63:0] pps_seen = 0;
    always @(posedge pps) pps_seen = dut.u_core.u_cap.t96 - 1;   // такт, в конце которого фронт
    integer fx3_ok = 0, fx3_bad = 0;
    reg [31:0] wexp, wsrc;
    always @(posedge fx3_pclk) begin
        wsrc = smp[dut.u_core.u_cap.smp_count + 1];
        for (k = 0; k < 8; k = k + 1)
            wexp[4*k +: 4] = {~wsrc[4*k + 1], wsrc[4*k], wsrc[4*k + 3], wsrc[4*k + 2]};
        if (dut.u_core.u_cap.smp_count > 4) begin
            if (fx3_d === wexp) fx3_ok = fx3_ok + 1; else fx3_bad = fx3_bad + 1;
        end
    end

    // ------------------------------------------------------------ программа МК
    integer i, e, s, busy, nd, nsys;
    reg [31:0] v, emask, smask, st, t_lo, t_hi, r [0:6];
    reg [63:0] tnow, ext_exp;
    initial begin
        nd = 0;
        #2000;
        rd32(15'h0000, v);
        $fwrite(f, "ID %08x %s\n", v, v == 32'h4D475038 ? "PASS" : "FAIL");
        wr32(15'h0002, 32'h0000_FF04);                       // SHDN = все включены, выдача в FX3
        // --- SPI MAX2771: запись и чтение регистра
        wr32(15'h0021, 32'h1234_5678);
        wr32(15'h0020, {16'd0, 12'h005, 1'b0, 3'd3});
        busy = 1; while (busy) begin rd32(15'h0020, v); busy = v[31]; end
        $fwrite(f, "SPI W ch=%0d a=%03x d=%08x %s\n", spi_ch, spi_wa, spi_wd,
                (spi_wv && spi_ch == 3 && spi_wa == 12'h005 && spi_wd == 32'h12345678) ? "PASS" : "FAIL");
        wr32(15'h0020, {16'd0, 12'h00A, 1'b1, 3'd6});
        busy = 1; while (busy) begin rd32(15'h0020, v); busy = v[31]; end
        rd32(15'h0022, v);
        $fwrite(f, "SPI R ch=%0d d=%08x %s\n", spi_ch, v,
                (spi_ch == 6 && v == {20'hC0DE0, 12'h00A}) ? "PASS" : "FAIL");
        // --- настройка корреляторов
        for (i = 0; i < ncmd; i = i + 1) begin
            wr32(cmd[3*i + 2][14:0], cmd[3*i + 3]);
            if (cmd[3*i + 1] == 1) begin                     // запись кода: ожидание BUSY движка
                busy = 1;
                while (busy) begin rd32((cmd[3*i + 2][14:0] & 15'h7E00) | 15'h0103, v); busy = v[0]; end
            end
        end
        // --- одновременный пуск каналов с заданного отсчёта
        rd32(15'h0004, v); t_lo = v;
        st = ((t_lo >> 2) + 3000) & 32'hFFFF_FFFC;
        $fwrite(f, "START %0d\n", st);
        for (e = 0; e < 2; e = e + 1) begin
            emask = 0;
            for (i = 0; i < ncmd; i = i + 1)
                if (cmd[3*i + 1] == 0 && cmd[3*i + 2][14:12] == 3'b001 && cmd[3*i + 2][11:9] == e
                    && !cmd[3*i + 2][8] && cmd[3*i + 2][3:0] == 0)
                    emask = emask | (32'd1 << cmd[3*i + 2][7:4]);
            wr32(15'h1000 + (e << 9) + 15'h104, st);
            wr32(15'h1000 + (e << 9) + 15'h105, emask);
        end
        // --- 1PPS, EXTINT, снимок
        rd32(15'h0004, t_lo); rd32(15'h0005, t_hi);
        tnow = {t_hi, t_lo};
        wr32(15'h000E, 32'd960);                            // длительность 10 мкс
        wr32(15'h000C, tnow[31:0] + 32'd20000);
        wr32(15'h000D, tnow[63:32]);
        wr32(15'h0031, st + 1000);                           // снимок: канал 0, 256 отсчётов
        wr32(15'h0032, 256);
        wr32(15'h0030, 32'h0000_0008);
        wr32(15'h0006, 32'd1000);                            // TIC: каждые 1000 отсчётов
        // --- приём результатов по прерыванию
        wr32(15'h000A, 32'h0000_0001);
        while (dut.u_core.u_cap.n < nsmp - 200) begin
            if (irq) begin
                rd32(15'h1E00, emask);
                for (e = 0; e < 2; e = e + 1) if (emask[e]) begin
                    rd32(15'h1000 + (e << 9) + 15'h102, smask);
                    for (s = 0; s < 16; s = s + 1) if (smask[s]) begin
                        for (i = 0; i < 7; i = i + 1) rd32(15'h1000 + (e << 9) + (s << 4) + 8 + i, r[i]);
                        $fwrite(f, "D %0d %0d %0d %0d %0d %0d %0d %0d\n", 16*e + s, r[6],
                                $signed(r[0]), $signed(r[1]), $signed(r[2]), $signed(r[3]),
                                $signed(r[4]), $signed(r[5]));
                        nd = nd + 1;
                    end
                end
            end else
                #200;
            if (pps_seen != 0 && pps_seen != 1) begin
                rd32(15'h000E, v);
                $fwrite(f, "PPS t=%0d ожидалось %0d %s\n", pps_seen, tnow + 20000,
                        (pps_seen == tnow + 20000 && !v[31]) ? "PASS" : "FAIL");
                pps_seen = 1;
                // внешнее событие: фронт EXTINT между тактами
                @(posedge clk96); #3 extint = 1; ext_exp = dut.u_core.u_cap.t96;   // такт фронта
                #500 extint = 0;
                rd32(15'h0010, t_lo); rd32(15'h0011, t_hi);
                $fwrite(f, "EXT t=%0d ожидалось %0d %s\n", {t_hi, t_lo}, ext_exp,
                        ({t_hi, t_lo} == ext_exp) ? "PASS" : "FAIL");
            end
        end
        $fwrite(f, "END %0d\n", dut.u_core.u_cap.n);
        $fwrite(f, "NOTCH %0d\n", dut.u_core.u_notch.cfg_n);
        rd32(15'h0007, t_lo); rd32(15'h0008, t_hi);
        $fwrite(f, "TIC событий %0d, интервалов по 4000 тактов %0d, TIC_T = последнему событию: %0d %s\n",
                tic_n, tic_good, {t_hi, t_lo} == tic_last,
                (tic_n > 10 && tic_good == tic_n - 1 && {t_hi, t_lo} == tic_last) ? "PASS" : "FAIL");
        // --- снимок
        rd32(15'h0030, v);
        rd32(15'h0033, t_lo);
        $fwrite(f, "SNAP 0 %0d", t_lo);
        for (i = 0; i < 32; i = i + 1) begin rd32(15'h2000 + i, v); $fwrite(f, " %08x", v); end
        $fwrite(f, "\n");
        $fwrite(f, "FX3 слов %0d, ошибок %0d %s\n", fx3_ok, fx3_bad, (fx3_ok > 1000 && fx3_bad == 0) ? "PASS" : "FAIL");
        $fclose(f);
        $display("tb_mgp8: сбросов прочитано %0d", nd);
        $finish;
    end
    // отладка: выход режекторного фильтра
    integer fn;
    initial fn = $fopen("tb/out/sys_notch.txt", "w");
    always @(posedge clk96) if (dut.u_core.f_stb) $fwrite(fn, "%0d %08x\n", dut.u_core.f_count, dut.u_core.f_data);
    // TIC: интервалы между событиями
    integer tic_n = 0, tic_good = 0;
    reg [63:0] tic_last = 0;
    always @(posedge clk96) if (dut.u_core.u_tb.tic_ev) begin
        if (tic_n > 0 && dut.u_core.u_tb.tic_t - tic_last == 64'd4000) tic_good = tic_good + 1;
        tic_last = dut.u_core.u_tb.tic_t;
        tic_n = tic_n + 1;
    end
endmodule
`default_nettype wire
