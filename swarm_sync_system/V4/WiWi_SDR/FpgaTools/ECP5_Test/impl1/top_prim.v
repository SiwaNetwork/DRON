// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.14.0.75.2
// Netlist written on Tue Dec 10 10:42:47 2024
//
// Verilog Description of module top
//

module top (fpga_led, fpga_neopixel, dpll_clkout2, dpll_clkout0, sdr_rx_wifi, 
            sdr_rx_subg, sdr_rxclk, sdr_txclk, sdr_txdata, fpga_sda, 
            fpga_scl, spi1_sck, spi1_mosi, spi2_sck, spi2_mosi, stm_fpga_spare1, 
            spi3_sck, spi3_mosi, spi4_sck, spi4_mosi, stm_fpga_spare2, 
            fpga_ufl_p7, fpga_ufl_p8, stm_fpga_spare5) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(1[8:11])
    output fpga_led;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(2[14:22])
    output fpga_neopixel;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(3[14:27])
    input dpll_clkout2;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(5[13:25])
    input dpll_clkout0;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(6[13:25])
    input sdr_rx_wifi;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(8[13:24])
    input sdr_rx_subg /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(9[13:24])
    input sdr_rxclk /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(10[13:22])
    output sdr_txclk /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(11[14:23])
    output sdr_txdata /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(12[14:24])
    input fpga_sda /* synthesis IO_TYPES="LVDS", .original_dir=IN_OUT */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(16[13:21])
    input fpga_scl /* synthesis .original_dir=IN_OUT */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(17[13:21])
    output spi1_sck;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(22[14:22])
    output spi1_mosi;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(23[14:23])
    output spi2_sck;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(28[14:22])
    output spi2_mosi;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(29[14:23])
    input stm_fpga_spare1;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(32[13:28])
    output spi3_sck;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(35[14:22])
    output spi3_mosi;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(36[14:23])
    output spi4_sck;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(40[14:22])
    output spi4_mosi;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(41[14:23])
    input stm_fpga_spare2;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(44[13:28])
    output fpga_ufl_p7;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(48[14:25])
    output fpga_ufl_p8;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(49[14:25])
    input stm_fpga_spare5;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(51[13:28])
    
    wire GND_net /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(13[23:34])
    wire dpll_clkout2_c /* synthesis is_clock=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(5[13:25])
    wire dpll_clkout0_c /* synthesis is_clock=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(6[13:25])
    wire sdr_rx_subg_c /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(9[13:24])
    wire sdr_rxclk_c /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(10[13:22])
    wire fpga_sda /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(16[13:21])
    wire int_clk_out /* synthesis DSPPORT_20=CLK3, CLOCK_NET_FOR_BUS20=20, is_clock=1, SET_AS_NETWORK=int_clk_out */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(56[6:17])
    wire internal_160MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_160MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(63[6:21])
    wire internal_80MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_80MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(64[6:20])
    wire internal_200MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_200MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(79[6:21])
    wire main_reset_n_N_4 /* synthesis DSPPORT_20=RST3, RESET_NET_FOR_BUS20=20 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(191[6:21])
    wire VCC_net /* synthesis CE_NET_FOR_BUS20=20, DSPPORT_20=CE3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(125[10:19])
    
    wire fpga_led_c, sdr_rx_wifi_c, spi1_sck_c, spi1_mosi_c, fpga_ufl_p7_c, 
        fpga_ufl_p8_c, stm_fpga_spare1_c, spi3_sck_c, spi3_mosi_c, spi4_sck_c, 
        spi4_mosi_c, stm_fpga_spare2_c, stm_fpga_spare5_c, pll_lock, 
        second_pll_lock, w_lvds_rx_09_d0, w_lvds_rx_09_d1, w_lvds_rx_24_d0, 
        w_lvds_rx_24_d1, subg_ddr_data_valid, wifi_ddr_data_valid, w_rx_09_fifo_push;
    wire [31:0]w_rx_09_fifo_data;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(247[13:30])
    
    wire w_rx_24_fifo_push;
    wire [31:0]w_rx_24_fifo_data;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(251[13:30])
    
    wire stm_fpga_spare5_N_9, data_rising, data_falling, internal_160MHz_enable_83;
    wire [1:0]o_debug_state;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(18[23:36])
    wire [2:0]r_phase_count;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(32[15:28])
    wire [2:0]r_phase_count_2__N_123;
    
    wire n1230;
    wire [31:0]o_fifo_data_adj_342;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(16[23:34])
    wire [1:0]o_debug_state_adj_343;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(18[23:36])
    wire [2:0]r_phase_count_adj_345;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(32[15:28])
    
    wire n1766;
    wire [2:0]r_phase_count_2__N_123_adj_358;
    
    wire n2693, internal_160MHz_enable_84, spi_busy;
    wire [15:0]shift_reg;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(176[26:35])
    
    wire internal_160MHz_enable_82;
    wire [15:0]shift_reg_15__N_168;
    
    wire n2689, spi_busy_adj_237;
    wire [15:0]shift_reg_adj_372;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(176[26:35])
    wire [15:0]shift_reg_15__N_168_adj_379;
    
    wire spi_busy_adj_268;
    wire [15:0]shift_reg_adj_387;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(176[26:35])
    wire [15:0]shift_reg_15__N_168_adj_394;
    
    wire spi_busy_adj_299;
    wire [15:0]shift_reg_adj_402;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(176[26:35])
    
    wire n1251, internal_160MHz_enable_81, n2685, n3032, n2938, n805;
    wire [15:0]shift_reg_15__N_168_adj_409;
    
    wire rRst, n2920, n2919, n2681, n2963, n1237, n2935, n1220, 
        n327, n328, n329, n330, n331, n332, n333, n334, n335, 
        n336, n337, n338, n339, n340, n341, n342, n343, n344, 
        n345, n346, n347, n348, n349, n350, n351, n352, n353, 
        n354, n355, n356, n357, n358, n2932, n2931, n2955, n2962, 
        n2259, n3031, n2910, n2909, n2907, n2906, n2873, n2960, 
        n2872, n2949, n537, n538, n539, n540, n541, n542, n543, 
        n544, n545, n546, n547, n548, n549, n550, n551, n552, 
        n553, n554, n555, n556, n557, n558, n559, n560, n561, 
        n562, n563, n564, n566, n3030, n3029, n2947, n2959, 
        n2946, n2629, n2961, n2943, n2958, n2627;
    
    VHI i51 (.Z(VCC_net));
    led_toggle my_led (.fpga_led_c(fpga_led_c), .int_clk_out(int_clk_out), 
            .GND_net(GND_net), .VCC_net(VCC_net)) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(93[12] 99[2])
    internal_pll my_pll (.dpll_clkout2_c(dpll_clkout2_c), .stm_fpga_spare5_N_9(stm_fpga_spare5_N_9), 
            .internal_160MHz(internal_160MHz), .internal_80MHz(internal_80MHz), 
            .pll_lock(pll_lock), .GND_net(GND_net)) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(68[14] 76[2])
    LUT4 i2217_4_lut_then_2_lut (.A(o_debug_state[1]), .B(o_debug_state[0]), 
         .Z(n2959)) /* synthesis lut_function=(A (B)+!A !(B)) */ ;
    defparam i2217_4_lut_then_2_lut.init = 16'h9999;
    LUT4 i2217_4_lut_else_2_lut (.A(r_phase_count[1]), .B(o_debug_state[1]), 
         .C(o_debug_state[0]), .D(r_phase_count[2]), .Z(n2958)) /* synthesis lut_function=(!(A (B (C))+!A (B (C+!(D))+!B !((D)+!C)))) */ ;
    defparam i2217_4_lut_else_2_lut.init = 16'h3f2b;
    OSCG osch_inst (.OSC(int_clk_out)) /* synthesis syn_instantiated=1 */ ;
    defparam osch_inst.DIV = 128;
    LUT4 shift_reg_15__I_0_i12_3_lut_4_lut (.A(spi_busy_adj_237), .B(n2947), 
         .C(w_rx_09_fifo_data[11]), .D(shift_reg_adj_372[12]), .Z(shift_reg_15__N_168_adj_379[11])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i12_3_lut_4_lut.init = 16'hfb40;
    LUT4 i1674_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[8]), .Z(n348)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1674_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i11_3_lut_4_lut (.A(spi_busy_adj_237), .B(n2947), 
         .C(w_rx_09_fifo_data[10]), .D(shift_reg_adj_372[11]), .Z(shift_reg_15__N_168_adj_379[10])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i11_3_lut_4_lut.init = 16'hfb40;
    LUT4 i1678_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[9]), .Z(n347)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1678_2_lut_3_lut.init = 16'he0e0;
    LUT4 i2218_4_lut_then_2_lut (.A(o_debug_state_adj_343[1]), .B(o_debug_state_adj_343[0]), 
         .Z(n2962)) /* synthesis lut_function=(A (B)+!A !(B)) */ ;
    defparam i2218_4_lut_then_2_lut.init = 16'h9999;
    LUT4 i2218_4_lut_else_2_lut (.A(r_phase_count_adj_345[1]), .B(o_debug_state_adj_343[1]), 
         .C(o_debug_state_adj_343[0]), .D(r_phase_count_adj_345[2]), .Z(n2961)) /* synthesis lut_function=(!(A (B (C))+!A (B (C+!(D))+!B !((D)+!C)))) */ ;
    defparam i2218_4_lut_else_2_lut.init = 16'h3f2b;
    LUT4 shift_reg_15__I_0_i10_3_lut_4_lut (.A(spi_busy_adj_237), .B(n2947), 
         .C(w_rx_09_fifo_data[9]), .D(shift_reg_adj_372[10]), .Z(shift_reg_15__N_168_adj_379[9])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i10_3_lut_4_lut.init = 16'hfb40;
    LUT4 i1728_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[10]), .Z(n346)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1728_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1724_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[11]), .Z(n345)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1724_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1727_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[12]), .Z(n344)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1727_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i9_3_lut_4_lut (.A(spi_busy_adj_237), .B(n2947), 
         .C(w_rx_09_fifo_data[8]), .D(shift_reg_adj_372[9]), .Z(shift_reg_15__N_168_adj_379[8])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i9_3_lut_4_lut.init = 16'hfb40;
    LUT4 shift_reg_15__I_0_i8_3_lut_4_lut (.A(spi_busy_adj_237), .B(n2947), 
         .C(w_rx_09_fifo_data[7]), .D(shift_reg_adj_372[8]), .Z(shift_reg_15__N_168_adj_379[7])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i8_3_lut_4_lut.init = 16'hfb40;
    LUT4 i1713_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[13]), .Z(n343)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1713_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i7_3_lut_4_lut (.A(spi_busy_adj_237), .B(n2947), 
         .C(w_rx_09_fifo_data[6]), .D(shift_reg_adj_372[7]), .Z(shift_reg_15__N_168_adj_379[6])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i7_3_lut_4_lut.init = 16'hfb40;
    LUT4 i1693_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[14]), .Z(n342)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1693_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i6_3_lut_4_lut (.A(spi_busy_adj_237), .B(n2947), 
         .C(w_rx_09_fifo_data[5]), .D(shift_reg_adj_372[6]), .Z(shift_reg_15__N_168_adj_379[5])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i6_3_lut_4_lut.init = 16'hfb40;
    LUT4 i1671_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[15]), .Z(n341)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1671_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i5_3_lut_4_lut (.A(spi_busy_adj_237), .B(n2947), 
         .C(w_rx_09_fifo_data[4]), .D(shift_reg_adj_372[5]), .Z(shift_reg_15__N_168_adj_379[4])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i5_3_lut_4_lut.init = 16'hfb40;
    LUT4 i1677_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[16]), .Z(n340)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1677_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1730_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[17]), .Z(n339)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1730_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i4_3_lut_4_lut (.A(spi_busy_adj_237), .B(n2947), 
         .C(w_rx_09_fifo_data[3]), .D(shift_reg_adj_372[4]), .Z(shift_reg_15__N_168_adj_379[3])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i4_3_lut_4_lut.init = 16'hfb40;
    PFUMX i2294 (.BLUT(n2920), .ALUT(n2919), .C0(n2949), .Z(r_phase_count_2__N_123[1]));
    LUT4 shift_reg_15__I_0_i3_3_lut_4_lut (.A(spi_busy_adj_237), .B(n2947), 
         .C(w_rx_09_fifo_data[2]), .D(shift_reg_adj_372[3]), .Z(shift_reg_15__N_168_adj_379[2])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i3_3_lut_4_lut.init = 16'hfb40;
    LUT4 i1652_4_lut_4_lut (.A(spi_busy_adj_268), .B(n2943), .C(n3032), 
         .D(n2685), .Z(n1251)) /* synthesis lut_function=(A ((D)+!C)+!A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam i1652_4_lut_4_lut.init = 16'hee4e;
    LUT4 i1711_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[18]), .Z(n338)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1711_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i2_3_lut_4_lut (.A(spi_busy_adj_237), .B(n2947), 
         .C(w_rx_09_fifo_data[1]), .D(shift_reg_adj_372[2]), .Z(shift_reg_15__N_168_adj_379[1])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i2_3_lut_4_lut.init = 16'hfb40;
    LUT4 shift_reg_15__I_0_i15_3_lut_4_lut (.A(spi_busy_adj_237), .B(n2947), 
         .C(w_rx_09_fifo_data[14]), .D(shift_reg_adj_372[15]), .Z(shift_reg_15__N_168_adj_379[14])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i15_3_lut_4_lut.init = 16'hfb40;
    LUT4 shift_reg_15__I_0_i14_3_lut_4_lut (.A(spi_busy), .B(n2947), .C(w_rx_09_fifo_data[29]), 
         .D(shift_reg[14]), .Z(shift_reg_15__N_168[13])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i14_3_lut_4_lut.init = 16'hfb40;
    LUT4 i1673_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[19]), .Z(n337)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1673_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1680_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[20]), .Z(n336)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1680_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i13_3_lut_4_lut (.A(spi_busy), .B(n2947), .C(w_rx_09_fifo_data[28]), 
         .D(shift_reg[13]), .Z(shift_reg_15__N_168[12])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i13_3_lut_4_lut.init = 16'hfb40;
    LUT4 i1679_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[21]), .Z(n335)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1679_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1668_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[22]), .Z(n334)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1668_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1670_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[23]), .Z(n333)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1670_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i12_3_lut_4_lut_adj_25 (.A(spi_busy), .B(n2947), 
         .C(w_rx_09_fifo_data[27]), .D(shift_reg[12]), .Z(shift_reg_15__N_168[11])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i12_3_lut_4_lut_adj_25.init = 16'hfb40;
    LUT4 shift_reg_15__I_0_i11_3_lut_4_lut_adj_26 (.A(spi_busy), .B(n2947), 
         .C(w_rx_09_fifo_data[26]), .D(shift_reg[11]), .Z(shift_reg_15__N_168[10])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i11_3_lut_4_lut_adj_26.init = 16'hfb40;
    OB fpga_led_pad (.I(fpga_led_c), .O(fpga_led));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(2[14:22])
    spi_generator wifi_q_spi (.spi4_sck_c(spi4_sck_c), .n3029(n3029), .spi_busy(spi_busy_adj_299), 
            .n2935(n2935), .spi4_mosi_c(spi4_mosi_c), .internal_160MHz(internal_160MHz), 
            .internal_160MHz_enable_81(internal_160MHz_enable_81), .\shift_reg_15__N_168[0] (shift_reg_15__N_168_adj_409[0]), 
            .n1230(n1230), .\shift_reg[1] (shift_reg_adj_402[1]), .\shift_reg_15__N_168[1] (shift_reg_15__N_168_adj_409[1]), 
            .\shift_reg[2] (shift_reg_adj_402[2]), .\shift_reg_15__N_168[2] (shift_reg_15__N_168_adj_409[2]), 
            .\shift_reg[3] (shift_reg_adj_402[3]), .\shift_reg_15__N_168[3] (shift_reg_15__N_168_adj_409[3]), 
            .\shift_reg[4] (shift_reg_adj_402[4]), .\shift_reg_15__N_168[4] (shift_reg_15__N_168_adj_409[4]), 
            .\shift_reg[5] (shift_reg_adj_402[5]), .\shift_reg_15__N_168[5] (shift_reg_15__N_168_adj_409[5]), 
            .\shift_reg[6] (shift_reg_adj_402[6]), .\shift_reg_15__N_168[6] (shift_reg_15__N_168_adj_409[6]), 
            .\shift_reg[7] (shift_reg_adj_402[7]), .\shift_reg_15__N_168[7] (shift_reg_15__N_168_adj_409[7]), 
            .\shift_reg[8] (shift_reg_adj_402[8]), .\shift_reg_15__N_168[8] (shift_reg_15__N_168_adj_409[8]), 
            .\shift_reg[9] (shift_reg_adj_402[9]), .\shift_reg_15__N_168[9] (shift_reg_15__N_168_adj_409[9]), 
            .\shift_reg[10] (shift_reg_adj_402[10]), .\shift_reg_15__N_168[10] (shift_reg_15__N_168_adj_409[10]), 
            .\shift_reg[11] (shift_reg_adj_402[11]), .\shift_reg_15__N_168[11] (shift_reg_15__N_168_adj_409[11]), 
            .\shift_reg[12] (shift_reg_adj_402[12]), .\shift_reg_15__N_168[12] (shift_reg_15__N_168_adj_409[12]), 
            .\shift_reg[13] (shift_reg_adj_402[13]), .\shift_reg_15__N_168[13] (shift_reg_15__N_168_adj_409[13]), 
            .\shift_reg[14] (shift_reg_adj_402[14]), .\shift_reg_15__N_168[14] (shift_reg_15__N_168_adj_409[14]), 
            .\shift_reg[15] (shift_reg_adj_402[15]), .\w_rx_24_fifo_data[13] (w_rx_24_fifo_data[13]), 
            .n2689(n2689)) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(541[15] 549[2])
    LUT4 shift_reg_15__I_0_i10_3_lut_4_lut_adj_27 (.A(spi_busy), .B(n2947), 
         .C(w_rx_09_fifo_data[25]), .D(shift_reg[10]), .Z(shift_reg_15__N_168[9])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i10_3_lut_4_lut_adj_27.init = 16'hfb40;
    LUT4 i1750_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[24]), .Z(n332)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1750_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i12_3_lut_4_lut_adj_28 (.A(spi_busy_adj_268), .B(n2943), 
         .C(w_rx_24_fifo_data[28]), .D(shift_reg_adj_387[12]), .Z(shift_reg_15__N_168_adj_394[11])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i12_3_lut_4_lut_adj_28.init = 16'hfb40;
    PFUMX i2291 (.BLUT(n2910), .ALUT(n2909), .C0(n2946), .Z(r_phase_count_2__N_123_adj_358[1]));
    LUT4 shift_reg_15__I_0_i9_3_lut_4_lut_adj_29 (.A(spi_busy), .B(n2947), 
         .C(w_rx_09_fifo_data[24]), .D(shift_reg[9]), .Z(shift_reg_15__N_168[8])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i9_3_lut_4_lut_adj_29.init = 16'hfb40;
    LUT4 shift_reg_15__I_0_i11_3_lut_4_lut_adj_30 (.A(spi_busy_adj_268), .B(n2943), 
         .C(w_rx_24_fifo_data[27]), .D(shift_reg_adj_387[11]), .Z(shift_reg_15__N_168_adj_394[10])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i11_3_lut_4_lut_adj_30.init = 16'hfb40;
    LUT4 shift_reg_15__I_0_i8_3_lut_4_lut_adj_31 (.A(spi_busy), .B(n2947), 
         .C(w_rx_09_fifo_data[23]), .D(shift_reg[8]), .Z(shift_reg_15__N_168[7])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i8_3_lut_4_lut_adj_31.init = 16'hfb40;
    LUT4 i1683_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[25]), .Z(n331)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1683_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1698_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[26]), .Z(n330)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1698_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1699_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[27]), .Z(n329)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1699_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1249_2_lut_3_lut (.A(n2949), .B(o_debug_state[0]), .C(o_debug_state[1]), 
         .Z(n1766)) /* synthesis lut_function=(A (B (C))+!A (C)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1249_2_lut_3_lut.init = 16'hd0d0;
    LUT4 shift_reg_15__I_0_i7_3_lut_4_lut_adj_32 (.A(spi_busy), .B(n2947), 
         .C(w_rx_09_fifo_data[22]), .D(shift_reg[7]), .Z(shift_reg_15__N_168[6])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i7_3_lut_4_lut_adj_32.init = 16'hfb40;
    LUT4 shift_reg_15__I_0_i6_3_lut_4_lut_adj_33 (.A(spi_busy), .B(n2947), 
         .C(w_rx_09_fifo_data[21]), .D(shift_reg[6]), .Z(shift_reg_15__N_168[5])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i6_3_lut_4_lut_adj_33.init = 16'hfb40;
    LUT4 i1700_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[28]), .Z(n328)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1700_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i5_3_lut_4_lut_adj_34 (.A(spi_busy), .B(n2947), 
         .C(w_rx_09_fifo_data[20]), .D(shift_reg[5]), .Z(shift_reg_15__N_168[4])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i5_3_lut_4_lut_adj_34.init = 16'hfb40;
    LUT4 shift_reg_15__I_0_i10_3_lut_4_lut_adj_35 (.A(spi_busy_adj_268), .B(n2943), 
         .C(w_rx_24_fifo_data[26]), .D(shift_reg_adj_387[10]), .Z(shift_reg_15__N_168_adj_394[9])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i10_3_lut_4_lut_adj_35.init = 16'hfb40;
    LUT4 i1_2_lut_rep_49 (.A(w_rx_24_fifo_push), .B(stm_fpga_spare2_c), 
         .Z(n2943)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam i1_2_lut_rep_49.init = 16'h8888;
    LUT4 shift_reg_15__I_0_i9_3_lut_4_lut_adj_36 (.A(spi_busy_adj_268), .B(n2943), 
         .C(w_rx_24_fifo_data[25]), .D(shift_reg_adj_387[9]), .Z(shift_reg_15__N_168_adj_394[8])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i9_3_lut_4_lut_adj_36.init = 16'hfb40;
    OB fpga_neopixel_pad (.I(GND_net), .O(fpga_neopixel));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(3[14:27])
    LUT4 i1_2_lut_rep_37_3_lut (.A(w_rx_24_fifo_push), .B(stm_fpga_spare2_c), 
         .C(spi_busy_adj_268), .Z(n2931)) /* synthesis lut_function=(!(((C)+!B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam i1_2_lut_rep_37_3_lut.init = 16'h0808;
    LUT4 shift_reg_15__I_0_i8_3_lut_4_lut_adj_37 (.A(spi_busy_adj_268), .B(n2943), 
         .C(w_rx_24_fifo_data[24]), .D(shift_reg_adj_387[8]), .Z(shift_reg_15__N_168_adj_394[7])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i8_3_lut_4_lut_adj_37.init = 16'hfb40;
    LUT4 stm_fpga_spare5_I_0_1_lut (.A(stm_fpga_spare5_c), .Z(stm_fpga_spare5_N_9)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(70[7:23])
    defparam stm_fpga_spare5_I_0_1_lut.init = 16'h5555;
    LUT4 shift_reg_15__I_0_i7_3_lut_4_lut_adj_38 (.A(spi_busy_adj_268), .B(n2943), 
         .C(w_rx_24_fifo_data[23]), .D(shift_reg_adj_387[7]), .Z(shift_reg_15__N_168_adj_394[6])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i7_3_lut_4_lut_adj_38.init = 16'hfb40;
    LUT4 shift_reg_15__I_0_i4_3_lut_4_lut_adj_39 (.A(spi_busy), .B(n2947), 
         .C(w_rx_09_fifo_data[19]), .D(shift_reg[4]), .Z(shift_reg_15__N_168[3])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i4_3_lut_4_lut_adj_39.init = 16'hfb40;
    LUT4 i1701_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[29]), .Z(n327)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1701_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1_2_lut_rep_41_3_lut (.A(w_rx_24_fifo_push), .B(stm_fpga_spare2_c), 
         .C(spi_busy_adj_299), .Z(n2935)) /* synthesis lut_function=(!(((C)+!B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam i1_2_lut_rep_41_3_lut.init = 16'h0808;
    LUT4 i1736_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_lvds_rx_09_d0), .Z(n357)) /* synthesis lut_function=(A (C)+!A ((C)+!B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1736_2_lut_3_lut.init = 16'hf1f1;
    LUT4 i1_2_lut_3_lut_3_lut_4_lut (.A(w_rx_24_fifo_push), .B(stm_fpga_spare2_c), 
         .C(spi_busy_adj_268), .D(n3032), .Z(internal_160MHz_enable_82)) /* synthesis lut_function=(A (B ((D)+!C)+!B (C (D)))+!A (C (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam i1_2_lut_3_lut_3_lut_4_lut.init = 16'hf808;
    LUT4 i1_2_lut_3_lut_3_lut_4_lut_adj_40 (.A(w_rx_24_fifo_push), .B(stm_fpga_spare2_c), 
         .C(spi_busy_adj_299), .D(n3029), .Z(internal_160MHz_enable_81)) /* synthesis lut_function=(A (B ((D)+!C)+!B (C (D)))+!A (C (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam i1_2_lut_3_lut_3_lut_4_lut_adj_40.init = 16'hf808;
    LUT4 i1731_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[0]), .Z(n356)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1731_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1712_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[1]), .Z(n355)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1712_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1714_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[2]), .Z(n354)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1714_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1694_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[3]), .Z(n353)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1694_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i6_3_lut_4_lut_adj_41 (.A(spi_busy_adj_268), .B(n2943), 
         .C(w_rx_24_fifo_data[22]), .D(shift_reg_adj_387[6]), .Z(shift_reg_15__N_168_adj_394[5])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i6_3_lut_4_lut_adj_41.init = 16'hfb40;
    LUT4 i1695_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[4]), .Z(n352)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1695_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1696_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[5]), .Z(n351)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1696_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1681_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[6]), .Z(n350)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1681_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1675_2_lut_3_lut (.A(o_debug_state[0]), .B(o_debug_state[1]), 
         .C(w_rx_09_fifo_data[7]), .Z(n349)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1675_2_lut_3_lut.init = 16'he0e0;
    LUT4 i2_3_lut_rep_61 (.A(pll_lock), .B(stm_fpga_spare5_c), .C(second_pll_lock), 
         .Z(n2955)) /* synthesis lut_function=(A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(89[23:67])
    defparam i2_3_lut_rep_61.init = 16'h8080;
    LUT4 i1_2_lut_4_lut (.A(pll_lock), .B(stm_fpga_spare5_c), .C(second_pll_lock), 
         .D(wifi_ddr_data_valid), .Z(n2629)) /* synthesis lut_function=(A (B (C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(89[23:67])
    defparam i1_2_lut_4_lut.init = 16'h8000;
    LUT4 i1_2_lut_4_lut_adj_42 (.A(pll_lock), .B(stm_fpga_spare5_c), .C(second_pll_lock), 
         .D(subg_ddr_data_valid), .Z(n2627)) /* synthesis lut_function=(A (B (C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(89[23:67])
    defparam i1_2_lut_4_lut_adj_42.init = 16'h8000;
    OB sdr_txclk_pad (.I(GND_net), .O(sdr_txclk));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(11[14:23])
    OB sdr_txdata_pad (.I(GND_net), .O(sdr_txdata));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(12[14:24])
    OB spi1_sck_pad (.I(spi1_sck_c), .O(spi1_sck));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(22[14:22])
    OB spi1_mosi_pad (.I(spi1_mosi_c), .O(spi1_mosi));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(23[14:23])
    OB spi2_sck_pad (.I(fpga_ufl_p7_c), .O(spi2_sck));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(28[14:22])
    OB spi2_mosi_pad (.I(fpga_ufl_p8_c), .O(spi2_mosi));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(29[14:23])
    OB spi3_sck_pad (.I(spi3_sck_c), .O(spi3_sck));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(35[14:22])
    OB spi3_mosi_pad (.I(spi3_mosi_c), .O(spi3_mosi));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(36[14:23])
    OB spi4_sck_pad (.I(spi4_sck_c), .O(spi4_sck));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(40[14:22])
    OB spi4_mosi_pad (.I(spi4_mosi_c), .O(spi4_mosi));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(41[14:23])
    OB fpga_ufl_p7_pad (.I(fpga_ufl_p7_c), .O(fpga_ufl_p7));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(48[14:25])
    OB fpga_ufl_p8_pad (.I(fpga_ufl_p8_c), .O(fpga_ufl_p8));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(49[14:25])
    IB dpll_clkout2_pad (.I(dpll_clkout2), .O(dpll_clkout2_c));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(5[13:25])
    IB dpll_clkout0_pad (.I(dpll_clkout0), .O(dpll_clkout0_c));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(6[13:25])
    IB sdr_rx_wifi_pad (.I(sdr_rx_wifi), .O(sdr_rx_wifi_c));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(8[13:24])
    IB sdr_rx_subg_pad (.I(sdr_rx_subg), .O(sdr_rx_subg_c));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(9[13:24])
    IB sdr_rxclk_pad (.I(sdr_rxclk), .O(sdr_rxclk_c));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(10[13:22])
    IB stm_fpga_spare1_pad (.I(stm_fpga_spare1), .O(stm_fpga_spare1_c));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(32[13:28])
    IB stm_fpga_spare2_pad (.I(stm_fpga_spare2), .O(stm_fpga_spare2_c));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(44[13:28])
    IB stm_fpga_spare5_pad (.I(stm_fpga_spare5), .O(stm_fpga_spare5_c));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(51[13:28])
    LUT4 shift_reg_15__I_0_i3_3_lut_4_lut_adj_43 (.A(spi_busy), .B(n2947), 
         .C(w_rx_09_fifo_data[18]), .D(shift_reg[3]), .Z(shift_reg_15__N_168[2])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i3_3_lut_4_lut_adj_43.init = 16'hfb40;
    LUT4 main_reset_n_I_0_1_lut_3_lut (.A(pll_lock), .B(stm_fpga_spare5_c), 
         .C(second_pll_lock), .Z(main_reset_n_N_4)) /* synthesis lut_function=(!(A (B (C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(89[23:67])
    defparam main_reset_n_I_0_1_lut_3_lut.init = 16'h7f7f;
    LUT4 shift_reg_15__I_0_i13_3_lut_4_lut_adj_44 (.A(spi_busy_adj_268), .B(n2943), 
         .C(w_rx_24_fifo_data[29]), .D(shift_reg_adj_387[13]), .Z(shift_reg_15__N_168_adj_394[12])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i13_3_lut_4_lut_adj_44.init = 16'hfb40;
    LUT4 shift_reg_15__I_0_i5_3_lut_4_lut_adj_45 (.A(spi_busy_adj_268), .B(n2943), 
         .C(w_rx_24_fifo_data[21]), .D(shift_reg_adj_387[5]), .Z(shift_reg_15__N_168_adj_394[4])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i5_3_lut_4_lut_adj_45.init = 16'hfb40;
    LUT4 shift_reg_15__I_0_i2_3_lut_4_lut_adj_46 (.A(spi_busy), .B(n2947), 
         .C(w_rx_09_fifo_data[17]), .D(shift_reg[2]), .Z(shift_reg_15__N_168[1])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i2_3_lut_4_lut_adj_46.init = 16'hfb40;
    LUT4 i1_2_lut_rep_53 (.A(w_rx_09_fifo_push), .B(stm_fpga_spare1_c), 
         .Z(n2947)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam i1_2_lut_rep_53.init = 16'h8888;
    LUT4 i1_2_lut_rep_38_3_lut (.A(w_rx_09_fifo_push), .B(stm_fpga_spare1_c), 
         .C(spi_busy), .Z(n2932)) /* synthesis lut_function=(!(((C)+!B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam i1_2_lut_rep_38_3_lut.init = 16'h0808;
    LUT4 i1_2_lut_rep_44_3_lut (.A(w_rx_09_fifo_push), .B(stm_fpga_spare1_c), 
         .C(spi_busy_adj_237), .Z(n2938)) /* synthesis lut_function=(!(((C)+!B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam i1_2_lut_rep_44_3_lut.init = 16'h0808;
    LUT4 i1_2_lut_3_lut_3_lut_4_lut_adj_47 (.A(w_rx_09_fifo_push), .B(stm_fpga_spare1_c), 
         .C(n3031), .D(spi_busy_adj_237), .Z(internal_160MHz_enable_83)) /* synthesis lut_function=(A (B (C+!(D))+!B (C (D)))+!A (C (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam i1_2_lut_3_lut_3_lut_4_lut_adj_47.init = 16'hf088;
    LUT4 shift_reg_15__I_0_i15_3_lut_4_lut_adj_48 (.A(spi_busy), .B(n2947), 
         .C(w_rx_09_fifo_data[30]), .D(shift_reg[15]), .Z(shift_reg_15__N_168[14])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i15_3_lut_4_lut_adj_48.init = 16'hfb40;
    LUT4 i1_2_lut_3_lut_3_lut_4_lut_adj_49 (.A(w_rx_09_fifo_push), .B(stm_fpga_spare1_c), 
         .C(spi_busy), .D(n3030), .Z(internal_160MHz_enable_84)) /* synthesis lut_function=(A (B ((D)+!C)+!B (C (D)))+!A (C (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam i1_2_lut_3_lut_3_lut_4_lut_adj_49.init = 16'hf808;
    LUT4 i1672_4_lut (.A(w_lvds_rx_09_d1), .B(o_debug_state[0]), .C(n2949), 
         .D(o_debug_state[1]), .Z(n358)) /* synthesis lut_function=(A (B (C+!(D))+!B (C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1672_4_lut.init = 16'ha088;
    LUT4 i1662_4_lut_4_lut (.A(spi_busy_adj_299), .B(n2943), .C(n3029), 
         .D(n2689), .Z(n1230)) /* synthesis lut_function=(A ((D)+!C)+!A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam i1662_4_lut_4_lut.init = 16'hee4e;
    LUT4 i1666_4_lut_4_lut (.A(spi_busy), .B(n2947), .C(n3030), .D(n2693), 
         .Z(n1237)) /* synthesis lut_function=(A ((D)+!C)+!A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam i1666_4_lut_4_lut.init = 16'hee4e;
    LUT4 i1704_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(o_fifo_data_adj_342[0]), .Z(n564)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1704_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i13_3_lut_4_lut_adj_50 (.A(spi_busy_adj_237), .B(n2947), 
         .C(w_rx_09_fifo_data[12]), .D(shift_reg_adj_372[13]), .Z(shift_reg_15__N_168_adj_379[12])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i13_3_lut_4_lut_adj_50.init = 16'hfb40;
    LUT4 i1665_4_lut (.A(w_lvds_rx_24_d1), .B(o_debug_state_adj_343[0]), 
         .C(n2946), .D(o_debug_state_adj_343[1]), .Z(n566)) /* synthesis lut_function=(!(A+!(B (C+!(D))+!B (C (D))))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1665_4_lut.init = 16'h5044;
    LUT4 i2261_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_lvds_rx_24_d0), .Z(n2259)) /* synthesis lut_function=(!(A (C)+!A (B (C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i2261_2_lut_3_lut.init = 16'h1f1f;
    LUT4 i1705_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[1]), .Z(n563)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1705_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i13_3_lut_4_lut_adj_51 (.A(spi_busy_adj_299), .B(n2943), 
         .C(w_rx_24_fifo_data[13]), .D(shift_reg_adj_402[13]), .Z(shift_reg_15__N_168_adj_409[12])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i13_3_lut_4_lut_adj_51.init = 16'hfb40;
    LUT4 i1706_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[2]), .Z(n562)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1706_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1707_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[3]), .Z(n561)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1707_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i14_3_lut_4_lut_adj_52 (.A(spi_busy_adj_299), .B(n2943), 
         .C(w_rx_24_fifo_data[13]), .D(shift_reg_adj_402[14]), .Z(shift_reg_15__N_168_adj_409[13])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i14_3_lut_4_lut_adj_52.init = 16'hfb40;
    LUT4 i1708_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[4]), .Z(n560)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1708_2_lut_3_lut.init = 16'he0e0;
    PFUMX i2288 (.BLUT(n2907), .ALUT(n2906), .C0(n2946), .Z(r_phase_count_2__N_123_adj_358[2]));
    LUT4 shift_reg_15__I_0_i1_3_lut_4_lut (.A(spi_busy_adj_299), .B(n2943), 
         .C(w_rx_24_fifo_data[1]), .D(shift_reg_adj_402[1]), .Z(shift_reg_15__N_168_adj_409[0])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i1_3_lut_4_lut.init = 16'hfb40;
    LUT4 i1709_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[5]), .Z(n559)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1709_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i12_3_lut_4_lut_adj_53 (.A(spi_busy_adj_299), .B(n2943), 
         .C(w_rx_24_fifo_data[12]), .D(shift_reg_adj_402[12]), .Z(shift_reg_15__N_168_adj_409[11])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i12_3_lut_4_lut_adj_53.init = 16'hfb40;
    LUT4 shift_reg_15__I_0_i4_3_lut_4_lut_adj_54 (.A(spi_busy_adj_268), .B(n2943), 
         .C(w_rx_24_fifo_data[20]), .D(shift_reg_adj_387[4]), .Z(shift_reg_15__N_168_adj_394[3])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i4_3_lut_4_lut_adj_54.init = 16'hfb40;
    LUT4 i1710_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[6]), .Z(n558)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1710_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i11_3_lut_4_lut_adj_55 (.A(spi_busy_adj_299), .B(n2943), 
         .C(w_rx_24_fifo_data[11]), .D(shift_reg_adj_402[11]), .Z(shift_reg_15__N_168_adj_409[10])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i11_3_lut_4_lut_adj_55.init = 16'hfb40;
    LUT4 shift_reg_15__I_0_i3_3_lut_4_lut_adj_56 (.A(spi_busy_adj_268), .B(n2943), 
         .C(w_rx_24_fifo_data[19]), .D(shift_reg_adj_387[3]), .Z(shift_reg_15__N_168_adj_394[2])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i3_3_lut_4_lut_adj_56.init = 16'hfb40;
    LUT4 i1716_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[7]), .Z(n557)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1716_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1717_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[8]), .Z(n556)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1717_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i10_3_lut_4_lut_adj_57 (.A(spi_busy_adj_299), .B(n2943), 
         .C(w_rx_24_fifo_data[10]), .D(shift_reg_adj_402[10]), .Z(shift_reg_15__N_168_adj_409[9])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i10_3_lut_4_lut_adj_57.init = 16'hfb40;
    LUT4 i1718_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[9]), .Z(n555)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1718_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i9_3_lut_4_lut_adj_58 (.A(spi_busy_adj_299), .B(n2943), 
         .C(w_rx_24_fifo_data[9]), .D(shift_reg_adj_402[9]), .Z(shift_reg_15__N_168_adj_409[8])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i9_3_lut_4_lut_adj_58.init = 16'hfb40;
    LUT4 i1719_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[10]), .Z(n554)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1719_2_lut_3_lut.init = 16'he0e0;
    ddr_data_recovery_U3 subg_iddr (.internal_200MHz(internal_200MHz), .sdr_rx_subg_c(sdr_rx_subg_c), 
            .data_out({w_lvds_rx_09_d0, w_lvds_rx_09_d1}), .internal_80MHz(internal_80MHz), 
            .sdr_rxclk_c(sdr_rxclk_c), .subg_ddr_data_valid(subg_ddr_data_valid), 
            .data_rising(data_rising), .data_falling(data_falling), .n805(n805), 
            .n2955(n2955), .main_reset_n_N_4(main_reset_n_N_4), .GND_net(GND_net), 
            .rRst(rRst), .VCC_net(VCC_net)) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(204[19] 212[2])
    pll_10MHzInput second_pll (.dpll_clkout0_c(dpll_clkout0_c), .stm_fpga_spare5_N_9(stm_fpga_spare5_N_9), 
            .internal_200MHz(internal_200MHz), .second_pll_lock(second_pll_lock), 
            .GND_net(GND_net)) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(81[16] 86[2])
    LUT4 shift_reg_15__I_0_i1_3_lut_4_lut_adj_59 (.A(spi_busy), .B(n2947), 
         .C(w_rx_09_fifo_data[16]), .D(shift_reg[1]), .Z(shift_reg_15__N_168[0])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i1_3_lut_4_lut_adj_59.init = 16'hfb40;
    LUT4 i1720_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[11]), .Z(n553)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1720_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1721_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[12]), .Z(n552)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1721_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1722_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[13]), .Z(n551)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1722_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1723_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(o_fifo_data_adj_342[14]), .Z(n550)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1723_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i8_3_lut_4_lut_adj_60 (.A(spi_busy_adj_299), .B(n2943), 
         .C(w_rx_24_fifo_data[8]), .D(shift_reg_adj_402[8]), .Z(shift_reg_15__N_168_adj_409[7])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i8_3_lut_4_lut_adj_60.init = 16'hfb40;
    LUT4 i1725_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(o_fifo_data_adj_342[15]), .Z(n549)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1725_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i7_3_lut_4_lut_adj_61 (.A(spi_busy_adj_299), .B(n2943), 
         .C(w_rx_24_fifo_data[7]), .D(shift_reg_adj_402[7]), .Z(shift_reg_15__N_168_adj_409[6])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i7_3_lut_4_lut_adj_61.init = 16'hfb40;
    LUT4 i1737_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(o_fifo_data_adj_342[16]), .Z(n548)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1737_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i6_3_lut_4_lut_adj_62 (.A(spi_busy_adj_299), .B(n2943), 
         .C(w_rx_24_fifo_data[6]), .D(shift_reg_adj_402[6]), .Z(shift_reg_15__N_168_adj_409[5])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i6_3_lut_4_lut_adj_62.init = 16'hfb40;
    LUT4 shift_reg_15__I_0_i5_3_lut_4_lut_adj_63 (.A(spi_busy_adj_299), .B(n2943), 
         .C(w_rx_24_fifo_data[5]), .D(shift_reg_adj_402[5]), .Z(shift_reg_15__N_168_adj_409[4])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i5_3_lut_4_lut_adj_63.init = 16'hfb40;
    LUT4 i1726_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[17]), .Z(n547)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1726_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i4_3_lut_4_lut_adj_64 (.A(spi_busy_adj_299), .B(n2943), 
         .C(w_rx_24_fifo_data[4]), .D(shift_reg_adj_402[4]), .Z(shift_reg_15__N_168_adj_409[3])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i4_3_lut_4_lut_adj_64.init = 16'hfb40;
    LUT4 i1729_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[18]), .Z(n546)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1729_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1692_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[19]), .Z(n545)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1692_2_lut_3_lut.init = 16'he0e0;
    PFUMX i2278 (.BLUT(n2873), .ALUT(n2872), .C0(n2949), .Z(r_phase_count_2__N_123[2]));
    LUT4 shift_reg_15__I_0_i3_3_lut_4_lut_adj_65 (.A(spi_busy_adj_299), .B(n2943), 
         .C(w_rx_24_fifo_data[3]), .D(shift_reg_adj_402[3]), .Z(shift_reg_15__N_168_adj_409[2])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i3_3_lut_4_lut_adj_65.init = 16'hfb40;
    LUT4 shift_reg_15__I_0_i2_3_lut_4_lut_adj_66 (.A(spi_busy_adj_299), .B(n2943), 
         .C(w_rx_24_fifo_data[2]), .D(shift_reg_adj_402[2]), .Z(shift_reg_15__N_168_adj_409[1])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i2_3_lut_4_lut_adj_66.init = 16'hfb40;
    LUT4 shift_reg_15__I_0_i2_3_lut_4_lut_adj_67 (.A(spi_busy_adj_268), .B(n2943), 
         .C(w_rx_24_fifo_data[18]), .D(shift_reg_adj_387[2]), .Z(shift_reg_15__N_168_adj_394[1])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i2_3_lut_4_lut_adj_67.init = 16'hfb40;
    LUT4 shift_reg_15__I_0_i15_3_lut_4_lut_adj_68 (.A(spi_busy_adj_299), .B(n2943), 
         .C(w_rx_24_fifo_data[13]), .D(shift_reg_adj_402[15]), .Z(shift_reg_15__N_168_adj_409[14])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i15_3_lut_4_lut_adj_68.init = 16'hfb40;
    LUT4 i1691_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[20]), .Z(n544)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1691_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1690_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[21]), .Z(n543)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1690_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1689_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[22]), .Z(n542)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1689_2_lut_3_lut.init = 16'he0e0;
    lvds_rx lvds_rx_24_inst (.wifi_ddr_data_valid(wifi_ddr_data_valid), .o_debug_state({o_debug_state_adj_343}), 
            .\o_fifo_data[0] (o_fifo_data_adj_342[0]), .internal_80MHz(internal_80MHz), 
            .n566(n566), .r_phase_count({r_phase_count_adj_345}), .n2963(n2963), 
            .w_rx_24_fifo_push(w_rx_24_fifo_push), .data_out({w_lvds_rx_24_d0, 
            w_lvds_rx_24_d1}), .n2946(n2946), .n2906(n2906), .\w_rx_24_fifo_data[1] (w_rx_24_fifo_data[1]), 
            .n2259(n2259), .\w_rx_24_fifo_data[2] (w_rx_24_fifo_data[2]), 
            .n564(n564), .n2907(n2907), .\w_rx_24_fifo_data[3] (w_rx_24_fifo_data[3]), 
            .n563(n563), .\w_rx_24_fifo_data[4] (w_rx_24_fifo_data[4]), 
            .n562(n562), .\w_rx_24_fifo_data[5] (w_rx_24_fifo_data[5]), 
            .n561(n561), .\w_rx_24_fifo_data[6] (w_rx_24_fifo_data[6]), 
            .n560(n560), .\w_rx_24_fifo_data[7] (w_rx_24_fifo_data[7]), 
            .n559(n559), .\w_rx_24_fifo_data[8] (w_rx_24_fifo_data[8]), 
            .n558(n558), .\w_rx_24_fifo_data[9] (w_rx_24_fifo_data[9]), 
            .n557(n557), .\w_rx_24_fifo_data[10] (w_rx_24_fifo_data[10]), 
            .n556(n556), .\w_rx_24_fifo_data[11] (w_rx_24_fifo_data[11]), 
            .n555(n555), .\w_rx_24_fifo_data[12] (w_rx_24_fifo_data[12]), 
            .n554(n554), .\w_rx_24_fifo_data[13] (w_rx_24_fifo_data[13]), 
            .n553(n553), .\o_fifo_data[14] (o_fifo_data_adj_342[14]), .n552(n552), 
            .\o_fifo_data[15] (o_fifo_data_adj_342[15]), .n551(n551), .\o_fifo_data[16] (o_fifo_data_adj_342[16]), 
            .n550(n550), .\w_rx_24_fifo_data[17] (w_rx_24_fifo_data[17]), 
            .n549(n549), .\w_rx_24_fifo_data[18] (w_rx_24_fifo_data[18]), 
            .n548(n548), .\w_rx_24_fifo_data[19] (w_rx_24_fifo_data[19]), 
            .n547(n547), .\w_rx_24_fifo_data[20] (w_rx_24_fifo_data[20]), 
            .n546(n546), .\w_rx_24_fifo_data[21] (w_rx_24_fifo_data[21]), 
            .n545(n545), .\w_rx_24_fifo_data[22] (w_rx_24_fifo_data[22]), 
            .n544(n544), .\w_rx_24_fifo_data[23] (w_rx_24_fifo_data[23]), 
            .n543(n543), .\w_rx_24_fifo_data[24] (w_rx_24_fifo_data[24]), 
            .n542(n542), .\w_rx_24_fifo_data[25] (w_rx_24_fifo_data[25]), 
            .n541(n541), .\w_rx_24_fifo_data[26] (w_rx_24_fifo_data[26]), 
            .n540(n540), .\w_rx_24_fifo_data[27] (w_rx_24_fifo_data[27]), 
            .n539(n539), .\w_rx_24_fifo_data[28] (w_rx_24_fifo_data[28]), 
            .n538(n538), .\w_rx_24_fifo_data[29] (w_rx_24_fifo_data[29]), 
            .n537(n537), .\r_phase_count_2__N_123[1] (r_phase_count_2__N_123_adj_358[1]), 
            .\r_phase_count_2__N_123[2] (r_phase_count_2__N_123_adj_358[2]), 
            .n2629(n2629), .n2910(n2910), .n2909(n2909)) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(268[9] 280[2])
    LUT4 i1688_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[23]), .Z(n541)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1688_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i14_3_lut_4_lut_adj_69 (.A(spi_busy_adj_268), .B(n2943), 
         .C(w_rx_24_fifo_data[29]), .D(shift_reg_adj_387[14]), .Z(shift_reg_15__N_168_adj_394[13])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i14_3_lut_4_lut_adj_69.init = 16'hfb40;
    LUT4 i1687_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[24]), .Z(n540)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1687_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i15_3_lut_4_lut_adj_70 (.A(spi_busy_adj_268), .B(n2943), 
         .C(w_rx_24_fifo_data[29]), .D(shift_reg_adj_387[15]), .Z(shift_reg_15__N_168_adj_394[14])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i15_3_lut_4_lut_adj_70.init = 16'hfb40;
    LUT4 i1686_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[25]), .Z(n539)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1686_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1685_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[26]), .Z(n538)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1685_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1684_2_lut_3_lut (.A(o_debug_state_adj_343[0]), .B(o_debug_state_adj_343[1]), 
         .C(w_rx_24_fifo_data[27]), .Z(n537)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam i1684_2_lut_3_lut.init = 16'he0e0;
    LUT4 shift_reg_15__I_0_i1_3_lut_4_lut_adj_71 (.A(spi_busy_adj_268), .B(n2943), 
         .C(w_rx_24_fifo_data[17]), .D(shift_reg_adj_387[1]), .Z(shift_reg_15__N_168_adj_394[0])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(479[23:58])
    defparam shift_reg_15__I_0_i1_3_lut_4_lut_adj_71.init = 16'hfb40;
    spi_generator_U4 subg_i_spi (.spi_busy(spi_busy), .internal_160MHz(internal_160MHz), 
            .n1237(n1237), .spi1_sck_c(spi1_sck_c), .n3030(n3030), .internal_160MHz_enable_84(internal_160MHz_enable_84), 
            .\shift_reg_15__N_168[0] (shift_reg_15__N_168[0]), .n2932(n2932), 
            .spi1_mosi_c(spi1_mosi_c), .\shift_reg[1] (shift_reg[1]), .\shift_reg_15__N_168[1] (shift_reg_15__N_168[1]), 
            .\shift_reg[2] (shift_reg[2]), .\shift_reg_15__N_168[2] (shift_reg_15__N_168[2]), 
            .\shift_reg[3] (shift_reg[3]), .\shift_reg_15__N_168[3] (shift_reg_15__N_168[3]), 
            .\shift_reg[4] (shift_reg[4]), .\shift_reg_15__N_168[4] (shift_reg_15__N_168[4]), 
            .\shift_reg[5] (shift_reg[5]), .\shift_reg_15__N_168[5] (shift_reg_15__N_168[5]), 
            .\shift_reg[6] (shift_reg[6]), .\shift_reg_15__N_168[6] (shift_reg_15__N_168[6]), 
            .\shift_reg[7] (shift_reg[7]), .\shift_reg_15__N_168[7] (shift_reg_15__N_168[7]), 
            .\shift_reg[8] (shift_reg[8]), .\shift_reg_15__N_168[8] (shift_reg_15__N_168[8]), 
            .\shift_reg[9] (shift_reg[9]), .\shift_reg_15__N_168[9] (shift_reg_15__N_168[9]), 
            .\shift_reg[10] (shift_reg[10]), .\shift_reg_15__N_168[10] (shift_reg_15__N_168[10]), 
            .\shift_reg[11] (shift_reg[11]), .\shift_reg_15__N_168[11] (shift_reg_15__N_168[11]), 
            .\shift_reg[12] (shift_reg[12]), .\shift_reg_15__N_168[12] (shift_reg_15__N_168[12]), 
            .\shift_reg[13] (shift_reg[13]), .\shift_reg_15__N_168[13] (shift_reg_15__N_168[13]), 
            .\shift_reg[14] (shift_reg[14]), .\shift_reg_15__N_168[14] (shift_reg_15__N_168[14]), 
            .n2693(n2693), .\shift_reg[15] (shift_reg[15]), .\w_rx_09_fifo_data[31] (w_rx_09_fifo_data[31])) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(505[15] 515[2])
    LUT4 i1740_4_lut_4_lut (.A(spi_busy_adj_237), .B(n2947), .C(n3031), 
         .D(n2681), .Z(n1220)) /* synthesis lut_function=(A ((D)+!C)+!A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam i1740_4_lut_4_lut.init = 16'hee4e;
    ddr_data_recovery wifi_iddr (.data_out({w_lvds_rx_24_d0, w_lvds_rx_24_d1}), 
            .internal_80MHz(internal_80MHz), .wifi_ddr_data_valid(wifi_ddr_data_valid), 
            .internal_200MHz(internal_200MHz), .data_rising(data_rising), 
            .sdr_rx_wifi_c(sdr_rx_wifi_c), .n805(n805), .data_falling(data_falling), 
            .n2955(n2955), .rRst(rRst), .VCC_net(VCC_net), .GND_net(GND_net), 
            .main_reset_n_N_4(main_reset_n_N_4)) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(194[19] 202[2])
    spi_generator_U2 subg_q_spi (.fpga_ufl_p7_c(fpga_ufl_p7_c), .n3031(n3031), 
            .internal_160MHz(internal_160MHz), .internal_160MHz_enable_83(internal_160MHz_enable_83), 
            .\shift_reg_15__N_168[0] (shift_reg_15__N_168_adj_379[0]), .n2938(n2938), 
            .fpga_ufl_p8_c(fpga_ufl_p8_c), .spi_busy(spi_busy_adj_237), 
            .n1220(n1220), .\shift_reg[1] (shift_reg_adj_372[1]), .\shift_reg_15__N_168[1] (shift_reg_15__N_168_adj_379[1]), 
            .n2681(n2681), .\shift_reg[2] (shift_reg_adj_372[2]), .\shift_reg_15__N_168[2] (shift_reg_15__N_168_adj_379[2]), 
            .\shift_reg[3] (shift_reg_adj_372[3]), .\shift_reg_15__N_168[3] (shift_reg_15__N_168_adj_379[3]), 
            .\shift_reg[4] (shift_reg_adj_372[4]), .\shift_reg_15__N_168[4] (shift_reg_15__N_168_adj_379[4]), 
            .\shift_reg[5] (shift_reg_adj_372[5]), .\shift_reg_15__N_168[5] (shift_reg_15__N_168_adj_379[5]), 
            .\shift_reg[6] (shift_reg_adj_372[6]), .\shift_reg_15__N_168[6] (shift_reg_15__N_168_adj_379[6]), 
            .\shift_reg[7] (shift_reg_adj_372[7]), .\shift_reg_15__N_168[7] (shift_reg_15__N_168_adj_379[7]), 
            .\shift_reg[8] (shift_reg_adj_372[8]), .\shift_reg_15__N_168[8] (shift_reg_15__N_168_adj_379[8]), 
            .\shift_reg[9] (shift_reg_adj_372[9]), .\shift_reg_15__N_168[9] (shift_reg_15__N_168_adj_379[9]), 
            .\shift_reg[10] (shift_reg_adj_372[10]), .\shift_reg_15__N_168[10] (shift_reg_15__N_168_adj_379[10]), 
            .\shift_reg[11] (shift_reg_adj_372[11]), .\shift_reg_15__N_168[11] (shift_reg_15__N_168_adj_379[11]), 
            .\shift_reg[12] (shift_reg_adj_372[12]), .\shift_reg_15__N_168[12] (shift_reg_15__N_168_adj_379[12]), 
            .\shift_reg[13] (shift_reg_adj_372[13]), .\shift_reg_15__N_168[13] (shift_reg_15__N_168_adj_379[13]), 
            .\shift_reg[14] (shift_reg_adj_372[14]), .\shift_reg_15__N_168[14] (shift_reg_15__N_168_adj_379[14]), 
            .\shift_reg[15] (shift_reg_adj_372[15]), .\w_rx_09_fifo_data[15] (w_rx_09_fifo_data[15])) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(519[15] 529[2])
    GSR GSR_INST (.GSR(n2955));
    PUR PUR_INST (.PUR(VCC_net));
    defparam PUR_INST.RST_PULSE = 1;
    LUT4 shift_reg_15__I_0_i1_3_lut_4_lut_adj_72 (.A(spi_busy_adj_237), .B(n2947), 
         .C(w_rx_09_fifo_data[0]), .D(shift_reg_adj_372[1]), .Z(shift_reg_15__N_168_adj_379[0])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i1_3_lut_4_lut_adj_72.init = 16'hfb40;
    LUT4 shift_reg_15__I_0_i14_3_lut_4_lut_adj_73 (.A(spi_busy_adj_237), .B(n2947), 
         .C(w_rx_09_fifo_data[13]), .D(shift_reg_adj_372[14]), .Z(shift_reg_15__N_168_adj_379[13])) /* synthesis lut_function=(A (D)+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[23:58])
    defparam shift_reg_15__I_0_i14_3_lut_4_lut_adj_73.init = 16'hfb40;
    lvds_rx_U5 lvds_rx_09_inst (.w_rx_09_fifo_data({w_rx_09_fifo_data}), .internal_80MHz(internal_80MHz), 
            .n326({n327, n328, n329, n330, n331, n332, n333, n334, 
            n335, n336, n337, n338, n339, n340, n341, n342, 
            n343, n344, n345, n346, n347, n348, n349, n350, 
            n351, n352, n353, n354, n355, n356, n357, n358}), 
            .r_phase_count({r_phase_count}), .subg_ddr_data_valid(subg_ddr_data_valid), 
            .n2960(n2960), .o_debug_state({o_debug_state}), .n2872(n2872), 
            .data_out({w_lvds_rx_09_d0, w_lvds_rx_09_d1}), .n2949(n2949), 
            .w_rx_09_fifo_push(w_rx_09_fifo_push), .\r_phase_count_2__N_123[2] (r_phase_count_2__N_123[2]), 
            .\r_phase_count_2__N_123[1] (r_phase_count_2__N_123[1]), .n2920(n2920), 
            .n2873(n2873), .n2919(n2919), .n2627(n2627), .n1766(n1766)) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(253[9] 265[2])
    spi_generator_U1 wifi_i_spi (.spi_busy(spi_busy_adj_268), .internal_160MHz(internal_160MHz), 
            .n1251(n1251), .spi3_sck_c(spi3_sck_c), .n3032(n3032), .spi3_mosi_c(spi3_mosi_c), 
            .internal_160MHz_enable_82(internal_160MHz_enable_82), .\shift_reg_15__N_168[0] (shift_reg_15__N_168_adj_394[0]), 
            .n2931(n2931), .\shift_reg[1] (shift_reg_adj_387[1]), .\shift_reg_15__N_168[1] (shift_reg_15__N_168_adj_394[1]), 
            .\shift_reg[2] (shift_reg_adj_387[2]), .\shift_reg_15__N_168[2] (shift_reg_15__N_168_adj_394[2]), 
            .\shift_reg[3] (shift_reg_adj_387[3]), .\shift_reg_15__N_168[3] (shift_reg_15__N_168_adj_394[3]), 
            .\shift_reg[4] (shift_reg_adj_387[4]), .\shift_reg_15__N_168[4] (shift_reg_15__N_168_adj_394[4]), 
            .\shift_reg[5] (shift_reg_adj_387[5]), .\shift_reg_15__N_168[5] (shift_reg_15__N_168_adj_394[5]), 
            .\shift_reg[6] (shift_reg_adj_387[6]), .\shift_reg_15__N_168[6] (shift_reg_15__N_168_adj_394[6]), 
            .\shift_reg[7] (shift_reg_adj_387[7]), .\shift_reg_15__N_168[7] (shift_reg_15__N_168_adj_394[7]), 
            .\shift_reg[8] (shift_reg_adj_387[8]), .\shift_reg_15__N_168[8] (shift_reg_15__N_168_adj_394[8]), 
            .\shift_reg[9] (shift_reg_adj_387[9]), .\shift_reg_15__N_168[9] (shift_reg_15__N_168_adj_394[9]), 
            .\shift_reg[10] (shift_reg_adj_387[10]), .\shift_reg_15__N_168[10] (shift_reg_15__N_168_adj_394[10]), 
            .\shift_reg[11] (shift_reg_adj_387[11]), .\shift_reg_15__N_168[11] (shift_reg_15__N_168_adj_394[11]), 
            .\shift_reg[12] (shift_reg_adj_387[12]), .\shift_reg_15__N_168[12] (shift_reg_15__N_168_adj_394[12]), 
            .\shift_reg[13] (shift_reg_adj_387[13]), .\shift_reg_15__N_168[13] (shift_reg_15__N_168_adj_394[13]), 
            .\shift_reg[14] (shift_reg_adj_387[14]), .\shift_reg_15__N_168[14] (shift_reg_15__N_168_adj_394[14]), 
            .\shift_reg[15] (shift_reg_adj_387[15]), .\w_rx_24_fifo_data[29] (w_rx_24_fifo_data[29]), 
            .n2685(n2685)) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(531[15] 539[2])
    PFUMX i2300 (.BLUT(n2961), .ALUT(n2962), .C0(r_phase_count_adj_345[0]), 
          .Z(n2963));
    PFUMX i2298 (.BLUT(n2958), .ALUT(n2959), .C0(r_phase_count[0]), .Z(n2960));
    VLO i1 (.Z(GND_net));
    
endmodule
//
// Verilog Description of module led_toggle
//

module led_toggle (fpga_led_c, int_clk_out, GND_net, VCC_net) /* synthesis syn_module_defined=1 */ ;
    output fpga_led_c;
    input int_clk_out;
    input GND_net;
    input VCC_net;
    
    wire int_clk_out /* synthesis DSPPORT_20=CLK3, CLOCK_NET_FOR_BUS20=20, is_clock=1, SET_AS_NETWORK=int_clk_out */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(56[6:17])
    wire GND_net /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(13[23:34])
    wire VCC_net /* synthesis CE_NET_FOR_BUS20=20, DSPPORT_20=CE3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(125[10:19])
    
    wire led_N_63;
    wire [25:0]counter;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(7[16:23])
    
    wire n1943;
    wire [25:0]n109;
    
    wire n2360, n2361, n2773, n2739, n2781, n2721, n2713, n2725, 
        n2717, n2699, n2701, n2705, n2372, n2371, n2370, n2369, 
        n2368, n2367, n2366, n2365, n2362, n2363, n2364;
    
    FD1S3AX led_12 (.D(led_N_63), .CK(int_clk_out), .Q(fpga_led_c)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=12, LSE_RCOL=2, LSE_LLINE=93, LSE_RLINE=99 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(14[18] 22[12])
    defparam led_12.GSR = "ENABLED";
    FD1S3IX counter_257__i0 (.D(n109[0]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[0])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i0.GSR = "ENABLED";
    LUT4 i1_2_lut (.A(fpga_led_c), .B(n1943), .Z(led_N_63)) /* synthesis lut_function=(!(A (B)+!A !(B))) */ ;
    defparam i1_2_lut.init = 16'h6666;
    CCU2C counter_257_add_4_3 (.A0(counter[1]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[2]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n2360), .COUT(n2361), .S0(n109[1]), .S1(n109[2]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257_add_4_3.INIT0 = 16'haaa0;
    defparam counter_257_add_4_3.INIT1 = 16'haaa0;
    defparam counter_257_add_4_3.INJECT1_0 = "NO";
    defparam counter_257_add_4_3.INJECT1_1 = "NO";
    LUT4 i2258_4_lut (.A(n2773), .B(n2739), .C(n2781), .D(n2721), .Z(n1943)) /* synthesis lut_function=(!((B+((D)+!C))+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(16[8:28])
    defparam i2258_4_lut.init = 16'h0020;
    FD1S3IX counter_257__i1 (.D(n109[1]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[1])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i1.GSR = "ENABLED";
    LUT4 i2207_2_lut (.A(counter[9]), .B(counter[17]), .Z(n2773)) /* synthesis lut_function=(A (B)) */ ;
    defparam i2207_2_lut.init = 16'h8888;
    LUT4 i1_4_lut (.A(n2713), .B(n2725), .C(counter[7]), .D(n2717), 
         .Z(n2739)) /* synthesis lut_function=(A+(B+((D)+!C))) */ ;
    defparam i1_4_lut.init = 16'hffef;
    LUT4 i2215_4_lut (.A(counter[11]), .B(counter[20]), .C(counter[14]), 
         .D(counter[10]), .Z(n2781)) /* synthesis lut_function=(A (B (C (D)))) */ ;
    defparam i2215_4_lut.init = 16'h8000;
    LUT4 i1_4_lut_adj_18 (.A(counter[22]), .B(n2699), .C(n2701), .D(counter[15]), 
         .Z(n2721)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_adj_18.init = 16'hfffe;
    LUT4 i1_4_lut_adj_19 (.A(counter[6]), .B(counter[24]), .C(counter[19]), 
         .D(counter[1]), .Z(n2713)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_adj_19.init = 16'hfffe;
    LUT4 i1_4_lut_adj_20 (.A(counter[8]), .B(counter[13]), .C(n2705), 
         .D(counter[3]), .Z(n2725)) /* synthesis lut_function=((B+(C+(D)))+!A) */ ;
    defparam i1_4_lut_adj_20.init = 16'hfffd;
    LUT4 i1_4_lut_adj_21 (.A(counter[12]), .B(counter[0]), .C(counter[18]), 
         .D(counter[16]), .Z(n2717)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_adj_21.init = 16'hfffe;
    LUT4 i1_2_lut_adj_22 (.A(counter[21]), .B(counter[4]), .Z(n2705)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut_adj_22.init = 16'heeee;
    LUT4 i1_2_lut_adj_23 (.A(counter[23]), .B(counter[5]), .Z(n2699)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut_adj_23.init = 16'heeee;
    LUT4 i1_2_lut_adj_24 (.A(counter[25]), .B(counter[2]), .Z(n2701)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut_adj_24.init = 16'heeee;
    CCU2C counter_257_add_4_27 (.A0(counter[25]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(GND_net), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n2372), .S0(n109[25]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257_add_4_27.INIT0 = 16'haaa0;
    defparam counter_257_add_4_27.INIT1 = 16'h0000;
    defparam counter_257_add_4_27.INJECT1_0 = "NO";
    defparam counter_257_add_4_27.INJECT1_1 = "NO";
    CCU2C counter_257_add_4_25 (.A0(counter[23]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[24]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n2371), .COUT(n2372), .S0(n109[23]), .S1(n109[24]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257_add_4_25.INIT0 = 16'haaa0;
    defparam counter_257_add_4_25.INIT1 = 16'haaa0;
    defparam counter_257_add_4_25.INJECT1_0 = "NO";
    defparam counter_257_add_4_25.INJECT1_1 = "NO";
    CCU2C counter_257_add_4_23 (.A0(counter[21]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[22]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n2370), .COUT(n2371), .S0(n109[21]), .S1(n109[22]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257_add_4_23.INIT0 = 16'haaa0;
    defparam counter_257_add_4_23.INIT1 = 16'haaa0;
    defparam counter_257_add_4_23.INJECT1_0 = "NO";
    defparam counter_257_add_4_23.INJECT1_1 = "NO";
    CCU2C counter_257_add_4_21 (.A0(counter[19]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[20]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n2369), .COUT(n2370), .S0(n109[19]), .S1(n109[20]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257_add_4_21.INIT0 = 16'haaa0;
    defparam counter_257_add_4_21.INIT1 = 16'haaa0;
    defparam counter_257_add_4_21.INJECT1_0 = "NO";
    defparam counter_257_add_4_21.INJECT1_1 = "NO";
    CCU2C counter_257_add_4_19 (.A0(counter[17]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[18]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n2368), .COUT(n2369), .S0(n109[17]), .S1(n109[18]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257_add_4_19.INIT0 = 16'haaa0;
    defparam counter_257_add_4_19.INIT1 = 16'haaa0;
    defparam counter_257_add_4_19.INJECT1_0 = "NO";
    defparam counter_257_add_4_19.INJECT1_1 = "NO";
    CCU2C counter_257_add_4_17 (.A0(counter[15]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[16]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n2367), .COUT(n2368), .S0(n109[15]), .S1(n109[16]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257_add_4_17.INIT0 = 16'haaa0;
    defparam counter_257_add_4_17.INIT1 = 16'haaa0;
    defparam counter_257_add_4_17.INJECT1_0 = "NO";
    defparam counter_257_add_4_17.INJECT1_1 = "NO";
    CCU2C counter_257_add_4_15 (.A0(counter[13]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[14]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n2366), .COUT(n2367), .S0(n109[13]), .S1(n109[14]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257_add_4_15.INIT0 = 16'haaa0;
    defparam counter_257_add_4_15.INIT1 = 16'haaa0;
    defparam counter_257_add_4_15.INJECT1_0 = "NO";
    defparam counter_257_add_4_15.INJECT1_1 = "NO";
    FD1S3IX counter_257__i2 (.D(n109[2]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[2])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i2.GSR = "ENABLED";
    FD1S3IX counter_257__i3 (.D(n109[3]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[3])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i3.GSR = "ENABLED";
    FD1S3IX counter_257__i4 (.D(n109[4]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[4])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i4.GSR = "ENABLED";
    FD1S3IX counter_257__i5 (.D(n109[5]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[5])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i5.GSR = "ENABLED";
    FD1S3IX counter_257__i6 (.D(n109[6]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[6])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i6.GSR = "ENABLED";
    FD1S3IX counter_257__i7 (.D(n109[7]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[7])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i7.GSR = "ENABLED";
    FD1S3IX counter_257__i8 (.D(n109[8]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[8])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i8.GSR = "ENABLED";
    FD1S3IX counter_257__i9 (.D(n109[9]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[9])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i9.GSR = "ENABLED";
    FD1S3IX counter_257__i10 (.D(n109[10]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[10])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i10.GSR = "ENABLED";
    FD1S3IX counter_257__i11 (.D(n109[11]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[11])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i11.GSR = "ENABLED";
    FD1S3IX counter_257__i12 (.D(n109[12]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[12])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i12.GSR = "ENABLED";
    FD1S3IX counter_257__i13 (.D(n109[13]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[13])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i13.GSR = "ENABLED";
    FD1S3IX counter_257__i14 (.D(n109[14]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[14])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i14.GSR = "ENABLED";
    FD1S3IX counter_257__i15 (.D(n109[15]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[15])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i15.GSR = "ENABLED";
    FD1S3IX counter_257__i16 (.D(n109[16]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[16])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i16.GSR = "ENABLED";
    FD1S3IX counter_257__i17 (.D(n109[17]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[17])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i17.GSR = "ENABLED";
    FD1S3IX counter_257__i18 (.D(n109[18]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[18])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i18.GSR = "ENABLED";
    FD1S3IX counter_257__i19 (.D(n109[19]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[19])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i19.GSR = "ENABLED";
    FD1S3IX counter_257__i20 (.D(n109[20]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[20])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i20.GSR = "ENABLED";
    FD1S3IX counter_257__i21 (.D(n109[21]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[21])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i21.GSR = "ENABLED";
    FD1S3IX counter_257__i22 (.D(n109[22]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[22])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i22.GSR = "ENABLED";
    FD1S3IX counter_257__i23 (.D(n109[23]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[23])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i23.GSR = "ENABLED";
    FD1S3IX counter_257__i24 (.D(n109[24]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[24])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i24.GSR = "ENABLED";
    FD1S3IX counter_257__i25 (.D(n109[25]), .CK(int_clk_out), .CD(n1943), 
            .Q(counter[25])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257__i25.GSR = "ENABLED";
    CCU2C counter_257_add_4_13 (.A0(counter[11]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[12]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n2365), .COUT(n2366), .S0(n109[11]), .S1(n109[12]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257_add_4_13.INIT0 = 16'haaa0;
    defparam counter_257_add_4_13.INIT1 = 16'haaa0;
    defparam counter_257_add_4_13.INJECT1_0 = "NO";
    defparam counter_257_add_4_13.INJECT1_1 = "NO";
    CCU2C counter_257_add_4_7 (.A0(counter[5]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[6]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n2362), .COUT(n2363), .S0(n109[5]), .S1(n109[6]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257_add_4_7.INIT0 = 16'haaa0;
    defparam counter_257_add_4_7.INIT1 = 16'haaa0;
    defparam counter_257_add_4_7.INJECT1_0 = "NO";
    defparam counter_257_add_4_7.INJECT1_1 = "NO";
    CCU2C counter_257_add_4_11 (.A0(counter[9]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[10]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n2364), .COUT(n2365), .S0(n109[9]), .S1(n109[10]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257_add_4_11.INIT0 = 16'haaa0;
    defparam counter_257_add_4_11.INIT1 = 16'haaa0;
    defparam counter_257_add_4_11.INJECT1_0 = "NO";
    defparam counter_257_add_4_11.INJECT1_1 = "NO";
    CCU2C counter_257_add_4_9 (.A0(counter[7]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[8]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n2363), .COUT(n2364), .S0(n109[7]), .S1(n109[8]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257_add_4_9.INIT0 = 16'haaa0;
    defparam counter_257_add_4_9.INIT1 = 16'haaa0;
    defparam counter_257_add_4_9.INJECT1_0 = "NO";
    defparam counter_257_add_4_9.INJECT1_1 = "NO";
    CCU2C counter_257_add_4_1 (.A0(GND_net), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(counter[0]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .COUT(n2360), .S1(n109[0]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257_add_4_1.INIT0 = 16'h0000;
    defparam counter_257_add_4_1.INIT1 = 16'h555f;
    defparam counter_257_add_4_1.INJECT1_0 = "NO";
    defparam counter_257_add_4_1.INJECT1_1 = "NO";
    CCU2C counter_257_add_4_5 (.A0(counter[3]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[4]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n2361), .COUT(n2362), .S0(n109[3]), .S1(n109[4]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_257_add_4_5.INIT0 = 16'haaa0;
    defparam counter_257_add_4_5.INIT1 = 16'haaa0;
    defparam counter_257_add_4_5.INJECT1_0 = "NO";
    defparam counter_257_add_4_5.INJECT1_1 = "NO";
    
endmodule
//
// Verilog Description of module internal_pll
//

module internal_pll (dpll_clkout2_c, stm_fpga_spare5_N_9, internal_160MHz, 
            internal_80MHz, pll_lock, GND_net) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;
    input dpll_clkout2_c;
    input stm_fpga_spare5_N_9;
    output internal_160MHz;
    output internal_80MHz;
    output pll_lock;
    input GND_net;
    
    wire dpll_clkout2_c /* synthesis is_clock=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(5[13:25])
    wire CLKOP /* synthesis is_clock=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/internal_pll/internal_pll.v(11[17:22])
    wire internal_160MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_160MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(63[6:21])
    wire internal_80MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_80MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(64[6:20])
    wire GND_net /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(13[23:34])
    
    EHXPLLL PLLInst_0 (.CLKI(dpll_clkout2_c), .CLKFB(CLKOP), .PHASESEL0(GND_net), 
            .PHASESEL1(GND_net), .PHASEDIR(GND_net), .PHASESTEP(GND_net), 
            .PHASELOADREG(GND_net), .STDBY(GND_net), .PLLWAKESYNC(GND_net), 
            .RST(stm_fpga_spare5_N_9), .ENCLKOP(GND_net), .ENCLKOS(GND_net), 
            .ENCLKOS2(GND_net), .ENCLKOS3(GND_net), .CLKOP(CLKOP), .CLKOS(internal_160MHz), 
            .CLKOS2(internal_80MHz), .LOCK(pll_lock)) /* synthesis FREQUENCY_PIN_CLKOS3="64.000000", FREQUENCY_PIN_CLKOS2="80.000000", FREQUENCY_PIN_CLKOS="160.000000", FREQUENCY_PIN_CLKOP="64.000000", FREQUENCY_PIN_CLKI="8.000000", ICP_CURRENT="5", LPF_RESISTOR="16", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=14, LSE_RCOL=2, LSE_LLINE=68, LSE_RLINE=76 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(68[14] 76[2])
    defparam PLLInst_0.CLKI_DIV = 1;
    defparam PLLInst_0.CLKFB_DIV = 8;
    defparam PLLInst_0.CLKOP_DIV = 10;
    defparam PLLInst_0.CLKOS_DIV = 4;
    defparam PLLInst_0.CLKOS2_DIV = 8;
    defparam PLLInst_0.CLKOS3_DIV = 10;
    defparam PLLInst_0.CLKOP_ENABLE = "ENABLED";
    defparam PLLInst_0.CLKOS_ENABLE = "ENABLED";
    defparam PLLInst_0.CLKOS2_ENABLE = "ENABLED";
    defparam PLLInst_0.CLKOS3_ENABLE = "ENABLED";
    defparam PLLInst_0.CLKOP_CPHASE = 9;
    defparam PLLInst_0.CLKOS_CPHASE = 3;
    defparam PLLInst_0.CLKOS2_CPHASE = 7;
    defparam PLLInst_0.CLKOS3_CPHASE = 12;
    defparam PLLInst_0.CLKOP_FPHASE = 0;
    defparam PLLInst_0.CLKOS_FPHASE = 0;
    defparam PLLInst_0.CLKOS2_FPHASE = 0;
    defparam PLLInst_0.CLKOS3_FPHASE = 3;
    defparam PLLInst_0.FEEDBK_PATH = "CLKOP";
    defparam PLLInst_0.CLKOP_TRIM_POL = "FALLING";
    defparam PLLInst_0.CLKOP_TRIM_DELAY = 0;
    defparam PLLInst_0.CLKOS_TRIM_POL = "FALLING";
    defparam PLLInst_0.CLKOS_TRIM_DELAY = 0;
    defparam PLLInst_0.OUTDIVIDER_MUXA = "DIVA";
    defparam PLLInst_0.OUTDIVIDER_MUXB = "DIVB";
    defparam PLLInst_0.OUTDIVIDER_MUXC = "DIVC";
    defparam PLLInst_0.OUTDIVIDER_MUXD = "DIVD";
    defparam PLLInst_0.PLL_LOCK_MODE = 0;
    defparam PLLInst_0.PLL_LOCK_DELAY = 200;
    defparam PLLInst_0.STDBY_ENABLE = "DISABLED";
    defparam PLLInst_0.REFIN_RESET = "DISABLED";
    defparam PLLInst_0.SYNC_ENABLE = "DISABLED";
    defparam PLLInst_0.INT_LOCK_STICKY = "ENABLED";
    defparam PLLInst_0.DPHASE_SOURCE = "DISABLED";
    defparam PLLInst_0.PLLRST_ENA = "ENABLED";
    defparam PLLInst_0.INTFB_WAKE = "DISABLED";
    
endmodule
//
// Verilog Description of module spi_generator
//

module spi_generator (spi4_sck_c, n3029, spi_busy, n2935, spi4_mosi_c, 
            internal_160MHz, internal_160MHz_enable_81, \shift_reg_15__N_168[0] , 
            n1230, \shift_reg[1] , \shift_reg_15__N_168[1] , \shift_reg[2] , 
            \shift_reg_15__N_168[2] , \shift_reg[3] , \shift_reg_15__N_168[3] , 
            \shift_reg[4] , \shift_reg_15__N_168[4] , \shift_reg[5] , 
            \shift_reg_15__N_168[5] , \shift_reg[6] , \shift_reg_15__N_168[6] , 
            \shift_reg[7] , \shift_reg_15__N_168[7] , \shift_reg[8] , 
            \shift_reg_15__N_168[8] , \shift_reg[9] , \shift_reg_15__N_168[9] , 
            \shift_reg[10] , \shift_reg_15__N_168[10] , \shift_reg[11] , 
            \shift_reg_15__N_168[11] , \shift_reg[12] , \shift_reg_15__N_168[12] , 
            \shift_reg[13] , \shift_reg_15__N_168[13] , \shift_reg[14] , 
            \shift_reg_15__N_168[14] , \shift_reg[15] , \w_rx_24_fifo_data[13] , 
            n2689) /* synthesis syn_module_defined=1 */ ;
    output spi4_sck_c;
    output n3029;
    output spi_busy;
    input n2935;
    output spi4_mosi_c;
    input internal_160MHz;
    input internal_160MHz_enable_81;
    input \shift_reg_15__N_168[0] ;
    input n1230;
    output \shift_reg[1] ;
    input \shift_reg_15__N_168[1] ;
    output \shift_reg[2] ;
    input \shift_reg_15__N_168[2] ;
    output \shift_reg[3] ;
    input \shift_reg_15__N_168[3] ;
    output \shift_reg[4] ;
    input \shift_reg_15__N_168[4] ;
    output \shift_reg[5] ;
    input \shift_reg_15__N_168[5] ;
    output \shift_reg[6] ;
    input \shift_reg_15__N_168[6] ;
    output \shift_reg[7] ;
    input \shift_reg_15__N_168[7] ;
    output \shift_reg[8] ;
    input \shift_reg_15__N_168[8] ;
    output \shift_reg[9] ;
    input \shift_reg_15__N_168[9] ;
    output \shift_reg[10] ;
    input \shift_reg_15__N_168[10] ;
    output \shift_reg[11] ;
    input \shift_reg_15__N_168[11] ;
    output \shift_reg[12] ;
    input \shift_reg_15__N_168[12] ;
    output \shift_reg[13] ;
    input \shift_reg_15__N_168[13] ;
    output \shift_reg[14] ;
    input \shift_reg_15__N_168[14] ;
    output \shift_reg[15] ;
    input \w_rx_24_fifo_data[13] ;
    output n2689;
    
    wire internal_160MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_160MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(63[6:21])
    wire [4:0]bit_count;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(177[32:41])
    
    wire n1334, spi_clk_enable, internal_160MHz_enable_79, n2941;
    wire [4:0]bit_count_4__N_184;
    wire [15:0]shift_reg;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(176[26:35])
    wire [4:0]bit_count_4__N_218;
    
    wire n1905, n1927, spi_clk_N_224, n1336, n1330, n2645, n8;
    
    LUT4 i1_2_lut (.A(bit_count[1]), .B(bit_count[0]), .Z(n1334)) /* synthesis lut_function=(A (B)+!A !(B)) */ ;
    defparam i1_2_lut.init = 16'h9999;
    LUT4 spi_clk_I_0_49_2_lut_rep_64 (.A(spi4_sck_c), .B(spi_clk_enable), 
         .Z(n3029)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(214[26:51])
    defparam spi_clk_I_0_49_2_lut_rep_64.init = 16'h8888;
    LUT4 spi_busy_I_3_2_lut_rep_42_3_lut (.A(spi4_sck_c), .B(spi_clk_enable), 
         .C(spi_busy), .Z(internal_160MHz_enable_79)) /* synthesis lut_function=(A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(214[26:51])
    defparam spi_busy_I_3_2_lut_rep_42_3_lut.init = 16'h8080;
    LUT4 i1732_4_lut (.A(bit_count[4]), .B(n2935), .C(bit_count[3]), .D(n2941), 
         .Z(bit_count_4__N_184[4])) /* synthesis lut_function=(A (B+(C+(D)))+!A (B+!(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(214[22] 225[16])
    defparam i1732_4_lut.init = 16'heeed;
    FD1P3AX spi_mosi_38 (.D(shift_reg[0]), .SP(internal_160MHz_enable_79), 
            .CK(internal_160MHz), .Q(spi4_mosi_c)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam spi_mosi_38.GSR = "ENABLED";
    FD1P3AX shift_reg_i0 (.D(\shift_reg_15__N_168[0] ), .SP(internal_160MHz_enable_81), 
            .CK(internal_160MHz), .Q(shift_reg[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i0.GSR = "ENABLED";
    FD1S3IX bit_count_i0 (.D(bit_count_4__N_218[0]), .CK(internal_160MHz), 
            .CD(n2935), .Q(bit_count[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i0.GSR = "ENABLED";
    FD1S3AX spi_clk_enable_41 (.D(n1905), .CK(internal_160MHz), .Q(spi_clk_enable)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam spi_clk_enable_41.GSR = "ENABLED";
    FD1S3AX spi_busy_42 (.D(n1230), .CK(internal_160MHz), .Q(spi_busy)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam spi_busy_42.GSR = "ENABLED";
    FD1S3IX spi_clk_36 (.D(spi_clk_N_224), .CK(internal_160MHz), .CD(n1927), 
            .Q(spi4_sck_c)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(186[18] 196[12])
    defparam spi_clk_36.GSR = "ENABLED";
    LUT4 i1_2_lut_3_lut (.A(bit_count[1]), .B(bit_count[0]), .C(bit_count[2]), 
         .Z(n1336)) /* synthesis lut_function=(A (C)+!A (B (C)+!B !(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(218[30:43])
    defparam i1_2_lut_3_lut.init = 16'he1e1;
    LUT4 i383_2_lut_rep_47_3_lut (.A(bit_count[1]), .B(bit_count[0]), .C(bit_count[2]), 
         .Z(n2941)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(218[30:43])
    defparam i383_2_lut_rep_47_3_lut.init = 16'hfefe;
    LUT4 i1_2_lut_3_lut_4_lut (.A(bit_count[1]), .B(bit_count[0]), .C(bit_count[3]), 
         .D(bit_count[2]), .Z(n1330)) /* synthesis lut_function=(A (C)+!A (B (C)+!B (C (D)+!C !(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(218[30:43])
    defparam i1_2_lut_3_lut_4_lut.init = 16'hf0e1;
    LUT4 i1384_4_lut (.A(n2645), .B(n2935), .C(spi_clk_enable), .D(internal_160MHz_enable_79), 
         .Z(n1905)) /* synthesis lut_function=(A (B+!((D)+!C))+!A (B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam i1384_4_lut.init = 16'hdcfc;
    LUT4 i1_3_lut (.A(n8), .B(bit_count[3]), .C(bit_count[0]), .Z(n2645)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;
    defparam i1_3_lut.init = 16'h1010;
    LUT4 i1_3_lut_adj_16 (.A(bit_count[1]), .B(bit_count[2]), .C(bit_count[4]), 
         .Z(n8)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(220[21:35])
    defparam i1_3_lut_adj_16.init = 16'hfefe;
    FD1P3AX shift_reg_i1 (.D(\shift_reg_15__N_168[1] ), .SP(internal_160MHz_enable_81), 
            .CK(internal_160MHz), .Q(\shift_reg[1] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i1.GSR = "ENABLED";
    FD1P3AX shift_reg_i2 (.D(\shift_reg_15__N_168[2] ), .SP(internal_160MHz_enable_81), 
            .CK(internal_160MHz), .Q(\shift_reg[2] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i2.GSR = "ENABLED";
    FD1P3AX shift_reg_i3 (.D(\shift_reg_15__N_168[3] ), .SP(internal_160MHz_enable_81), 
            .CK(internal_160MHz), .Q(\shift_reg[3] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i3.GSR = "ENABLED";
    FD1P3AX shift_reg_i4 (.D(\shift_reg_15__N_168[4] ), .SP(internal_160MHz_enable_81), 
            .CK(internal_160MHz), .Q(\shift_reg[4] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i4.GSR = "ENABLED";
    FD1P3AX shift_reg_i5 (.D(\shift_reg_15__N_168[5] ), .SP(internal_160MHz_enable_81), 
            .CK(internal_160MHz), .Q(\shift_reg[5] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i5.GSR = "ENABLED";
    FD1P3AX shift_reg_i6 (.D(\shift_reg_15__N_168[6] ), .SP(internal_160MHz_enable_81), 
            .CK(internal_160MHz), .Q(\shift_reg[6] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i6.GSR = "ENABLED";
    FD1P3AX shift_reg_i7 (.D(\shift_reg_15__N_168[7] ), .SP(internal_160MHz_enable_81), 
            .CK(internal_160MHz), .Q(\shift_reg[7] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i7.GSR = "ENABLED";
    FD1P3AX shift_reg_i8 (.D(\shift_reg_15__N_168[8] ), .SP(internal_160MHz_enable_81), 
            .CK(internal_160MHz), .Q(\shift_reg[8] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i8.GSR = "ENABLED";
    FD1P3AX shift_reg_i9 (.D(\shift_reg_15__N_168[9] ), .SP(internal_160MHz_enable_81), 
            .CK(internal_160MHz), .Q(\shift_reg[9] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i9.GSR = "ENABLED";
    FD1P3AX shift_reg_i10 (.D(\shift_reg_15__N_168[10] ), .SP(internal_160MHz_enable_81), 
            .CK(internal_160MHz), .Q(\shift_reg[10] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i10.GSR = "ENABLED";
    FD1P3AX shift_reg_i11 (.D(\shift_reg_15__N_168[11] ), .SP(internal_160MHz_enable_81), 
            .CK(internal_160MHz), .Q(\shift_reg[11] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i11.GSR = "ENABLED";
    FD1P3AX shift_reg_i12 (.D(\shift_reg_15__N_168[12] ), .SP(internal_160MHz_enable_81), 
            .CK(internal_160MHz), .Q(\shift_reg[12] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i12.GSR = "ENABLED";
    FD1P3AX shift_reg_i13 (.D(\shift_reg_15__N_168[13] ), .SP(internal_160MHz_enable_81), 
            .CK(internal_160MHz), .Q(\shift_reg[13] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i13.GSR = "ENABLED";
    FD1P3AX shift_reg_i14 (.D(\shift_reg_15__N_168[14] ), .SP(internal_160MHz_enable_81), 
            .CK(internal_160MHz), .Q(\shift_reg[14] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i14.GSR = "ENABLED";
    FD1P3IX bit_count_i1 (.D(n1334), .SP(internal_160MHz_enable_79), .CD(n2935), 
            .CK(internal_160MHz), .Q(bit_count[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i1.GSR = "ENABLED";
    FD1P3IX bit_count_i2 (.D(n1336), .SP(internal_160MHz_enable_79), .CD(n2935), 
            .CK(internal_160MHz), .Q(bit_count[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i2.GSR = "ENABLED";
    FD1P3IX bit_count_i3 (.D(n1330), .SP(internal_160MHz_enable_79), .CD(n2935), 
            .CK(internal_160MHz), .Q(bit_count[3])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i3.GSR = "ENABLED";
    FD1P3AX bit_count_i4 (.D(bit_count_4__N_184[4]), .SP(internal_160MHz_enable_81), 
            .CK(internal_160MHz), .Q(bit_count[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i4.GSR = "ENABLED";
    LUT4 i633_1_lut (.A(spi4_sck_c), .Z(spi_clk_N_224)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(189[13] 192[16])
    defparam i633_1_lut.init = 16'h5555;
    FD1P3IX shift_reg_i15 (.D(\w_rx_24_fifo_data[13] ), .SP(internal_160MHz_enable_81), 
            .CD(internal_160MHz_enable_79), .CK(internal_160MHz), .Q(\shift_reg[15] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=541, LSE_RLINE=549 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i15.GSR = "ENABLED";
    LUT4 i1404_1_lut (.A(spi_clk_enable), .Z(n1927)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam i1404_1_lut.init = 16'h5555;
    LUT4 i1_3_lut_adj_17 (.A(bit_count[0]), .B(n8), .C(bit_count[3]), 
         .Z(n2689)) /* synthesis lut_function=((B+(C))+!A) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(220[21:35])
    defparam i1_3_lut_adj_17.init = 16'hfdfd;
    LUT4 i707_2_lut_3_lut_4_lut (.A(spi4_sck_c), .B(spi_clk_enable), .C(bit_count[0]), 
         .D(spi_busy), .Z(bit_count_4__N_218[0])) /* synthesis lut_function=(!(A (B (C (D)+!C !(D))+!B !(C))+!A !(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(214[26:51])
    defparam i707_2_lut_3_lut_4_lut.init = 16'h78f0;
    
endmodule
//
// Verilog Description of module ddr_data_recovery_U3
//

module ddr_data_recovery_U3 (internal_200MHz, sdr_rx_subg_c, data_out, 
            internal_80MHz, sdr_rxclk_c, subg_ddr_data_valid, data_rising, 
            data_falling, n805, n2955, main_reset_n_N_4, GND_net, 
            rRst, VCC_net) /* synthesis syn_module_defined=1 */ ;
    input internal_200MHz;
    input sdr_rx_subg_c;
    output [1:0]data_out;
    input internal_80MHz;
    input sdr_rxclk_c;
    output subg_ddr_data_valid;
    output data_rising;
    output data_falling;
    output n805;
    input n2955;
    input main_reset_n_N_4;
    input GND_net;
    output rRst;
    input VCC_net;
    
    wire internal_200MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_200MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(79[6:21])
    wire sdr_rx_subg_c /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(9[13:24])
    wire internal_80MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_80MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(64[6:20])
    wire sdr_rxclk_c /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(10[13:22])
    wire main_reset_n_N_4 /* synthesis DSPPORT_20=RST3, RESET_NET_FOR_BUS20=20 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(191[6:21])
    wire GND_net /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(13[23:34])
    wire VCC_net /* synthesis CE_NET_FOR_BUS20=20, DSPPORT_20=CE3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(125[10:19])
    wire [1:0]fifo_data;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(18[15:24])
    
    wire internal_200MHz_enable_3, fifo_empty_N_71;
    wire [1:0]fifo_out;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(20[16:24])
    
    wire sdr_rxclk_last, fifo_wr_en, fifo_full_N_81, data_rising_capture, 
        fifo_full, fifo_empty;
    
    FD1P3AX fifo_data_i0_i0 (.D(sdr_rx_subg_c), .SP(internal_200MHz_enable_3), 
            .CK(internal_200MHz), .Q(fifo_data[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=204, LSE_RLINE=212 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(56[18] 72[12])
    defparam fifo_data_i0_i0.GSR = "DISABLED";
    FD1P3AX data_out_i0_i0 (.D(fifo_out[0]), .SP(fifo_empty_N_71), .CK(internal_80MHz), 
            .Q(data_out[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=204, LSE_RLINE=212 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(81[18] 88[12])
    defparam data_out_i0_i0.GSR = "ENABLED";
    FD1S3AX sdr_rxclk_last_29 (.D(sdr_rxclk_c), .CK(internal_200MHz), .Q(sdr_rxclk_last)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=194, LSE_RLINE=202 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(43[18] 47[12])
    defparam sdr_rxclk_last_29.GSR = "ENABLED";
    FD1S3AX data_valid_37 (.D(fifo_empty_N_71), .CK(internal_80MHz), .Q(subg_ddr_data_valid)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=204, LSE_RLINE=212 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(81[18] 88[12])
    defparam data_valid_37.GSR = "ENABLED";
    FD1S3IX data_rising_30 (.D(sdr_rxclk_c), .CK(internal_200MHz), .CD(sdr_rxclk_last), 
            .Q(data_rising)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=194, LSE_RLINE=202 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(43[18] 47[12])
    defparam data_rising_30.GSR = "ENABLED";
    FD1S3IX data_falling_31 (.D(sdr_rxclk_last), .CK(internal_200MHz), .CD(sdr_rxclk_c), 
            .Q(data_falling)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=194, LSE_RLINE=202 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(43[18] 47[12])
    defparam data_falling_31.GSR = "ENABLED";
    FD1S3IX fifo_wr_en_34 (.D(fifo_full_N_81), .CK(internal_200MHz), .CD(n805), 
            .Q(fifo_wr_en)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=204, LSE_RLINE=212 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(56[18] 72[12])
    defparam fifo_wr_en_34.GSR = "ENABLED";
    FD1P3AX data_rising_capture_32 (.D(sdr_rx_subg_c), .SP(data_rising), 
            .CK(internal_200MHz), .Q(data_rising_capture)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=204, LSE_RLINE=212 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(56[18] 72[12])
    defparam data_rising_capture_32.GSR = "ENABLED";
    LUT4 i319_1_lut (.A(data_falling), .Z(n805)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(43[18] 47[12])
    defparam i319_1_lut.init = 16'h5555;
    LUT4 fifo_full_I_0_1_lut (.A(fifo_full), .Z(fifo_full_N_81)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(67[21:31])
    defparam fifo_full_I_0_1_lut.init = 16'h5555;
    FD1P3AX data_out_i0_i1 (.D(fifo_out[1]), .SP(fifo_empty_N_71), .CK(internal_80MHz), 
            .Q(data_out[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=204, LSE_RLINE=212 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(81[18] 88[12])
    defparam data_out_i0_i1.GSR = "ENABLED";
    FD1P3AX fifo_data_i0_i1 (.D(data_rising_capture), .SP(internal_200MHz_enable_3), 
            .CK(internal_200MHz), .Q(fifo_data[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=204, LSE_RLINE=212 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(56[18] 72[12])
    defparam fifo_data_i0_i1.GSR = "DISABLED";
    LUT4 i1_2_lut_3_lut (.A(n2955), .B(data_falling), .C(fifo_full), .Z(internal_200MHz_enable_3)) /* synthesis lut_function=(!(((C)+!B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(56[18] 72[12])
    defparam i1_2_lut_3_lut.init = 16'h0808;
    LUT4 fifo_empty_I_0_1_lut (.A(fifo_empty), .Z(fifo_empty_N_71)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(85[17:28])
    defparam fifo_empty_I_0_1_lut.init = 16'h5555;
    fifo_dc_2in_2out_U0 fifo_inst (.main_reset_n_N_4(main_reset_n_N_4), .GND_net(GND_net), 
            .rRst(rRst), .internal_200MHz(internal_200MHz), .internal_80MHz(internal_80MHz), 
            .fifo_full(fifo_full), .fifo_empty(fifo_empty), .VCC_net(VCC_net), 
            .fifo_wr_en(fifo_wr_en), .subg_ddr_data_valid(subg_ddr_data_valid), 
            .fifo_data({fifo_data}), .fifo_out({fifo_out})) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    
endmodule
//
// Verilog Description of module fifo_dc_2in_2out_U0
//

module fifo_dc_2in_2out_U0 (main_reset_n_N_4, GND_net, rRst, internal_200MHz, 
            internal_80MHz, fifo_full, fifo_empty, VCC_net, fifo_wr_en, 
            subg_ddr_data_valid, fifo_data, fifo_out) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;
    input main_reset_n_N_4;
    input GND_net;
    output rRst;
    input internal_200MHz;
    input internal_80MHz;
    output fifo_full;
    output fifo_empty;
    input VCC_net;
    input fifo_wr_en;
    input subg_ddr_data_valid;
    input [1:0]fifo_data;
    output [1:0]fifo_out;
    
    wire main_reset_n_N_4 /* synthesis DSPPORT_20=RST3, RESET_NET_FOR_BUS20=20 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(191[6:21])
    wire GND_net /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(13[23:34])
    wire internal_200MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_200MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(79[6:21])
    wire internal_80MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_80MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(64[6:20])
    wire VCC_net /* synthesis CE_NET_FOR_BUS20=20, DSPPORT_20=CE3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(125[10:19])
    
    wire wcount_1, wren_i, iwcount_1, wcount_2, iwcount_2, wcount_3, 
        iwcount_3, wcount_4, iwcount_4, w_gcount_0, w_gdata_0, w_gcount_1, 
        w_gdata_1, w_gcount_2, w_gdata_2, w_gcount_3, w_gdata_3, w_gcount_4, 
        wptr_0, wcount_0, wptr_1, wptr_2, wptr_3, wptr_4, w_gcount_r0, 
        ircount_0, rden_i, rcount_0, ircount_1, rcount_1, ircount_2, 
        rcount_2, ircount_3, rcount_3, ircount_4, rcount_4, r_gdata_0, 
        r_gcount_0, r_gdata_1, r_gcount_1, r_gdata_2, r_gcount_2, 
        r_gdata_3, r_gcount_3, r_gcount_4, rptr_0, rptr_1, rptr_2, 
        rptr_3, rptr_4, w_gcount_r1, w_gcount_r2, w_gcount_r3, w_gcount_r4, 
        w_gcount_r20, r_gcount_w0, r_gcount_w1, r_gcount_w2, r_gcount_w3, 
        r_gcount_w4, w_gcount_r21, w_gcount_r22, w_gcount_r23, w_gcount_r24, 
        full_d, r_gcount_w20, r_gcount_w21, r_gcount_w22, r_gcount_w23, 
        r_gcount_w24, empty_d, iwcount_0, w_gctr_ci, co0, co1, r_gctr_ci, 
        co0_1, co1_1, cmp_ci, wcount_r0, w_g2b_xor_cluster_0, co0_2, 
        wcount_r2, wcount_r3, co1_2, empty_cmp_clr, empty_cmp_set, 
        empty_d_c, cmp_ci_1, rcount_w0, r_g2b_xor_cluster_0, co0_3, 
        rcount_w2, rcount_w3, co1_3, full_cmp_clr, full_cmp_set, full_d_c, 
        invout_1, invout_0;
    
    OR2 OR2_t8 (.A(main_reset_n_N_4), .B(GND_net), .Z(rRst)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(137[9:50])
    FD1P3AX FF_50 (.D(iwcount_1), .SP(wren_i), .CK(internal_200MHz), .Q(wcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(247[13] 248[22])
    defparam FF_50.GSR = "ENABLED";
    FD1P3AX FF_49 (.D(iwcount_2), .SP(wren_i), .CK(internal_200MHz), .Q(wcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(251[13] 252[22])
    defparam FF_49.GSR = "ENABLED";
    FD1P3AX FF_48 (.D(iwcount_3), .SP(wren_i), .CK(internal_200MHz), .Q(wcount_3)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(255[13] 256[22])
    defparam FF_48.GSR = "ENABLED";
    FD1P3AX FF_47 (.D(iwcount_4), .SP(wren_i), .CK(internal_200MHz), .Q(wcount_4)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(259[13] 260[22])
    defparam FF_47.GSR = "ENABLED";
    FD1P3AX FF_46 (.D(w_gdata_0), .SP(wren_i), .CK(internal_200MHz), .Q(w_gcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(263[13] 264[24])
    defparam FF_46.GSR = "ENABLED";
    FD1P3AX FF_45 (.D(w_gdata_1), .SP(wren_i), .CK(internal_200MHz), .Q(w_gcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(267[13] 268[24])
    defparam FF_45.GSR = "ENABLED";
    FD1P3AX FF_44 (.D(w_gdata_2), .SP(wren_i), .CK(internal_200MHz), .Q(w_gcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(271[13] 272[24])
    defparam FF_44.GSR = "ENABLED";
    FD1P3AX FF_43 (.D(w_gdata_3), .SP(wren_i), .CK(internal_200MHz), .Q(w_gcount_3)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(275[13] 276[24])
    defparam FF_43.GSR = "ENABLED";
    FD1P3AX FF_42 (.D(wcount_4), .SP(wren_i), .CK(internal_200MHz), .Q(w_gcount_4)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(279[13] 280[24])
    defparam FF_42.GSR = "ENABLED";
    FD1P3AX FF_41 (.D(wcount_0), .SP(wren_i), .CK(internal_200MHz), .Q(wptr_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(283[13] 284[20])
    defparam FF_41.GSR = "ENABLED";
    FD1P3AX FF_40 (.D(wcount_1), .SP(wren_i), .CK(internal_200MHz), .Q(wptr_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(287[13] 288[20])
    defparam FF_40.GSR = "ENABLED";
    FD1P3AX FF_39 (.D(wcount_2), .SP(wren_i), .CK(internal_200MHz), .Q(wptr_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(291[13] 292[20])
    defparam FF_39.GSR = "ENABLED";
    FD1P3AX FF_38 (.D(wcount_3), .SP(wren_i), .CK(internal_200MHz), .Q(wptr_3)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(295[13] 296[20])
    defparam FF_38.GSR = "ENABLED";
    FD1P3AX FF_37 (.D(wcount_4), .SP(wren_i), .CK(internal_200MHz), .Q(wptr_4)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(299[13] 300[20])
    defparam FF_37.GSR = "ENABLED";
    FD1S3AX FF_21 (.D(w_gcount_0), .CK(internal_80MHz), .Q(w_gcount_r0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(357[13:78])
    defparam FF_21.GSR = "ENABLED";
    FD1P3BX FF_36 (.D(ircount_0), .SP(rden_i), .CK(internal_80MHz), .PD(rRst), 
            .Q(rcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(303[13] 304[22])
    defparam FF_36.GSR = "DISABLED";
    FD1P3DX FF_35 (.D(ircount_1), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(307[13] 308[22])
    defparam FF_35.GSR = "DISABLED";
    FD1P3DX FF_34 (.D(ircount_2), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(311[13] 312[22])
    defparam FF_34.GSR = "DISABLED";
    FD1P3DX FF_33 (.D(ircount_3), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rcount_3)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(315[13] 316[22])
    defparam FF_33.GSR = "DISABLED";
    FD1P3DX FF_32 (.D(ircount_4), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rcount_4)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(319[13] 320[22])
    defparam FF_32.GSR = "DISABLED";
    FD1P3DX FF_31 (.D(r_gdata_0), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(323[13] 324[24])
    defparam FF_31.GSR = "DISABLED";
    FD1P3DX FF_30 (.D(r_gdata_1), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(327[13] 328[24])
    defparam FF_30.GSR = "DISABLED";
    FD1P3DX FF_29 (.D(r_gdata_2), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(331[13] 332[24])
    defparam FF_29.GSR = "DISABLED";
    FD1P3DX FF_28 (.D(r_gdata_3), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_3)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(335[13] 336[24])
    defparam FF_28.GSR = "DISABLED";
    FD1P3DX FF_27 (.D(rcount_4), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_4)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(339[13:87])
    defparam FF_27.GSR = "DISABLED";
    FD1P3DX FF_26 (.D(rcount_0), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(342[13:83])
    defparam FF_26.GSR = "DISABLED";
    FD1P3DX FF_25 (.D(rcount_1), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(345[13:83])
    defparam FF_25.GSR = "DISABLED";
    FD1P3DX FF_24 (.D(rcount_2), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(348[13:83])
    defparam FF_24.GSR = "DISABLED";
    FD1P3DX FF_23 (.D(rcount_3), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_3)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(351[13:83])
    defparam FF_23.GSR = "DISABLED";
    FD1P3DX FF_22 (.D(rcount_4), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_4)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(354[13:83])
    defparam FF_22.GSR = "DISABLED";
    FD1S3AX FF_20 (.D(w_gcount_1), .CK(internal_80MHz), .Q(w_gcount_r1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(360[13:78])
    defparam FF_20.GSR = "ENABLED";
    FD1S3AX FF_19 (.D(w_gcount_2), .CK(internal_80MHz), .Q(w_gcount_r2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(363[13:78])
    defparam FF_19.GSR = "ENABLED";
    FD1S3AX FF_18 (.D(w_gcount_3), .CK(internal_80MHz), .Q(w_gcount_r3)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(366[13:78])
    defparam FF_18.GSR = "ENABLED";
    FD1S3AX FF_17 (.D(w_gcount_4), .CK(internal_80MHz), .Q(w_gcount_r4)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(369[13:78])
    defparam FF_17.GSR = "ENABLED";
    FD1S3AX FF_11 (.D(w_gcount_r0), .CK(internal_80MHz), .Q(w_gcount_r20)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(387[13:80])
    defparam FF_11.GSR = "ENABLED";
    FD1S3DX FF_16 (.D(r_gcount_0), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(372[13:77])
    defparam FF_16.GSR = "DISABLED";
    FD1S3DX FF_15 (.D(r_gcount_1), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(375[13:77])
    defparam FF_15.GSR = "DISABLED";
    FD1S3DX FF_14 (.D(r_gcount_2), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(378[13:77])
    defparam FF_14.GSR = "DISABLED";
    FD1S3DX FF_13 (.D(r_gcount_3), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w3)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(381[13:77])
    defparam FF_13.GSR = "DISABLED";
    FD1S3DX FF_12 (.D(r_gcount_4), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w4)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(384[13:77])
    defparam FF_12.GSR = "DISABLED";
    FD1S3AX FF_10 (.D(w_gcount_r1), .CK(internal_80MHz), .Q(w_gcount_r21)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(390[13:80])
    defparam FF_10.GSR = "ENABLED";
    FD1S3AX FF_9 (.D(w_gcount_r2), .CK(internal_80MHz), .Q(w_gcount_r22)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(393[13:79])
    defparam FF_9.GSR = "ENABLED";
    FD1S3AX FF_8 (.D(w_gcount_r3), .CK(internal_80MHz), .Q(w_gcount_r23)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(396[13:79])
    defparam FF_8.GSR = "ENABLED";
    FD1S3AX FF_7 (.D(w_gcount_r4), .CK(internal_80MHz), .Q(w_gcount_r24)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(399[13:79])
    defparam FF_7.GSR = "ENABLED";
    FD1S3AX FF_0 (.D(full_d), .CK(internal_200MHz), .Q(fifo_full)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(420[13:68])
    defparam FF_0.GSR = "ENABLED";
    FD1S3DX FF_6 (.D(r_gcount_w0), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w20)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(402[13:78])
    defparam FF_6.GSR = "DISABLED";
    FD1S3DX FF_5 (.D(r_gcount_w1), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w21)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(405[13:78])
    defparam FF_5.GSR = "DISABLED";
    FD1S3DX FF_4 (.D(r_gcount_w2), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w22)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(408[13:78])
    defparam FF_4.GSR = "DISABLED";
    FD1S3DX FF_3 (.D(r_gcount_w3), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w23)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(411[13:78])
    defparam FF_3.GSR = "DISABLED";
    FD1S3DX FF_2 (.D(r_gcount_w4), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w24)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(414[13:78])
    defparam FF_2.GSR = "DISABLED";
    FD1S3BX FF_1 (.D(empty_d), .CK(internal_80MHz), .PD(rRst), .Q(fifo_empty)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(417[13:69])
    defparam FF_1.GSR = "DISABLED";
    FD1P3AY FF_51 (.D(iwcount_0), .SP(wren_i), .CK(internal_200MHz), .Q(wcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(243[13] 244[22])
    defparam FF_51.GSR = "ENABLED";
    CCU2C w_gctr_cia (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(VCC_net), .B1(VCC_net), .C1(VCC_net), .D1(VCC_net), .COUT(w_gctr_ci)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(427[11] 429[48])
    defparam w_gctr_cia.INIT0 = 16'b0110011010101010;
    defparam w_gctr_cia.INIT1 = 16'b0110011010101010;
    defparam w_gctr_cia.INJECT1_0 = "NO";
    defparam w_gctr_cia.INJECT1_1 = "NO";
    CCU2C w_gctr_0 (.A0(wcount_0), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(wcount_1), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(w_gctr_ci), 
          .COUT(co0), .S0(iwcount_0), .S1(iwcount_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(435[11] 437[69])
    defparam w_gctr_0.INIT0 = 16'b0110011010101010;
    defparam w_gctr_0.INIT1 = 16'b0110011010101010;
    defparam w_gctr_0.INJECT1_0 = "NO";
    defparam w_gctr_0.INJECT1_1 = "NO";
    CCU2C w_gctr_1 (.A0(wcount_2), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(wcount_3), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(co0), 
          .COUT(co1), .S0(iwcount_2), .S1(iwcount_3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(443[11] 445[63])
    defparam w_gctr_1.INIT0 = 16'b0110011010101010;
    defparam w_gctr_1.INIT1 = 16'b0110011010101010;
    defparam w_gctr_1.INJECT1_0 = "NO";
    defparam w_gctr_1.INJECT1_1 = "NO";
    CCU2C w_gctr_2 (.A0(wcount_4), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(co1), 
          .S0(iwcount_4)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(451[11] 453[54])
    defparam w_gctr_2.INIT0 = 16'b0110011010101010;
    defparam w_gctr_2.INIT1 = 16'b0110011010101010;
    defparam w_gctr_2.INJECT1_0 = "NO";
    defparam w_gctr_2.INJECT1_1 = "NO";
    CCU2C r_gctr_cia (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(VCC_net), .B1(VCC_net), .C1(VCC_net), .D1(VCC_net), .COUT(r_gctr_ci)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(459[11] 461[48])
    defparam r_gctr_cia.INIT0 = 16'b0110011010101010;
    defparam r_gctr_cia.INIT1 = 16'b0110011010101010;
    defparam r_gctr_cia.INJECT1_0 = "NO";
    defparam r_gctr_cia.INJECT1_1 = "NO";
    CCU2C r_gctr_0 (.A0(rcount_0), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(rcount_1), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(r_gctr_ci), 
          .COUT(co0_1), .S0(ircount_0), .S1(ircount_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(467[11] 469[71])
    defparam r_gctr_0.INIT0 = 16'b0110011010101010;
    defparam r_gctr_0.INIT1 = 16'b0110011010101010;
    defparam r_gctr_0.INJECT1_0 = "NO";
    defparam r_gctr_0.INJECT1_1 = "NO";
    CCU2C r_gctr_1 (.A0(rcount_2), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(rcount_3), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(co0_1), 
          .COUT(co1_1), .S0(ircount_2), .S1(ircount_3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(475[11] 477[67])
    defparam r_gctr_1.INIT0 = 16'b0110011010101010;
    defparam r_gctr_1.INIT1 = 16'b0110011010101010;
    defparam r_gctr_1.INJECT1_0 = "NO";
    defparam r_gctr_1.INJECT1_1 = "NO";
    CCU2C r_gctr_2 (.A0(rcount_4), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(co1_1), 
          .S0(ircount_4)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(483[11] 485[58])
    defparam r_gctr_2.INIT0 = 16'b0110011010101010;
    defparam r_gctr_2.INIT1 = 16'b0110011010101010;
    defparam r_gctr_2.INJECT1_0 = "NO";
    defparam r_gctr_2.INJECT1_1 = "NO";
    CCU2C empty_cmp_ci_a (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(rden_i), .B1(rden_i), .C1(VCC_net), .D1(VCC_net), .COUT(cmp_ci)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(491[11] 493[45])
    defparam empty_cmp_ci_a.INIT0 = 16'b0110011010101010;
    defparam empty_cmp_ci_a.INIT1 = 16'b0110011010101010;
    defparam empty_cmp_ci_a.INJECT1_0 = "NO";
    defparam empty_cmp_ci_a.INJECT1_1 = "NO";
    CCU2C empty_cmp_0 (.A0(rcount_0), .B0(wcount_r0), .C0(VCC_net), .D0(VCC_net), 
          .A1(rcount_1), .B1(w_g2b_xor_cluster_0), .C1(VCC_net), .D1(VCC_net), 
          .CIN(cmp_ci), .COUT(co0_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(499[11] 501[50])
    defparam empty_cmp_0.INIT0 = 16'b1001100110101010;
    defparam empty_cmp_0.INIT1 = 16'b1001100110101010;
    defparam empty_cmp_0.INJECT1_0 = "NO";
    defparam empty_cmp_0.INJECT1_1 = "NO";
    CCU2C empty_cmp_1 (.A0(rcount_2), .B0(wcount_r2), .C0(VCC_net), .D0(VCC_net), 
          .A1(rcount_3), .B1(wcount_r3), .C1(VCC_net), .D1(VCC_net), 
          .CIN(co0_2), .COUT(co1_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(507[11] 509[49])
    defparam empty_cmp_1.INIT0 = 16'b1001100110101010;
    defparam empty_cmp_1.INIT1 = 16'b1001100110101010;
    defparam empty_cmp_1.INJECT1_0 = "NO";
    defparam empty_cmp_1.INJECT1_1 = "NO";
    CCU2C empty_cmp_2 (.A0(empty_cmp_set), .B0(empty_cmp_clr), .C0(VCC_net), 
          .D0(VCC_net), .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), 
          .CIN(co1_2), .COUT(empty_d_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(515[11] 517[69])
    defparam empty_cmp_2.INIT0 = 16'b1001100110101010;
    defparam empty_cmp_2.INIT1 = 16'b1001100110101010;
    defparam empty_cmp_2.INJECT1_0 = "NO";
    defparam empty_cmp_2.INJECT1_1 = "NO";
    CCU2C a0 (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(empty_d_c), 
          .S0(empty_d)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(523[11] 525[55])
    defparam a0.INIT0 = 16'b0110011010101010;
    defparam a0.INIT1 = 16'b0110011010101010;
    defparam a0.INJECT1_0 = "NO";
    defparam a0.INJECT1_1 = "NO";
    CCU2C full_cmp_ci_a (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(wren_i), .B1(wren_i), .C1(VCC_net), .D1(VCC_net), .COUT(cmp_ci_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(531[11] 533[47])
    defparam full_cmp_ci_a.INIT0 = 16'b0110011010101010;
    defparam full_cmp_ci_a.INIT1 = 16'b0110011010101010;
    defparam full_cmp_ci_a.INJECT1_0 = "NO";
    defparam full_cmp_ci_a.INJECT1_1 = "NO";
    CCU2C full_cmp_0 (.A0(wcount_0), .B0(rcount_w0), .C0(VCC_net), .D0(VCC_net), 
          .A1(wcount_1), .B1(r_g2b_xor_cluster_0), .C1(VCC_net), .D1(VCC_net), 
          .CIN(cmp_ci_1), .COUT(co0_3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(539[11] 541[52])
    defparam full_cmp_0.INIT0 = 16'b1001100110101010;
    defparam full_cmp_0.INIT1 = 16'b1001100110101010;
    defparam full_cmp_0.INJECT1_0 = "NO";
    defparam full_cmp_0.INJECT1_1 = "NO";
    CCU2C full_cmp_1 (.A0(wcount_2), .B0(rcount_w2), .C0(VCC_net), .D0(VCC_net), 
          .A1(wcount_3), .B1(rcount_w3), .C1(VCC_net), .D1(VCC_net), 
          .CIN(co0_3), .COUT(co1_3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(547[11] 549[49])
    defparam full_cmp_1.INIT0 = 16'b1001100110101010;
    defparam full_cmp_1.INIT1 = 16'b1001100110101010;
    defparam full_cmp_1.INJECT1_0 = "NO";
    defparam full_cmp_1.INJECT1_1 = "NO";
    CCU2C full_cmp_2 (.A0(full_cmp_set), .B0(full_cmp_clr), .C0(VCC_net), 
          .D0(VCC_net), .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), 
          .CIN(co1_3), .COUT(full_d_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(555[11] 557[68])
    defparam full_cmp_2.INIT0 = 16'b1001100110101010;
    defparam full_cmp_2.INIT1 = 16'b1001100110101010;
    defparam full_cmp_2.INJECT1_0 = "NO";
    defparam full_cmp_2.INJECT1_1 = "NO";
    CCU2C a1 (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(full_d_c), 
          .S0(full_d)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(567[11] 569[53])
    defparam a1.INIT0 = 16'b0110011010101010;
    defparam a1.INIT1 = 16'b0110011010101010;
    defparam a1.INJECT1_0 = "NO";
    defparam a1.INJECT1_1 = "NO";
    AND2 AND2_t10 (.A(fifo_wr_en), .B(invout_1), .Z(wren_i)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(129[10:55])
    INV INV_1 (.A(fifo_full), .Z(invout_1)) /* synthesis LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    AND2 AND2_t9 (.A(subg_ddr_data_valid), .B(invout_0), .Z(rden_i)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(133[10:54])
    INV INV_0 (.A(fifo_empty), .Z(invout_0)) /* synthesis LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    XOR2 XOR2_t7 (.A(wcount_0), .B(wcount_1), .Z(w_gdata_0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(139[10:61])
    XOR2 XOR2_t6 (.A(wcount_1), .B(wcount_2), .Z(w_gdata_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(141[10:61])
    XOR2 XOR2_t5 (.A(wcount_2), .B(wcount_3), .Z(w_gdata_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(143[10:61])
    XOR2 XOR2_t4 (.A(wcount_3), .B(wcount_4), .Z(w_gdata_3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(145[10:61])
    XOR2 XOR2_t3 (.A(rcount_0), .B(rcount_1), .Z(r_gdata_0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(147[10:61])
    XOR2 XOR2_t2 (.A(rcount_1), .B(rcount_2), .Z(r_gdata_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(149[10:61])
    XOR2 XOR2_t1 (.A(rcount_2), .B(rcount_3), .Z(r_gdata_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(151[10:61])
    XOR2 XOR2_t0 (.A(rcount_3), .B(rcount_4), .Z(r_gdata_3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(153[10:61])
    ROM16X1A LUT4_11 (.AD0(w_gcount_r24), .AD1(w_gcount_r23), .AD2(w_gcount_r22), 
            .AD3(w_gcount_r21), .DO0(w_g2b_xor_cluster_0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_11.initval = 16'b0110100110010110;
    ROM16X1A LUT4_10 (.AD0(GND_net), .AD1(GND_net), .AD2(w_gcount_r24), 
            .AD3(w_gcount_r23), .DO0(wcount_r3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_10.initval = 16'b0110100110010110;
    ROM16X1A LUT4_9 (.AD0(GND_net), .AD1(w_gcount_r24), .AD2(w_gcount_r23), 
            .AD3(w_gcount_r22), .DO0(wcount_r2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_9.initval = 16'b0110100110010110;
    ROM16X1A LUT4_8 (.AD0(wcount_r3), .AD1(w_gcount_r22), .AD2(w_gcount_r21), 
            .AD3(w_gcount_r20), .DO0(wcount_r0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_8.initval = 16'b0110100110010110;
    ROM16X1A LUT4_7 (.AD0(r_gcount_w24), .AD1(r_gcount_w23), .AD2(r_gcount_w22), 
            .AD3(r_gcount_w21), .DO0(r_g2b_xor_cluster_0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_7.initval = 16'b0110100110010110;
    ROM16X1A LUT4_6 (.AD0(GND_net), .AD1(GND_net), .AD2(r_gcount_w24), 
            .AD3(r_gcount_w23), .DO0(rcount_w3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_6.initval = 16'b0110100110010110;
    ROM16X1A LUT4_5 (.AD0(GND_net), .AD1(r_gcount_w24), .AD2(r_gcount_w23), 
            .AD3(r_gcount_w22), .DO0(rcount_w2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_5.initval = 16'b0110100110010110;
    ROM16X1A LUT4_4 (.AD0(rcount_w3), .AD1(r_gcount_w22), .AD2(r_gcount_w21), 
            .AD3(r_gcount_w20), .DO0(rcount_w0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_4.initval = 16'b0110100110010110;
    ROM16X1A LUT4_3 (.AD0(GND_net), .AD1(w_gcount_r24), .AD2(rcount_4), 
            .AD3(rptr_4), .DO0(empty_cmp_set)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_3.initval = 16'b0000010000010000;
    ROM16X1A LUT4_2 (.AD0(GND_net), .AD1(w_gcount_r24), .AD2(rcount_4), 
            .AD3(rptr_4), .DO0(empty_cmp_clr)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_2.initval = 16'b0001000000000100;
    ROM16X1A LUT4_1 (.AD0(GND_net), .AD1(r_gcount_w24), .AD2(wcount_4), 
            .AD3(wptr_4), .DO0(full_cmp_set)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_1.initval = 16'b0000000101000000;
    ROM16X1A LUT4_0 (.AD0(GND_net), .AD1(r_gcount_w24), .AD2(wcount_4), 
            .AD3(wptr_4), .DO0(full_cmp_clr)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_0.initval = 16'b0100000000000001;
    DP16KD pdp_ram_0_0_0 (.DIA0(fifo_data[0]), .DIA1(fifo_data[1]), .DIA2(GND_net), 
           .DIA3(GND_net), .DIA4(GND_net), .DIA5(GND_net), .DIA6(GND_net), 
           .DIA7(GND_net), .DIA8(GND_net), .DIA9(GND_net), .DIA10(GND_net), 
           .DIA11(GND_net), .DIA12(GND_net), .DIA13(GND_net), .DIA14(GND_net), 
           .DIA15(GND_net), .DIA16(GND_net), .DIA17(GND_net), .ADA0(GND_net), 
           .ADA1(wptr_0), .ADA2(wptr_1), .ADA3(wptr_2), .ADA4(wptr_3), 
           .ADA5(GND_net), .ADA6(GND_net), .ADA7(GND_net), .ADA8(GND_net), 
           .ADA9(GND_net), .ADA10(GND_net), .ADA11(GND_net), .ADA12(GND_net), 
           .ADA13(GND_net), .CEA(wren_i), .OCEA(wren_i), .CLKA(internal_200MHz), 
           .WEA(VCC_net), .CSA0(GND_net), .CSA1(GND_net), .CSA2(GND_net), 
           .RSTA(main_reset_n_N_4), .DIB0(GND_net), .DIB1(GND_net), .DIB2(GND_net), 
           .DIB3(GND_net), .DIB4(GND_net), .DIB5(GND_net), .DIB6(GND_net), 
           .DIB7(GND_net), .DIB8(GND_net), .DIB9(GND_net), .DIB10(GND_net), 
           .DIB11(GND_net), .DIB12(GND_net), .DIB13(GND_net), .DIB14(GND_net), 
           .DIB15(GND_net), .DIB16(GND_net), .DIB17(GND_net), .ADB0(GND_net), 
           .ADB1(rptr_0), .ADB2(rptr_1), .ADB3(rptr_2), .ADB4(rptr_3), 
           .ADB5(GND_net), .ADB6(GND_net), .ADB7(GND_net), .ADB8(GND_net), 
           .ADB9(GND_net), .ADB10(GND_net), .ADB11(GND_net), .ADB12(GND_net), 
           .ADB13(GND_net), .CEB(rden_i), .OCEB(rden_i), .CLKB(internal_80MHz), 
           .WEB(GND_net), .CSB0(GND_net), .CSB1(GND_net), .CSB2(GND_net), 
           .RSTB(main_reset_n_N_4), .DOB0(fifo_out[0]), .DOB1(fifo_out[1])) /* synthesis MEM_LPC_FILE="fifo_dc_2in_2out.lpc", MEM_INIT_FILE="", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam pdp_ram_0_0_0.DATA_WIDTH_A = 2;
    defparam pdp_ram_0_0_0.DATA_WIDTH_B = 2;
    defparam pdp_ram_0_0_0.REGMODE_A = "NOREG";
    defparam pdp_ram_0_0_0.REGMODE_B = "NOREG";
    defparam pdp_ram_0_0_0.RESETMODE = "ASYNC";
    defparam pdp_ram_0_0_0.ASYNC_RESET_RELEASE = "SYNC";
    defparam pdp_ram_0_0_0.WRITEMODE_A = "NORMAL";
    defparam pdp_ram_0_0_0.WRITEMODE_B = "NORMAL";
    defparam pdp_ram_0_0_0.CSDECODE_A = "0b000";
    defparam pdp_ram_0_0_0.CSDECODE_B = "0b000";
    defparam pdp_ram_0_0_0.GSR = "ENABLED";
    defparam pdp_ram_0_0_0.INITVAL_00 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_01 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_02 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_03 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_04 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_05 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_06 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_07 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_08 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_09 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_0A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_0B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_0C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_0D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_0E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_0F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_10 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_11 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_12 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_13 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_14 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_15 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_16 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_17 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_18 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_19 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_1A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_1B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_1C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_1D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_1E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_1F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_20 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_21 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_22 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_23 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_24 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_25 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_26 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_27 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_28 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_29 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_2A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_2B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_2C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_2D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_2E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_2F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_30 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_31 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_32 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_33 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_34 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_35 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_36 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_37 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_38 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_39 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_3A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_3B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_3C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_3D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_3E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_3F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INIT_DATA = "STATIC";
    
endmodule
//
// Verilog Description of module pll_10MHzInput
//

module pll_10MHzInput (dpll_clkout0_c, stm_fpga_spare5_N_9, internal_200MHz, 
            second_pll_lock, GND_net) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;
    input dpll_clkout0_c;
    input stm_fpga_spare5_N_9;
    output internal_200MHz;
    output second_pll_lock;
    input GND_net;
    
    wire dpll_clkout0_c /* synthesis is_clock=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(6[13:25])
    wire internal_200MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_200MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(79[6:21])
    wire GND_net /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(13[23:34])
    
    EHXPLLL PLLInst_0 (.CLKI(dpll_clkout0_c), .CLKFB(internal_200MHz), .PHASESEL0(GND_net), 
            .PHASESEL1(GND_net), .PHASEDIR(GND_net), .PHASESTEP(GND_net), 
            .PHASELOADREG(GND_net), .STDBY(GND_net), .PLLWAKESYNC(GND_net), 
            .RST(stm_fpga_spare5_N_9), .ENCLKOP(GND_net), .ENCLKOS(GND_net), 
            .ENCLKOS2(GND_net), .ENCLKOS3(GND_net), .CLKOP(internal_200MHz), 
            .LOCK(second_pll_lock)) /* synthesis FREQUENCY_PIN_CLKOP="200.000000", FREQUENCY_PIN_CLKI="10.000000", ICP_CURRENT="5", LPF_RESISTOR="16", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=16, LSE_RCOL=2, LSE_LLINE=81, LSE_RLINE=86 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(81[16] 86[2])
    defparam PLLInst_0.CLKI_DIV = 1;
    defparam PLLInst_0.CLKFB_DIV = 20;
    defparam PLLInst_0.CLKOP_DIV = 3;
    defparam PLLInst_0.CLKOS_DIV = 1;
    defparam PLLInst_0.CLKOS2_DIV = 1;
    defparam PLLInst_0.CLKOS3_DIV = 1;
    defparam PLLInst_0.CLKOP_ENABLE = "ENABLED";
    defparam PLLInst_0.CLKOS_ENABLE = "DISABLED";
    defparam PLLInst_0.CLKOS2_ENABLE = "DISABLED";
    defparam PLLInst_0.CLKOS3_ENABLE = "DISABLED";
    defparam PLLInst_0.CLKOP_CPHASE = 2;
    defparam PLLInst_0.CLKOS_CPHASE = 0;
    defparam PLLInst_0.CLKOS2_CPHASE = 0;
    defparam PLLInst_0.CLKOS3_CPHASE = 0;
    defparam PLLInst_0.CLKOP_FPHASE = 0;
    defparam PLLInst_0.CLKOS_FPHASE = 0;
    defparam PLLInst_0.CLKOS2_FPHASE = 0;
    defparam PLLInst_0.CLKOS3_FPHASE = 0;
    defparam PLLInst_0.FEEDBK_PATH = "CLKOP";
    defparam PLLInst_0.CLKOP_TRIM_POL = "FALLING";
    defparam PLLInst_0.CLKOP_TRIM_DELAY = 0;
    defparam PLLInst_0.CLKOS_TRIM_POL = "FALLING";
    defparam PLLInst_0.CLKOS_TRIM_DELAY = 0;
    defparam PLLInst_0.OUTDIVIDER_MUXA = "DIVA";
    defparam PLLInst_0.OUTDIVIDER_MUXB = "DIVB";
    defparam PLLInst_0.OUTDIVIDER_MUXC = "DIVC";
    defparam PLLInst_0.OUTDIVIDER_MUXD = "DIVD";
    defparam PLLInst_0.PLL_LOCK_MODE = 0;
    defparam PLLInst_0.PLL_LOCK_DELAY = 200;
    defparam PLLInst_0.STDBY_ENABLE = "DISABLED";
    defparam PLLInst_0.REFIN_RESET = "DISABLED";
    defparam PLLInst_0.SYNC_ENABLE = "DISABLED";
    defparam PLLInst_0.INT_LOCK_STICKY = "ENABLED";
    defparam PLLInst_0.DPHASE_SOURCE = "DISABLED";
    defparam PLLInst_0.PLLRST_ENA = "ENABLED";
    defparam PLLInst_0.INTFB_WAKE = "DISABLED";
    
endmodule
//
// Verilog Description of module lvds_rx
//

module lvds_rx (wifi_ddr_data_valid, o_debug_state, \o_fifo_data[0] , 
            internal_80MHz, n566, r_phase_count, n2963, w_rx_24_fifo_push, 
            data_out, n2946, n2906, \w_rx_24_fifo_data[1] , n2259, 
            \w_rx_24_fifo_data[2] , n564, n2907, \w_rx_24_fifo_data[3] , 
            n563, \w_rx_24_fifo_data[4] , n562, \w_rx_24_fifo_data[5] , 
            n561, \w_rx_24_fifo_data[6] , n560, \w_rx_24_fifo_data[7] , 
            n559, \w_rx_24_fifo_data[8] , n558, \w_rx_24_fifo_data[9] , 
            n557, \w_rx_24_fifo_data[10] , n556, \w_rx_24_fifo_data[11] , 
            n555, \w_rx_24_fifo_data[12] , n554, \w_rx_24_fifo_data[13] , 
            n553, \o_fifo_data[14] , n552, \o_fifo_data[15] , n551, 
            \o_fifo_data[16] , n550, \w_rx_24_fifo_data[17] , n549, 
            \w_rx_24_fifo_data[18] , n548, \w_rx_24_fifo_data[19] , n547, 
            \w_rx_24_fifo_data[20] , n546, \w_rx_24_fifo_data[21] , n545, 
            \w_rx_24_fifo_data[22] , n544, \w_rx_24_fifo_data[23] , n543, 
            \w_rx_24_fifo_data[24] , n542, \w_rx_24_fifo_data[25] , n541, 
            \w_rx_24_fifo_data[26] , n540, \w_rx_24_fifo_data[27] , n539, 
            \w_rx_24_fifo_data[28] , n538, \w_rx_24_fifo_data[29] , n537, 
            \r_phase_count_2__N_123[1] , \r_phase_count_2__N_123[2] , n2629, 
            n2910, n2909) /* synthesis syn_module_defined=1 */ ;
    input wifi_ddr_data_valid;
    output [1:0]o_debug_state;
    output \o_fifo_data[0] ;
    input internal_80MHz;
    input n566;
    output [2:0]r_phase_count;
    input n2963;
    output w_rx_24_fifo_push;
    input [1:0]data_out;
    output n2946;
    output n2906;
    output \w_rx_24_fifo_data[1] ;
    input n2259;
    output \w_rx_24_fifo_data[2] ;
    input n564;
    output n2907;
    output \w_rx_24_fifo_data[3] ;
    input n563;
    output \w_rx_24_fifo_data[4] ;
    input n562;
    output \w_rx_24_fifo_data[5] ;
    input n561;
    output \w_rx_24_fifo_data[6] ;
    input n560;
    output \w_rx_24_fifo_data[7] ;
    input n559;
    output \w_rx_24_fifo_data[8] ;
    input n558;
    output \w_rx_24_fifo_data[9] ;
    input n557;
    output \w_rx_24_fifo_data[10] ;
    input n556;
    output \w_rx_24_fifo_data[11] ;
    input n555;
    output \w_rx_24_fifo_data[12] ;
    input n554;
    output \w_rx_24_fifo_data[13] ;
    input n553;
    output \o_fifo_data[14] ;
    input n552;
    output \o_fifo_data[15] ;
    input n551;
    output \o_fifo_data[16] ;
    input n550;
    output \w_rx_24_fifo_data[17] ;
    input n549;
    output \w_rx_24_fifo_data[18] ;
    input n548;
    output \w_rx_24_fifo_data[19] ;
    input n547;
    output \w_rx_24_fifo_data[20] ;
    input n546;
    output \w_rx_24_fifo_data[21] ;
    input n545;
    output \w_rx_24_fifo_data[22] ;
    input n544;
    output \w_rx_24_fifo_data[23] ;
    input n543;
    output \w_rx_24_fifo_data[24] ;
    input n542;
    output \w_rx_24_fifo_data[25] ;
    input n541;
    output \w_rx_24_fifo_data[26] ;
    input n540;
    output \w_rx_24_fifo_data[27] ;
    input n539;
    output \w_rx_24_fifo_data[28] ;
    input n538;
    output \w_rx_24_fifo_data[29] ;
    input n537;
    input \r_phase_count_2__N_123[1] ;
    input \r_phase_count_2__N_123[2] ;
    input n2629;
    output n2910;
    output n2909;
    
    wire internal_80MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_80MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(64[6:20])
    
    wire n1926, internal_80MHz_enable_56, internal_80MHz_enable_17, o_fifo_push_N_159, 
        n1, n2957, n2757, n1277, n2952;
    wire [1:0]o_debug_state_1__N_121;
    
    wire n2612, internal_80MHz_enable_59, n2663, n2951, n2498;
    
    LUT4 i1403_2_lut (.A(wifi_ddr_data_valid), .B(o_debug_state[1]), .Z(n1926)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam i1403_2_lut.init = 16'h8888;
    FD1P3AX o_fifo_data_i0_i0 (.D(n566), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\o_fifo_data[0] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i0.GSR = "DISABLED";
    FD1P3AY r_phase_count_i0_i0 (.D(n2963), .SP(wifi_ddr_data_valid), .CK(internal_80MHz), 
            .Q(r_phase_count[0])) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam r_phase_count_i0_i0.GSR = "ENABLED";
    FD1P3AX o_fifo_push_41 (.D(o_fifo_push_N_159), .SP(internal_80MHz_enable_17), 
            .CK(internal_80MHz), .Q(w_rx_24_fifo_push)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_push_41.GSR = "ENABLED";
    LUT4 mux_24_Mux_0_i1_4_lut (.A(data_out[0]), .B(n2946), .C(o_debug_state[0]), 
         .D(data_out[1]), .Z(n1)) /* synthesis lut_function=(A (B (C+!(D))+!B !(C+(D)))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam mux_24_Mux_0_i1_4_lut.init = 16'hc0ca;
    LUT4 n1340_bdd_3_lut_2287_4_lut (.A(r_phase_count[2]), .B(n2957), .C(o_debug_state[0]), 
         .D(o_debug_state[1]), .Z(n2906)) /* synthesis lut_function=(!(A (B (C (D))+!B (C+(D)))+!A (B (C+(D))+!B (C (D))))) */ ;
    defparam n1340_bdd_3_lut_2287_4_lut.init = 16'h099f;
    FD1P3AX o_fifo_data_i0_i1 (.D(n2259), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[1] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i1.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i2 (.D(n564), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[2] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i2.GSR = "DISABLED";
    LUT4 n1340_bdd_3_lut_4_lut (.A(data_out[0]), .B(data_out[1]), .C(o_debug_state[0]), 
         .D(o_debug_state[1]), .Z(n2907)) /* synthesis lut_function=(!(A (C+(D))+!A (B (D)+!B (C+(D))))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(66[29:55])
    defparam n1340_bdd_3_lut_4_lut.init = 16'h004f;
    FD1P3AX o_fifo_data_i0_i3 (.D(n563), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[3] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i3.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i4 (.D(n562), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[4] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i4.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i5 (.D(n561), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[5] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i5.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i6 (.D(n560), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[6] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i6.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i7 (.D(n559), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[7] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i7.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i8 (.D(n558), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[8] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i8.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i9 (.D(n557), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[9] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i9.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i10 (.D(n556), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[10] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i10.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i11 (.D(n555), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[11] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i11.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i12 (.D(n554), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[12] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i12.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i13 (.D(n553), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[13] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i13.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i14 (.D(n552), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\o_fifo_data[14] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i14.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i15 (.D(n551), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\o_fifo_data[15] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i15.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i16 (.D(n550), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\o_fifo_data[16] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i16.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i17 (.D(n549), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[17] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i17.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i18 (.D(n548), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[18] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i18.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i19 (.D(n547), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[19] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i19.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i20 (.D(n546), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[20] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i20.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i21 (.D(n545), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[21] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i21.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i22 (.D(n544), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[22] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i22.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i23 (.D(n543), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[23] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i23.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i24 (.D(n542), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[24] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i24.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i25 (.D(n541), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[25] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i25.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i26 (.D(n540), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[26] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i26.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i27 (.D(n539), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[27] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i27.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i28 (.D(n538), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[28] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i28.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i29 (.D(n537), .SP(internal_80MHz_enable_56), 
            .CK(internal_80MHz), .Q(\w_rx_24_fifo_data[29] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i29.GSR = "DISABLED";
    FD1P3IX r_state_if_i0_i0 (.D(n1), .SP(wifi_ddr_data_valid), .CD(n1926), 
            .CK(internal_80MHz), .Q(o_debug_state[0])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam r_state_if_i0_i0.GSR = "ENABLED";
    LUT4 mux_24_Mux_1_i3_4_lut (.A(n2757), .B(n1277), .C(o_debug_state[1]), 
         .D(n2952), .Z(o_debug_state_1__N_121[1])) /* synthesis lut_function=(A (B (C+!(D))+!B !(C+(D)))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam mux_24_Mux_1_i3_4_lut.init = 16'hc0ca;
    LUT4 i1_4_lut (.A(data_out[0]), .B(r_phase_count[0]), .C(o_debug_state[0]), 
         .D(data_out[1]), .Z(n2757)) /* synthesis lut_function=(!(A+(B+!(C (D))))) */ ;
    defparam i1_4_lut.init = 16'h1000;
    LUT4 i2264_4_lut (.A(n2612), .B(n1277), .C(wifi_ddr_data_valid), .D(o_debug_state[1]), 
         .Z(internal_80MHz_enable_59)) /* synthesis lut_function=(!(A+!(B (C)+!B !((D)+!C)))) */ ;
    defparam i2264_4_lut.init = 16'h4050;
    LUT4 i1_4_lut_adj_14 (.A(n2663), .B(n2951), .C(n2957), .D(o_debug_state[1]), 
         .Z(n2612)) /* synthesis lut_function=(!(((C+(D))+!B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam i1_4_lut_adj_14.init = 16'h0008;
    LUT4 i1_2_lut (.A(r_phase_count[2]), .B(o_debug_state[0]), .Z(n2663)) /* synthesis lut_function=(!(A+!(B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam i1_2_lut.init = 16'h4444;
    FD1P3AX r_state_if_i0_i1 (.D(o_debug_state_1__N_121[1]), .SP(wifi_ddr_data_valid), 
            .CK(internal_80MHz), .Q(o_debug_state[1])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam r_state_if_i0_i1.GSR = "ENABLED";
    FD1P3AY r_phase_count_i0_i1 (.D(\r_phase_count_2__N_123[1] ), .SP(internal_80MHz_enable_59), 
            .CK(internal_80MHz), .Q(r_phase_count[1])) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam r_phase_count_i0_i1.GSR = "ENABLED";
    FD1P3AY r_phase_count_i0_i2 (.D(\r_phase_count_2__N_123[2] ), .SP(internal_80MHz_enable_59), 
            .CK(internal_80MHz), .Q(r_phase_count[2])) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=268, LSE_RLINE=280 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam r_phase_count_i0_i2.GSR = "ENABLED";
    LUT4 i543_2_lut_rep_63 (.A(r_phase_count[1]), .B(r_phase_count[0]), 
         .Z(n2957)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(86[42:59])
    defparam i543_2_lut_rep_63.init = 16'heeee;
    LUT4 i1_3_lut_rep_52 (.A(r_phase_count[0]), .B(r_phase_count[1]), .C(r_phase_count[2]), 
         .Z(n2946)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(80[25:48])
    defparam i1_3_lut_rep_52.init = 16'hfefe;
    LUT4 i1741_rep_1_2_lut_4_lut (.A(r_phase_count[0]), .B(r_phase_count[1]), 
         .C(r_phase_count[2]), .D(o_debug_state[0]), .Z(n1277)) /* synthesis lut_function=(!(A (D)+!A (B (D)+!B ((D)+!C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(80[25:48])
    defparam i1741_rep_1_2_lut_4_lut.init = 16'h00fe;
    LUT4 i1_3_lut (.A(o_debug_state[0]), .B(wifi_ddr_data_valid), .C(o_debug_state[1]), 
         .Z(internal_80MHz_enable_17)) /* synthesis lut_function=(!(A ((C)+!B)+!A !(B))) */ ;
    defparam i1_3_lut.init = 16'h4c4c;
    LUT4 i1_4_lut_adj_15 (.A(n2629), .B(n2498), .C(o_debug_state[0]), 
         .D(o_debug_state[1]), .Z(internal_80MHz_enable_56)) /* synthesis lut_function=(!((B (C (D)+!C !(D))+!B (C (D)))+!A)) */ ;
    defparam i1_4_lut_adj_15.init = 16'h0aa2;
    LUT4 i1949_2_lut (.A(data_out[1]), .B(data_out[0]), .Z(n2498)) /* synthesis lut_function=(A+!(B)) */ ;
    defparam i1949_2_lut.init = 16'hbbbb;
    LUT4 i2201_2_lut_rep_58 (.A(r_phase_count[1]), .B(r_phase_count[2]), 
         .Z(n2952)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i2201_2_lut_rep_58.init = 16'heeee;
    LUT4 i3_3_lut_4_lut (.A(r_phase_count[1]), .B(r_phase_count[2]), .C(o_debug_state[1]), 
         .D(r_phase_count[0]), .Z(o_fifo_push_N_159)) /* synthesis lut_function=(!(A+(B+((D)+!C)))) */ ;
    defparam i3_3_lut_4_lut.init = 16'h0010;
    LUT4 equal_10_i3_2_lut_rep_57 (.A(data_out[0]), .B(data_out[1]), .Z(n2951)) /* synthesis lut_function=(A+!(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(66[29:55])
    defparam equal_10_i3_2_lut_rep_57.init = 16'hbbbb;
    LUT4 n3_bdd_3_lut_4_lut (.A(data_out[0]), .B(data_out[1]), .C(o_debug_state[0]), 
         .D(o_debug_state[1]), .Z(n2910)) /* synthesis lut_function=(!(A (C+(D))+!A (B (D)+!B (C+(D))))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(66[29:55])
    defparam n3_bdd_3_lut_4_lut.init = 16'h004f;
    LUT4 n3_bdd_3_lut_2290_4_lut (.A(r_phase_count[1]), .B(r_phase_count[0]), 
         .C(o_debug_state[0]), .D(o_debug_state[1]), .Z(n2909)) /* synthesis lut_function=(!(A (B (C (D))+!B (C+(D)))+!A (B (C+(D))+!B (C (D))))) */ ;
    defparam n3_bdd_3_lut_2290_4_lut.init = 16'h099f;
    
endmodule
//
// Verilog Description of module spi_generator_U4
//

module spi_generator_U4 (spi_busy, internal_160MHz, n1237, spi1_sck_c, 
            n3030, internal_160MHz_enable_84, \shift_reg_15__N_168[0] , 
            n2932, spi1_mosi_c, \shift_reg[1] , \shift_reg_15__N_168[1] , 
            \shift_reg[2] , \shift_reg_15__N_168[2] , \shift_reg[3] , 
            \shift_reg_15__N_168[3] , \shift_reg[4] , \shift_reg_15__N_168[4] , 
            \shift_reg[5] , \shift_reg_15__N_168[5] , \shift_reg[6] , 
            \shift_reg_15__N_168[6] , \shift_reg[7] , \shift_reg_15__N_168[7] , 
            \shift_reg[8] , \shift_reg_15__N_168[8] , \shift_reg[9] , 
            \shift_reg_15__N_168[9] , \shift_reg[10] , \shift_reg_15__N_168[10] , 
            \shift_reg[11] , \shift_reg_15__N_168[11] , \shift_reg[12] , 
            \shift_reg_15__N_168[12] , \shift_reg[13] , \shift_reg_15__N_168[13] , 
            \shift_reg[14] , \shift_reg_15__N_168[14] , n2693, \shift_reg[15] , 
            \w_rx_09_fifo_data[31] ) /* synthesis syn_module_defined=1 */ ;
    output spi_busy;
    input internal_160MHz;
    input n1237;
    output spi1_sck_c;
    output n3030;
    input internal_160MHz_enable_84;
    input \shift_reg_15__N_168[0] ;
    input n2932;
    output spi1_mosi_c;
    output \shift_reg[1] ;
    input \shift_reg_15__N_168[1] ;
    output \shift_reg[2] ;
    input \shift_reg_15__N_168[2] ;
    output \shift_reg[3] ;
    input \shift_reg_15__N_168[3] ;
    output \shift_reg[4] ;
    input \shift_reg_15__N_168[4] ;
    output \shift_reg[5] ;
    input \shift_reg_15__N_168[5] ;
    output \shift_reg[6] ;
    input \shift_reg_15__N_168[6] ;
    output \shift_reg[7] ;
    input \shift_reg_15__N_168[7] ;
    output \shift_reg[8] ;
    input \shift_reg_15__N_168[8] ;
    output \shift_reg[9] ;
    input \shift_reg_15__N_168[9] ;
    output \shift_reg[10] ;
    input \shift_reg_15__N_168[10] ;
    output \shift_reg[11] ;
    input \shift_reg_15__N_168[11] ;
    output \shift_reg[12] ;
    input \shift_reg_15__N_168[12] ;
    output \shift_reg[13] ;
    input \shift_reg_15__N_168[13] ;
    output \shift_reg[14] ;
    input \shift_reg_15__N_168[14] ;
    output n2693;
    output \shift_reg[15] ;
    input \w_rx_09_fifo_data[31] ;
    
    wire internal_160MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_160MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(63[6:21])
    wire [4:0]bit_count;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(177[32:41])
    
    wire n2934, spi_clk_enable;
    wire [15:0]shift_reg;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(176[26:35])
    wire [4:0]bit_count_4__N_218;
    
    wire internal_160MHz_enable_25, n1925, spi_clk_N_224, n1908, n1338, 
        n1342;
    wire [4:0]bit_count_4__N_184;
    
    wire n1344, n8, n2653;
    
    LUT4 i503_2_lut_rep_40_3_lut (.A(bit_count[1]), .B(bit_count[0]), .C(bit_count[2]), 
         .Z(n2934)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(218[30:43])
    defparam i503_2_lut_rep_40_3_lut.init = 16'hfefe;
    FD1S3AX spi_busy_42 (.D(n1237), .CK(internal_160MHz), .Q(spi_busy)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam spi_busy_42.GSR = "ENABLED";
    LUT4 spi_clk_I_0_49_2_lut_rep_65 (.A(spi1_sck_c), .B(spi_clk_enable), 
         .Z(n3030)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(214[26:51])
    defparam spi_clk_I_0_49_2_lut_rep_65.init = 16'h8888;
    FD1P3AX shift_reg_i0 (.D(\shift_reg_15__N_168[0] ), .SP(internal_160MHz_enable_84), 
            .CK(internal_160MHz), .Q(shift_reg[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i0.GSR = "ENABLED";
    FD1S3IX bit_count_i0 (.D(bit_count_4__N_218[0]), .CK(internal_160MHz), 
            .CD(n2932), .Q(bit_count[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i0.GSR = "ENABLED";
    FD1P3AX spi_mosi_38 (.D(shift_reg[0]), .SP(internal_160MHz_enable_25), 
            .CK(internal_160MHz), .Q(spi1_mosi_c)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam spi_mosi_38.GSR = "ENABLED";
    LUT4 i1402_1_lut (.A(spi_clk_enable), .Z(n1925)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam i1402_1_lut.init = 16'h5555;
    LUT4 i630_1_lut (.A(spi1_sck_c), .Z(spi_clk_N_224)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(189[13] 192[16])
    defparam i630_1_lut.init = 16'h5555;
    FD1S3AX spi_clk_enable_41 (.D(n1908), .CK(internal_160MHz), .Q(spi_clk_enable)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam spi_clk_enable_41.GSR = "ENABLED";
    LUT4 i1_2_lut_3_lut (.A(bit_count[1]), .B(bit_count[0]), .C(bit_count[2]), 
         .Z(n1338)) /* synthesis lut_function=(A (C)+!A (B (C)+!B !(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(218[30:43])
    defparam i1_2_lut_3_lut.init = 16'he1e1;
    FD1S3IX spi_clk_36 (.D(spi_clk_N_224), .CK(internal_160MHz), .CD(n1925), 
            .Q(spi1_sck_c)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(186[18] 196[12])
    defparam spi_clk_36.GSR = "ENABLED";
    FD1P3AX shift_reg_i1 (.D(\shift_reg_15__N_168[1] ), .SP(internal_160MHz_enable_84), 
            .CK(internal_160MHz), .Q(\shift_reg[1] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i1.GSR = "ENABLED";
    LUT4 i1_2_lut (.A(bit_count[1]), .B(bit_count[0]), .Z(n1342)) /* synthesis lut_function=(A (B)+!A !(B)) */ ;
    defparam i1_2_lut.init = 16'h9999;
    LUT4 i1682_4_lut (.A(bit_count[4]), .B(n2932), .C(bit_count[3]), .D(n2934), 
         .Z(bit_count_4__N_184[4])) /* synthesis lut_function=(A (B+(C+(D)))+!A (B+!(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(214[22] 225[16])
    defparam i1682_4_lut.init = 16'heeed;
    LUT4 i704_2_lut_3_lut_4_lut (.A(spi1_sck_c), .B(spi_clk_enable), .C(bit_count[0]), 
         .D(spi_busy), .Z(bit_count_4__N_218[0])) /* synthesis lut_function=(!(A (B (C (D)+!C !(D))+!B !(C))+!A !(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(214[26:51])
    defparam i704_2_lut_3_lut_4_lut.init = 16'h78f0;
    LUT4 spi_busy_I_3_2_lut_rep_46_3_lut (.A(spi1_sck_c), .B(spi_clk_enable), 
         .C(spi_busy), .Z(internal_160MHz_enable_25)) /* synthesis lut_function=(A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(214[26:51])
    defparam spi_busy_I_3_2_lut_rep_46_3_lut.init = 16'h8080;
    FD1P3AX shift_reg_i2 (.D(\shift_reg_15__N_168[2] ), .SP(internal_160MHz_enable_84), 
            .CK(internal_160MHz), .Q(\shift_reg[2] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i2.GSR = "ENABLED";
    FD1P3AX shift_reg_i3 (.D(\shift_reg_15__N_168[3] ), .SP(internal_160MHz_enable_84), 
            .CK(internal_160MHz), .Q(\shift_reg[3] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i3.GSR = "ENABLED";
    FD1P3AX shift_reg_i4 (.D(\shift_reg_15__N_168[4] ), .SP(internal_160MHz_enable_84), 
            .CK(internal_160MHz), .Q(\shift_reg[4] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i4.GSR = "ENABLED";
    FD1P3AX shift_reg_i5 (.D(\shift_reg_15__N_168[5] ), .SP(internal_160MHz_enable_84), 
            .CK(internal_160MHz), .Q(\shift_reg[5] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i5.GSR = "ENABLED";
    FD1P3AX shift_reg_i6 (.D(\shift_reg_15__N_168[6] ), .SP(internal_160MHz_enable_84), 
            .CK(internal_160MHz), .Q(\shift_reg[6] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i6.GSR = "ENABLED";
    FD1P3AX shift_reg_i7 (.D(\shift_reg_15__N_168[7] ), .SP(internal_160MHz_enable_84), 
            .CK(internal_160MHz), .Q(\shift_reg[7] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i7.GSR = "ENABLED";
    FD1P3AX shift_reg_i8 (.D(\shift_reg_15__N_168[8] ), .SP(internal_160MHz_enable_84), 
            .CK(internal_160MHz), .Q(\shift_reg[8] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i8.GSR = "ENABLED";
    FD1P3AX shift_reg_i9 (.D(\shift_reg_15__N_168[9] ), .SP(internal_160MHz_enable_84), 
            .CK(internal_160MHz), .Q(\shift_reg[9] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i9.GSR = "ENABLED";
    FD1P3AX shift_reg_i10 (.D(\shift_reg_15__N_168[10] ), .SP(internal_160MHz_enable_84), 
            .CK(internal_160MHz), .Q(\shift_reg[10] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i10.GSR = "ENABLED";
    FD1P3AX shift_reg_i11 (.D(\shift_reg_15__N_168[11] ), .SP(internal_160MHz_enable_84), 
            .CK(internal_160MHz), .Q(\shift_reg[11] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i11.GSR = "ENABLED";
    FD1P3AX shift_reg_i12 (.D(\shift_reg_15__N_168[12] ), .SP(internal_160MHz_enable_84), 
            .CK(internal_160MHz), .Q(\shift_reg[12] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i12.GSR = "ENABLED";
    FD1P3AX shift_reg_i13 (.D(\shift_reg_15__N_168[13] ), .SP(internal_160MHz_enable_84), 
            .CK(internal_160MHz), .Q(\shift_reg[13] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i13.GSR = "ENABLED";
    FD1P3AX shift_reg_i14 (.D(\shift_reg_15__N_168[14] ), .SP(internal_160MHz_enable_84), 
            .CK(internal_160MHz), .Q(\shift_reg[14] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i14.GSR = "ENABLED";
    FD1P3IX bit_count_i1 (.D(n1342), .SP(internal_160MHz_enable_25), .CD(n2932), 
            .CK(internal_160MHz), .Q(bit_count[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i1.GSR = "ENABLED";
    FD1P3IX bit_count_i2 (.D(n1338), .SP(internal_160MHz_enable_25), .CD(n2932), 
            .CK(internal_160MHz), .Q(bit_count[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i2.GSR = "ENABLED";
    FD1P3IX bit_count_i3 (.D(n1344), .SP(internal_160MHz_enable_25), .CD(n2932), 
            .CK(internal_160MHz), .Q(bit_count[3])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i3.GSR = "ENABLED";
    FD1P3AX bit_count_i4 (.D(bit_count_4__N_184[4]), .SP(internal_160MHz_enable_84), 
            .CK(internal_160MHz), .Q(bit_count[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i4.GSR = "ENABLED";
    LUT4 i1_3_lut (.A(bit_count[0]), .B(n8), .C(bit_count[3]), .Z(n2693)) /* synthesis lut_function=((B+(C))+!A) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(220[21:35])
    defparam i1_3_lut.init = 16'hfdfd;
    LUT4 i1_3_lut_adj_12 (.A(bit_count[1]), .B(bit_count[2]), .C(bit_count[4]), 
         .Z(n8)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(220[21:35])
    defparam i1_3_lut_adj_12.init = 16'hfefe;
    LUT4 i1387_4_lut (.A(n2653), .B(n2932), .C(spi_clk_enable), .D(internal_160MHz_enable_25), 
         .Z(n1908)) /* synthesis lut_function=(A (B+!((D)+!C))+!A (B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam i1387_4_lut.init = 16'hdcfc;
    LUT4 i1_3_lut_adj_13 (.A(n8), .B(bit_count[3]), .C(bit_count[0]), 
         .Z(n2653)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;
    defparam i1_3_lut_adj_13.init = 16'h1010;
    LUT4 i1_2_lut_3_lut_4_lut (.A(bit_count[1]), .B(bit_count[0]), .C(bit_count[3]), 
         .D(bit_count[2]), .Z(n1344)) /* synthesis lut_function=(A (C)+!A (B (C)+!B (C (D)+!C !(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(218[30:43])
    defparam i1_2_lut_3_lut_4_lut.init = 16'hf0e1;
    FD1P3IX shift_reg_i15 (.D(\w_rx_09_fifo_data[31] ), .SP(internal_160MHz_enable_84), 
            .CD(internal_160MHz_enable_25), .CK(internal_160MHz), .Q(\shift_reg[15] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=505, LSE_RLINE=515 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i15.GSR = "ENABLED";
    
endmodule
//
// Verilog Description of module ddr_data_recovery
//

module ddr_data_recovery (data_out, internal_80MHz, wifi_ddr_data_valid, 
            internal_200MHz, data_rising, sdr_rx_wifi_c, n805, data_falling, 
            n2955, rRst, VCC_net, GND_net, main_reset_n_N_4) /* synthesis syn_module_defined=1 */ ;
    output [1:0]data_out;
    input internal_80MHz;
    output wifi_ddr_data_valid;
    input internal_200MHz;
    input data_rising;
    input sdr_rx_wifi_c;
    input n805;
    input data_falling;
    input n2955;
    input rRst;
    input VCC_net;
    input GND_net;
    input main_reset_n_N_4;
    
    wire internal_80MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_80MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(64[6:20])
    wire internal_200MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_200MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(79[6:21])
    wire VCC_net /* synthesis CE_NET_FOR_BUS20=20, DSPPORT_20=CE3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(125[10:19])
    wire GND_net /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(13[23:34])
    wire main_reset_n_N_4 /* synthesis DSPPORT_20=RST3, RESET_NET_FOR_BUS20=20 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(191[6:21])
    
    wire fifo_empty_N_71;
    wire [1:0]fifo_out;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(20[16:24])
    
    wire data_rising_capture, fifo_wr_en, n2950;
    wire [1:0]fifo_data;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(18[15:24])
    
    wire internal_200MHz_enable_4, fifo_empty, fifo_full;
    
    FD1P3AX data_out_i0_i0 (.D(fifo_out[0]), .SP(fifo_empty_N_71), .CK(internal_80MHz), 
            .Q(data_out[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=194, LSE_RLINE=202 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(81[18] 88[12])
    defparam data_out_i0_i0.GSR = "ENABLED";
    FD1S3AX data_valid_37 (.D(fifo_empty_N_71), .CK(internal_80MHz), .Q(wifi_ddr_data_valid)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=194, LSE_RLINE=202 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(81[18] 88[12])
    defparam data_valid_37.GSR = "ENABLED";
    FD1P3AX data_rising_capture_32 (.D(sdr_rx_wifi_c), .SP(data_rising), 
            .CK(internal_200MHz), .Q(data_rising_capture)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=194, LSE_RLINE=202 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(56[18] 72[12])
    defparam data_rising_capture_32.GSR = "ENABLED";
    FD1S3IX fifo_wr_en_34 (.D(n2950), .CK(internal_200MHz), .CD(n805), 
            .Q(fifo_wr_en)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=194, LSE_RLINE=202 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(56[18] 72[12])
    defparam fifo_wr_en_34.GSR = "ENABLED";
    FD1P3AX fifo_data_i0_i0 (.D(sdr_rx_wifi_c), .SP(internal_200MHz_enable_4), 
            .CK(internal_200MHz), .Q(fifo_data[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=194, LSE_RLINE=202 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(56[18] 72[12])
    defparam fifo_data_i0_i0.GSR = "DISABLED";
    FD1P3AX data_out_i0_i1 (.D(fifo_out[1]), .SP(fifo_empty_N_71), .CK(internal_80MHz), 
            .Q(data_out[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=194, LSE_RLINE=202 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(81[18] 88[12])
    defparam data_out_i0_i1.GSR = "ENABLED";
    FD1P3AX fifo_data_i0_i1 (.D(data_rising_capture), .SP(internal_200MHz_enable_4), 
            .CK(internal_200MHz), .Q(fifo_data[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=194, LSE_RLINE=202 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(56[18] 72[12])
    defparam fifo_data_i0_i1.GSR = "DISABLED";
    LUT4 fifo_empty_I_0_1_lut (.A(fifo_empty), .Z(fifo_empty_N_71)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(85[17:28])
    defparam fifo_empty_I_0_1_lut.init = 16'h5555;
    LUT4 fifo_full_I_0_1_lut_rep_56 (.A(fifo_full), .Z(n2950)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(67[21:31])
    defparam fifo_full_I_0_1_lut_rep_56.init = 16'h5555;
    LUT4 i1_2_lut_3_lut_3_lut (.A(fifo_full), .B(data_falling), .C(n2955), 
         .Z(internal_200MHz_enable_4)) /* synthesis lut_function=(!(A+!(B (C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(67[21:31])
    defparam i1_2_lut_3_lut_3_lut.init = 16'h4040;
    fifo_dc_2in_2out fifo_inst (.internal_200MHz(internal_200MHz), .internal_80MHz(internal_80MHz), 
            .rRst(rRst), .fifo_full(fifo_full), .fifo_empty(fifo_empty), 
            .VCC_net(VCC_net), .GND_net(GND_net), .fifo_wr_en(fifo_wr_en), 
            .wifi_ddr_data_valid(wifi_ddr_data_valid), .fifo_data({fifo_data}), 
            .main_reset_n_N_4(main_reset_n_N_4), .fifo_out({fifo_out})) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    
endmodule
//
// Verilog Description of module fifo_dc_2in_2out
//

module fifo_dc_2in_2out (internal_200MHz, internal_80MHz, rRst, fifo_full, 
            fifo_empty, VCC_net, GND_net, fifo_wr_en, wifi_ddr_data_valid, 
            fifo_data, main_reset_n_N_4, fifo_out) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;
    input internal_200MHz;
    input internal_80MHz;
    input rRst;
    output fifo_full;
    output fifo_empty;
    input VCC_net;
    input GND_net;
    input fifo_wr_en;
    input wifi_ddr_data_valid;
    input [1:0]fifo_data;
    input main_reset_n_N_4;
    output [1:0]fifo_out;
    
    wire internal_200MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_200MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(79[6:21])
    wire internal_80MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_80MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(64[6:20])
    wire VCC_net /* synthesis CE_NET_FOR_BUS20=20, DSPPORT_20=CE3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(125[10:19])
    wire GND_net /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(13[23:34])
    wire main_reset_n_N_4 /* synthesis DSPPORT_20=RST3, RESET_NET_FOR_BUS20=20 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(191[6:21])
    
    wire wcount_2, wren_i, iwcount_2, wcount_3, iwcount_3, wcount_4, 
        iwcount_4, w_gcount_0, w_gdata_0, w_gcount_1, w_gdata_1, w_gcount_2, 
        w_gdata_2, w_gcount_3, w_gdata_3, w_gcount_4, wptr_0, wcount_0, 
        wptr_1, wcount_1, wptr_2, wptr_3, wptr_4, w_gcount_r0, ircount_0, 
        rden_i, rcount_0, ircount_1, rcount_1, ircount_2, rcount_2, 
        ircount_3, rcount_3, ircount_4, rcount_4, r_gdata_0, r_gcount_0, 
        r_gdata_1, r_gcount_1, r_gdata_2, r_gcount_2, r_gdata_3, r_gcount_3, 
        r_gcount_4, rptr_0, rptr_1, rptr_2, rptr_3, rptr_4, w_gcount_r1, 
        w_gcount_r2, w_gcount_r3, w_gcount_r4, w_gcount_r20, r_gcount_w0, 
        r_gcount_w1, r_gcount_w2, r_gcount_w3, r_gcount_w4, w_gcount_r21, 
        w_gcount_r22, w_gcount_r23, w_gcount_r24, full_d, r_gcount_w20, 
        r_gcount_w21, r_gcount_w22, r_gcount_w23, r_gcount_w24, empty_d, 
        iwcount_0, w_gctr_ci, iwcount_1, co0, co1, r_gctr_ci, co0_1, 
        co1_1, cmp_ci, wcount_r0, w_g2b_xor_cluster_0, co0_2, wcount_r2, 
        wcount_r3, co1_2, empty_cmp_clr, empty_cmp_set, empty_d_c, 
        cmp_ci_1, rcount_w0, r_g2b_xor_cluster_0, co0_3, rcount_w2, 
        rcount_w3, co1_3, full_cmp_clr, full_cmp_set, full_d_c, invout_1, 
        invout_0;
    
    FD1P3AX FF_49 (.D(iwcount_2), .SP(wren_i), .CK(internal_200MHz), .Q(wcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(251[13] 252[22])
    defparam FF_49.GSR = "ENABLED";
    FD1P3AX FF_48 (.D(iwcount_3), .SP(wren_i), .CK(internal_200MHz), .Q(wcount_3)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(255[13] 256[22])
    defparam FF_48.GSR = "ENABLED";
    FD1P3AX FF_47 (.D(iwcount_4), .SP(wren_i), .CK(internal_200MHz), .Q(wcount_4)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(259[13] 260[22])
    defparam FF_47.GSR = "ENABLED";
    FD1P3AX FF_46 (.D(w_gdata_0), .SP(wren_i), .CK(internal_200MHz), .Q(w_gcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(263[13] 264[24])
    defparam FF_46.GSR = "ENABLED";
    FD1P3AX FF_45 (.D(w_gdata_1), .SP(wren_i), .CK(internal_200MHz), .Q(w_gcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(267[13] 268[24])
    defparam FF_45.GSR = "ENABLED";
    FD1P3AX FF_44 (.D(w_gdata_2), .SP(wren_i), .CK(internal_200MHz), .Q(w_gcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(271[13] 272[24])
    defparam FF_44.GSR = "ENABLED";
    FD1P3AX FF_43 (.D(w_gdata_3), .SP(wren_i), .CK(internal_200MHz), .Q(w_gcount_3)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(275[13] 276[24])
    defparam FF_43.GSR = "ENABLED";
    FD1P3AX FF_42 (.D(wcount_4), .SP(wren_i), .CK(internal_200MHz), .Q(w_gcount_4)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(279[13] 280[24])
    defparam FF_42.GSR = "ENABLED";
    FD1P3AX FF_41 (.D(wcount_0), .SP(wren_i), .CK(internal_200MHz), .Q(wptr_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(283[13] 284[20])
    defparam FF_41.GSR = "ENABLED";
    FD1P3AX FF_40 (.D(wcount_1), .SP(wren_i), .CK(internal_200MHz), .Q(wptr_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(287[13] 288[20])
    defparam FF_40.GSR = "ENABLED";
    FD1P3AX FF_39 (.D(wcount_2), .SP(wren_i), .CK(internal_200MHz), .Q(wptr_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(291[13] 292[20])
    defparam FF_39.GSR = "ENABLED";
    FD1P3AX FF_38 (.D(wcount_3), .SP(wren_i), .CK(internal_200MHz), .Q(wptr_3)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(295[13] 296[20])
    defparam FF_38.GSR = "ENABLED";
    FD1P3AX FF_37 (.D(wcount_4), .SP(wren_i), .CK(internal_200MHz), .Q(wptr_4)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(299[13] 300[20])
    defparam FF_37.GSR = "ENABLED";
    FD1S3AX FF_21 (.D(w_gcount_0), .CK(internal_80MHz), .Q(w_gcount_r0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(357[13:78])
    defparam FF_21.GSR = "ENABLED";
    FD1P3BX FF_36 (.D(ircount_0), .SP(rden_i), .CK(internal_80MHz), .PD(rRst), 
            .Q(rcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(303[13] 304[22])
    defparam FF_36.GSR = "DISABLED";
    FD1P3DX FF_35 (.D(ircount_1), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(307[13] 308[22])
    defparam FF_35.GSR = "DISABLED";
    FD1P3DX FF_34 (.D(ircount_2), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(311[13] 312[22])
    defparam FF_34.GSR = "DISABLED";
    FD1P3DX FF_33 (.D(ircount_3), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rcount_3)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(315[13] 316[22])
    defparam FF_33.GSR = "DISABLED";
    FD1P3DX FF_32 (.D(ircount_4), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rcount_4)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(319[13] 320[22])
    defparam FF_32.GSR = "DISABLED";
    FD1P3DX FF_31 (.D(r_gdata_0), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(323[13] 324[24])
    defparam FF_31.GSR = "DISABLED";
    FD1P3DX FF_30 (.D(r_gdata_1), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(327[13] 328[24])
    defparam FF_30.GSR = "DISABLED";
    FD1P3DX FF_29 (.D(r_gdata_2), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(331[13] 332[24])
    defparam FF_29.GSR = "DISABLED";
    FD1P3DX FF_28 (.D(r_gdata_3), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_3)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(335[13] 336[24])
    defparam FF_28.GSR = "DISABLED";
    FD1P3DX FF_27 (.D(rcount_4), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_4)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(339[13:87])
    defparam FF_27.GSR = "DISABLED";
    FD1P3DX FF_26 (.D(rcount_0), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(342[13:83])
    defparam FF_26.GSR = "DISABLED";
    FD1P3DX FF_25 (.D(rcount_1), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(345[13:83])
    defparam FF_25.GSR = "DISABLED";
    FD1P3DX FF_24 (.D(rcount_2), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(348[13:83])
    defparam FF_24.GSR = "DISABLED";
    FD1P3DX FF_23 (.D(rcount_3), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_3)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(351[13:83])
    defparam FF_23.GSR = "DISABLED";
    FD1P3DX FF_22 (.D(rcount_4), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_4)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(354[13:83])
    defparam FF_22.GSR = "DISABLED";
    FD1S3AX FF_20 (.D(w_gcount_1), .CK(internal_80MHz), .Q(w_gcount_r1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(360[13:78])
    defparam FF_20.GSR = "ENABLED";
    FD1S3AX FF_19 (.D(w_gcount_2), .CK(internal_80MHz), .Q(w_gcount_r2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(363[13:78])
    defparam FF_19.GSR = "ENABLED";
    FD1S3AX FF_18 (.D(w_gcount_3), .CK(internal_80MHz), .Q(w_gcount_r3)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(366[13:78])
    defparam FF_18.GSR = "ENABLED";
    FD1S3AX FF_17 (.D(w_gcount_4), .CK(internal_80MHz), .Q(w_gcount_r4)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(369[13:78])
    defparam FF_17.GSR = "ENABLED";
    FD1S3AX FF_11 (.D(w_gcount_r0), .CK(internal_80MHz), .Q(w_gcount_r20)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(387[13:80])
    defparam FF_11.GSR = "ENABLED";
    FD1S3DX FF_16 (.D(r_gcount_0), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(372[13:77])
    defparam FF_16.GSR = "DISABLED";
    FD1S3DX FF_15 (.D(r_gcount_1), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(375[13:77])
    defparam FF_15.GSR = "DISABLED";
    FD1S3DX FF_14 (.D(r_gcount_2), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(378[13:77])
    defparam FF_14.GSR = "DISABLED";
    FD1S3DX FF_13 (.D(r_gcount_3), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w3)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(381[13:77])
    defparam FF_13.GSR = "DISABLED";
    FD1S3DX FF_12 (.D(r_gcount_4), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w4)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(384[13:77])
    defparam FF_12.GSR = "DISABLED";
    FD1S3AX FF_10 (.D(w_gcount_r1), .CK(internal_80MHz), .Q(w_gcount_r21)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(390[13:80])
    defparam FF_10.GSR = "ENABLED";
    FD1S3AX FF_9 (.D(w_gcount_r2), .CK(internal_80MHz), .Q(w_gcount_r22)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(393[13:79])
    defparam FF_9.GSR = "ENABLED";
    FD1S3AX FF_8 (.D(w_gcount_r3), .CK(internal_80MHz), .Q(w_gcount_r23)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(396[13:79])
    defparam FF_8.GSR = "ENABLED";
    FD1S3AX FF_7 (.D(w_gcount_r4), .CK(internal_80MHz), .Q(w_gcount_r24)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(399[13:79])
    defparam FF_7.GSR = "ENABLED";
    FD1S3AX FF_0 (.D(full_d), .CK(internal_200MHz), .Q(fifo_full)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(420[13:68])
    defparam FF_0.GSR = "ENABLED";
    FD1S3DX FF_6 (.D(r_gcount_w0), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w20)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(402[13:78])
    defparam FF_6.GSR = "DISABLED";
    FD1S3DX FF_5 (.D(r_gcount_w1), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w21)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(405[13:78])
    defparam FF_5.GSR = "DISABLED";
    FD1S3DX FF_4 (.D(r_gcount_w2), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w22)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(408[13:78])
    defparam FF_4.GSR = "DISABLED";
    FD1S3DX FF_3 (.D(r_gcount_w3), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w23)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(411[13:78])
    defparam FF_3.GSR = "DISABLED";
    FD1S3DX FF_2 (.D(r_gcount_w4), .CK(internal_200MHz), .CD(rRst), .Q(r_gcount_w24)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(414[13:78])
    defparam FF_2.GSR = "DISABLED";
    FD1S3BX FF_1 (.D(empty_d), .CK(internal_80MHz), .PD(rRst), .Q(fifo_empty)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(417[13:69])
    defparam FF_1.GSR = "DISABLED";
    FD1P3AY FF_51 (.D(iwcount_0), .SP(wren_i), .CK(internal_200MHz), .Q(wcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(243[13] 244[22])
    defparam FF_51.GSR = "ENABLED";
    CCU2C w_gctr_cia (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(VCC_net), .B1(VCC_net), .C1(VCC_net), .D1(VCC_net), .COUT(w_gctr_ci)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(427[11] 429[48])
    defparam w_gctr_cia.INIT0 = 16'b0110011010101010;
    defparam w_gctr_cia.INIT1 = 16'b0110011010101010;
    defparam w_gctr_cia.INJECT1_0 = "NO";
    defparam w_gctr_cia.INJECT1_1 = "NO";
    CCU2C w_gctr_0 (.A0(wcount_0), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(wcount_1), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(w_gctr_ci), 
          .COUT(co0), .S0(iwcount_0), .S1(iwcount_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(435[11] 437[69])
    defparam w_gctr_0.INIT0 = 16'b0110011010101010;
    defparam w_gctr_0.INIT1 = 16'b0110011010101010;
    defparam w_gctr_0.INJECT1_0 = "NO";
    defparam w_gctr_0.INJECT1_1 = "NO";
    CCU2C w_gctr_1 (.A0(wcount_2), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(wcount_3), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(co0), 
          .COUT(co1), .S0(iwcount_2), .S1(iwcount_3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(443[11] 445[63])
    defparam w_gctr_1.INIT0 = 16'b0110011010101010;
    defparam w_gctr_1.INIT1 = 16'b0110011010101010;
    defparam w_gctr_1.INJECT1_0 = "NO";
    defparam w_gctr_1.INJECT1_1 = "NO";
    CCU2C w_gctr_2 (.A0(wcount_4), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(co1), 
          .S0(iwcount_4)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(451[11] 453[54])
    defparam w_gctr_2.INIT0 = 16'b0110011010101010;
    defparam w_gctr_2.INIT1 = 16'b0110011010101010;
    defparam w_gctr_2.INJECT1_0 = "NO";
    defparam w_gctr_2.INJECT1_1 = "NO";
    CCU2C r_gctr_cia (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(VCC_net), .B1(VCC_net), .C1(VCC_net), .D1(VCC_net), .COUT(r_gctr_ci)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(459[11] 461[48])
    defparam r_gctr_cia.INIT0 = 16'b0110011010101010;
    defparam r_gctr_cia.INIT1 = 16'b0110011010101010;
    defparam r_gctr_cia.INJECT1_0 = "NO";
    defparam r_gctr_cia.INJECT1_1 = "NO";
    CCU2C r_gctr_0 (.A0(rcount_0), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(rcount_1), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(r_gctr_ci), 
          .COUT(co0_1), .S0(ircount_0), .S1(ircount_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(467[11] 469[71])
    defparam r_gctr_0.INIT0 = 16'b0110011010101010;
    defparam r_gctr_0.INIT1 = 16'b0110011010101010;
    defparam r_gctr_0.INJECT1_0 = "NO";
    defparam r_gctr_0.INJECT1_1 = "NO";
    CCU2C r_gctr_1 (.A0(rcount_2), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(rcount_3), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(co0_1), 
          .COUT(co1_1), .S0(ircount_2), .S1(ircount_3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(475[11] 477[67])
    defparam r_gctr_1.INIT0 = 16'b0110011010101010;
    defparam r_gctr_1.INIT1 = 16'b0110011010101010;
    defparam r_gctr_1.INJECT1_0 = "NO";
    defparam r_gctr_1.INJECT1_1 = "NO";
    CCU2C r_gctr_2 (.A0(rcount_4), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(co1_1), 
          .S0(ircount_4)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(483[11] 485[58])
    defparam r_gctr_2.INIT0 = 16'b0110011010101010;
    defparam r_gctr_2.INIT1 = 16'b0110011010101010;
    defparam r_gctr_2.INJECT1_0 = "NO";
    defparam r_gctr_2.INJECT1_1 = "NO";
    CCU2C empty_cmp_ci_a (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(rden_i), .B1(rden_i), .C1(VCC_net), .D1(VCC_net), .COUT(cmp_ci)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(491[11] 493[45])
    defparam empty_cmp_ci_a.INIT0 = 16'b0110011010101010;
    defparam empty_cmp_ci_a.INIT1 = 16'b0110011010101010;
    defparam empty_cmp_ci_a.INJECT1_0 = "NO";
    defparam empty_cmp_ci_a.INJECT1_1 = "NO";
    CCU2C empty_cmp_0 (.A0(rcount_0), .B0(wcount_r0), .C0(VCC_net), .D0(VCC_net), 
          .A1(rcount_1), .B1(w_g2b_xor_cluster_0), .C1(VCC_net), .D1(VCC_net), 
          .CIN(cmp_ci), .COUT(co0_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(499[11] 501[50])
    defparam empty_cmp_0.INIT0 = 16'b1001100110101010;
    defparam empty_cmp_0.INIT1 = 16'b1001100110101010;
    defparam empty_cmp_0.INJECT1_0 = "NO";
    defparam empty_cmp_0.INJECT1_1 = "NO";
    CCU2C empty_cmp_1 (.A0(rcount_2), .B0(wcount_r2), .C0(VCC_net), .D0(VCC_net), 
          .A1(rcount_3), .B1(wcount_r3), .C1(VCC_net), .D1(VCC_net), 
          .CIN(co0_2), .COUT(co1_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(507[11] 509[49])
    defparam empty_cmp_1.INIT0 = 16'b1001100110101010;
    defparam empty_cmp_1.INIT1 = 16'b1001100110101010;
    defparam empty_cmp_1.INJECT1_0 = "NO";
    defparam empty_cmp_1.INJECT1_1 = "NO";
    CCU2C empty_cmp_2 (.A0(empty_cmp_set), .B0(empty_cmp_clr), .C0(VCC_net), 
          .D0(VCC_net), .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), 
          .CIN(co1_2), .COUT(empty_d_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(515[11] 517[69])
    defparam empty_cmp_2.INIT0 = 16'b1001100110101010;
    defparam empty_cmp_2.INIT1 = 16'b1001100110101010;
    defparam empty_cmp_2.INJECT1_0 = "NO";
    defparam empty_cmp_2.INJECT1_1 = "NO";
    CCU2C a0 (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(empty_d_c), 
          .S0(empty_d)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(523[11] 525[55])
    defparam a0.INIT0 = 16'b0110011010101010;
    defparam a0.INIT1 = 16'b0110011010101010;
    defparam a0.INJECT1_0 = "NO";
    defparam a0.INJECT1_1 = "NO";
    CCU2C full_cmp_ci_a (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(wren_i), .B1(wren_i), .C1(VCC_net), .D1(VCC_net), .COUT(cmp_ci_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(531[11] 533[47])
    defparam full_cmp_ci_a.INIT0 = 16'b0110011010101010;
    defparam full_cmp_ci_a.INIT1 = 16'b0110011010101010;
    defparam full_cmp_ci_a.INJECT1_0 = "NO";
    defparam full_cmp_ci_a.INJECT1_1 = "NO";
    CCU2C full_cmp_0 (.A0(wcount_0), .B0(rcount_w0), .C0(VCC_net), .D0(VCC_net), 
          .A1(wcount_1), .B1(r_g2b_xor_cluster_0), .C1(VCC_net), .D1(VCC_net), 
          .CIN(cmp_ci_1), .COUT(co0_3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(539[11] 541[52])
    defparam full_cmp_0.INIT0 = 16'b1001100110101010;
    defparam full_cmp_0.INIT1 = 16'b1001100110101010;
    defparam full_cmp_0.INJECT1_0 = "NO";
    defparam full_cmp_0.INJECT1_1 = "NO";
    CCU2C full_cmp_1 (.A0(wcount_2), .B0(rcount_w2), .C0(VCC_net), .D0(VCC_net), 
          .A1(wcount_3), .B1(rcount_w3), .C1(VCC_net), .D1(VCC_net), 
          .CIN(co0_3), .COUT(co1_3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(547[11] 549[49])
    defparam full_cmp_1.INIT0 = 16'b1001100110101010;
    defparam full_cmp_1.INIT1 = 16'b1001100110101010;
    defparam full_cmp_1.INJECT1_0 = "NO";
    defparam full_cmp_1.INJECT1_1 = "NO";
    CCU2C full_cmp_2 (.A0(full_cmp_set), .B0(full_cmp_clr), .C0(VCC_net), 
          .D0(VCC_net), .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), 
          .CIN(co1_3), .COUT(full_d_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(555[11] 557[68])
    defparam full_cmp_2.INIT0 = 16'b1001100110101010;
    defparam full_cmp_2.INIT1 = 16'b1001100110101010;
    defparam full_cmp_2.INJECT1_0 = "NO";
    defparam full_cmp_2.INJECT1_1 = "NO";
    CCU2C a1 (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(full_d_c), 
          .S0(full_d)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(567[11] 569[53])
    defparam a1.INIT0 = 16'b0110011010101010;
    defparam a1.INIT1 = 16'b0110011010101010;
    defparam a1.INJECT1_0 = "NO";
    defparam a1.INJECT1_1 = "NO";
    INV INV_1 (.A(fifo_full), .Z(invout_1)) /* synthesis LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    AND2 AND2_t10 (.A(fifo_wr_en), .B(invout_1), .Z(wren_i)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(129[10:55])
    AND2 AND2_t9 (.A(wifi_ddr_data_valid), .B(invout_0), .Z(rden_i)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(133[10:54])
    INV INV_0 (.A(fifo_empty), .Z(invout_0)) /* synthesis LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    XOR2 XOR2_t7 (.A(wcount_0), .B(wcount_1), .Z(w_gdata_0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(139[10:61])
    XOR2 XOR2_t6 (.A(wcount_1), .B(wcount_2), .Z(w_gdata_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(141[10:61])
    XOR2 XOR2_t5 (.A(wcount_2), .B(wcount_3), .Z(w_gdata_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(143[10:61])
    XOR2 XOR2_t4 (.A(wcount_3), .B(wcount_4), .Z(w_gdata_3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(145[10:61])
    XOR2 XOR2_t3 (.A(rcount_0), .B(rcount_1), .Z(r_gdata_0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(147[10:61])
    XOR2 XOR2_t2 (.A(rcount_1), .B(rcount_2), .Z(r_gdata_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(149[10:61])
    XOR2 XOR2_t1 (.A(rcount_2), .B(rcount_3), .Z(r_gdata_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(151[10:61])
    XOR2 XOR2_t0 (.A(rcount_3), .B(rcount_4), .Z(r_gdata_3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(153[10:61])
    ROM16X1A LUT4_11 (.AD0(w_gcount_r24), .AD1(w_gcount_r23), .AD2(w_gcount_r22), 
            .AD3(w_gcount_r21), .DO0(w_g2b_xor_cluster_0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_11.initval = 16'b0110100110010110;
    ROM16X1A LUT4_10 (.AD0(GND_net), .AD1(GND_net), .AD2(w_gcount_r24), 
            .AD3(w_gcount_r23), .DO0(wcount_r3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_10.initval = 16'b0110100110010110;
    ROM16X1A LUT4_9 (.AD0(GND_net), .AD1(w_gcount_r24), .AD2(w_gcount_r23), 
            .AD3(w_gcount_r22), .DO0(wcount_r2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_9.initval = 16'b0110100110010110;
    ROM16X1A LUT4_8 (.AD0(wcount_r3), .AD1(w_gcount_r22), .AD2(w_gcount_r21), 
            .AD3(w_gcount_r20), .DO0(wcount_r0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_8.initval = 16'b0110100110010110;
    ROM16X1A LUT4_7 (.AD0(r_gcount_w24), .AD1(r_gcount_w23), .AD2(r_gcount_w22), 
            .AD3(r_gcount_w21), .DO0(r_g2b_xor_cluster_0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_7.initval = 16'b0110100110010110;
    ROM16X1A LUT4_6 (.AD0(GND_net), .AD1(GND_net), .AD2(r_gcount_w24), 
            .AD3(r_gcount_w23), .DO0(rcount_w3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_6.initval = 16'b0110100110010110;
    ROM16X1A LUT4_5 (.AD0(GND_net), .AD1(r_gcount_w24), .AD2(r_gcount_w23), 
            .AD3(r_gcount_w22), .DO0(rcount_w2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_5.initval = 16'b0110100110010110;
    ROM16X1A LUT4_4 (.AD0(rcount_w3), .AD1(r_gcount_w22), .AD2(r_gcount_w21), 
            .AD3(r_gcount_w20), .DO0(rcount_w0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_4.initval = 16'b0110100110010110;
    ROM16X1A LUT4_3 (.AD0(GND_net), .AD1(w_gcount_r24), .AD2(rcount_4), 
            .AD3(rptr_4), .DO0(empty_cmp_set)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_3.initval = 16'b0000010000010000;
    ROM16X1A LUT4_2 (.AD0(GND_net), .AD1(w_gcount_r24), .AD2(rcount_4), 
            .AD3(rptr_4), .DO0(empty_cmp_clr)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_2.initval = 16'b0001000000000100;
    ROM16X1A LUT4_1 (.AD0(GND_net), .AD1(r_gcount_w24), .AD2(wcount_4), 
            .AD3(wptr_4), .DO0(full_cmp_set)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_1.initval = 16'b0000000101000000;
    ROM16X1A LUT4_0 (.AD0(GND_net), .AD1(r_gcount_w24), .AD2(wcount_4), 
            .AD3(wptr_4), .DO0(full_cmp_clr)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam LUT4_0.initval = 16'b0100000000000001;
    DP16KD pdp_ram_0_0_0 (.DIA0(fifo_data[0]), .DIA1(fifo_data[1]), .DIA2(GND_net), 
           .DIA3(GND_net), .DIA4(GND_net), .DIA5(GND_net), .DIA6(GND_net), 
           .DIA7(GND_net), .DIA8(GND_net), .DIA9(GND_net), .DIA10(GND_net), 
           .DIA11(GND_net), .DIA12(GND_net), .DIA13(GND_net), .DIA14(GND_net), 
           .DIA15(GND_net), .DIA16(GND_net), .DIA17(GND_net), .ADA0(GND_net), 
           .ADA1(wptr_0), .ADA2(wptr_1), .ADA3(wptr_2), .ADA4(wptr_3), 
           .ADA5(GND_net), .ADA6(GND_net), .ADA7(GND_net), .ADA8(GND_net), 
           .ADA9(GND_net), .ADA10(GND_net), .ADA11(GND_net), .ADA12(GND_net), 
           .ADA13(GND_net), .CEA(wren_i), .OCEA(wren_i), .CLKA(internal_200MHz), 
           .WEA(VCC_net), .CSA0(GND_net), .CSA1(GND_net), .CSA2(GND_net), 
           .RSTA(main_reset_n_N_4), .DIB0(GND_net), .DIB1(GND_net), .DIB2(GND_net), 
           .DIB3(GND_net), .DIB4(GND_net), .DIB5(GND_net), .DIB6(GND_net), 
           .DIB7(GND_net), .DIB8(GND_net), .DIB9(GND_net), .DIB10(GND_net), 
           .DIB11(GND_net), .DIB12(GND_net), .DIB13(GND_net), .DIB14(GND_net), 
           .DIB15(GND_net), .DIB16(GND_net), .DIB17(GND_net), .ADB0(GND_net), 
           .ADB1(rptr_0), .ADB2(rptr_1), .ADB3(rptr_2), .ADB4(rptr_3), 
           .ADB5(GND_net), .ADB6(GND_net), .ADB7(GND_net), .ADB8(GND_net), 
           .ADB9(GND_net), .ADB10(GND_net), .ADB11(GND_net), .ADB12(GND_net), 
           .ADB13(GND_net), .CEB(rden_i), .OCEB(rden_i), .CLKB(internal_80MHz), 
           .WEB(GND_net), .CSB0(GND_net), .CSB1(GND_net), .CSB2(GND_net), 
           .RSTB(main_reset_n_N_4), .DOB0(fifo_out[0]), .DOB1(fifo_out[1])) /* synthesis MEM_LPC_FILE="fifo_dc_2in_2out.lpc", MEM_INIT_FILE="", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/ddr_workaround.v(24[22] 35[6])
    defparam pdp_ram_0_0_0.DATA_WIDTH_A = 2;
    defparam pdp_ram_0_0_0.DATA_WIDTH_B = 2;
    defparam pdp_ram_0_0_0.REGMODE_A = "NOREG";
    defparam pdp_ram_0_0_0.REGMODE_B = "NOREG";
    defparam pdp_ram_0_0_0.RESETMODE = "ASYNC";
    defparam pdp_ram_0_0_0.ASYNC_RESET_RELEASE = "SYNC";
    defparam pdp_ram_0_0_0.WRITEMODE_A = "NORMAL";
    defparam pdp_ram_0_0_0.WRITEMODE_B = "NORMAL";
    defparam pdp_ram_0_0_0.CSDECODE_A = "0b000";
    defparam pdp_ram_0_0_0.CSDECODE_B = "0b000";
    defparam pdp_ram_0_0_0.GSR = "ENABLED";
    defparam pdp_ram_0_0_0.INITVAL_00 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_01 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_02 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_03 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_04 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_05 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_06 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_07 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_08 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_09 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_0A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_0B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_0C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_0D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_0E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_0F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_10 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_11 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_12 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_13 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_14 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_15 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_16 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_17 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_18 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_19 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_1A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_1B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_1C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_1D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_1E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_1F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_20 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_21 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_22 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_23 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_24 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_25 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_26 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_27 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_28 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_29 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_2A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_2B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_2C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_2D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_2E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_2F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_30 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_31 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_32 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_33 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_34 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_35 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_36 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_37 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_38 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_39 = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_3A = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_3B = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_3C = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_3D = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_3E = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INITVAL_3F = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000";
    defparam pdp_ram_0_0_0.INIT_DATA = "STATIC";
    FD1P3AX FF_50 (.D(iwcount_1), .SP(wren_i), .CK(internal_200MHz), .Q(wcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=13, LSE_LCOL=22, LSE_RCOL=6, LSE_LLINE=24, LSE_RLINE=35 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_2in_2out/fifo_dc_2in_2out.v(247[13] 248[22])
    defparam FF_50.GSR = "ENABLED";
    
endmodule
//
// Verilog Description of module spi_generator_U2
//

module spi_generator_U2 (fpga_ufl_p7_c, n3031, internal_160MHz, internal_160MHz_enable_83, 
            \shift_reg_15__N_168[0] , n2938, fpga_ufl_p8_c, spi_busy, 
            n1220, \shift_reg[1] , \shift_reg_15__N_168[1] , n2681, 
            \shift_reg[2] , \shift_reg_15__N_168[2] , \shift_reg[3] , 
            \shift_reg_15__N_168[3] , \shift_reg[4] , \shift_reg_15__N_168[4] , 
            \shift_reg[5] , \shift_reg_15__N_168[5] , \shift_reg[6] , 
            \shift_reg_15__N_168[6] , \shift_reg[7] , \shift_reg_15__N_168[7] , 
            \shift_reg[8] , \shift_reg_15__N_168[8] , \shift_reg[9] , 
            \shift_reg_15__N_168[9] , \shift_reg[10] , \shift_reg_15__N_168[10] , 
            \shift_reg[11] , \shift_reg_15__N_168[11] , \shift_reg[12] , 
            \shift_reg_15__N_168[12] , \shift_reg[13] , \shift_reg_15__N_168[13] , 
            \shift_reg[14] , \shift_reg_15__N_168[14] , \shift_reg[15] , 
            \w_rx_09_fifo_data[15] ) /* synthesis syn_module_defined=1 */ ;
    output fpga_ufl_p7_c;
    output n3031;
    input internal_160MHz;
    input internal_160MHz_enable_83;
    input \shift_reg_15__N_168[0] ;
    input n2938;
    output fpga_ufl_p8_c;
    output spi_busy;
    input n1220;
    output \shift_reg[1] ;
    input \shift_reg_15__N_168[1] ;
    output n2681;
    output \shift_reg[2] ;
    input \shift_reg_15__N_168[2] ;
    output \shift_reg[3] ;
    input \shift_reg_15__N_168[3] ;
    output \shift_reg[4] ;
    input \shift_reg_15__N_168[4] ;
    output \shift_reg[5] ;
    input \shift_reg_15__N_168[5] ;
    output \shift_reg[6] ;
    input \shift_reg_15__N_168[6] ;
    output \shift_reg[7] ;
    input \shift_reg_15__N_168[7] ;
    output \shift_reg[8] ;
    input \shift_reg_15__N_168[8] ;
    output \shift_reg[9] ;
    input \shift_reg_15__N_168[9] ;
    output \shift_reg[10] ;
    input \shift_reg_15__N_168[10] ;
    output \shift_reg[11] ;
    input \shift_reg_15__N_168[11] ;
    output \shift_reg[12] ;
    input \shift_reg_15__N_168[12] ;
    output \shift_reg[13] ;
    input \shift_reg_15__N_168[13] ;
    output \shift_reg[14] ;
    input \shift_reg_15__N_168[14] ;
    output \shift_reg[15] ;
    input \w_rx_09_fifo_data[15] ;
    
    wire internal_160MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_160MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(63[6:21])
    
    wire spi_clk_enable;
    wire [15:0]shift_reg;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(176[26:35])
    wire [4:0]bit_count;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(177[32:41])
    wire [4:0]bit_count_4__N_218;
    
    wire n1900, internal_160MHz_enable_43, n1923, spi_clk_N_224, n2641, 
        n8, n1332, n2933, n1322, n1326;
    wire [4:0]bit_count_4__N_184;
    
    LUT4 spi_clk_I_0_49_2_lut_rep_66 (.A(fpga_ufl_p7_c), .B(spi_clk_enable), 
         .Z(n3031)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(214[26:51])
    defparam spi_clk_I_0_49_2_lut_rep_66.init = 16'h8888;
    FD1P3AX shift_reg_i0 (.D(\shift_reg_15__N_168[0] ), .SP(internal_160MHz_enable_83), 
            .CK(internal_160MHz), .Q(shift_reg[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i0.GSR = "ENABLED";
    FD1S3IX bit_count_i0 (.D(bit_count_4__N_218[0]), .CK(internal_160MHz), 
            .CD(n2938), .Q(bit_count[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i0.GSR = "ENABLED";
    FD1S3AX spi_clk_enable_41 (.D(n1900), .CK(internal_160MHz), .Q(spi_clk_enable)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam spi_clk_enable_41.GSR = "ENABLED";
    FD1P3AX spi_mosi_38 (.D(shift_reg[0]), .SP(internal_160MHz_enable_43), 
            .CK(internal_160MHz), .Q(fpga_ufl_p8_c)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam spi_mosi_38.GSR = "ENABLED";
    FD1S3AX spi_busy_42 (.D(n1220), .CK(internal_160MHz), .Q(spi_busy)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam spi_busy_42.GSR = "ENABLED";
    LUT4 i1400_1_lut (.A(spi_clk_enable), .Z(n1923)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam i1400_1_lut.init = 16'h5555;
    LUT4 i631_1_lut (.A(fpga_ufl_p7_c), .Z(spi_clk_N_224)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(189[13] 192[16])
    defparam i631_1_lut.init = 16'h5555;
    FD1S3IX spi_clk_36 (.D(spi_clk_N_224), .CK(internal_160MHz), .CD(n1923), 
            .Q(fpga_ufl_p7_c)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(186[18] 196[12])
    defparam spi_clk_36.GSR = "ENABLED";
    LUT4 spi_busy_I_3_2_lut_rep_43_3_lut (.A(fpga_ufl_p7_c), .B(spi_clk_enable), 
         .C(spi_busy), .Z(internal_160MHz_enable_43)) /* synthesis lut_function=(A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(214[26:51])
    defparam spi_busy_I_3_2_lut_rep_43_3_lut.init = 16'h8080;
    LUT4 i705_2_lut_3_lut_4_lut (.A(fpga_ufl_p7_c), .B(spi_clk_enable), 
         .C(bit_count[0]), .D(spi_busy), .Z(bit_count_4__N_218[0])) /* synthesis lut_function=(!(A (B (C (D)+!C !(D))+!B !(C))+!A !(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(214[26:51])
    defparam i705_2_lut_3_lut_4_lut.init = 16'h78f0;
    LUT4 i1379_4_lut (.A(n2641), .B(n2938), .C(spi_clk_enable), .D(internal_160MHz_enable_43), 
         .Z(n1900)) /* synthesis lut_function=(A (B+!((D)+!C))+!A (B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam i1379_4_lut.init = 16'hdcfc;
    LUT4 i1_3_lut (.A(n8), .B(bit_count[3]), .C(bit_count[0]), .Z(n2641)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;
    defparam i1_3_lut.init = 16'h1010;
    LUT4 i1_3_lut_adj_10 (.A(bit_count[1]), .B(bit_count[2]), .C(bit_count[4]), 
         .Z(n8)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(220[21:35])
    defparam i1_3_lut_adj_10.init = 16'hfefe;
    LUT4 i1_2_lut_3_lut (.A(bit_count[1]), .B(bit_count[0]), .C(bit_count[2]), 
         .Z(n1332)) /* synthesis lut_function=(A (C)+!A (B (C)+!B !(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(218[30:43])
    defparam i1_2_lut_3_lut.init = 16'he1e1;
    LUT4 i463_2_lut_rep_39_3_lut (.A(bit_count[1]), .B(bit_count[0]), .C(bit_count[2]), 
         .Z(n2933)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(218[30:43])
    defparam i463_2_lut_rep_39_3_lut.init = 16'hfefe;
    FD1P3AX shift_reg_i1 (.D(\shift_reg_15__N_168[1] ), .SP(internal_160MHz_enable_83), 
            .CK(internal_160MHz), .Q(\shift_reg[1] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i1.GSR = "ENABLED";
    LUT4 i1_3_lut_adj_11 (.A(bit_count[0]), .B(n8), .C(bit_count[3]), 
         .Z(n2681)) /* synthesis lut_function=((B+(C))+!A) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(220[21:35])
    defparam i1_3_lut_adj_11.init = 16'hfdfd;
    LUT4 i1_2_lut_3_lut_4_lut (.A(bit_count[1]), .B(bit_count[0]), .C(bit_count[3]), 
         .D(bit_count[2]), .Z(n1322)) /* synthesis lut_function=(A (C)+!A (B (C)+!B (C (D)+!C !(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(218[30:43])
    defparam i1_2_lut_3_lut_4_lut.init = 16'hf0e1;
    LUT4 i1_2_lut (.A(bit_count[1]), .B(bit_count[0]), .Z(n1326)) /* synthesis lut_function=(A (B)+!A !(B)) */ ;
    defparam i1_2_lut.init = 16'h9999;
    FD1P3AX shift_reg_i2 (.D(\shift_reg_15__N_168[2] ), .SP(internal_160MHz_enable_83), 
            .CK(internal_160MHz), .Q(\shift_reg[2] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i2.GSR = "ENABLED";
    FD1P3AX shift_reg_i3 (.D(\shift_reg_15__N_168[3] ), .SP(internal_160MHz_enable_83), 
            .CK(internal_160MHz), .Q(\shift_reg[3] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i3.GSR = "ENABLED";
    FD1P3AX shift_reg_i4 (.D(\shift_reg_15__N_168[4] ), .SP(internal_160MHz_enable_83), 
            .CK(internal_160MHz), .Q(\shift_reg[4] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i4.GSR = "ENABLED";
    FD1P3AX shift_reg_i5 (.D(\shift_reg_15__N_168[5] ), .SP(internal_160MHz_enable_83), 
            .CK(internal_160MHz), .Q(\shift_reg[5] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i5.GSR = "ENABLED";
    FD1P3AX shift_reg_i6 (.D(\shift_reg_15__N_168[6] ), .SP(internal_160MHz_enable_83), 
            .CK(internal_160MHz), .Q(\shift_reg[6] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i6.GSR = "ENABLED";
    FD1P3AX shift_reg_i7 (.D(\shift_reg_15__N_168[7] ), .SP(internal_160MHz_enable_83), 
            .CK(internal_160MHz), .Q(\shift_reg[7] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i7.GSR = "ENABLED";
    FD1P3AX shift_reg_i8 (.D(\shift_reg_15__N_168[8] ), .SP(internal_160MHz_enable_83), 
            .CK(internal_160MHz), .Q(\shift_reg[8] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i8.GSR = "ENABLED";
    FD1P3AX shift_reg_i9 (.D(\shift_reg_15__N_168[9] ), .SP(internal_160MHz_enable_83), 
            .CK(internal_160MHz), .Q(\shift_reg[9] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i9.GSR = "ENABLED";
    FD1P3AX shift_reg_i10 (.D(\shift_reg_15__N_168[10] ), .SP(internal_160MHz_enable_83), 
            .CK(internal_160MHz), .Q(\shift_reg[10] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i10.GSR = "ENABLED";
    FD1P3AX shift_reg_i11 (.D(\shift_reg_15__N_168[11] ), .SP(internal_160MHz_enable_83), 
            .CK(internal_160MHz), .Q(\shift_reg[11] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i11.GSR = "ENABLED";
    FD1P3AX shift_reg_i12 (.D(\shift_reg_15__N_168[12] ), .SP(internal_160MHz_enable_83), 
            .CK(internal_160MHz), .Q(\shift_reg[12] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i12.GSR = "ENABLED";
    FD1P3AX shift_reg_i13 (.D(\shift_reg_15__N_168[13] ), .SP(internal_160MHz_enable_83), 
            .CK(internal_160MHz), .Q(\shift_reg[13] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i13.GSR = "ENABLED";
    FD1P3AX shift_reg_i14 (.D(\shift_reg_15__N_168[14] ), .SP(internal_160MHz_enable_83), 
            .CK(internal_160MHz), .Q(\shift_reg[14] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i14.GSR = "ENABLED";
    FD1P3IX bit_count_i1 (.D(n1326), .SP(internal_160MHz_enable_43), .CD(n2938), 
            .CK(internal_160MHz), .Q(bit_count[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i1.GSR = "ENABLED";
    FD1P3IX bit_count_i2 (.D(n1332), .SP(internal_160MHz_enable_43), .CD(n2938), 
            .CK(internal_160MHz), .Q(bit_count[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i2.GSR = "ENABLED";
    FD1P3IX bit_count_i3 (.D(n1322), .SP(internal_160MHz_enable_43), .CD(n2938), 
            .CK(internal_160MHz), .Q(bit_count[3])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i3.GSR = "ENABLED";
    FD1P3AX bit_count_i4 (.D(bit_count_4__N_184[4]), .SP(internal_160MHz_enable_83), 
            .CK(internal_160MHz), .Q(bit_count[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i4.GSR = "ENABLED";
    LUT4 i1697_4_lut (.A(bit_count[4]), .B(n2938), .C(bit_count[3]), .D(n2933), 
         .Z(bit_count_4__N_184[4])) /* synthesis lut_function=(A (B+(C+(D)))+!A (B+!(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(214[22] 225[16])
    defparam i1697_4_lut.init = 16'heeed;
    FD1P3IX shift_reg_i15 (.D(\w_rx_09_fifo_data[15] ), .SP(internal_160MHz_enable_83), 
            .CD(internal_160MHz_enable_43), .CK(internal_160MHz), .Q(\shift_reg[15] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=519, LSE_RLINE=529 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i15.GSR = "ENABLED";
    
endmodule
//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

//
// Verilog Description of module lvds_rx_U5
//

module lvds_rx_U5 (w_rx_09_fifo_data, internal_80MHz, n326, r_phase_count, 
            subg_ddr_data_valid, n2960, o_debug_state, n2872, data_out, 
            n2949, w_rx_09_fifo_push, \r_phase_count_2__N_123[2] , \r_phase_count_2__N_123[1] , 
            n2920, n2873, n2919, n2627, n1766) /* synthesis syn_module_defined=1 */ ;
    output [31:0]w_rx_09_fifo_data;
    input internal_80MHz;
    input [31:0]n326;
    output [2:0]r_phase_count;
    input subg_ddr_data_valid;
    input n2960;
    output [1:0]o_debug_state;
    output n2872;
    input [1:0]data_out;
    output n2949;
    output w_rx_09_fifo_push;
    input \r_phase_count_2__N_123[2] ;
    input \r_phase_count_2__N_123[1] ;
    output n2920;
    output n2873;
    output n2919;
    input n2627;
    input n1766;
    
    wire internal_80MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_80MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(64[6:20])
    
    wire internal_80MHz_enable_68, n2942, n1924, n1, internal_80MHz_enable_30, 
        o_fifo_push_N_159, n2749, n2929, n2765;
    wire [1:0]o_debug_state_1__N_121;
    
    wire internal_80MHz_enable_57, n2945, n2496, n2677;
    
    FD1P3AX o_fifo_data_i0_i10 (.D(n326[10]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[10])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i10.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i11 (.D(n326[11]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[11])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i11.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i0 (.D(n326[0]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i0.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i12 (.D(n326[12]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[12])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i12.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i13 (.D(n326[13]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[13])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i13.GSR = "DISABLED";
    FD1P3AY r_phase_count_i0_i0 (.D(n2960), .SP(subg_ddr_data_valid), .CK(internal_80MHz), 
            .Q(r_phase_count[0])) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam r_phase_count_i0_i0.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i0_i14 (.D(n326[14]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[14])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i14.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i15 (.D(n326[15]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[15])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i15.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i16 (.D(n326[16]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[16])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i16.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i17 (.D(n326[17]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[17])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i17.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i18 (.D(n326[18]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[18])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i18.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i19 (.D(n326[19]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[19])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i19.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i20 (.D(n326[20]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[20])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i20.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i21 (.D(n326[21]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[21])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i21.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i22 (.D(n326[22]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[22])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i22.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i23 (.D(n326[23]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[23])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i23.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i24 (.D(n326[24]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[24])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i24.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i25 (.D(n326[25]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[25])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i25.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i26 (.D(n326[26]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[26])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i26.GSR = "DISABLED";
    LUT4 n1328_bdd_3_lut_2277_4_lut (.A(r_phase_count[2]), .B(n2942), .C(o_debug_state[0]), 
         .D(o_debug_state[1]), .Z(n2872)) /* synthesis lut_function=(!(A (B (C (D))+!B (C+(D)))+!A (B (C+(D))+!B (C (D))))) */ ;
    defparam n1328_bdd_3_lut_2277_4_lut.init = 16'h099f;
    FD1P3AX o_fifo_data_i0_i27 (.D(n326[27]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[27])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i27.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i28 (.D(n326[28]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[28])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i28.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i29 (.D(n326[29]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[29])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i29.GSR = "DISABLED";
    LUT4 i1401_2_lut (.A(subg_ddr_data_valid), .B(o_debug_state[1]), .Z(n1924)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam i1401_2_lut.init = 16'h8888;
    LUT4 mux_24_Mux_0_i1_4_lut (.A(data_out[0]), .B(n2949), .C(o_debug_state[0]), 
         .D(data_out[1]), .Z(n1)) /* synthesis lut_function=(A (B (C))+!A (B (C+(D))+!B !(C+!(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam mux_24_Mux_0_i1_4_lut.init = 16'hc5c0;
    FD1P3AX o_fifo_data_i0_i30 (.D(n326[30]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[30])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i30.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i31 (.D(n326[31]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[31])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i31.GSR = "DISABLED";
    FD1P3AX o_fifo_push_41 (.D(o_fifo_push_N_159), .SP(internal_80MHz_enable_30), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_push)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_push_41.GSR = "ENABLED";
    LUT4 mux_24_Mux_1_i3_4_lut (.A(n2749), .B(n2929), .C(o_debug_state[1]), 
         .D(n2765), .Z(o_debug_state_1__N_121[1])) /* synthesis lut_function=(A (B (C+!(D))+!B !(C+(D)))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(53[13] 90[20])
    defparam mux_24_Mux_1_i3_4_lut.init = 16'hc0ca;
    LUT4 i1_4_lut (.A(r_phase_count[2]), .B(r_phase_count[0]), .C(o_debug_state[0]), 
         .D(data_out[0]), .Z(n2749)) /* synthesis lut_function=(!(A+(B+!(C (D))))) */ ;
    defparam i1_4_lut.init = 16'h1000;
    LUT4 i2199_2_lut (.A(r_phase_count[1]), .B(data_out[1]), .Z(n2765)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i2199_2_lut.init = 16'heeee;
    FD1P3AY r_phase_count_i0_i2 (.D(\r_phase_count_2__N_123[2] ), .SP(internal_80MHz_enable_57), 
            .CK(internal_80MHz), .Q(r_phase_count[2])) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam r_phase_count_i0_i2.GSR = "ENABLED";
    FD1P3IX r_state_if_i0_i0 (.D(n1), .SP(subg_ddr_data_valid), .CD(n1924), 
            .CK(internal_80MHz), .Q(o_debug_state[0])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam r_state_if_i0_i0.GSR = "ENABLED";
    FD1P3AY r_phase_count_i0_i1 (.D(\r_phase_count_2__N_123[1] ), .SP(internal_80MHz_enable_57), 
            .CK(internal_80MHz), .Q(r_phase_count[1])) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam r_phase_count_i0_i1.GSR = "ENABLED";
    FD1P3AX r_state_if_i0_i1 (.D(o_debug_state_1__N_121[1]), .SP(subg_ddr_data_valid), 
            .CK(internal_80MHz), .Q(o_debug_state[1])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam r_state_if_i0_i1.GSR = "ENABLED";
    LUT4 i591_2_lut_rep_48 (.A(r_phase_count[1]), .B(r_phase_count[0]), 
         .Z(n2942)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(86[42:59])
    defparam i591_2_lut_rep_48.init = 16'heeee;
    LUT4 equal_347_i6_2_lut_rep_51 (.A(data_out[0]), .B(data_out[1]), .Z(n2945)) /* synthesis lut_function=((B)+!A) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(80[25:48])
    defparam equal_347_i6_2_lut_rep_51.init = 16'hdddd;
    LUT4 n6_bdd_3_lut_4_lut (.A(data_out[0]), .B(data_out[1]), .C(o_debug_state[0]), 
         .D(o_debug_state[1]), .Z(n2920)) /* synthesis lut_function=(!(A (B (C+(D))+!B (D))+!A (C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(80[25:48])
    defparam n6_bdd_3_lut_4_lut.init = 16'h002f;
    LUT4 n1328_bdd_3_lut_4_lut (.A(data_out[0]), .B(data_out[1]), .C(o_debug_state[0]), 
         .D(o_debug_state[1]), .Z(n2873)) /* synthesis lut_function=(!(A (B (C+(D))+!B (D))+!A (C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(80[25:48])
    defparam n1328_bdd_3_lut_4_lut.init = 16'h002f;
    LUT4 n6_bdd_3_lut_2293_4_lut (.A(r_phase_count[1]), .B(r_phase_count[0]), 
         .C(o_debug_state[0]), .D(o_debug_state[1]), .Z(n2919)) /* synthesis lut_function=(!(A (B (C (D))+!B (C+(D)))+!A (B (C+(D))+!B (C (D))))) */ ;
    defparam n6_bdd_3_lut_2293_4_lut.init = 16'h099f;
    LUT4 i1_3_lut_rep_55 (.A(r_phase_count[0]), .B(r_phase_count[1]), .C(r_phase_count[2]), 
         .Z(n2949)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(80[25:48])
    defparam i1_3_lut_rep_55.init = 16'hfefe;
    LUT4 i1_3_lut (.A(o_debug_state[0]), .B(subg_ddr_data_valid), .C(o_debug_state[1]), 
         .Z(internal_80MHz_enable_30)) /* synthesis lut_function=(!(A ((C)+!B)+!A !(B))) */ ;
    defparam i1_3_lut.init = 16'h4c4c;
    LUT4 i3_4_lut (.A(r_phase_count[0]), .B(r_phase_count[1]), .C(o_debug_state[1]), 
         .D(r_phase_count[2]), .Z(o_fifo_push_N_159)) /* synthesis lut_function=(!(A+(B+((D)+!C)))) */ ;
    defparam i3_4_lut.init = 16'h0010;
    LUT4 i764_2_lut_rep_35_4_lut (.A(r_phase_count[0]), .B(r_phase_count[1]), 
         .C(r_phase_count[2]), .D(o_debug_state[0]), .Z(n2929)) /* synthesis lut_function=(!(A (D)+!A (B (D)+!B ((D)+!C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(80[25:48])
    defparam i764_2_lut_rep_35_4_lut.init = 16'h00fe;
    FD1P3AX o_fifo_data_i0_i1 (.D(n326[1]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i1.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i2 (.D(n326[2]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i2.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i3 (.D(n326[3]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[3])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i3.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i4 (.D(n326[4]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i4.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i5 (.D(n326[5]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[5])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i5.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i6 (.D(n326[6]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[6])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i6.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i7 (.D(n326[7]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[7])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i7.GSR = "DISABLED";
    LUT4 i1_4_lut_adj_8 (.A(n2627), .B(n2496), .C(o_debug_state[0]), .D(o_debug_state[1]), 
         .Z(internal_80MHz_enable_68)) /* synthesis lut_function=(!((B (C (D)+!C !(D))+!B (C (D)))+!A)) */ ;
    defparam i1_4_lut_adj_8.init = 16'h0aa2;
    LUT4 i2241_4_lut (.A(n2677), .B(n1766), .C(subg_ddr_data_valid), .D(n2945), 
         .Z(internal_80MHz_enable_57)) /* synthesis lut_function=(!(A (B+((D)+!C))+!A (B+!(C)))) */ ;
    defparam i2241_4_lut.init = 16'h1030;
    LUT4 i1_4_lut_adj_9 (.A(r_phase_count[2]), .B(n2942), .C(o_debug_state[1]), 
         .D(o_debug_state[0]), .Z(n2677)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam i1_4_lut_adj_9.init = 16'h0100;
    LUT4 i1947_2_lut (.A(data_out[1]), .B(data_out[0]), .Z(n2496)) /* synthesis lut_function=((B)+!A) */ ;
    defparam i1947_2_lut.init = 16'hdddd;
    FD1P3AX o_fifo_data_i0_i8 (.D(n326[8]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[8])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i8.GSR = "DISABLED";
    FD1P3AX o_fifo_data_i0_i9 (.D(n326[9]), .SP(internal_80MHz_enable_68), 
            .CK(internal_80MHz), .Q(w_rx_09_fifo_data[9])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=9, LSE_RCOL=2, LSE_LLINE=253, LSE_RLINE=265 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/lvds_rx.v(52[18] 91[12])
    defparam o_fifo_data_i0_i9.GSR = "DISABLED";
    
endmodule
//
// Verilog Description of module spi_generator_U1
//

module spi_generator_U1 (spi_busy, internal_160MHz, n1251, spi3_sck_c, 
            n3032, spi3_mosi_c, internal_160MHz_enable_82, \shift_reg_15__N_168[0] , 
            n2931, \shift_reg[1] , \shift_reg_15__N_168[1] , \shift_reg[2] , 
            \shift_reg_15__N_168[2] , \shift_reg[3] , \shift_reg_15__N_168[3] , 
            \shift_reg[4] , \shift_reg_15__N_168[4] , \shift_reg[5] , 
            \shift_reg_15__N_168[5] , \shift_reg[6] , \shift_reg_15__N_168[6] , 
            \shift_reg[7] , \shift_reg_15__N_168[7] , \shift_reg[8] , 
            \shift_reg_15__N_168[8] , \shift_reg[9] , \shift_reg_15__N_168[9] , 
            \shift_reg[10] , \shift_reg_15__N_168[10] , \shift_reg[11] , 
            \shift_reg_15__N_168[11] , \shift_reg[12] , \shift_reg_15__N_168[12] , 
            \shift_reg[13] , \shift_reg_15__N_168[13] , \shift_reg[14] , 
            \shift_reg_15__N_168[14] , \shift_reg[15] , \w_rx_24_fifo_data[29] , 
            n2685) /* synthesis syn_module_defined=1 */ ;
    output spi_busy;
    input internal_160MHz;
    input n1251;
    output spi3_sck_c;
    output n3032;
    output spi3_mosi_c;
    input internal_160MHz_enable_82;
    input \shift_reg_15__N_168[0] ;
    input n2931;
    output \shift_reg[1] ;
    input \shift_reg_15__N_168[1] ;
    output \shift_reg[2] ;
    input \shift_reg_15__N_168[2] ;
    output \shift_reg[3] ;
    input \shift_reg_15__N_168[3] ;
    output \shift_reg[4] ;
    input \shift_reg_15__N_168[4] ;
    output \shift_reg[5] ;
    input \shift_reg_15__N_168[5] ;
    output \shift_reg[6] ;
    input \shift_reg_15__N_168[6] ;
    output \shift_reg[7] ;
    input \shift_reg_15__N_168[7] ;
    output \shift_reg[8] ;
    input \shift_reg_15__N_168[8] ;
    output \shift_reg[9] ;
    input \shift_reg_15__N_168[9] ;
    output \shift_reg[10] ;
    input \shift_reg_15__N_168[10] ;
    output \shift_reg[11] ;
    input \shift_reg_15__N_168[11] ;
    output \shift_reg[12] ;
    input \shift_reg_15__N_168[12] ;
    output \shift_reg[13] ;
    input \shift_reg_15__N_168[13] ;
    output \shift_reg[14] ;
    input \shift_reg_15__N_168[14] ;
    output \shift_reg[15] ;
    input \w_rx_24_fifo_data[29] ;
    output n2685;
    
    wire internal_160MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_160MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(63[6:21])
    
    wire spi_clk_enable, internal_160MHz_enable_61;
    wire [15:0]shift_reg;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(176[26:35])
    wire [4:0]bit_count;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(177[32:41])
    wire [4:0]bit_count_4__N_218;
    
    wire n1922, n1928, spi_clk_N_224, n1316, n2930, n1324, n2649, 
        n8, n1312;
    wire [4:0]bit_count_4__N_184;
    
    FD1S3AX spi_busy_42 (.D(n1251), .CK(internal_160MHz), .Q(spi_busy)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam spi_busy_42.GSR = "ENABLED";
    LUT4 spi_clk_I_0_49_2_lut_rep_67 (.A(spi3_sck_c), .B(spi_clk_enable), 
         .Z(n3032)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(214[26:51])
    defparam spi_clk_I_0_49_2_lut_rep_67.init = 16'h8888;
    FD1P3AX spi_mosi_38 (.D(shift_reg[0]), .SP(internal_160MHz_enable_61), 
            .CK(internal_160MHz), .Q(spi3_mosi_c)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam spi_mosi_38.GSR = "ENABLED";
    FD1P3AX shift_reg_i0 (.D(\shift_reg_15__N_168[0] ), .SP(internal_160MHz_enable_82), 
            .CK(internal_160MHz), .Q(shift_reg[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i0.GSR = "ENABLED";
    FD1S3IX bit_count_i0 (.D(bit_count_4__N_218[0]), .CK(internal_160MHz), 
            .CD(n2931), .Q(bit_count[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i0.GSR = "ENABLED";
    FD1S3AX spi_clk_enable_41 (.D(n1922), .CK(internal_160MHz), .Q(spi_clk_enable)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam spi_clk_enable_41.GSR = "ENABLED";
    LUT4 i1405_1_lut (.A(spi_clk_enable), .Z(n1928)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam i1405_1_lut.init = 16'h5555;
    FD1S3IX spi_clk_36 (.D(spi_clk_N_224), .CK(internal_160MHz), .CD(n1928), 
            .Q(spi3_sck_c)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(186[18] 196[12])
    defparam spi_clk_36.GSR = "ENABLED";
    LUT4 i706_2_lut_3_lut_4_lut (.A(spi3_sck_c), .B(spi_clk_enable), .C(bit_count[0]), 
         .D(spi_busy), .Z(bit_count_4__N_218[0])) /* synthesis lut_function=(!(A (B (C (D)+!C !(D))+!B !(C))+!A !(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(214[26:51])
    defparam i706_2_lut_3_lut_4_lut.init = 16'h78f0;
    LUT4 spi_busy_I_3_2_lut_rep_45_3_lut (.A(spi3_sck_c), .B(spi_clk_enable), 
         .C(spi_busy), .Z(internal_160MHz_enable_61)) /* synthesis lut_function=(A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(214[26:51])
    defparam spi_busy_I_3_2_lut_rep_45_3_lut.init = 16'h8080;
    LUT4 i1_2_lut_3_lut (.A(bit_count[1]), .B(bit_count[0]), .C(bit_count[2]), 
         .Z(n1316)) /* synthesis lut_function=(A (C)+!A (B (C)+!B !(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(218[30:43])
    defparam i1_2_lut_3_lut.init = 16'he1e1;
    LUT4 i423_2_lut_rep_36_3_lut (.A(bit_count[1]), .B(bit_count[0]), .C(bit_count[2]), 
         .Z(n2930)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(218[30:43])
    defparam i423_2_lut_rep_36_3_lut.init = 16'hfefe;
    LUT4 i1_2_lut_3_lut_4_lut (.A(bit_count[1]), .B(bit_count[0]), .C(bit_count[3]), 
         .D(bit_count[2]), .Z(n1324)) /* synthesis lut_function=(A (C)+!A (B (C)+!B (C (D)+!C !(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(218[30:43])
    defparam i1_2_lut_3_lut_4_lut.init = 16'hf0e1;
    LUT4 i1399_4_lut (.A(n2649), .B(n2931), .C(spi_clk_enable), .D(internal_160MHz_enable_61), 
         .Z(n1922)) /* synthesis lut_function=(A (B+!((D)+!C))+!A (B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam i1399_4_lut.init = 16'hdcfc;
    LUT4 i1_3_lut (.A(n8), .B(bit_count[3]), .C(bit_count[0]), .Z(n2649)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;
    defparam i1_3_lut.init = 16'h1010;
    FD1P3AX shift_reg_i1 (.D(\shift_reg_15__N_168[1] ), .SP(internal_160MHz_enable_82), 
            .CK(internal_160MHz), .Q(\shift_reg[1] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i1.GSR = "ENABLED";
    FD1P3AX shift_reg_i2 (.D(\shift_reg_15__N_168[2] ), .SP(internal_160MHz_enable_82), 
            .CK(internal_160MHz), .Q(\shift_reg[2] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i2.GSR = "ENABLED";
    FD1P3AX shift_reg_i3 (.D(\shift_reg_15__N_168[3] ), .SP(internal_160MHz_enable_82), 
            .CK(internal_160MHz), .Q(\shift_reg[3] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i3.GSR = "ENABLED";
    FD1P3AX shift_reg_i4 (.D(\shift_reg_15__N_168[4] ), .SP(internal_160MHz_enable_82), 
            .CK(internal_160MHz), .Q(\shift_reg[4] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i4.GSR = "ENABLED";
    FD1P3AX shift_reg_i5 (.D(\shift_reg_15__N_168[5] ), .SP(internal_160MHz_enable_82), 
            .CK(internal_160MHz), .Q(\shift_reg[5] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i5.GSR = "ENABLED";
    FD1P3AX shift_reg_i6 (.D(\shift_reg_15__N_168[6] ), .SP(internal_160MHz_enable_82), 
            .CK(internal_160MHz), .Q(\shift_reg[6] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i6.GSR = "ENABLED";
    FD1P3AX shift_reg_i7 (.D(\shift_reg_15__N_168[7] ), .SP(internal_160MHz_enable_82), 
            .CK(internal_160MHz), .Q(\shift_reg[7] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i7.GSR = "ENABLED";
    FD1P3AX shift_reg_i8 (.D(\shift_reg_15__N_168[8] ), .SP(internal_160MHz_enable_82), 
            .CK(internal_160MHz), .Q(\shift_reg[8] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i8.GSR = "ENABLED";
    FD1P3AX shift_reg_i9 (.D(\shift_reg_15__N_168[9] ), .SP(internal_160MHz_enable_82), 
            .CK(internal_160MHz), .Q(\shift_reg[9] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i9.GSR = "ENABLED";
    FD1P3AX shift_reg_i10 (.D(\shift_reg_15__N_168[10] ), .SP(internal_160MHz_enable_82), 
            .CK(internal_160MHz), .Q(\shift_reg[10] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i10.GSR = "ENABLED";
    FD1P3AX shift_reg_i11 (.D(\shift_reg_15__N_168[11] ), .SP(internal_160MHz_enable_82), 
            .CK(internal_160MHz), .Q(\shift_reg[11] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i11.GSR = "ENABLED";
    FD1P3AX shift_reg_i12 (.D(\shift_reg_15__N_168[12] ), .SP(internal_160MHz_enable_82), 
            .CK(internal_160MHz), .Q(\shift_reg[12] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i12.GSR = "ENABLED";
    FD1P3AX shift_reg_i13 (.D(\shift_reg_15__N_168[13] ), .SP(internal_160MHz_enable_82), 
            .CK(internal_160MHz), .Q(\shift_reg[13] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i13.GSR = "ENABLED";
    FD1P3AX shift_reg_i14 (.D(\shift_reg_15__N_168[14] ), .SP(internal_160MHz_enable_82), 
            .CK(internal_160MHz), .Q(\shift_reg[14] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i14.GSR = "ENABLED";
    FD1P3IX bit_count_i1 (.D(n1312), .SP(internal_160MHz_enable_61), .CD(n2931), 
            .CK(internal_160MHz), .Q(bit_count[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i1.GSR = "ENABLED";
    FD1P3IX bit_count_i2 (.D(n1316), .SP(internal_160MHz_enable_61), .CD(n2931), 
            .CK(internal_160MHz), .Q(bit_count[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i2.GSR = "ENABLED";
    FD1P3IX bit_count_i3 (.D(n1324), .SP(internal_160MHz_enable_61), .CD(n2931), 
            .CK(internal_160MHz), .Q(bit_count[3])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i3.GSR = "ENABLED";
    FD1P3AX bit_count_i4 (.D(bit_count_4__N_184[4]), .SP(internal_160MHz_enable_82), 
            .CK(internal_160MHz), .Q(bit_count[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam bit_count_i4.GSR = "ENABLED";
    FD1P3IX shift_reg_i15 (.D(\w_rx_24_fifo_data[29] ), .SP(internal_160MHz_enable_82), 
            .CD(internal_160MHz_enable_61), .CK(internal_160MHz), .Q(\shift_reg[15] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=15, LSE_RCOL=2, LSE_LLINE=531, LSE_RLINE=539 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(207[18] 226[12])
    defparam shift_reg_i15.GSR = "ENABLED";
    LUT4 i1_2_lut (.A(bit_count[1]), .B(bit_count[0]), .Z(n1312)) /* synthesis lut_function=(A (B)+!A !(B)) */ ;
    defparam i1_2_lut.init = 16'h9999;
    LUT4 i1_3_lut_adj_6 (.A(bit_count[0]), .B(n8), .C(bit_count[3]), .Z(n2685)) /* synthesis lut_function=((B+(C))+!A) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(220[21:35])
    defparam i1_3_lut_adj_6.init = 16'hfdfd;
    LUT4 i1715_4_lut (.A(bit_count[4]), .B(n2931), .C(bit_count[3]), .D(n2930), 
         .Z(bit_count_4__N_184[4])) /* synthesis lut_function=(A (B+(C+(D)))+!A (B+!(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(214[22] 225[16])
    defparam i1715_4_lut.init = 16'heeed;
    LUT4 i1_3_lut_adj_7 (.A(bit_count[1]), .B(bit_count[2]), .C(bit_count[4]), 
         .Z(n8)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(220[21:35])
    defparam i1_3_lut_adj_7.init = 16'hfefe;
    LUT4 i632_1_lut (.A(spi3_sck_c), .Z(spi_clk_N_224)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(189[13] 192[16])
    defparam i632_1_lut.init = 16'h5555;
    
endmodule
