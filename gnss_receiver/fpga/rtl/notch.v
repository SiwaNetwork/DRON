// =============================================================================
// МГП-8. Цифровой режекторный фильтр (компенсатор гармонических помех) по 8 ВЧ-каналам.
// Битово-точная спецификация — fpga/model/notch_model.py (класс Notch, функция run).
//
// Для включённого канала k: x·e^{−jφ} -> оценка помехи B (экспоненциальное сглаживание с
// коэффициентом 2^−μ) -> вычитание B·e^{jφ} из x -> повторное 2-битное квантование с АРУ порога.
// Выключенный канал передаётся без изменений (с той же задержкой).
//
// Отсчёт приходит раз в 4 такта (smp_stb); две дорожки обрабатывают по 4 канала:
// дорожка L в такте p (0..3) после строба — канал 4L + p. Конвейер:
//   A — фаза NCO; B0, B — таблица cos/sin (EBR с выходным регистром);
//   C1, C — перенос на нулевую частоту; D1, D2, D3 — обновление оценки B (разность, сдвиг на μ,
//   сумма); E — умножители (DSP); F1, F2 — вычитание оценки (и дизеринг:
//   x·127²·2^7 + d·2^7 − ŝ); G0 — модуль; G1 — квантование; G2 — АРУ.
// Выход (out_stb) — через 18 тактов после smp_stb; номер отсчёта сопровождает данные (out_count).
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
    // {c[7:0], s[7:0], 3c[9:0], 3s[9:0]}; чтение — с выходным регистром (2 такта)
    reg [35:0] rom [0:255];
    initial begin
        rom[0] = 36'h7F025F406;
        rom[1] = 36'h7F055F40F;
        rom[2] = 36'h7F085F418;
        rom[3] = 36'h7F0B5F421;
        rom[4] = 36'h7E0E5E82A;
        rom[5] = 36'h7E115E833;
        rom[6] = 36'h7D145DC3C;
        rom[7] = 36'h7D175DC45;
        rom[8] = 36'h7C1A5D04E;
        rom[9] = 36'h7C1D5D057;
        rom[10] = 36'h7B205C460;
        rom[11] = 36'h7A235B869;
        rom[12] = 36'h79265AC72;
        rom[13] = 36'h78295A07B;
        rom[14] = 36'h772C59484;
        rom[15] = 36'h762F5888D;
        rom[16] = 36'h753257C96;
        rom[17] = 36'h73355649F;
        rom[18] = 36'h7238558A8;
        rom[19] = 36'h713A54CAE;
        rom[20] = 36'h6F3D534B7;
        rom[21] = 36'h6E40528C0;
        rom[22] = 36'h6C43510C9;
        rom[23] = 36'h6A454F8CF;
        rom[24] = 36'h69484ECD8;
        rom[25] = 36'h674A4D4DE;
        rom[26] = 36'h654D4BCE7;
        rom[27] = 36'h634F4A4ED;
        rom[28] = 36'h615248CF6;
        rom[29] = 36'h5F54474FC;
        rom[30] = 36'h5D5645D02;
        rom[31] = 36'h5B594450B;
        rom[32] = 36'h595B42D11;
        rom[33] = 36'h565D40917;
        rom[34] = 36'h545F3F11D;
        rom[35] = 36'h52613D923;
        rom[36] = 36'h4F633B529;
        rom[37] = 36'h4D6539D2F;
        rom[38] = 36'h4A6737935;
        rom[39] = 36'h48693613B;
        rom[40] = 36'h456A33D3E;
        rom[41] = 36'h436C32544;
        rom[42] = 36'h406E3014A;
        rom[43] = 36'h3D6F2DD4D;
        rom[44] = 36'h3A712B953;
        rom[45] = 36'h38722A156;
        rom[46] = 36'h357327D59;
        rom[47] = 36'h32752595F;
        rom[48] = 36'h2F7623562;
        rom[49] = 36'h2C7721165;
        rom[50] = 36'h29781ED68;
        rom[51] = 36'h26791C96B;
        rom[52] = 36'h237A1A56E;
        rom[53] = 36'h207B18171;
        rom[54] = 36'h1D7C15D74;
        rom[55] = 36'h1A7C13974;
        rom[56] = 36'h177D11577;
        rom[57] = 36'h147D0F177;
        rom[58] = 36'h117E0CD7A;
        rom[59] = 36'h0E7E0A97A;
        rom[60] = 36'h0B7F0857D;
        rom[61] = 36'h087F0617D;
        rom[62] = 36'h057F03D7D;
        rom[63] = 36'h027F0197D;
        rom[64] = 36'hFE7FFE97D;
        rom[65] = 36'hFB7FFC57D;
        rom[66] = 36'hF87FFA17D;
        rom[67] = 36'hF57FF7D7D;
        rom[68] = 36'hF27EF597A;
        rom[69] = 36'hEF7EF357A;
        rom[70] = 36'hEC7DF1177;
        rom[71] = 36'hE97DEED77;
        rom[72] = 36'hE67CEC974;
        rom[73] = 36'hE37CEA574;
        rom[74] = 36'hE07BE8171;
        rom[75] = 36'hDD7AE5D6E;
        rom[76] = 36'hDA79E396B;
        rom[77] = 36'hD778E1568;
        rom[78] = 36'hD477DF165;
        rom[79] = 36'hD176DCD62;
        rom[80] = 36'hCE75DA95F;
        rom[81] = 36'hCB73D8559;
        rom[82] = 36'hC872D6156;
        rom[83] = 36'hC671D4953;
        rom[84] = 36'hC36FD254D;
        rom[85] = 36'hC06ED014A;
        rom[86] = 36'hBD6CCDD44;
        rom[87] = 36'hBB6ACC53E;
        rom[88] = 36'hB869CA13B;
        rom[89] = 36'hB667C8935;
        rom[90] = 36'hB365C652F;
        rom[91] = 36'hB163C4D29;
        rom[92] = 36'hAE61C2923;
        rom[93] = 36'hAC5FC111D;
        rom[94] = 36'hAA5DBF917;
        rom[95] = 36'hA75BBD511;
        rom[96] = 36'hA559BBD0B;
        rom[97] = 36'hA356BA502;
        rom[98] = 36'hA154B8CFC;
        rom[99] = 36'h9F52B74F6;
        rom[100] = 36'h9D4FB5CED;
        rom[101] = 36'h9B4DB44E7;
        rom[102] = 36'h994AB2CDE;
        rom[103] = 36'h9748B14D8;
        rom[104] = 36'h9645B08CF;
        rom[105] = 36'h9443AF0C9;
        rom[106] = 36'h9240AD8C0;
        rom[107] = 36'h913DACCB7;
        rom[108] = 36'h8F3AAB4AE;
        rom[109] = 36'h8E38AA8A8;
        rom[110] = 36'h8D35A9C9F;
        rom[111] = 36'h8B32A8496;
        rom[112] = 36'h8A2FA788D;
        rom[113] = 36'h892CA6C84;
        rom[114] = 36'h8829A607B;
        rom[115] = 36'h8726A5472;
        rom[116] = 36'h8623A4869;
        rom[117] = 36'h8520A3C60;
        rom[118] = 36'h841DA3057;
        rom[119] = 36'h841AA304E;
        rom[120] = 36'h8317A2445;
        rom[121] = 36'h8314A243C;
        rom[122] = 36'h8211A1833;
        rom[123] = 36'h820EA182A;
        rom[124] = 36'h810BA0C21;
        rom[125] = 36'h8108A0C18;
        rom[126] = 36'h8105A0C0F;
        rom[127] = 36'h8102A0C06;
        rom[128] = 36'h81FEA0FFA;
        rom[129] = 36'h81FBA0FF1;
        rom[130] = 36'h81F8A0FE8;
        rom[131] = 36'h81F5A0FDF;
        rom[132] = 36'h82F2A1BD6;
        rom[133] = 36'h82EFA1BCD;
        rom[134] = 36'h83ECA27C4;
        rom[135] = 36'h83E9A27BB;
        rom[136] = 36'h84E6A33B2;
        rom[137] = 36'h84E3A33A9;
        rom[138] = 36'h85E0A3FA0;
        rom[139] = 36'h86DDA4B97;
        rom[140] = 36'h87DAA578E;
        rom[141] = 36'h88D7A6385;
        rom[142] = 36'h89D4A6F7C;
        rom[143] = 36'h8AD1A7B73;
        rom[144] = 36'h8BCEA876A;
        rom[145] = 36'h8DCBA9F61;
        rom[146] = 36'h8EC8AAB58;
        rom[147] = 36'h8FC6AB752;
        rom[148] = 36'h91C3ACF49;
        rom[149] = 36'h92C0ADB40;
        rom[150] = 36'h94BDAF337;
        rom[151] = 36'h96BBB0B31;
        rom[152] = 36'h97B8B1728;
        rom[153] = 36'h99B6B2F22;
        rom[154] = 36'h9BB3B4719;
        rom[155] = 36'h9DB1B5F13;
        rom[156] = 36'h9FAEB770A;
        rom[157] = 36'hA1ACB8F04;
        rom[158] = 36'hA3AABA6FE;
        rom[159] = 36'hA5A7BBEF5;
        rom[160] = 36'hA7A5BD6EF;
        rom[161] = 36'hAAA3BFAE9;
        rom[162] = 36'hACA1C12E3;
        rom[163] = 36'hAE9FC2ADD;
        rom[164] = 36'hB19DC4ED7;
        rom[165] = 36'hB39BC66D1;
        rom[166] = 36'hB699C8ACB;
        rom[167] = 36'hB897CA2C5;
        rom[168] = 36'hBB96CC6C2;
        rom[169] = 36'hBD94CDEBC;
        rom[170] = 36'hC092D02B6;
        rom[171] = 36'hC391D26B3;
        rom[172] = 36'hC68FD4AAD;
        rom[173] = 36'hC88ED62AA;
        rom[174] = 36'hCB8DD86A7;
        rom[175] = 36'hCE8BDAAA1;
        rom[176] = 36'hD18ADCE9E;
        rom[177] = 36'hD489DF29B;
        rom[178] = 36'hD788E1698;
        rom[179] = 36'hDA87E3A95;
        rom[180] = 36'hDD86E5E92;
        rom[181] = 36'hE085E828F;
        rom[182] = 36'hE384EA68C;
        rom[183] = 36'hE684ECA8C;
        rom[184] = 36'hE983EEE89;
        rom[185] = 36'hEC83F1289;
        rom[186] = 36'hEF82F3686;
        rom[187] = 36'hF282F5A86;
        rom[188] = 36'hF581F7E83;
        rom[189] = 36'hF881FA283;
        rom[190] = 36'hFB81FC683;
        rom[191] = 36'hFE81FEA83;
        rom[192] = 36'h028101A83;
        rom[193] = 36'h058103E83;
        rom[194] = 36'h088106283;
        rom[195] = 36'h0B8108683;
        rom[196] = 36'h0E820AA86;
        rom[197] = 36'h11820CE86;
        rom[198] = 36'h14830F289;
        rom[199] = 36'h178311689;
        rom[200] = 36'h1A8413A8C;
        rom[201] = 36'h1D8415E8C;
        rom[202] = 36'h20851828F;
        rom[203] = 36'h23861A692;
        rom[204] = 36'h26871CA95;
        rom[205] = 36'h29881EE98;
        rom[206] = 36'h2C892129B;
        rom[207] = 36'h2F8A2369E;
        rom[208] = 36'h328B25AA1;
        rom[209] = 36'h358D27EA7;
        rom[210] = 36'h388E2A2AA;
        rom[211] = 36'h3A8F2BAAD;
        rom[212] = 36'h3D912DEB3;
        rom[213] = 36'h4092302B6;
        rom[214] = 36'h4394326BC;
        rom[215] = 36'h459633EC2;
        rom[216] = 36'h4897362C5;
        rom[217] = 36'h4A9937ACB;
        rom[218] = 36'h4D9B39ED1;
        rom[219] = 36'h4F9D3B6D7;
        rom[220] = 36'h529F3DADD;
        rom[221] = 36'h54A13F2E3;
        rom[222] = 36'h56A340AE9;
        rom[223] = 36'h59A542EEF;
        rom[224] = 36'h5BA7446F5;
        rom[225] = 36'h5DAA45EFE;
        rom[226] = 36'h5FAC47704;
        rom[227] = 36'h61AE48F0A;
        rom[228] = 36'h63B14A713;
        rom[229] = 36'h65B34BF19;
        rom[230] = 36'h67B64D722;
        rom[231] = 36'h69B84EF28;
        rom[232] = 36'h6ABB4FB31;
        rom[233] = 36'h6CBD51337;
        rom[234] = 36'h6EC052B40;
        rom[235] = 36'h6FC353749;
        rom[236] = 36'h71C654F52;
        rom[237] = 36'h72C855B58;
        rom[238] = 36'h73CB56761;
        rom[239] = 36'h75CE57F6A;
        rom[240] = 36'h76D158B73;
        rom[241] = 36'h77D45977C;
        rom[242] = 36'h78D75A385;
        rom[243] = 36'h79DA5AF8E;
        rom[244] = 36'h7ADD5BB97;
        rom[245] = 36'h7BE05C7A0;
        rom[246] = 36'h7CE35D3A9;
        rom[247] = 36'h7CE65D3B2;
        rom[248] = 36'h7DE95DFBB;
        rom[249] = 36'h7DEC5DFC4;
        rom[250] = 36'h7EEF5EBCD;
        rom[251] = 36'h7EF25EBD6;
        rom[252] = 36'h7FF55F7DF;
        rom[253] = 36'h7FF85F7E8;
        rom[254] = 36'h7FFB5F7F1;
        rom[255] = 36'h7FFE5F7FA;
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
    // номер отсчёта: кольцо на 8 отсчётов (в конвейере не более 5), индекс идёт с тегами ступеней
    reg [31:0] cring [0:7];
    reg [2:0]  wp, xtag;
    always @(posedge clk) begin
        if (rst) wp <= 3'd0;
        else if (smp_stb) begin
            cring[wp] <= smp_count; xtag <= wp; wp <= wp + 1'b1;
        end
    end

    // ------------------------------------------------------------ теги ступеней (общие)
    // {act, last-канал (p==3), конец окна}
    reg [1:0] pA, pB0, pB, pC1, pC, pD1, pD2, pD3, pE, pF1, pF2, pG0;
    reg       vA, vB0, vB, vC1, vC, vD1, vD2, vD3, vE, vF1, vF2, vG0;
    reg       wA, wB0, wB, wC1, wC, wD1, wD2, wD3, wE, wF1, wF2, wG0;
    reg [2:0] tA, tB0, tB, tC1, tC, tD1, tD2, tD3, tE, tF1, tF2, tG0, tG1;
    reg       fA, fB0, fB, fC1, fC, fD1, fD2, fD3, fE;     // первый канал первого отсчёта после настройки
    reg [1:0] pG1;
    reg       vG1, wG1;
    always @(posedge clk) begin
        tA <= xtag; tB0 <= tA; tB <= tB0; tC1 <= tB; tC <= tC1; tD1 <= tC; tD2 <= tD1; tD3 <= tD2; tE <= tD3;
        tF1 <= tE; tF2 <= tF1; tG0 <= tF2; tG1 <= tG0;
        fA <= act && xfirst && (ph == 2'd0); fB0 <= fA; fB <= fB0; fC1 <= fB; fC <= fC1;
        fD1 <= fC; fD2 <= fD1; fD3 <= fD2; fE <= fD3;
        vA <= act && !rst; pA <= ph; wA <= xlast;
        vB0 <= vA;  pB0 <= pA;  wB0 <= wA;
        vB <= vB0;  pB <= pB0;  wB <= wB0;
        vC1 <= vB;  pC1 <= pB;  wC1 <= wB;
        vC <= vC1;  pC <= pC1;  wC <= wC1;
        vD1 <= vC;  pD1 <= pC;  wD1 <= wC;
        vD2 <= vD1; pD2 <= pD1; wD2 <= wD1;
        vD3 <= vD2; pD3 <= pD2; wD3 <= wD2;
        vE <= vD3;  pE <= pD3;  wE <= wD3;
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
        // разрешения записи φ — однопозиционный код такта (регистр, без дешифратора)
        reg  [3:0]  wen;
        wire [31:0] phi_n = en_l[ph] ? phi[ph] + dp_l[ph] : 32'd0;
        always @(posedge clk) begin
            if (rst) wen <= 4'd0;
            else if (smp_stb) wen <= 4'b0001;
            else wen <= {wen[2:0], 1'b0};
        end
        always @(posedge clk) begin
            if (rst) begin
                for (q = 0; q < 4; q = q + 1) phi[q] <= 32'd0;
            end else begin
                for (q = 0; q < 4; q = q + 1) if (wen[q]) phi[q] <= phi_n;
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
        // B0, B: таблица (EBR, синхронное чтение с выходным регистром)
        reg [35:0] csB0, csB;
        reg [3:0]  xB0, xB;
        reg        eB0, dB0, eB, dB;
        always @(posedge clk) begin
            csB0 <= rom[idxA];
            csB <= csB0;
            xB0 <= xA; eB0 <= eA; dB0 <= dA;
            xB <= xB0; eB <= eB0; dB <= dB0;
        end
        // C1: слагаемые xi·c, xq·s, xq·c, xi·s при x ∈ {±1, ±3}: x = {sI, mI, sQ, mQ}
        wire signed [7:0] cB = csB[35:28], sB = csB[27:20];
        wire signed [9:0] c3 = csB[19:10], s3 = csB[9:0];
        wire signed [9:0] c1 = {{2{cB[7]}}, cB}, s1 = {{2{sB[7]}}, sB};
        wire signed [9:0] ic = xB[2] ? c3 : c1, is_ = xB[2] ? s3 : s1;
        wire signed [9:0] qc = xB[0] ? c3 : c1, qs = xB[0] ? s3 : s1;
        reg signed [10:0] xic, xis, xqc, xqs;
        reg signed [7:0]  cC1, sC1;
        reg [3:0] xC1;
        reg       eC1, dC1;
        always @(posedge clk) begin
            xic <= xB[3] ? -ic : ic; xis <= xB[3] ? -is_ : is_;
            xqc <= xB[1] ? -qc : qc; xqs <= xB[1] ? -qs : qs;
            cC1 <= cB; sC1 <= sB; xC1 <= xB; eC1 <= eB; dC1 <= dB;
        end
        // C: b = x·e^{−jφ}
        reg signed [10:0] biC, bqC;
        reg signed [7:0]  cC, sC;
        reg [3:0] xC;
        reg       eC, dC;
        always @(posedge clk) begin
            biC <= xic + xqs;
            bqC <= xqc - xis;
            cC <= cC1; sC <= sC1; xC <= xC1; eC <= eC1; dC <= dC1;
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
        // D2: разность >> μ
        reg signed [19:0] shI, shQ;
        reg signed [18:0] boI2, boQ2;
        reg signed [7:0]  cD2, sD2;
        reg [3:0] xD2;
        reg       eD2, dD2;
        always @(posedge clk) begin
            shI <= diD >>> muD; shQ <= dqD >>> muD;
            boI2 <= boI; boQ2 <= boQ;
            cD2 <= cD1; sD2 <= sD1; xD2 <= xD1; eD2 <= eD1; dD2 <= dD1;
        end
        // D3: B ← B + (разность >> μ) (запись — через 2 такта после чтения, следующее чтение
        // канала — через 4); Bh = B >> 1
        wire signed [19:0] bnI = boI2 + shI;
        wire signed [19:0] bnQ = boQ2 + shQ;
        reg signed [17:0] bhI, bhQ;
        reg signed [7:0]  cD3, sD3;
        reg [3:0] xD3;
        reg       eD3, dD3;
        always @(posedge clk) begin
            if (rst) begin
                for (q = 0; q < 4; q = q + 1) begin bsi[q] <= 19'd0; bsq[q] <= 19'd0; end
            end else if (vD2) begin
                bsi[pD2] <= eD2 ? bnI[18:0] : 19'd0;
                bsq[pD2] <= eD2 ? bnQ[18:0] : 19'd0;
            end
            bhI <= bnI[18:1]; bhQ <= bnQ[18:1];
            cD3 <= cD2; sD3 <= sD2; xD3 <= xD2; eD3 <= eD2; dD3 <= dD2;
        end
        // E: произведения (DSP)
        reg signed [25:0] pIc, pQs, pQc, pIs;
        reg [3:0] xE;
        reg       eE, dE;
        always @(posedge clk) begin
            pIc <= bhI * cD3; pQs <= bhQ * sD3;
            pQc <= bhQ * cD3; pIs <= bhI * sD3;
            xE <= xD3; eE <= eD3; dE <= dD3;
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
            case (pG1)                    // постоянные индексы (без сдвигателя)
                2'd0: begin ow[3:0]   <= onib[0]; ow[19:16] <= onib[1]; end
                2'd1: begin ow[7:4]   <= onib[0]; ow[23:20] <= onib[1]; end
                2'd2: begin ow[11:8]  <= onib[0]; ow[27:24] <= onib[1]; end
                default: begin ow[15:12] <= onib[0]; ow[31:28] <= onib[1]; end
            endcase
            if (pG1 == 2'd3) begin
                out_stb  <= 1'b1;
                out_data <= {onib[1], ow[27:16], onib[0], ow[11:0]};
                out_count <= cring[tG1];
            end
        end
    end
endmodule
`default_nettype wire
