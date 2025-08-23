module ddr_input (
    input wire clk,           
    input wire ddr_data_in,       // Single-ended DDR data input
    output reg [1:0] data_out     // Captured DDR data output
);

    wire clk;                     // Internal single-ended clock signal

    // Differential clock buffer for ECP5
    wire clk_ibuf, clk_nbuf;
    IB u_ib_p (
        .I(clk_p),
        .O(clk_ibuf)
    );

    IB u_ib_n (
        .I(clk_n),
        .O(clk_nbuf)
    );

    IBUF u_ibuf (
        .I(clk_ibuf),
        .IB(clk_nbuf),
        .O(clk)
    );

    // Register the captured data
    always @(posedge clk) begin
        data_out <= ddr_data;
    end

endmodule
