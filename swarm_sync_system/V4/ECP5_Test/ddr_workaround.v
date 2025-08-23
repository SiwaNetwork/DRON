module ddr_data_recovery (
    input  wire        clk_internal,     // Internal 190 MHz clock
    input  wire        rst,              // Active-high reset
    input  wire        sdr_rxclk,        // DDR clock (64 MHz)
    input  wire        sdr_data,         // DDR data line
    input  wire        clk_out_domain,   // Output clock domain (e.g., 95 MHz)
    output reg  [1:0]  data_out,         // Recovered DDR data: {data_out_0, data_out_1}
    output reg         data_valid        // Strobe signal for new data
);

    // Temporary registers for DDR edge detection
    reg sdr_rxclk_last, data_rising, data_falling;

    // Temporary storage for DDR data
    reg data_rising_capture, data_falling_capture;

    // FIFO signals
    reg [1:0] fifo_data;
    reg       fifo_wr_en, fifo_rd_en;
    wire [1:0] fifo_out;
    wire       fifo_empty, fifo_full;

    // Instantiate the FIFO for clock domain crossing
    fifo_dc_2in_2out fifo_inst (
        .Data(fifo_data),        // Data to write to FIFO
        .WrClock(clk_internal),  // Write clock domain
        .RdClock(clk_out_domain),// Read clock domain
        .WrEn(fifo_wr_en),       // Write enable
        .RdEn(fifo_rd_en),       // Read enable
        .Reset(rst),             // Global reset
        .RPReset(1'b0),          // Reset read pointer (not used here)
        .Q(fifo_out),            // Data read from FIFO
        .Empty(fifo_empty),      // FIFO empty flag
        .Full(fifo_full)         // FIFO full flag
    );

    // Edge detection for sdr_rxclk
    always @(posedge clk_internal or posedge rst) begin
        if (rst) begin
            sdr_rxclk_last <= 1'b0;
            data_rising <= 1'b0;
            data_falling <= 1'b0;
        end else begin
            data_rising <= ~sdr_rxclk_last & sdr_rxclk;  // Rising edge detection
            data_falling <= sdr_rxclk_last & ~sdr_rxclk;// Falling edge detection
            sdr_rxclk_last <= sdr_rxclk;                // Update last clock state
        end
    end

    // Capture data on rising and falling edges
    always @(posedge clk_internal or posedge rst) begin
        if (rst) begin
            data_rising_capture <= 1'b0;
            data_falling_capture <= 1'b0;
            fifo_wr_en <= 1'b0;
        end else begin
            fifo_wr_en <= 1'b0; // Default to no write

            if (data_rising) begin
                data_rising_capture <= sdr_data; // Capture data on rising edge
            end

            if (data_falling) begin
                data_falling_capture <= sdr_data; // Capture data on falling edge

                // Write both rising and falling edge data to FIFO
                if (!fifo_full) begin
                    fifo_data <= {data_rising_capture, sdr_data};
                    fifo_wr_en <= 1'b1; // Write enable on complete DDR data
                end
            end
        end
    end

    // Read data from FIFO and generate strobe
    always @(posedge clk_out_domain or posedge rst) begin
        if (rst) begin
            data_out <= 2'b00;
            data_valid <= 1'b0;
            fifo_rd_en <= 1'b0;
        end else begin
            fifo_rd_en <= !fifo_empty; // Enable read when FIFO is not empty
            data_valid <= !fifo_empty; // Assert valid strobe when data is available

            if (!fifo_empty) begin
                data_out <= fifo_out; // Read data from FIFO
            end
        end
    end

endmodule



module bit_duplicator (
    input  wire [15:0] in_data,   // 16-bit input
    output wire [31:0] out_data   // 32-bit output
);

    // Duplicate each bit
    assign out_data = { {2{in_data[15]}}, {2{in_data[14]}}, {2{in_data[13]}}, {2{in_data[12]}},
                        {2{in_data[11]}}, {2{in_data[10]}}, {2{in_data[9]}},  {2{in_data[8]}},
                        {2{in_data[7]}},  {2{in_data[6]}},  {2{in_data[5]}},  {2{in_data[4]}},
                        {2{in_data[3]}},  {2{in_data[2]}},  {2{in_data[1]}},  {2{in_data[0]}} };

endmodule

