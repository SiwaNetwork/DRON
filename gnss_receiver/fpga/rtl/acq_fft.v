// =============================================================================
// МГП-8. Ускоритель захвата: БПФ-поиск по задержке кода и сетке доплера в ПЛИС.
// Битово-точная модель — sw/fw/src/acqf_sim.c (там же описание алгоритма), регистры — inc/fpga.h
// (R_ACQ_*), драйвер — sw/fw/src/acq.c (acq_hw_*).
//
// Запуск — K периодов кода по Ns отсчётов; начала периодов — через Nper отсчётов (первый — сразу или
// с отсчёта ACQ_T). Захват периода: перенос на нулевую частоту (NCO 32 бит, таблица 64 × ±15) и
// усреднение в 2048 ячеек C (9 + 9 бит, общий пул 14/15). Обработка периода — машиной БПФ
// (основание 2, прореживание по частоте, 1 бабочка на такт, 11 этапов по 1040 тактов): прямое БПФ
// ячеек → спектр X; для каждой из ng гипотез g — Z[k] = conj(X[(k + m_g) mod N])·R[k], прямое БПФ,
// |·|² со сдвигом и накопление в A_g (пул 2g, 2g + 1) со сдвигом кода sh_g. В последнем периоде —
// максимум и сумма A_g (PEAK, SUM). Время обработки периода — ACQ_PROC_CLK(ng) тактов; расписание,
// которое не укладывается в Nper, отвергается при пуске (CTRL[30]).
//
// Память: общий пул 16 × 1K × 18 (при простое — буфер снимка: слово снимка wa — пары пул[2·wa[12:10]],
// пул[2·wa[12:10] + 1], младшие 16 бит; при работе — накопители A_g и ячейки C), рабочий массив БПФ
// W (2 банка 1K × 36, банк — чётность номера элемента), спектр X (2 × 1K × 18), опора R (2 × 1K × 18),
// таблица поворотов (1K × 17, rtl/acq_tw.hex — из tb/gen_acq.c).
// Шина: регистры 0x60–0x86 — запись и чтение (reg_q, задержка 1 такт); окно 0x4000–0x7FFF —
// запись R[k] (0x4000 + k), чтение пула (0x4000 + 1024·p + a); окно снимка 0x2000–0x3FFF — чтение
// (mem_q, задержка 3 такта). Пул доступен шине и снимку только при простое (busy = 0).
// =============================================================================
`default_nettype none

// двухпортовая память 1K × W (запись — порт A, чтение с регистром — порт B)
module acq_ram #(parameter W = 18) (
    input  wire         clk,
    input  wire         we,
    input  wire [9:0]   wa,
    input  wire [W-1:0] wd,
    input  wire [9:0]   ra,
    output reg  [W-1:0] rd
);
    (* no_rw_check *) reg [W-1:0] mem [0:1023];
    always @(posedge clk) begin
        if (we) mem[wa] <= wd;
        rd <= mem[ra];
    end
endmodule

// таблица поворотов T[q] = round(65536·cos(2πq/2048)), q = 0..512, — два порта чтения
module acq_twrom (
    input  wire        clk,
    input  wire [9:0]  a0, a1,
    output reg  [16:0] q0, q1
);
    reg [16:0] rom [0:1023];
    initial $readmemh("rtl/acq_tw.hex", rom);
    always @(posedge clk) begin
        q0 <= rom[a0];
        q1 <= rom[a1];
    end
endmodule

// умножитель 18 × 18 со знаком на блоке DSP: входной, конвейерный и выходной регистры
// внутри MULT18X18D (задержка 3 такта); Yosys сам эти регистры не использует, а снаружи
// блока DSP маршрут до логики занимает около 3 нс в каждую сторону
module acq_mul (
    input  wire        clk,
    input  wire [17:0] a, b,
    output wire [35:0] p
);
`ifdef SYNTHESIS
    MULT18X18D #(.REG_INPUTA_CLK("CLK0"), .REG_INPUTB_CLK("CLK0"), .REG_PIPELINE_CLK("CLK0"),
                 .REG_OUTPUT_CLK("CLK0"), .GSR("DISABLED")) u_m (
        .A17(a[17]), .A16(a[16]), .A15(a[15]), .A14(a[14]), .A13(a[13]), .A12(a[12]), .A11(a[11]), .A10(a[10]), .A9(a[9]),
        .A8(a[8]), .A7(a[7]), .A6(a[6]), .A5(a[5]), .A4(a[4]), .A3(a[3]), .A2(a[2]), .A1(a[1]), .A0(a[0]),
        .B17(b[17]), .B16(b[16]), .B15(b[15]), .B14(b[14]), .B13(b[13]), .B12(b[12]), .B11(b[11]), .B10(b[10]), .B9(b[9]),
        .B8(b[8]), .B7(b[7]), .B6(b[6]), .B5(b[5]), .B4(b[4]), .B3(b[3]), .B2(b[2]), .B1(b[1]), .B0(b[0]),
        .C17(1'b0), .C16(1'b0), .C15(1'b0), .C14(1'b0), .C13(1'b0), .C12(1'b0), .C11(1'b0), .C10(1'b0), .C9(1'b0),
        .C8(1'b0), .C7(1'b0), .C6(1'b0), .C5(1'b0), .C4(1'b0), .C3(1'b0), .C2(1'b0), .C1(1'b0), .C0(1'b0),
        .SIGNEDA(1'b1), .SIGNEDB(1'b1), .SOURCEA(1'b0), .SOURCEB(1'b0),
        .CLK0(clk), .CLK1(1'b0), .CLK2(1'b0), .CLK3(1'b0), .CE0(1'b1), .CE1(1'b0), .CE2(1'b0), .CE3(1'b0),
        .RST0(1'b0), .RST1(1'b0), .RST2(1'b0), .RST3(1'b0),
        .P35(p[35]), .P34(p[34]), .P33(p[33]), .P32(p[32]), .P31(p[31]), .P30(p[30]), .P29(p[29]), .P28(p[28]), .P27(p[27]),
        .P26(p[26]), .P25(p[25]), .P24(p[24]), .P23(p[23]), .P22(p[22]), .P21(p[21]), .P20(p[20]), .P19(p[19]), .P18(p[18]),
        .P17(p[17]), .P16(p[16]), .P15(p[15]), .P14(p[14]), .P13(p[13]), .P12(p[12]), .P11(p[11]), .P10(p[10]), .P9(p[9]),
        .P8(p[8]), .P7(p[7]), .P6(p[6]), .P5(p[5]), .P4(p[4]), .P3(p[3]), .P2(p[2]), .P1(p[1]), .P0(p[0]));
`else
    reg [17:0] ar, br;
    reg [35:0] pp, pr;
    always @(posedge clk) begin
        ar <= a; br <= b;
        pp <= $signed(ar) * $signed(br);
        pr <= pp;
    end
    assign p = pr;
`endif
endmodule

module acq_fft (
    input  wire        clk,
    input  wire        rst,
    input  wire        smp_stb,
    input  wire [31:0] smp_data,
    input  wire [31:0] smp_count,
    input  wire        bus_we,
    input  wire [14:0] bus_addr,
    input  wire [31:0] bus_wdata,
    output reg  [31:0] reg_q,            // регистры 0x60–0x86 (задержка 1 такт; иначе 0)
    output reg  [31:0] mem_q,            // окна 0x2000/0x4000 (задержка 3 такта)
    input  wire        snap_we,          // запись снимка в пул (только при простое)
    input  wire [12:0] snap_wa,
    input  wire [31:0] snap_wd,
    input  wire        inhibit,          // запрет пуска (снимок занят)
    output reg         busy,
    output reg         done              // строб: запуск завершён (или сбой расписания)
);
    localparam G = 7;
    localparam [1:0] KW = 2'd0, KC = 2'd1, KZ = 2'd2;     // вход этапа: W, ячейки C, Z
    localparam [1:0] KX = 2'd1, KA = 2'd2;                // выход: W, спектр X, накопители A
    integer gi;

    function [9:0] brev10;
        input [9:0] c;
        integer b;
        begin
            for (b = 0; b < 10; b = b + 1) brev10[9 - b] = c[b];
        end
    endfunction
    // таблица переноса: round(15·cos(2π(j + 0,5)/64))
    function [4:0] cs15;
        input [5:0] j;
        case (j)
            6'd0: cs15 = 5'd15; 6'd1: cs15 = 5'd15; 6'd2: cs15 = 5'd15; 6'd3: cs15 = 5'd14;
            6'd4: cs15 = 5'd14; 6'd5: cs15 = 5'd13; 6'd6: cs15 = 5'd12; 6'd7: cs15 = 5'd11;
            6'd8: cs15 = 5'd10; 6'd9: cs15 = 5'd9; 6'd10: cs15 = 5'd8; 6'd11: cs15 = 5'd6;
            6'd12: cs15 = 5'd5; 6'd13: cs15 = 5'd4; 6'd14: cs15 = 5'd2; 6'd15: cs15 = 5'd1;
            6'd16: cs15 = -5'd1; 6'd17: cs15 = -5'd2; 6'd18: cs15 = -5'd4; 6'd19: cs15 = -5'd5;
            6'd20: cs15 = -5'd6; 6'd21: cs15 = -5'd8; 6'd22: cs15 = -5'd9; 6'd23: cs15 = -5'd10;
            6'd24: cs15 = -5'd11; 6'd25: cs15 = -5'd12; 6'd26: cs15 = -5'd13; 6'd27: cs15 = -5'd14;
            6'd28: cs15 = -5'd14; 6'd29: cs15 = -5'd15; 6'd30: cs15 = -5'd15; 6'd31: cs15 = -5'd15;
            6'd32: cs15 = -5'd15; 6'd33: cs15 = -5'd15; 6'd34: cs15 = -5'd15; 6'd35: cs15 = -5'd14;
            6'd36: cs15 = -5'd14; 6'd37: cs15 = -5'd13; 6'd38: cs15 = -5'd12; 6'd39: cs15 = -5'd11;
            6'd40: cs15 = -5'd10; 6'd41: cs15 = -5'd9; 6'd42: cs15 = -5'd8; 6'd43: cs15 = -5'd6;
            6'd44: cs15 = -5'd5; 6'd45: cs15 = -5'd4; 6'd46: cs15 = -5'd2; 6'd47: cs15 = -5'd1;
            6'd48: cs15 = 5'd1; 6'd49: cs15 = 5'd2; 6'd50: cs15 = 5'd4; 6'd51: cs15 = 5'd5;
            6'd52: cs15 = 5'd6; 6'd53: cs15 = 5'd8; 6'd54: cs15 = 5'd9; 6'd55: cs15 = 5'd10;
            6'd56: cs15 = 5'd11; 6'd57: cs15 = 5'd12; 6'd58: cs15 = 5'd13; 6'd59: cs15 = 5'd14;
            6'd60: cs15 = 5'd14; 6'd61: cs15 = 5'd15; 6'd62: cs15 = 5'd15; default: cs15 = 5'd15;
        endcase
    endfunction
    // (s ? −1 : 1)·(m ? 3 : 1)·v — сдвигом и сложением (без умножителя)
    function [6:0] m3;
        input       s, m;
        input [4:0] v;
        reg   [6:0] e, t;
        begin
            e  = {{2{v[4]}}, v};
            t  = m ? e + {e[5:0], 1'b0} : e;
            m3 = s ? 7'd0 - t : t;
        end
    endfunction
    function [8:0] sat9s16;              // насыщение ±255
        input [15:0] r;
        sat9s16 = (!r[15] && r[14:8] != 7'd0) ? 9'h0FF :
                  (r[15] && (r[14:8] != 7'h7F || r[7:0] == 8'd0)) ? 9'h101 : r[8:0];
    endfunction
    // ячейка C: округление со сдвигом csh и насыщение ±255
    function [8:0] cq;
        input [14:0] a;
        input [1:0]  sh;
        reg   [15:0] e;
        begin
            e = {a[14], a};
            case (sh)
                2'd0:    e = e;
                2'd1:    begin e = e + 16'd1; e = {e[15], e[15:1]}; end
                2'd2:    begin e = e + 16'd2; e = {{2{e[15]}}, e[15:2]}; end
                default: begin e = e + 16'd4; e = {{3{e[15]}}, e[15:3]}; end
            endcase
            cq = sat9s16(e);
        end
    endfunction
    function [8:0] sat9;                 // 18 бит → ±255
        input [17:0] x;
        sat9 = (!x[17] && x[16:8] != 9'd0) ? 9'h0FF :
               (x[17] && (x[16:8] != 9'h1FF || x[7:0] == 8'd0)) ? 9'h101 : x[8:0];
    endfunction
    function [17:0] sat18;               // 19 бит → 18 бит
        input [18:0] v;
        sat18 = (v[18] == v[17]) ? v[17:0] : (v[18] ? 18'h20000 : 18'h1FFFF);
    endfunction
    function [17:0] bfo;                 // выход суммы/разности: ÷2 с округлением или насыщение
        input [18:0] v;
        input        s;
        reg   [18:0] h;
        begin
            h   = v + 19'd1;
            bfo = s ? h[18:1] : sat18(v);
        end
    endfunction
    function [17:0] rnd16;               // (p + 2^15) >> 16 с насыщением до 18 бит
        input [36:0] p;
        reg   [36:0] s;
        begin
            s     = p + 37'd32768;
            rnd16 = (s[36:33] == 4'h0 || s[36:33] == 4'hF) ? s[33:16] : (s[36] ? 18'h20000 : 18'h1FFFF);
        end
    endfunction
    function [35:0] c2w;                 // ячейка C {im9, re9} → {im18, re18}
        input [17:0] v;
        c2w = {{9{v[17]}}, v[17:9], {9{v[8]}}, v[8:0]};
    endfunction
    // мощность после сдвига: (x + 1) >> 1 для psh ≠ 0, насыщение 2^18 − 1
    function [17:0] pss;
        input [35:0] x;
        input        r;
        reg   [19:0] h;
        begin
            h = {1'b0, x[18:0]} + 20'd1;
            if (r) pss = (x[35:19] != 17'd0 || &x[18:0]) ? 18'h3FFFF : h[18:1];
            else   pss = (x[35:18] != 18'd0) ? 18'h3FFFF : x[17:0];
        end
    endfunction

    // ------------------------------------------------------------ регистры
    wire       rsel = (bus_addr[14:8] == 7'd0);
    wire       rwe  = bus_we && rsel;
    wire [7:0] ra   = bus_addr[7:0];

    reg [10:0]     ctrl_r;
    reg [31:0]     dphi, t_start, t_ref;
    reg [15:0]     kreg;
    reg [16:0]     ns, nper;
    reg [28:0]     scale;
    reg [2:0]      ng_r, ch_r;
    reg            ovr;
    reg [G*11-1:0] mreg_v, shcap_v, shp_v;
    reg [G*32-1:0] dsh_v, phi_v, sum_v;
    reg [G*29-1:0] peak_v;

    // чтение регистров
    wire [2:0] ri = ra[2:0];
    wire       rv = (ri != 3'd7);
    reg [15:0] proc_p;
    always @(posedge clk) begin
        reg_q <= 32'd0;
        if (rsel) case (ra[7:3])
            5'b01100: case (ri)
                3'd0:    reg_q <= {busy, ovr, 19'd0, ctrl_r};
                3'd1:    reg_q <= {16'd0, proc_p};
                3'd2:    reg_q <= dphi;
                3'd3:    reg_q <= {16'd0, kreg};
                3'd4:    reg_q <= {15'd0, ns};
                3'd5:    reg_q <= {15'd0, nper};
                3'd6:    reg_q <= {3'd0, scale};
                default: reg_q <= t_start;
            endcase
            5'b01101: reg_q <= rv ? {21'd0, mreg_v[11*ri +: 11]} : t_ref;
            5'b01110: if (rv) reg_q <= dsh_v[32*ri +: 32];
            5'b01111: if (rv) reg_q <= {3'd0, peak_v[29*ri +: 29]};
            5'b10000: if (rv) reg_q <= sum_v[32*ri +: 32];
            default: ;
        endcase
    end

    // проверка расписания при пуске
    wire [2:0]  ng_w = (bus_wdata[6:4] == 3'd0) ? 3'd1 : bus_wdata[6:4];
    reg  [16:0] pclk;
    always @* case (ng_w)
        3'd1:    pclk = 17'd22944;
        3'd2:    pclk = 17'd34384;
        3'd3:    pclk = 17'd45824;
        3'd4:    pclk = 17'd57264;
        3'd5:    pclk = 17'd68704;
        3'd6:    pclk = 17'd80144;
        default: pclk = 17'd91584;
    endcase
    wire sovr = (ns < 17'd2048) || ({1'b0, nper} < {1'b0, ns} + 18'd300) ||
                ({nper, 2'b00} < {2'b00, pclk});

    // ------------------------------------------------------------ захват периода
    // такт 0 — входной регистр отсчёта и сравнения счётчика с T_next / T; такт 1 — решение go и
    // шаг периода (варианты «начало периода» и «продолжение» считаются от регистров заранее)
    reg        s_v, s_eqn, s_eqs;
    reg [3:0]  s_x;
    reg [31:0] s_cnt;
    reg        rec, fb, cap_nz, cap_end, g1, g1z;
    reg [16:0] cap_p, ci, ns1;
    reg [31:0] t_next, ph;
    reg [17:0] cr;
    reg [18:0] nsm;
    reg [10:0] ck;
    reg [31:0] pe;
    wire [16:0] keff17 = (kreg == 16'd0) ? 17'h10000 : {1'b0, kreg};
    always @(posedge clk) begin
        s_v   <= smp_stb && busy;
        s_x   <= smp_data[4*ch_r +: 4];
        s_cnt <= smp_count;
        s_eqn <= (smp_count == t_next);
        s_eqs <= (smp_count == t_start);
        nsm   <= 19'd2048 - {2'd0, ns};                  // 2048 − Ns
        ns1   <= ns - 17'd1;
    end
    wire go  = busy && s_v && !rec && !cap_end && (cap_nz ? s_eqn : (!ctrl_r[1] || s_eqs));
    wire act = busy && s_v && (rec || go);
    // начало периода (ячейка 0, остаток 2048)
    wire        cl_g = ({1'b0, ns} <= 18'd2048);
    wire [17:0] cr_g = cl_g ? nsm[17:0] : 18'd2048;
    wire        ls_g = (ns == 17'd1);
    // продолжение: остаток cr + 2048 − Ns (знак — переход в следующую ячейку)
    wire [31:0] ph_a = ph + dphi;
    wire [17:0] cr_a = cr + 18'd2048;
    wire [18:0] cr_b = {1'b0, cr} + nsm;
    wire        cl_r = !cr_b[18];
    wire        ls_r = (ci == ns1);
    wire        cl_s = go ? cl_g : cl_r;
    wire        ls_s = go ? ls_g : ls_r;

    // ------------------------------------------------------------ управление машиной БПФ
    reg        eng, tail, first_p, last_p, proc_req;
    reg [3:0]  tcnt, st;
    reg [2:0]  pass, g_r;                        // g_r = pass − 1 (7 — проход спектра копии)
    reg [10:0] m_r, sh_r;                        // M_g и сдвиг кода прохода (защёлкнуты при смене прохода)
    reg [10:0] cc;
    wire stop_w = rwe && ra == 8'h60 && bus_wdata[2];
    wire dyn    = proc_req && busy && eng;           // период готов, а предыдущий не обработан
    wire kill   = rst || stop_w || dyn;

    always @(posedge clk) begin
        done <= 1'b0;
        if (rst) begin
            busy <= 1'b0; ovr <= 1'b0; rec <= 1'b0; eng <= 1'b0; tail <= 1'b0;
            ctrl_r <= 11'd0; ng_r <= 3'd1; ch_r <= 3'd0; dphi <= 32'd0; kreg <= 16'd0; ns <= 17'd0;
            nper <= 17'd0; scale <= 29'd0; t_start <= 32'd0; t_ref <= 32'd0;
            mreg_v <= 0; dsh_v <= 0; phi_v <= 0; shcap_v <= 0; shp_v <= 0;
            cap_p <= 17'd0; cap_nz <= 1'b0; cap_end <= 1'b0; proc_p <= 16'd0; t_next <= 32'd0;
        end else begin
            if (rwe) case (ra)
                8'h62: dphi    <= bus_wdata;
                8'h63: kreg    <= bus_wdata[15:0];
                8'h64: ns      <= bus_wdata[16:0];
                8'h65: nper    <= bus_wdata[16:0];
                8'h66: scale   <= bus_wdata[28:0];
                8'h67: t_start <= bus_wdata;
                default: ;
            endcase
            for (gi = 0; gi < G; gi = gi + 1) begin
                if (rwe && ra == 8'h68 + gi) mreg_v[11*gi +: 11] <= bus_wdata[10:0];
                if (rwe && ra == 8'h70 + gi) dsh_v[32*gi +: 32]  <= bus_wdata;
            end
            // захват
            if (act) begin
                ph  <= go ? dphi : ph_a;
                cr  <= go ? cr_g : (cl_r ? cr_b[17:0] : cr_a);
                ck  <= go ? {10'd0, cl_g} : (cl_r ? ck + 11'd1 : ck);
                ci  <= go ? 17'd1 : ci + 17'd1;
                fb  <= cl_s;
                rec <= !ls_s;
            end
            g1 <= go; g1z <= !cap_nz;
            if (go) begin
                cap_p   <= cap_p + 17'd1;
                cap_nz  <= 1'b1;
                cap_end <= (cap_p + 17'd1 == keff17);
                t_next  <= s_cnt + {15'd0, nper};
                if (!cap_nz) t_ref <= s_cnt;
            end
            // сдвиги кода гипотез — тактом позже (нужны только к обработке периода)
            if (g1) for (gi = 0; gi < G; gi = gi + 1) begin
                pe = g1z ? 32'd0 : phi_v[32*gi +: 32];
                shcap_v[11*gi +: 11] <= pe[31:21] + {10'd0, pe[20]};
                phi_v[32*gi +: 32]   <= pe + dsh_v[32*gi +: 32];
            end
            // машина БПФ: ng + 1 проходов по 11 этапов по 1040 тактов, затем 16 тактов выбега
            if (proc_req && busy) begin
                if (eng) begin
                    ovr <= 1'b1; busy <= 1'b0; rec <= 1'b0; eng <= 1'b0; tail <= 1'b0; done <= 1'b1;
                end else begin
                    eng <= 1'b1; tail <= 1'b0; pass <= 3'd0; st <= 4'd0; cc <= 11'd0;
                    g_r <= 3'd7; m_r <= 11'd0; sh_r <= 11'd0;
                    first_p <= (proc_p == 16'd0);
                    last_p  <= (proc_p == kreg - 16'd1);
                    shp_v   <= shcap_v;
                end
            end else if (eng) begin
                if (tail) begin
                    tcnt <= tcnt + 4'd1;
                    if (tcnt == 4'd15) begin
                        eng <= 1'b0; tail <= 1'b0; proc_p <= proc_p + 16'd1;
                        if (last_p) begin busy <= 1'b0; done <= 1'b1; end
                    end
                end else if (cc == 11'd1039) begin
                    cc <= 11'd0;
                    if (st == 4'd10) begin
                        st <= 4'd0;
                        if (pass == ng_r) begin tail <= 1'b1; tcnt <= 4'd0; end
                        else begin
                            pass <= pass + 3'd1; g_r <= pass;
                            m_r  <= mreg_v[11*pass +: 11]; sh_r <= shp_v[11*pass +: 11];
                        end
                    end else st <= st + 4'd1;
                end else cc <= cc + 11'd1;
            end
            // пуск и останов
            if (rwe && ra == 8'h60) begin
                if (bus_wdata[2]) begin
                    busy <= 1'b0; rec <= 1'b0; eng <= 1'b0; tail <= 1'b0;
                end else if (bus_wdata[0] && !busy && !inhibit) begin
                    ctrl_r <= bus_wdata[10:0] & 11'h772;
                    ng_r   <= ng_w;
                    ch_r   <= bus_wdata[10:8];
                    rec    <= 1'b0; cap_p <= 17'd0; cap_nz <= 1'b0; cap_end <= 1'b0; proc_p <= 16'd0;
                    ovr    <= sovr; busy <= !sovr;
                end
            end
        end
    end

    // ------------------------------------------------------------ конвейер захвата (7 тактов с входным регистром)
    reg        q1v, q1f, q1c, q1l, q2v, q2f, q2c, q2l, q3v, q3f, q3c, q3l, q4v, q4f, q4c, q4l;
    reg        q5v, q5c, q5l, cw_we;
    reg [3:0]  q1x, q2x;
    reg [5:0]  q1j;
    reg [4:0]  q2cv, q2sv;
    reg [10:0] q1k, q2k, q3k, q4k, q5k, cw_k;
    reg [6:0]  q3ic, q3qs, q3qc, q3is;
    reg [7:0]  q4re, q4im;
    reg [14:0] acc_r, acc_i;
    reg [17:0] cw_d;
    always @(posedge clk) begin
        q1v <= act && !kill;
        q1x <= s_x; q1j <= go ? 6'd0 : ph[31:26];
        q1f <= go | fb; q1c <= cl_s; q1k <= go ? 11'd0 : ck; q1l <= ls_s;
        q2v <= q1v && !kill; q2f <= q1f; q2c <= q1c; q2k <= q1k; q2l <= q1l; q2x <= q1x;
        q2cv <= cs15(q1j); q2sv <= cs15(q1j - 6'd16);
        q3v <= q2v && !kill; q3f <= q2f; q3c <= q2c; q3k <= q2k; q3l <= q2l;
        q3ic <= m3(q2x[3], q2x[2], q2cv);           // xi·c
        q3qs <= m3(q2x[1], q2x[0], q2sv);           // xq·s
        q3qc <= m3(q2x[1], q2x[0], q2cv);           // xq·c
        q3is <= m3(q2x[3], q2x[2], q2sv);           // xi·s
        q4v <= q3v && !kill; q4f <= q3f; q4c <= q3c; q4k <= q3k; q4l <= q3l;
        q4re <= {q3ic[6], q3ic} + {q3qs[6], q3qs};
        q4im <= {q3qc[6], q3qc} - {q3is[6], q3is};
        q5v <= q4v && !kill; q5c <= q4c; q5k <= q4k; q5l <= q4l;
        if (q4v) begin
            acc_r <= (q4f ? 15'd0 : acc_r) + {{7{q4re[7]}}, q4re};
            acc_i <= (q4f ? 15'd0 : acc_i) + {{7{q4im[7]}}, q4im};
        end
        cw_we    <= q5v && q5c && !kill;
        cw_k     <= q5k;
        cw_d     <= {cq(acc_i, scale[28:27]), cq(acc_r, scale[28:27])};
        proc_req <= q5v && q5l && !kill;
    end

    // ------------------------------------------------------------ выдача бабочки (такт 0)
    wire        iv   = eng && !tail && !cc[10];
    wire [9:0]  c0   = cc[9:0];
    wire [9:0]  lowm = 10'h3FF >> st;                 // D − 1
    wire [9:0]  dh   = 10'h200 >> st;                 // D[10:1]
    wire [10:0] aa   = {c0 & ~lowm, 1'b0} | {1'b0, c0 & lowm};
    wire        par  = ^c0;                           // банк элемента a
    wire [9:0]  ah   = aa[10:1];
    wire [9:0]  bh   = ah | dh;
    wire [9:0]  tw   = c0 << st;
    wire [2:0]  g0   = g_r;
    wire [10:0] u    = {1'b0, c0} + m_r;
    wire [9:0]  nb   = brev10(c0);
    wire [10:0] idx  = {1'b0, nb} + sh_r;
    wire [1:0]  kin  = (st != 4'd0) ? KW : (pass == 3'd0) ? KC : KZ;
    wire [1:0]  kout = (st != 4'd10) ? KW : (pass == 3'd0) ? KX : KA;
    wire        sc   = (pass == 3'd0) ? scale[st] : scale[5'd11 + {1'b0, st}];
    // признаки элемента, сопровождающие его по конвейеру
    localparam TW = 83;
    wire [TW-1:0] tg0 = {tw, (c0 == 10'd1023), (c0 == 10'd0), g0, idx, nb, c0, u[10], u[9:0],
                         par ? ah : bh, par ? bh : ah, par, sc, kout, kin};
    // (такты конвейера: 1 — адреса W, X, R; 5 — адрес поворота; 13 — запись W/X; 17 — чтение A_g;
    //  21 — запись A_g; 23 — итог; умножители — 3 такта, регистры внутри DSP)
    reg  [TW*23-1:0] tg;
    reg  [23:1]      vv;
    always @(posedge clk) begin
        tg <= {tg[TW*22-1:0], tg0};
        vv <= kill ? 23'd0 : {vv[22:1], iv};
    end
`define TG(k) tg[TW*((k)-1) +: TW]
    wire [TW-1:0] t1 = `TG(1), t2 = `TG(2), t5 = `TG(5), t6 = `TG(6), t7 = `TG(7), t13 = `TG(13);
    wire [TW-1:0] t17 = `TG(17), t19 = `TG(19), t21 = `TG(21), t22 = `TG(22), t23 = `TG(23);
`undef TG
    // поля: [1:0] kin, [3:2] kout, [4] sc, [5] pa, [15:6] w0a, [25:16] w1a, [35:26] u[9:0], [36] u[10],
    //       [46:37] c, [56:47] nb, [67:57] idx, [70:68] g, [71] fe, [72] le, [82:73] t

    // ------------------------------------------------------------ память
    wire [35:0] wq0, wq1;
    wire [17:0] xql, xqh, rql, rqh;
    wire [16:0] tq0, tq1;
    reg         wwe, xwe;
    reg  [9:0]  wwa0, wwa1, xwa;
    reg  [35:0] wwd0, wwd1;
    reg  [17:0] xdl, xdh;
    acq_ram #(.W(36)) u_w0 (.clk(clk), .we(wwe), .wa(wwa0), .wd(wwd0), .ra(t1[15:6]),  .rd(wq0));
    acq_ram #(.W(36)) u_w1 (.clk(clk), .we(wwe), .wa(wwa1), .wd(wwd1), .ra(t1[25:16]), .rd(wq1));
    acq_ram #(.W(18)) u_xl (.clk(clk), .we(xwe), .wa(xwa), .wd(xdl), .ra(t1[35:26]), .rd(xql));
    acq_ram #(.W(18)) u_xh (.clk(clk), .we(xwe), .wa(xwa), .wd(xdh), .ra(t1[35:26]), .rd(xqh));
    wire r_we = bus_we && (bus_addr[14:11] == 4'b1000);
    acq_ram #(.W(18)) u_rl (.clk(clk), .we(r_we && !bus_addr[10]), .wa(bus_addr[9:0]),
                            .wd(bus_wdata[17:0]), .ra(t1[46:37]), .rd(rql));
    acq_ram #(.W(18)) u_rh (.clk(clk), .we(r_we && bus_addr[10]), .wa(bus_addr[9:0]),
                            .wd(bus_wdata[17:0]), .ra(t1[46:37]), .rd(rqh));
    wire [9:0] tt5  = t5[82:73];
    wire       tt5h = (tt5 > 10'd512);
    reg        tt6h;
    always @(posedge clk) tt6h <= tt5h;
    acq_twrom u_tw (.clk(clk), .a0(tt5h ? 10'd0 - tt5 : tt5), .a1(tt5h ? tt5 - 10'd512 : 10'd512 - tt5),
                    .q0(tq0), .q1(tq1));

    // общий пул (выходы — через регистр pqr: чтение A_g — по t17, ячеек C — по t0, шиной — на 1 такт
    // раньше выдачи)
    wire        va21 = vv[21] && (t21[3:2] == KA);
    reg  [17:0] nva21, nvb21;
    wire [18*16-1:0] pqv;
    reg  [18*16-1:0] pqr;
    always @(posedge clk) pqr <= pqv;
    genvar pi;
    generate for (pi = 0; pi < 16; pi = pi + 1) begin : g_pool
        wire        p_we, s_we;
        wire [9:0]  p_wa, p_ra;
        wire [17:0] p_wd;
        assign s_we = snap_we && (snap_wa[12:10] == pi / 2);
        if (pi < 14) begin : g_a
            assign p_we = busy ? (va21 && t21[70:68] == pi / 2) : s_we;
            assign p_wa = busy ? t21[66:57] : snap_wa[9:0];
            assign p_wd = busy ? ((((pi % 2) == 1) ^ t21[67]) ? nvb21 : nva21)
                               : {2'b00, (pi % 2) ? snap_wd[31:16] : snap_wd[15:0]};
            assign p_ra = busy ? t17[66:57] : bus_addr[9:0];
        end else begin : g_c
            assign p_we = busy ? (cw_we && cw_k[10] == (pi - 14)) : s_we;
            assign p_wa = busy ? cw_k[9:0] : snap_wa[9:0];
            assign p_wd = busy ? cw_d : {2'b00, (pi % 2) ? snap_wd[31:16] : snap_wd[15:0]};
            assign p_ra = busy ? c0 : bus_addr[9:0];
        end
        acq_ram #(.W(18)) u_p (.clk(clk), .we(p_we), .wa(p_wa), .wd(p_wd), .ra(p_ra),
                               .rd(pqv[18*pi +: 18]));
    end endgenerate

    // чтение шиной: пул (0x4000) или снимок (0x2000, пара пулов)
    reg [4:0] ma1, ma2;
    always @(posedge clk) begin
        ma1   <= bus_addr[14:10]; ma2 <= ma1;
        mem_q <= ma2[4] ? {14'd0, pqr[18*ma2[3:0] +: 18]}
                        : {pqr[18*{ma2[2:0], 1'b1} +: 16], pqr[18*{ma2[2:0], 1'b0} +: 16]};
    end

    // ------------------------------------------------------------ тракт бабочки
    reg  [35:0] a3, b3, a4, b4, a5, b5, a6, b6, a7, b7;
    reg  [17:0] xa3, xb3, ra3, rb3;
    reg  [16:0] tq7;
    reg         ng7;
    reg  [17:0] ss7, cs8, ss8;
    reg  [17:0] sr8, si8, dr8, di8, sr9, si9, sr10, si10, sr11, si11, sr12, si12;
    reg  [17:0] ar13, ai13, br13, bi13;
    reg  [36:0] pr12, pi12;
    // 4–6: произведения Z = conj(X)·R; 9–11: поворот разности (регистры — внутри блоков DSP)
    function [17:0] sx9(input [8:0] v); sx9 = {{9{v[8]}}, v}; endfunction
    wire [35:0] za1, za2, za3, za4, zb1, zb2, zb3, zb4, mp1, mp2, mp3, mp4;
    acq_mul u_za1 (.clk(clk), .a(sx9(xa3[8:0])),  .b(sx9(ra3[8:0])),  .p(za1));
    acq_mul u_za2 (.clk(clk), .a(sx9(xa3[17:9])), .b(sx9(ra3[17:9])), .p(za2));
    acq_mul u_za3 (.clk(clk), .a(sx9(xa3[8:0])),  .b(sx9(ra3[17:9])), .p(za3));
    acq_mul u_za4 (.clk(clk), .a(sx9(xa3[17:9])), .b(sx9(ra3[8:0])),  .p(za4));
    acq_mul u_zb1 (.clk(clk), .a(sx9(xb3[8:0])),  .b(sx9(rb3[8:0])),  .p(zb1));
    acq_mul u_zb2 (.clk(clk), .a(sx9(xb3[17:9])), .b(sx9(rb3[17:9])), .p(zb2));
    acq_mul u_zb3 (.clk(clk), .a(sx9(xb3[8:0])),  .b(sx9(rb3[17:9])), .p(zb3));
    acq_mul u_zb4 (.clk(clk), .a(sx9(xb3[17:9])), .b(sx9(rb3[8:0])),  .p(zb4));
    acq_mul u_mp1 (.clk(clk), .a(dr8), .b(cs8), .p(mp1));
    acq_mul u_mp2 (.clk(clk), .a(di8), .b(ss8), .p(mp2));
    acq_mul u_mp3 (.clk(clk), .a(di8), .b(cs8), .p(mp3));
    acq_mul u_mp4 (.clk(clk), .a(dr8), .b(ss8), .p(mp4));
    wire [17:0] zc1 = za1[17:0], zc2 = za2[17:0], zc3 = za3[17:0], zc4 = za4[17:0];
    wire [17:0] zd1 = zb1[17:0], zd2 = zb2[17:0], zd3 = zb3[17:0], zd4 = zb4[17:0];
    wire [17:0] pq14 = pqr[18*14 +: 18], pq15 = pqr[18*15 +: 18];
    wire [18:0] s_r = {a7[17], a7[17:0]}  + {b7[17], b7[17:0]};
    wire [18:0] s_i = {a7[35], a7[35:18]} + {b7[35], b7[35:18]};
    wire [18:0] d_r = {a7[17], a7[17:0]}  - {b7[17], b7[17:0]};
    wire [18:0] d_i = {a7[35], a7[35:18]} - {b7[35], b7[35:18]};
    always @(posedge clk) begin
        // 3: данные памяти (W — по банкам, ячейки C, X — по u[10], R)
        a3  <= (t2[1:0] == KC) ? c2w(pq14) : (t2[5] ? wq1 : wq0);
        b3  <= (t2[1:0] == KC) ? c2w(pq15) : (t2[5] ? wq0 : wq1);
        xa3 <= t2[36] ? xqh : xql;
        xb3 <= t2[36] ? xql : xqh;
        ra3 <= rql; rb3 <= rqh;
        // 4–6: задержка входов бабочки на время умножения
        a4 <= a3; b4 <= b3; a5 <= a4; b5 <= b4; a6 <= a5; b6 <= b5;
        // 7: вход бабочки
        a7 <= (t6[1:0] == KZ) ? {zc3 - zc4, zc1 + zc2} : a6;
        b7 <= (t6[1:0] == KZ) ? {zd3 - zd4, zd1 + zd2} : b6;
        // поворот: адрес таблицы — по t5, знак косинуса — тактом позже
        tq7 <= tq0; ng7 <= tt6h; ss7 <= {1'b0, tq1};
        cs8 <= ng7 ? 18'd0 - {1'b0, tq7} : {1'b0, tq7}; ss8 <= ss7;
        // 8: сумма и разность
        sr8 <= bfo(s_r, t7[4]); si8 <= bfo(s_i, t7[4]);
        dr8 <= bfo(d_r, t7[4]); di8 <= bfo(d_i, t7[4]);
        // 9–13: поворот разности (произведения — с 9-го по 11-й такт), сумма — с задержкой
        sr9 <= sr8; si9 <= si8; sr10 <= sr9; si10 <= si9; sr11 <= sr10; si11 <= si10;
        pr12 <= {mp1[35], mp1} + {mp2[35], mp2};
        pi12 <= {mp3[35], mp3} - {mp4[35], mp4};
        sr12 <= sr11; si12 <= si11;
        br13 <= rnd16(pr12); bi13 <= rnd16(pi12);
        ar13 <= sr12; ai13 <= si12;
        // 14: запись W или X
        wwe  <= vv[13] && (t13[3:2] == KW) && !kill;
        wwa0 <= t13[15:6]; wwa1 <= t13[25:16];
        wwd0 <= t13[5] ? {bi13, br13} : {ai13, ar13};
        wwd1 <= t13[5] ? {ai13, ar13} : {bi13, br13};
        xwe  <= vv[13] && (t13[3:2] == KX) && !kill;
        xwa  <= t13[56:47];
        xdl  <= {sat9(ai13), sat9(ar13)};
        xdh  <= {sat9(bi13), sat9(br13)};
    end

    // ------------------------------------------------------------ мощность и накопление
    // 14–16: квадраты (регистры — внутри блоков DSP)
    wire [35:0] qcar, qcai, qcbr, qcbi;
    acq_mul u_qar (.clk(clk), .a(ar13), .b(ar13), .p(qcar));
    acq_mul u_qai (.clk(clk), .a(ai13), .b(ai13), .p(qcai));
    acq_mul u_qbr (.clk(clk), .a(br13), .b(br13), .p(qcbr));
    acq_mul u_qbi (.clk(clk), .a(bi13), .b(bi13), .p(qcbi));
    reg  [35:0] pwa17, pwb17, pwa18, pwb18, pwa19, pwb19;
    reg  [17:0] psa20, psb20, oa20, ob20, pv22, best;
    reg  [10:0] pidx22, bk;
    reg  [18:0] psum22;
    reg  [31:0] sm;
    wire [4:0]  psh   = scale[26:22];
    wire [4:0]  shamt = (psh != 5'd0) ? psh - 5'd1 : 5'd0;
    wire [17:0] pe19  = pqr[18*{t19[70:68], 1'b0} +: 18], po19 = pqr[18*{t19[70:68], 1'b1} +: 18];
    wire [18:0] sa20  = {1'b0, oa20} + {1'b0, psa20}, sb20 = {1'b0, ob20} + {1'b0, psb20};
    always @(posedge clk) begin
        // 17–20: мощность, сдвиг, насыщение; A_g из пула
        pwa17 <= qcar + qcai; pwb17 <= qcbr + qcbi;
        pwa18 <= pwa17 >> {shamt[4:3], 3'b000}; pwb18 <= pwb17 >> {shamt[4:3], 3'b000};
        pwa19 <= pwa18 >> shamt[2:0];           pwb19 <= pwb18 >> shamt[2:0];
        psa20 <= pss(pwa19, psh != 5'd0);       psb20 <= pss(pwb19, psh != 5'd0);
        oa20  <= t19[67] ? po19 : pe19;         ob20  <= t19[67] ? pe19 : po19;
        // 21: накопление (запись в пул — по t21)
        nva21 <= first_p ? psa20 : (sa20[18] ? 18'h3FFFF : sa20[17:0]);
        nvb21 <= first_p ? psb20 : (sb20[18] ? 18'h3FFFF : sb20[17:0]);
        // 22: пара (порядок h = 0, затем h = 1 — строгий максимум)
        pv22   <= (nvb21 > nva21) ? nvb21 : nva21;
        pidx22 <= (nvb21 > nva21) ? {~t21[67], t21[66:57]} : t21[67:57];
        psum22 <= {1'b0, nva21} + {1'b0, nvb21};
        // 23: максимум и сумма по проходу
        if (vv[22] && t22[3:2] == KA) begin
            if (t22[71]) begin
                best <= pv22; bk <= (pv22 != 18'd0) ? pidx22 : 11'd0; sm <= {13'd0, psum22};
            end else begin
                if (pv22 > best) begin best <= pv22; bk <= pidx22; end
                sm <= sm + {13'd0, psum22};
            end
        end
        // 24: итог последнего периода
        if (rst) begin
            peak_v <= 0; sum_v <= 0;
        end else if (vv[23] && t23[3:2] == KA && t23[72] && last_p) begin
            peak_v[29*t23[70:68] +: 29] <= {bk, best};
            sum_v[32*t23[70:68] +: 32]  <= sm;
        end
    end
endmodule
`default_nettype wire
