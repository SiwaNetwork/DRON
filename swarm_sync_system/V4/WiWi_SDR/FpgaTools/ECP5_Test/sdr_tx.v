
module ddr_stream_generator (
    input  wire        clk,         // Input clock (double data rate)
    input  wire        rst,         // Reset signal
    output wire        ddr_data_out // DDR output data
);

    // Parameters
    localparam [31:0] FIXED_PATTERN = 32'h7FFFBFFF; // 01 in top 2 bits of top 16 bits, 10 in top 2 bits of bottom 16 bits, for I and Q sync
	//localparam [31:0] FIXED_PATTERN = 32'ha5a5a5a5;
    // Internal signals
    reg [31:0] shift_reg; // Shift register to hold the pattern
    wire ddr_bit0, ddr_bit1; // Two bits to feed into the ODDRX1F primitive
    reg [3:0] bit_counter; // Counter to track shifts (4 bits for 16 cycles)

    // Shift register logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= ~FIXED_PATTERN; // Load the fixed pattern on reset, INVERTED BECAUSE P/N SWAP
            bit_counter <= 4'd15;      // Reset the bit counter (16 cycles)
        end else begin
            // Shift the register left by 2 bits
            shift_reg <= {shift_reg[29:0], shift_reg[31:30]};
            // Decrement the bit counter
            if (bit_counter == 4'd0) begin
                shift_reg <= ~FIXED_PATTERN; // Reload the pattern when done, INVERTED BECAUSE P/N SWAP
                bit_counter <= 4'd15;      // Reset the bit counter
            end else begin
                bit_counter <= bit_counter - 1;
            end
        end
    end

    // Assign the MSB 2 bits to the DDR inputs
    assign ddr_bit0 = shift_reg[31]; // Most significant bit
    assign ddr_bit1 = shift_reg[30]; // Next significant bit

    // ODDRX1F primitive instantiation
    ODDRX1F oddr_inst (
        .D0(ddr_bit0),       // Data input for first half-cycle
        .D1(ddr_bit1),       // Data input for second half-cycle
        .SCLK(clk),          // DDR clock input
		.RST(rst),
        .Q(ddr_data_out)     // DDR output
    );

endmodule
