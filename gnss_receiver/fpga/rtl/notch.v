// =============================================================================
// МГП-8. Цифровой режекторный фильтр (компенсатор гармонических помех) по 8 ВЧ-каналам.
// Битово-точная спецификация — fpga/model/notch_model.py (класс Notch, функция run).
//
// Для включённого канала k: x·e^{−jφ} -> оценка помехи B (экспоненциальное сглаживание с
// коэффициентом 2^−μ) -> вычитание B·e^{jφ} из x -> повторное 2-битное квантование с АРУ порога.
// Выключенный канал передаётся без изменений (с той же задержкой).
//
// Отсчёт приходит раз в 4 такта (smp_stb); две дорожки обрабатывают по 4 канала:
// дорожка L в такте p (0..3) после строба — канал 4L + p. Конвейер: A — фаза NCO, B — таблица
// cos/sin (EBR), C — перенос на нулевую частоту, D1/D2 — обновление B, E — умножители (DSP),
// F1/F2 — вычитание оценки (и дизеринг: x·127²·2^7 + d·2^7 − ŝ), G0 — модуль, G1 — квантование, G2 — АРУ. Выход (out_stb) — через 15
// тактов после smp_stb (номер отсчёта сопровождает данные: out_count).
// Состояние канала (φ, B, T, счётчик АРУ) удерживается в начальном значении, пока канал выключен.
// Запись NOTCH_EN (en_wr) вступает в силу с первого отсчёта после неё: маски en/dith фиксируются,
// окно АРУ и генераторы дизеринга начинаются заново (модель начинает с этого отсчёта; его номер —
// cfg_n).
// =============================================================================
`default_nettype none

module notch (
    input  wire         clk,
    input  wire         rst,
    input  wire         smp_stb,
    input  wire [31:0]  smp_data,
    input  wire [31:0]  smp_count,
    input  wire [7:0]   en,               // NOTCH_EN[7:0]
    input  wire [7:0]   dith,             // NOTCH_EN[23:16]: дизеринг перед повторным квантованием
    input  wire         en_wr,            // строб записи NOTCH_EN
    input  wire [31:0]  mu,               // 4 бита на канал
    input  wire [255:0] dphi,             // 32 бита на канал
    output reg          out_stb,
    output reg  [31:0]  out_data,
    output reg  [31:0]  out_count
);
    // ------------------------------------------------------------ таблица cos/sin (127·)
    reg [15:0] rom [0:255];
    initial begin
        rom[0] = 16'h7F02;
        rom[1] = 16'h7F05;
        rom[2] = 16'h7F08;
        rom[3] = 16'h7F0B;
        rom[4] = 16'h7E0E;
        rom[5] = 16'h7E11;
        rom[6] = 16'h7D14;
        rom[7] = 16'h7D17;
        rom[8] = 16'h7C1A;
        rom[9] = 16'h7C1D;
        rom[10] = 16'h7B20;
        rom[11] = 16'h7A23;
        rom[12] = 16'h7926;
        rom[13] = 16'h7829;
        rom[14] = 16'h772C;
        rom[15] = 16'h762F;
        rom[16] = 16'h7532;
        rom[17] = 16'h7335;
        rom[18] = 16'h7238;
        rom[19] = 16'h713A;
        rom[20] = 16'h6F3D;
        rom[21] = 16'h6E40;
        rom[22] = 16'h6C43;
        rom[23] = 16'h6A45;
        rom[24] = 16'h6948;
        rom[25] = 16'h674A;
        rom[26] = 16'h654D;
        rom[27] = 16'h634F;
        rom[28] = 16'h6152;
        rom[29] = 16'h5F54;
        rom[30] = 16'h5D56;
        rom[31] = 16'h5B59;
        rom[32] = 16'h595B;
        rom[33] = 16'h565D;
        rom[34] = 16'h545F;
        rom[35] = 16'h5261;
        rom[36] = 16'h4F63;
        rom[37] = 16'h4D65;
        rom[38] = 16'h4A67;
        rom[39] = 16'h4869;
        rom[40] = 16'h456A;
        rom[41] = 16'h436C;
        rom[42] = 16'h406E;
        rom[43] = 16'h3D6F;
        rom[44] = 16'h3A71;
        rom[45] = 16'h3872;
        rom[46] = 16'h3573;
        rom[47] = 16'h3275;
        rom[48] = 16'h2F76;
        rom[49] = 16'h2C77;
        rom[50] = 16'h2978;
        rom[51] = 16'h2679;
        rom[52] = 16'h237A;
        rom[53] = 16'h207B;
        rom[54] = 16'h1D7C;
        rom[55] = 16'h1A7C;
        rom[56] = 16'h177D;
        rom[57] = 16'h147D;
        rom[58] = 16'h117E;
        rom[59] = 16'h0E7E;
        rom[60] = 16'h0B7F;
        rom[61] = 16'h087F;
        rom[62] = 16'h057F;
        rom[63] = 16'h027F;
        rom[64] = 16'hFE7F;
        rom[65] = 16'hFB7F;
        rom[66] = 16'hF87F;
        rom[67] = 16'hF57F;
        rom[68] = 16'hF27E;
        rom[69] = 16'hEF7E;
        rom[70] = 16'hEC7D;
        rom[71] = 16'hE97D;
        rom[72] = 16'hE67C;
        rom[73] = 16'hE37C;
        rom[74] = 16'hE07B;
        rom[75] = 16'hDD7A;
        rom[76] = 16'hDA79;
        rom[77] = 16'hD778;
        rom[78] = 16'hD477;
        rom[79] = 16'hD176;
        rom[80] = 16'hCE75;
        rom[81] = 16'hCB73;
        rom[82] = 16'hC872;
        rom[83] = 16'hC671;
        rom[84] = 16'hC36F;
        rom[85] = 16'hC06E;
        rom[86] = 16'hBD6C;
        rom[87] = 16'hBB6A;
        rom[88] = 16'hB869;
        rom[89] = 16'hB667;
        rom[90] = 16'hB365;
        rom[91] = 16'hB163;
        rom[92] = 16'hAE61;
        rom[93] = 16'hAC5F;
        rom[94] = 16'hAA5D;
        rom[95] = 16'hA75B;
        rom[96] = 16'hA559;
        rom[97] = 16'hA356;
        rom[98] = 16'hA154;
        rom[99] = 16'h9F52;
        rom[100] = 16'h9D4F;
        rom[101] = 16'h9B4D;
        rom[102] = 16'h994A;
        rom[103] = 16'h9748;
        rom[104] = 16'h9645;
        rom[105] = 16'h9443;
        rom[106] = 16'h9240;
        rom[107] = 16'h913D;
        rom[108] = 16'h8F3A;
        rom[109] = 16'h8E38;
        rom[110] = 16'h8D35;
        rom[111] = 16'h8B32;
        rom[112] = 16'h8A2F;
        rom[113] = 16'h892C;
        rom[114] = 16'h8829;
        rom[115] = 16'h8726;
        rom[116] = 16'h8623;
        rom[117] = 16'h8520;
        rom[118] = 16'h841D;
        rom[119] = 16'h841A;
        rom[120] = 16'h8317;
        rom[121] = 16'h8314;
        rom[122] = 16'h8211;
        rom[123] = 16'h820E;
        rom[124] = 16'h810B;
        rom[125] = 16'h8108;
        rom[126] = 16'h8105;
        rom[127] = 16'h8102;
        rom[128] = 16'h81FE;
        rom[129] = 16'h81FB;
        rom[130] = 16'h81F8;
        rom[131] = 16'h81F5;
        rom[132] = 16'h82F2;
        rom[133] = 16'h82EF;
        rom[134] = 16'h83EC;
        rom[135] = 16'h83E9;
        rom[136] = 16'h84E6;
        rom[137] = 16'h84E3;
        rom[138] = 16'h85E0;
        rom[139] = 16'h86DD;
        rom[140] = 16'h87DA;
        rom[141] = 16'h88D7;
        rom[142] = 16'h89D4;
        rom[143] = 16'h8AD1;
        rom[144] = 16'h8BCE;
        rom[145] = 16'h8DCB;
        rom[146] = 16'h8EC8;
        rom[147] = 16'h8FC6;
        rom[148] = 16'h91C3;
        rom[149] = 16'h92C0;
        rom[150] = 16'h94BD;
        rom[151] = 16'h96BB;
        rom[152] = 16'h97B8;
        rom[153] = 16'h99B6;
        rom[154] = 16'h9BB3;
        rom[155] = 16'h9DB1;
        rom[156] = 16'h9FAE;
        rom[157] = 16'hA1AC;
        rom[158] = 16'hA3AA;
        rom[159] = 16'hA5A7;
        rom[160] = 16'hA7A5;
        rom[161] = 16'hAAA3;
        rom[162] = 16'hACA1;
        rom[163] = 16'hAE9F;
        rom[164] = 16'hB19D;
        rom[165] = 16'hB39B;
        rom[166] = 16'hB699;
        rom[167] = 16'hB897;
        rom[168] = 16'hBB96;
        rom[169] = 16'hBD94;
        rom[170] = 16'hC092;
        rom[171] = 16'hC391;
        rom[172] = 16'hC68F;
        rom[173] = 16'hC88E;
        rom[174] = 16'hCB8D;
        rom[175] = 16'hCE8B;
        rom[176] = 16'hD18A;
        rom[177] = 16'hD489;
        rom[178] = 16'hD788;
        rom[179] = 16'hDA87;
        rom[180] = 16'hDD86;
        rom[181] = 16'hE085;
        rom[182] = 16'hE384;
        rom[183] = 16'hE684;
        rom[184] = 16'hE983;
        rom[185] = 16'hEC83;
        rom[186] = 16'hEF82;
        rom[187] = 16'hF282;
        rom[188] = 16'hF581;
        rom[189] = 16'hF881;
        rom[190] = 16'hFB81;
        rom[191] = 16'hFE81;
        rom[192] = 16'h0281;
        rom[193] = 16'h0581;
        rom[194] = 16'h0881;
        rom[195] = 16'h0B81;
        rom[196] = 16'h0E82;
        rom[197] = 16'h1182;
        rom[198] = 16'h1483;
        rom[199] = 16'h1783;
        rom[200] = 16'h1A84;
        rom[201] = 16'h1D84;
        rom[202] = 16'h2085;
        rom[203] = 16'h2386;
        rom[204] = 16'h2687;
        rom[205] = 16'h2988;
        rom[206] = 16'h2C89;
        rom[207] = 16'h2F8A;
        rom[208] = 16'h328B;
        rom[209] = 16'h358D;
        rom[210] = 16'h388E;
        rom[211] = 16'h3A8F;
        rom[212] = 16'h3D91;
        rom[213] = 16'h4092;
        rom[214] = 16'h4394;
        rom[215] = 16'h4596;
        rom[216] = 16'h4897;
        rom[217] = 16'h4A99;
        rom[218] = 16'h4D9B;
        rom[219] = 16'h4F9D;
        rom[220] = 16'h529F;
        rom[221] = 16'h54A1;
        rom[222] = 16'h56A3;
        rom[223] = 16'h59A5;
        rom[224] = 16'h5BA7;
        rom[225] = 16'h5DAA;
        rom[226] = 16'h5FAC;
        rom[227] = 16'h61AE;
        rom[228] = 16'h63B1;
        rom[229] = 16'h65B3;
        rom[230] = 16'h67B6;
        rom[231] = 16'h69B8;
        rom[232] = 16'h6ABB;
        rom[233] = 16'h6CBD;
        rom[234] = 16'h6EC0;
        rom[235] = 16'h6FC3;
        rom[236] = 16'h71C6;
        rom[237] = 16'h72C8;
        rom[238] = 16'h73CB;
        rom[239] = 16'h75CE;
        rom[240] = 16'h76D1;
        rom[241] = 16'h77D4;
        rom[242] = 16'h78D7;
        rom[243] = 16'h79DA;
        rom[244] = 16'h7ADD;
        rom[245] = 16'h7BE0;
        rom[246] = 16'h7CE3;
        rom[247] = 16'h7CE6;
        rom[248] = 16'h7DE9;
        rom[249] = 16'h7DEC;
        rom[250] = 16'h7EEF;
        rom[251] = 16'h7EF2;
        rom[252] = 16'h7FF5;
        rom[253] = 16'h7FF8;
        rom[254] = 16'h7FFB;
        rom[255] = 16'h7FFE;
    end

    // ------------------------------------------------------------ вход и фазы
    reg [31:0] xin;
    reg [9:0]  wcnt;                      // номер отсчёта в окне АРУ
    reg        xlast;                     // отсчёт — последний в окне
    reg [1:0]  ph;
    reg        act;
    reg [7:0]  en_s, di_s;                // маски, действующие с отсчёта cfg_n
    reg        pend, xfirst;               // xfirst — отсчёт первый после применения настройки
    reg [31:0] cfg_n;
    wire       apply = smp_stb && (pend || en_wr);
    always @(posedge clk) begin
        if (rst) begin
            act <= 1'b0; ph <= 2'd0; wcnt <= 10'd0; pend <= 1'b0; en_s <= 8'd0; di_s <= 8'd0;
        end else begin
            if (en_wr) pend <= 1'b1;
            if (smp_stb) begin
                xin <= smp_data;
                ph <= 2'd0; act <= 1'b1;
                if (apply) begin
                    en_s <= en; di_s <= dith; pend <= 1'b0; cfg_n <= smp_count;
                    xlast <= 1'b0; wcnt <= 10'd1; xfirst <= 1'b1;
                end else begin
                    xlast <= (wcnt == 10'd1023); wcnt <= wcnt + 1'b1; xfirst <= 1'b0;
                end
            end else if (act) begin
                ph <= ph + 1'b1;
                if (ph == 2'd3) act <= 1'b0;
            end
        end
    end
    // номер отсчёта: кольцо на 4 отсчёта (в конвейере не более 4), индекс идёт с тегами ступеней
    reg [31:0] cring [0:3];
    reg [1:0]  wp, xtag;
    always @(posedge clk) begin
        if (rst) wp <= 2'd0;
        else if (smp_stb) begin
            cring[wp] <= smp_count; xtag <= wp; wp <= wp + 1'b1;
        end
    end

    // ------------------------------------------------------------ теги ступеней (общие)
    // {act, last-канал (p==3), конец окна}
    reg [1:0] pA, pB, pC, pD1, pD2, pE, pF1, pF2, pG0;
    reg       vA, vB, vC, vD1, vD2, vE, vF1, vF2, vG0;
    reg       wA, wB, wC, wD1, wD2, wE, wF1, wF2, wG0;
    reg [1:0] tA, tB, tC, tD1, tD2, tE, tF1, tF2, tG0, tG1;
    reg       fA, fB, fC, fD1, fD2, fE;     // первый канал первого отсчёта после настройки
    reg [1:0] pG1;
    reg       vG1, wG1;
    always @(posedge clk) begin
        tA <= xtag; tB <= tA; tC <= tB; tD1 <= tC; tD2 <= tD1; tE <= tD2; tF1 <= tE; tF2 <= tF1;
        tG0 <= tF2; tG1 <= tG0;
        fA <= act && xfirst && (ph == 2'd0); fB <= fA; fC <= fB; fD1 <= fC; fD2 <= fD1; fE <= fD2;
        vA <= act && !rst; pA <= ph; wA <= xlast;
        vB <= vA;   pB <= pA;   wB <= wA;
        vC <= vB;   pC <= pB;   wC <= wB;
        vD1 <= vC;  pD1 <= pC;  wD1 <= wC;
        vD2 <= vD1; pD2 <= pD1; wD2 <= wD1;
        vE <= vD2;  pE <= pD2;  wE <= wD2;
        vF1 <= vE;  pF1 <= pE;  wF1 <= wE;
        vF2 <= vF1; pF2 <= pF1; wF2 <= wF1;
        vG0 <= vF2; pG0 <= pF2; wG0 <= wF2;
        vG1 <= vG0 && !rst; pG1 <= pG0; wG1 <= wG0;
    end

    wire [3:0] onib [0:1];
    reg  [31:0] ow;

    genvar L;
    generate for (L = 0; L < 2; L = L + 1) begin : g_lane
        // состояние 4 каналов дорожки
        reg [31:0] phi  [0:3];
        reg [18:0] bsi  [0:3];
        reg [18:0] bsq  [0:3];
        reg [19:0] thr  [0:3];
        reg [11:0] big  [0:3];
        // параметры каналов дорожки (постоянные индексы — без сдвигателей)
        wire [31:0] dp_l [0:3];
        wire [3:0]  mu_l [0:3];
        genvar j;
        for (j = 0; j < 4; j = j + 1) begin : g_par
            assign dp_l[j] = dphi[32*(4*L + j) +: 32];
            assign mu_l[j] = mu[4*(4*L + j) +: 4];
        end
        wire [3:0] en_l = en_s[4*L +: 4], di_l = di_s[4*L +: 4];
        wire [15:0] xin_l = xin[16*L +: 16];

        // A: фаза NCO
        reg [7:0] idxA;
        reg [3:0] xA;
        reg       eA, dA;
        integer q;
        always @(posedge clk) begin
            if (rst) begin
                for (q = 0; q < 4; q = q + 1) phi[q] <= 32'd0;
            end else if (act) begin
                phi[ph] <= en_l[ph] ? phi[ph] + dp_l[ph] : 32'd0;
            end
            idxA <= phi[ph][31:24];
            case (ph)
                2'd0: xA <= xin_l[3:0];
                2'd1: xA <= xin_l[7:4];
                2'd2: xA <= xin_l[11:8];
                default: xA <= xin_l[15:12];
            endcase
            eA   <= en_l[ph];
            dA   <= di_l[ph];
        end
        // B: таблица (EBR, синхронное чтение)
        reg [15:0] csB;
        reg [3:0]  xB;
        reg        eB, dB;
        always @(posedge clk) begin
            csB <= rom[idxA];
            xB <= xA; eB <= eA; dB <= dA;
        end
        // C: b = x·e^{−jφ}
        wire signed [7:0] cB = csB[15:8], sB = csB[7:0];
        wire signed [9:0] c3 = {{2{cB[7]}}, cB} + {{1{cB[7]}}, cB, 1'b0};
        wire signed [9:0] s3 = {{2{sB[7]}}, sB} + {{1{sB[7]}}, sB, 1'b0};
        wire signed [9:0] c1 = {{2{cB[7]}}, cB}, s1 = {{2{sB[7]}}, sB};
        // xi·c, xq·s, xq·c, xi·s при x ∈ {±1, ±3}: x = {sI, mI, sQ, mQ}
        wire signed [9:0] ic = xB[2] ? c3 : c1, is_ = xB[2] ? s3 : s1;
        wire signed [9:0] qc = xB[0] ? c3 : c1, qs = xB[0] ? s3 : s1;
        wire signed [10:0] xic = xB[3] ? -ic : ic, xis = xB[3] ? -is_ : is_;
        wire signed [10:0] xqc = xB[1] ? -qc : qc, xqs = xB[1] ? -qs : qs;
        reg signed [10:0] biC, bqC;
        reg signed [7:0]  cC, sC;
        reg [3:0] xC;
        reg       eC, dC;
        always @(posedge clk) begin
            biC <= xic + xqs;
            bqC <= xqc - xis;
            cC <= cB; sC <= sB; xC <= xB; eC <= eB; dC <= dB;
        end
        // D1: разность (b·2^8 − B)
        reg signed [19:0] diD, dqD;
        reg signed [18:0] boI, boQ;
        reg [3:0] muD;
        reg signed [7:0] cD1, sD1;
        reg [3:0] xD1;
        reg       eD1, dD1;
        always @(posedge clk) begin
            diD <= {biC[10], biC, 8'd0} - {bsi[pC][18], bsi[pC]};
            dqD <= {bqC[10], bqC, 8'd0} - {bsq[pC][18], bsq[pC]};
            boI <= bsi[pC]; boQ <= bsq[pC];
            muD <= mu_l[pC];
            cD1 <= cC; sD1 <= sC; xD1 <= xC; eD1 <= eC; dD1 <= dC;
        end
        // D2: B ← B + (разность >> μ); Bh = B >> 1
        wire signed [19:0] bnI = boI + (diD >>> muD);
        wire signed [19:0] bnQ = boQ + (dqD >>> muD);
        reg signed [17:0] bhI, bhQ;
        reg signed [7:0]  cD2, sD2;
        reg [3:0] xD2;
        reg       eD2, dD2;
        always @(posedge clk) begin
            if (rst) begin
                for (q = 0; q < 4; q = q + 1) begin bsi[q] <= 19'd0; bsq[q] <= 19'd0; end
            end else if (vD1) begin
                bsi[pD1] <= eD1 ? bnI[18:0] : 19'd0;
                bsq[pD1] <= eD1 ? bnQ[18:0] : 19'd0;
            end
            bhI <= bnI[18:1]; bhQ <= bnQ[18:1];
            cD2 <= cD1; sD2 <= sD1; xD2 <= xD1; eD2 <= eD1; dD2 <= dD1;
        end
        // E: произведения (DSP)
        reg signed [25:0] pIc, pQs, pQc, pIs;
        reg [3:0] xE;
        reg       eE, dE;
        always @(posedge clk) begin
            pIc <= bhI * cD2; pQs <= bhQ * sD2;
            pQc <= bhQ * cD2; pIs <= bhI * sD2;
            xE <= xD2; eE <= eD2; dE <= dD2;
        end
        // F1: ŝ; x·127²·2^7 + d·2^7 (d — дизеринг, xorshift32 дорожки: шаг на каждый канал;
        // с первого отсчёта после настройки генератор начинается с начального значения)
        reg [31:0] rng_q;
        wire [31:0] rng = fE ? (L ? 32'h9E3779B9 : 32'h12345678) : rng_q;
        wire [31:0] rx1 = rng ^ {rng[18:0], 13'd0};
        wire [31:0] rx2 = rx1 ^ {17'd0, rx1[31:17]};
        wire [31:0] rx3 = rx2 ^ {rx2[26:0], 5'd0};
        wire signed [27:0] xiK = xE[2] ? 28'sd6193536 : 28'sd2064512;   // 3·16129·128, 16129·128
        wire signed [27:0] xqK = xE[0] ? 28'sd6193536 : 28'sd2064512;
        // d = r[14:0] − 2^14 = {~r[14], r[13:0]} (15 бит со знаком), ·2^7
        wire signed [27:0] dI = dE ? {{7{~rng[14]}}, rng[13:0], 7'd0} : 28'sd0;
        wire signed [27:0] dQ = dE ? {{7{~rng[30]}}, rng[29:16], 7'd0} : 28'sd0;
        reg signed [26:0] siF, sqF;
        reg signed [27:0] kiF, kqF;
        reg [3:0] xF1;
        reg       eF1;
        always @(posedge clk) begin
            if (rst) rng_q <= L ? 32'h9E3779B9 : 32'h12345678;
            else if (vE) rng_q <= rx3;
            siF <= pIc - pQs;
            sqF <= pQc + pIs;
            kiF <= (xE[3] ? -xiK : xiK) + dI;
            kqF <= (xE[1] ? -xqK : xqK) + dQ;
            xF1 <= xE; eF1 <= eE;
        end
        // F2: y = (x·127²·2^7 + d·2^7 − ŝ) >> 7
        wire signed [27:0] yiF = kiF - siF;
        wire signed [27:0] yqF = kqF - sqF;
        reg signed [20:0] yiR, yqR;
        reg [3:0] xF2;
        reg       eF2;
        always @(posedge clk) begin
            yiR <= yiF[27:7]; yqR <= yqF[27:7];
            xF2 <= xF1; eF2 <= eF1;
        end
        // G0: знак и модуль; чтение порога и счётчика АРУ канала
        reg [20:0] aiG, aqG;
        reg        niG, nqG;
        reg [3:0]  xG0;
        reg        eG0;
        reg [19:0] tG0;
        reg [11:0] bG0;
        always @(posedge clk) begin
            aiG <= yiR[20] ? -yiR : yiR; niG <= yiR[20];
            aqG <= yqR[20] ? -yqR : yqR; nqG <= yqR[20];
            xG0 <= xF2; eG0 <= eF2;
            tG0 <= thr[pF2]; bG0 <= big[pF2];
        end
        // G1: квантование; заготовки для АРУ (T ± T/16, сравнения счётчика при приращении 0, 1, 2)
        wire        miG = (aiG > {1'b0, tG0});
        wire        mqG = (aqG > {1'b0, tG0});
        reg  [3:0]  nibG;
        reg         mi1, mq1, e1;
        reg  [19:0] tup1, tdn1, t1;
        reg  [11:0] b1;
        reg  [2:0]  hi1, lo1;
        wire [20:0] tup = tG0 + (tG0 >> 4);
        always @(posedge clk) begin
            nibG <= eG0 ? {niG, miG, nqG, mqG} : xG0;
            mi1 <= miG; mq1 <= mqG; e1 <= eG0;
            t1 <= tG0; b1 <= bG0;
            tup1 <= tup[20] ? 20'hFFFFF : tup[19:0];
            tdn1 <= tG0 - (tG0 >> 4);
            hi1 <= {bG0 > 12'd681, bG0 > 12'd682, bG0 > 12'd683};     // big + k > 683, k = 2, 1, 0
            lo1 <= {bG0 < 12'd612, bG0 < 12'd613, bG0 < 12'd614};     // big + k < 614
        end
        // G2: АРУ — запись порога и счётчика
        wire [1:0]  inc2 = mi1 + mq1;
        wire        hi2 = hi1[inc2], lo2 = lo1[inc2];
        always @(posedge clk) begin
            if (rst) begin
                for (q = 0; q < 4; q = q + 1) begin thr[q] <= 20'd16129; big[q] <= 12'd0; end
            end else if (vG1) begin
                if (!e1) begin
                    thr[pG1] <= 20'd16129; big[pG1] <= 12'd0;
                end else if (wG1) begin
                    big[pG1] <= 12'd0;
                    if (hi2)      thr[pG1] <= tup1;
                    else if (lo2) thr[pG1] <= tdn1;
                end else
                    big[pG1] <= b1 + inc2;
            end
        end
        assign onib[L] = nibG;
    end endgenerate

    // ------------------------------------------------------------ сборка выходного слова
    always @(posedge clk) begin
        out_stb <= 1'b0;
        if (vG1) begin
            ow[4*pG1 +: 4]      <= onib[0];
            ow[16 + 4*pG1 +: 4] <= onib[1];
            if (pG1 == 2'd3) begin
                out_stb  <= 1'b1;
                out_data <= {onib[1], ow[27:16], onib[0], ow[11:0]};
                out_count <= cring[tG1];
            end
        end
    end
endmodule
`default_nettype wire
