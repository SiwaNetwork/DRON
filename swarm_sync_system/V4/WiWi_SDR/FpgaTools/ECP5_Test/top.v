module top(	
	output wire fpga_led,
	output wire fpga_neopixel,
	// input dpll_clkout6_p, // 10MHz clock -> V3 not connected
	input wire dpll_clkout2,  // 8MHz clock from DPLL as of 12/7/2024
	input wire dpll_clkout0, // 10MHz clock from DPLL as of 12/8/2024
	
	input wire sdr_rx_wifi,  /* synthesis IO_TYPES="LVDS"*/
	input wire sdr_rx_subg,  /* synthesis IO_TYPES="LVDS"*/
	input wire sdr_rxclk, /* synthesis IO_TYPES="LVDS"*/
	output wire sdr_txclk, /* synthesis IO_TYPES="LVDS"*/
	output wire sdr_txdata, /* synthesis IO_TYPES="LVDS"*/

	
	/****** I2C inteface ********/
	inout wire fpga_sda,
	inout wire fpga_scl,
	
	/****** SPI interfaces for I/Q data streaming *******/
	// FPGA is master for these 
	// SPI1 for Sub-GHz I 
	output wire spi1_sck,
	output wire spi1_mosi,
	//input wire spi1_miso,
	
	
	// SPI2 for Sub-GHz Q
	output wire spi2_sck,
	output wire spi2_mosi,
	//input wire spi2_miso,
	
	input wire stm_fpga_spare1, // using this spare as Sub-GHz serializer gating
	
	// SPI3 for 2.4GHz I
	output wire spi3_sck,
	output wire spi3_mosi,
	//input wire spi3_miso,
	
	// SPI4 for 2.4GHz Q
	output wire spi4_sck,
	output wire spi4_mosi,
	//input wire spi4_miso,
	
	input wire stm_fpga_spare2, // using this spare as 2.4GHz serializer gating
	
	
	
	output wire fpga_ufl_p7,
	output wire fpga_ufl_p8,
	
	input wire stm_fpga_spare5 // using this as spare rst_n
	
);
  
/****** Internal oscillator *****/
wire int_clk_out;
OSCG #(
	.DIV(128) // divide by 128 = 2.4MHz
) osch_inst (
	.OSC(int_clk_out)   // Oscillator output
); 
/***** Internal PLL *******/
wire internal_160MHz;
wire internal_80MHz;
wire internal_64MHz;
wire internal_64MHz_90deg; // used for DDR stuff
wire pll_lock;
internal_pll my_pll (
	.CLKI(dpll_clkout2),
	.RST(!stm_fpga_spare5),
	.CLKOP(internal_64MHz),
	.CLKOS(internal_160MHz),
	.CLKOS2(internal_80MHz),
	.CLKOS3(internal_64MHz_90deg), 
	.LOCK(pll_lock)	
);


wire internal_200MHz; // over 3x over sampling DDR signals at 64MHz
wire second_pll_lock;
pll_10MHzInput second_pll (
	.CLKI(dpll_clkout0),
	.RST(!stm_fpga_spare5),
	.CLKOP(internal_200MHz),
	.LOCK(second_pll_lock) 
);

wire main_reset_n;
assign main_reset_n = stm_fpga_spare5 & pll_lock & second_pll_lock; // active low, don't need to invert pll_lock

/******* Debug LED **********/

led_toggle my_led (
	.clk(int_clk_out), 
	//.clk(dpll_clkout2),
	.reset(!main_reset_n),
	//.reset(1'b0),
	.led(fpga_led)
);

//assign fpga_led = 1'b1;



/******** Debug I2C slave interface ********/
/*
reg [7:0] i2c_data_in;
wire [7:0] i2c_data_out;
wire i2c_stretch_on;
wire i2c_start, i2c_stop, i2c_data_valid, i2c_rw;

// CSR Memory
reg [7:0] csr [0:15];  // 16 8-bit CSRs

// Internal Signals
reg [3:0] csr_addr;    // Address of the current CSR
wire write_enable;     // Write enable signal
wire read_enable;      // Read enable signal

// Assign read and write enables based on I2C core signals
assign write_enable = i2c_data_valid && !i2c_rw;  // Write when data is valid and r_w is 0
assign read_enable = i2c_data_valid && i2c_rw;    // Read when data is valid and r_w is 1



i2cslave_controller_top  #(
	.SLAVE_ADDRESS(7'b0001000), // 0x8 slave address for now
	.ADDR_10BIT_ENABLE(1'b0)
) i2cslave(
	.scl(fpga_scl),
	.sda(fpga_sda),
	.clk(dpll_clkout2),
	.reset(!rst_n),
	.stretch_on(i2c_stretch_on),
	.data_in(i2c_data_in),
	.start(i2c_start),
	.stop(i2c_stop),
	.data_vld(i2c_data_valid),
	.r_w(i2c_rw),
	.data_out(i2c_data_out)
);

integer i;
// CSR Read/Write Logic
always @(posedge dpll_clkout2 or posedge !rst_n) begin
	if (!rst_n) begin
		// Initialize CSRs and internal state on reset
		csr_addr <= 4'b0;
		i2c_data_in <= 8'b0;
	
		for (i = 0; i < 16; i = i + 1) begin
			csr[i] <= 8'b0;
		end
	end else begin
		if (write_enable) begin
			// Write operation: First byte is CSR address, subsequent bytes are data
			if (csr_addr == 4'b0) begin
				csr_addr <= i2c_data_out[3:0];  // Address is the lower 4 bits
			end else begin
				csr[csr_addr] <= i2c_data_out; // Write data to the addressed CSR
			end
		end
		if (read_enable) begin
			// Read operation: Provide data from the addressed CSR
			i2c_data_in <= csr[csr_addr];
		end
	end
end

*/


/******* AT86RF215IQ TX interface *******/
// Just making a fixed pattern output

/*
ddr_stream_generator tx_ddr_output(
	.clk(internal_64MHz_90deg),
	.rst(!main_reset_n),
	.ddr_data_out(sdr_txdata)
);
assign sdr_txclk = internal_64MHz;
*/



/******** AT86RF215IQ RX interface    *****/
wire w_lvds_rx_09_d0;  // 0 degree
wire w_lvds_rx_09_d1;  // 180 degree
wire w_lvds_rx_24_d0;  // 0 degree
wire w_lvds_rx_24_d1;  // 180 degree
wire subg_ddr_data_valid, wifi_ddr_data_valid;

ddr_data_recovery wifi_iddr (
	.clk_internal(internal_200MHz),
	.rst(!main_reset_n),
	.sdr_rxclk(sdr_rxclk),
	.sdr_data(sdr_rx_wifi),
	.clk_out_domain(internal_80MHz),
	.data_out({w_lvds_rx_24_d0,w_lvds_rx_24_d1} ),
	.data_valid(wifi_ddr_data_valid)
);

ddr_data_recovery subg_iddr (
	.clk_internal(internal_200MHz),
	.rst(!main_reset_n),
	.sdr_rxclk(sdr_rxclk),
	.sdr_data(sdr_rx_subg),
	.clk_out_domain(internal_80MHz),
	.data_out({w_lvds_rx_09_d0,w_lvds_rx_09_d1} ),
	.data_valid(subg_ddr_data_valid)
);


/* CANT USE IDDRX1F, Tinysdr picked the wrong pin for SDR RX clock, not a clock pin
IDDRX1F wifi_iddr (
	.D(sdr_rx_wifi),          // Input DDR data
	.Q0(w_lvds_rx_24_d0),         // Captured data on rising edge
	.Q1(w_lvds_rx_24_d1),         // Captured data on falling edge
	.SCLK(sdr_rx_clk_buf),                // Single-ended clock
	.RST(!main_reset_n)                // Reset (not used)
);
  
// DDR input register

IDDRX1F subg_iddr (
	.D(sdr_rx_subg),          // Input DDR data
	.Q0(w_lvds_rx_09_d0),         // Captured data on rising edge
	.Q1(w_lvds_rx_09_d1),         // Captured data on falling edge
	.SCLK(sdr_rx_clk_buf),                // Single-ended clock
	.RST(!main_reset_n)                // Reset (not used)
);
*/




//=========================================================================
// LVDS RX SIGNAL FROM MODEM
//=========================================================================



// RX FIFO Internals
wire w_rx_09_fifo_write_clk;
wire w_rx_09_fifo_push;
wire [31:0] w_rx_09_fifo_data;

wire w_rx_24_fifo_write_clk;
wire w_rx_24_fifo_push;
wire [31:0] w_rx_24_fifo_data;

lvds_rx lvds_rx_09_inst (
  .i_rst_b  (main_reset_n),
  .i_ddr_clk(internal_80MHz),
  .i_ddr_data({w_lvds_rx_09_d0, w_lvds_rx_09_d1}),
  .i_ddr_strobe(subg_ddr_data_valid),
  .i_fifo_full(1'b0),
  .o_fifo_write_clk(),
  .o_fifo_push(w_rx_09_fifo_push),

  .o_fifo_data(w_rx_09_fifo_data),
  .i_sync_input (1'b0),
  .o_debug_state()
);


lvds_rx lvds_rx_24_inst (
  .i_rst_b  (main_reset_n),
  .i_ddr_clk(internal_80MHz),
  .i_ddr_data({!w_lvds_rx_24_d0, !w_lvds_rx_24_d1}),
  .i_ddr_strobe(wifi_ddr_data_valid),
  .i_fifo_full(1'b0), // pushing data fast, dont need fifo assuming for now
  .o_fifo_write_clk(), // not used
  .o_fifo_push(w_rx_24_fifo_push),

  .o_fifo_data(w_rx_24_fifo_data),
  .i_sync_input (1'b0),
  .o_debug_state()
);

//assign fpga_neopixel = w_rx_24_fifo_push | w_rx_09_fifo_push; // just for debug to get it to synthesize


/************** Dual clock FIFO to take data from lvds_rx clock domain to SPI clock domain *******/
// NOT SURE WHERE THE TRUE "VALUES" ARE IN LVDS RX DATA, 14-bit I and 14-bit Q signed I think!
/**** Not needed anymore, ddr_workaround is converting to 95Mhz clock domain already
wire subg_i_empty;
wire subg_i_full;
wire [15:0] subg_i_fifo_data_out;
fifo_dc_16in_16out subg_i_fifo_dc (
	.Data(w_rx_09_fifo_data[15:0]),
	.WrClock(sdr_rxclk),
	.RdClock(internal_80MHz),
	.WrEn(w_rx_09_fifo_push),
	.RdEn(!subg_i_empty),
	.Reset(!main_reset_n),
	.RPReset(!main_reset_n),
	.Q(subg_i_fifo_data_out),
	.Empty(subg_i_empty),
	.Full()
);

wire subg_q_empty;
wire subg_q_full;
wire [15:0] subg_q_fifo_data_out;
fifo_dc_16in_16out subg_q_fifo_dc (
	.Data(w_rx_09_fifo_data[31:16]),
	.WrClock(sdr_rxclk),
	.RdClock(internal_80MHz),
	.WrEn(w_rx_09_fifo_push),
	.RdEn(!subg_q_empty),
	.Reset(!main_reset_n),
	.RPReset(!main_reset_n),
	.Q(subg_q_fifo_data_out),
	.Empty(subg_q_empty),
	.Full()
);


wire wifi_i_empty;
wire wifi_i_full;
wire [15:0] wifi_i_fifo_data_out;
fifo_dc_16in_16out wifi_i_fifo_dc (
	.Data(w_rx_24_fifo_data[15:0]),
	.WrClock(sdr_rxclk),
	.RdClock(internal_80MHz),
	.WrEn(w_rx_24_fifo_push),
	.RdEn(!wifi_i_empty),
	.Reset(!main_reset_n),
	.RPReset(!main_reset_n),
	.Q(wifi_i_fifo_data_out),
	.Empty(wifi_i_empty),
	.Full()
);

wire wifi_q_empty;
wire wifi_q_full;
wire [15:0] wifi_q_fifo_data_out;
fifo_dc_16in_16out wifi_q_fifo_dc (
	.Data(w_rx_24_fifo_data[31:16]),
	.WrClock(sdr_rxclk),
	.RdClock(internal_80MHz),
	.WrEn(w_rx_24_fifo_push),
	.RdEn(!wifi_q_empty),
	.Reset(!main_reset_n),
	.RPReset(!main_reset_n),
	.Q(wifi_q_fifo_data_out),
	.Empty(wifi_q_empty),
	.Full()
);
*****/

/************** Pipeline stage between FIFO and SPI *******/
/***** Removing for now, hopefully 95MHz is good
// Pipeline the data and the empty signal for I and Q for subg and wifi
wire [15:0] subg_i_fifo_data_out_pipe;
pipeline #(
	.DATA_WIDTH(16),
	.STAGES(2)
) subg_i_data_pipeline (
	.clk(internal_80MHz),
	.rst(!main_reset_n),
	.data_in(subg_i_fifo_data_out),
	.data_out(subg_i_fifo_data_out_pipe)
);

wire subg_i_empty_pipe;
pipeline #(
	.DATA_WIDTH(1),
	.STAGES(2)
) subg_i_empty_pipeline (
	.clk(internal_80MHz),
	.rst(!main_reset_n),
	.data_in(subg_i_empty),
	.data_out(subg_i_empty_pipe)
);

wire [15:0] subg_q_fifo_data_out_pipe;
pipeline #(
	.DATA_WIDTH(16),
	.STAGES(2)
) subg_q_data_pipeline (
	.clk(internal_80MHz),
	.rst(!main_reset_n),
	.data_in(subg_q_fifo_data_out),
	.data_out(subg_q_fifo_data_out_pipe)
);

wire subg_q_empty_pipe;
pipeline #(
	.DATA_WIDTH(1),
	.STAGES(2)
) subg_q_empty_pipeline (
	.clk(internal_80MHz),
	.rst(!main_reset_n),
	.data_in(subg_q_empty),
	.data_out(subg_q_empty_pipe)
);







wire [15:0] wifi_i_fifo_data_out_pipe;
pipeline #(
	.DATA_WIDTH(16),
	.STAGES(2)
) wifi_i_data_pipeline (
	.clk(internal_80MHz),
	.rst(!main_reset_n),
	.data_in(wifi_i_fifo_data_out),
	.data_out(wifi_i_fifo_data_out_pipe)
);

wire wifi_i_empty_pipe;
pipeline #(
	.DATA_WIDTH(1),
	.STAGES(2)
) wifi_i_empty_pipeline (
	.clk(internal_80MHz),
	.rst(!main_reset_n),
	.data_in(wifi_i_empty),
	.data_out(wifi_i_empty_pipe)
);

wire [15:0] wifi_q_fifo_data_out_pipe;
pipeline #(
	.DATA_WIDTH(16),
	.STAGES(2)
) wifi_q_data_pipeline (
	.clk(internal_80MHz),
	.rst(!main_reset_n),
	.data_in(wifi_q_fifo_data_out),
	.data_out(wifi_q_fifo_data_out_pipe)
);

wire wifi_q_empty_pipe;
pipeline #(
	.DATA_WIDTH(1),
	.STAGES(2)
) wifi_q_empty_pipeline (
	.clk(internal_80MHz),
	.rst(!main_reset_n),
	.data_in(wifi_q_empty),
	.data_out(wifi_q_empty_pipe)
);

***/


/************** "SPI" Serializer data output to stm32 *********/


// Serializer has two components
// Data components and clock component
// both are essentially dual clock fifos
// Data -> output clock is half rate
// Clock -> output clock is full rate

// the shift_on_falling_edge doesn't really work, keep it 0
// it will change data on rising edge, read data on falling edge

wire subg_i_shift, subg_q_shift;
/* Pipeline version
assign subg_i_shift = stm_fpga_spare1 & !subg_i_empty;
assign subg_q_shift = stm_fpga_spare1 & !subg_q_empty;
*/
assign subg_i_shift = stm_fpga_spare1 & w_rx_09_fifo_push;
assign subg_q_shift = stm_fpga_spare1 & w_rx_09_fifo_push;

wire wifi_i_shift, wifi_q_shift;
/* Pipeline version
assign wifi_i_shift = stm_fpga_spare2 & !wifi_i_empty;
assign wifi_q_shift = stm_fpga_spare2 & !wifi_q_empty;
*/
assign wifi_i_shift = stm_fpga_spare2 & w_rx_24_fifo_push;
assign wifi_q_shift = stm_fpga_spare2 & w_rx_24_fifo_push;



/********* 
w_rx_09_fifo_data[31:0] / w_rx_24_fifo_data[31:0] is of the format described in AT86RF215IQ datasheet
[31:30] = I_SYNC = 0b10
[29:17] = I_DATA[13:1], 13-bit 2's complement signed value
[16] = I_DATA[0] , always 0 for receive data path
[15:14] = Q_SYNC = 0b01
[13:1] = Q_DATA[13:1], 13-bit 2's complement signed value
[0] = Q_DATA[0] , always 0 for receive path

I want to push just the 2's complement value, but sign extend it to int16_t
since that's what microcontrollers can ingest easily
***********/

wire [12:0] subg_i_data, subg_q_data;
wire [12:0] wifi_i_data, wifi_q_data;

assign subg_i_data = w_rx_09_fifo_data[29:17];
assign subg_q_data = w_rx_09_fifo_data[13:1];
assign wifi_i_data = w_rx_24_fifo_data[29:17];
assign wifi_q_data = w_rx_24_fifo_data[13:1];

spi_generator subg_i_spi (
	.clk(internal_160MHz),
	.rst(!main_reset_n),
	//.data_in( { {3{subg_i_data[12]}} , subg_i_data} ), // sign extend to 16-bits
	//.data_in(16'hdead),
	.data_in( w_rx_09_fifo_data[31:16] ), // raw data out
	.data_strobe(subg_i_shift),
	.spi_mosi(spi1_mosi),
	.spi_busy(),
	.spi_clk(spi1_sck)
);



spi_generator subg_q_spi (
	.clk(internal_160MHz),
	.rst(!main_reset_n),
	//.data_in( { {3{subg_q_data[12]}} , subg_q_data} ), // sign extend to 16-bits
	//.data_in(16'hbeef),
	.data_in( w_rx_09_fifo_data[15:0] ), // raw data out
	.data_strobe(subg_q_shift),
	.spi_mosi(spi2_mosi),
	.spi_busy(),
	.spi_clk(spi2_sck)
);

spi_generator wifi_i_spi (
	.clk(internal_160MHz),
	.rst(!main_reset_n),
	.data_in( { {3{wifi_i_data[12]}} , wifi_i_data} ), // sign extend to 16-bits
	.data_strobe(wifi_i_shift),
	.spi_mosi(spi3_mosi),
	.spi_busy(),
	.spi_clk(spi3_sck)
);

spi_generator wifi_q_spi (
	.clk(internal_160MHz),
	.rst(!main_reset_n),
	.data_in( { {3{wifi_q_data[12]}} , wifi_q_data} ), // sign extend to 16-bits
	.data_strobe(wifi_q_shift),
	.spi_mosi(spi4_mosi),
	.spi_busy(),
	.spi_clk(spi4_sck)
);


assign fpga_ufl_p7 = spi2_sck;
assign fpga_ufl_p8 = spi2_mosi; // debug UFL, good for probing purposes

	


endmodule