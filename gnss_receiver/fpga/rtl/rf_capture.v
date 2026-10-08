// =============================================================================
// МГП-8. Приём отсчётов 8 ВЧ-каналов MAX2771 (I1, I0, Q1, Q0 — формат «знак/модуль»).
//
// clk = 96 МГц = 4 × частота дискретизации (ФАПЧ от тактового сигнала АЦП, фаза фиксирована).
// Выводы регистрируются каждый такт; отсчёт берётся в такте с номером cap_phase внутри периода
// (подстройка под окно достоверности данных). Счётчик времени t96 — число тактов 96 МГц:
// отсчёт n взят в момент t96 = 4n + cap_phase (с точностью до постоянной задержки входа).
//
// Внутренний формат (коррелятор, снимок): канал k — биты [4k+3:4k] = {sI, mI, sQ, mQ},
// знак 1 = минус. Знак Q инвертирован относительно вывода Q1 — так же, как в ПО PocketSDR
// (sdr_rcv.c: valQ_2b = {−1, −3, 1, 3}), что даёт правильное направление спектра.
// Формат USB (PocketSDR FE 8CH, RAW32): байт b = {канал 2b+1, канал 2b}, полубайт канала =
// {Q1, Q0, I1, I0} — значения выводов без изменений.
// =============================================================================
`default_nettype none

module rf_capture (
    input  wire        clk,
    input  wire        rst,
    input  wire [1:0]  cap_phase,
    input  wire [7:0]  pin_i1, pin_i0, pin_q1, pin_q0,   // каналы A..H = биты 0..7
    output reg         smp_stb,          // строб отсчёта (раз в 4 такта)
    output reg  [31:0] smp_data,         // внутренний формат
    output reg  [63:0] smp_count,        // номер отсчёта (действителен при smp_stb)
    output reg  [31:0] usb_word,         // формат PocketSDR RAW32 (меняется вместе с smp_stb)
    output reg  [63:0] t96               // счётчик тактов 96 МГц
);
    (* syn_useioff = 1 *) reg [7:0] r_i1, r_i0, r_q1, r_q0;
    always @(posedge clk) begin
        r_i1 <= pin_i1; r_i0 <= pin_i0; r_q1 <= pin_q1; r_q0 <= pin_q0;
    end
    integer k;
    reg [61:0] n;
    always @(posedge clk) begin
        smp_stb <= 1'b0;
        if (rst) begin
            t96 <= 64'd0; n <= 62'd0;
        end else begin
            t96 <= t96 + 1'b1;
            if (t96[1:0] == cap_phase) begin
                smp_stb   <= 1'b1;
                smp_count <= {2'b00, n};
                n <= n + 1'b1;
                for (k = 0; k < 8; k = k + 1) begin
                    smp_data[4*k +: 4] <= {r_i1[k], r_i0[k], ~r_q1[k], r_q0[k]};
                    usb_word[4*k +: 4] <= {r_q1[k], r_q0[k], r_i1[k], r_i0[k]};
                end
            end
        end
    end
endmodule
`default_nettype wire
