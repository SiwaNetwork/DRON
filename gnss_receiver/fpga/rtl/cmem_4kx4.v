// =============================================================================
// МГП-8. Память кода канала коррелятора: EBR 4K×4 (DP16KD), порт A — чтение, порт B — чтение
// или запись; задержка чтения 2 такта (регистр EBR + выходной регистр OUTREG — малое время
// выборки, важно при разнесённых по кристаллу блоках). Для моделирования — поведенческая модель.
// =============================================================================
`default_nettype none

module cmem_4kx4 (
    input  wire        clk,
    input  wire [11:0] a_addr,
    output wire [3:0]  a_dout,
    input  wire [11:0] b_addr,
    input  wire        b_we,
    input  wire [3:0]  b_din,
    output wire [3:0]  b_dout
);
`ifdef SYNTHESIS
    wire [17:0] doa, dob;
    DP16KD #(
        .DATA_WIDTH_A(4), .DATA_WIDTH_B(4), .REGMODE_A("OUTREG"), .REGMODE_B("OUTREG"),
        .WRITEMODE_A("NORMAL"), .WRITEMODE_B("READBEFOREWRITE"), .RESETMODE("SYNC"),
        .ASYNC_RESET_RELEASE("SYNC"), .CSDECODE_A("0b000"), .CSDECODE_B("0b000"), .GSR("DISABLED")
    ) u_ebr (
        .CLKA(clk), .CEA(1'b1), .OCEA(1'b1), .WEA(1'b0), .RSTA(1'b0),
        .CSA0(1'b0), .CSA1(1'b0), .CSA2(1'b0),
        .ADA0(1'b0),
        .ADA1(1'b0),
        .ADA2(a_addr[0]),
        .ADA3(a_addr[1]),
        .ADA4(a_addr[2]),
        .ADA5(a_addr[3]),
        .ADA6(a_addr[4]),
        .ADA7(a_addr[5]),
        .ADA8(a_addr[6]),
        .ADA9(a_addr[7]),
        .ADA10(a_addr[8]),
        .ADA11(a_addr[9]),
        .ADA12(a_addr[10]),
        .ADA13(a_addr[11]),
        .DIA0(1'b0),
        .DIA1(1'b0),
        .DIA2(1'b0),
        .DIA3(1'b0),
        .DIA4(1'b0),
        .DIA5(1'b0),
        .DIA6(1'b0),
        .DIA7(1'b0),
        .DIA8(1'b0),
        .DIA9(1'b0),
        .DIA10(1'b0),
        .DIA11(1'b0),
        .DIA12(1'b0),
        .DIA13(1'b0),
        .DIA14(1'b0),
        .DIA15(1'b0),
        .DIA16(1'b0),
        .DIA17(1'b0),
        .CLKB(clk), .CEB(1'b1), .OCEB(1'b1), .WEB(b_we), .RSTB(1'b0),
        .CSB0(1'b0), .CSB1(1'b0), .CSB2(1'b0),
        .ADB0(1'b0),
        .ADB1(1'b0),
        .ADB2(b_addr[0]),
        .ADB3(b_addr[1]),
        .ADB4(b_addr[2]),
        .ADB5(b_addr[3]),
        .ADB6(b_addr[4]),
        .ADB7(b_addr[5]),
        .ADB8(b_addr[6]),
        .ADB9(b_addr[7]),
        .ADB10(b_addr[8]),
        .ADB11(b_addr[9]),
        .ADB12(b_addr[10]),
        .ADB13(b_addr[11]),
        .DIB0(b_din[0]),
        .DIB1(b_din[1]),
        .DIB2(b_din[2]),
        .DIB3(b_din[3]),
        .DIB4(1'b0),
        .DIB5(1'b0),
        .DIB6(1'b0),
        .DIB7(1'b0),
        .DIB8(1'b0),
        .DIB9(1'b0),
        .DIB10(1'b0),
        .DIB11(1'b0),
        .DIB12(1'b0),
        .DIB13(1'b0),
        .DIB14(1'b0),
        .DIB15(1'b0),
        .DIB16(1'b0),
        .DIB17(1'b0),
        .DOA0(doa[0]),
        .DOA1(doa[1]),
        .DOA2(doa[2]),
        .DOA3(doa[3]),
        .DOA4(doa[4]),
        .DOA5(doa[5]),
        .DOA6(doa[6]),
        .DOA7(doa[7]),
        .DOA8(doa[8]),
        .DOA9(doa[9]),
        .DOA10(doa[10]),
        .DOA11(doa[11]),
        .DOA12(doa[12]),
        .DOA13(doa[13]),
        .DOA14(doa[14]),
        .DOA15(doa[15]),
        .DOA16(doa[16]),
        .DOA17(doa[17]),
        .DOB0(dob[0]),
        .DOB1(dob[1]),
        .DOB2(dob[2]),
        .DOB3(dob[3]),
        .DOB4(dob[4]),
        .DOB5(dob[5]),
        .DOB6(dob[6]),
        .DOB7(dob[7]),
        .DOB8(dob[8]),
        .DOB9(dob[9]),
        .DOB10(dob[10]),
        .DOB11(dob[11]),
        .DOB12(dob[12]),
        .DOB13(dob[13]),
        .DOB14(dob[14]),
        .DOB15(dob[15]),
        .DOB16(dob[16]),
        .DOB17(dob[17])
    );
    assign a_dout = doa[3:0];
    assign b_dout = dob[3:0];
`else
    reg [3:0] mem [0:4095];
    reg [3:0] a1, a2, b1, b2;
    always @(posedge clk) begin
        a1 <= mem[a_addr]; a2 <= a1;
        if (b_we) mem[b_addr] <= b_din;
        b1 <= mem[b_addr]; b2 <= b1;
    end
    assign a_dout = a2;
    assign b_dout = b2;
`endif
endmodule
`default_nettype wire
