

module pipeline #(
    parameter DATA_WIDTH = 32, // Width of the data
    parameter STAGES = 2       // Number of pipeline stages
)(
    input  wire                   clk,      // Clock signal
    input  wire                   rst,      // Reset signal (active high)
    input  wire [DATA_WIDTH-1:0]  data_in,  // Input data
    output wire [DATA_WIDTH-1:0]  data_out  // Output data
);

    // Internal register array for the pipeline stages
    reg [DATA_WIDTH-1:0] pipeline_reg [STAGES-1:0];

    // Generate pipeline stages
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all pipeline stages to 0
            for (i = 0; i < STAGES; i = i + 1) begin
                pipeline_reg[i] <= {DATA_WIDTH{1'b0}};
            end
        end else begin
            // Shift data through the pipeline
            pipeline_reg[0] <= data_in;  // First stage
            for (i = 1; i < STAGES; i = i + 1) begin
                pipeline_reg[i] <= pipeline_reg[i-1]; // Subsequent stages
            end
        end
    end

    // Assign the last stage to the output
    assign data_out = pipeline_reg[STAGES-1];

endmodule

















/*

module parallel_to_serial (
    input wire clk,
	input wire half_clk,
    input wire reset,
    input wire [15:0] parallel_data,
    input wire data_valid,
    output wire serial_data,
    output wire serial_clock
);
	// make 16-bit data into 32-bit at full clock
	bit_duplicator clock_duplicator (
		.in_data(16'ha5a5
	);


	// two FIFO DC blocks, one for clock , one for data
	// THIS WONT WORK, will always end clock on a high, unless you do 33 bits or something painful
	wire clock_empty;
	fifo_dc_32in_1out clock_fifo (
		.Data(),
		.WrClock(),
		.RdClock(),
		.WrEn(),
		.RdEn(),
		.Reset(),
		.RPReset(),
		.Q(serial_clock),
		.Empty(),
		.Full()
	);




    reg [15:0] shift_register; // Holds the data to be shifted out
    reg [5:0] bit_counter;     // Tracks the number of bits shifted out (needs 6 bits for 0-32 range)
    reg serializing;           // Indicates whether the module is currently serializing data


	// only part that needs to be clocked at clk
	// generate serial clock when serializing
	always @(posedge clk or posedge reset) begin
		if ( reset ) begin
			serial_clock <= 0;
		end else begin
			if (data_valid && !serializing) begin
				serial_clock <= 0;
			end
			if ( serializing) begin
				serial_clock <= ~serial_clock;
			end
			if (bit_counter == 0 && serial_clock) begin
				serial_clock <= 0;
			end
		end
	end


    always @(posedge half_clk or posedge reset) begin
        if (reset) begin
            serial_data <= 0;
            shift_register <= 16'd0;
            bit_counter <= 6'd0;
            serializing <= 1'b0;
        end else begin
            if (data_valid && !serializing) begin
                // Load the parallel data into the shift register
                shift_register <= parallel_data;
                bit_counter <= 6'd16; // 32 bits to shift out
                serializing <= 1'b1;
                //serial_clock <= 0; // Ensure serial_clock starts low
            end

            if (serializing) begin
				// LSB first
				serial_data <= shift_register[0];
				shift_register <= {1'b0, shift_register[15:1] };
				bit_counter <= bit_counter - 1;

                // Stop serializing after all bits are shifted out
                if (bit_counter == 0) begin
                    serializing <= 1'b0;
                    //serial_clock <= 0; // Ensure serial_clock ends low
                end
            end
        end
    end

endmodule
*/
















module spi_generator #(
    parameter DATA_WIDTH = 16,     // Width of the parallel input data
    parameter SPI_CLK_DIV = 1     // Divide system clock to generate SPI clock
)(
    input  wire                  clk,       // System clock
    input  wire                  rst,       // Active-high reset
    input  wire [DATA_WIDTH-1:0] data_in,   // Parallel input data
    input  wire                  data_strobe, // Strobe signal for parallel input
    output reg                   spi_clk,   // SPI clock
    output reg                   spi_mosi,  // SPI data line (Master Out Slave In)
    output reg                   spi_busy   // SPI busy signal
);

    // Internal signals
    reg [DATA_WIDTH-1:0] shift_reg; // Shift register for serializing data
    reg [$clog2(DATA_WIDTH):0] bit_count; // Counter for bits
    reg [SPI_CLK_DIV-1:0] clk_div; // Clock divider for SPI clock
    reg spi_clk_enable; // SPI clock enable

    // Reset and initialization
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            spi_clk <= 1'b0;
            clk_div <= 0;
        end else if (spi_clk_enable) begin
            // SPI clock toggles at SPI clock frequency
            clk_div <= clk_div + 1;
            if (clk_div == SPI_CLK_DIV-1) begin
                spi_clk <= ~spi_clk;
                clk_div <= 0;
            end
        end else begin
            spi_clk <= 1'b0;
            clk_div <= 0;
        end
    end

    // Shift register and SPI state machine
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            spi_mosi <= 1'b0;
            shift_reg <= 0;
            bit_count <= 0;
            spi_clk_enable <= 1'b0;
            spi_busy <= 1'b0;
        end else begin
            if (data_strobe && !spi_busy) begin
                // Load new data into the shift register and start SPI transaction
                shift_reg <= data_in;
                bit_count <= DATA_WIDTH;
                spi_clk_enable <= 1'b1;
                spi_busy <= 1'b1;
            end else if (spi_clk && spi_clk_enable && spi_busy) begin
                // Shift out data on the rising edge of the SPI clock
                spi_mosi <= shift_reg[0]; // LSB first
                shift_reg <= shift_reg >> 1;       // Shift right
                bit_count <= bit_count - 1;

                if (bit_count == 1) begin
                    // Complete the transaction
                    spi_clk_enable <= 1'b0;
                    spi_busy <= 1'b0;
                end
            end
        end
    end

endmodule









