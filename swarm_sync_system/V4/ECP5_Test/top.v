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
	
	/****** Antenna mux control signals *******/
	output wire rf_sel_0,
	output wire rf_sel_1,
	output wire rf_sel_2,
	output wire rf_sel_3,
	output wire subg_fem_sel0,
	output wire subg_fem_sel1,	
	output wire wifi_fem_sel0,
	output wire wifi_fem_sel1,
	
	/****** SKY66112-11 WiFi FEM module control signals ******/
	output wire wifi_fem_csd,
	output wire wifi_fem_cps,
	output wire wifi_fem_crx,
	output wire wifi_fem_ctx,
	output wire wifi_fem_chl,
	
	/****** SE2435L-R (not installed on V4 boards due to footprint issue) control signals *******/
	output wire subg_fem_cps,
	output wire subg_fem_ctx,
	output wire subg_fem_csd,
	
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
	.DIV(32) // divide by 32 = 9.6MHz
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
reg internal_rst, led_rst;
assign main_reset_n = stm_fpga_spare5 & pll_lock & second_pll_lock & !internal_rst; // active low, don't need to invert pll_lock

/******* Debug LED **********/

led_toggle my_led (
	.clk(int_clk_out), 
	//.clk(dpll_clkout2),
	//.reset(!main_reset_n),
	.reset(!stm_fpga_spare5 | led_rst),
	//.reset(1'b0),
	.led(fpga_led)
);

//assign fpga_led = 1'b1;



/****** Hard coded RF selects ******/

// SKY13585 truth table -> 0 = OUT2, 1 = OUT1

// debug default, ESP32 goes to J3, AT86 goes to J1, separate antennas
assign rf_sel_0 = 1'b1; // U26 SKY13585, COMMON = WIWI_WIFI_ANT (J1), OUT1 = SDR_WIFI_RF, OUT2 = ESP_ANT_SW 
assign rf_sel_1 = 1'b1; // U27 SKY13585, COMMON = ESP_ANT (From ESP32S3), OUT1 = XCVR_RX_WIFI_ANT (J3), OUT2 = ESP_ANT_SW (goes to U26)

// debug default, SX1276 goes to J8, AT86 goes to J7, separate antennas
assign rf_sel_2 = 1'b0; // U6 SKY13585 , COMMON = WIWI_LORA_ANT (J7), OUT1 = SX1276_ANT_SW, OUT2 = SDR_SUBG_RF (AT86RF215)
assign rf_sel_3 = 1'b0; // U29 SKY13585, COMMON = SX1276_ANT (SX1276), OUT1 = SX1276_ANT_SW (goes to U6), OUT2 = XCVR_RX_LORA_ANT (J8)


// default for now is bypass FEMs , especially since subg one isn't present in V4 boards!
assign subg_fem_sel0 = 1'b1; // U32 SKY13585, COMMON = SDR_SUBG_RF_CHIP (AT86 SDR RX), OUT1 = SDR_SUBG_RF_SW, OUT2 = SDR_SUBG_RF_FEM_IN (goes to FEM)
assign subg_fem_sel1 = 1'b0; // U34 SKY13585, COMMON = SDR_SUBG_RF (goes to U6), OUT1 = SDR_SUBG_RF_FEM_OUT (from FEM) , OUT2 = SDR_SUBG_RF_SW (goes to U32)

assign wifi_fem_sel0 = 1'b0; // U33 SKY13585, COMMON = SDR_WIFI_RF_CHIP (AT86 SDR RX), OUT1 = SDR_WIFI_RF_FEM_IN, OUT2 = SDR_WIFI_RF_SW
assign wifi_fem_sel1 = 1'b1; // U35 SKY13585, COMMON = SDR_WIFI_RF (goes to U26), OUT1 = SDR_WIFI_RF_SW (from U33), OUT2 = SDR_WIFI_RF_FEM_OUT




/******* Hard coded FEM controls ******/
// SKY66112-11 , WiFi FEM , all off => CSD = 0

assign wifi_fem_csd = 1'b0;
assign wifi_fem_cps = 1'b0;
assign wifi_fem_crx = 1'b0;
assign wifi_fem_ctx = 1'b0;
assign wifi_fem_chl = 1'b0;

// SE2435L-R , SubG FEM, not installed so doesn't matter, just assign so it drives something
assign subg_fem_cps = 1'b0;
assign subg_fem_ctx = 1'b0;
assign subg_fem_csd = 1'b0;


/******** Debug I2C slave interface ********/


wire fpga_scl_out, fpga_scl_oe, fpga_scl_in;
BB scl_io (
	.B(fpga_scl),
	.I(fpga_scl_out),
	.T(fpga_scl_oe),
	.O(fpga_scl_in)
);


wire fpga_sda_out, fpga_sda_oe, fpga_sda_in;
BB sda_io (
	.B(fpga_sda),
	.I(fpga_sda_out),
	.T(fpga_sda_oe),
	.O(fpga_sda_in)
);



// Clocking from internal oscillator and direct pin reset only
// primary debug / probing / configuration interface when all else doesn't work
wire [7:0] wb_dat_o;
wire [15:0] wb_adr_o;
wire wb_we_o, wb_stb_o, wb_cyc_o, wb_sel_o;
wire i2c_busy, i2c_addressed, i2c_bus_active;

reg [7:0] wb_dat_i;
reg wb_ack_i, wb_err_i;

i2c_slave_wbm  #(
	.FILTER_LEN(4),
	.WB_DATA_WIDTH(8),
	.WB_ADDR_WIDTH(16),
	.WB_SELECT_WIDTH(1)
	) i2c_slave (
	
	.clk(int_clk_out),
	.rst(!stm_fpga_spare5),
	 
	// i2c signals
	.i2c_scl_i(fpga_scl_in),
	.i2c_scl_o(fpga_scl_out),
	.i2c_scl_t(fpga_scl_oe),
	.i2c_sda_i(fpga_sda_in),
	.i2c_sda_o(fpga_sda_out),
	.i2c_sda_t(fpga_sda_oe),
	

    // Wishbone interface

    .wb_adr_o(wb_adr_o),   // ADR_O() address
    .wb_dat_i(wb_dat_i),   // DAT_I() data in
    .wb_dat_o(wb_dat_o),   // DAT_O() data out
    .wb_we_o(wb_we_o),    // WE_O write enable output
    .wb_sel_o(wb_sel_o),   // SEL_O() select output
    .wb_stb_o(wb_stb_o),   // STB_O strobe output
    .wb_ack_i(wb_ack_i),   // ACK_I acknowledge input
    .wb_err_i(wb_err_i),   // ERR_I error input
    .wb_cyc_o(wb_cyc_o),   // CYC_O cycle output 

    //Status
     
    .busy(i2c_busy),
    .bus_addressed(i2c_addressed),
    .bus_active(i2c_bus_active),

    //Configuration
    
    .enable(1'b1),
    .device_address(7'h10)	
);


/********* I2C registers
Defining here because it has the most access to signals
*********/


/***** Registers:

0 => scratch
1 => scratch
2 => scratch
3 => status
		[0] = pll_lock
		[1] = second_pll_lock
		[7:2] = reserved
4 => control
		[0] = soft reset, reset rest of FPGA except i2c and led , active high (internal_rst)
		[1] = led blink reset (led_rst)
		[7:2] = reserved
5 => ufl p7 control
		0 = fpga_sda_in
		1 = fpga_scl_in
		2 = sdr_rxclk 
		3 = sdr_rx_subg
		4 = sdr_rx_wifi
		5 = w_rx_09_fifo_push
		6 = w_rx_24_fifo_push
		
		These SPI busses dont work because im using DDR
		if you find a way to do them without ddr they should work
		7 = spi1_sck
		8 = spi1_mosi
		9 = spi2_sck
		10 = spi2_mosi
		11 = spi3_sck
		12 = spi3_mosi
		13 = spi4_sck
		14 = spi4_mosi
6 => ufl p8 control 
		same decimal definition as ufl p7 control
7 => IQ stream control
		0 = enable SubG RX inversion
		1 = enable WiFi RX inversion
		2 = enable SubG sync checking alignment
		3 = enable WiFi sync checking alignment
		[7:2] = reserved
		
//////Test patterns to test SPI serializer block
8 => spi1 test pattern [15:8]
9 => spi1 test pattern [7:0]
0xA => spi2 test pattern [15:8]
0xB => spi2 test pattern [7:0]
0xC => spi3 test pattern [15:8]
0xD => spi3 test pattern [7:0]
0xE => spi4 test pattern [15:8]
0xF => spi4 test pattern [7:0]
0x10 => SPI test pattern enable
		0 = spi1
		1 = spi2
		2 = spi3
		4 = spi4

////// Test pattern for LVDS TX to AT86RF215
// can enable loopback on radio to verify IQ LVDS datapath

0x11 => TX test pattern, [31:24] , top 8 bits of I
0x12 => TX test pattern, [23:16] , bottom 8 bits of I
0x13 => TX test pattern, [15:8] , top 8 bits of Q
0x14 => TX test pattern, [7:0] , bottom 8 bits of Q
0x15 => TX enable
		0 = enable 
		
		
0x16 => subg delay control and status, for debug 
		0 = LoadN , control signal
		1 = Move , falling edge controls 
		2 = Direction , 1 to decrease delay, 0 to increase
		3 = CFLAG, set when reached max (going up) or min (going down)
		
******/


reg [7:0] reg0,reg1,reg2;
reg [7:0] ufl_p7_sel, ufl_p8_sel;
reg subg_rx_invert, wifi_rx_invert;
reg [15:0] spi1_test_pattern, spi2_test_pattern;
reg [15:0] spi3_test_pattern, spi4_test_pattern;
reg [3:0] spi_test_pattern_enable;
reg [31:0] tx_lvds_test_pattern;
reg tx_lvds_test_pattern_enable;
reg subg_sync_check_enable, wifi_sync_check_enable;
reg subg_delay_loadn, subg_delay_move, subg_delay_direction;
wire subg_delay_cflag;
//------------------------------------------------
// 1) WRITE LOGIC
//    If WE=1, store wb_dat_i into the selected reg
//    This happens on the rising edge of wb_clk_i.
//------------------------------------------------
always @(posedge int_clk_out) begin
	if (!stm_fpga_spare5) begin
	  reg0 <= 8'h00;
	  reg1 <= 8'h00;
	  reg2 <= 8'h00;
	  internal_rst <= 1'b0;
	  led_rst <= 1'b0; // use this for initialization
	  ufl_p7_sel <= 8'd7;
	  ufl_p8_sel <= 8'd8;
	  subg_rx_invert <= 1'b1;
	  wifi_rx_invert <= 1'b1;
	  spi1_test_pattern <= 16'hdead;
	  spi2_test_pattern <= 16'hbeef;
	  spi3_test_pattern <= 16'ha5a5;
	  spi4_test_pattern <= 16'h5a5a;
	  spi_test_pattern_enable <= 4'd0;
	  tx_lvds_test_pattern <= { 2'b10, 14'h3ffe, 2'b01, 14'h3fff };
	  //tx_lvds_test_pattern <= 32'd1;
	  tx_lvds_test_pattern_enable <= 1'b1;
	  subg_sync_check_enable <= 1'b1;
	  wifi_sync_check_enable <= 1'b1;
	  subg_delay_loadn <= 1'b0;
	  subg_delay_move <= 1'b0;
	  subg_delay_direction <= 1'b0;
	end 
	else if (wb_cyc_o && wb_stb_o && wb_we_o) begin
	  case (wb_adr_o)
		16'h0000: reg0 <= wb_dat_o;
		16'h0001: reg1 <= wb_dat_o;
		16'h0002: reg2 <= wb_dat_o;
		16'h0004: begin
			internal_rst <= wb_dat_o[0];
			led_rst <= wb_dat_o[1];
		end
		16'h0005: ufl_p7_sel <= wb_dat_o;
		16'h0006: ufl_p8_sel <= wb_dat_o;
		16'h0007: begin
			subg_rx_invert <= wb_dat_o[0];
			wifi_rx_invert <= wb_dat_o[1];
			subg_sync_check_enable <= wb_dat_o[2];
			wifi_sync_check_enable <= wb_dat_o[3];
		end
		16'h0008: spi1_test_pattern[15:8] <= wb_dat_o;
		16'h0009: spi1_test_pattern[7:0] <= wb_dat_o;
		16'h000A: spi2_test_pattern[15:8] <= wb_dat_o;
		16'h000B: spi2_test_pattern[7:0] <= wb_dat_o;
		16'h000C: spi3_test_pattern[15:8] <= wb_dat_o;
		16'h000D: spi3_test_pattern[7:0] <= wb_dat_o;
		16'h000E: spi4_test_pattern[15:8] <= wb_dat_o;
		16'h000F: spi4_test_pattern[7:0] <= wb_dat_o;
		16'h0010: spi_test_pattern_enable <= wb_dat_o;
		16'h0011: tx_lvds_test_pattern[31:24] <= wb_dat_o;
		16'h0012: tx_lvds_test_pattern[23:16] <= wb_dat_o;
		16'h0013: tx_lvds_test_pattern[15:8] <= wb_dat_o;
		16'h0014: tx_lvds_test_pattern[7:0] <= wb_dat_o;
		16'h0015: tx_lvds_test_pattern_enable <= wb_dat_o[0];
		16'h0016: begin
			subg_delay_loadn <= wb_dat_o[0];
			subg_delay_move <= wb_dat_o[1];
			subg_delay_direction <= wb_dat_o[2];
		end
		//default: /* Do nothing for invalid addresses */
	  endcase
	end
end


//------------------------------------------------
// 2) READ DATA MUX (COMBINATIONAL)
//    We select which register data to return
//------------------------------------------------
reg [7:0] data_mux;
always @* begin
	case (wb_adr_o)
	  16'h0000: data_mux = reg0;
	  16'h0001: data_mux = reg1;
	  16'h0002: data_mux = reg2;
	  16'h0003: data_mux = { 6'b0, second_pll_lock, pll_lock };	  
	  16'h0004: data_mux = { 6'b0, led_rst, internal_rst };
	  16'h0005: data_mux = ufl_p7_sel;
	  16'h0006: data_mux = ufl_p8_sel;
	  16'h0007: data_mux = { 4'b0, wifi_sync_check_enable, subg_sync_check_enable, wifi_rx_invert, subg_rx_invert };
	  16'h0008: data_mux = spi1_test_pattern[15:8];
	  16'h0009: data_mux = spi1_test_pattern[7:0]; 
	  16'h000A: data_mux = spi2_test_pattern[15:8];  
	  16'h000B: data_mux = spi2_test_pattern[7:0];
	  16'h000C: data_mux = spi3_test_pattern[15:8]; 
	  16'h000D: data_mux = spi3_test_pattern[7:0];  
	  16'h000E: data_mux = spi4_test_pattern[15:8]; 
	  16'h000F: data_mux = spi4_test_pattern[7:0]; 
	  16'h0010: data_mux = spi_test_pattern_enable;	 
	  16'h0011: data_mux = tx_lvds_test_pattern[31:24];
	  16'h0012: data_mux = tx_lvds_test_pattern[23:16];
	  16'h0013: data_mux = tx_lvds_test_pattern[15:8];
	  16'h0014: data_mux = tx_lvds_test_pattern[7:0];
	  16'h0015: data_mux = {7'b0, tx_lvds_test_pattern_enable};	 
	  16'h0016: data_mux = {4'b0, subg_delay_cflag, subg_delay_direction, subg_delay_move, subg_delay_loadn};
	  default: data_mux = 8'hFF; // Default for invalid address
	endcase
end

//------------------------------------------------
// 3) OUTPUT DATA & ACK (SYNCHRONOUS)
//    - wb_dat_o is latched each clock from data_mux
//    - wb_ack_o = 1 if cyc_i & stb_i, else 0
//------------------------------------------------
always @(posedge int_clk_out) begin
	if (!stm_fpga_spare5) begin
	  wb_dat_i <= 8'h00;
	  wb_ack_i <= 1'b0;
	end 
	else begin
	  // Latch the selected register into wb_dat_o
	  wb_dat_i <= data_mux;

	  // Single-cycle ACK: assert it when cyc_i & stb_i are active
	  wb_ack_i <= (wb_cyc_o && wb_stb_o);
	end
end




/********* AT86RF215IQ TX Interface ******/

// Primarily used for debug purposes at the moment

reg [31:0] tx_ddr_data;
reg [7:0] tx_counter;
always @(posedge internal_64MHz or negedge main_reset_n) begin
	if ( !main_reset_n ) begin
		tx_counter <= 8'd0;
		tx_ddr_data <= 32'd0;
	end else begin
		if ( tx_counter == 8'd15 ) begin
			tx_counter <= 8'd0;
			tx_ddr_data <= tx_lvds_test_pattern;
		end else begin
			tx_counter <= tx_counter + 1;
			tx_ddr_data <= { tx_ddr_data[29:0], 2'd0 }; // shift out top 
		end
	end
end


ODDRX1F tx_ddr_data_inst (
	.D0( ~tx_ddr_data[31] ),
	.D1( ~tx_ddr_data[30] ), // TX pin is inverted on pinout, invert these here
	//.D0(1'b1),
	//.D1(1'b0),
	.SCLK(internal_64MHz),
	.RST(!main_reset_n | !tx_lvds_test_pattern_enable),
	.Q(sdr_txdata)
);


assign sdr_txclk = internal_64MHz_90deg;

/*

DELAYF #(
	.DEL_MODE("USER_DEFINED"),
	.DEL_VALUE(1)
	)  subg_delay (
	.A(sdr_rx_subg),
	.Z(sdr_rx_subg_delayed),
	.LOADN(subg_delay_loadn),
	.MOVE(subg_delay_move),
	.DIRECTION(subg_delay_direction),
	.CFLAG(subg_delay_cflag)
);
*/

/******** AT86RF215IQ RX interface    *****/
wire w_lvds_rx_09_d0;  // 0 degree
wire w_lvds_rx_09_d1;  // 180 degree
wire w_lvds_rx_24_d0;  // 0 degree
wire w_lvds_rx_24_d1;  // 180 degree

wire subg_ddr_data_valid, wifi_ddr_data_valid;






IDDRX1F wifi_iddr (
	.D(sdr_rx_wifi),          // Input DDR data
	.Q0(w_lvds_rx_24_d0),         // Captured data on rising edge, should be D0 but trying flipped
	.Q1(w_lvds_rx_24_d1),         // Captured data on falling edge
	.SCLK(sdr_rxclk),                // Single-ended clock
	.RST(!main_reset_n)                // Reset (not used)
);


  
// DDR input register

IDDRX1F subg_iddr (
	.D(sdr_rx_subg),          // Input DDR data
	.Q0(w_lvds_rx_09_d0),         // Captured data on rising edge
	.Q1(w_lvds_rx_09_d1),         // Captured data on falling edge
	.SCLK(sdr_rxclk),                // Single-ended clock
	.RST(!main_reset_n)                // Reset (not used)
);



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

/*
// Using my LVDS RX block
my_lvds_rx lvds_rx_09_inst (
    .i_rst_b(main_reset_n),
    .i_ddr_clk(sdr_rxclk),
    .i_ddr_data( subg_rx_invert ? { !w_lvds_rx_09_d0, !w_lvds_rx_09_d1} : { w_lvds_rx_09_d0, w_lvds_rx_09_d1} ),
	.i_enable_sync_check(subg_sync_check_enable),

    // FIFO status
    .i_fifo_full(1'b0),
    .o_fifo_write_clk(),
    .o_fifo_push(w_rx_09_fifo_push),
    .o_fifo_data(w_rx_09_fifo_data)
);

my_lvds_rx lvds_rx_24_inst (
    .i_rst_b(main_reset_n),
    .i_ddr_clk(sdr_rxclk),
	.i_ddr_data( wifi_rx_invert ? { !w_lvds_rx_24_d0, !w_lvds_rx_24_d1} : { w_lvds_rx_24_d0, w_lvds_rx_24_d1} ),
	.i_enable_sync_check(wifi_sync_check_enable),

    // FIFO status
    .i_fifo_full(1'b0),
    .o_fifo_write_clk(),
    .o_fifo_push(w_rx_24_fifo_push),
    .o_fifo_data(w_rx_24_fifo_data)
);
*/

/*
// cariboulite LVDS RX blocks
lvds_rx lvds_rx_09_inst (
    .i_rst_b(main_reset_n),
    .i_ddr_clk(sdr_rxclk),
    .i_ddr_data(  { w_lvds_rx_09_d1, w_lvds_rx_09_d0}  ),

    // FIFO status
    .i_fifo_full(1'b0),
    .o_fifo_write_clk(),
	.i_sync_input(1'b0),
	.o_debug_state(),
    .o_fifo_push(w_rx_09_fifo_push),
    .o_fifo_data(w_rx_09_fifo_data)
);

lvds_rx lvds_rx_24_inst (
    .i_rst_b(main_reset_n),
    .i_ddr_clk(sdr_rxclk),
	.i_ddr_data( { w_lvds_rx_24_d1, w_lvds_rx_24_d0} ),

    // FIFO status
    .i_fifo_full(1'b0),
    .o_fifo_write_clk(),
	.i_sync_input(1'b0),
	.o_debug_state(),
    .o_fifo_push(w_rx_24_fifo_push),
    .o_fifo_data(w_rx_24_fifo_data)
);
*/


word_align_3state lvds_rx_09_inst (
    .i_rst_b(main_reset_n),
    .i_ddr_clk(sdr_rxclk),
    .i_ddr_data(  { w_lvds_rx_09_d0, w_lvds_rx_09_d1}  ),

    .o_fifo_push(w_rx_09_fifo_push),
    .o_fifo_data(w_rx_09_fifo_data)
);

word_align_3state lvds_rx_24_inst (
    .i_rst_b(main_reset_n),
    .i_ddr_clk(sdr_rxclk),
	.i_ddr_data( { w_lvds_rx_24_d0, w_lvds_rx_24_d1} ),

    .o_fifo_push(w_rx_24_fifo_push),
    .o_fifo_data(w_rx_24_fifo_data)
);


/************** Dual clock FIFO to take data from lvds_rx clock domain to SPI clock domain *******/
// NOT SURE WHERE THE TRUE "VALUES" ARE IN LVDS RX DATA, 14-bit I and 14-bit Q signed I think!

wire subg_i_empty;
wire subg_i_full;
wire [15:0] subg_i_fifo_data_out;
fifo_dc_16in_16out subg_i_fifo_dc (
	.Data(w_rx_09_fifo_data[31:16]), // data from AT86 hopefully
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
	.Data(w_rx_09_fifo_data[15:0]),
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
	.Data(w_rx_24_fifo_data[31:16]),
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
	.Data(w_rx_24_fifo_data[15:0]),
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


/************** "SPI" Serializer data output to stm32 *********/


// Serializer has two components
// Data components and clock component
// both are essentially dual clock fifos
// Data -> output clock is half rate
// Clock -> output clock is full rate

// the shift_on_falling_edge doesn't really work, keep it 0
// it will change data on rising edge, read data on falling edge

wire subg_i_shift, subg_q_shift;
// Pipeline version
assign subg_i_shift = stm_fpga_spare1 & !subg_i_empty;
assign subg_q_shift = stm_fpga_spare1 & !subg_q_empty;

wire wifi_i_shift, wifi_q_shift;
// Pipeline version
assign wifi_i_shift = stm_fpga_spare2 & !wifi_i_empty;
assign wifi_q_shift = stm_fpga_spare2 & !wifi_q_empty;



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

ecp5_spi_master_top subg_i_spi (
	.i_clk_80(internal_80MHz),
	.i_rst_n(main_reset_n),
	.i_start(subg_i_shift),
	.i_data( spi_test_pattern_enable[0] ? spi1_test_pattern : subg_i_fifo_data_out ),
	.o_sclk(spi1_sck),
	.o_mosi(spi1_mosi),
	.o_busy()
);

ecp5_spi_master_top subg_q_spi (
	.i_clk_80(internal_80MHz),
	.i_rst_n(main_reset_n),
	.i_start(subg_q_shift),
	.i_data(spi_test_pattern_enable[1] ? spi2_test_pattern : subg_q_fifo_data_out),
	.o_sclk(spi2_sck),
	.o_mosi(spi2_mosi),
	.o_busy()
);


ecp5_spi_master_top wifi_i_spi (
	.i_clk_80(internal_80MHz),
	.i_rst_n(main_reset_n),
	.i_start(wifi_i_shift),
	.i_data(spi_test_pattern_enable[2] ? spi3_test_pattern : wifi_i_fifo_data_out),
	.o_sclk(spi3_sck),
	.o_mosi(spi3_mosi),
	.o_busy()
);

ecp5_spi_master_top wifi_q_spi (
	.i_clk_80(internal_80MHz),
	.i_rst_n(main_reset_n),
	.i_start(wifi_q_shift),
	.i_data(spi_test_pattern_enable[3] ? spi4_test_pattern : wifi_q_fifo_data_out),
	.o_sclk(spi4_sck),
	.o_mosi(spi4_mosi),
	.o_busy()
);




/******* fpga ufl p7 / p8 debug mux *********/	




reg ufl_p7_mux;
always @* begin
	case (ufl_p7_sel)
		8'd0: ufl_p7_mux = fpga_sda_in;
		8'd1: ufl_p7_mux = fpga_scl_in;
		//8'd2: ufl_p7_mux = sdr_rxclk;
		//8'd3: ufl_p7_mux = sdr_rx_subg;
		8'd4: ufl_p7_mux = sdr_rx_wifi;
		8'd5: ufl_p7_mux = w_rx_09_fifo_push;
		8'd6: ufl_p7_mux = w_rx_24_fifo_push;
		/*
		8'd7: ufl_p7_mux = spi1_sck;
		8'd8: ufl_p7_mux = spi1_mosi;
		8'd9: ufl_p7_mux = spi2_sck;
		8'd10: ufl_p7_mux = spi2_mosi;
		8'd11: ufl_p7_mux = spi3_sck;
		8'd12: ufl_p7_mux = spi3_mosi;
		8'd13: ufl_p7_mux = spi4_sck;	
		8'd14: ufl_p7_mux = spi4_mosi;				
		*/
	endcase
end
//assign fpga_ufl_p7 = ufl_p7_mux;

reg ufl_p8_mux;
always @* begin
	case (ufl_p8_sel)
		8'd0: ufl_p8_mux = fpga_sda_in;
		8'd1: ufl_p8_mux = fpga_scl_in;
		//8'd2: ufl_p8_mux = sdr_rxclk;
		//8'd3: ufl_p8_mux = sdr_rx_subg;
		8'd4: ufl_p8_mux = sdr_rx_wifi;
		8'd5: ufl_p8_mux = w_rx_09_fifo_push;
		8'd6: ufl_p8_mux = w_rx_24_fifo_push;
		/*
		8'd7: ufl_p8_mux = spi1_sck;
		8'd8: ufl_p8_mux = spi1_mosi;
		8'd9: ufl_p8_mux = spi2_sck;
		8'd10: ufl_p8_mux = spi2_mosi;
		8'd11: ufl_p8_mux = spi3_sck;
		8'd12: ufl_p8_mux = spi3_mosi;
		8'd13: ufl_p8_mux = spi4_sck;	
		8'd14: ufl_p8_mux = spi4_mosi;	
		*/
	endcase
end
//assign fpga_ufl_p8 = ufl_p8_mux;

assign fpga_ufl_p7 = sdr_rxclk;
assign fpga_ufl_p8 = sdr_rx_subg;


	


endmodule