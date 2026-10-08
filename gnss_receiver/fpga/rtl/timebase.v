// =============================================================================
// МГП-8. Шкала времени: 1PPS, метки внешних событий, вход опоры, периодическое прерывание.
//
// Время — счётчик t96 тактов 96 МГц (шаг 10,4 нс), см. rf_capture.v.
//  - 1PPS: программа записывает момент следующего импульса (PPS_T, 64 бит) и длительность;
//    импульс формируется на выходе в такте t96 == PPS_T. Программа вычисляет PPS_T по решению
//    навигационной задачи и пишет его после каждого импульса (погрешность квантования — qErr).
//  - EXTINT и REF: вход синхронизируется двумя триггерами; метка = t96 − 2 (задержка
//    синхронизатора исключена). Для REF дополнительно считается число фронтов (частотомер
//    опоры 10 МГц: разность счётчика за известный интервал t96).
//  - TIC: прерывание каждые TIC_PERIOD отсчётов (эпоха измерений).
// =============================================================================
`default_nettype none

module timebase (
    input  wire        clk,
    input  wire        rst,
    input  wire [63:0] t96,
    input  wire        smp_stb,
    // настройка
    input  wire [63:0] pps_t,            // момент импульса
    input  wire        pps_arm,          // строб: PPS_T записан (взвести)
    input  wire [23:0] pps_width,        // длительность, тактов
    input  wire        pps_pol,          // 1 — активный низкий уровень
    input  wire        ext_edge,         // 0 — передний фронт, 1 — задний
    input  wire [31:0] tic_period,       // отсчётов, 0 — выкл.
    // входы (асинхронные)
    input  wire        ext_in,
    input  wire        ref_in,
    // результаты
    output wire        pps_out,
    output reg         pps_armed,
    output reg         pps_ev,           // строб: импульс выдан
    output reg  [63:0] ext_t,
    output reg         ext_ev,
    output reg  [63:0] ref_t,
    output reg  [31:0] ref_cnt,
    output reg         ref_ev,
    output reg         tic_ev,
    output reg  [63:0] tic_t
);
    // ------------------------------------------------------------ 1PPS
    reg        pps_on;
    reg [23:0] pps_cnt;
    always @(posedge clk) begin
        pps_ev <= 1'b0;
        if (rst) begin
            pps_armed <= 1'b0; pps_on <= 1'b0; pps_cnt <= 0;
        end else begin
            if (pps_arm) pps_armed <= 1'b1;
            if (pps_armed && t96 == pps_t) begin
                pps_on <= 1'b1; pps_cnt <= pps_width; pps_armed <= 1'b0; pps_ev <= 1'b1;
            end else if (pps_on) begin
                if (pps_cnt <= 24'd1) pps_on <= 1'b0;
                pps_cnt <= pps_cnt - 1'b1;
            end
        end
    end
    assign pps_out = pps_on ^ pps_pol;

    // ------------------------------------------------------------ EXTINT, REF
    (* async_reg = "true" *) reg [2:0] ext_s, ref_s;
    always @(posedge clk) begin
        ext_s <= {ext_s[1:0], ext_in};
        ref_s <= {ref_s[1:0], ref_in};
        ext_ev <= 1'b0; ref_ev <= 1'b0;
        if (rst) begin
            ref_cnt <= 32'd0;
        end else begin
            if (ext_edge ? (ext_s[2] & ~ext_s[1]) : (~ext_s[2] & ext_s[1])) begin
                ext_t <= t96 - 64'd2; ext_ev <= 1'b1;
            end
            if (~ref_s[2] & ref_s[1]) begin
                ref_t <= t96 - 64'd2; ref_ev <= 1'b1; ref_cnt <= ref_cnt + 1'b1;
            end
        end
    end

    // ------------------------------------------------------------ TIC
    // событие — каждые tic_period отсчётов; сравнение на равенство с period − 1 вычисляется
    // заранее (регистр; отсчёты приходят раз в 4 такта), смена периода сбрасывает счётчик
    reg [31:0] tic_cnt, tic_pm1, tic_prev;
    reg        tic_eq;
    always @(posedge clk) begin
        tic_ev   <= 1'b0;
        tic_pm1  <= tic_period - 32'd1;
        tic_prev <= tic_period;
        tic_eq   <= (tic_cnt == tic_pm1);
        if (rst || tic_period == 0 || tic_period != tic_prev) begin
            tic_cnt <= 32'd0;
        end else if (smp_stb) begin
            if (tic_eq) begin
                tic_cnt <= 32'd0; tic_ev <= 1'b1; tic_t <= t96;
            end else
                tic_cnt <= tic_cnt + 1'b1;
        end
    end
endmodule
`default_nettype wire
