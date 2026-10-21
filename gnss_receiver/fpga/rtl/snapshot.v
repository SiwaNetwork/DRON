// =============================================================================
// МГП-8. Буфер снимка отсчётов для захвата сигналов (БПФ-поиск в МК).
// Записывает LEN отсчётов (кратно 8, ≤ 65536) одного ВЧ-канала во внутреннем формате
// {sI, mI, sQ, mQ}: 8 отсчётов в слове, первый — в младших битах. Запуск — сразу или с отсчёта,
// младшие 32 бит номера которого равны T_START. Память — общий пул ускорителя захвата (acq_fft.v):
// слово wa — пары пул[2·wa[12:10]], пул[2·wa[12:10] + 1]; пуск запрещён, пока занят ускоритель.
// =============================================================================
`default_nettype none

module snapshot (
    input  wire        clk,
    input  wire        rst,
    input  wire        smp_stb,
    input  wire [31:0] smp_data,
    input  wire [63:0] smp_count,
    input  wire        arm,              // строб запуска
    input  wire        inhibit,          // запрет пуска (ускоритель захвата занят)
    input  wire [2:0]  ch,
    input  wire        at_time,
    input  wire [31:0] t_start,
    input  wire [16:0] len,
    output reg         busy,
    output reg         done,             // строб завершения
    output reg  [31:0] t0,               // номер первого отсчёта (мл. 32 бит)
    output wire        mem_we,           // запись слова в пул
    output wire [12:0] mem_wa,
    output wire [31:0] mem_wd
);
    reg        rec;
    reg [2:0]  ch_r;
    reg        at_r;
    reg [31:0] ts_r;
    reg [16:0] left;
    reg [12:0] wa;
    reg [27:0] sr;
    reg [2:0]  nib;
    reg        we;
    reg [31:0] wd;
    always @(posedge clk) begin
        done <= 1'b0;
        we   <= 1'b0;
        if (rst) begin
            busy <= 1'b0; rec <= 1'b0;
        end else begin
            if (arm && !busy && !inhibit) begin
                busy <= 1'b1; rec <= 1'b0; ch_r <= ch; at_r <= at_time; ts_r <= t_start;
                left <= len; wa <= 0; nib <= 0;
            end else if (busy && smp_stb) begin
                if (!rec && (!at_r || smp_count[31:0] == ts_r)) begin
                    rec <= 1'b1; t0 <= smp_count[31:0];
                end
                if (rec || !at_r || smp_count[31:0] == ts_r) begin
                    nib <= nib + 1'b1;
                    if (nib == 3'd7) begin
                        we <= 1'b1; wd <= {smp_data[4*ch_r +: 4], sr};
                    end else
                        sr <= {smp_data[4*ch_r +: 4], sr[27:4]};
                    left <= left - 1'b1;
                    if (left == 17'd1) begin busy <= 1'b0; rec <= 1'b0; done <= 1'b1; end
                end
            end
            if (we) wa <= wa + 1'b1;
        end
    end
    assign mem_we = we;
    assign mem_wa = wa;
    assign mem_wd = wd;
endmodule
`default_nettype wire
