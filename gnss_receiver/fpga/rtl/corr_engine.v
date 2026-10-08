// =============================================================================
// МГП-8. Движок коррелятора: NMUX = 16 каналов с разделением времени, группа из P = 4 отсчётов
// за шаг. Спецификация арифметики — fpga/model/corr_model.py (битово-точная модель).
//
// Частота clk = 4 × fs (96 МГц при fs = 24 МГц): за время прихода группы из 4 отсчётов (16 тактов)
// движок по одному разу обращается к каждому из 16 слотов и выполняет для включённого канала
// 4 шага коррелятора сразу. Конвейер:
//   S0 — чтение состояния (LUTRAM, адрес = slot), положения кода и фазы несущей 4 отсчётов,
//        эпоха кода, адреса памяти кода; запись нового состояния — в следующем такте (U);
//   S1a, S1b — выход памяти кода (EBR с выходным регистром), выбор блока слота;
//   S1 — окно из 8 чипов памяти кода, индексы и значения чипов E/P/L, таблица несущей;
//   S2 — перенос на нулевую частоту;
//   S3 — произведения на чипы, попарные суммы отсчётов до и после эпохи кода; S3b — суммы;
//   S4 — накопление (LUTRAM, адрес = slot), сброс результатов.
// Состояние канала читается и пишется по одному адресу, глубина LUTRAM 16 используется полностью.
//
// Память кода — EBR 4K×4 на канал (16384 чипа). Код хранится с дополнением:
//   mem[a] = code[(a − 1) mod L], a = 0 .. L+7,
// так что окно из двух соседних слов {mem4[ci/4 + 1], mem4[ci/4]} содержит все чипы с индексами
// ci−1 .. ci+3, нужные 4 отсчётам группы, без проверки перехода через конец кода.
//
// Карта регистров канала (адрес = {0, slot[3:0], reg[3:0]}):
//   0 CTRL      [0] en  [1] boc  [2] tdm  [5:3] rf  [15:8] n_int (1..255). При en=0 накопители
//               и счётчик эпох обнуляются.
//   1 CODE_LEN  длина кода L, чипов (≤ 16376)
//   2 CARR_RATE шаг фазы несущей (доп. код); при en=1 вступает в силу в конце группы, в которой
//               произошёл следующий сброс, при en=0 — в течение 16 тактов
//   3 CODE_RATE шаг фазы кода, доли чипа на отсчёт · 2^32, < 2^31 (аналогично)
//   4 CARR_PHASE фаза несущей (только при en=0)
//   5 CODE_INT  целая часть фазы кода (только при en=0)
//   6 CODE_FRAC дробная часть фазы кода (только при en=0)
//   7 SPACING   смещение ранней/поздней копии, доли чипа · 2^32, ≤ 0,5 чипа (используются ст. 16 бит)
//   8..13       чтение: результаты EI EQ PI PQ LI LQ последнего интервала
//   14 DUMP_T   чтение: номер последнего отсчёта интервала (мл. 32 бит); снимает флаг «готов»
//   15 STATUS   чтение: [0] готов результат, [1] переполнение (результат перезаписан до чтения);
//               чтение снимает флаг переполнения
// Регистры движка (адрес = {1, 0000, reg[3:0]}): 0 CODE_WADDR {slot[19:16], слово[11:0]},
//   1 CODE_WDATA (16 чипов = 4 слова, мл. бит — первый; запись занимает 4 обхода слотов),
//   2 IRQ (готовность по слотам), 3 BUSY (идёт запись кода или фазы),
//   4 START_T — номер отсчёта (мл. 32 бит, кратен 4), 5 START_MASK — маска слотов: запись взводит
//   одновременное включение слотов маски с группы, первый отсчёт которой равен START_T
//   (детерминированный ввод каналов в слежение). Бит en регистра CTRL действует сразу.
// Входы шины регистрируются; задержка чтения — 2 такта. Записи 4..6 буферизуются (буфер на одно
// слово) и выполняются в такте своего слота: интервал между записями в движок должен быть
// не менее 16 тактов (обеспечивается циклом шины FMC).
// =============================================================================
`default_nettype none

module corr_engine #(
    parameter CLOG  = 4,          // разрядность номера слота; NMUX = 2^CLOG
    parameter WBITS = 12          // разрядность адреса слова памяти кода (4 чипа в слове)
) (
    input  wire         clk,
    input  wire         rst,
    input  wire         grp_stb,         // строб группы (ровно раз в NMUX тактов)
    input  wire [127:0] grp_data,        // 4 отсчёта × 8 ВЧ-каналов × {I1,I0,Q1,Q0}
    input  wire [31:0]  grp_count,       // номер первого отсчёта группы (кратен 4)
    input  wire         bus_we,
    input  wire         bus_re,
    input  wire [8:0]   bus_addr,
    input  wire [31:0]  bus_wdata,
    output reg  [31:0]  bus_rdata,
    output wire         irq
);
    localparam NMUX = 1 << CLOG;
    localparam W    = 32;
    localparam CB   = WBITS + 2;         // разрядность индекса чипа
    integer i;

    // ------------------------------------------------------------ входной регистр шины
    reg        b_we, b_re;
    reg [8:0]  b_addr;
    reg [31:0] b_wdata;
    always @(posedge clk) begin
        b_we <= bus_we; b_re <= bus_re; b_addr <= bus_addr; b_wdata <= bus_wdata;
    end
    function [NMUX-1:0] onehot;
        input [CLOG-1:0] k;
        onehot = {{(NMUX-1){1'b0}}, 1'b1} << k;
    endfunction

    // ------------------------------------------------------------ планировщик слотов
    reg [CLOG-1:0] slot;
    // копии номера слота для групп памяти (нагрузка одного триггера на ~170 ячеек LUTRAM велика)
    (* keep *) reg [CLOG-1:0] slot_a, slot_b, slot_c;
    reg            run;                  // в этом обходе обрабатывается новая группа
    reg [127:0]    grp_l;
    reg [31:0]     cnt_l;
    always @(posedge clk) begin
        if (rst) begin
            run <= 1'b0; slot <= 0; slot_a <= 0; slot_b <= 0; slot_c <= 0;
        end else if (grp_stb) begin
            run <= 1'b1; slot <= 0; slot_a <= 0; slot_b <= 0; slot_c <= 0;
            grp_l <= grp_data; cnt_l <= grp_count;
        end else begin
            if (slot == NMUX-1) run <= 1'b0;
            slot <= slot + 1'b1; slot_a <= slot_a + 1'b1; slot_b <= slot_b + 1'b1; slot_c <= slot_c + 1'b1;
        end
    end

    // ------------------------------------------------------------ память состояния (LUTRAM)
    reg [W-1:0]  m_cp  [0:NMUX-1];      // фаза несущей
    reg [W-1:0]  m_cr  [0:NMUX-1];      // шаг несущей (действующий)
    reg [W-1:0]  m_kr  [0:NMUX-1];      // шаг кода (действующий)
    reg [W-1:0]  m_cr3 [0:NMUX-1];      // 3 × шаг несущей
    reg [W:0]    m_kr3 [0:NMUX-1];      // 3 × шаг кода (33 бит)
    reg [W-1:0]  m_cf  [0:NMUX-1];      // дробная фаза кода
    reg [CB-1:0] m_ci  [0:NMUX-1];      // целая фаза кода
    reg [WBITS-1:0] m_wn [0:NMUX-1];     // адрес следующего слова кода: ci[CB-1:2] + 1
    reg [15:0]   m_nm  [0:NMUX-1];      // {max(n_int − 1, 0), max(n_int − 2, 0)} (из CTRL)
    reg [CB:0]   m_D   [0:NMUX-1];      // L − ci (≥ 1)
    reg [8:0]    m_ep  [0:NMUX-1];      // {последняя эпоха интервала, счётчик эпох}
    reg [15:0]   m_ctl [0:NMUX-1];      // запись с шины
    reg [CB:0]   m_len [0:NMUX-1];
    reg [W-1:0]  m_crn [0:NMUX-1];      // шаг несущей (новый)
    reg [W-1:0]  m_krn [0:NMUX-1];      // шаг кода (новый)
    reg [15:0]   m_sp  [0:NMUX-1];
    reg [NMUX-1:0] pend;                 // записан новый шаг, ещё не применён
    initial for (i = 0; i < NMUX; i = i + 1) begin m_ctl[i] = 16'd0; m_nm[i] = 16'd0; end

    // включение слотов: сразу (CTRL[0]) или с заданного отсчёта (START_T, START_MASK).
    // Совпадение номера следующей группы (cnt_l + 4) с START_T вычисляется заранее (за обход).
    reg [NMUX-1:0] en_r, st_mask;
    reg [31:0]     st_t, cnt_next;
    reg            st_v, st_hit;
    wire           ctl_wr = b_we && !b_addr[8] && b_addr[3:0] == 4'd0;
    wire [NMUX-1:0] ctl_m = ctl_wr ? onehot(b_addr[4 +: CLOG]) : {NMUX{1'b0}};
    always @(posedge clk) begin
        cnt_next <= cnt_l + 32'd4;
        st_hit   <= st_v && (cnt_next == st_t);
        if (rst) begin
            en_r <= 0; st_v <= 1'b0;
        end else begin
            en_r <= (en_r & ~ctl_m) | (ctl_m & {NMUX{b_wdata[0]}})
                  | ((grp_stb && st_hit) ? st_mask : {NMUX{1'b0}});
            if (b_we && b_addr == 9'h104) st_t <= b_wdata;
            if (b_we && b_addr == 9'h105) begin st_mask <= b_wdata[NMUX-1:0]; st_v <= 1'b1; end
            else if (grp_stb && st_hit) st_v <= 1'b0;
        end
    end

    // ------------------------------------------------------------ арифметика
    // tcos(m, k) = (m ? 3 : 1) · round(7·cos(2π(k+0.5)/64)). Отрицание — сдвигом индекса на 32
    // (cos(φ+π) = −cos φ), синус — сдвигом на ∓16 (sin φ = cos(φ−π/2), −sin φ = cos(φ+π/2));
    // для этой таблицы тождества выполняются точно.
    function signed [5:0] tcos;          // таблица 2 × 64 значений (чистая логика LUT)
        input m;
        input [5:0] k;
        case ({m, k})
            7'd0: tcos = 7; 7'd1: tcos = 7; 7'd2: tcos = 7; 7'd3: tcos = 7; 7'd4: tcos = 6; 7'd5: tcos = 6; 7'd6: tcos = 6; 7'd7: tcos = 5;
            7'd8: tcos = 5; 7'd9: tcos = 4; 7'd10: tcos = 4; 7'd11: tcos = 3; 7'd12: tcos = 2; 7'd13: tcos = 2; 7'd14: tcos = 1; 7'd15: tcos = 0;
            7'd16: tcos = 0; 7'd17: tcos = -1; 7'd18: tcos = -2; 7'd19: tcos = -2; 7'd20: tcos = -3; 7'd21: tcos = -4; 7'd22: tcos = -4; 7'd23: tcos = -5;
            7'd24: tcos = -5; 7'd25: tcos = -6; 7'd26: tcos = -6; 7'd27: tcos = -6; 7'd28: tcos = -7; 7'd29: tcos = -7; 7'd30: tcos = -7; 7'd31: tcos = -7;
            7'd32: tcos = -7; 7'd33: tcos = -7; 7'd34: tcos = -7; 7'd35: tcos = -7; 7'd36: tcos = -6; 7'd37: tcos = -6; 7'd38: tcos = -6; 7'd39: tcos = -5;
            7'd40: tcos = -5; 7'd41: tcos = -4; 7'd42: tcos = -4; 7'd43: tcos = -3; 7'd44: tcos = -2; 7'd45: tcos = -2; 7'd46: tcos = -1; 7'd47: tcos = 0;
            7'd48: tcos = 0; 7'd49: tcos = 1; 7'd50: tcos = 2; 7'd51: tcos = 2; 7'd52: tcos = 3; 7'd53: tcos = 4; 7'd54: tcos = 4; 7'd55: tcos = 5;
            7'd56: tcos = 5; 7'd57: tcos = 6; 7'd58: tcos = 6; 7'd59: tcos = 6; 7'd60: tcos = 7; 7'd61: tcos = 7; 7'd62: tcos = 7; 7'd63: tcos = 7;
            7'd64: tcos = 21; 7'd65: tcos = 21; 7'd66: tcos = 21; 7'd67: tcos = 21; 7'd68: tcos = 18; 7'd69: tcos = 18; 7'd70: tcos = 18; 7'd71: tcos = 15;
            7'd72: tcos = 15; 7'd73: tcos = 12; 7'd74: tcos = 12; 7'd75: tcos = 9; 7'd76: tcos = 6; 7'd77: tcos = 6; 7'd78: tcos = 3; 7'd79: tcos = 0;
            7'd80: tcos = 0; 7'd81: tcos = -3; 7'd82: tcos = -6; 7'd83: tcos = -6; 7'd84: tcos = -9; 7'd85: tcos = -12; 7'd86: tcos = -12; 7'd87: tcos = -15;
            7'd88: tcos = -15; 7'd89: tcos = -18; 7'd90: tcos = -18; 7'd91: tcos = -18; 7'd92: tcos = -21; 7'd93: tcos = -21; 7'd94: tcos = -21; 7'd95: tcos = -21;
            7'd96: tcos = -21; 7'd97: tcos = -21; 7'd98: tcos = -21; 7'd99: tcos = -21; 7'd100: tcos = -18; 7'd101: tcos = -18; 7'd102: tcos = -18; 7'd103: tcos = -15;
            7'd104: tcos = -15; 7'd105: tcos = -12; 7'd106: tcos = -12; 7'd107: tcos = -9; 7'd108: tcos = -6; 7'd109: tcos = -6; 7'd110: tcos = -3; 7'd111: tcos = 0;
            7'd112: tcos = 0; 7'd113: tcos = 3; 7'd114: tcos = 6; 7'd115: tcos = 6; 7'd116: tcos = 9; 7'd117: tcos = 12; 7'd118: tcos = 12; 7'd119: tcos = 15;
            7'd120: tcos = 15; 7'd121: tcos = 18; 7'd122: tcos = 18; 7'd123: tcos = 18; 7'd124: tcos = 21; 7'd125: tcos = 21; 7'd126: tcos = 21; 7'd127: tcos = 21;
        endcase
    endfunction
    // слагаемое накопителя: z ? 0 : (n ? ~v : v); недостающая единица (−v = ~v + 1) — отдельно
    function signed [6:0] chipx;
        input z, n;
        input signed [6:0] v;
        chipx = z ? 7'sd0 : (v ^ {7{n}});
    endfunction

    // ------------------------------------------------------------ S0: NCO, эпоха, адреса кода
    wire [15:0]   c0  = m_ctl[slot_c];
    wire          en0 = en_r[slot];
    wire [2:0]    rf0 = c0[5:3];
    wire [W-1:0]  cp0 = m_cp[slot_a];
    wire [W-1:0]  cr0 = m_cr[slot_a];
    wire [W-1:0]  kr0 = m_kr[slot_b];
    wire [W-1:0]  cf0 = m_cf[slot_b];
    wire [CB-1:0] ci0 = m_ci[slot_b];
    wire [CB:0]   L0  = m_len[slot_c];
    wire [8:0]    ep0 = m_ep[slot_c];
    // положение кода отсчёта j группы: ci0 + (cf0 + j·kr0) / 2^32
    wire [33:0] f1 = {2'b0, cf0} + {2'b0, kr0};
    wire [33:0] f2 = {2'b0, cf0} + {1'b0, kr0, 1'b0};
    wire [33:0] f3 = {2'b0, cf0} + {1'b0, m_kr3[slot_b]};
    wire [33:0] f4 = {2'b0, cf0} + {kr0, 2'b0};
    // фаза несущей отсчёта j: cp0 + j·cr0
    wire [W-1:0] ph1 = cp0 + cr0;
    wire [W-1:0] ph2 = cp0 + {cr0[W-2:0], 1'b0};
    wire [W-1:0] ph3 = cp0 + m_cr3[slot_a];
    wire [W-1:0] ph4 = cp0 + {cr0[W-3:0], 2'b0};
    // эпоха кода после отсчёта j: ci0 + o_{j+1} ≥ L, т. е. o_{j+1} ≥ D = L − ci0 (D ≥ 1, o ≤ 2)
    wire [CB:0] D0 = m_D[slot_b];
    wire        dsm = (D0[CB:2] == 0);
    wire w0 = dsm && (f1[33:32] >= D0[1:0]);
    wire w1 = dsm && (f2[33:32] >= D0[1:0]);
    wire w2 = dsm && (f3[33:32] >= D0[1:0]);
    wire w3 = dsm && (f4[33:32] >= D0[1:0]);
    wire       wrap0 = w3;
    wire       dump0 = wrap0 && ep0[8];
    wire       act0  = run && en0;

    // буфер записи фаз: регистры 4, 5, 6 -> pw_reg 0, 1, 2
    reg            pw_v;
    reg [CLOG-1:0] pw_slot;
    reg [1:0]      pw_reg;
    reg [31:0]     pw_data;
    wire pw_now = pw_v && (pw_slot == slot);

    // ------------------------------------------------------------ U: запись состояния
    // Новое состояние записывается тактом позже (адрес u_slot): слот снова читается через NMUX
    // тактов, а длинная цепочка «чтение LUTRAM — сумматоры — запись» разбивается на два такта.
    reg [CLOG-1:0] u_slot;
    reg            u_v, u_en, u_wrap, u_dump, u_pend, u_pw;
    reg [W-1:0]    u_cp, u_cf, u_pwd;
    reg [1:0]      u_o4, u_pwr;
    reg [CB-1:0]   u_ci;
    reg [CB:0]     u_D, u_L;
    reg [7:0]      u_ep, u_e1;
    reg            u_fi, u_fs, u_fz;
    // признак «ep + 1 ≥ n_int» для трёх вариантов нового ep (ep + 1, ep, 0) — вычисляется тактом раньше
    wire [7:0]  e1_0 = ep0[7:0] + 1'b1;
    wire [15:0] nm0  = m_nm[slot_c];
    always @(posedge clk) begin
        u_slot <= slot; u_v <= act0; u_en <= en0; u_wrap <= wrap0; u_dump <= dump0;
        u_pend <= pend[slot]; u_pw <= pw_now; u_pwr <= pw_reg; u_pwd <= pw_data;
        u_cp <= ph4; u_cf <= f4[W-1:0]; u_o4 <= f4[33:32]; u_ci <= ci0; u_D <= D0; u_L <= L0; u_ep <= ep0[7:0];
        u_e1 <= e1_0;
        // ep + 2 ≥ n_int, ep + 1 ≥ n_int, n_int ≤ 1 (ep ≤ 254 — счётчик сбрасывается на сбросе)
        u_fi <= (ep0[7:0] >= nm0[7:0]);
        u_fs <= (ep0[7:0] >= nm0[15:8]);
        u_fz <= (nm0[15:8] == 8'd0);
    end
    // новые шаги NCO: при сбросе (канал включён) или сразу (канал выключен)
    wire        u_apply = u_pend && (!u_en || (u_v && u_dump));
    // при переходе через конец кода: ci + o4 − L = o4 − D
    wire [CB:0] u_ni = u_wrap ? ({{(CB-1){1'b0}}, u_o4} - u_D) : ({1'b0, u_ci} + u_o4);
    // то же + 4 чипа (следующее слово кода) — параллельно, без удлинения цепочки
    wire [CB:0] u_ni4 = u_wrap ? ({{(CB-2){1'b0}}, 1'b1, u_o4} - u_D) : ({1'b0, u_ci} + {1'b1, u_o4});
    // новое расстояние до конца кода: при переходе L − (o4 − D), иначе D − o4
    wire [CB:0] u_Dn = u_wrap ? (u_L - u_ni) : (u_D - u_o4);
    // счётчик эпох и признак «следующая эпоха завершает интервал» (ep + 1 ≥ n_int)
    wire [7:0]  u_epn = (u_v && u_wrap) ? (u_dump ? 8'd0 : u_e1) : (u_v ? u_ep : 8'd0);
    wire        u_epf = (u_v && u_wrap) ? (u_dump ? u_fz : u_fi) : (u_v ? u_fs : u_fz);
    wire [8:0]  u_epw = {u_epf, u_epn};
    always @(posedge clk) begin
        if (u_v) begin
            m_cp[u_slot] <= u_cp;
            m_cf[u_slot] <= u_cf;
            m_ci[u_slot] <= u_ni[CB-1:0];
            m_wn[u_slot] <= u_ni4[CB-1:2];
            m_D[u_slot]  <= u_Dn;
            m_ep[u_slot] <= u_epw;
        end else if (!u_en) begin
            m_ep[u_slot] <= u_epw;
            m_D[u_slot]  <= u_L - {1'b0, u_ci};          // пересчёт после записи CODE_INT / LEN
            if (u_pw && u_pwr == 2'd0) m_cp[u_slot] <= u_pwd;
            if (u_pw && u_pwr == 2'd1) begin
                m_ci[u_slot] <= u_pwd[CB-1:0];
                m_wn[u_slot] <= u_pwd[CB-1:2] + 1'b1;
            end
            if (u_pw && u_pwr == 2'd2) m_cf[u_slot] <= u_pwd;
        end
        if (u_apply) begin
            m_cr[u_slot]  <= m_crn[u_slot];
            m_kr[u_slot]  <= m_krn[u_slot];
            m_cr3[u_slot] <= m_crn[u_slot] + {m_crn[u_slot][W-2:0], 1'b0};
            m_kr3[u_slot] <= {1'b0, m_krn[u_slot]} + {m_krn[u_slot], 1'b0};
        end
    end

    // запись с шины
    wire bus_ch = b_we && !b_addr[8];
    wire [CLOG-1:0] bs = b_addr[4 +: CLOG];
    always @(posedge clk) begin
        if (bus_ch) case (b_addr[3:0])
            4'd0: begin
                m_ctl[bs] <= b_wdata[15:0];
                m_nm[bs]  <= {(b_wdata[15:8] > 8'd1) ? b_wdata[15:8] - 8'd1 : 8'd0,
                              (b_wdata[15:8] > 8'd2) ? b_wdata[15:8] - 8'd2 : 8'd0};
            end
            4'd1: m_len[bs] <= b_wdata[CB:0];
            4'd2: m_crn[bs] <= b_wdata;
            4'd3: m_krn[bs] <= b_wdata;
            4'd7: m_sp [bs] <= b_wdata[31:16];
            default: ;
        endcase
    end
    always @(posedge clk) begin
        if (rst) begin
            pw_v <= 1'b0; pend <= 0;
        end else begin
            if (pw_now) pw_v <= 1'b0;
            if (bus_ch && b_addr[3:0] >= 4'd4 && b_addr[3:0] <= 4'd6) begin
                pw_v <= 1'b1; pw_slot <= bs; pw_reg <= b_addr[1:0]; pw_data <= b_wdata;
            end
            pend <= (pend & ~(u_apply ? onehot(u_slot) : {NMUX{1'b0}}))
                  | ((bus_ch && b_addr[3:1] == 3'd1) ? onehot(bs) : {NMUX{1'b0}});
        end
    end

    // ------------------------------------------------------------ память кодов (EBR 4K×4 на слот)
    // 16 блоков читаются по одному адресу; выход выбирается по номеру слота через 2 такта
    // (EBR с выходным регистром). Запись — только в блок текущего слота (w_slot).
    reg [CLOG-1:0]  w_slot;
    reg [WBITS-1:0] w_word;
    reg [15:0]      w_data;
    reg [2:0]       w_cnt;
    wire w_now = (w_cnt != 0) && (slot == w_slot);
    wire [WBITS-1:0] wa0 = ci0[CB-1:2];
    wire [WBITS-1:0] wa1 = w_now ? w_word : m_wn[slot_b];
    wire [3:0] cm_a [0:NMUX-1];
    wire [3:0] cm_b [0:NMUX-1];
    genvar m;
    generate
        for (m = 0; m < NMUX; m = m + 1) begin : g_cmem
            cmem_4kx4 u_cm (.clk(clk), .a_addr(wa0), .a_dout(cm_a[m]),
                            .b_addr(wa1), .b_we(w_now && slot == m), .b_din(w_data[3:0]), .b_dout(cm_b[m]));
        end
    endgenerate
    always @(posedge clk) begin
        if (rst) w_cnt <= 0;
        else if (b_we && b_addr == 9'h100) begin
            w_slot <= b_wdata[16 +: CLOG];
            w_word <= b_wdata[WBITS-1:0];
        end else if (b_we && b_addr == 9'h101) begin
            w_data <= b_wdata[15:0];
            w_cnt  <= 3'd4;
        end else if (w_now) begin
            w_data <= {4'd0, w_data[15:4]};
            w_word <= w_word + 1'b1;
            w_cnt  <= w_cnt - 1'b1;
        end
    end

    // ------------------------------------------------------------ S0 -> S1
    reg [CLOG-1:0] s1_slot;
    reg        s1_v, s1_en, s1_dump, s1_boc, s1_tdm;
    reg [1:0]  s1_cl;
    reg [2:0]  s1_w;                     // эпоха кода после отсчёта 0, 1, 2
    reg [5:0]  s1_o;                     // o1, o2, o3
    reg [63:0] s1_F;                     // ст. 16 бит дробной фазы кода 4 отсчётов
    reg [15:0] s1_sp;
    reg [23:0] s1_k;                     // индексы таблицы несущей 4 отсчётов
    reg [15:0] s1_x;                     // 4 отсчёта выбранного ВЧ-канала
    reg [31:0] s1_t;
    always @(posedge clk) begin
        s1_v    <= act0;
        s1_en   <= en0;
        s1_slot <= slot;
        s1_dump <= dump0;
        s1_boc  <= c0[1];
        s1_tdm  <= c0[2];
        s1_w    <= {w2, w1, w0};
        s1_cl   <= ci0[1:0];
        s1_o    <= {f3[33:32], f2[33:32], f1[33:32]};
        s1_F    <= {f3[31:16], f2[31:16], f1[31:16], cf0[31:16]};
        s1_sp   <= m_sp[slot_c];
        s1_k    <= {ph3[31:26], ph2[31:26], ph1[31:26], cp0[31:26]};
        s1_x    <= {grp_l[96 + rf0*4 +: 4], grp_l[64 + rf0*4 +: 4],
                    grp_l[32 + rf0*4 +: 4], grp_l[rf0*4 +: 4]};
        s1_t    <= cnt_l;
    end

    // ------------------------------------------------------------ S1a, S1b: выход EBR -> регистр
    // (данные памяти кода приходят через 2 такта после адреса; остальные сигналы задерживаются)
    reg [CLOG-1:0] t0_slot;
    reg        t0_v, t0_en, t0_dump, t0_boc, t0_tdm;
    reg [1:0]  t0_cl;
    reg [2:0]  t0_w;
    reg [5:0]  t0_o;
    reg [63:0] t0_F;
    reg [15:0] t0_sp;
    reg [23:0] t0_k;
    reg [15:0] t0_x;
    reg [31:0] t0_t;
    always @(posedge clk) begin
        t0_slot <= s1_slot; t0_v <= s1_v; t0_en <= s1_en; t0_dump <= s1_dump;
        t0_boc <= s1_boc; t0_tdm <= s1_tdm; t0_cl <= s1_cl; t0_w <= s1_w; t0_o <= s1_o;
        t0_F <= s1_F; t0_sp <= s1_sp; t0_k <= s1_k; t0_x <= s1_x; t0_t <= s1_t;
    end
    reg [CLOG-1:0] t1_slot;
    reg        t1_v, t1_en, t1_dump, t1_boc, t1_tdm;
    reg [1:0]  t1_jw, t1_cl;
    reg [5:0]  t1_o;
    reg [63:0] t1_F;
    reg [15:0] t1_sp;
    reg [23:0] t1_k;
    reg [15:0] t1_x;
    reg [31:0] t1_t;
    reg [7:0]  t1_win;
    wire [1:0] t0_jw0 = t0_w[0] ? 2'd0 : t0_w[1] ? 2'd1 : t0_w[2] ? 2'd2 : 2'd3;
    always @(posedge clk) begin
        t1_slot <= t0_slot; t1_v <= t0_v; t1_en <= t0_en; t1_dump <= t0_dump;
        t1_boc <= t0_boc; t1_tdm <= t0_tdm; t1_cl <= t0_cl; t1_o <= t0_o;
        t1_F <= t0_F; t1_sp <= t0_sp; t1_k <= t0_k; t1_x <= t0_x;
        // последний отсчёт интервала: при сбросе — граница эпохи, иначе все 4 в накопитель
        t1_jw <= t0_dump ? t0_jw0 : 2'd3;
        t1_t  <= {t0_t[31:2], t0_jw0};
        t1_win <= {cm_b[t0_slot], cm_a[t0_slot]};
    end

    // ------------------------------------------------------------ S1: чипы, таблица несущей
    wire [7:0] win = t1_win;
    wire [23:0] s1_chip;                 // по отсчёту j: {zE, nE, zP, nP, zL, nL}
    wire [95:0] s1_tab;                  // по отсчёту j: {I·sin', Q·cos, Q·sin, I·cos} по 6 бит
    genvar j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : g_s1
            wire [15:0] Fj = t1_F[16*j +: 16];
            wire [7:0]  oall = {t1_o, 2'b00};
            wire [1:0]  oj = oall[2*j +: 2];
            wire [16:0] e17 = {1'b0, Fj} + {1'b0, t1_sp};
            wire [16:0] l17 = {1'b0, Fj} - {1'b0, t1_sp};
            wire [2:0]  pidx = {1'b0, t1_cl} + {1'b0, oj} + 3'd1;
            wire [2:0]  eidx = pidx + e17[16];
            wire [2:0]  lidx = pidx - l17[16];
            // чип: бит памяти 1 -> −1; BOC — инверсия во второй половине чипа; TDM — 0 там же
            assign s1_chip[6*j +: 6] = {
                t1_tdm & e17[15], win[eidx] ^ (t1_boc & e17[15]),
                t1_tdm & Fj[15],  win[pidx] ^ (t1_boc & Fj[15]),
                t1_tdm & l17[15], win[lidx] ^ (t1_boc & l17[15])};
            wire [5:0] kj = t1_k[6*j +: 6];
            wire [3:0] xj = t1_x[4*j +: 4];          // {sI, mI, sQ, mQ}
            wire [5:0] ki = {kj[5] ^ xj[3], kj[4:0]};
            wire [5:0] kq = {kj[5] ^ xj[1], kj[4:0]};
            // bb_i = x_i·cos + x_q·sin;  bb_q = x_q·cos − x_i·sin
            assign s1_tab[24*j +: 24] = {
                tcos(xj[2], {ki[5:4] + 2'd1, ki[3:0]}),   // −x_i·sin
                tcos(xj[0], kq),                          //  x_q·cos
                tcos(xj[0], {kq[5:4] - 2'd1, kq[3:0]}),   //  x_q·sin
                tcos(xj[2], ki)};                         //  x_i·cos
        end
    endgenerate

    reg [CLOG-1:0] s2_slot;
    reg        s2_v, s2_en, s2_dump;
    reg [1:0]  s2_jw;
    reg [23:0] s2_chip;
    reg [95:0] s2_tab;
    reg [31:0] s2_t;
    always @(posedge clk) begin
        s2_v <= t1_v; s2_en <= t1_en; s2_slot <= t1_slot; s2_dump <= t1_dump; s2_t <= t1_t;
        s2_jw <= t1_jw; s2_chip <= s1_chip; s2_tab <= s1_tab;
    end

    // ------------------------------------------------------------ S2: перенос на нулевую частоту
    wire [55:0] s2_bb;                   // по отсчёту j: {bq[6:0], bi[6:0]}
    generate
        for (j = 0; j < 4; j = j + 1) begin : g_s2
            wire signed [5:0] t_ic = s2_tab[24*j +: 6];
            wire signed [5:0] t_qs = s2_tab[24*j + 6 +: 6];
            wire signed [5:0] t_qc = s2_tab[24*j + 12 +: 6];
            wire signed [5:0] t_is = s2_tab[24*j + 18 +: 6];
            wire signed [6:0] bi = t_ic + t_qs;
            wire signed [6:0] bq = t_qc + t_is;
            assign s2_bb[14*j +: 14] = {bq, bi};
        end
    endgenerate

    reg [CLOG-1:0] s3_slot;
    reg        s3_v, s3_en, s3_dump;
    reg [1:0]  s3_jw;
    reg [23:0] s3_chip;
    reg [55:0] s3_bb;
    reg [31:0] s3_t;
    always @(posedge clk) begin
        s3_v <= s2_v; s3_en <= s2_en; s3_slot <= s2_slot; s3_dump <= s2_dump; s3_t <= s2_t;
        s3_jw <= s2_jw; s3_chip <= s2_chip; s3_bb <= s2_bb;
    end

    // ------------------------------------------------------------ S3: произведения и суммы
    // add — отсчёты 0..jw (в текущий интервал), nxt — отсчёты jw+1..3 (в следующий)
    wire [3:0] m_cur = (s3_jw == 2'd0) ? 4'b0001 : (s3_jw == 2'd1) ? 4'b0011 :
                       (s3_jw == 2'd2) ? 4'b0111 : 4'b1111;
    wire [191:0] s3_pair;                // по накопителю: {pn23, pn01, pa23, pa01} по 8 бит
    genvar a;
    generate
        for (a = 0; a < 6; a = a + 1) begin : g_s3
            // a: 0 EI, 1 EQ, 2 PI, 3 PQ, 4 LI, 5 LQ; чип — пара бит (a/2), компонента — a%2
            localparam ZB = 5 - 2*(a/2), NB = 4 - 2*(a/2), VB = 7*(a%2);
            wire [3:0] z, n;
            wire signed [6:0] v0 = s3_bb[14*0 + VB +: 7], v1 = s3_bb[14*1 + VB +: 7],
                              v2 = s3_bb[14*2 + VB +: 7], v3 = s3_bb[14*3 + VB +: 7];
            assign z = {s3_chip[6*3 + ZB], s3_chip[6*2 + ZB], s3_chip[6*1 + ZB], s3_chip[6*0 + ZB]};
            assign n = {s3_chip[6*3 + NB], s3_chip[6*2 + NB], s3_chip[6*1 + NB], s3_chip[6*0 + NB]};
            wire [3:0] za = z | ~m_cur, zn = z | m_cur;
            wire [3:0] ca = ~za & n, cn = ~zn & n;
            // попарные суммы (недостающие единицы −v = ~v + 1 добавляются здесь же)
            wire signed [7:0] pa01 = chipx(za[0], n[0], v0) + chipx(za[1], n[1], v1)
                                   + $signed({2'b0, {1'b0, ca[0]} + {1'b0, ca[1]}});
            wire signed [7:0] pa23 = chipx(za[2], n[2], v2) + chipx(za[3], n[3], v3)
                                   + $signed({2'b0, {1'b0, ca[2]} + {1'b0, ca[3]}});
            wire signed [7:0] pn01 = chipx(zn[0], n[0], v0) + chipx(zn[1], n[1], v1)
                                   + $signed({2'b0, {1'b0, cn[0]} + {1'b0, cn[1]}});
            wire signed [7:0] pn23 = chipx(zn[2], n[2], v2) + chipx(zn[3], n[3], v3)
                                   + $signed({2'b0, {1'b0, cn[2]} + {1'b0, cn[3]}});
            assign s3_pair[32*a +: 32] = {pn23, pn01, pa23, pa01};
        end
    endgenerate

    // S3b: окончательные суммы
    reg [CLOG-1:0] q_slot;
    reg        q_v, q_en, q_dump;
    reg [191:0] q_pair;
    reg [31:0] q_t;
    always @(posedge clk) begin
        q_v <= s3_v; q_en <= s3_en; q_slot <= s3_slot; q_dump <= s3_dump; q_t <= s3_t;
        q_pair <= s3_pair;
    end
    wire signed [8:0] s3_add [0:5];
    wire signed [8:0] s3_nxt [0:5];
    generate
        for (a = 0; a < 6; a = a + 1) begin : g_s3b
            wire signed [7:0] pa01 = q_pair[32*a +: 8],      pa23 = q_pair[32*a + 8 +: 8];
            wire signed [7:0] pn01 = q_pair[32*a + 16 +: 8], pn23 = q_pair[32*a + 24 +: 8];
            assign s3_add[a] = pa01 + pa23;
            assign s3_nxt[a] = pn01 + pn23;
        end
    endgenerate

    reg [CLOG-1:0] s4_slot;
    reg        s4_v, s4_en, s4_dump;
    reg [NMUX-1:0] s4_dmask;
    reg signed [8:0] s4_add0, s4_add1, s4_add2, s4_add3, s4_add4, s4_add5;
    reg signed [8:0] s4_nxt0, s4_nxt1, s4_nxt2, s4_nxt3, s4_nxt4, s4_nxt5;
    reg [31:0] s4_t;
    always @(posedge clk) begin
        s4_v <= q_v; s4_en <= q_en; s4_slot <= q_slot; s4_dump <= q_dump; s4_t <= q_t;
        s4_dmask <= (q_v && q_dump) ? onehot(q_slot) : {NMUX{1'b0}};
        s4_add0 <= s3_add[0]; s4_add1 <= s3_add[1]; s4_add2 <= s3_add[2];
        s4_add3 <= s3_add[3]; s4_add4 <= s3_add[4]; s4_add5 <= s3_add[5];
        s4_nxt0 <= s3_nxt[0]; s4_nxt1 <= s3_nxt[1]; s4_nxt2 <= s3_nxt[2];
        s4_nxt3 <= s3_nxt[3]; s4_nxt4 <= s3_nxt[4]; s4_nxt5 <= s3_nxt[5];
    end

    // ------------------------------------------------------------ S4: накопление и сброс
    reg signed [W-1:0] a_ei [0:NMUX-1], a_eq [0:NMUX-1], a_pi [0:NMUX-1],
                       a_pq [0:NMUX-1], a_li [0:NMUX-1], a_lq [0:NMUX-1];
    reg signed [W-1:0] r_ei [0:NMUX-1], r_eq [0:NMUX-1], r_pi [0:NMUX-1],
                       r_pq [0:NMUX-1], r_li [0:NMUX-1], r_lq [0:NMUX-1];
    reg [31:0]     r_t  [0:NMUX-1];
    reg [NMUX-1:0] ready, ovr;
    wire signed [W-1:0] n_ei = a_ei[s4_slot] + s4_add0;
    wire signed [W-1:0] n_eq = a_eq[s4_slot] + s4_add1;
    wire signed [W-1:0] n_pi = a_pi[s4_slot] + s4_add2;
    wire signed [W-1:0] n_pq = a_pq[s4_slot] + s4_add3;
    wire signed [W-1:0] n_li = a_li[s4_slot] + s4_add4;
    wire signed [W-1:0] n_lq = a_lq[s4_slot] + s4_add5;
    always @(posedge clk) begin
        if (!s4_en) begin
            a_ei[s4_slot] <= 0; a_eq[s4_slot] <= 0; a_pi[s4_slot] <= 0;
            a_pq[s4_slot] <= 0; a_li[s4_slot] <= 0; a_lq[s4_slot] <= 0;
        end else if (s4_v) begin
            a_ei[s4_slot] <= s4_dump ? s4_nxt0 : n_ei;
            a_eq[s4_slot] <= s4_dump ? s4_nxt1 : n_eq;
            a_pi[s4_slot] <= s4_dump ? s4_nxt2 : n_pi;
            a_pq[s4_slot] <= s4_dump ? s4_nxt3 : n_pq;
            a_li[s4_slot] <= s4_dump ? s4_nxt4 : n_li;
            a_lq[s4_slot] <= s4_dump ? s4_nxt5 : n_lq;
        end
        if (s4_v && s4_dump) begin
            r_ei[s4_slot] <= n_ei; r_eq[s4_slot] <= n_eq; r_pi[s4_slot] <= n_pi;
            r_pq[s4_slot] <= n_pq; r_li[s4_slot] <= n_li; r_lq[s4_slot] <= n_lq;
            r_t[s4_slot]  <= s4_t;
        end
    end
    wire [CLOG-1:0] rs = b_addr[4 +: CLOG];
    wire rd_ch = b_re && !b_addr[8];
    // флаги готовности и переполнения: маски слотов (сброс — дешифрирован на такт раньше)
    wire [NMUX-1:0] rclr = (rd_ch && b_addr[3:0] == 4'd14) ? onehot(rs) : {NMUX{1'b0}};
    wire [NMUX-1:0] oclr = (rd_ch && b_addr[3:0] == 4'd15) ? onehot(rs) : {NMUX{1'b0}};
    always @(posedge clk) begin
        if (rst) begin
            ready <= 0; ovr <= 0;
        end else begin
            ready <= (ready & ~rclr) | s4_dmask;
            ovr   <= (ovr & ~oclr) | (s4_dmask & ready);
        end
    end
    assign irq = |ready;

    // ------------------------------------------------------------ чтение регистров
    always @(posedge clk) begin
        if (b_addr[8])
            bus_rdata <= (b_addr[3:0] == 4'd2) ? {{(32-NMUX){1'b0}}, ready} :
                         (b_addr[3:0] == 4'd3) ? {31'd0, (w_cnt != 0) | pw_v} : 32'd0;
        else case (b_addr[3:0])
            4'd8:  bus_rdata <= r_ei[rs];
            4'd9:  bus_rdata <= r_eq[rs];
            4'd10: bus_rdata <= r_pi[rs];
            4'd11: bus_rdata <= r_pq[rs];
            4'd12: bus_rdata <= r_li[rs];
            4'd13: bus_rdata <= r_lq[rs];
            4'd14: bus_rdata <= r_t[rs];
            4'd15: bus_rdata <= {30'd0, ovr[rs], ready[rs]};
            default: bus_rdata <= 32'd0;
        endcase
    end
endmodule
`default_nettype wire
