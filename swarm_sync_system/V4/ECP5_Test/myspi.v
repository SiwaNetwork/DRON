

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
	
	wire data_strobe_sync;
	wire [DATA_WIDTH-1:0] data_in_sync;
		
	pipeline #(
		.DATA_WIDTH(1),
		.STAGES(2)
	) data_strobe_pipeline (
		.clk(clk),
		.rst(rst),
		.data_in(data_strobe),
		.data_out(data_strobe_sync)
	);

		
	pipeline #(
		.DATA_WIDTH(16),
		.STAGES(2)
	) data_in_pipeline (
		.clk(clk),
		.rst(rst),
		.data_in(data_in),
		.data_out(data_in_sync)
	);



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
            if (data_strobe_sync && !spi_busy) begin
                // Load new data into the shift register and start SPI transaction
                shift_reg <= data_in_sync;
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









module data_serializer (
    input wire clk,             // Clock input
    input wire rst,             // Reset input
    input wire [15:0] data_in,  // 16-bit parallel data input
    input wire data_strobe,     // Load signal to load data_in into the shift register
    output wire clk_out,         // Clock output for shifting data (conditionally enabled)
    output reg data_out         // Serial data output
);

    reg [15:0] shift_reg;
	reg clk_out_enable;
    reg [5:0] bit_counter;
	
	reg [15:0] test_counter; 
	
    // State encoding
    parameter STATE_A = 1'b0, STATE_B = 1'b1;
	// Current and next state variables
    reg state, next_state;
	reg data_strobe_d;  // Delayed data_strobe to detect rising edge
	
    // Next state logic
    always @(*) begin
        next_state = state; // Default is to stay in the current state
        if (data_strobe && !data_strobe_d) begin  // Detect rising edge of data_strobe
            case (state)
                STATE_A: next_state = STATE_B;
                STATE_B: next_state = STATE_A;
                default: next_state = STATE_A;
            endcase
        end
    end
	
    // State transition logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= STATE_A;
            data_strobe_d <= 0;
        end else begin
            state <= next_state;
            data_strobe_d <= data_strobe;  // Capture the data_strobe
        end
    end
	

	
	// clk_out_enable control 
	always @(negedge clk or posedge rst) begin
		if (rst) begin
			clk_out_enable <= 1'b0;
		//end else if ( bit_counter == 16 ) begin
		end else if ( bit_counter != 0 ) begin
			clk_out_enable <= 1'b1;
		//end else if ( bit_counter == 0 ) begin
		end else begin
			clk_out_enable <= 1'b0;
		end
	end
	

	assign clk_out = (clk_out_enable) ? clk : 0;	
	

    // Load data into the shift register on the data_strobe signal
	// shift data out on rising edge, use CPOL=0 / CPHA=1
	// SX1257 uses CPOL=0/CPHA=0 , so its different from SX1257
	// but makes it easier
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_counter <= 6'b0;
			data_out <= 0;
			shift_reg <= 16'b0;
			test_counter <= 16'b0;
        end else if (data_strobe) begin
            bit_counter <= 6'd16;
			//shift_reg <= { 3'd0  , data_in}; // just add leading zeroes
			
			
			shift_reg <= data_in; // sign extend -> THIS IS MAIN PATH
			//shift_reg <= test_counter;
			test_counter <= test_counter + 1;
			
			//

			/*
			if ( state == STATE_A ) begin
				shift_reg <= 16'hdead; // hack constant to verify getting to stm proper
			end else begin
				shift_reg <= 16'hbeef;
			end
			*/
        end else if ( bit_counter != 0 ) begin
			bit_counter <= bit_counter - 1'b1;
			data_out <= shift_reg[0];
            shift_reg <= {1'b0, shift_reg[15:1]};
		end else begin
			data_out <= 0;
		end
    end


endmodule






module ecp5_spi_master_top (
    input  wire        i_clk_80,   // 80 MHz
    input  wire        i_rst_n,    // async reset (active low)
    input  wire        i_start,    // start shifting 16 bits
    input  wire [15:0] i_data,     // the 16 bits to send

    output wire        o_sclk,
    output wire        o_mosi,
    output reg         o_busy      // '1' while shifting out data
);

	
    reg [15:0] shift_reg;
    reg [5:0] bit_counter;
	
	// Generate SCLK from incoming clock as DDR
	ODDRX1F sclk_ddr (
		.D0( bit_counter == 0 ? 1'b0 : 1'b1 ), // if no bits, set to zero
		.D1(1'b0),
		.SCLK(i_clk_80),
		.RST(!i_rst_n),
		.Q(o_sclk)
	);
	
	ODDRX1F mosi_ddr (
		.D0( bit_counter == 0 ? 1'b0 : shift_reg[0] ),
		.D1( bit_counter == 0 ? 1'b0 : shift_reg[0] ),
		.SCLK(i_clk_80),
		.RST(!i_rst_n),
		.Q(o_mosi)
	);
	
	
	always @(posedge i_clk_80 or negedge i_rst_n) begin
		if ( !i_rst_n ) begin
			shift_reg <= 16'd0;
			bit_counter <= 6'd0;
		end else if ( i_start && bit_counter == 0 ) begin
			// can shift
			shift_reg <= i_data;
			bit_counter <= 6'd16;
		end else if ( bit_counter != 0 ) begin
			shift_reg <= {1'b0, shift_reg[15:1]};
			bit_counter <= bit_counter - 1'b1;
		end
		
	end
endmodule






