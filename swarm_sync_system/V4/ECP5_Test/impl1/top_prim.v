// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.14.0.75.2
// Netlist written on Tue Jan 28 18:13:56 2025
//
// Verilog Description of module top
//

module top (fpga_led, fpga_neopixel, dpll_clkout2, dpll_clkout0, sdr_rx_wifi, 
            sdr_rx_subg, sdr_rxclk, sdr_txclk, sdr_txdata, fpga_sda, 
            fpga_scl, rf_sel_0, rf_sel_1, rf_sel_2, rf_sel_3, subg_fem_sel0, 
            subg_fem_sel1, wifi_fem_sel0, wifi_fem_sel1, wifi_fem_csd, 
            wifi_fem_cps, wifi_fem_crx, wifi_fem_ctx, wifi_fem_chl, 
            subg_fem_cps, subg_fem_ctx, subg_fem_csd, spi1_sck, spi1_mosi, 
            spi2_sck, spi2_mosi, stm_fpga_spare1, spi3_sck, spi3_mosi, 
            spi4_sck, spi4_mosi, stm_fpga_spare2, fpga_ufl_p7, fpga_ufl_p8, 
            stm_fpga_spare5) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(1[8:11])
    output fpga_led;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(2[14:22])
    output fpga_neopixel;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(3[14:27])
    input dpll_clkout2;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(5[13:25])
    input dpll_clkout0;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(6[13:25])
    input sdr_rx_wifi;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(8[13:24])
    input sdr_rx_subg /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(9[13:24])
    input sdr_rxclk /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(10[13:22])
    output sdr_txclk /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(11[14:23])
    output sdr_txdata /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(12[14:24])
    inout fpga_sda /* synthesis IO_TYPES="LVDS", black_box_pad_pin=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(15[13:21])
    inout fpga_scl /* synthesis black_box_pad_pin=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(16[13:21])
    output rf_sel_0;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(19[14:22])
    output rf_sel_1;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(20[14:22])
    output rf_sel_2;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(21[14:22])
    output rf_sel_3;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(22[14:22])
    output subg_fem_sel0;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(23[14:27])
    output subg_fem_sel1;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(24[14:27])
    output wifi_fem_sel0;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(25[14:27])
    output wifi_fem_sel1;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(26[14:27])
    output wifi_fem_csd;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(29[14:26])
    output wifi_fem_cps;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(30[14:26])
    output wifi_fem_crx;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(31[14:26])
    output wifi_fem_ctx;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(32[14:26])
    output wifi_fem_chl;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(33[14:26])
    output subg_fem_cps;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(36[14:26])
    output subg_fem_ctx;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(37[14:26])
    output subg_fem_csd;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(38[14:26])
    output spi1_sck;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(43[14:22])
    output spi1_mosi;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(44[14:23])
    output spi2_sck;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(48[14:22])
    output spi2_mosi;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(49[14:23])
    input stm_fpga_spare1;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(52[13:28])
    output spi3_sck;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(55[14:22])
    output spi3_mosi;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(56[14:23])
    output spi4_sck;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(60[14:22])
    output spi4_mosi;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(61[14:23])
    input stm_fpga_spare2;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(64[13:28])
    output fpga_ufl_p7;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(66[14:25])
    output fpga_ufl_p8;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(67[14:25])
    input stm_fpga_spare5;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(69[13:28])
    
    wire VCC_net /* synthesis CE_NET_FOR_BUS20=20, DSPPORT_20=CE3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(26[14:27])
    wire dpll_clkout2_c /* synthesis is_clock=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(5[13:25])
    wire dpll_clkout0_c /* synthesis is_clock=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(6[13:25])
    wire fpga_ufl_p8_c_c /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(9[13:24])
    wire sdr_rxclk_c /* synthesis IO_TYPES="LVDS", is_clock=1, SET_AS_NETWORK=sdr_rxclk_c */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(10[13:22])
    wire sdr_txclk_c /* synthesis IO_TYPES="LVDS", is_clock=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(11[14:23])
    wire sdr_txdata_c /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(12[14:24])
    wire fpga_sda /* synthesis IO_TYPES="LVDS" */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(15[13:21])
    wire int_clk_out /* synthesis DSPPORT_20=CLK3, CLOCK_NET_FOR_BUS20=20, is_clock=1, SET_AS_NETWORK=int_clk_out */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(76[6:17])
    wire internal_80MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_80MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(84[6:20])
    wire internal_64MHz /* synthesis SET_AS_NETWORK=internal_64MHz, is_clock=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(85[6:20])
    wire fpga_led_N_383 /* synthesis DSPPORT_20=RST3, RESET_NET_FOR_BUS20=20 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(2[14:22])
    
    wire GND_net, fpga_led_c, sdr_rx_wifi_c, spi1_sck_c, spi1_mosi_c, 
        spi2_sck_c, spi2_mosi_c, stm_fpga_spare1_c, spi3_sck_c, spi3_mosi_c, 
        spi4_sck_c, spi4_mosi_c, stm_fpga_spare2_c, stm_fpga_spare5_c, 
        pll_lock, second_pll_lock, internal_rst, led_rst, fpga_scl_out, 
        fpga_scl_in, fpga_sda_out, fpga_sda_in;
    wire [7:0]wb_dat_o;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(189[12:20])
    wire [15:0]wb_adr_o;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(190[13:21])
    
    wire wb_we_o, wb_stb_o;
    wire [7:0]wb_dat_i;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(194[11:19])
    
    wire wb_ack_i;
    wire [7:0]reg0;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(322[11:15])
    wire [7:0]reg1;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(322[16:20])
    wire [7:0]reg2;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(322[21:25])
    wire [7:0]ufl_p7_sel;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(323[11:21])
    wire [7:0]ufl_p8_sel;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(323[23:33])
    
    wire subg_rx_invert, wifi_rx_invert;
    wire [15:0]spi1_test_pattern;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(325[12:29])
    wire [15:0]spi2_test_pattern;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(325[31:48])
    wire [15:0]spi3_test_pattern;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(326[12:29])
    wire [15:0]spi4_test_pattern;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(326[31:48])
    wire [3:0]spi_test_pattern_enable;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(327[11:34])
    wire [31:0]tx_lvds_test_pattern;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(328[12:32])
    
    wire tx_lvds_test_pattern_enable, subg_sync_check_enable, wifi_sync_check_enable, 
        subg_delay_loadn, subg_delay_move, subg_delay_direction;
    wire [7:0]data_mux;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(409[11:19])
    wire [31:0]tx_ddr_data;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(465[12:23])
    wire [7:0]tx_counter;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(466[11:21])
    
    wire w_lvds_rx_09_d0, w_lvds_rx_09_d1, w_lvds_rx_24_d0, w_lvds_rx_24_d1, 
        w_rx_09_fifo_push;
    wire [31:0]w_rx_09_fifo_data;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(555[13:30])
    
    wire w_rx_24_fifo_push;
    wire [31:0]w_rx_24_fifo_data;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(559[13:30])
    
    wire subg_i_empty;
    wire [15:0]subg_i_fifo_data_out;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(646[13:33])
    
    wire subg_q_empty;
    wire [15:0]subg_q_fifo_data_out;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(662[13:33])
    
    wire wifi_i_empty;
    wire [15:0]wifi_i_fifo_data_out;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(679[13:33])
    
    wire wifi_q_empty;
    wire [15:0]wifi_q_fifo_data_out;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(695[13:33])
    
    wire n13180, n2891, n45, n44, n43, n42, n41, n40, n2890, 
        n2797, n2889, internal_80MHz_enable_36, internal_80MHz_enable_52, 
        n2888, n2883, n2882, n14031, n13388, n14029, n11591, n13458, 
        n13162, internal_80MHz_enable_68, n13467, int_clk_out_enable_55, 
        n14021, n13460, int_clk_out_enable_129, n14019, int_clk_out_enable_111;
    wire [7:0]ufl_p7_sel_7__N_35;
    
    wire n13457;
    wire [15:0]spi3_test_pattern_15__N_83;
    wire [31:0]tx_lvds_test_pattern_31__N_119;
    
    wire int_clk_out_enable_54, main_reset_n_N_208;
    wire [31:0]tx_ddr_data_31__N_175;
    
    wire tx_ddr_data_31__N_385, tx_ddr_data_30__N_387, sdr_txdata_N_388, 
        subg_i_empty_N_227;
    wire [15:0]spi1_sck_N_394;
    wire [15:0]spi2_sck_N_410;
    wire [15:0]spi3_sck_N_426;
    wire [15:0]spi4_sck_N_442;
    
    wire n14305, bus_addressed, n13471, n13485, n13391, n12812, 
        int_clk_out_enable_32, n14304, n13394, n13397, n2996, n2995, 
        n2994, n2993, n14004, n14002, n13400, int_clk_out_enable_122, 
        int_clk_out_enable_99, n14269, n12798, internal_80MHz_enable_51, 
        n13462;
    wire [1:0]r_state;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(23[16:23])
    wire [32:0]sr;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(27[16:18])
    wire [3:0]match_count;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(30[15:26])
    
    wire n11664;
    wire [3:0]match_count_next;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(30[28:44])
    
    wire r_candidate_offset;
    wire [7:0]sample_count;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(36[16:28])
    wire [7:0]sample_count_next;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(36[30:47])
    wire [31:0]candidate_sr;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[14:26])
    
    wire real_candidate, n14398, n102, n2907, n2895, n2894, n2893, 
        n2881, n2869, n2868, n2867, n2866, n2865, n2864, n39, 
        n38, internal_80MHz_enable_35;
    wire [1:0]r_state_adj_1205;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(23[16:23])
    wire [7:0]sample_count_adj_1211;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(36[16:28])
    wire [7:0]sample_count_next_adj_1212;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(36[30:47])
    
    wire n13080, n13431, int_clk_out_enable_15, n13494, n13493, n13492, 
        n13491, n13490, n2770, n2769, n2857, n2856, n2855, n2854, 
        n2853, n2852, n2845, n2844, n13468, n9012, n11958, rRst, 
        shift_reg_15__N_1175, shift_reg_15__N_1166, shift_reg_15__N_1175_adj_1193, 
        shift_reg_15__N_1175_adj_1194, n13489, n13488, n13487, shift_reg_15__N_1175_adj_1195, 
        n13486, n13459, n14407, n2843, n13044;
    wire [4:0]state_reg_adj_1301;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(181[11:20])
    
    wire n10824, mode_read_reg, sda_i_reg, n2842, n2841, n11488, 
        n2840, n14299, n2833, n2832, n2831, n2830, n2829, n2828, 
        internal_80MHz_enable_19, n13466, n2821, n2820, n14915, n14914, 
        n14913, n14912, n14911, n14910, n2809, n2808, n14909, 
        n14908, n13456, n12618, n13481, n13480, n13465, int_clk_out_enable_171, 
        n11601, int_clk_out_enable_164, n14395, n14384, sdr_rxclk_c_enable_88, 
        n13461, n13479, int_clk_out_enable_143, n14294, int_clk_out_enable_134, 
        n1, int_clk_out_enable_150, int_clk_out_enable_128, n13453, 
        int_clk_out_enable_121, n14268, n12168, int_clk_out_enable_27, 
        n14293, int_clk_out_enable_114, n13411, n12966, n12156, n12964, 
        n12954, int_clk_out_enable_106, n12153, int_clk_out_enable_107, 
        int_clk_out_enable_98, n3020, n3019, n3018, n3016, n3015, 
        n3014, n3013, n15, int_clk_out_enable_92, n12584, n14366, 
        n14365, int_clk_out_enable_84, n14363, int_clk_out_enable_76, 
        n14409, n14408, n14360, int_clk_out_enable_77, int_clk_out_enable_69, 
        int_clk_out_enable_62, n13234, n13402, int_clk_out_enable_53, 
        n14403, n14356, n13401, int_clk_out_enable_46, n14354, n14402, 
        n10827, int_clk_out_enable_39, n13230, n12902, n14352, n14351, 
        n13470, internal_80MHz_enable_20, n14348, n12896, n14347, 
        n14346, n14400, n13463, n14399, n14345, n14343, n13398, 
        n10825, int_clk_out_enable_83, n13464, n13396, n14121, n14120, 
        n14397, n14119, n14118, n14117, n10826, int_clk_out_enable_28, 
        n14115, n14114, n14113, n14112, n14111, n13395, n14110, 
        n14106, n14105, n14104, n14103, n13393, n14102, n14101, 
        n13392, int_clk_out_enable_91, n14396, n13302, n14093, n13204, 
        n14092, int_clk_out_enable_212, n14091, n14090, n14089, n14088, 
        n14338, n13390, n13324, n14337, internal_80MHz_enable_67, 
        n14917, n13477, n13476, n13475, n13474, n13389, n13473, 
        n13472, n14288, n14287, n14285, n7334, n13469, n14330, 
        n14284, n14058, n14056, n14401, n14325, n14324, int_clk_out_enable_141, 
        n14116, int_clk_out_enable_136, n14316, n14315, n13499, n13498, 
        n13497, n13496, n13495;
    
    VHI i2 (.Z(VCC_net));
    BB scl_io (.I(fpga_scl_out), .T(fpga_scl_out), .B(fpga_scl), .O(fpga_scl_in)) /* synthesis syn_instantiated=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(169[4] 174[2])
    internal_pll my_pll (.dpll_clkout2_c(dpll_clkout2_c), .n14343(n14343), 
            .internal_64MHz(internal_64MHz), .internal_80MHz(internal_80MHz), 
            .sdr_txclk_c(sdr_txclk_c), .pll_lock(pll_lock), .GND_net(GND_net)) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(88[14] 96[2])
    LUT4 n2829_bdd_3_lut_10888 (.A(n2865), .B(n2841), .C(wb_adr_o[2]), 
         .Z(n14101)) /* synthesis lut_function=(A (B+(C))+!A !((C)+!B)) */ ;
    defparam n2829_bdd_3_lut_10888.init = 16'hacac;
    led_toggle my_led (.fpga_led_c(fpga_led_c), .int_clk_out(int_clk_out), 
            .fpga_led_N_383(fpga_led_N_383), .GND_net(GND_net), .VCC_net(VCC_net)) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(114[12] 121[2])
    PFUMX mux_859_i3 (.BLUT(n13394), .ALUT(n13396), .C0(n13431), .Z(n3018));
    LUT4 i1_2_lut_3_lut_3_lut (.A(wifi_i_empty), .B(shift_reg_15__N_1175_adj_1194), 
         .C(stm_fpga_spare2_c), .Z(internal_80MHz_enable_51)) /* synthesis lut_function=(A (B)+!A (B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(729[41:54])
    defparam i1_2_lut_3_lut_3_lut.init = 16'hdcdc;
    LUT4 n2828_bdd_3_lut_11135 (.A(n2828), .B(n2852), .C(wb_adr_o[2]), 
         .Z(n14089)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam n2828_bdd_3_lut_11135.init = 16'hcaca;
    FD1P3IX led_rst_219 (.D(wb_dat_o[1]), .SP(int_clk_out_enable_15), .CD(n14343), 
            .CK(int_clk_out), .Q(led_rst));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam led_rst_219.GSR = "DISABLED";
    FD1S3IX wb_dat_i__i0 (.D(data_mux[0]), .CK(int_clk_out), .CD(n14343), 
            .Q(wb_dat_i[0]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(444[8] 456[4])
    defparam wb_dat_i__i0.GSR = "DISABLED";
    PFUMX mux_859_i2 (.BLUT(n13391), .ALUT(n13393), .C0(n13431), .Z(n3019));
    LUT4 i1_3_lut_4_lut (.A(n15), .B(n14360), .C(n14338), .D(sample_count_adj_1211[2]), 
         .Z(sample_count_next_adj_1212[2])) /* synthesis lut_function=(!(((C (D)+!C !(D))+!B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(123[9] 198[16])
    defparam i1_3_lut_4_lut.init = 16'h0880;
    LUT4 i1_3_lut_4_lut_adj_226 (.A(n15), .B(n14360), .C(sample_count_adj_1211[0]), 
         .D(sample_count_adj_1211[1]), .Z(sample_count_next_adj_1212[1])) /* synthesis lut_function=(!(((C (D)+!C !(D))+!B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(123[9] 198[16])
    defparam i1_3_lut_4_lut_adj_226.init = 16'h0880;
    FD1P3IX reg0__i0 (.D(wb_dat_o[0]), .SP(int_clk_out_enable_150), .CD(n14343), 
            .CK(int_clk_out), .Q(reg0[0]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg0__i0.GSR = "DISABLED";
    FD1P3AX ufl_p7_sel_i0 (.D(ufl_p7_sel_7__N_35[0]), .SP(int_clk_out_enable_143), 
            .CK(int_clk_out), .Q(ufl_p7_sel[0]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam ufl_p7_sel_i0.GSR = "DISABLED";
    LUT4 i10668_2_lut (.A(n14366), .B(tx_lvds_test_pattern_enable), .Z(sdr_txdata_N_388)) /* synthesis lut_function=(!(A (B))) */ ;
    defparam i10668_2_lut.init = 16'h7777;
    LUT4 tx_ddr_data_31__I_0_1_lut (.A(tx_ddr_data[31]), .Z(tx_ddr_data_31__N_385)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(484[7:23])
    defparam tx_ddr_data_31__I_0_1_lut.init = 16'h5555;
    FD1P3IX ufl_p8_sel_i0 (.D(wb_dat_o[0]), .SP(int_clk_out_enable_136), 
            .CD(n14343), .CK(int_clk_out), .Q(ufl_p8_sel[0]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam ufl_p8_sel_i0.GSR = "DISABLED";
    LUT4 n2829_bdd_3_lut_11095 (.A(n2829), .B(n2853), .C(wb_adr_o[2]), 
         .Z(n14102)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam n2829_bdd_3_lut_11095.init = 16'hcaca;
    FD1P3AX spi1_test_pattern_i0 (.D(ufl_p7_sel_7__N_35[0]), .SP(int_clk_out_enable_128), 
            .CK(int_clk_out), .Q(spi1_test_pattern[0]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi1_test_pattern_i0.GSR = "DISABLED";
    FD1P3AX spi2_test_pattern_i0 (.D(ufl_p7_sel_7__N_35[0]), .SP(int_clk_out_enable_114), 
            .CK(int_clk_out), .Q(spi2_test_pattern[0]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi2_test_pattern_i0.GSR = "DISABLED";
    LUT4 mux_810_i5_3_lut (.A(spi1_test_pattern[12]), .B(spi1_test_pattern[4]), 
         .C(wb_adr_o[0]), .Z(n2831)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_810_i5_3_lut.init = 16'hcaca;
    FD1P3AX spi3_test_pattern_i0 (.D(ufl_p7_sel_7__N_35[0]), .SP(int_clk_out_enable_98), 
            .CK(int_clk_out), .Q(spi3_test_pattern[0]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi3_test_pattern_i0.GSR = "DISABLED";
    FD1P3IX spi4_test_pattern_i0 (.D(wb_dat_o[0]), .SP(int_clk_out_enable_83), 
            .CD(n14343), .CK(int_clk_out), .Q(spi4_test_pattern[0]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi4_test_pattern_i0.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i0 (.D(ufl_p7_sel_7__N_35[0]), .SP(int_clk_out_enable_69), 
            .CK(int_clk_out), .Q(tx_lvds_test_pattern[0]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i0.GSR = "DISABLED";
    FD1S3IX tx_ddr_data_i0 (.D(tx_lvds_test_pattern[0]), .CK(internal_64MHz), 
            .CD(n14293), .Q(tx_ddr_data[0]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i0.GSR = "ENABLED";
    LUT4 tx_ddr_data_30__I_0_1_lut (.A(tx_ddr_data[30]), .Z(tx_ddr_data_30__N_387)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(485[7:23])
    defparam tx_ddr_data_30__I_0_1_lut.init = 16'h5555;
    OSCG osch_inst (.OSC(int_clk_out)) /* synthesis syn_instantiated=1 */ ;
    defparam osch_inst.DIV = 32;
    IDDRX1F wifi_iddr (.D(sdr_rx_wifi_c), .SCLK(sdr_rxclk_c), .RST(main_reset_n_N_208), 
            .Q0(w_lvds_rx_24_d0), .Q1(w_lvds_rx_24_d1)) /* synthesis syn_instantiated=1 */ ;
    defparam wifi_iddr.GSR = "ENABLED";
    IDDRX1F subg_iddr (.D(fpga_ufl_p8_c_c), .SCLK(sdr_rxclk_c), .RST(main_reset_n_N_208), 
            .Q0(w_lvds_rx_09_d0), .Q1(w_lvds_rx_09_d1)) /* synthesis syn_instantiated=1 */ ;
    defparam subg_iddr.GSR = "ENABLED";
    LUT4 equal_767_i3_2_lut (.A(r_state[0]), .B(r_state[1]), .Z(sdr_rxclk_c_enable_88)) /* synthesis lut_function=(A+!(B)) */ ;
    defparam equal_767_i3_2_lut.init = 16'hbbbb;
    OB sdr_txclk_pad (.I(sdr_txclk_c), .O(sdr_txclk));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(11[14:23])
    BB sda_io (.I(fpga_sda_out), .T(fpga_sda_out), .B(fpga_sda), .O(fpga_sda_in)) /* synthesis syn_instantiated=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(178[4] 183[2])
    ODDRX1F tx_ddr_data_inst (.D0(tx_ddr_data_31__N_385), .D1(tx_ddr_data_30__N_387), 
            .SCLK(internal_64MHz), .RST(sdr_txdata_N_388), .Q(sdr_txdata_c)) /* synthesis syn_instantiated=1 */ ;
    defparam tx_ddr_data_inst.GSR = "ENABLED";
    LUT4 i10498_3_lut (.A(spi4_test_pattern[8]), .B(spi4_test_pattern[0]), 
         .C(wb_adr_o[0]), .Z(n13492)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i10498_3_lut.init = 16'hcaca;
    LUT4 n13479_bdd_4_lut (.A(n2769), .B(wb_adr_o[0]), .C(reg2[3]), .D(wb_adr_o[1]), 
         .Z(n14912)) /* synthesis lut_function=(!(A (B (D)+!B !(C+!(D)))+!A (B+!(C (D))))) */ ;
    defparam n13479_bdd_4_lut.init = 16'h30aa;
    LUT4 n14912_bdd_3_lut (.A(n14912), .B(n13479), .C(wb_adr_o[2]), .Z(n14913)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam n14912_bdd_3_lut.init = 16'hcaca;
    LUT4 subg_q_empty_I_0_1_lut_rep_264 (.A(subg_q_empty), .Z(n14348)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(725[41:54])
    defparam subg_q_empty_I_0_1_lut_rep_264.init = 16'h5555;
    LUT4 i4308_2_lut_rep_276 (.A(r_state_adj_1205[1]), .B(r_state_adj_1205[0]), 
         .Z(n14360)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(123[9] 198[16])
    defparam i4308_2_lut_rep_276.init = 16'heeee;
    LUT4 i10409_4_lut (.A(r_candidate_offset), .B(n13204), .C(n14365), 
         .D(n11488), .Z(n13401)) /* synthesis lut_function=(A ((C+!(D))+!B)+!A !(B (C+(D))+!B (C))) */ ;
    defparam i10409_4_lut.init = 16'ha3af;
    LUT4 stm_fpga_spare1_I_0_2_lut_rep_227_2_lut (.A(subg_q_empty), .B(stm_fpga_spare1_c), 
         .Z(internal_80MHz_enable_36)) /* synthesis lut_function=(!(A+!(B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(725[41:54])
    defparam stm_fpga_spare1_I_0_2_lut_rep_227_2_lut.init = 16'h4444;
    LUT4 i_start_I_0_2_lut_rep_204_3_lut_3_lut (.A(subg_q_empty), .B(shift_reg_15__N_1175_adj_1193), 
         .C(stm_fpga_spare1_c), .Z(n14288)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(725[41:54])
    defparam i_start_I_0_2_lut_rep_204_3_lut_3_lut.init = 16'h1010;
    LUT4 i10497_3_lut (.A(spi3_test_pattern[8]), .B(spi3_test_pattern[0]), 
         .C(wb_adr_o[0]), .Z(n13491)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i10497_3_lut.init = 16'hcaca;
    LUT4 i1_2_lut_3_lut (.A(r_state_adj_1205[1]), .B(r_state_adj_1205[0]), 
         .C(sample_count_adj_1211[0]), .Z(sample_count_next_adj_1212[0])) /* synthesis lut_function=(!(A (C)+!A ((C)+!B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(123[9] 198[16])
    defparam i1_2_lut_3_lut.init = 16'h0e0e;
    LUT4 i1_2_lut_rep_200_3_lut (.A(r_state_adj_1205[1]), .B(r_state_adj_1205[0]), 
         .C(n15), .Z(n14284)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(123[9] 198[16])
    defparam i1_2_lut_rep_200_3_lut.init = 16'he0e0;
    LUT4 i1_2_lut_3_lut_3_lut_adj_227 (.A(subg_q_empty), .B(shift_reg_15__N_1175_adj_1193), 
         .C(stm_fpga_spare1_c), .Z(internal_80MHz_enable_35)) /* synthesis lut_function=(A (B)+!A (B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(725[41:54])
    defparam i1_2_lut_3_lut_3_lut_adj_227.init = 16'hdcdc;
    LUT4 i10496_3_lut (.A(spi2_test_pattern[8]), .B(spi2_test_pattern[0]), 
         .C(wb_adr_o[0]), .Z(n13490)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i10496_3_lut.init = 16'hcaca;
    LUT4 stm_fpga_spare1_I_0_288_2_lut_rep_265 (.A(stm_fpga_spare1_c), .B(subg_i_empty), 
         .Z(internal_80MHz_enable_20)) /* synthesis lut_function=(!((B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(724[23:54])
    defparam stm_fpga_spare1_I_0_288_2_lut_rep_265.init = 16'h2222;
    LUT4 i10495_3_lut (.A(spi1_test_pattern[8]), .B(spi1_test_pattern[0]), 
         .C(wb_adr_o[0]), .Z(n13489)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i10495_3_lut.init = 16'hcaca;
    LUT4 i10465_3_lut (.A(ufl_p8_sel[1]), .B(wifi_rx_invert), .C(wb_adr_o[0]), 
         .Z(n13459)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i10465_3_lut.init = 16'hcaca;
    LUT4 i_start_I_0_2_lut_3_lut (.A(stm_fpga_spare1_c), .B(subg_i_empty), 
         .C(shift_reg_15__N_1175), .Z(shift_reg_15__N_1166)) /* synthesis lut_function=(!((B+(C))+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(724[23:54])
    defparam i_start_I_0_2_lut_3_lut.init = 16'h0202;
    LUT4 i1_2_lut_rep_279 (.A(r_state[0]), .B(r_state[1]), .Z(n14363)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(123[9] 198[16])
    defparam i1_2_lut_rep_279.init = 16'h8888;
    LUT4 i10670_2_lut_3_lut (.A(r_state[0]), .B(r_state[1]), .C(n14315), 
         .Z(n11591)) /* synthesis lut_function=(((C)+!B)+!A) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(123[9] 198[16])
    defparam i10670_2_lut_3_lut.init = 16'hf7f7;
    LUT4 i1_4_lut (.A(n14354), .B(n12954), .C(n9012), .D(wb_adr_o[8]), 
         .Z(n12966)) /* synthesis lut_function=(!(A+((C+(D))+!B))) */ ;
    defparam i1_4_lut.init = 16'h0004;
    LUT4 i1_2_lut_3_lut_adj_228 (.A(stm_fpga_spare1_c), .B(subg_i_empty), 
         .C(shift_reg_15__N_1175), .Z(internal_80MHz_enable_19)) /* synthesis lut_function=(A ((C)+!B)+!A (C)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(724[23:54])
    defparam i1_2_lut_3_lut_adj_228.init = 16'hf2f2;
    LUT4 i10494_3_lut (.A(ufl_p8_sel[0]), .B(subg_rx_invert), .C(wb_adr_o[0]), 
         .Z(n13488)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i10494_3_lut.init = 16'hcaca;
    LUT4 i10493_3_lut (.A(internal_rst), .B(ufl_p7_sel[0]), .C(wb_adr_o[0]), 
         .Z(n13487)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i10493_3_lut.init = 16'hcaca;
    OB fpga_neopixel_pad (.I(GND_net), .O(fpga_neopixel));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(3[14:27])
    LUT4 i10464_3_lut (.A(led_rst), .B(ufl_p7_sel[1]), .C(wb_adr_o[0]), 
         .Z(n13458)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i10464_3_lut.init = 16'hcaca;
    ecp5_spi_master_top_U4 subg_i_spi (.internal_80MHz(internal_80MHz), .shift_reg_15__N_1166(shift_reg_15__N_1166), 
            .spi1_mosi_c(spi1_mosi_c), .main_reset_n_N_208(main_reset_n_N_208), 
            .internal_80MHz_enable_19(internal_80MHz_enable_19), .GND_net(GND_net), 
            .spi1_sck_c(spi1_sck_c), .shift_reg_15__N_1175(shift_reg_15__N_1175), 
            .internal_80MHz_enable_20(internal_80MHz_enable_20), .spi1_sck_N_394({spi1_sck_N_394})) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(755[21] 763[2])
    ecp5_spi_master_top_U2 subg_q_spi (.internal_80MHz(internal_80MHz), .spi2_mosi_c(spi2_mosi_c), 
            .main_reset_n_N_208(main_reset_n_N_208), .n14288(n14288), .internal_80MHz_enable_35(internal_80MHz_enable_35), 
            .GND_net(GND_net), .spi2_sck_c(spi2_sck_c), .shift_reg_15__N_1175(shift_reg_15__N_1175_adj_1193), 
            .spi2_sck_N_410({spi2_sck_N_410}), .internal_80MHz_enable_36(internal_80MHz_enable_36)) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(765[21] 773[2])
    ecp5_spi_master_top_U0 wifi_i_spi (.internal_80MHz(internal_80MHz), .n14287(n14287), 
            .spi3_mosi_c(spi3_mosi_c), .main_reset_n_N_208(main_reset_n_N_208), 
            .internal_80MHz_enable_51(internal_80MHz_enable_51), .GND_net(GND_net), 
            .spi3_sck_c(spi3_sck_c), .shift_reg_15__N_1175(shift_reg_15__N_1175_adj_1194), 
            .internal_80MHz_enable_52(internal_80MHz_enable_52), .spi3_sck_N_426({spi3_sck_N_426})) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(776[21] 784[2])
    FD1P3IX spi_test_pattern_enable__i0 (.D(wb_dat_o[0]), .SP(int_clk_out_enable_27), 
            .CD(n14343), .CK(int_clk_out), .Q(spi_test_pattern_enable[0]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi_test_pattern_enable__i0.GSR = "DISABLED";
    LUT4 i4294_2_lut_rep_281 (.A(r_state[1]), .B(r_state[0]), .Z(n14365)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(123[9] 198[16])
    defparam i4294_2_lut_rep_281.init = 16'heeee;
    LUT4 i1_2_lut_rep_210_3_lut (.A(r_state[1]), .B(r_state[0]), .C(n14315), 
         .Z(n14294)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(123[9] 198[16])
    defparam i1_2_lut_rep_210_3_lut.init = 16'he0e0;
    FD1P3IX subg_delay_move_234 (.D(wb_dat_o[1]), .SP(int_clk_out_enable_32), 
            .CD(n14343), .CK(int_clk_out), .Q(subg_delay_move));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam subg_delay_move_234.GSR = "DISABLED";
    LUT4 i10691_2_lut (.A(int_clk_out_enable_91), .B(stm_fpga_spare5_c), 
         .Z(int_clk_out_enable_92)) /* synthesis lut_function=(A+!(B)) */ ;
    defparam i10691_2_lut.init = 16'hbbbb;
    LUT4 i1_2_lut_3_lut_adj_229 (.A(r_state[1]), .B(r_state[0]), .C(sample_count[0]), 
         .Z(sample_count_next[0])) /* synthesis lut_function=(!(A (C)+!A ((C)+!B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(123[9] 198[16])
    defparam i1_2_lut_3_lut_adj_229.init = 16'h0e0e;
    LUT4 i10694_4_lut (.A(n12618), .B(n14330), .C(wb_adr_o[2]), .D(n14325), 
         .Z(int_clk_out_enable_91)) /* synthesis lut_function=(!(A+(((D)+!C)+!B))) */ ;
    defparam i10694_4_lut.init = 16'h0040;
    FD1P3IX internal_rst_218 (.D(wb_dat_o[0]), .SP(int_clk_out_enable_15), 
            .CD(n14343), .CK(int_clk_out), .Q(internal_rst));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam internal_rst_218.GSR = "DISABLED";
    LUT4 i10492_3_lut (.A(reg2[0]), .B(pll_lock), .C(wb_adr_o[0]), .Z(n13486)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i10492_3_lut.init = 16'hcaca;
    LUT4 i10491_3_lut (.A(reg0[0]), .B(reg1[0]), .C(wb_adr_o[0]), .Z(n13485)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i10491_3_lut.init = 16'hcaca;
    LUT4 n2828_bdd_3_lut_10878 (.A(n2864), .B(n2840), .C(wb_adr_o[2]), 
         .Z(n14088)) /* synthesis lut_function=(A (B+(C))+!A !((C)+!B)) */ ;
    defparam n2828_bdd_3_lut_10878.init = 16'hacac;
    LUT4 n14031_bdd_4_lut (.A(n14031), .B(wb_adr_o[0]), .C(wb_adr_o[2]), 
         .D(ufl_p7_sel[6]), .Z(n14104)) /* synthesis lut_function=(A (B ((D)+!C)+!B !(C))+!A (B (C (D)))) */ ;
    defparam n14031_bdd_4_lut.init = 16'hca0a;
    LUT4 internal_rst_I_2_2_lut_rep_267 (.A(wb_stb_o), .B(wb_we_o), .Z(n14351)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(363[11:42])
    defparam internal_rst_I_2_2_lut_rep_267.init = 16'h8888;
    LUT4 i1_3_lut (.A(n3013), .B(n12156), .C(n12153), .Z(data_mux[7])) /* synthesis lut_function=(A+((C)+!B)) */ ;
    defparam i1_3_lut.init = 16'hfbfb;
    LUT4 i1_3_lut_adj_230 (.A(n3014), .B(n12156), .C(n12153), .Z(data_mux[6])) /* synthesis lut_function=(A+((C)+!B)) */ ;
    defparam i1_3_lut_adj_230.init = 16'hfbfb;
    LUT4 n14058_bdd_4_lut (.A(n14058), .B(wb_adr_o[0]), .C(wb_adr_o[2]), 
         .D(ufl_p7_sel[7]), .Z(n14091)) /* synthesis lut_function=(A (B ((D)+!C)+!B !(C))+!A (B (C (D)))) */ ;
    defparam n14058_bdd_4_lut.init = 16'hca0a;
    LUT4 i1_3_lut_adj_231 (.A(n3015), .B(n12156), .C(n12153), .Z(data_mux[5])) /* synthesis lut_function=(A+((C)+!B)) */ ;
    defparam i1_3_lut_adj_231.init = 16'hfbfb;
    LUT4 i1_3_lut_rep_246_4_lut (.A(wb_stb_o), .B(wb_we_o), .C(wb_adr_o[7]), 
         .D(wb_adr_o[6]), .Z(n14330)) /* synthesis lut_function=(!(((C+(D))+!B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(363[11:42])
    defparam i1_3_lut_rep_246_4_lut.init = 16'h0008;
    FD1P3IX reg1__i0 (.D(wb_dat_o[0]), .SP(int_clk_out_enable_164), .CD(n14343), 
            .CK(int_clk_out), .Q(reg1[0]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg1__i0.GSR = "DISABLED";
    LUT4 i1_3_lut_3_lut_4_lut (.A(wb_stb_o), .B(wb_we_o), .C(n14352), 
         .D(stm_fpga_spare5_c), .Z(n13180)) /* synthesis lut_function=(!(A (B (C)+!B (C+(D)))+!A (C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(363[11:42])
    defparam i1_3_lut_3_lut_4_lut.init = 16'h080f;
    FD1P3IX subg_delay_direction_235 (.D(wb_dat_o[2]), .SP(int_clk_out_enable_32), 
            .CD(n14343), .CK(int_clk_out), .Q(subg_delay_direction));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam subg_delay_direction_235.GSR = "DISABLED";
    LUT4 i1_2_lut_3_lut_adj_232 (.A(wb_stb_o), .B(wb_we_o), .C(wb_adr_o[2]), 
         .Z(n12954)) /* synthesis lut_function=(A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(363[11:42])
    defparam i1_2_lut_3_lut_adj_232.init = 16'h8080;
    LUT4 mux_830_i1_3_lut (.A(tx_lvds_test_pattern[16]), .B(tx_lvds_test_pattern[8]), 
         .C(wb_adr_o[0]), .Z(n2895)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_830_i1_3_lut.init = 16'hcaca;
    FD1P3IX reg2__i0 (.D(wb_dat_o[0]), .SP(int_clk_out_enable_171), .CD(n14343), 
            .CK(int_clk_out), .Q(reg2[0]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg2__i0.GSR = "DISABLED";
    LUT4 mux_826_i1_3_lut (.A(spi_test_pattern_enable[0]), .B(tx_lvds_test_pattern[24]), 
         .C(wb_adr_o[0]), .Z(n2883)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_826_i1_3_lut.init = 16'hcaca;
    LUT4 n2830_bdd_3_lut_11063 (.A(n2830), .B(n2854), .C(wb_adr_o[2]), 
         .Z(n14111)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam n2830_bdd_3_lut_11063.init = 16'hcaca;
    LUT4 i1_3_lut_adj_233 (.A(n3016), .B(n12156), .C(n12153), .Z(data_mux[4])) /* synthesis lut_function=(A+((C)+!B)) */ ;
    defparam i1_3_lut_adj_233.init = 16'hfbfb;
    LUT4 i10410_4_lut (.A(mode_read_reg), .B(sda_i_reg), .C(n14299), .D(n12584), 
         .Z(n13402)) /* synthesis lut_function=(A (B+(C+!(D)))+!A !((C+!(D))+!B)) */ ;
    defparam i10410_4_lut.init = 16'hacaa;
    LUT4 i1_3_lut_adj_234 (.A(n14915), .B(n12156), .C(n12153), .Z(data_mux[3])) /* synthesis lut_function=(A+((C)+!B)) */ ;
    defparam i1_3_lut_adj_234.init = 16'hfbfb;
    LUT4 i3_4_lut_rep_282 (.A(stm_fpga_spare5_c), .B(second_pll_lock), .C(internal_rst), 
         .D(pll_lock), .Z(n14366)) /* synthesis lut_function=(!(((C+!(D))+!B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(110[23:83])
    defparam i3_4_lut_rep_282.init = 16'h0800;
    LUT4 i1_3_lut_adj_235 (.A(n12153), .B(n12156), .C(n3018), .Z(data_mux[2])) /* synthesis lut_function=(A+((C)+!B)) */ ;
    defparam i1_3_lut_adj_235.init = 16'hfbfb;
    FD1P3AX subg_rx_invert_222 (.D(ufl_p7_sel_7__N_35[0]), .SP(int_clk_out_enable_212), 
            .CK(int_clk_out), .Q(subg_rx_invert));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam subg_rx_invert_222.GSR = "DISABLED";
    LUT4 i1_3_lut_adj_236 (.A(n12153), .B(n12156), .C(n3019), .Z(data_mux[1])) /* synthesis lut_function=(A+((C)+!B)) */ ;
    defparam i1_3_lut_adj_236.init = 16'hfbfb;
    LUT4 tx_ddr_data_29__I_0_i32_3_lut (.A(tx_lvds_test_pattern[31]), .B(tx_ddr_data[29]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[31])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i32_3_lut.init = 16'hcaca;
    LUT4 n2830_bdd_3_lut_10897 (.A(n2866), .B(n2842), .C(wb_adr_o[2]), 
         .Z(n14110)) /* synthesis lut_function=(A (B+(C))+!A !((C)+!B)) */ ;
    defparam n2830_bdd_3_lut_10897.init = 16'hacac;
    OB fpga_led_pad (.I(fpga_led_c), .O(fpga_led));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(2[14:22])
    LUT4 tx_ddr_data_29__I_0_i31_3_lut (.A(tx_lvds_test_pattern[30]), .B(tx_ddr_data[28]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[30])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i31_3_lut.init = 16'hcaca;
    LUT4 main_reset_n_I_0_1_lut_4_lut (.A(stm_fpga_spare5_c), .B(second_pll_lock), 
         .C(internal_rst), .D(pll_lock), .Z(main_reset_n_N_208)) /* synthesis lut_function=(((C+!(D))+!B)+!A) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(110[23:83])
    defparam main_reset_n_I_0_1_lut_4_lut.init = 16'hf7ff;
    PFUMX i10478 (.BLUT(n2809), .ALUT(n2821), .C0(wb_adr_o[1]), .Z(n13472));
    LUT4 mux_779_i3_3_lut (.A(reg0[2]), .B(reg1[2]), .C(wb_adr_o[0]), 
         .Z(n2770)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_779_i3_3_lut.init = 16'hcaca;
    LUT4 i1_4_lut_adj_237 (.A(n102), .B(real_candidate), .C(r_state[1]), 
         .D(n13080), .Z(match_count_next[1])) /* synthesis lut_function=(!(A+((C+!(D))+!B))) */ ;
    defparam i1_4_lut_adj_237.init = 16'h0400;
    LUT4 tx_ddr_data_29__I_0_i30_3_lut (.A(tx_lvds_test_pattern[29]), .B(tx_ddr_data[27]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[29])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i30_3_lut.init = 16'hcaca;
    LUT4 i1_3_lut_adj_238 (.A(match_count[1]), .B(r_state[0]), .C(match_count[0]), 
         .Z(n13080)) /* synthesis lut_function=(!(A ((C)+!B)+!A !(B (C)))) */ ;
    defparam i1_3_lut_adj_238.init = 16'h4848;
    FD1P3IX spi_test_pattern_enable__i3 (.D(wb_dat_o[3]), .SP(int_clk_out_enable_27), 
            .CD(n14343), .CK(int_clk_out), .Q(spi_test_pattern_enable[3]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi_test_pattern_enable__i3.GSR = "DISABLED";
    LUT4 tx_ddr_data_29__I_0_i29_3_lut (.A(tx_lvds_test_pattern[28]), .B(tx_ddr_data[26]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[28])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i29_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i28_3_lut (.A(tx_lvds_test_pattern[27]), .B(tx_ddr_data[25]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[27])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i28_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i27_3_lut (.A(tx_lvds_test_pattern[26]), .B(tx_ddr_data[24]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[26])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i27_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i26_3_lut (.A(tx_lvds_test_pattern[25]), .B(tx_ddr_data[23]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[25])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i26_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i25_3_lut (.A(tx_lvds_test_pattern[24]), .B(tx_ddr_data[22]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[24])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i25_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i24_3_lut (.A(tx_lvds_test_pattern[23]), .B(tx_ddr_data[21]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[23])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i24_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i23_3_lut (.A(tx_lvds_test_pattern[22]), .B(tx_ddr_data[20]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[22])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i23_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i22_3_lut (.A(tx_lvds_test_pattern[21]), .B(tx_ddr_data[19]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[21])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i22_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i21_3_lut (.A(tx_lvds_test_pattern[20]), .B(tx_ddr_data[18]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[20])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i21_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i20_3_lut (.A(tx_lvds_test_pattern[19]), .B(tx_ddr_data[17]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[19])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i20_3_lut.init = 16'hcaca;
    FD1P3IX spi_test_pattern_enable__i2 (.D(wb_dat_o[2]), .SP(int_clk_out_enable_27), 
            .CD(n14343), .CK(int_clk_out), .Q(spi_test_pattern_enable[2]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi_test_pattern_enable__i2.GSR = "DISABLED";
    FD1P3IX spi_test_pattern_enable__i1 (.D(wb_dat_o[1]), .SP(int_clk_out_enable_27), 
            .CD(n14343), .CK(int_clk_out), .Q(spi_test_pattern_enable[1]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi_test_pattern_enable__i1.GSR = "DISABLED";
    LUT4 n14021_bdd_4_lut (.A(n14021), .B(wb_adr_o[0]), .C(wb_adr_o[2]), 
         .D(ufl_p7_sel[5]), .Z(n14113)) /* synthesis lut_function=(A (B ((D)+!C)+!B !(C))+!A (B (C (D)))) */ ;
    defparam n14021_bdd_4_lut.init = 16'hca0a;
    LUT4 i10406_3_lut (.A(tx_lvds_test_pattern[19]), .B(tx_lvds_test_pattern[11]), 
         .C(wb_adr_o[0]), .Z(n13398)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i10406_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i19_3_lut (.A(tx_lvds_test_pattern[18]), .B(tx_ddr_data[16]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[18])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i19_3_lut.init = 16'hcaca;
    FD1P3AX tx_lvds_test_pattern_enable_230 (.D(ufl_p7_sel_7__N_35[0]), .SP(int_clk_out_enable_28), 
            .CK(int_clk_out), .Q(tx_lvds_test_pattern_enable));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_enable_230.GSR = "DISABLED";
    LUT4 tx_ddr_data_29__I_0_i18_3_lut (.A(tx_lvds_test_pattern[17]), .B(tx_ddr_data[15]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[17])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i18_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i17_3_lut (.A(tx_lvds_test_pattern[16]), .B(tx_ddr_data[14]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[16])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i17_3_lut.init = 16'hcaca;
    LUT4 mux_830_i2_3_lut (.A(tx_lvds_test_pattern[17]), .B(tx_lvds_test_pattern[9]), 
         .C(wb_adr_o[0]), .Z(n2894)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_830_i2_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i16_3_lut (.A(tx_lvds_test_pattern[15]), .B(tx_ddr_data[13]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[15])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i16_3_lut.init = 16'hcaca;
    PFUMX i10485 (.BLUT(n2808), .ALUT(n2820), .C0(wb_adr_o[1]), .Z(n13479));
    LUT4 mux_822_i3_3_lut (.A(spi4_test_pattern[10]), .B(spi4_test_pattern[2]), 
         .C(wb_adr_o[0]), .Z(n2869)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_822_i3_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i15_3_lut (.A(tx_lvds_test_pattern[14]), .B(tx_ddr_data[12]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[14])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i15_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i14_3_lut (.A(tx_lvds_test_pattern[13]), .B(tx_ddr_data[11]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[13])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i14_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i13_3_lut (.A(tx_lvds_test_pattern[12]), .B(tx_ddr_data[10]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[12])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i13_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i12_3_lut (.A(tx_lvds_test_pattern[11]), .B(tx_ddr_data[9]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[11])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i12_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i11_3_lut (.A(tx_lvds_test_pattern[10]), .B(tx_ddr_data[8]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[10])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i11_3_lut.init = 16'hcaca;
    LUT4 mux_826_i2_3_lut (.A(spi_test_pattern_enable[1]), .B(tx_lvds_test_pattern[25]), 
         .C(wb_adr_o[0]), .Z(n2882)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_826_i2_3_lut.init = 16'hcaca;
    FD1S3IX wb_ack_i_237 (.D(wb_stb_o), .CK(int_clk_out), .CD(n14343), 
            .Q(wb_ack_i));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(444[8] 456[4])
    defparam wb_ack_i_237.GSR = "DISABLED";
    LUT4 tx_ddr_data_29__I_0_i10_3_lut (.A(tx_lvds_test_pattern[9]), .B(tx_ddr_data[7]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[9])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i10_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i9_3_lut (.A(tx_lvds_test_pattern[8]), .B(tx_ddr_data[6]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[8])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i9_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i8_3_lut (.A(tx_lvds_test_pattern[7]), .B(tx_ddr_data[5]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[7])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i8_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i7_3_lut (.A(tx_lvds_test_pattern[6]), .B(tx_ddr_data[4]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[6])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i7_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i6_3_lut (.A(tx_lvds_test_pattern[5]), .B(tx_ddr_data[3]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[5])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i6_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i5_3_lut (.A(tx_lvds_test_pattern[4]), .B(tx_ddr_data[2]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[4])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i5_3_lut.init = 16'hcaca;
    LUT4 mux_830_i3_3_lut (.A(tx_lvds_test_pattern[18]), .B(tx_lvds_test_pattern[10]), 
         .C(wb_adr_o[0]), .Z(n2893)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_830_i3_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i4_3_lut (.A(tx_lvds_test_pattern[3]), .B(tx_ddr_data[1]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[3])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i4_3_lut.init = 16'hcaca;
    LUT4 i10463_3_lut (.A(reg2[1]), .B(second_pll_lock), .C(wb_adr_o[0]), 
         .Z(n13457)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i10463_3_lut.init = 16'hcaca;
    LUT4 i10462_3_lut (.A(reg0[1]), .B(reg1[1]), .C(wb_adr_o[0]), .Z(n13456)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i10462_3_lut.init = 16'hcaca;
    LUT4 tx_ddr_data_29__I_0_i3_3_lut (.A(tx_lvds_test_pattern[2]), .B(tx_ddr_data[0]), 
         .C(n14293), .Z(tx_ddr_data_31__N_175[2])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(475[12] 478[6])
    defparam tx_ddr_data_29__I_0_i3_3_lut.init = 16'hcaca;
    LUT4 mux_826_i3_3_lut (.A(spi_test_pattern_enable[2]), .B(tx_lvds_test_pattern[26]), 
         .C(wb_adr_o[0]), .Z(n2881)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_826_i3_3_lut.init = 16'hcaca;
    FD1P3JX wifi_sync_check_enable_232 (.D(wb_dat_o[3]), .SP(int_clk_out_enable_212), 
            .PD(n14343), .CK(int_clk_out), .Q(wifi_sync_check_enable));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam wifi_sync_check_enable_232.GSR = "DISABLED";
    FD1P3IX subg_delay_loadn_233 (.D(wb_dat_o[0]), .SP(int_clk_out_enable_32), 
            .CD(n14343), .CK(int_clk_out), .Q(subg_delay_loadn));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam subg_delay_loadn_233.GSR = "DISABLED";
    LUT4 i1_4_lut_adj_239 (.A(tx_counter[0]), .B(tx_counter[5]), .C(n13230), 
         .D(tx_counter[7]), .Z(n13234)) /* synthesis lut_function=((B+(C+(D)))+!A) */ ;
    defparam i1_4_lut_adj_239.init = 16'hfffd;
    LUT4 i1_3_lut_4_lut_adj_240 (.A(n15), .B(n14360), .C(n14305), .D(sample_count_adj_1211[3]), 
         .Z(sample_count_next_adj_1212[3])) /* synthesis lut_function=(!(((C (D)+!C !(D))+!B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(123[9] 198[16])
    defparam i1_3_lut_4_lut_adj_240.init = 16'h0880;
    LUT4 i1_2_lut (.A(tx_counter[4]), .B(tx_counter[6]), .Z(n13230)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut.init = 16'heeee;
    LUT4 mux_822_i4_3_lut (.A(spi4_test_pattern[11]), .B(spi4_test_pattern[3]), 
         .C(wb_adr_o[0]), .Z(n2868)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_822_i4_3_lut.init = 16'hcaca;
    LUT4 mux_818_i4_3_lut (.A(spi3_test_pattern[11]), .B(spi3_test_pattern[3]), 
         .C(wb_adr_o[0]), .Z(n2856)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_818_i4_3_lut.init = 16'hcaca;
    LUT4 mux_200_i5_3_lut (.A(wifi_i_fifo_data_out[4]), .B(spi3_test_pattern[4]), 
         .C(spi_test_pattern_enable[2]), .Z(spi3_sck_N_426[4])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(780[10:79])
    defparam mux_200_i5_3_lut.init = 16'hcaca;
    LUT4 mux_818_i3_3_lut (.A(spi3_test_pattern[10]), .B(spi3_test_pattern[2]), 
         .C(wb_adr_o[0]), .Z(n2857)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_818_i3_3_lut.init = 16'hcaca;
    LUT4 n2831_bdd_3_lut_10904 (.A(n2867), .B(n2843), .C(wb_adr_o[2]), 
         .Z(n14116)) /* synthesis lut_function=(A (B+(C))+!A !((C)+!B)) */ ;
    defparam n2831_bdd_3_lut_10904.init = 16'hacac;
    LUT4 mux_814_i4_3_lut (.A(spi2_test_pattern[11]), .B(spi2_test_pattern[3]), 
         .C(wb_adr_o[0]), .Z(n2844)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_814_i4_3_lut.init = 16'hcaca;
    FD1S3AX tx_ddr_data_i31 (.D(tx_ddr_data_31__N_175[31]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[31]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i31.GSR = "ENABLED";
    LUT4 mux_810_i4_3_lut (.A(spi1_test_pattern[11]), .B(spi1_test_pattern[3]), 
         .C(wb_adr_o[0]), .Z(n2832)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_810_i4_3_lut.init = 16'hcaca;
    FD1S3AX tx_ddr_data_i30 (.D(tx_ddr_data_31__N_175[30]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[30]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i30.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i29 (.D(tx_ddr_data_31__N_175[29]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[29]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i29.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i28 (.D(tx_ddr_data_31__N_175[28]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[28]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i28.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i27 (.D(tx_ddr_data_31__N_175[27]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[27]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i27.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i26 (.D(tx_ddr_data_31__N_175[26]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[26]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i26.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i25 (.D(tx_ddr_data_31__N_175[25]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[25]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i25.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i24 (.D(tx_ddr_data_31__N_175[24]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[24]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i24.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i23 (.D(tx_ddr_data_31__N_175[23]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[23]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i23.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i22 (.D(tx_ddr_data_31__N_175[22]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[22]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i22.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i21 (.D(tx_ddr_data_31__N_175[21]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[21]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i21.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i20 (.D(tx_ddr_data_31__N_175[20]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[20]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i20.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i19 (.D(tx_ddr_data_31__N_175[19]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[19]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i19.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i18 (.D(tx_ddr_data_31__N_175[18]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[18]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i18.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i17 (.D(tx_ddr_data_31__N_175[17]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[17]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i17.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i16 (.D(tx_ddr_data_31__N_175[16]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[16]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i16.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i15 (.D(tx_ddr_data_31__N_175[15]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[15]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i15.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i14 (.D(tx_ddr_data_31__N_175[14]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[14]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i14.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i13 (.D(tx_ddr_data_31__N_175[13]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[13]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i13.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i12 (.D(tx_ddr_data_31__N_175[12]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[12]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i12.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i11 (.D(tx_ddr_data_31__N_175[11]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[11]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i11.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i10 (.D(tx_ddr_data_31__N_175[10]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[10]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i10.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i9 (.D(tx_ddr_data_31__N_175[9]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[9]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i9.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i8 (.D(tx_ddr_data_31__N_175[8]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[8]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i8.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i7 (.D(tx_ddr_data_31__N_175[7]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[7]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i7.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i6 (.D(tx_ddr_data_31__N_175[6]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[6]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i6.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i5 (.D(tx_ddr_data_31__N_175[5]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[5]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i5.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i4 (.D(tx_ddr_data_31__N_175[4]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[4]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i4.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i3 (.D(tx_ddr_data_31__N_175[3]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[3]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i3.GSR = "ENABLED";
    FD1S3AX tx_ddr_data_i2 (.D(tx_ddr_data_31__N_175[2]), .CK(internal_64MHz), 
            .Q(tx_ddr_data[2]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i2.GSR = "ENABLED";
    LUT4 n2831_bdd_3_lut_11050 (.A(n2831), .B(n2855), .C(wb_adr_o[2]), 
         .Z(n14117)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam n2831_bdd_3_lut_11050.init = 16'hcaca;
    LUT4 n14004_bdd_4_lut (.A(n14004), .B(wb_adr_o[0]), .C(wb_adr_o[2]), 
         .D(ufl_p7_sel[4]), .Z(n14119)) /* synthesis lut_function=(A (B ((D)+!C)+!B !(C))+!A (B (C (D)))) */ ;
    defparam n14004_bdd_4_lut.init = 16'hca0a;
    LUT4 mux_814_i3_3_lut (.A(spi2_test_pattern[10]), .B(spi2_test_pattern[2]), 
         .C(wb_adr_o[0]), .Z(n2845)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_814_i3_3_lut.init = 16'hcaca;
    FD1S3IX tx_ddr_data_i1 (.D(tx_lvds_test_pattern[1]), .CK(internal_64MHz), 
            .CD(n14293), .Q(tx_ddr_data[1]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(471[11] 479[5])
    defparam tx_ddr_data_i1.GSR = "ENABLED";
    FD1P3AX tx_lvds_test_pattern_i31 (.D(tx_lvds_test_pattern_31__N_119[31]), 
            .SP(int_clk_out_enable_46), .CK(int_clk_out), .Q(tx_lvds_test_pattern[31]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i31.GSR = "DISABLED";
    FD1P3IX tx_lvds_test_pattern_i30 (.D(wb_dat_o[6]), .SP(int_clk_out_enable_39), 
            .CD(n14343), .CK(int_clk_out), .Q(tx_lvds_test_pattern[30]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i30.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i29 (.D(spi3_test_pattern_15__N_83[13]), 
            .SP(int_clk_out_enable_46), .CK(int_clk_out), .Q(tx_lvds_test_pattern[29]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i29.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i28 (.D(tx_lvds_test_pattern_31__N_119[28]), 
            .SP(int_clk_out_enable_46), .CK(int_clk_out), .Q(tx_lvds_test_pattern[28]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i28.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i27 (.D(tx_lvds_test_pattern_31__N_119[27]), 
            .SP(int_clk_out_enable_46), .CK(int_clk_out), .Q(tx_lvds_test_pattern[27]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i27.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i26 (.D(tx_lvds_test_pattern_31__N_119[26]), 
            .SP(int_clk_out_enable_46), .CK(int_clk_out), .Q(tx_lvds_test_pattern[26]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i26.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i25 (.D(tx_lvds_test_pattern_31__N_119[25]), 
            .SP(int_clk_out_enable_46), .CK(int_clk_out), .Q(tx_lvds_test_pattern[25]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i25.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i24 (.D(ufl_p7_sel_7__N_35[0]), .SP(int_clk_out_enable_46), 
            .CK(int_clk_out), .Q(tx_lvds_test_pattern[24]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i24.GSR = "DISABLED";
    OB sdr_txdata_pad (.I(sdr_txdata_c), .O(sdr_txdata));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(12[14:24])
    FD1P3AX tx_lvds_test_pattern_i23 (.D(tx_lvds_test_pattern_31__N_119[31]), 
            .SP(int_clk_out_enable_53), .CK(int_clk_out), .Q(tx_lvds_test_pattern[23]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i23.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i22 (.D(tx_lvds_test_pattern_31__N_119[6]), 
            .SP(int_clk_out_enable_53), .CK(int_clk_out), .Q(tx_lvds_test_pattern[22]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i22.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i21 (.D(spi3_test_pattern_15__N_83[13]), 
            .SP(int_clk_out_enable_53), .CK(int_clk_out), .Q(tx_lvds_test_pattern[21]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i21.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i20 (.D(tx_lvds_test_pattern_31__N_119[28]), 
            .SP(int_clk_out_enable_53), .CK(int_clk_out), .Q(tx_lvds_test_pattern[20]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i20.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i19 (.D(tx_lvds_test_pattern_31__N_119[27]), 
            .SP(int_clk_out_enable_53), .CK(int_clk_out), .Q(tx_lvds_test_pattern[19]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i19.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i18 (.D(tx_lvds_test_pattern_31__N_119[26]), 
            .SP(int_clk_out_enable_53), .CK(int_clk_out), .Q(tx_lvds_test_pattern[18]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i18.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i17 (.D(tx_lvds_test_pattern_31__N_119[25]), 
            .SP(int_clk_out_enable_53), .CK(int_clk_out), .Q(tx_lvds_test_pattern[17]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i17.GSR = "DISABLED";
    FD1P3IX tx_lvds_test_pattern_i16 (.D(wb_dat_o[0]), .SP(int_clk_out_enable_54), 
            .CD(n14343), .CK(int_clk_out), .Q(tx_lvds_test_pattern[16]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i16.GSR = "DISABLED";
    FD1P3IX tx_lvds_test_pattern_i15 (.D(wb_dat_o[7]), .SP(int_clk_out_enable_55), 
            .CD(n14343), .CK(int_clk_out), .Q(tx_lvds_test_pattern[15]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i15.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i14 (.D(tx_lvds_test_pattern_31__N_119[6]), 
            .SP(int_clk_out_enable_62), .CK(int_clk_out), .Q(tx_lvds_test_pattern[14]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i14.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i13 (.D(spi3_test_pattern_15__N_83[13]), 
            .SP(int_clk_out_enable_62), .CK(int_clk_out), .Q(tx_lvds_test_pattern[13]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i13.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i12 (.D(tx_lvds_test_pattern_31__N_119[28]), 
            .SP(int_clk_out_enable_62), .CK(int_clk_out), .Q(tx_lvds_test_pattern[12]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i12.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i11 (.D(tx_lvds_test_pattern_31__N_119[27]), 
            .SP(int_clk_out_enable_62), .CK(int_clk_out), .Q(tx_lvds_test_pattern[11]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i11.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i10 (.D(tx_lvds_test_pattern_31__N_119[26]), 
            .SP(int_clk_out_enable_62), .CK(int_clk_out), .Q(tx_lvds_test_pattern[10]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i10.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i9 (.D(tx_lvds_test_pattern_31__N_119[25]), 
            .SP(int_clk_out_enable_62), .CK(int_clk_out), .Q(tx_lvds_test_pattern[9]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i9.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i8 (.D(ufl_p7_sel_7__N_35[0]), .SP(int_clk_out_enable_62), 
            .CK(int_clk_out), .Q(tx_lvds_test_pattern[8]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i8.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i7 (.D(tx_lvds_test_pattern_31__N_119[31]), 
            .SP(int_clk_out_enable_69), .CK(int_clk_out), .Q(tx_lvds_test_pattern[7]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i7.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i6 (.D(tx_lvds_test_pattern_31__N_119[6]), 
            .SP(int_clk_out_enable_69), .CK(int_clk_out), .Q(tx_lvds_test_pattern[6]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i6.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i5 (.D(spi3_test_pattern_15__N_83[13]), .SP(int_clk_out_enable_69), 
            .CK(int_clk_out), .Q(tx_lvds_test_pattern[5]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i5.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i4 (.D(tx_lvds_test_pattern_31__N_119[28]), 
            .SP(int_clk_out_enable_69), .CK(int_clk_out), .Q(tx_lvds_test_pattern[4]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i4.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i3 (.D(tx_lvds_test_pattern_31__N_119[27]), 
            .SP(int_clk_out_enable_69), .CK(int_clk_out), .Q(tx_lvds_test_pattern[3]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i3.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i2 (.D(tx_lvds_test_pattern_31__N_119[26]), 
            .SP(int_clk_out_enable_69), .CK(int_clk_out), .Q(tx_lvds_test_pattern[2]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i2.GSR = "DISABLED";
    FD1P3AX tx_lvds_test_pattern_i1 (.D(tx_lvds_test_pattern_31__N_119[25]), 
            .SP(int_clk_out_enable_69), .CK(int_clk_out), .Q(tx_lvds_test_pattern[1]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam tx_lvds_test_pattern_i1.GSR = "DISABLED";
    FD1P3IX spi4_test_pattern_i15 (.D(wb_dat_o[7]), .SP(int_clk_out_enable_77), 
            .CD(n14343), .CK(int_clk_out), .Q(spi4_test_pattern[15]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi4_test_pattern_i15.GSR = "DISABLED";
    FD1P3AX spi4_test_pattern_i14 (.D(tx_lvds_test_pattern_31__N_119[6]), 
            .SP(int_clk_out_enable_76), .CK(int_clk_out), .Q(spi4_test_pattern[14]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi4_test_pattern_i14.GSR = "DISABLED";
    FD1P3IX spi4_test_pattern_i13 (.D(wb_dat_o[5]), .SP(int_clk_out_enable_77), 
            .CD(n14343), .CK(int_clk_out), .Q(spi4_test_pattern[13]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi4_test_pattern_i13.GSR = "DISABLED";
    FD1P3AX spi4_test_pattern_i12 (.D(tx_lvds_test_pattern_31__N_119[28]), 
            .SP(int_clk_out_enable_76), .CK(int_clk_out), .Q(spi4_test_pattern[12]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi4_test_pattern_i12.GSR = "DISABLED";
    FD1P3AX spi4_test_pattern_i11 (.D(tx_lvds_test_pattern_31__N_119[27]), 
            .SP(int_clk_out_enable_76), .CK(int_clk_out), .Q(spi4_test_pattern[11]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi4_test_pattern_i11.GSR = "DISABLED";
    FD1P3IX spi4_test_pattern_i10 (.D(wb_dat_o[2]), .SP(int_clk_out_enable_77), 
            .CD(n14343), .CK(int_clk_out), .Q(spi4_test_pattern[10]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi4_test_pattern_i10.GSR = "DISABLED";
    FD1P3AX spi4_test_pattern_i9 (.D(tx_lvds_test_pattern_31__N_119[25]), 
            .SP(int_clk_out_enable_76), .CK(int_clk_out), .Q(spi4_test_pattern[9]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi4_test_pattern_i9.GSR = "DISABLED";
    FD1P3IX spi4_test_pattern_i8 (.D(wb_dat_o[0]), .SP(int_clk_out_enable_77), 
            .CD(n14343), .CK(int_clk_out), .Q(spi4_test_pattern[8]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi4_test_pattern_i8.GSR = "DISABLED";
    FD1P3IX spi4_test_pattern_i7 (.D(wb_dat_o[7]), .SP(int_clk_out_enable_83), 
            .CD(n14343), .CK(int_clk_out), .Q(spi4_test_pattern[7]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi4_test_pattern_i7.GSR = "DISABLED";
    FD1P3AX spi4_test_pattern_i6 (.D(tx_lvds_test_pattern_31__N_119[6]), .SP(int_clk_out_enable_84), 
            .CK(int_clk_out), .Q(spi4_test_pattern[6]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi4_test_pattern_i6.GSR = "DISABLED";
    FD1P3IX spi4_test_pattern_i5 (.D(wb_dat_o[5]), .SP(int_clk_out_enable_83), 
            .CD(n14343), .CK(int_clk_out), .Q(spi4_test_pattern[5]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi4_test_pattern_i5.GSR = "DISABLED";
    FD1P3AX spi4_test_pattern_i4 (.D(tx_lvds_test_pattern_31__N_119[28]), 
            .SP(int_clk_out_enable_84), .CK(int_clk_out), .Q(spi4_test_pattern[4]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi4_test_pattern_i4.GSR = "DISABLED";
    FD1P3AX spi4_test_pattern_i3 (.D(tx_lvds_test_pattern_31__N_119[27]), 
            .SP(int_clk_out_enable_84), .CK(int_clk_out), .Q(spi4_test_pattern[3]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi4_test_pattern_i3.GSR = "DISABLED";
    FD1P3IX spi4_test_pattern_i2 (.D(wb_dat_o[2]), .SP(int_clk_out_enable_83), 
            .CD(n14343), .CK(int_clk_out), .Q(spi4_test_pattern[2]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi4_test_pattern_i2.GSR = "DISABLED";
    FD1P3AX spi4_test_pattern_i1 (.D(tx_lvds_test_pattern_31__N_119[25]), 
            .SP(int_clk_out_enable_84), .CK(int_clk_out), .Q(spi4_test_pattern[1]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi4_test_pattern_i1.GSR = "DISABLED";
    FD1P3AX spi3_test_pattern_i15 (.D(tx_lvds_test_pattern_31__N_119[31]), 
            .SP(int_clk_out_enable_92), .CK(int_clk_out), .Q(spi3_test_pattern[15]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi3_test_pattern_i15.GSR = "DISABLED";
    FD1P3IX spi3_test_pattern_i14 (.D(wb_dat_o[6]), .SP(int_clk_out_enable_91), 
            .CD(n14343), .CK(int_clk_out), .Q(spi3_test_pattern[14]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi3_test_pattern_i14.GSR = "DISABLED";
    FD1P3AX spi3_test_pattern_i13 (.D(spi3_test_pattern_15__N_83[13]), .SP(int_clk_out_enable_92), 
            .CK(int_clk_out), .Q(spi3_test_pattern[13]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi3_test_pattern_i13.GSR = "DISABLED";
    FD1P3IX spi3_test_pattern_i12 (.D(wb_dat_o[4]), .SP(int_clk_out_enable_91), 
            .CD(n14343), .CK(int_clk_out), .Q(spi3_test_pattern[12]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi3_test_pattern_i12.GSR = "DISABLED";
    FD1P3IX spi3_test_pattern_i11 (.D(wb_dat_o[3]), .SP(int_clk_out_enable_91), 
            .CD(n14343), .CK(int_clk_out), .Q(spi3_test_pattern[11]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi3_test_pattern_i11.GSR = "DISABLED";
    FD1P3AX spi3_test_pattern_i10 (.D(tx_lvds_test_pattern_31__N_119[26]), 
            .SP(int_clk_out_enable_92), .CK(int_clk_out), .Q(spi3_test_pattern[10]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi3_test_pattern_i10.GSR = "DISABLED";
    FD1P3IX spi3_test_pattern_i9 (.D(wb_dat_o[1]), .SP(int_clk_out_enable_91), 
            .CD(n14343), .CK(int_clk_out), .Q(spi3_test_pattern[9]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi3_test_pattern_i9.GSR = "DISABLED";
    FD1P3AX spi3_test_pattern_i8 (.D(ufl_p7_sel_7__N_35[0]), .SP(int_clk_out_enable_92), 
            .CK(int_clk_out), .Q(spi3_test_pattern[8]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi3_test_pattern_i8.GSR = "DISABLED";
    FD1P3AX spi3_test_pattern_i7 (.D(tx_lvds_test_pattern_31__N_119[31]), 
            .SP(int_clk_out_enable_98), .CK(int_clk_out), .Q(spi3_test_pattern[7]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi3_test_pattern_i7.GSR = "DISABLED";
    FD1P3IX spi3_test_pattern_i6 (.D(wb_dat_o[6]), .SP(int_clk_out_enable_99), 
            .CD(n14343), .CK(int_clk_out), .Q(spi3_test_pattern[6]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi3_test_pattern_i6.GSR = "DISABLED";
    FD1P3AX spi3_test_pattern_i5 (.D(spi3_test_pattern_15__N_83[13]), .SP(int_clk_out_enable_98), 
            .CK(int_clk_out), .Q(spi3_test_pattern[5]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi3_test_pattern_i5.GSR = "DISABLED";
    FD1P3IX spi3_test_pattern_i4 (.D(wb_dat_o[4]), .SP(int_clk_out_enable_99), 
            .CD(n14343), .CK(int_clk_out), .Q(spi3_test_pattern[4]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi3_test_pattern_i4.GSR = "DISABLED";
    FD1P3IX spi3_test_pattern_i3 (.D(wb_dat_o[3]), .SP(int_clk_out_enable_99), 
            .CD(n14343), .CK(int_clk_out), .Q(spi3_test_pattern[3]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi3_test_pattern_i3.GSR = "DISABLED";
    FD1P3AX spi3_test_pattern_i2 (.D(tx_lvds_test_pattern_31__N_119[26]), 
            .SP(int_clk_out_enable_98), .CK(int_clk_out), .Q(spi3_test_pattern[2]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi3_test_pattern_i2.GSR = "DISABLED";
    FD1P3IX spi3_test_pattern_i1 (.D(wb_dat_o[1]), .SP(int_clk_out_enable_99), 
            .CD(n14343), .CK(int_clk_out), .Q(spi3_test_pattern[1]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi3_test_pattern_i1.GSR = "DISABLED";
    FD1P3AX spi2_test_pattern_i15 (.D(tx_lvds_test_pattern_31__N_119[31]), 
            .SP(int_clk_out_enable_106), .CK(int_clk_out), .Q(spi2_test_pattern[15]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi2_test_pattern_i15.GSR = "DISABLED";
    FD1P3IX spi2_test_pattern_i14 (.D(wb_dat_o[6]), .SP(int_clk_out_enable_107), 
            .CD(n14343), .CK(int_clk_out), .Q(spi2_test_pattern[14]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi2_test_pattern_i14.GSR = "DISABLED";
    FD1P3AX spi2_test_pattern_i13 (.D(spi3_test_pattern_15__N_83[13]), .SP(int_clk_out_enable_106), 
            .CK(int_clk_out), .Q(spi2_test_pattern[13]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi2_test_pattern_i13.GSR = "DISABLED";
    FD1P3AX spi2_test_pattern_i12 (.D(tx_lvds_test_pattern_31__N_119[28]), 
            .SP(int_clk_out_enable_106), .CK(int_clk_out), .Q(spi2_test_pattern[12]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi2_test_pattern_i12.GSR = "DISABLED";
    FD1P3AX spi2_test_pattern_i11 (.D(tx_lvds_test_pattern_31__N_119[27]), 
            .SP(int_clk_out_enable_106), .CK(int_clk_out), .Q(spi2_test_pattern[11]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi2_test_pattern_i11.GSR = "DISABLED";
    FD1P3AX spi2_test_pattern_i10 (.D(tx_lvds_test_pattern_31__N_119[26]), 
            .SP(int_clk_out_enable_106), .CK(int_clk_out), .Q(spi2_test_pattern[10]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi2_test_pattern_i10.GSR = "DISABLED";
    FD1P3AX spi2_test_pattern_i9 (.D(tx_lvds_test_pattern_31__N_119[25]), 
            .SP(int_clk_out_enable_106), .CK(int_clk_out), .Q(spi2_test_pattern[9]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi2_test_pattern_i9.GSR = "DISABLED";
    FD1P3IX spi2_test_pattern_i8 (.D(wb_dat_o[0]), .SP(int_clk_out_enable_107), 
            .CD(n14343), .CK(int_clk_out), .Q(spi2_test_pattern[8]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi2_test_pattern_i8.GSR = "DISABLED";
    FD1P3AX spi2_test_pattern_i7 (.D(tx_lvds_test_pattern_31__N_119[31]), 
            .SP(int_clk_out_enable_114), .CK(int_clk_out), .Q(spi2_test_pattern[7]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi2_test_pattern_i7.GSR = "DISABLED";
    FD1P3AX spi2_test_pattern_i6 (.D(tx_lvds_test_pattern_31__N_119[6]), .SP(int_clk_out_enable_114), 
            .CK(int_clk_out), .Q(spi2_test_pattern[6]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi2_test_pattern_i6.GSR = "DISABLED";
    FD1P3AX spi2_test_pattern_i5 (.D(spi3_test_pattern_15__N_83[13]), .SP(int_clk_out_enable_114), 
            .CK(int_clk_out), .Q(spi2_test_pattern[5]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi2_test_pattern_i5.GSR = "DISABLED";
    FD1P3IX spi2_test_pattern_i4 (.D(wb_dat_o[4]), .SP(int_clk_out_enable_111), 
            .CD(n14343), .CK(int_clk_out), .Q(spi2_test_pattern[4]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi2_test_pattern_i4.GSR = "DISABLED";
    FD1P3AX spi2_test_pattern_i3 (.D(tx_lvds_test_pattern_31__N_119[27]), 
            .SP(int_clk_out_enable_114), .CK(int_clk_out), .Q(spi2_test_pattern[3]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi2_test_pattern_i3.GSR = "DISABLED";
    FD1P3AX spi2_test_pattern_i2 (.D(tx_lvds_test_pattern_31__N_119[26]), 
            .SP(int_clk_out_enable_114), .CK(int_clk_out), .Q(spi2_test_pattern[2]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi2_test_pattern_i2.GSR = "DISABLED";
    FD1P3AX spi2_test_pattern_i1 (.D(tx_lvds_test_pattern_31__N_119[25]), 
            .SP(int_clk_out_enable_114), .CK(int_clk_out), .Q(spi2_test_pattern[1]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi2_test_pattern_i1.GSR = "DISABLED";
    FD1P3AX spi1_test_pattern_i15 (.D(tx_lvds_test_pattern_31__N_119[31]), 
            .SP(int_clk_out_enable_121), .CK(int_clk_out), .Q(spi1_test_pattern[15]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi1_test_pattern_i15.GSR = "DISABLED";
    FD1P3AX spi1_test_pattern_i14 (.D(tx_lvds_test_pattern_31__N_119[6]), 
            .SP(int_clk_out_enable_121), .CK(int_clk_out), .Q(spi1_test_pattern[14]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi1_test_pattern_i14.GSR = "DISABLED";
    FD1P3IX spi1_test_pattern_i13 (.D(wb_dat_o[5]), .SP(int_clk_out_enable_122), 
            .CD(n14343), .CK(int_clk_out), .Q(spi1_test_pattern[13]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi1_test_pattern_i13.GSR = "DISABLED";
    FD1P3AX spi1_test_pattern_i12 (.D(tx_lvds_test_pattern_31__N_119[28]), 
            .SP(int_clk_out_enable_121), .CK(int_clk_out), .Q(spi1_test_pattern[12]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi1_test_pattern_i12.GSR = "DISABLED";
    FD1P3AX spi1_test_pattern_i11 (.D(tx_lvds_test_pattern_31__N_119[27]), 
            .SP(int_clk_out_enable_121), .CK(int_clk_out), .Q(spi1_test_pattern[11]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi1_test_pattern_i11.GSR = "DISABLED";
    FD1P3AX spi1_test_pattern_i10 (.D(tx_lvds_test_pattern_31__N_119[26]), 
            .SP(int_clk_out_enable_121), .CK(int_clk_out), .Q(spi1_test_pattern[10]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi1_test_pattern_i10.GSR = "DISABLED";
    FD1P3AX spi1_test_pattern_i9 (.D(tx_lvds_test_pattern_31__N_119[25]), 
            .SP(int_clk_out_enable_121), .CK(int_clk_out), .Q(spi1_test_pattern[9]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi1_test_pattern_i9.GSR = "DISABLED";
    FD1P3IX spi1_test_pattern_i8 (.D(wb_dat_o[0]), .SP(int_clk_out_enable_122), 
            .CD(n14343), .CK(int_clk_out), .Q(spi1_test_pattern[8]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi1_test_pattern_i8.GSR = "DISABLED";
    FD1P3AX spi1_test_pattern_i7 (.D(tx_lvds_test_pattern_31__N_119[31]), 
            .SP(int_clk_out_enable_128), .CK(int_clk_out), .Q(spi1_test_pattern[7]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi1_test_pattern_i7.GSR = "DISABLED";
    FD1P3IX spi1_test_pattern_i6 (.D(wb_dat_o[6]), .SP(int_clk_out_enable_129), 
            .CD(n14343), .CK(int_clk_out), .Q(spi1_test_pattern[6]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi1_test_pattern_i6.GSR = "DISABLED";
    FD1P3AX spi1_test_pattern_i5 (.D(spi3_test_pattern_15__N_83[13]), .SP(int_clk_out_enable_128), 
            .CK(int_clk_out), .Q(spi1_test_pattern[5]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi1_test_pattern_i5.GSR = "DISABLED";
    FD1P3IX spi1_test_pattern_i4 (.D(wb_dat_o[4]), .SP(int_clk_out_enable_129), 
            .CD(n14343), .CK(int_clk_out), .Q(spi1_test_pattern[4]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi1_test_pattern_i4.GSR = "DISABLED";
    FD1P3AX spi1_test_pattern_i3 (.D(tx_lvds_test_pattern_31__N_119[27]), 
            .SP(int_clk_out_enable_128), .CK(int_clk_out), .Q(spi1_test_pattern[3]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi1_test_pattern_i3.GSR = "DISABLED";
    FD1P3AX spi1_test_pattern_i2 (.D(tx_lvds_test_pattern_31__N_119[26]), 
            .SP(int_clk_out_enable_128), .CK(int_clk_out), .Q(spi1_test_pattern[2]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi1_test_pattern_i2.GSR = "DISABLED";
    FD1P3IX spi1_test_pattern_i1 (.D(wb_dat_o[1]), .SP(int_clk_out_enable_129), 
            .CD(n14343), .CK(int_clk_out), .Q(spi1_test_pattern[1]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam spi1_test_pattern_i1.GSR = "DISABLED";
    FD1P3IX ufl_p8_sel_i7 (.D(wb_dat_o[7]), .SP(int_clk_out_enable_136), 
            .CD(n14343), .CK(int_clk_out), .Q(ufl_p8_sel[7]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam ufl_p8_sel_i7.GSR = "DISABLED";
    FD1P3IX ufl_p8_sel_i6 (.D(wb_dat_o[6]), .SP(int_clk_out_enable_136), 
            .CD(n14343), .CK(int_clk_out), .Q(ufl_p8_sel[6]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam ufl_p8_sel_i6.GSR = "DISABLED";
    FD1P3IX ufl_p8_sel_i5 (.D(wb_dat_o[5]), .SP(int_clk_out_enable_136), 
            .CD(n14343), .CK(int_clk_out), .Q(ufl_p8_sel[5]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam ufl_p8_sel_i5.GSR = "DISABLED";
    FD1P3IX ufl_p8_sel_i4 (.D(wb_dat_o[4]), .SP(int_clk_out_enable_136), 
            .CD(n14343), .CK(int_clk_out), .Q(ufl_p8_sel[4]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam ufl_p8_sel_i4.GSR = "DISABLED";
    FD1P3AX ufl_p8_sel_i3 (.D(tx_lvds_test_pattern_31__N_119[27]), .SP(int_clk_out_enable_134), 
            .CK(int_clk_out), .Q(ufl_p8_sel[3]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam ufl_p8_sel_i3.GSR = "DISABLED";
    FD1P3IX ufl_p8_sel_i2 (.D(wb_dat_o[2]), .SP(int_clk_out_enable_136), 
            .CD(n14343), .CK(int_clk_out), .Q(ufl_p8_sel[2]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam ufl_p8_sel_i2.GSR = "DISABLED";
    FD1P3IX ufl_p8_sel_i1 (.D(wb_dat_o[1]), .SP(int_clk_out_enable_136), 
            .CD(n14343), .CK(int_clk_out), .Q(ufl_p8_sel[1]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam ufl_p8_sel_i1.GSR = "DISABLED";
    FD1P3IX ufl_p7_sel_i7 (.D(wb_dat_o[7]), .SP(int_clk_out_enable_141), 
            .CD(n14343), .CK(int_clk_out), .Q(ufl_p7_sel[7]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam ufl_p7_sel_i7.GSR = "DISABLED";
    FD1P3IX ufl_p7_sel_i6 (.D(wb_dat_o[6]), .SP(int_clk_out_enable_141), 
            .CD(n14343), .CK(int_clk_out), .Q(ufl_p7_sel[6]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam ufl_p7_sel_i6.GSR = "DISABLED";
    FD1P3IX ufl_p7_sel_i5 (.D(wb_dat_o[5]), .SP(int_clk_out_enable_141), 
            .CD(n14343), .CK(int_clk_out), .Q(ufl_p7_sel[5]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam ufl_p7_sel_i5.GSR = "DISABLED";
    FD1P3IX ufl_p7_sel_i4 (.D(wb_dat_o[4]), .SP(int_clk_out_enable_141), 
            .CD(n14343), .CK(int_clk_out), .Q(ufl_p7_sel[4]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam ufl_p7_sel_i4.GSR = "DISABLED";
    FD1P3IX ufl_p7_sel_i3 (.D(wb_dat_o[3]), .SP(int_clk_out_enable_141), 
            .CD(n14343), .CK(int_clk_out), .Q(ufl_p7_sel[3]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam ufl_p7_sel_i3.GSR = "DISABLED";
    FD1P3AX ufl_p7_sel_i2 (.D(tx_lvds_test_pattern_31__N_119[26]), .SP(int_clk_out_enable_143), 
            .CK(int_clk_out), .Q(ufl_p7_sel[2]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam ufl_p7_sel_i2.GSR = "DISABLED";
    FD1P3AX ufl_p7_sel_i1 (.D(tx_lvds_test_pattern_31__N_119[25]), .SP(int_clk_out_enable_143), 
            .CK(int_clk_out), .Q(ufl_p7_sel[1]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam ufl_p7_sel_i1.GSR = "DISABLED";
    FD1P3IX reg0__i7 (.D(wb_dat_o[7]), .SP(int_clk_out_enable_150), .CD(n14343), 
            .CK(int_clk_out), .Q(reg0[7]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg0__i7.GSR = "DISABLED";
    PFUMX i10486 (.BLUT(n2832), .ALUT(n2844), .C0(wb_adr_o[1]), .Z(n13480));
    FD1P3IX reg0__i6 (.D(wb_dat_o[6]), .SP(int_clk_out_enable_150), .CD(n14343), 
            .CK(int_clk_out), .Q(reg0[6]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg0__i6.GSR = "DISABLED";
    FD1P3IX reg0__i5 (.D(wb_dat_o[5]), .SP(int_clk_out_enable_150), .CD(n14343), 
            .CK(int_clk_out), .Q(reg0[5]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg0__i5.GSR = "DISABLED";
    FD1P3IX reg0__i4 (.D(wb_dat_o[4]), .SP(int_clk_out_enable_150), .CD(n14343), 
            .CK(int_clk_out), .Q(reg0[4]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg0__i4.GSR = "DISABLED";
    FD1P3IX reg0__i3 (.D(wb_dat_o[3]), .SP(int_clk_out_enable_150), .CD(n14343), 
            .CK(int_clk_out), .Q(reg0[3]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg0__i3.GSR = "DISABLED";
    FD1P3IX reg0__i2 (.D(wb_dat_o[2]), .SP(int_clk_out_enable_150), .CD(n14343), 
            .CK(int_clk_out), .Q(reg0[2]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg0__i2.GSR = "DISABLED";
    FD1P3IX reg0__i1 (.D(wb_dat_o[1]), .SP(int_clk_out_enable_150), .CD(n14343), 
            .CK(int_clk_out), .Q(reg0[1]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg0__i1.GSR = "DISABLED";
    FD1S3IX wb_dat_i__i7 (.D(data_mux[7]), .CK(int_clk_out), .CD(n14343), 
            .Q(wb_dat_i[7]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(444[8] 456[4])
    defparam wb_dat_i__i7.GSR = "DISABLED";
    FD1S3IX wb_dat_i__i6 (.D(data_mux[6]), .CK(int_clk_out), .CD(n14343), 
            .Q(wb_dat_i[6]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(444[8] 456[4])
    defparam wb_dat_i__i6.GSR = "DISABLED";
    FD1S3IX wb_dat_i__i5 (.D(data_mux[5]), .CK(int_clk_out), .CD(n14343), 
            .Q(wb_dat_i[5]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(444[8] 456[4])
    defparam wb_dat_i__i5.GSR = "DISABLED";
    FD1S3IX wb_dat_i__i4 (.D(data_mux[4]), .CK(int_clk_out), .CD(n14343), 
            .Q(wb_dat_i[4]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(444[8] 456[4])
    defparam wb_dat_i__i4.GSR = "DISABLED";
    FD1S3IX wb_dat_i__i3 (.D(data_mux[3]), .CK(int_clk_out), .CD(n14343), 
            .Q(wb_dat_i[3]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(444[8] 456[4])
    defparam wb_dat_i__i3.GSR = "DISABLED";
    FD1S3IX wb_dat_i__i2 (.D(data_mux[2]), .CK(int_clk_out), .CD(n14343), 
            .Q(wb_dat_i[2]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(444[8] 456[4])
    defparam wb_dat_i__i2.GSR = "DISABLED";
    FD1S3IX wb_dat_i__i1 (.D(data_mux[1]), .CK(int_clk_out), .CD(n14343), 
            .Q(wb_dat_i[1]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(444[8] 456[4])
    defparam wb_dat_i__i1.GSR = "DISABLED";
    LUT4 mux_810_i3_3_lut (.A(spi1_test_pattern[10]), .B(spi1_test_pattern[2]), 
         .C(wb_adr_o[0]), .Z(n2833)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_810_i3_3_lut.init = 16'hcaca;
    L6MUX21 i10505 (.D0(n13497), .D1(n13498), .SD(wb_adr_o[3]), .Z(n13499));
    PFUMX i10479 (.BLUT(n2833), .ALUT(n2845), .C0(wb_adr_o[1]), .Z(n13473));
    OB rf_sel_0_pad (.I(VCC_net), .O(rf_sel_0));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(19[14:22])
    OB rf_sel_1_pad (.I(VCC_net), .O(rf_sel_1));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(20[14:22])
    OB rf_sel_2_pad (.I(GND_net), .O(rf_sel_2));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(21[14:22])
    OB rf_sel_3_pad (.I(GND_net), .O(rf_sel_3));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(22[14:22])
    OB subg_fem_sel0_pad (.I(VCC_net), .O(subg_fem_sel0));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(23[14:27])
    OB subg_fem_sel1_pad (.I(GND_net), .O(subg_fem_sel1));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(24[14:27])
    OB wifi_fem_sel0_pad (.I(GND_net), .O(wifi_fem_sel0));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(25[14:27])
    OB wifi_fem_sel1_pad (.I(VCC_net), .O(wifi_fem_sel1));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(26[14:27])
    OB wifi_fem_csd_pad (.I(GND_net), .O(wifi_fem_csd));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(29[14:26])
    OB wifi_fem_cps_pad (.I(GND_net), .O(wifi_fem_cps));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(30[14:26])
    OB wifi_fem_crx_pad (.I(GND_net), .O(wifi_fem_crx));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(31[14:26])
    OB wifi_fem_ctx_pad (.I(GND_net), .O(wifi_fem_ctx));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(32[14:26])
    OB wifi_fem_chl_pad (.I(GND_net), .O(wifi_fem_chl));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(33[14:26])
    OB subg_fem_cps_pad (.I(GND_net), .O(subg_fem_cps));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(36[14:26])
    OB subg_fem_ctx_pad (.I(GND_net), .O(subg_fem_ctx));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(37[14:26])
    OB subg_fem_csd_pad (.I(GND_net), .O(subg_fem_csd));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(38[14:26])
    OB spi1_sck_pad (.I(spi1_sck_c), .O(spi1_sck));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(43[14:22])
    OB spi1_mosi_pad (.I(spi1_mosi_c), .O(spi1_mosi));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(44[14:23])
    OB spi2_sck_pad (.I(spi2_sck_c), .O(spi2_sck));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(48[14:22])
    OB spi2_mosi_pad (.I(spi2_mosi_c), .O(spi2_mosi));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(49[14:23])
    OB spi3_sck_pad (.I(spi3_sck_c), .O(spi3_sck));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(55[14:22])
    OB spi3_mosi_pad (.I(spi3_mosi_c), .O(spi3_mosi));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(56[14:23])
    OB spi4_sck_pad (.I(spi4_sck_c), .O(spi4_sck));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(60[14:22])
    OB spi4_mosi_pad (.I(spi4_mosi_c), .O(spi4_mosi));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(61[14:23])
    OB fpga_ufl_p7_pad (.I(sdr_rxclk_c), .O(fpga_ufl_p7));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(66[14:25])
    OB fpga_ufl_p8_pad (.I(fpga_ufl_p8_c_c), .O(fpga_ufl_p8));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(67[14:25])
    IB dpll_clkout2_pad (.I(dpll_clkout2), .O(dpll_clkout2_c));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(5[13:25])
    IB dpll_clkout0_pad (.I(dpll_clkout0), .O(dpll_clkout0_c));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(6[13:25])
    IB sdr_rx_wifi_pad (.I(sdr_rx_wifi), .O(sdr_rx_wifi_c));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(8[13:24])
    IB fpga_ufl_p8_c_pad (.I(sdr_rx_subg), .O(fpga_ufl_p8_c_c));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(9[13:24])
    IB sdr_rxclk_pad (.I(sdr_rxclk), .O(sdr_rxclk_c));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(10[13:22])
    IB stm_fpga_spare1_pad (.I(stm_fpga_spare1), .O(stm_fpga_spare1_c));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(52[13:28])
    IB stm_fpga_spare2_pad (.I(stm_fpga_spare2), .O(stm_fpga_spare2_c));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(64[13:28])
    IB stm_fpga_spare5_pad (.I(stm_fpga_spare5), .O(stm_fpga_spare5_c));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(69[13:28])
    VLO i1 (.Z(GND_net));
    LUT4 mux_200_i6_3_lut (.A(wifi_i_fifo_data_out[5]), .B(spi3_test_pattern[5]), 
         .C(spi_test_pattern_enable[2]), .Z(spi3_sck_N_426[5])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(780[10:79])
    defparam mux_200_i6_3_lut.init = 16'hcaca;
    LUT4 mux_199_i1_3_lut (.A(subg_q_fifo_data_out[0]), .B(spi2_test_pattern[0]), 
         .C(spi_test_pattern_enable[1]), .Z(spi2_sck_N_410[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(769[10:79])
    defparam mux_199_i1_3_lut.init = 16'hcaca;
    L6MUX21 i10909 (.D0(n14120), .D1(n14118), .SD(wb_adr_o[3]), .Z(n14121));
    L6MUX21 i10476 (.D0(n13468), .D1(n13469), .SD(wb_adr_o[3]), .Z(n13470));
    PFUMX i10907 (.BLUT(n14119), .ALUT(n14002), .C0(wb_adr_o[1]), .Z(n14120));
    L6MUX21 i10483 (.D0(n13475), .D1(n13476), .SD(wb_adr_o[3]), .Z(n13477));
    LUT4 mux_200_i7_3_lut (.A(wifi_i_fifo_data_out[6]), .B(spi3_test_pattern[6]), 
         .C(spi_test_pattern_enable[2]), .Z(spi3_sck_N_426[6])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(780[10:79])
    defparam mux_200_i7_3_lut.init = 16'hcaca;
    PFUMX i10905 (.BLUT(n14117), .ALUT(n14116), .C0(wb_adr_o[1]), .Z(n14118));
    PFUMX i10487 (.BLUT(n2856), .ALUT(n2868), .C0(wb_adr_o[1]), .Z(n13481));
    PFUMX i10480 (.BLUT(n2857), .ALUT(n2869), .C0(wb_adr_o[1]), .Z(n13474));
    L6MUX21 i10902 (.D0(n14114), .D1(n14112), .SD(wb_adr_o[3]), .Z(n14115));
    PFUMX i10900 (.BLUT(n14113), .ALUT(n14019), .C0(wb_adr_o[1]), .Z(n14114));
    LUT4 mux_806_i3_3_lut (.A(ufl_p8_sel[2]), .B(subg_sync_check_enable), 
         .C(wb_adr_o[0]), .Z(n2821)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_806_i3_3_lut.init = 16'hcaca;
    LUT4 mux_200_i8_3_lut (.A(wifi_i_fifo_data_out[7]), .B(spi3_test_pattern[7]), 
         .C(spi_test_pattern_enable[2]), .Z(spi3_sck_N_426[7])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(780[10:79])
    defparam mux_200_i8_3_lut.init = 16'hcaca;
    PUR PUR_INST (.PUR(VCC_net));
    defparam PUR_INST.RST_PULSE = 1;
    PFUMX i10898 (.BLUT(n14111), .ALUT(n14110), .C0(wb_adr_o[1]), .Z(n14112));
    L6MUX21 i10893 (.D0(n14105), .D1(n14103), .SD(wb_adr_o[3]), .Z(n14106));
    L6MUX21 i10503 (.D0(n13493), .D1(n13494), .SD(wb_adr_o[2]), .Z(n13497));
    L6MUX21 i10504 (.D0(n13495), .D1(n13496), .SD(wb_adr_o[2]), .Z(n13498));
    PFUMX i10891 (.BLUT(n14104), .ALUT(n14029), .C0(wb_adr_o[1]), .Z(n14105));
    PFUMX i10889 (.BLUT(n14102), .ALUT(n14101), .C0(wb_adr_o[1]), .Z(n14103));
    FD1P3IX reg1__i1 (.D(wb_dat_o[1]), .SP(int_clk_out_enable_164), .CD(n14343), 
            .CK(int_clk_out), .Q(reg1[1]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg1__i1.GSR = "DISABLED";
    LUT4 i2006_1_lut (.A(r_state_adj_1205[0]), .Z(n1)) /* synthesis lut_function=(!(A)) */ ;
    defparam i2006_1_lut.init = 16'h5555;
    PFUMX i10470 (.BLUT(n13456), .ALUT(n13457), .C0(wb_adr_o[1]), .Z(n13464));
    LUT4 mux_198_i2_3_lut (.A(subg_i_fifo_data_out[1]), .B(spi1_test_pattern[1]), 
         .C(spi_test_pattern_enable[0]), .Z(spi1_sck_N_394[1])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(759[11:80])
    defparam mux_198_i2_3_lut.init = 16'hcaca;
    LUT4 i1_3_lut_adj_241 (.A(n12153), .B(n12156), .C(n3020), .Z(data_mux[0])) /* synthesis lut_function=(A+((C)+!B)) */ ;
    defparam i1_3_lut_adj_241.init = 16'hfbfb;
    FD1P3IX reg1__i2 (.D(wb_dat_o[2]), .SP(int_clk_out_enable_164), .CD(n14343), 
            .CK(int_clk_out), .Q(reg1[2]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg1__i2.GSR = "DISABLED";
    FD1P3IX reg1__i3 (.D(wb_dat_o[3]), .SP(int_clk_out_enable_164), .CD(n14343), 
            .CK(int_clk_out), .Q(reg1[3]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg1__i3.GSR = "DISABLED";
    FD1P3IX reg1__i4 (.D(wb_dat_o[4]), .SP(int_clk_out_enable_164), .CD(n14343), 
            .CK(int_clk_out), .Q(reg1[4]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg1__i4.GSR = "DISABLED";
    FD1P3IX reg1__i5 (.D(wb_dat_o[5]), .SP(int_clk_out_enable_164), .CD(n14343), 
            .CK(int_clk_out), .Q(reg1[5]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg1__i5.GSR = "DISABLED";
    FD1P3IX reg1__i6 (.D(wb_dat_o[6]), .SP(int_clk_out_enable_164), .CD(n14343), 
            .CK(int_clk_out), .Q(reg1[6]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg1__i6.GSR = "DISABLED";
    FD1P3IX reg1__i7 (.D(wb_dat_o[7]), .SP(int_clk_out_enable_164), .CD(n14343), 
            .CK(int_clk_out), .Q(reg1[7]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg1__i7.GSR = "DISABLED";
    FD1P3IX reg2__i1 (.D(wb_dat_o[1]), .SP(int_clk_out_enable_171), .CD(n14343), 
            .CK(int_clk_out), .Q(reg2[1]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg2__i1.GSR = "DISABLED";
    LUT4 mux_198_i3_3_lut (.A(subg_i_fifo_data_out[2]), .B(spi1_test_pattern[2]), 
         .C(spi_test_pattern_enable[0]), .Z(spi1_sck_N_394[2])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(759[11:80])
    defparam mux_198_i3_3_lut.init = 16'hcaca;
    LUT4 mux_198_i4_3_lut (.A(subg_i_fifo_data_out[3]), .B(spi1_test_pattern[3]), 
         .C(spi_test_pattern_enable[0]), .Z(spi1_sck_N_394[3])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(759[11:80])
    defparam mux_198_i4_3_lut.init = 16'hcaca;
    FD1P3IX reg2__i2 (.D(wb_dat_o[2]), .SP(int_clk_out_enable_171), .CD(n14343), 
            .CK(int_clk_out), .Q(reg2[2]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg2__i2.GSR = "DISABLED";
    FD1P3IX reg2__i3 (.D(wb_dat_o[3]), .SP(int_clk_out_enable_171), .CD(n14343), 
            .CK(int_clk_out), .Q(reg2[3]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg2__i3.GSR = "DISABLED";
    FD1P3IX reg2__i4 (.D(wb_dat_o[4]), .SP(int_clk_out_enable_171), .CD(n14343), 
            .CK(int_clk_out), .Q(reg2[4]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg2__i4.GSR = "DISABLED";
    FD1P3IX reg2__i5 (.D(wb_dat_o[5]), .SP(int_clk_out_enable_171), .CD(n14343), 
            .CK(int_clk_out), .Q(reg2[5]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg2__i5.GSR = "DISABLED";
    FD1P3IX reg2__i6 (.D(wb_dat_o[6]), .SP(int_clk_out_enable_171), .CD(n14343), 
            .CK(int_clk_out), .Q(reg2[6]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg2__i6.GSR = "DISABLED";
    FD1P3IX reg2__i7 (.D(wb_dat_o[7]), .SP(int_clk_out_enable_171), .CD(n14343), 
            .CK(int_clk_out), .Q(reg2[7]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam reg2__i7.GSR = "DISABLED";
    LUT4 mux_198_i5_3_lut (.A(subg_i_fifo_data_out[4]), .B(spi1_test_pattern[4]), 
         .C(spi_test_pattern_enable[0]), .Z(spi1_sck_N_394[4])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(759[11:80])
    defparam mux_198_i5_3_lut.init = 16'hcaca;
    LUT4 mux_806_i4_3_lut (.A(ufl_p8_sel[3]), .B(wifi_sync_check_enable), 
         .C(wb_adr_o[0]), .Z(n2820)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_806_i4_3_lut.init = 16'hcaca;
    LUT4 i1_rep_46_4_lut (.A(n11664), .B(n12168), .C(n9012), .D(n11601), 
         .Z(n12156)) /* synthesis lut_function=(!(A (B+(C+!(D)))+!A (C))) */ ;
    defparam i1_rep_46_4_lut.init = 16'h0705;
    LUT4 mux_198_i6_3_lut (.A(subg_i_fifo_data_out[5]), .B(spi1_test_pattern[5]), 
         .C(spi_test_pattern_enable[0]), .Z(spi1_sck_N_394[5])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(759[11:80])
    defparam mux_198_i6_3_lut.init = 16'hcaca;
    LUT4 i6166_2_lut (.A(ufl_p7_sel[3]), .B(wb_adr_o[0]), .Z(n2808)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam i6166_2_lut.init = 16'h8888;
    LUT4 mux_198_i7_3_lut (.A(subg_i_fifo_data_out[6]), .B(spi1_test_pattern[6]), 
         .C(spi_test_pattern_enable[0]), .Z(spi1_sck_N_394[6])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(759[11:80])
    defparam mux_198_i7_3_lut.init = 16'hcaca;
    LUT4 mux_198_i8_3_lut (.A(subg_i_fifo_data_out[7]), .B(spi1_test_pattern[7]), 
         .C(spi_test_pattern_enable[0]), .Z(spi1_sck_N_394[7])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(759[11:80])
    defparam mux_198_i8_3_lut.init = 16'hcaca;
    L6MUX21 i10475 (.D0(n13466), .D1(n13467), .SD(wb_adr_o[2]), .Z(n13469));
    LUT4 i8719_2_lut (.A(wb_adr_o[4]), .B(wb_adr_o[5]), .Z(n11664)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i8719_2_lut.init = 16'heeee;
    LUT4 i10636_3_lut_3_lut (.A(wb_adr_o[4]), .B(n14093), .C(n14400), 
         .Z(n2993)) /* synthesis lut_function=(A (C)+!A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(394[3:11])
    defparam i10636_3_lut_3_lut.init = 16'he4e4;
    LUT4 mux_198_i9_3_lut (.A(subg_i_fifo_data_out[8]), .B(spi1_test_pattern[8]), 
         .C(spi_test_pattern_enable[0]), .Z(spi1_sck_N_394[8])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(759[11:80])
    defparam mux_198_i9_3_lut.init = 16'hcaca;
    LUT4 i10632_3_lut_3_lut (.A(wb_adr_o[4]), .B(n14115), .C(n14403), 
         .Z(n2995)) /* synthesis lut_function=(A (C)+!A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(394[3:11])
    defparam i10632_3_lut_3_lut.init = 16'he4e4;
    L6MUX21 i10883 (.D0(n14092), .D1(n14090), .SD(wb_adr_o[3]), .Z(n14093));
    LUT4 i10630_3_lut_3_lut (.A(wb_adr_o[4]), .B(n14121), .C(n14409), 
         .Z(n2996)) /* synthesis lut_function=(A (C)+!A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(394[3:11])
    defparam i10630_3_lut_3_lut.init = 16'he4e4;
    LUT4 i10404_3_lut_3_lut (.A(wb_adr_o[4]), .B(n13477), .C(n13395), 
         .Z(n13396)) /* synthesis lut_function=(A (C)+!A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(394[3:11])
    defparam i10404_3_lut_3_lut.init = 16'he4e4;
    LUT4 i10397_3_lut_3_lut (.A(wb_adr_o[4]), .B(n13499), .C(subg_delay_loadn), 
         .Z(n13389)) /* synthesis lut_function=(A (C)+!A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(394[3:11])
    defparam i10397_3_lut_3_lut.init = 16'he4e4;
    LUT4 subg_i_empty_I_0_1_lut (.A(subg_i_empty), .Z(subg_i_empty_N_227)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(724[41:54])
    defparam subg_i_empty_I_0_1_lut.init = 16'h5555;
    LUT4 i10634_3_lut_3_lut (.A(wb_adr_o[4]), .B(n14106), .C(n14397), 
         .Z(n2994)) /* synthesis lut_function=(A (C)+!A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(394[3:11])
    defparam i10634_3_lut_3_lut.init = 16'he4e4;
    LUT4 i10401_3_lut_3_lut (.A(wb_adr_o[4]), .B(n13470), .C(n13392), 
         .Z(n13393)) /* synthesis lut_function=(A (C)+!A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(394[3:11])
    defparam i10401_3_lut_3_lut.init = 16'he4e4;
    LUT4 mux_198_i10_3_lut (.A(subg_i_fifo_data_out[9]), .B(spi1_test_pattern[9]), 
         .C(spi_test_pattern_enable[0]), .Z(spi1_sck_N_394[9])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(759[11:80])
    defparam mux_198_i10_3_lut.init = 16'hcaca;
    LUT4 mux_198_i11_3_lut (.A(subg_i_fifo_data_out[10]), .B(spi1_test_pattern[10]), 
         .C(spi_test_pattern_enable[0]), .Z(spi1_sck_N_394[10])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(759[11:80])
    defparam mux_198_i11_3_lut.init = 16'hcaca;
    LUT4 i1_3_lut_4_lut_4_lut (.A(wb_adr_o[4]), .B(n14352), .C(wb_adr_o[1]), 
         .D(wb_adr_o[0]), .Z(n12964)) /* synthesis lut_function=(!(A+(B+!(C (D))))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(394[3:11])
    defparam i1_3_lut_4_lut_4_lut.init = 16'h1000;
    LUT4 mux_198_i12_3_lut (.A(subg_i_fifo_data_out[11]), .B(spi1_test_pattern[11]), 
         .C(spi_test_pattern_enable[0]), .Z(spi1_sck_N_394[11])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(759[11:80])
    defparam mux_198_i12_3_lut.init = 16'hcaca;
    PFUMX i10477 (.BLUT(n2770), .ALUT(n2797), .C0(wb_adr_o[1]), .Z(n13471));
    LUT4 mux_198_i13_3_lut (.A(subg_i_fifo_data_out[12]), .B(spi1_test_pattern[12]), 
         .C(spi_test_pattern_enable[0]), .Z(spi1_sck_N_394[12])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(759[11:80])
    defparam mux_198_i13_3_lut.init = 16'hcaca;
    LUT4 i6061_2_lut (.A(wb_adr_o[7]), .B(wb_adr_o[6]), .Z(n9012)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i6061_2_lut.init = 16'heeee;
    L6MUX21 i10481 (.D0(n13471), .D1(n13472), .SD(wb_adr_o[2]), .Z(n13475));
    L6MUX21 i10482 (.D0(n13473), .D1(n13474), .SD(wb_adr_o[2]), .Z(n13476));
    LUT4 mux_198_i14_3_lut (.A(subg_i_fifo_data_out[13]), .B(spi1_test_pattern[13]), 
         .C(spi_test_pattern_enable[0]), .Z(spi1_sck_N_394[13])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(759[11:80])
    defparam mux_198_i14_3_lut.init = 16'hcaca;
    LUT4 mux_198_i15_3_lut (.A(subg_i_fifo_data_out[14]), .B(spi1_test_pattern[14]), 
         .C(spi_test_pattern_enable[0]), .Z(spi1_sck_N_394[14])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(759[11:80])
    defparam mux_198_i15_3_lut.init = 16'hcaca;
    PFUMX i10881 (.BLUT(n14091), .ALUT(n14056), .C0(wb_adr_o[1]), .Z(n14092));
    LUT4 mux_198_i16_3_lut (.A(subg_i_fifo_data_out[15]), .B(spi1_test_pattern[15]), 
         .C(spi_test_pattern_enable[0]), .Z(spi1_sck_N_394[15])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(759[11:80])
    defparam mux_198_i16_3_lut.init = 16'hcaca;
    PFUMX i10396 (.BLUT(n2883), .ALUT(n2895), .C0(wb_adr_o[1]), .Z(n13388));
    LUT4 mux_199_i2_3_lut (.A(subg_q_fifo_data_out[1]), .B(spi2_test_pattern[1]), 
         .C(spi_test_pattern_enable[1]), .Z(spi2_sck_N_410[1])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(769[10:79])
    defparam mux_199_i2_3_lut.init = 16'hcaca;
    LUT4 mux_199_i3_3_lut (.A(subg_q_fifo_data_out[2]), .B(spi2_test_pattern[2]), 
         .C(spi_test_pattern_enable[1]), .Z(spi2_sck_N_410[2])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(769[10:79])
    defparam mux_199_i3_3_lut.init = 16'hcaca;
    LUT4 mux_199_i4_3_lut (.A(subg_q_fifo_data_out[3]), .B(spi2_test_pattern[3]), 
         .C(spi_test_pattern_enable[1]), .Z(spi2_sck_N_410[3])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(769[10:79])
    defparam mux_199_i4_3_lut.init = 16'hcaca;
    PFUMX i10471 (.BLUT(n13458), .ALUT(n13459), .C0(wb_adr_o[1]), .Z(n13465));
    LUT4 mux_199_i5_3_lut (.A(subg_q_fifo_data_out[4]), .B(spi2_test_pattern[4]), 
         .C(spi_test_pattern_enable[1]), .Z(spi2_sck_N_410[4])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(769[10:79])
    defparam mux_199_i5_3_lut.init = 16'hcaca;
    LUT4 mux_199_i6_3_lut (.A(subg_q_fifo_data_out[5]), .B(spi2_test_pattern[5]), 
         .C(spi_test_pattern_enable[1]), .Z(spi2_sck_N_410[5])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(769[10:79])
    defparam mux_199_i6_3_lut.init = 16'hcaca;
    PFUMX i10879 (.BLUT(n14089), .ALUT(n14088), .C0(wb_adr_o[1]), .Z(n14090));
    LUT4 mux_199_i7_3_lut (.A(subg_q_fifo_data_out[6]), .B(spi2_test_pattern[6]), 
         .C(spi_test_pattern_enable[1]), .Z(spi2_sck_N_410[6])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(769[10:79])
    defparam mux_199_i7_3_lut.init = 16'hcaca;
    L6MUX21 i10474 (.D0(n13464), .D1(n13465), .SD(wb_adr_o[2]), .Z(n13468));
    FD1S3IX tx_counter_1302__i1 (.D(n44), .CK(internal_64MHz), .CD(n7334), 
            .Q(tx_counter[1])) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(476[18:32])
    defparam tx_counter_1302__i1.GSR = "ENABLED";
    LUT4 mux_199_i8_3_lut (.A(subg_q_fifo_data_out[7]), .B(spi2_test_pattern[7]), 
         .C(spi_test_pattern_enable[1]), .Z(spi2_sck_N_410[7])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(769[10:79])
    defparam mux_199_i8_3_lut.init = 16'hcaca;
    PFUMX i10499 (.BLUT(n13485), .ALUT(n13486), .C0(wb_adr_o[1]), .Z(n13493));
    FD1S3IX tx_counter_1302__i2 (.D(n43), .CK(internal_64MHz), .CD(n7334), 
            .Q(tx_counter[2])) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(476[18:32])
    defparam tx_counter_1302__i2.GSR = "ENABLED";
    FD1S3IX tx_counter_1302__i3 (.D(n42), .CK(internal_64MHz), .CD(n7334), 
            .Q(tx_counter[3])) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(476[18:32])
    defparam tx_counter_1302__i3.GSR = "ENABLED";
    FD1S3IX tx_counter_1302__i4 (.D(n41), .CK(internal_64MHz), .CD(n7334), 
            .Q(tx_counter[4])) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(476[18:32])
    defparam tx_counter_1302__i4.GSR = "ENABLED";
    FD1S3IX tx_counter_1302__i5 (.D(n40), .CK(internal_64MHz), .CD(n7334), 
            .Q(tx_counter[5])) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(476[18:32])
    defparam tx_counter_1302__i5.GSR = "ENABLED";
    FD1S3IX tx_counter_1302__i6 (.D(n39), .CK(internal_64MHz), .CD(n7334), 
            .Q(tx_counter[6])) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(476[18:32])
    defparam tx_counter_1302__i6.GSR = "ENABLED";
    FD1S3IX tx_counter_1302__i7 (.D(n38), .CK(internal_64MHz), .CD(n7334), 
            .Q(tx_counter[7])) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(476[18:32])
    defparam tx_counter_1302__i7.GSR = "ENABLED";
    LUT4 mux_199_i9_3_lut (.A(subg_q_fifo_data_out[8]), .B(spi2_test_pattern[8]), 
         .C(spi_test_pattern_enable[1]), .Z(spi2_sck_N_410[8])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(769[10:79])
    defparam mux_199_i9_3_lut.init = 16'hcaca;
    LUT4 i10400_4_lut (.A(tx_lvds_test_pattern[1]), .B(subg_delay_move), 
         .C(wb_adr_o[1]), .D(wb_adr_o[0]), .Z(n13392)) /* synthesis lut_function=(A (B (C+!(D))+!B !(C+(D)))+!A (B (C))) */ ;
    defparam i10400_4_lut.init = 16'hc0ca;
    LUT4 mux_199_i10_3_lut (.A(subg_q_fifo_data_out[9]), .B(spi2_test_pattern[9]), 
         .C(spi_test_pattern_enable[1]), .Z(spi2_sck_N_410[9])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(769[10:79])
    defparam mux_199_i10_3_lut.init = 16'hcaca;
    LUT4 mux_199_i11_3_lut (.A(subg_q_fifo_data_out[10]), .B(spi2_test_pattern[10]), 
         .C(spi_test_pattern_enable[1]), .Z(spi2_sck_N_410[10])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(769[10:79])
    defparam mux_199_i11_3_lut.init = 16'hcaca;
    LUT4 mux_198_i1_3_lut (.A(subg_i_fifo_data_out[0]), .B(spi1_test_pattern[0]), 
         .C(spi_test_pattern_enable[0]), .Z(spi1_sck_N_394[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(759[11:80])
    defparam mux_198_i1_3_lut.init = 16'hcaca;
    LUT4 mux_199_i12_3_lut (.A(subg_q_fifo_data_out[11]), .B(spi2_test_pattern[11]), 
         .C(spi_test_pattern_enable[1]), .Z(spi2_sck_N_410[11])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(769[10:79])
    defparam mux_199_i12_3_lut.init = 16'hcaca;
    LUT4 mux_199_i13_3_lut (.A(subg_q_fifo_data_out[12]), .B(spi2_test_pattern[12]), 
         .C(spi_test_pattern_enable[1]), .Z(spi2_sck_N_410[12])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(769[10:79])
    defparam mux_199_i13_3_lut.init = 16'hcaca;
    LUT4 mux_199_i14_3_lut (.A(subg_q_fifo_data_out[13]), .B(spi2_test_pattern[13]), 
         .C(spi_test_pattern_enable[1]), .Z(spi2_sck_N_410[13])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(769[10:79])
    defparam mux_199_i14_3_lut.init = 16'hcaca;
    PFUMX i10500 (.BLUT(n13487), .ALUT(n13488), .C0(wb_adr_o[1]), .Z(n13494));
    LUT4 mux_199_i15_3_lut (.A(subg_q_fifo_data_out[14]), .B(spi2_test_pattern[14]), 
         .C(spi_test_pattern_enable[1]), .Z(spi2_sck_N_410[14])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(769[10:79])
    defparam mux_199_i15_3_lut.init = 16'hcaca;
    LUT4 mux_199_i16_3_lut (.A(subg_q_fifo_data_out[15]), .B(spi2_test_pattern[15]), 
         .C(spi_test_pattern_enable[1]), .Z(spi2_sck_N_410[15])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(769[10:79])
    defparam mux_199_i16_3_lut.init = 16'hcaca;
    LUT4 i1_4_lut_adj_242 (.A(n13162), .B(n11958), .C(n14384), .D(n13180), 
         .Z(int_clk_out_enable_32)) /* synthesis lut_function=(!((B+!(C (D)))+!A)) */ ;
    defparam i1_4_lut_adj_242.init = 16'h2000;
    LUT4 i1_4_lut_adj_243 (.A(n14354), .B(n14356), .C(wb_adr_o[6]), .D(n14345), 
         .Z(n13162)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i1_4_lut_adj_243.init = 16'h0100;
    PFUMX i10501 (.BLUT(n13489), .ALUT(n13490), .C0(wb_adr_o[1]), .Z(n13495));
    LUT4 mux_200_i2_3_lut (.A(wifi_i_fifo_data_out[1]), .B(spi3_test_pattern[1]), 
         .C(spi_test_pattern_enable[2]), .Z(spi3_sck_N_426[1])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(780[10:79])
    defparam mux_200_i2_3_lut.init = 16'hcaca;
    LUT4 i6165_2_lut (.A(ufl_p7_sel[2]), .B(wb_adr_o[0]), .Z(n2809)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam i6165_2_lut.init = 16'h8888;
    CCU2C tx_counter_1302_add_4_9 (.A0(tx_counter[7]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(GND_net), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n10827), .S0(n38));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(476[18:32])
    defparam tx_counter_1302_add_4_9.INIT0 = 16'haaa0;
    defparam tx_counter_1302_add_4_9.INIT1 = 16'h0000;
    defparam tx_counter_1302_add_4_9.INJECT1_0 = "NO";
    defparam tx_counter_1302_add_4_9.INJECT1_1 = "NO";
    CCU2C tx_counter_1302_add_4_3 (.A0(tx_counter[1]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(tx_counter[2]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n10824), .COUT(n10825), .S0(n44), .S1(n43));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(476[18:32])
    defparam tx_counter_1302_add_4_3.INIT0 = 16'haaa0;
    defparam tx_counter_1302_add_4_3.INIT1 = 16'haaa0;
    defparam tx_counter_1302_add_4_3.INJECT1_0 = "NO";
    defparam tx_counter_1302_add_4_3.INJECT1_1 = "NO";
    CCU2C tx_counter_1302_add_4_7 (.A0(tx_counter[5]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(tx_counter[6]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n10826), .COUT(n10827), .S0(n40), .S1(n39));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(476[18:32])
    defparam tx_counter_1302_add_4_7.INIT0 = 16'haaa0;
    defparam tx_counter_1302_add_4_7.INIT1 = 16'haaa0;
    defparam tx_counter_1302_add_4_7.INJECT1_0 = "NO";
    defparam tx_counter_1302_add_4_7.INJECT1_1 = "NO";
    CCU2C tx_counter_1302_add_4_1 (.A0(GND_net), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(tx_counter[0]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .COUT(n10824), .S1(n45));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(476[18:32])
    defparam tx_counter_1302_add_4_1.INIT0 = 16'h0000;
    defparam tx_counter_1302_add_4_1.INIT1 = 16'h555f;
    defparam tx_counter_1302_add_4_1.INJECT1_0 = "NO";
    defparam tx_counter_1302_add_4_1.INJECT1_1 = "NO";
    CCU2C tx_counter_1302_add_4_5 (.A0(tx_counter[3]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(tx_counter[4]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n10825), .COUT(n10826), .S0(n42), .S1(n41));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(476[18:32])
    defparam tx_counter_1302_add_4_5.INIT0 = 16'haaa0;
    defparam tx_counter_1302_add_4_5.INIT1 = 16'haaa0;
    defparam tx_counter_1302_add_4_5.INJECT1_0 = "NO";
    defparam tx_counter_1302_add_4_5.INJECT1_1 = "NO";
    LUT4 mux_200_i3_3_lut (.A(wifi_i_fifo_data_out[2]), .B(spi3_test_pattern[2]), 
         .C(spi_test_pattern_enable[2]), .Z(spi3_sck_N_426[2])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(780[10:79])
    defparam mux_200_i3_3_lut.init = 16'hcaca;
    PFUMX i10502 (.BLUT(n13491), .ALUT(n13492), .C0(wb_adr_o[1]), .Z(n13496));
    LUT4 mux_200_i4_3_lut (.A(wifi_i_fifo_data_out[3]), .B(spi3_test_pattern[3]), 
         .C(spi_test_pattern_enable[2]), .Z(spi3_sck_N_426[3])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(780[10:79])
    defparam mux_200_i4_3_lut.init = 16'hcaca;
    L6MUX21 i11226 (.D0(n14914), .D1(n14910), .SD(wb_adr_o[4]), .Z(n14915));
    LUT4 mux_200_i9_3_lut (.A(wifi_i_fifo_data_out[8]), .B(spi3_test_pattern[8]), 
         .C(spi_test_pattern_enable[2]), .Z(spi3_sck_N_426[8])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(780[10:79])
    defparam mux_200_i9_3_lut.init = 16'hcaca;
    LUT4 i1_2_lut_3_lut_4_lut_4_lut (.A(wb_adr_o[2]), .B(wb_adr_o[0]), .C(wb_adr_o[1]), 
         .D(n14330), .Z(n12798)) /* synthesis lut_function=(!(A+(B+!(C (D))))) */ ;
    defparam i1_2_lut_3_lut_4_lut_4_lut.init = 16'h1000;
    PFUMX i11224 (.BLUT(n14913), .ALUT(n14911), .C0(wb_adr_o[3]), .Z(n14914));
    LUT4 i1_3_lut_4_lut_4_lut_adj_244 (.A(wb_adr_o[2]), .B(wb_adr_o[0]), 
         .C(wb_adr_o[1]), .D(n13302), .Z(n12812)) /* synthesis lut_function=(!(A+((C+(D))+!B))) */ ;
    defparam i1_3_lut_4_lut_4_lut_adj_244.init = 16'h0004;
    LUT4 mux_830_i5_3_lut (.A(tx_lvds_test_pattern[20]), .B(tx_lvds_test_pattern[12]), 
         .C(wb_adr_o[0]), .Z(n2891)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_830_i5_3_lut.init = 16'hcaca;
    LUT4 n54_bdd_4_lut_then_4_lut (.A(wb_adr_o[0]), .B(tx_lvds_test_pattern[30]), 
         .C(wb_adr_o[2]), .D(wb_adr_o[1]), .Z(n14396)) /* synthesis lut_function=(!(A ((C)+!B)+!A ((D)+!C))) */ ;
    defparam n54_bdd_4_lut_then_4_lut.init = 16'h0858;
    LUT4 n54_bdd_4_lut_else_4_lut (.A(wb_adr_o[0]), .B(tx_lvds_test_pattern[30]), 
         .C(wb_adr_o[2]), .Z(n14395)) /* synthesis lut_function=(!(((C)+!B)+!A)) */ ;
    defparam n54_bdd_4_lut_else_4_lut.init = 16'h0808;
    LUT4 n54_bdd_4_lut_10982_then_4_lut (.A(wb_adr_o[0]), .B(tx_lvds_test_pattern[31]), 
         .C(wb_adr_o[2]), .D(wb_adr_o[1]), .Z(n14399)) /* synthesis lut_function=(!(A ((C)+!B)+!A ((D)+!C))) */ ;
    defparam n54_bdd_4_lut_10982_then_4_lut.init = 16'h0858;
    LUT4 n54_bdd_4_lut_10982_else_4_lut (.A(wb_adr_o[0]), .B(tx_lvds_test_pattern[31]), 
         .C(wb_adr_o[2]), .Z(n14398)) /* synthesis lut_function=(!(((C)+!B)+!A)) */ ;
    defparam n54_bdd_4_lut_10982_else_4_lut.init = 16'h0808;
    LUT4 i10403_4_lut (.A(tx_lvds_test_pattern[2]), .B(subg_delay_direction), 
         .C(wb_adr_o[1]), .D(wb_adr_o[0]), .Z(n13395)) /* synthesis lut_function=(A (B (C+!(D))+!B !(C+(D)))+!A (B (C))) */ ;
    defparam i10403_4_lut.init = 16'hc0ca;
    LUT4 mux_830_i6_3_lut (.A(tx_lvds_test_pattern[21]), .B(tx_lvds_test_pattern[13]), 
         .C(wb_adr_o[0]), .Z(n2890)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_830_i6_3_lut.init = 16'hcaca;
    LUT4 n54_bdd_4_lut_10981_then_4_lut (.A(wb_adr_o[0]), .B(tx_lvds_test_pattern[29]), 
         .C(wb_adr_o[2]), .D(wb_adr_o[1]), .Z(n14402)) /* synthesis lut_function=(!(A ((C)+!B)+!A ((D)+!C))) */ ;
    defparam n54_bdd_4_lut_10981_then_4_lut.init = 16'h0858;
    LUT4 n54_bdd_4_lut_10981_else_4_lut (.A(wb_adr_o[0]), .B(tx_lvds_test_pattern[29]), 
         .C(wb_adr_o[2]), .Z(n14401)) /* synthesis lut_function=(!(((C)+!B)+!A)) */ ;
    defparam n54_bdd_4_lut_10981_else_4_lut.init = 16'h0808;
    LUT4 i10734_2_lut (.A(wb_adr_o[4]), .B(wb_adr_o[1]), .Z(n13411)) /* synthesis lut_function=((B)+!A) */ ;
    defparam i10734_2_lut.init = 16'hdddd;
    fifo_dc_16in_16out_U5 subg_i_fifo_dc (.sdr_rxclk_c(sdr_rxclk_c), .internal_80MHz(internal_80MHz), 
            .rRst(rRst), .subg_i_empty(subg_i_empty), .VCC_net(VCC_net), 
            .GND_net(GND_net), .w_rx_09_fifo_push(w_rx_09_fifo_push), .subg_i_empty_N_227(subg_i_empty_N_227), 
            .\w_rx_09_fifo_data[31] (w_rx_09_fifo_data[31]), .\w_rx_09_fifo_data[30] (w_rx_09_fifo_data[30]), 
            .\w_rx_09_fifo_data[29] (w_rx_09_fifo_data[29]), .\w_rx_09_fifo_data[28] (w_rx_09_fifo_data[28]), 
            .\w_rx_09_fifo_data[27] (w_rx_09_fifo_data[27]), .\w_rx_09_fifo_data[26] (w_rx_09_fifo_data[26]), 
            .\w_rx_09_fifo_data[25] (w_rx_09_fifo_data[25]), .\w_rx_09_fifo_data[24] (w_rx_09_fifo_data[24]), 
            .\w_rx_09_fifo_data[23] (w_rx_09_fifo_data[23]), .\w_rx_09_fifo_data[22] (w_rx_09_fifo_data[22]), 
            .\w_rx_09_fifo_data[21] (w_rx_09_fifo_data[21]), .\w_rx_09_fifo_data[20] (w_rx_09_fifo_data[20]), 
            .\w_rx_09_fifo_data[19] (w_rx_09_fifo_data[19]), .\w_rx_09_fifo_data[18] (w_rx_09_fifo_data[18]), 
            .\w_rx_09_fifo_data[17] (w_rx_09_fifo_data[17]), .\w_rx_09_fifo_data[16] (w_rx_09_fifo_data[16]), 
            .main_reset_n_N_208(main_reset_n_N_208), .subg_i_fifo_data_out({subg_i_fifo_data_out})) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(647[20] 658[2])
    LUT4 n54_bdd_4_lut_10980_then_4_lut (.A(wb_adr_o[0]), .B(tx_lvds_test_pattern[28]), 
         .C(wb_adr_o[2]), .D(wb_adr_o[1]), .Z(n14408)) /* synthesis lut_function=(!(A ((C)+!B)+!A ((D)+!C))) */ ;
    defparam n54_bdd_4_lut_10980_then_4_lut.init = 16'h0858;
    LUT4 n54_bdd_4_lut_10980_else_4_lut (.A(wb_adr_o[0]), .B(tx_lvds_test_pattern[28]), 
         .C(wb_adr_o[2]), .Z(n14407)) /* synthesis lut_function=(!(((C)+!B)+!A)) */ ;
    defparam n54_bdd_4_lut_10980_else_4_lut.init = 16'h0808;
    LUT4 mux_830_i7_3_lut (.A(tx_lvds_test_pattern[22]), .B(tx_lvds_test_pattern[14]), 
         .C(wb_adr_o[0]), .Z(n2889)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_830_i7_3_lut.init = 16'hcaca;
    LUT4 mux_200_i10_3_lut (.A(wifi_i_fifo_data_out[9]), .B(spi3_test_pattern[9]), 
         .C(spi_test_pattern_enable[2]), .Z(spi3_sck_N_426[9])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(780[10:79])
    defparam mux_200_i10_3_lut.init = 16'hcaca;
    LUT4 mux_830_i8_3_lut (.A(tx_lvds_test_pattern[23]), .B(tx_lvds_test_pattern[15]), 
         .C(wb_adr_o[0]), .Z(n2888)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_830_i8_3_lut.init = 16'hcaca;
    PFUMX i10472 (.BLUT(n13460), .ALUT(n13461), .C0(wb_adr_o[1]), .Z(n13466));
    LUT4 mux_200_i11_3_lut (.A(wifi_i_fifo_data_out[10]), .B(spi3_test_pattern[10]), 
         .C(spi_test_pattern_enable[2]), .Z(spi3_sck_N_426[10])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(780[10:79])
    defparam mux_200_i11_3_lut.init = 16'hcaca;
    PFUMX i11222 (.BLUT(n14909), .ALUT(n14908), .C0(wb_adr_o[2]), .Z(n14910));
    LUT4 mux_200_i12_3_lut (.A(wifi_i_fifo_data_out[11]), .B(spi3_test_pattern[11]), 
         .C(spi_test_pattern_enable[2]), .Z(spi3_sck_N_426[11])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(780[10:79])
    defparam mux_200_i12_3_lut.init = 16'hcaca;
    LUT4 mux_200_i13_3_lut (.A(wifi_i_fifo_data_out[12]), .B(spi3_test_pattern[12]), 
         .C(spi_test_pattern_enable[2]), .Z(spi3_sck_N_426[12])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(780[10:79])
    defparam mux_200_i13_3_lut.init = 16'hcaca;
    LUT4 i10710_3_lut (.A(wb_adr_o[4]), .B(wb_adr_o[2]), .C(wb_adr_o[1]), 
         .Z(n13453)) /* synthesis lut_function=((B+!(C))+!A) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam i10710_3_lut.init = 16'hdfdf;
    LUT4 mux_200_i14_3_lut (.A(wifi_i_fifo_data_out[13]), .B(spi3_test_pattern[13]), 
         .C(spi_test_pattern_enable[2]), .Z(spi3_sck_N_426[13])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(780[10:79])
    defparam mux_200_i14_3_lut.init = 16'hcaca;
    LUT4 i10714_4_lut (.A(n12902), .B(n14316), .C(candidate_sr[30]), .D(n12896), 
         .Z(match_count_next[0])) /* synthesis lut_function=(!(A+((C+(D))+!B))) */ ;
    defparam i10714_4_lut.init = 16'h0004;
    LUT4 mux_200_i15_3_lut (.A(wifi_i_fifo_data_out[14]), .B(spi3_test_pattern[14]), 
         .C(spi_test_pattern_enable[2]), .Z(spi3_sck_N_426[14])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(780[10:79])
    defparam mux_200_i15_3_lut.init = 16'hcaca;
    LUT4 mux_834_i1_3_lut (.A(tx_lvds_test_pattern[0]), .B(tx_lvds_test_pattern_enable), 
         .C(wb_adr_o[0]), .Z(n2907)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_834_i1_3_lut.init = 16'hcaca;
    LUT4 i1_4_lut_adj_245 (.A(n102), .B(sr[16]), .C(r_state[1]), .D(match_count[0]), 
         .Z(n12896)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_adj_245.init = 16'hfffe;
    LUT4 i1_4_lut_rep_209 (.A(tx_counter[2]), .B(n13234), .C(tx_counter[1]), 
         .D(tx_counter[3]), .Z(n14293)) /* synthesis lut_function=((B+!(C (D)))+!A) */ ;
    defparam i1_4_lut_rep_209.init = 16'hdfff;
    LUT4 i4370_1_lut_4_lut (.A(tx_counter[2]), .B(n13234), .C(tx_counter[1]), 
         .D(tx_counter[3]), .Z(n7334)) /* synthesis lut_function=(!((B+!(C (D)))+!A)) */ ;
    defparam i4370_1_lut_4_lut.init = 16'h2000;
    LUT4 reg0_4__bdd_3_lut_11054 (.A(reg0[4]), .B(wb_adr_o[0]), .C(reg1[4]), 
         .Z(n14004)) /* synthesis lut_function=(A ((C)+!B)+!A (B (C))) */ ;
    defparam reg0_4__bdd_3_lut_11054.init = 16'he2e2;
    LUT4 mux_200_i16_3_lut (.A(wifi_i_fifo_data_out[15]), .B(spi3_test_pattern[15]), 
         .C(spi_test_pattern_enable[2]), .Z(spi3_sck_N_426[15])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(780[10:79])
    defparam mux_200_i16_3_lut.init = 16'hcaca;
    LUT4 i1_3_lut_4_lut_adj_246 (.A(n14315), .B(n14365), .C(sample_count[0]), 
         .D(sample_count[1]), .Z(sample_count_next[1])) /* synthesis lut_function=(!(((C (D)+!C !(D))+!B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(123[9] 198[16])
    defparam i1_3_lut_4_lut_adj_246.init = 16'h0880;
    LUT4 mux_201_i1_3_lut (.A(wifi_q_fifo_data_out[0]), .B(spi4_test_pattern[0]), 
         .C(spi_test_pattern_enable[3]), .Z(spi4_sck_N_442[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(790[10:79])
    defparam mux_201_i1_3_lut.init = 16'hcaca;
    LUT4 mux_201_i2_3_lut (.A(wifi_q_fifo_data_out[1]), .B(spi4_test_pattern[1]), 
         .C(spi_test_pattern_enable[3]), .Z(spi4_sck_N_442[1])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(790[10:79])
    defparam mux_201_i2_3_lut.init = 16'hcaca;
    LUT4 mux_201_i3_3_lut (.A(wifi_q_fifo_data_out[2]), .B(spi4_test_pattern[2]), 
         .C(spi_test_pattern_enable[3]), .Z(spi4_sck_N_442[2])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(790[10:79])
    defparam mux_201_i3_3_lut.init = 16'hcaca;
    LUT4 mux_201_i4_3_lut (.A(wifi_q_fifo_data_out[3]), .B(spi4_test_pattern[3]), 
         .C(spi_test_pattern_enable[3]), .Z(spi4_sck_N_442[3])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(790[10:79])
    defparam mux_201_i4_3_lut.init = 16'hcaca;
    LUT4 mux_201_i5_3_lut (.A(wifi_q_fifo_data_out[4]), .B(spi4_test_pattern[4]), 
         .C(spi_test_pattern_enable[3]), .Z(spi4_sck_N_442[4])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(790[10:79])
    defparam mux_201_i5_3_lut.init = 16'hcaca;
    LUT4 mux_200_i1_3_lut (.A(wifi_i_fifo_data_out[0]), .B(spi3_test_pattern[0]), 
         .C(spi_test_pattern_enable[2]), .Z(spi3_sck_N_426[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(780[10:79])
    defparam mux_200_i1_3_lut.init = 16'hcaca;
    LUT4 mux_201_i6_3_lut (.A(wifi_q_fifo_data_out[5]), .B(spi4_test_pattern[5]), 
         .C(spi_test_pattern_enable[3]), .Z(spi4_sck_N_442[5])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(790[10:79])
    defparam mux_201_i6_3_lut.init = 16'hcaca;
    LUT4 i10699_2_lut (.A(wb_adr_o[4]), .B(wb_adr_o[2]), .Z(n13431)) /* synthesis lut_function=((B)+!A) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam i10699_2_lut.init = 16'hdddd;
    LUT4 i1_3_lut_4_lut_adj_247 (.A(n14315), .B(n14365), .C(n14304), .D(sample_count[3]), 
         .Z(sample_count_next[3])) /* synthesis lut_function=(!(((C (D)+!C !(D))+!B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(123[9] 198[16])
    defparam i1_3_lut_4_lut_adj_247.init = 16'h0880;
    LUT4 mux_201_i7_3_lut (.A(wifi_q_fifo_data_out[6]), .B(spi4_test_pattern[6]), 
         .C(spi_test_pattern_enable[3]), .Z(spi4_sck_N_442[6])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(790[10:79])
    defparam mux_201_i7_3_lut.init = 16'hcaca;
    LUT4 i10626_3_lut (.A(n2881), .B(n2893), .C(wb_adr_o[1]), .Z(n13394)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam i10626_3_lut.init = 16'hcaca;
    PFUMX i10473 (.BLUT(n13462), .ALUT(n13463), .C0(wb_adr_o[1]), .Z(n13467));
    LUT4 mux_201_i8_3_lut (.A(wifi_q_fifo_data_out[7]), .B(spi4_test_pattern[7]), 
         .C(spi_test_pattern_enable[3]), .Z(spi4_sck_N_442[7])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(790[10:79])
    defparam mux_201_i8_3_lut.init = 16'hcaca;
    LUT4 mux_201_i9_3_lut (.A(wifi_q_fifo_data_out[8]), .B(spi4_test_pattern[8]), 
         .C(spi_test_pattern_enable[3]), .Z(spi4_sck_N_442[8])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(790[10:79])
    defparam mux_201_i9_3_lut.init = 16'hcaca;
    LUT4 i1_3_lut_4_lut_adj_248 (.A(n14315), .B(n14365), .C(n14337), .D(sample_count[2]), 
         .Z(sample_count_next[2])) /* synthesis lut_function=(!(((C (D)+!C !(D))+!B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(123[9] 198[16])
    defparam i1_3_lut_4_lut_adj_248.init = 16'h0880;
    LUT4 mux_201_i10_3_lut (.A(wifi_q_fifo_data_out[9]), .B(spi4_test_pattern[9]), 
         .C(spi_test_pattern_enable[3]), .Z(spi4_sck_N_442[9])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(790[10:79])
    defparam mux_201_i10_3_lut.init = 16'hcaca;
    LUT4 mux_201_i11_3_lut (.A(wifi_q_fifo_data_out[10]), .B(spi4_test_pattern[10]), 
         .C(spi_test_pattern_enable[3]), .Z(spi4_sck_N_442[10])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(790[10:79])
    defparam mux_201_i11_3_lut.init = 16'hcaca;
    LUT4 mux_201_i12_3_lut (.A(wifi_q_fifo_data_out[11]), .B(spi4_test_pattern[11]), 
         .C(spi_test_pattern_enable[3]), .Z(spi4_sck_N_442[11])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(790[10:79])
    defparam mux_201_i12_3_lut.init = 16'hcaca;
    LUT4 mux_201_i13_3_lut (.A(wifi_q_fifo_data_out[12]), .B(spi4_test_pattern[12]), 
         .C(spi_test_pattern_enable[3]), .Z(spi4_sck_N_442[12])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(790[10:79])
    defparam mux_201_i13_3_lut.init = 16'hcaca;
    LUT4 mux_201_i14_3_lut (.A(wifi_q_fifo_data_out[13]), .B(spi4_test_pattern[13]), 
         .C(spi_test_pattern_enable[3]), .Z(spi4_sck_N_442[13])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(790[10:79])
    defparam mux_201_i14_3_lut.init = 16'hcaca;
    LUT4 mux_201_i15_3_lut (.A(wifi_q_fifo_data_out[14]), .B(spi4_test_pattern[14]), 
         .C(spi_test_pattern_enable[3]), .Z(spi4_sck_N_442[14])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(790[10:79])
    defparam mux_201_i15_3_lut.init = 16'hcaca;
    LUT4 mux_201_i16_3_lut (.A(wifi_q_fifo_data_out[15]), .B(spi4_test_pattern[15]), 
         .C(spi_test_pattern_enable[3]), .Z(spi4_sck_N_442[15])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(790[10:79])
    defparam mux_201_i16_3_lut.init = 16'hcaca;
    LUT4 mux_814_i8_3_lut (.A(spi2_test_pattern[15]), .B(spi2_test_pattern[7]), 
         .C(wb_adr_o[0]), .Z(n2840)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_814_i8_3_lut.init = 16'hcaca;
    LUT4 mux_810_i8_3_lut (.A(spi1_test_pattern[15]), .B(spi1_test_pattern[7]), 
         .C(wb_adr_o[0]), .Z(n2828)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_810_i8_3_lut.init = 16'hcaca;
    LUT4 i10469_3_lut (.A(spi4_test_pattern[9]), .B(spi4_test_pattern[1]), 
         .C(wb_adr_o[0]), .Z(n13463)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i10469_3_lut.init = 16'hcaca;
    LUT4 mux_822_i8_3_lut (.A(spi4_test_pattern[15]), .B(spi4_test_pattern[7]), 
         .C(wb_adr_o[0]), .Z(n2864)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_822_i8_3_lut.init = 16'hcaca;
    LUT4 mux_822_i7_3_lut (.A(spi4_test_pattern[14]), .B(spi4_test_pattern[6]), 
         .C(wb_adr_o[0]), .Z(n2865)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_822_i7_3_lut.init = 16'hcaca;
    LUT4 mux_818_i7_3_lut (.A(spi3_test_pattern[14]), .B(spi3_test_pattern[6]), 
         .C(wb_adr_o[0]), .Z(n2853)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_818_i7_3_lut.init = 16'hcaca;
    LUT4 mux_814_i7_3_lut (.A(spi2_test_pattern[14]), .B(spi2_test_pattern[6]), 
         .C(wb_adr_o[0]), .Z(n2841)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_814_i7_3_lut.init = 16'hcaca;
    LUT4 m0_lut (.Z(n14917)) /* synthesis lut_function=0, syn_instantiated=1 */ ;
    defparam m0_lut.init = 16'h0000;
    LUT4 mux_810_i7_3_lut (.A(spi1_test_pattern[14]), .B(spi1_test_pattern[6]), 
         .C(wb_adr_o[0]), .Z(n2829)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_810_i7_3_lut.init = 16'hcaca;
    LUT4 i1_4_lut_adj_249 (.A(sample_count[7]), .B(n14294), .C(sample_count[6]), 
         .D(n14268), .Z(sample_count_next[7])) /* synthesis lut_function=(!(A ((C (D))+!B)+!A !(B (C (D))))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(123[9] 198[16])
    defparam i1_4_lut_adj_249.init = 16'h4888;
    LUT4 mux_822_i6_3_lut (.A(spi4_test_pattern[13]), .B(spi4_test_pattern[5]), 
         .C(wb_adr_o[0]), .Z(n2866)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_822_i6_3_lut.init = 16'hcaca;
    LUT4 reg0_5__bdd_3_lut_11067 (.A(reg0[5]), .B(wb_adr_o[0]), .C(reg1[5]), 
         .Z(n14021)) /* synthesis lut_function=(A ((C)+!B)+!A (B (C))) */ ;
    defparam reg0_5__bdd_3_lut_11067.init = 16'he2e2;
    LUT4 mux_818_i6_3_lut (.A(spi3_test_pattern[13]), .B(spi3_test_pattern[5]), 
         .C(wb_adr_o[0]), .Z(n2854)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_818_i6_3_lut.init = 16'hcaca;
    word_align_3state_U6 lvds_rx_09_inst (.sample_count({Open_0, Open_1, 
            Open_2, Open_3, Open_4, Open_5, sample_count[1:0]}), .n14337(n14337), 
            .n14294(n14294), .\sample_count[6] (sample_count[6]), .r_state({r_state}), 
            .n12902(n12902), .sr({Open_6, Open_7, Open_8, Open_9, 
            Open_10, Open_11, Open_12, Open_13, Open_14, Open_15, 
            Open_16, Open_17, Open_18, Open_19, Open_20, Open_21, 
            sr[16], Open_22, Open_23, Open_24, Open_25, Open_26, 
            Open_27, Open_28, Open_29, Open_30, Open_31, Open_32, 
            Open_33, Open_34, Open_35, Open_36, Open_37}), .n11488(n11488), 
            .n13204(n13204), .\sample_count[2] (sample_count[2]), .\sample_count[3] (sample_count[3]), 
            .sdr_rxclk_c(sdr_rxclk_c), .i_ddr_data({w_lvds_rx_09_d0, w_lvds_rx_09_d1}), 
            .n14315(n14315), .r_candidate_offset(r_candidate_offset), .\candidate_sr[30] (candidate_sr[30]), 
            .n14316(n14316), .sdr_rxclk_c_enable_88(sdr_rxclk_c_enable_88), 
            .\sample_count_next[0] (sample_count_next[0]), .n13401(n13401), 
            .w_rx_09_fifo_data({w_rx_09_fifo_data}), .n14304(n14304), .n14268(n14268), 
            .real_candidate(real_candidate), .\match_count[1] (match_count[1]), 
            .n102(n102), .\sample_count[7] (sample_count[7]), .\sample_count_next[1] (sample_count_next[1]), 
            .n14363(n14363), .\match_count_next[1] (match_count_next[1]), 
            .n14917(n14917), .\sample_count_next[7] (sample_count_next[7]), 
            .w_rx_09_fifo_push(w_rx_09_fifo_push), .n11591(n11591), .\match_count[0] (match_count[0]), 
            .\match_count_next[0] (match_count_next[0]), .\sample_count_next[3] (sample_count_next[3]), 
            .\sample_count_next[2] (sample_count_next[2])) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(622[19] 629[2])
    LUT4 mux_818_i8_3_lut (.A(spi3_test_pattern[15]), .B(spi3_test_pattern[7]), 
         .C(wb_adr_o[0]), .Z(n2852)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_818_i8_3_lut.init = 16'hcaca;
    LUT4 i10468_3_lut (.A(spi3_test_pattern[9]), .B(spi3_test_pattern[1]), 
         .C(wb_adr_o[0]), .Z(n13462)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i10468_3_lut.init = 16'hcaca;
    LUT4 i1_2_lut_rep_261 (.A(wb_adr_o[2]), .B(wb_adr_o[4]), .Z(n14345)) /* synthesis lut_function=(A (B)) */ ;
    defparam i1_2_lut_rep_261.init = 16'h8888;
    LUT4 reg0_6__bdd_3_lut_11099 (.A(reg0[6]), .B(wb_adr_o[0]), .C(reg1[6]), 
         .Z(n14031)) /* synthesis lut_function=(A ((C)+!B)+!A (B (C))) */ ;
    defparam reg0_6__bdd_3_lut_11099.init = 16'he2e2;
    LUT4 mux_814_i6_3_lut (.A(spi2_test_pattern[13]), .B(spi2_test_pattern[5]), 
         .C(wb_adr_o[0]), .Z(n2842)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_814_i6_3_lut.init = 16'hcaca;
    LUT4 mux_810_i6_3_lut (.A(spi1_test_pattern[13]), .B(spi1_test_pattern[5]), 
         .C(wb_adr_o[0]), .Z(n2830)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_810_i6_3_lut.init = 16'hcaca;
    LUT4 i10405_3_lut (.A(spi_test_pattern_enable[3]), .B(tx_lvds_test_pattern[27]), 
         .C(wb_adr_o[0]), .Z(n13397)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i10405_3_lut.init = 16'hcaca;
    LUT4 i10624_3_lut (.A(n2882), .B(n2894), .C(wb_adr_o[1]), .Z(n13391)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam i10624_3_lut.init = 16'hcaca;
    LUT4 i1_2_lut_3_lut_adj_250 (.A(wb_adr_o[2]), .B(wb_adr_o[4]), .C(wb_adr_o[0]), 
         .Z(n13044)) /* synthesis lut_function=(A (B (C))) */ ;
    defparam i1_2_lut_3_lut_adj_250.init = 16'h8080;
    LUT4 i10408_4_lut (.A(bus_addressed), .B(state_reg_adj_1301[0]), .C(n13324), 
         .D(n14324), .Z(n13400)) /* synthesis lut_function=(A (B+!((D)+!C))+!A (B ((D)+!C))) */ ;
    defparam i10408_4_lut.init = 16'hccac;
    LUT4 mux_822_i5_3_lut (.A(spi4_test_pattern[12]), .B(spi4_test_pattern[4]), 
         .C(wb_adr_o[0]), .Z(n2867)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_822_i5_3_lut.init = 16'hcaca;
    LUT4 mux_818_i5_3_lut (.A(spi3_test_pattern[12]), .B(spi3_test_pattern[4]), 
         .C(wb_adr_o[0]), .Z(n2855)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_818_i5_3_lut.init = 16'hcaca;
    FD1S3IX tx_counter_1302__i0 (.D(n45), .CK(internal_64MHz), .CD(n7334), 
            .Q(tx_counter[0])) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(476[18:32])
    defparam tx_counter_1302__i0.GSR = "ENABLED";
    fifo_dc_16in_16out_U1 wifi_i_fifo_dc (.sdr_rxclk_c(sdr_rxclk_c), .internal_80MHz(internal_80MHz), 
            .rRst(rRst), .wifi_i_empty(wifi_i_empty), .GND_net(GND_net), 
            .VCC_net(VCC_net), .w_rx_24_fifo_push(w_rx_24_fifo_push), .n14347(n14347), 
            .\w_rx_24_fifo_data[31] (w_rx_24_fifo_data[31]), .\w_rx_24_fifo_data[30] (w_rx_24_fifo_data[30]), 
            .\w_rx_24_fifo_data[29] (w_rx_24_fifo_data[29]), .\w_rx_24_fifo_data[28] (w_rx_24_fifo_data[28]), 
            .\w_rx_24_fifo_data[27] (w_rx_24_fifo_data[27]), .\w_rx_24_fifo_data[26] (w_rx_24_fifo_data[26]), 
            .\w_rx_24_fifo_data[25] (w_rx_24_fifo_data[25]), .\w_rx_24_fifo_data[24] (w_rx_24_fifo_data[24]), 
            .\w_rx_24_fifo_data[23] (w_rx_24_fifo_data[23]), .\w_rx_24_fifo_data[22] (w_rx_24_fifo_data[22]), 
            .\w_rx_24_fifo_data[21] (w_rx_24_fifo_data[21]), .\w_rx_24_fifo_data[20] (w_rx_24_fifo_data[20]), 
            .\w_rx_24_fifo_data[19] (w_rx_24_fifo_data[19]), .\w_rx_24_fifo_data[18] (w_rx_24_fifo_data[18]), 
            .\w_rx_24_fifo_data[17] (w_rx_24_fifo_data[17]), .\w_rx_24_fifo_data[16] (w_rx_24_fifo_data[16]), 
            .main_reset_n_N_208(main_reset_n_N_208), .wifi_i_fifo_data_out({wifi_i_fifo_data_out})) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(680[20] 691[2])
    L6MUX21 mux_859_i1 (.D0(n13388), .D1(n13390), .SD(n13431), .Z(n3020));
    fifo_dc_16in_16out_U3 subg_q_fifo_dc (.sdr_rxclk_c(sdr_rxclk_c), .internal_80MHz(internal_80MHz), 
            .rRst(rRst), .subg_q_empty(subg_q_empty), .GND_net(GND_net), 
            .VCC_net(VCC_net), .w_rx_09_fifo_push(w_rx_09_fifo_push), .n14348(n14348), 
            .\w_rx_09_fifo_data[15] (w_rx_09_fifo_data[15]), .\w_rx_09_fifo_data[14] (w_rx_09_fifo_data[14]), 
            .\w_rx_09_fifo_data[13] (w_rx_09_fifo_data[13]), .\w_rx_09_fifo_data[12] (w_rx_09_fifo_data[12]), 
            .\w_rx_09_fifo_data[11] (w_rx_09_fifo_data[11]), .\w_rx_09_fifo_data[10] (w_rx_09_fifo_data[10]), 
            .\w_rx_09_fifo_data[9] (w_rx_09_fifo_data[9]), .\w_rx_09_fifo_data[8] (w_rx_09_fifo_data[8]), 
            .\w_rx_09_fifo_data[7] (w_rx_09_fifo_data[7]), .\w_rx_09_fifo_data[6] (w_rx_09_fifo_data[6]), 
            .\w_rx_09_fifo_data[5] (w_rx_09_fifo_data[5]), .\w_rx_09_fifo_data[4] (w_rx_09_fifo_data[4]), 
            .\w_rx_09_fifo_data[3] (w_rx_09_fifo_data[3]), .\w_rx_09_fifo_data[2] (w_rx_09_fifo_data[2]), 
            .\w_rx_09_fifo_data[1] (w_rx_09_fifo_data[1]), .\w_rx_09_fifo_data[0] (w_rx_09_fifo_data[0]), 
            .main_reset_n_N_208(main_reset_n_N_208), .subg_q_fifo_data_out({subg_q_fifo_data_out})) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(663[20] 674[2])
    LUT4 wifi_q_empty_I_0_1_lut_rep_262 (.A(wifi_q_empty), .Z(n14346)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(730[41:54])
    defparam wifi_q_empty_I_0_1_lut_rep_262.init = 16'h5555;
    PFUMX i10398 (.BLUT(n2907), .ALUT(n13389), .C0(n13411), .Z(n13390));
    LUT4 stm_fpga_spare2_I_0_2_lut_rep_222_2_lut (.A(wifi_q_empty), .B(stm_fpga_spare2_c), 
         .Z(internal_80MHz_enable_68)) /* synthesis lut_function=(!(A+!(B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(730[41:54])
    defparam stm_fpga_spare2_I_0_2_lut_rep_222_2_lut.init = 16'h4444;
    LUT4 i_start_I_0_2_lut_rep_201_3_lut_3_lut (.A(wifi_q_empty), .B(shift_reg_15__N_1175_adj_1195), 
         .C(stm_fpga_spare2_c), .Z(n14285)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(730[41:54])
    defparam i_start_I_0_2_lut_rep_201_3_lut_3_lut.init = 16'h1010;
    LUT4 mux_779_i4_3_lut (.A(reg0[3]), .B(reg1[3]), .C(wb_adr_o[0]), 
         .Z(n2769)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_779_i4_3_lut.init = 16'hcaca;
    LUT4 i1_2_lut_3_lut_3_lut_adj_251 (.A(wifi_q_empty), .B(shift_reg_15__N_1175_adj_1195), 
         .C(stm_fpga_spare2_c), .Z(internal_80MHz_enable_67)) /* synthesis lut_function=(A (B)+!A (B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(730[41:54])
    defparam i1_2_lut_3_lut_3_lut_adj_251.init = 16'hdcdc;
    LUT4 i10467_3_lut (.A(spi2_test_pattern[9]), .B(spi2_test_pattern[1]), 
         .C(wb_adr_o[0]), .Z(n13461)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i10467_3_lut.init = 16'hcaca;
    PFUMX i10996 (.BLUT(n14407), .ALUT(n14408), .C0(tx_lvds_test_pattern[4]), 
          .Z(n14409));
    PFUMX mux_859_i8 (.BLUT(n2888), .ALUT(n2993), .C0(n13453), .Z(n3013));
    LUT4 i10466_3_lut (.A(spi1_test_pattern[9]), .B(spi1_test_pattern[1]), 
         .C(wb_adr_o[0]), .Z(n13460)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i10466_3_lut.init = 16'hcaca;
    pll_10MHzInput second_pll (.dpll_clkout0_c(dpll_clkout0_c), .n14343(n14343), 
            .second_pll_lock(second_pll_lock), .GND_net(GND_net)) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(101[16] 106[2])
    PFUMX mux_859_i7 (.BLUT(n2889), .ALUT(n2994), .C0(n13453), .Z(n3014));
    LUT4 reg0_7__bdd_3_lut_11139 (.A(reg0[7]), .B(wb_adr_o[0]), .C(reg1[7]), 
         .Z(n14058)) /* synthesis lut_function=(A ((C)+!B)+!A (B (C))) */ ;
    defparam reg0_7__bdd_3_lut_11139.init = 16'he2e2;
    FD1P3JX wifi_rx_invert_223 (.D(wb_dat_o[1]), .SP(int_clk_out_enable_212), 
            .PD(n14343), .CK(int_clk_out), .Q(wifi_rx_invert));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam wifi_rx_invert_223.GSR = "DISABLED";
    ecp5_spi_master_top wifi_q_spi (.internal_80MHz_enable_68(internal_80MHz_enable_68), 
            .shift_reg_15__N_1175(shift_reg_15__N_1175_adj_1195), .internal_80MHz(internal_80MHz), 
            .spi4_mosi_c(spi4_mosi_c), .main_reset_n_N_208(main_reset_n_N_208), 
            .n14285(n14285), .internal_80MHz_enable_67(internal_80MHz_enable_67), 
            .GND_net(GND_net), .spi4_sck_c(spi4_sck_c), .spi4_sck_N_442({spi4_sck_N_442})) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(786[21] 794[2])
    LUT4 wifi_i_empty_I_0_1_lut_rep_263 (.A(wifi_i_empty), .Z(n14347)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(729[41:54])
    defparam wifi_i_empty_I_0_1_lut_rep_263.init = 16'h5555;
    PFUMX i10992 (.BLUT(n14401), .ALUT(n14402), .C0(tx_lvds_test_pattern[5]), 
          .Z(n14403));
    PFUMX mux_859_i6 (.BLUT(n2890), .ALUT(n2995), .C0(n13453), .Z(n3015));
    PFUMX i10990 (.BLUT(n14398), .ALUT(n14399), .C0(tx_lvds_test_pattern[7]), 
          .Z(n14400));
    FD1P3JX subg_sync_check_enable_231 (.D(wb_dat_o[2]), .SP(int_clk_out_enable_212), 
            .PD(n14343), .CK(int_clk_out), .Q(subg_sync_check_enable));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(338[8] 402[4])
    defparam subg_sync_check_enable_231.GSR = "DISABLED";
    LUT4 stm_fpga_spare2_I_0_289_2_lut_rep_226_2_lut (.A(wifi_i_empty), .B(stm_fpga_spare2_c), 
         .Z(internal_80MHz_enable_52)) /* synthesis lut_function=(!(A+!(B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(729[41:54])
    defparam stm_fpga_spare2_I_0_289_2_lut_rep_226_2_lut.init = 16'h4444;
    \i2c_slave_wbm(WB_DATA_WIDTH=8,WB_ADDR_WIDTH=16,WB_SELECT_WIDTH=1)  i2c_slave (.n13302(n13302), 
            .int_clk_out_enable_99(int_clk_out_enable_99), .wb_adr_o({Open_38, 
            Open_39, Open_40, Open_41, Open_42, Open_43, Open_44, 
            wb_adr_o[8], Open_45, Open_46, Open_47, Open_48, Open_49, 
            Open_50, wb_adr_o[1], Open_51}), .int_clk_out(int_clk_out), 
            .\wb_adr_o[7] (wb_adr_o[7]), .n14356(n14356), .\wb_adr_o[2] (wb_adr_o[2]), 
            .\wb_adr_o[6] (wb_adr_o[6]), .\wb_adr_o[0] (wb_adr_o[0]), .\wb_adr_o[3] (wb_adr_o[3]), 
            .\ufl_p8_sel[7] (ufl_p8_sel[7]), .\reg2[7] (reg2[7]), .n14056(n14056), 
            .\ufl_p8_sel[5] (ufl_p8_sel[5]), .\reg2[5] (reg2[5]), .n14019(n14019), 
            .\ufl_p8_sel[6] (ufl_p8_sel[6]), .\reg2[6] (reg2[6]), .n14029(n14029), 
            .\ufl_p8_sel[4] (ufl_p8_sel[4]), .\reg2[4] (reg2[4]), .n14002(n14002), 
            .\reg2[2] (reg2[2]), .n2797(n2797), .n11601(n11601), .n12798(n12798), 
            .int_clk_out_enable_54(int_clk_out_enable_54), .int_clk_out_enable_55(int_clk_out_enable_55), 
            .n14330(n14330), .int_clk_out_enable_77(int_clk_out_enable_77), 
            .n12168(n12168), .n11664(n11664), .n12618(n12618), .n14354(n14354), 
            .n9012(n9012), .n13044(n13044), .n14351(n14351), .int_clk_out_enable_107(int_clk_out_enable_107), 
            .int_clk_out_enable_83(int_clk_out_enable_83), .wb_dat_o({wb_dat_o}), 
            .n14352(n14352), .n14343(n14343), .n11958(n11958), .n12153(n12153), 
            .wb_stb_o(wb_stb_o), .n12812(n12812), .int_clk_out_enable_39(int_clk_out_enable_39), 
            .\wb_adr_o[4] (wb_adr_o[4]), .\wb_adr_o[5] (wb_adr_o[5]), .wb_we_o(wb_we_o), 
            .n13180(n13180), .int_clk_out_enable_15(int_clk_out_enable_15), 
            .bus_addressed(bus_addressed), .stm_fpga_spare5_c(stm_fpga_spare5_c), 
            .wb_ack_i(wb_ack_i), .n14325(n14325), .n14384(n14384), .int_clk_out_enable_134(int_clk_out_enable_134), 
            .int_clk_out_enable_136(int_clk_out_enable_136), .int_clk_out_enable_141(int_clk_out_enable_141), 
            .int_clk_out_enable_129(int_clk_out_enable_129), .int_clk_out_enable_143(int_clk_out_enable_143), 
            .int_clk_out_enable_122(int_clk_out_enable_122), .GND_net(GND_net), 
            .VCC_net(VCC_net), .wb_dat_i({wb_dat_i}), .int_clk_out_enable_111(int_clk_out_enable_111), 
            .\state_reg[0] (state_reg_adj_1301[0]), .n13400(n13400), .sda_i_reg(sda_i_reg), 
            .n14324(n14324), .mode_read_reg(mode_read_reg), .fpga_scl_in(fpga_scl_in), 
            .fpga_sda_in(fpga_sda_in), .fpga_scl_out(fpga_scl_out), .n13402(n13402), 
            .fpga_sda_out(fpga_sda_out), .n12584(n12584), .\tx_lvds_test_pattern_31__N_119[25] (tx_lvds_test_pattern_31__N_119[25]), 
            .int_clk_out_enable_62(int_clk_out_enable_62), .int_clk_out_enable_28(int_clk_out_enable_28), 
            .int_clk_out_enable_114(int_clk_out_enable_114), .int_clk_out_enable_46(int_clk_out_enable_46), 
            .int_clk_out_enable_69(int_clk_out_enable_69), .int_clk_out_enable_150(int_clk_out_enable_150), 
            .led_rst(led_rst), .fpga_led_N_383(fpga_led_N_383), .int_clk_out_enable_121(int_clk_out_enable_121), 
            .\tx_lvds_test_pattern_31__N_119[6] (tx_lvds_test_pattern_31__N_119[6]), 
            .int_clk_out_enable_53(int_clk_out_enable_53), .\tx_lvds_test_pattern_31__N_119[26] (tx_lvds_test_pattern_31__N_119[26]), 
            .int_clk_out_enable_27(int_clk_out_enable_27), .int_clk_out_enable_164(int_clk_out_enable_164), 
            .int_clk_out_enable_171(int_clk_out_enable_171), .int_clk_out_enable_106(int_clk_out_enable_106), 
            .\ufl_p7_sel_7__N_35[0] (ufl_p7_sel_7__N_35[0]), .n12964(n12964), 
            .n12966(n12966), .int_clk_out_enable_212(int_clk_out_enable_212), 
            .int_clk_out_enable_128(int_clk_out_enable_128), .int_clk_out_enable_84(int_clk_out_enable_84), 
            .int_clk_out_enable_76(int_clk_out_enable_76), .\tx_lvds_test_pattern_31__N_119[31] (tx_lvds_test_pattern_31__N_119[31]), 
            .int_clk_out_enable_98(int_clk_out_enable_98), .\tx_lvds_test_pattern_31__N_119[27] (tx_lvds_test_pattern_31__N_119[27]), 
            .\spi3_test_pattern_15__N_83[13] (spi3_test_pattern_15__N_83[13]), 
            .\tx_lvds_test_pattern_31__N_119[28] (tx_lvds_test_pattern_31__N_119[28]), 
            .n14299(n14299), .n13324(n13324)) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(202[4] 238[2])
    LUT4 i1_4_lut_adj_252 (.A(sample_count_adj_1211[7]), .B(n14284), .C(sample_count_adj_1211[6]), 
         .D(n14269), .Z(sample_count_next_adj_1212[7])) /* synthesis lut_function=(!(A ((C (D))+!B)+!A !(B (C (D))))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(123[9] 198[16])
    defparam i1_4_lut_adj_252.init = 16'h4888;
    GSR GSR_INST (.GSR(n14366));
    LUT4 n13397_bdd_3_lut (.A(n13397), .B(wb_adr_o[1]), .C(n13398), .Z(n14909)) /* synthesis lut_function=(A ((C)+!B)+!A (B (C))) */ ;
    defparam n13397_bdd_3_lut.init = 16'he2e2;
    PFUMX mux_859_i5 (.BLUT(n2891), .ALUT(n2996), .C0(n13453), .Z(n3016));
    PFUMX i10988 (.BLUT(n14395), .ALUT(n14396), .C0(tx_lvds_test_pattern[6]), 
          .Z(n14397));
    word_align_3state lvds_rx_24_inst (.n14284(n14284), .n15(n15), .r_state({r_state_adj_1205}), 
            .sdr_rxclk_c(sdr_rxclk_c), .i_ddr_data({w_lvds_rx_24_d0, w_lvds_rx_24_d1}), 
            .\sample_count[0] (sample_count_adj_1211[0]), .\sample_count_next[0] (sample_count_next_adj_1212[0]), 
            .w_rx_24_fifo_data({w_rx_24_fifo_data}), .\sample_count[2] (sample_count_adj_1211[2]), 
            .n14338(n14338), .\sample_count[3] (sample_count_adj_1211[3]), 
            .n14305(n14305), .n14269(n14269), .\sample_count[1] (sample_count_adj_1211[1]), 
            .\sample_count[7] (sample_count_adj_1211[7]), .\sample_count[6] (sample_count_adj_1211[6]), 
            .n14917(n14917), .n1(n1), .\sample_count_next[7] (sample_count_next_adj_1212[7]), 
            .\sample_count_next[3] (sample_count_next_adj_1212[3]), .n14360(n14360), 
            .\sample_count_next[2] (sample_count_next_adj_1212[2]), .w_rx_24_fifo_push(w_rx_24_fifo_push), 
            .\sample_count_next[1] (sample_count_next_adj_1212[1])) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(631[19] 638[2])
    LUT4 n13397_bdd_3_lut_11221 (.A(wb_adr_o[0]), .B(wb_adr_o[1]), .C(tx_lvds_test_pattern[3]), 
         .Z(n14908)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;
    defparam n13397_bdd_3_lut_11221.init = 16'h1010;
    LUT4 mux_814_i5_3_lut (.A(spi2_test_pattern[12]), .B(spi2_test_pattern[4]), 
         .C(wb_adr_o[0]), .Z(n2843)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(411[2] 436[9])
    defparam mux_814_i5_3_lut.init = 16'hcaca;
    LUT4 n13480_bdd_3_lut (.A(n13480), .B(n13481), .C(wb_adr_o[2]), .Z(n14911)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam n13480_bdd_3_lut.init = 16'hcaca;
    LUT4 i_start_I_0_2_lut_rep_203_3_lut_3_lut (.A(wifi_i_empty), .B(shift_reg_15__N_1175_adj_1194), 
         .C(stm_fpga_spare2_c), .Z(n14287)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(729[41:54])
    defparam i_start_I_0_2_lut_rep_203_3_lut_3_lut.init = 16'h1010;
    fifo_dc_16in_16out wifi_q_fifo_dc (.main_reset_n_N_208(main_reset_n_N_208), 
            .rRst(rRst), .sdr_rxclk_c(sdr_rxclk_c), .internal_80MHz(internal_80MHz), 
            .wifi_q_empty(wifi_q_empty), .GND_net(GND_net), .VCC_net(VCC_net), 
            .w_rx_24_fifo_push(w_rx_24_fifo_push), .n14346(n14346), .\w_rx_24_fifo_data[15] (w_rx_24_fifo_data[15]), 
            .\w_rx_24_fifo_data[14] (w_rx_24_fifo_data[14]), .\w_rx_24_fifo_data[13] (w_rx_24_fifo_data[13]), 
            .\w_rx_24_fifo_data[12] (w_rx_24_fifo_data[12]), .\w_rx_24_fifo_data[11] (w_rx_24_fifo_data[11]), 
            .\w_rx_24_fifo_data[10] (w_rx_24_fifo_data[10]), .\w_rx_24_fifo_data[9] (w_rx_24_fifo_data[9]), 
            .\w_rx_24_fifo_data[8] (w_rx_24_fifo_data[8]), .\w_rx_24_fifo_data[7] (w_rx_24_fifo_data[7]), 
            .\w_rx_24_fifo_data[6] (w_rx_24_fifo_data[6]), .\w_rx_24_fifo_data[5] (w_rx_24_fifo_data[5]), 
            .\w_rx_24_fifo_data[4] (w_rx_24_fifo_data[4]), .\w_rx_24_fifo_data[3] (w_rx_24_fifo_data[3]), 
            .\w_rx_24_fifo_data[2] (w_rx_24_fifo_data[2]), .\w_rx_24_fifo_data[1] (w_rx_24_fifo_data[1]), 
            .\w_rx_24_fifo_data[0] (w_rx_24_fifo_data[0]), .wifi_q_fifo_data_out({wifi_q_fifo_data_out})) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(696[20] 707[2])
    
endmodule
//
// Verilog Description of module internal_pll
//

module internal_pll (dpll_clkout2_c, n14343, internal_64MHz, internal_80MHz, 
            sdr_txclk_c, pll_lock, GND_net) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;
    input dpll_clkout2_c;
    input n14343;
    output internal_64MHz;
    output internal_80MHz;
    output sdr_txclk_c;
    output pll_lock;
    input GND_net;
    
    wire dpll_clkout2_c /* synthesis is_clock=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(5[13:25])
    wire internal_64MHz /* synthesis SET_AS_NETWORK=internal_64MHz, is_clock=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(85[6:20])
    wire internal_80MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_80MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(84[6:20])
    wire sdr_txclk_c /* synthesis IO_TYPES="LVDS", is_clock=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(11[14:23])
    
    EHXPLLL PLLInst_0 (.CLKI(dpll_clkout2_c), .CLKFB(internal_64MHz), .PHASESEL0(GND_net), 
            .PHASESEL1(GND_net), .PHASEDIR(GND_net), .PHASESTEP(GND_net), 
            .PHASELOADREG(GND_net), .STDBY(GND_net), .PLLWAKESYNC(GND_net), 
            .RST(n14343), .ENCLKOP(GND_net), .ENCLKOS(GND_net), .ENCLKOS2(GND_net), 
            .ENCLKOS3(GND_net), .CLKOP(internal_64MHz), .CLKOS2(internal_80MHz), 
            .CLKOS3(sdr_txclk_c), .LOCK(pll_lock)) /* synthesis FREQUENCY_PIN_CLKOS3="64.000000", FREQUENCY_PIN_CLKOS2="80.000000", FREQUENCY_PIN_CLKOS="160.000000", FREQUENCY_PIN_CLKOP="64.000000", FREQUENCY_PIN_CLKI="8.000000", ICP_CURRENT="5", LPF_RESISTOR="16", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=14, LSE_RCOL=2, LSE_LLINE=88, LSE_RLINE=96 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(88[14] 96[2])
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
// Verilog Description of module led_toggle
//

module led_toggle (fpga_led_c, int_clk_out, fpga_led_N_383, GND_net, 
            VCC_net) /* synthesis syn_module_defined=1 */ ;
    output fpga_led_c;
    input int_clk_out;
    input fpga_led_N_383;
    input GND_net;
    input VCC_net;
    
    wire int_clk_out /* synthesis DSPPORT_20=CLK3, CLOCK_NET_FOR_BUS20=20, is_clock=1, SET_AS_NETWORK=int_clk_out */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(76[6:17])
    wire fpga_led_N_383 /* synthesis DSPPORT_20=RST3, RESET_NET_FOR_BUS20=20 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(2[14:22])
    wire VCC_net /* synthesis CE_NET_FOR_BUS20=20, DSPPORT_20=CE3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(26[14:27])
    wire [25:0]counter;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(7[16:23])
    
    wire n12912, n12936, n12924, n13276, n12928, n12920, n12918, 
        n12922, led_N_536;
    wire [25:0]n109;
    
    wire n51;
    wire [25:0]n137;
    
    wire n10845, n10846, n10844, n13348, n12946, n12948, n12942, 
        n10843, n10842, n10841, n10840, n10852, n10851, n10850, 
        n10849, n10848, n10847;
    
    LUT4 i1_2_lut (.A(counter[21]), .B(counter[8]), .Z(n12912)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut.init = 16'heeee;
    LUT4 i1_4_lut (.A(counter[5]), .B(counter[23]), .C(counter[0]), .D(counter[14]), 
         .Z(n12936)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut.init = 16'hfffe;
    LUT4 i1_2_lut_adj_216 (.A(counter[25]), .B(counter[4]), .Z(n12924)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut_adj_216.init = 16'heeee;
    LUT4 i10285_2_lut (.A(counter[9]), .B(counter[12]), .Z(n13276)) /* synthesis lut_function=(A (B)) */ ;
    defparam i10285_2_lut.init = 16'h8888;
    LUT4 i1_2_lut_adj_217 (.A(counter[7]), .B(counter[1]), .Z(n12928)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut_adj_217.init = 16'heeee;
    LUT4 i1_2_lut_adj_218 (.A(counter[18]), .B(counter[15]), .Z(n12920)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut_adj_218.init = 16'heeee;
    LUT4 i1_2_lut_adj_219 (.A(counter[17]), .B(counter[2]), .Z(n12918)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut_adj_219.init = 16'heeee;
    LUT4 i1_2_lut_adj_220 (.A(counter[24]), .B(counter[20]), .Z(n12922)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut_adj_220.init = 16'heeee;
    FD1S3DX led_12 (.D(led_N_536), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(fpga_led_c)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=12, LSE_RCOL=2, LSE_LLINE=114, LSE_RLINE=121 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(14[18] 22[12])
    defparam led_12.GSR = "DISABLED";
    LUT4 i6133_2_lut (.A(n109[0]), .B(n51), .Z(n137[0])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6133_2_lut.init = 16'h8888;
    CCU2C counter_1303_add_4_13 (.A0(counter[11]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[12]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n10845), .COUT(n10846), .S0(n109[11]), 
          .S1(n109[12]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303_add_4_13.INIT0 = 16'haaa0;
    defparam counter_1303_add_4_13.INIT1 = 16'haaa0;
    defparam counter_1303_add_4_13.INJECT1_0 = "NO";
    defparam counter_1303_add_4_13.INJECT1_1 = "NO";
    CCU2C counter_1303_add_4_11 (.A0(counter[9]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[10]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n10844), .COUT(n10845), .S0(n109[9]), .S1(n109[10]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303_add_4_11.INIT0 = 16'haaa0;
    defparam counter_1303_add_4_11.INIT1 = 16'haaa0;
    defparam counter_1303_add_4_11.INJECT1_0 = "NO";
    defparam counter_1303_add_4_11.INJECT1_1 = "NO";
    LUT4 i1_2_lut_adj_221 (.A(fpga_led_c), .B(n51), .Z(led_N_536)) /* synthesis lut_function=(A (B)+!A !(B)) */ ;
    defparam i1_2_lut_adj_221.init = 16'h9999;
    LUT4 i1_4_lut_adj_222 (.A(n13348), .B(n12946), .C(n12948), .D(n12942), 
         .Z(n51)) /* synthesis lut_function=((B+(C+(D)))+!A) */ ;
    defparam i1_4_lut_adj_222.init = 16'hfffd;
    CCU2C counter_1303_add_4_9 (.A0(counter[7]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[8]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n10843), .COUT(n10844), .S0(n109[7]), .S1(n109[8]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303_add_4_9.INIT0 = 16'haaa0;
    defparam counter_1303_add_4_9.INIT1 = 16'haaa0;
    defparam counter_1303_add_4_9.INJECT1_0 = "NO";
    defparam counter_1303_add_4_9.INJECT1_1 = "NO";
    LUT4 i10357_4_lut (.A(counter[10]), .B(counter[22]), .C(counter[16]), 
         .D(counter[19]), .Z(n13348)) /* synthesis lut_function=(A (B (C (D)))) */ ;
    defparam i10357_4_lut.init = 16'h8000;
    LUT4 i1_4_lut_adj_223 (.A(n12912), .B(counter[13]), .C(n12936), .D(n12924), 
         .Z(n12946)) /* synthesis lut_function=(A+((C+(D))+!B)) */ ;
    defparam i1_4_lut_adj_223.init = 16'hfffb;
    LUT4 i1_4_lut_adj_224 (.A(n13276), .B(n12928), .C(n12920), .D(n12918), 
         .Z(n12948)) /* synthesis lut_function=((B+(C+(D)))+!A) */ ;
    defparam i1_4_lut_adj_224.init = 16'hfffd;
    LUT4 i1_4_lut_adj_225 (.A(counter[11]), .B(counter[6]), .C(n12922), 
         .D(counter[3]), .Z(n12942)) /* synthesis lut_function=((B+(C+(D)))+!A) */ ;
    defparam i1_4_lut_adj_225.init = 16'hfffd;
    CCU2C counter_1303_add_4_7 (.A0(counter[5]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[6]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n10842), .COUT(n10843), .S0(n109[5]), .S1(n109[6]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303_add_4_7.INIT0 = 16'haaa0;
    defparam counter_1303_add_4_7.INIT1 = 16'haaa0;
    defparam counter_1303_add_4_7.INJECT1_0 = "NO";
    defparam counter_1303_add_4_7.INJECT1_1 = "NO";
    FD1S3DX counter_1303__i0 (.D(n137[0]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[0])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i0.GSR = "DISABLED";
    CCU2C counter_1303_add_4_5 (.A0(counter[3]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[4]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n10841), .COUT(n10842), .S0(n109[3]), .S1(n109[4]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303_add_4_5.INIT0 = 16'haaa0;
    defparam counter_1303_add_4_5.INIT1 = 16'haaa0;
    defparam counter_1303_add_4_5.INJECT1_0 = "NO";
    defparam counter_1303_add_4_5.INJECT1_1 = "NO";
    CCU2C counter_1303_add_4_3 (.A0(counter[1]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[2]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n10840), .COUT(n10841), .S0(n109[1]), .S1(n109[2]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303_add_4_3.INIT0 = 16'haaa0;
    defparam counter_1303_add_4_3.INIT1 = 16'haaa0;
    defparam counter_1303_add_4_3.INJECT1_0 = "NO";
    defparam counter_1303_add_4_3.INJECT1_1 = "NO";
    CCU2C counter_1303_add_4_1 (.A0(GND_net), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(counter[0]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .COUT(n10840), .S1(n109[0]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303_add_4_1.INIT0 = 16'h0000;
    defparam counter_1303_add_4_1.INIT1 = 16'h555f;
    defparam counter_1303_add_4_1.INJECT1_0 = "NO";
    defparam counter_1303_add_4_1.INJECT1_1 = "NO";
    FD1S3DX counter_1303__i1 (.D(n137[1]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[1])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i1.GSR = "DISABLED";
    FD1S3DX counter_1303__i2 (.D(n137[2]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[2])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i2.GSR = "DISABLED";
    FD1S3DX counter_1303__i3 (.D(n137[3]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[3])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i3.GSR = "DISABLED";
    FD1S3DX counter_1303__i4 (.D(n137[4]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[4])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i4.GSR = "DISABLED";
    FD1S3DX counter_1303__i5 (.D(n137[5]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[5])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i5.GSR = "DISABLED";
    FD1S3DX counter_1303__i6 (.D(n137[6]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[6])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i6.GSR = "DISABLED";
    FD1S3DX counter_1303__i7 (.D(n137[7]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[7])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i7.GSR = "DISABLED";
    FD1S3DX counter_1303__i8 (.D(n137[8]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[8])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i8.GSR = "DISABLED";
    FD1S3DX counter_1303__i9 (.D(n137[9]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[9])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i9.GSR = "DISABLED";
    FD1S3DX counter_1303__i10 (.D(n137[10]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[10])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i10.GSR = "DISABLED";
    FD1S3DX counter_1303__i11 (.D(n137[11]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[11])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i11.GSR = "DISABLED";
    FD1S3DX counter_1303__i12 (.D(n137[12]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[12])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i12.GSR = "DISABLED";
    FD1S3DX counter_1303__i13 (.D(n137[13]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[13])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i13.GSR = "DISABLED";
    FD1S3DX counter_1303__i14 (.D(n137[14]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[14])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i14.GSR = "DISABLED";
    FD1S3DX counter_1303__i15 (.D(n137[15]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[15])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i15.GSR = "DISABLED";
    FD1S3DX counter_1303__i16 (.D(n137[16]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[16])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i16.GSR = "DISABLED";
    FD1S3DX counter_1303__i17 (.D(n137[17]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[17])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i17.GSR = "DISABLED";
    FD1S3DX counter_1303__i18 (.D(n137[18]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[18])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i18.GSR = "DISABLED";
    FD1S3DX counter_1303__i19 (.D(n137[19]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[19])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i19.GSR = "DISABLED";
    FD1S3DX counter_1303__i20 (.D(n137[20]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[20])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i20.GSR = "DISABLED";
    FD1S3DX counter_1303__i21 (.D(n137[21]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[21])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i21.GSR = "DISABLED";
    FD1S3DX counter_1303__i22 (.D(n137[22]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[22])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i22.GSR = "DISABLED";
    FD1S3DX counter_1303__i23 (.D(n137[23]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[23])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i23.GSR = "DISABLED";
    FD1S3DX counter_1303__i24 (.D(n137[24]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[24])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i24.GSR = "DISABLED";
    FD1S3DX counter_1303__i25 (.D(n137[25]), .CK(int_clk_out), .CD(fpga_led_N_383), 
            .Q(counter[25])) /* synthesis syn_use_carry_chain=1, REG_OUTPUT_CLK=CLK3, REG_OUTPUT_CE=CE3, REG_OUTPUT_RST=RST3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303__i25.GSR = "DISABLED";
    CCU2C counter_1303_add_4_27 (.A0(counter[25]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(GND_net), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n10852), .S0(n109[25]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303_add_4_27.INIT0 = 16'haaa0;
    defparam counter_1303_add_4_27.INIT1 = 16'h0000;
    defparam counter_1303_add_4_27.INJECT1_0 = "NO";
    defparam counter_1303_add_4_27.INJECT1_1 = "NO";
    LUT4 i6229_2_lut (.A(n109[1]), .B(n51), .Z(n137[1])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6229_2_lut.init = 16'h8888;
    CCU2C counter_1303_add_4_25 (.A0(counter[23]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[24]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n10851), .COUT(n10852), .S0(n109[23]), 
          .S1(n109[24]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303_add_4_25.INIT0 = 16'haaa0;
    defparam counter_1303_add_4_25.INIT1 = 16'haaa0;
    defparam counter_1303_add_4_25.INJECT1_0 = "NO";
    defparam counter_1303_add_4_25.INJECT1_1 = "NO";
    LUT4 i6230_2_lut (.A(n109[2]), .B(n51), .Z(n137[2])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6230_2_lut.init = 16'h8888;
    LUT4 i6231_2_lut (.A(n109[3]), .B(n51), .Z(n137[3])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6231_2_lut.init = 16'h8888;
    CCU2C counter_1303_add_4_23 (.A0(counter[21]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[22]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n10850), .COUT(n10851), .S0(n109[21]), 
          .S1(n109[22]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303_add_4_23.INIT0 = 16'haaa0;
    defparam counter_1303_add_4_23.INIT1 = 16'haaa0;
    defparam counter_1303_add_4_23.INJECT1_0 = "NO";
    defparam counter_1303_add_4_23.INJECT1_1 = "NO";
    LUT4 i6232_2_lut (.A(n109[4]), .B(n51), .Z(n137[4])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6232_2_lut.init = 16'h8888;
    LUT4 i6233_2_lut (.A(n109[5]), .B(n51), .Z(n137[5])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6233_2_lut.init = 16'h8888;
    LUT4 i6234_2_lut (.A(n109[6]), .B(n51), .Z(n137[6])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6234_2_lut.init = 16'h8888;
    LUT4 i6235_2_lut (.A(n109[7]), .B(n51), .Z(n137[7])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6235_2_lut.init = 16'h8888;
    LUT4 i6236_2_lut (.A(n109[8]), .B(n51), .Z(n137[8])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6236_2_lut.init = 16'h8888;
    LUT4 i6237_2_lut (.A(n109[9]), .B(n51), .Z(n137[9])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6237_2_lut.init = 16'h8888;
    LUT4 i6238_2_lut (.A(n109[10]), .B(n51), .Z(n137[10])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6238_2_lut.init = 16'h8888;
    LUT4 i6239_2_lut (.A(n109[11]), .B(n51), .Z(n137[11])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6239_2_lut.init = 16'h8888;
    LUT4 i6240_2_lut (.A(n109[12]), .B(n51), .Z(n137[12])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6240_2_lut.init = 16'h8888;
    LUT4 i6241_2_lut (.A(n109[13]), .B(n51), .Z(n137[13])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6241_2_lut.init = 16'h8888;
    LUT4 i6242_2_lut (.A(n109[14]), .B(n51), .Z(n137[14])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6242_2_lut.init = 16'h8888;
    LUT4 i6243_2_lut (.A(n109[15]), .B(n51), .Z(n137[15])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6243_2_lut.init = 16'h8888;
    LUT4 i6244_2_lut (.A(n109[16]), .B(n51), .Z(n137[16])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6244_2_lut.init = 16'h8888;
    LUT4 i6245_2_lut (.A(n109[17]), .B(n51), .Z(n137[17])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6245_2_lut.init = 16'h8888;
    LUT4 i6246_2_lut (.A(n109[18]), .B(n51), .Z(n137[18])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6246_2_lut.init = 16'h8888;
    LUT4 i6247_2_lut (.A(n109[19]), .B(n51), .Z(n137[19])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6247_2_lut.init = 16'h8888;
    LUT4 i6248_2_lut (.A(n109[20]), .B(n51), .Z(n137[20])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6248_2_lut.init = 16'h8888;
    LUT4 i6249_2_lut (.A(n109[21]), .B(n51), .Z(n137[21])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6249_2_lut.init = 16'h8888;
    LUT4 i6250_2_lut (.A(n109[22]), .B(n51), .Z(n137[22])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6250_2_lut.init = 16'h8888;
    LUT4 i6251_2_lut (.A(n109[23]), .B(n51), .Z(n137[23])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6251_2_lut.init = 16'h8888;
    LUT4 i6252_2_lut (.A(n109[24]), .B(n51), .Z(n137[24])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6252_2_lut.init = 16'h8888;
    LUT4 i6253_2_lut (.A(n109[25]), .B(n51), .Z(n137[25])) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam i6253_2_lut.init = 16'h8888;
    CCU2C counter_1303_add_4_21 (.A0(counter[19]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[20]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n10849), .COUT(n10850), .S0(n109[19]), 
          .S1(n109[20]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303_add_4_21.INIT0 = 16'haaa0;
    defparam counter_1303_add_4_21.INIT1 = 16'haaa0;
    defparam counter_1303_add_4_21.INJECT1_0 = "NO";
    defparam counter_1303_add_4_21.INJECT1_1 = "NO";
    CCU2C counter_1303_add_4_19 (.A0(counter[17]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[18]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n10848), .COUT(n10849), .S0(n109[17]), 
          .S1(n109[18]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303_add_4_19.INIT0 = 16'haaa0;
    defparam counter_1303_add_4_19.INIT1 = 16'haaa0;
    defparam counter_1303_add_4_19.INJECT1_0 = "NO";
    defparam counter_1303_add_4_19.INJECT1_1 = "NO";
    CCU2C counter_1303_add_4_17 (.A0(counter[15]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[16]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n10847), .COUT(n10848), .S0(n109[15]), 
          .S1(n109[16]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303_add_4_17.INIT0 = 16'haaa0;
    defparam counter_1303_add_4_17.INIT1 = 16'haaa0;
    defparam counter_1303_add_4_17.INJECT1_0 = "NO";
    defparam counter_1303_add_4_17.INJECT1_1 = "NO";
    CCU2C counter_1303_add_4_15 (.A0(counter[13]), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(counter[14]), .B1(GND_net), .C1(GND_net), 
          .D1(VCC_net), .CIN(n10846), .COUT(n10847), .S0(n109[13]), 
          .S1(n109[14]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myled.v(20[28:39])
    defparam counter_1303_add_4_15.INIT0 = 16'haaa0;
    defparam counter_1303_add_4_15.INIT1 = 16'haaa0;
    defparam counter_1303_add_4_15.INJECT1_0 = "NO";
    defparam counter_1303_add_4_15.INJECT1_1 = "NO";
    
endmodule
//
// Verilog Description of module ecp5_spi_master_top_U4
//

module ecp5_spi_master_top_U4 (internal_80MHz, shift_reg_15__N_1166, spi1_mosi_c, 
            main_reset_n_N_208, internal_80MHz_enable_19, GND_net, spi1_sck_c, 
            shift_reg_15__N_1175, internal_80MHz_enable_20, spi1_sck_N_394) /* synthesis syn_module_defined=1 */ ;
    input internal_80MHz;
    input shift_reg_15__N_1166;
    output spi1_mosi_c;
    input main_reset_n_N_208;
    input internal_80MHz_enable_19;
    input GND_net;
    output spi1_sck_c;
    output shift_reg_15__N_1175;
    input internal_80MHz_enable_20;
    input [15:0]spi1_sck_N_394;
    
    wire internal_80MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_80MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(84[6:20])
    wire [5:0]bit_counter;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(386[15:26])
    wire [5:0]bit_counter_5__N_1168;
    
    wire o_mosi_N_1176;
    wire [15:0]shift_reg;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(385[16:25])
    wire [15:0]shift_reg_15__N_1126;
    
    wire n6384, n14314, n6380, n6382;
    wire [5:0]bit_counter_5__N_1144;
    
    wire n6376, n13132, n13130;
    
    FD1S3IX bit_counter_i0 (.D(bit_counter_5__N_1168[0]), .CK(internal_80MHz), 
            .CD(shift_reg_15__N_1166), .Q(bit_counter[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i0.GSR = "ENABLED";
    ODDRX1F mosi_ddr (.D0(o_mosi_N_1176), .D1(o_mosi_N_1176), .SCLK(internal_80MHz), 
            .RST(main_reset_n_N_208), .Q(spi1_mosi_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(755[21] 763[2])
    defparam mosi_ddr.GSR = "ENABLED";
    FD1P3AX shift_reg_i0 (.D(shift_reg_15__N_1126[0]), .SP(internal_80MHz_enable_19), 
            .CK(internal_80MHz), .Q(shift_reg[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i0.GSR = "ENABLED";
    ODDRX1F sclk_ddr (.D0(shift_reg_15__N_1175), .D1(GND_net), .SCLK(internal_80MHz), 
            .RST(main_reset_n_N_208), .Q(spi1_sck_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(755[21] 763[2])
    defparam sclk_ddr.GSR = "ENABLED";
    LUT4 i1_2_lut_3_lut (.A(bit_counter[1]), .B(bit_counter[0]), .C(bit_counter[2]), 
         .Z(n6384)) /* synthesis lut_function=(A (C)+!A (B (C)+!B !(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1_2_lut_3_lut.init = 16'he1e1;
    LUT4 i1760_2_lut_rep_230_3_lut (.A(bit_counter[1]), .B(bit_counter[0]), 
         .C(bit_counter[2]), .Z(n14314)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1760_2_lut_rep_230_3_lut.init = 16'hfefe;
    LUT4 i1_2_lut_3_lut_4_lut (.A(bit_counter[1]), .B(bit_counter[0]), .C(bit_counter[3]), 
         .D(bit_counter[2]), .Z(n6380)) /* synthesis lut_function=(A (C)+!A (B (C)+!B (C (D)+!C !(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1_2_lut_3_lut_4_lut.init = 16'hf0e1;
    FD1P3IX bit_counter_i1 (.D(n6382), .SP(shift_reg_15__N_1175), .CD(shift_reg_15__N_1166), 
            .CK(internal_80MHz), .Q(bit_counter[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i1.GSR = "ENABLED";
    FD1P3IX bit_counter_i2 (.D(n6384), .SP(shift_reg_15__N_1175), .CD(shift_reg_15__N_1166), 
            .CK(internal_80MHz), .Q(bit_counter[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i2.GSR = "ENABLED";
    FD1P3IX bit_counter_i3 (.D(n6380), .SP(shift_reg_15__N_1175), .CD(shift_reg_15__N_1166), 
            .CK(internal_80MHz), .Q(bit_counter[3])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i3.GSR = "ENABLED";
    FD1P3AX bit_counter_i4 (.D(bit_counter_5__N_1144[4]), .SP(internal_80MHz_enable_19), 
            .CK(internal_80MHz), .Q(bit_counter[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i4.GSR = "ENABLED";
    FD1P3IX bit_counter_i5 (.D(n6376), .SP(shift_reg_15__N_1175), .CD(shift_reg_15__N_1166), 
            .CK(internal_80MHz), .Q(bit_counter[5])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i5.GSR = "ENABLED";
    FD1P3AX shift_reg_i1 (.D(shift_reg_15__N_1126[1]), .SP(internal_80MHz_enable_19), 
            .CK(internal_80MHz), .Q(shift_reg[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i1.GSR = "ENABLED";
    FD1P3AX shift_reg_i2 (.D(shift_reg_15__N_1126[2]), .SP(internal_80MHz_enable_19), 
            .CK(internal_80MHz), .Q(shift_reg[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i2.GSR = "ENABLED";
    FD1P3AX shift_reg_i3 (.D(shift_reg_15__N_1126[3]), .SP(internal_80MHz_enable_19), 
            .CK(internal_80MHz), .Q(shift_reg[3])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i3.GSR = "ENABLED";
    FD1P3AX shift_reg_i4 (.D(shift_reg_15__N_1126[4]), .SP(internal_80MHz_enable_19), 
            .CK(internal_80MHz), .Q(shift_reg[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i4.GSR = "ENABLED";
    FD1P3AX shift_reg_i5 (.D(shift_reg_15__N_1126[5]), .SP(internal_80MHz_enable_19), 
            .CK(internal_80MHz), .Q(shift_reg[5])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i5.GSR = "ENABLED";
    FD1P3AX shift_reg_i6 (.D(shift_reg_15__N_1126[6]), .SP(internal_80MHz_enable_19), 
            .CK(internal_80MHz), .Q(shift_reg[6])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i6.GSR = "ENABLED";
    FD1P3AX shift_reg_i7 (.D(shift_reg_15__N_1126[7]), .SP(internal_80MHz_enable_19), 
            .CK(internal_80MHz), .Q(shift_reg[7])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i7.GSR = "ENABLED";
    FD1P3AX shift_reg_i8 (.D(shift_reg_15__N_1126[8]), .SP(internal_80MHz_enable_19), 
            .CK(internal_80MHz), .Q(shift_reg[8])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i8.GSR = "ENABLED";
    FD1P3AX shift_reg_i9 (.D(shift_reg_15__N_1126[9]), .SP(internal_80MHz_enable_19), 
            .CK(internal_80MHz), .Q(shift_reg[9])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i9.GSR = "ENABLED";
    FD1P3AX shift_reg_i10 (.D(shift_reg_15__N_1126[10]), .SP(internal_80MHz_enable_19), 
            .CK(internal_80MHz), .Q(shift_reg[10])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i10.GSR = "ENABLED";
    FD1P3AX shift_reg_i11 (.D(shift_reg_15__N_1126[11]), .SP(internal_80MHz_enable_19), 
            .CK(internal_80MHz), .Q(shift_reg[11])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i11.GSR = "ENABLED";
    FD1P3AX shift_reg_i12 (.D(shift_reg_15__N_1126[12]), .SP(internal_80MHz_enable_19), 
            .CK(internal_80MHz), .Q(shift_reg[12])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i12.GSR = "ENABLED";
    FD1P3AX shift_reg_i13 (.D(shift_reg_15__N_1126[13]), .SP(internal_80MHz_enable_19), 
            .CK(internal_80MHz), .Q(shift_reg[13])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i13.GSR = "ENABLED";
    FD1P3AX shift_reg_i14 (.D(shift_reg_15__N_1126[14]), .SP(internal_80MHz_enable_19), 
            .CK(internal_80MHz), .Q(shift_reg[14])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i14.GSR = "ENABLED";
    FD1P3IX shift_reg_i15 (.D(spi1_sck_N_394[15]), .SP(internal_80MHz_enable_20), 
            .CD(shift_reg_15__N_1175), .CK(internal_80MHz), .Q(shift_reg[15])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=755, LSE_RLINE=763 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i15.GSR = "ENABLED";
    LUT4 i1_2_lut (.A(bit_counter[1]), .B(bit_counter[0]), .Z(n6382)) /* synthesis lut_function=(A (B)+!A !(B)) */ ;
    defparam i1_2_lut.init = 16'h9999;
    LUT4 i2089_2_lut (.A(bit_counter[0]), .B(shift_reg_15__N_1175), .Z(bit_counter_5__N_1168[0])) /* synthesis lut_function=(!(A (B)+!A !(B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2089_2_lut.init = 16'h6666;
    LUT4 i1_4_lut (.A(bit_counter[4]), .B(n13132), .C(n13130), .D(bit_counter[5]), 
         .Z(shift_reg_15__N_1175)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(390[8:24])
    defparam i1_4_lut.init = 16'hfffe;
    LUT4 i2397_3_lut (.A(spi1_sck_N_394[1]), .B(shift_reg[2]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[1])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2397_3_lut.init = 16'hcaca;
    LUT4 i1_2_lut_adj_214 (.A(bit_counter[0]), .B(bit_counter[3]), .Z(n13132)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(390[8:24])
    defparam i1_2_lut_adj_214.init = 16'heeee;
    LUT4 i2399_3_lut (.A(spi1_sck_N_394[2]), .B(shift_reg[3]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[2])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2399_3_lut.init = 16'hcaca;
    LUT4 i2401_3_lut (.A(spi1_sck_N_394[3]), .B(shift_reg[4]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[3])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2401_3_lut.init = 16'hcaca;
    LUT4 i2403_3_lut (.A(spi1_sck_N_394[4]), .B(shift_reg[5]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[4])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2403_3_lut.init = 16'hcaca;
    LUT4 i2405_3_lut (.A(spi1_sck_N_394[5]), .B(shift_reg[6]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[5])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2405_3_lut.init = 16'hcaca;
    LUT4 i2407_3_lut (.A(spi1_sck_N_394[6]), .B(shift_reg[7]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[6])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2407_3_lut.init = 16'hcaca;
    LUT4 i1_2_lut_adj_215 (.A(bit_counter[2]), .B(bit_counter[1]), .Z(n13130)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(390[8:24])
    defparam i1_2_lut_adj_215.init = 16'heeee;
    LUT4 i2409_3_lut (.A(spi1_sck_N_394[7]), .B(shift_reg[8]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[7])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2409_3_lut.init = 16'hcaca;
    LUT4 i2411_3_lut (.A(spi1_sck_N_394[8]), .B(shift_reg[9]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[8])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2411_3_lut.init = 16'hcaca;
    LUT4 i2413_3_lut (.A(spi1_sck_N_394[9]), .B(shift_reg[10]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[9])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2413_3_lut.init = 16'hcaca;
    LUT4 i2415_3_lut (.A(spi1_sck_N_394[10]), .B(shift_reg[11]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[10])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2415_3_lut.init = 16'hcaca;
    LUT4 i2417_3_lut (.A(spi1_sck_N_394[11]), .B(shift_reg[12]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[11])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2417_3_lut.init = 16'hcaca;
    LUT4 i2419_3_lut (.A(spi1_sck_N_394[12]), .B(shift_reg[13]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[12])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2419_3_lut.init = 16'hcaca;
    LUT4 i2421_3_lut (.A(spi1_sck_N_394[13]), .B(shift_reg[14]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[13])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2421_3_lut.init = 16'hcaca;
    LUT4 i2423_3_lut (.A(spi1_sck_N_394[14]), .B(shift_reg[15]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[14])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2423_3_lut.init = 16'hcaca;
    LUT4 i6084_2_lut (.A(shift_reg[0]), .B(shift_reg_15__N_1175), .Z(o_mosi_N_1176)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(398[8:46])
    defparam i6084_2_lut.init = 16'h8888;
    LUT4 i2142_3_lut (.A(spi1_sck_N_394[0]), .B(shift_reg[1]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2142_3_lut.init = 16'hcaca;
    LUT4 i1_3_lut_4_lut (.A(bit_counter[3]), .B(n14314), .C(bit_counter[4]), 
         .D(bit_counter[5]), .Z(n6376)) /* synthesis lut_function=(A (D)+!A (B (D)+!B (C (D)+!C !(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1_3_lut_4_lut.init = 16'hfe01;
    LUT4 i6160_3_lut_4_lut (.A(bit_counter[3]), .B(n14314), .C(shift_reg_15__N_1166), 
         .D(bit_counter[4]), .Z(bit_counter_5__N_1144[4])) /* synthesis lut_function=(A (C+(D))+!A (B (C+(D))+!B (C+!(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i6160_3_lut_4_lut.init = 16'hfef1;
    
endmodule
//
// Verilog Description of module ecp5_spi_master_top_U2
//

module ecp5_spi_master_top_U2 (internal_80MHz, spi2_mosi_c, main_reset_n_N_208, 
            n14288, internal_80MHz_enable_35, GND_net, spi2_sck_c, shift_reg_15__N_1175, 
            spi2_sck_N_410, internal_80MHz_enable_36) /* synthesis syn_module_defined=1 */ ;
    input internal_80MHz;
    output spi2_mosi_c;
    input main_reset_n_N_208;
    input n14288;
    input internal_80MHz_enable_35;
    input GND_net;
    output spi2_sck_c;
    output shift_reg_15__N_1175;
    input [15:0]spi2_sck_N_410;
    input internal_80MHz_enable_36;
    
    wire internal_80MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_80MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(84[6:20])
    
    wire o_mosi_N_1176;
    wire [5:0]bit_counter;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(386[15:26])
    wire [5:0]bit_counter_5__N_1168;
    wire [15:0]shift_reg;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(385[16:25])
    wire [15:0]shift_reg_15__N_1126;
    
    wire n14290;
    wire [5:0]bit_counter_5__N_1144;
    
    wire n6372, n6374, n6370, n6366, n13124, n13122, n14313;
    
    ODDRX1F mosi_ddr (.D0(o_mosi_N_1176), .D1(o_mosi_N_1176), .SCLK(internal_80MHz), 
            .RST(main_reset_n_N_208), .Q(spi2_mosi_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(765[21] 773[2])
    defparam mosi_ddr.GSR = "ENABLED";
    FD1S3IX bit_counter_i0 (.D(bit_counter_5__N_1168[0]), .CK(internal_80MHz), 
            .CD(n14288), .Q(bit_counter[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i0.GSR = "ENABLED";
    FD1P3AX shift_reg_i0 (.D(shift_reg_15__N_1126[0]), .SP(internal_80MHz_enable_35), 
            .CK(internal_80MHz), .Q(shift_reg[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i0.GSR = "ENABLED";
    ODDRX1F sclk_ddr (.D0(shift_reg_15__N_1175), .D1(GND_net), .SCLK(internal_80MHz), 
            .RST(main_reset_n_N_208), .Q(spi2_sck_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(765[21] 773[2])
    defparam sclk_ddr.GSR = "ENABLED";
    LUT4 i2090_2_lut (.A(bit_counter[0]), .B(shift_reg_15__N_1175), .Z(bit_counter_5__N_1168[0])) /* synthesis lut_function=(!(A (B)+!A !(B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2090_2_lut.init = 16'h6666;
    LUT4 i2144_3_lut (.A(spi2_sck_N_410[0]), .B(shift_reg[1]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2144_3_lut.init = 16'hcaca;
    LUT4 i6161_3_lut_4_lut (.A(internal_80MHz_enable_36), .B(shift_reg_15__N_1175), 
         .C(n14290), .D(bit_counter[4]), .Z(bit_counter_5__N_1144[4])) /* synthesis lut_function=(A ((C (D)+!C !(D))+!B)+!A (C (D)+!C !(D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[17:44])
    defparam i6161_3_lut_4_lut.init = 16'hf22f;
    FD1P3IX bit_counter_i1 (.D(n6372), .SP(shift_reg_15__N_1175), .CD(n14288), 
            .CK(internal_80MHz), .Q(bit_counter[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i1.GSR = "ENABLED";
    FD1P3IX bit_counter_i2 (.D(n6374), .SP(shift_reg_15__N_1175), .CD(n14288), 
            .CK(internal_80MHz), .Q(bit_counter[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i2.GSR = "ENABLED";
    FD1P3IX bit_counter_i3 (.D(n6370), .SP(shift_reg_15__N_1175), .CD(n14288), 
            .CK(internal_80MHz), .Q(bit_counter[3])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i3.GSR = "ENABLED";
    FD1P3AX bit_counter_i4 (.D(bit_counter_5__N_1144[4]), .SP(internal_80MHz_enable_35), 
            .CK(internal_80MHz), .Q(bit_counter[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i4.GSR = "ENABLED";
    FD1P3IX bit_counter_i5 (.D(n6366), .SP(shift_reg_15__N_1175), .CD(n14288), 
            .CK(internal_80MHz), .Q(bit_counter[5])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i5.GSR = "ENABLED";
    FD1P3AX shift_reg_i1 (.D(shift_reg_15__N_1126[1]), .SP(internal_80MHz_enable_35), 
            .CK(internal_80MHz), .Q(shift_reg[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i1.GSR = "ENABLED";
    FD1P3AX shift_reg_i2 (.D(shift_reg_15__N_1126[2]), .SP(internal_80MHz_enable_35), 
            .CK(internal_80MHz), .Q(shift_reg[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i2.GSR = "ENABLED";
    FD1P3AX shift_reg_i3 (.D(shift_reg_15__N_1126[3]), .SP(internal_80MHz_enable_35), 
            .CK(internal_80MHz), .Q(shift_reg[3])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i3.GSR = "ENABLED";
    FD1P3AX shift_reg_i4 (.D(shift_reg_15__N_1126[4]), .SP(internal_80MHz_enable_35), 
            .CK(internal_80MHz), .Q(shift_reg[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i4.GSR = "ENABLED";
    FD1P3AX shift_reg_i5 (.D(shift_reg_15__N_1126[5]), .SP(internal_80MHz_enable_35), 
            .CK(internal_80MHz), .Q(shift_reg[5])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i5.GSR = "ENABLED";
    FD1P3AX shift_reg_i6 (.D(shift_reg_15__N_1126[6]), .SP(internal_80MHz_enable_35), 
            .CK(internal_80MHz), .Q(shift_reg[6])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i6.GSR = "ENABLED";
    FD1P3AX shift_reg_i7 (.D(shift_reg_15__N_1126[7]), .SP(internal_80MHz_enable_35), 
            .CK(internal_80MHz), .Q(shift_reg[7])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i7.GSR = "ENABLED";
    FD1P3AX shift_reg_i8 (.D(shift_reg_15__N_1126[8]), .SP(internal_80MHz_enable_35), 
            .CK(internal_80MHz), .Q(shift_reg[8])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i8.GSR = "ENABLED";
    FD1P3AX shift_reg_i9 (.D(shift_reg_15__N_1126[9]), .SP(internal_80MHz_enable_35), 
            .CK(internal_80MHz), .Q(shift_reg[9])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i9.GSR = "ENABLED";
    FD1P3AX shift_reg_i10 (.D(shift_reg_15__N_1126[10]), .SP(internal_80MHz_enable_35), 
            .CK(internal_80MHz), .Q(shift_reg[10])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i10.GSR = "ENABLED";
    FD1P3AX shift_reg_i11 (.D(shift_reg_15__N_1126[11]), .SP(internal_80MHz_enable_35), 
            .CK(internal_80MHz), .Q(shift_reg[11])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i11.GSR = "ENABLED";
    FD1P3AX shift_reg_i12 (.D(shift_reg_15__N_1126[12]), .SP(internal_80MHz_enable_35), 
            .CK(internal_80MHz), .Q(shift_reg[12])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i12.GSR = "ENABLED";
    FD1P3AX shift_reg_i13 (.D(shift_reg_15__N_1126[13]), .SP(internal_80MHz_enable_35), 
            .CK(internal_80MHz), .Q(shift_reg[13])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i13.GSR = "ENABLED";
    FD1P3AX shift_reg_i14 (.D(shift_reg_15__N_1126[14]), .SP(internal_80MHz_enable_35), 
            .CK(internal_80MHz), .Q(shift_reg[14])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i14.GSR = "ENABLED";
    FD1P3IX shift_reg_i15 (.D(spi2_sck_N_410[15]), .SP(internal_80MHz_enable_36), 
            .CD(shift_reg_15__N_1175), .CK(internal_80MHz), .Q(shift_reg[15])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=765, LSE_RLINE=773 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i15.GSR = "ENABLED";
    LUT4 i1_2_lut (.A(bit_counter[1]), .B(bit_counter[0]), .Z(n6372)) /* synthesis lut_function=(A (B)+!A !(B)) */ ;
    defparam i1_2_lut.init = 16'h9999;
    LUT4 i2437_3_lut (.A(spi2_sck_N_410[1]), .B(shift_reg[2]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[1])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2437_3_lut.init = 16'hcaca;
    LUT4 i2439_3_lut (.A(spi2_sck_N_410[2]), .B(shift_reg[3]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[2])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2439_3_lut.init = 16'hcaca;
    LUT4 i2441_3_lut (.A(spi2_sck_N_410[3]), .B(shift_reg[4]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[3])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2441_3_lut.init = 16'hcaca;
    LUT4 i2443_3_lut (.A(spi2_sck_N_410[4]), .B(shift_reg[5]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[4])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2443_3_lut.init = 16'hcaca;
    LUT4 i2445_3_lut (.A(spi2_sck_N_410[5]), .B(shift_reg[6]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[5])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2445_3_lut.init = 16'hcaca;
    LUT4 i2447_3_lut (.A(spi2_sck_N_410[6]), .B(shift_reg[7]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[6])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2447_3_lut.init = 16'hcaca;
    LUT4 i2449_3_lut (.A(spi2_sck_N_410[7]), .B(shift_reg[8]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[7])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2449_3_lut.init = 16'hcaca;
    LUT4 i2451_3_lut (.A(spi2_sck_N_410[8]), .B(shift_reg[9]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[8])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2451_3_lut.init = 16'hcaca;
    LUT4 i2453_3_lut (.A(spi2_sck_N_410[9]), .B(shift_reg[10]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[9])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2453_3_lut.init = 16'hcaca;
    LUT4 i2455_3_lut (.A(spi2_sck_N_410[10]), .B(shift_reg[11]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[10])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2455_3_lut.init = 16'hcaca;
    LUT4 i2457_3_lut (.A(spi2_sck_N_410[11]), .B(shift_reg[12]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[11])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2457_3_lut.init = 16'hcaca;
    LUT4 i2459_3_lut (.A(spi2_sck_N_410[12]), .B(shift_reg[13]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[12])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2459_3_lut.init = 16'hcaca;
    LUT4 i2461_3_lut (.A(spi2_sck_N_410[13]), .B(shift_reg[14]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[13])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2461_3_lut.init = 16'hcaca;
    LUT4 i2463_3_lut (.A(spi2_sck_N_410[14]), .B(shift_reg[15]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[14])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2463_3_lut.init = 16'hcaca;
    LUT4 i6085_2_lut (.A(shift_reg[0]), .B(shift_reg_15__N_1175), .Z(o_mosi_N_1176)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(398[8:46])
    defparam i6085_2_lut.init = 16'h8888;
    LUT4 i1_4_lut (.A(bit_counter[4]), .B(n13124), .C(n13122), .D(bit_counter[5]), 
         .Z(shift_reg_15__N_1175)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(390[8:24])
    defparam i1_4_lut.init = 16'hfffe;
    LUT4 i1_2_lut_adj_212 (.A(bit_counter[0]), .B(bit_counter[3]), .Z(n13124)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(390[8:24])
    defparam i1_2_lut_adj_212.init = 16'heeee;
    LUT4 i1_2_lut_adj_213 (.A(bit_counter[2]), .B(bit_counter[1]), .Z(n13122)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(390[8:24])
    defparam i1_2_lut_adj_213.init = 16'heeee;
    LUT4 i1_3_lut_4_lut (.A(bit_counter[3]), .B(n14313), .C(bit_counter[4]), 
         .D(bit_counter[5]), .Z(n6366)) /* synthesis lut_function=(A (D)+!A (B (D)+!B (C (D)+!C !(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1_3_lut_4_lut.init = 16'hfe01;
    LUT4 i1_2_lut_3_lut (.A(bit_counter[1]), .B(bit_counter[0]), .C(bit_counter[2]), 
         .Z(n6374)) /* synthesis lut_function=(A (C)+!A (B (C)+!B !(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1_2_lut_3_lut.init = 16'he1e1;
    LUT4 i1808_2_lut_rep_229_3_lut (.A(bit_counter[1]), .B(bit_counter[0]), 
         .C(bit_counter[2]), .Z(n14313)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1808_2_lut_rep_229_3_lut.init = 16'hfefe;
    LUT4 i1_2_lut_3_lut_4_lut (.A(bit_counter[1]), .B(bit_counter[0]), .C(bit_counter[3]), 
         .D(bit_counter[2]), .Z(n6370)) /* synthesis lut_function=(A (C)+!A (B (C)+!B (C (D)+!C !(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1_2_lut_3_lut_4_lut.init = 16'hf0e1;
    LUT4 i1816_2_lut_rep_206_3_lut_4_lut (.A(bit_counter[1]), .B(bit_counter[0]), 
         .C(bit_counter[3]), .D(bit_counter[2]), .Z(n14290)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1816_2_lut_rep_206_3_lut_4_lut.init = 16'hfffe;
    
endmodule
//
// Verilog Description of module ecp5_spi_master_top_U0
//

module ecp5_spi_master_top_U0 (internal_80MHz, n14287, spi3_mosi_c, main_reset_n_N_208, 
            internal_80MHz_enable_51, GND_net, spi3_sck_c, shift_reg_15__N_1175, 
            internal_80MHz_enable_52, spi3_sck_N_426) /* synthesis syn_module_defined=1 */ ;
    input internal_80MHz;
    input n14287;
    output spi3_mosi_c;
    input main_reset_n_N_208;
    input internal_80MHz_enable_51;
    input GND_net;
    output spi3_sck_c;
    output shift_reg_15__N_1175;
    input internal_80MHz_enable_52;
    input [15:0]spi3_sck_N_426;
    
    wire internal_80MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_80MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(84[6:20])
    wire [5:0]bit_counter;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(386[15:26])
    wire [5:0]bit_counter_5__N_1168;
    
    wire o_mosi_N_1176;
    wire [15:0]shift_reg;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(385[16:25])
    wire [15:0]shift_reg_15__N_1126;
    
    wire n14289;
    wire [5:0]bit_counter_5__N_1144;
    
    wire n13148, n13146, n6362, n6364, n6360, n6356, n14312;
    
    FD1S3IX bit_counter_i0 (.D(bit_counter_5__N_1168[0]), .CK(internal_80MHz), 
            .CD(n14287), .Q(bit_counter[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i0.GSR = "ENABLED";
    ODDRX1F mosi_ddr (.D0(o_mosi_N_1176), .D1(o_mosi_N_1176), .SCLK(internal_80MHz), 
            .RST(main_reset_n_N_208), .Q(spi3_mosi_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(776[21] 784[2])
    defparam mosi_ddr.GSR = "ENABLED";
    FD1P3AX shift_reg_i0 (.D(shift_reg_15__N_1126[0]), .SP(internal_80MHz_enable_51), 
            .CK(internal_80MHz), .Q(shift_reg[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i0.GSR = "ENABLED";
    ODDRX1F sclk_ddr (.D0(shift_reg_15__N_1175), .D1(GND_net), .SCLK(internal_80MHz), 
            .RST(main_reset_n_N_208), .Q(spi3_sck_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(776[21] 784[2])
    defparam sclk_ddr.GSR = "ENABLED";
    LUT4 i6163_3_lut_4_lut (.A(internal_80MHz_enable_52), .B(shift_reg_15__N_1175), 
         .C(n14289), .D(bit_counter[4]), .Z(bit_counter_5__N_1144[4])) /* synthesis lut_function=(A ((C (D)+!C !(D))+!B)+!A (C (D)+!C !(D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[17:44])
    defparam i6163_3_lut_4_lut.init = 16'hf22f;
    LUT4 i2473_3_lut (.A(spi3_sck_N_426[4]), .B(shift_reg[5]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[4])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2473_3_lut.init = 16'hcaca;
    LUT4 i2475_3_lut (.A(spi3_sck_N_426[5]), .B(shift_reg[6]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[5])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2475_3_lut.init = 16'hcaca;
    LUT4 i2477_3_lut (.A(spi3_sck_N_426[6]), .B(shift_reg[7]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[6])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2477_3_lut.init = 16'hcaca;
    LUT4 i2091_2_lut (.A(bit_counter[0]), .B(shift_reg_15__N_1175), .Z(bit_counter_5__N_1168[0])) /* synthesis lut_function=(!(A (B)+!A !(B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2091_2_lut.init = 16'h6666;
    LUT4 i1_4_lut (.A(bit_counter[4]), .B(n13148), .C(n13146), .D(bit_counter[5]), 
         .Z(shift_reg_15__N_1175)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(390[8:24])
    defparam i1_4_lut.init = 16'hfffe;
    LUT4 i2479_3_lut (.A(spi3_sck_N_426[7]), .B(shift_reg[8]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[7])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2479_3_lut.init = 16'hcaca;
    FD1P3IX bit_counter_i1 (.D(n6362), .SP(shift_reg_15__N_1175), .CD(n14287), 
            .CK(internal_80MHz), .Q(bit_counter[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i1.GSR = "ENABLED";
    FD1P3IX bit_counter_i2 (.D(n6364), .SP(shift_reg_15__N_1175), .CD(n14287), 
            .CK(internal_80MHz), .Q(bit_counter[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i2.GSR = "ENABLED";
    FD1P3IX bit_counter_i3 (.D(n6360), .SP(shift_reg_15__N_1175), .CD(n14287), 
            .CK(internal_80MHz), .Q(bit_counter[3])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i3.GSR = "ENABLED";
    FD1P3AX bit_counter_i4 (.D(bit_counter_5__N_1144[4]), .SP(internal_80MHz_enable_51), 
            .CK(internal_80MHz), .Q(bit_counter[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i4.GSR = "ENABLED";
    FD1P3IX bit_counter_i5 (.D(n6356), .SP(shift_reg_15__N_1175), .CD(n14287), 
            .CK(internal_80MHz), .Q(bit_counter[5])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i5.GSR = "ENABLED";
    FD1P3AX shift_reg_i1 (.D(shift_reg_15__N_1126[1]), .SP(internal_80MHz_enable_51), 
            .CK(internal_80MHz), .Q(shift_reg[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i1.GSR = "ENABLED";
    FD1P3AX shift_reg_i2 (.D(shift_reg_15__N_1126[2]), .SP(internal_80MHz_enable_51), 
            .CK(internal_80MHz), .Q(shift_reg[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i2.GSR = "ENABLED";
    FD1P3AX shift_reg_i3 (.D(shift_reg_15__N_1126[3]), .SP(internal_80MHz_enable_51), 
            .CK(internal_80MHz), .Q(shift_reg[3])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i3.GSR = "ENABLED";
    FD1P3AX shift_reg_i4 (.D(shift_reg_15__N_1126[4]), .SP(internal_80MHz_enable_51), 
            .CK(internal_80MHz), .Q(shift_reg[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i4.GSR = "ENABLED";
    FD1P3AX shift_reg_i5 (.D(shift_reg_15__N_1126[5]), .SP(internal_80MHz_enable_51), 
            .CK(internal_80MHz), .Q(shift_reg[5])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i5.GSR = "ENABLED";
    FD1P3AX shift_reg_i6 (.D(shift_reg_15__N_1126[6]), .SP(internal_80MHz_enable_51), 
            .CK(internal_80MHz), .Q(shift_reg[6])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i6.GSR = "ENABLED";
    FD1P3AX shift_reg_i7 (.D(shift_reg_15__N_1126[7]), .SP(internal_80MHz_enable_51), 
            .CK(internal_80MHz), .Q(shift_reg[7])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i7.GSR = "ENABLED";
    FD1P3AX shift_reg_i8 (.D(shift_reg_15__N_1126[8]), .SP(internal_80MHz_enable_51), 
            .CK(internal_80MHz), .Q(shift_reg[8])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i8.GSR = "ENABLED";
    FD1P3AX shift_reg_i9 (.D(shift_reg_15__N_1126[9]), .SP(internal_80MHz_enable_51), 
            .CK(internal_80MHz), .Q(shift_reg[9])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i9.GSR = "ENABLED";
    FD1P3AX shift_reg_i10 (.D(shift_reg_15__N_1126[10]), .SP(internal_80MHz_enable_51), 
            .CK(internal_80MHz), .Q(shift_reg[10])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i10.GSR = "ENABLED";
    FD1P3AX shift_reg_i11 (.D(shift_reg_15__N_1126[11]), .SP(internal_80MHz_enable_51), 
            .CK(internal_80MHz), .Q(shift_reg[11])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i11.GSR = "ENABLED";
    FD1P3AX shift_reg_i12 (.D(shift_reg_15__N_1126[12]), .SP(internal_80MHz_enable_51), 
            .CK(internal_80MHz), .Q(shift_reg[12])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i12.GSR = "ENABLED";
    FD1P3AX shift_reg_i13 (.D(shift_reg_15__N_1126[13]), .SP(internal_80MHz_enable_51), 
            .CK(internal_80MHz), .Q(shift_reg[13])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i13.GSR = "ENABLED";
    FD1P3AX shift_reg_i14 (.D(shift_reg_15__N_1126[14]), .SP(internal_80MHz_enable_51), 
            .CK(internal_80MHz), .Q(shift_reg[14])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i14.GSR = "ENABLED";
    FD1P3IX shift_reg_i15 (.D(spi3_sck_N_426[15]), .SP(internal_80MHz_enable_52), 
            .CD(shift_reg_15__N_1175), .CK(internal_80MHz), .Q(shift_reg[15])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=776, LSE_RLINE=784 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i15.GSR = "ENABLED";
    LUT4 i2481_3_lut (.A(spi3_sck_N_426[8]), .B(shift_reg[9]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[8])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2481_3_lut.init = 16'hcaca;
    LUT4 i1_2_lut (.A(bit_counter[1]), .B(bit_counter[0]), .Z(n6362)) /* synthesis lut_function=(A (B)+!A !(B)) */ ;
    defparam i1_2_lut.init = 16'h9999;
    LUT4 i2467_3_lut (.A(spi3_sck_N_426[1]), .B(shift_reg[2]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[1])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2467_3_lut.init = 16'hcaca;
    LUT4 i2469_3_lut (.A(spi3_sck_N_426[2]), .B(shift_reg[3]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[2])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2469_3_lut.init = 16'hcaca;
    LUT4 i2471_3_lut (.A(spi3_sck_N_426[3]), .B(shift_reg[4]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[3])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2471_3_lut.init = 16'hcaca;
    LUT4 i2483_3_lut (.A(spi3_sck_N_426[9]), .B(shift_reg[10]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[9])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2483_3_lut.init = 16'hcaca;
    LUT4 i2485_3_lut (.A(spi3_sck_N_426[10]), .B(shift_reg[11]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[10])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2485_3_lut.init = 16'hcaca;
    LUT4 i2487_3_lut (.A(spi3_sck_N_426[11]), .B(shift_reg[12]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[11])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2487_3_lut.init = 16'hcaca;
    LUT4 i1_3_lut_4_lut (.A(bit_counter[3]), .B(n14312), .C(bit_counter[4]), 
         .D(bit_counter[5]), .Z(n6356)) /* synthesis lut_function=(A (D)+!A (B (D)+!B (C (D)+!C !(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1_3_lut_4_lut.init = 16'hfe01;
    LUT4 i2489_3_lut (.A(spi3_sck_N_426[12]), .B(shift_reg[13]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[12])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2489_3_lut.init = 16'hcaca;
    LUT4 i2491_3_lut (.A(spi3_sck_N_426[13]), .B(shift_reg[14]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[13])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2491_3_lut.init = 16'hcaca;
    LUT4 i2493_3_lut (.A(spi3_sck_N_426[14]), .B(shift_reg[15]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[14])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2493_3_lut.init = 16'hcaca;
    LUT4 i1_2_lut_adj_210 (.A(bit_counter[0]), .B(bit_counter[3]), .Z(n13148)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(390[8:24])
    defparam i1_2_lut_adj_210.init = 16'heeee;
    LUT4 i1_2_lut_adj_211 (.A(bit_counter[2]), .B(bit_counter[1]), .Z(n13146)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(390[8:24])
    defparam i1_2_lut_adj_211.init = 16'heeee;
    LUT4 i6086_2_lut (.A(shift_reg[0]), .B(shift_reg_15__N_1175), .Z(o_mosi_N_1176)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(398[8:46])
    defparam i6086_2_lut.init = 16'h8888;
    LUT4 i2146_3_lut (.A(spi3_sck_N_426[0]), .B(shift_reg[1]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2146_3_lut.init = 16'hcaca;
    LUT4 i1_2_lut_3_lut (.A(bit_counter[1]), .B(bit_counter[0]), .C(bit_counter[2]), 
         .Z(n6364)) /* synthesis lut_function=(A (C)+!A (B (C)+!B !(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1_2_lut_3_lut.init = 16'he1e1;
    LUT4 i1856_2_lut_rep_228_3_lut (.A(bit_counter[1]), .B(bit_counter[0]), 
         .C(bit_counter[2]), .Z(n14312)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1856_2_lut_rep_228_3_lut.init = 16'hfefe;
    LUT4 i1_2_lut_3_lut_4_lut (.A(bit_counter[1]), .B(bit_counter[0]), .C(bit_counter[3]), 
         .D(bit_counter[2]), .Z(n6360)) /* synthesis lut_function=(A (C)+!A (B (C)+!B (C (D)+!C !(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1_2_lut_3_lut_4_lut.init = 16'hf0e1;
    LUT4 i1864_2_lut_rep_205_3_lut_4_lut (.A(bit_counter[1]), .B(bit_counter[0]), 
         .C(bit_counter[3]), .D(bit_counter[2]), .Z(n14289)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1864_2_lut_rep_205_3_lut_4_lut.init = 16'hfffe;
    
endmodule
//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

//
// Verilog Description of module fifo_dc_16in_16out_U5
//

module fifo_dc_16in_16out_U5 (sdr_rxclk_c, internal_80MHz, rRst, subg_i_empty, 
            VCC_net, GND_net, w_rx_09_fifo_push, subg_i_empty_N_227, 
            \w_rx_09_fifo_data[31] , \w_rx_09_fifo_data[30] , \w_rx_09_fifo_data[29] , 
            \w_rx_09_fifo_data[28] , \w_rx_09_fifo_data[27] , \w_rx_09_fifo_data[26] , 
            \w_rx_09_fifo_data[25] , \w_rx_09_fifo_data[24] , \w_rx_09_fifo_data[23] , 
            \w_rx_09_fifo_data[22] , \w_rx_09_fifo_data[21] , \w_rx_09_fifo_data[20] , 
            \w_rx_09_fifo_data[19] , \w_rx_09_fifo_data[18] , \w_rx_09_fifo_data[17] , 
            \w_rx_09_fifo_data[16] , main_reset_n_N_208, subg_i_fifo_data_out) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;
    input sdr_rxclk_c;
    input internal_80MHz;
    input rRst;
    output subg_i_empty;
    input VCC_net;
    input GND_net;
    input w_rx_09_fifo_push;
    input subg_i_empty_N_227;
    input \w_rx_09_fifo_data[31] ;
    input \w_rx_09_fifo_data[30] ;
    input \w_rx_09_fifo_data[29] ;
    input \w_rx_09_fifo_data[28] ;
    input \w_rx_09_fifo_data[27] ;
    input \w_rx_09_fifo_data[26] ;
    input \w_rx_09_fifo_data[25] ;
    input \w_rx_09_fifo_data[24] ;
    input \w_rx_09_fifo_data[23] ;
    input \w_rx_09_fifo_data[22] ;
    input \w_rx_09_fifo_data[21] ;
    input \w_rx_09_fifo_data[20] ;
    input \w_rx_09_fifo_data[19] ;
    input \w_rx_09_fifo_data[18] ;
    input \w_rx_09_fifo_data[17] ;
    input \w_rx_09_fifo_data[16] ;
    input main_reset_n_N_208;
    output [15:0]subg_i_fifo_data_out;
    
    wire sdr_rxclk_c /* synthesis IO_TYPES="LVDS", is_clock=1, SET_AS_NETWORK=sdr_rxclk_c */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(10[13:22])
    wire internal_80MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_80MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(84[6:20])
    wire VCC_net /* synthesis CE_NET_FOR_BUS20=20, DSPPORT_20=CE3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(26[14:27])
    
    wire wcount_2, wren_i, iwcount_2, w_gcount_0, w_gdata_0, w_gcount_1, 
        w_gdata_1, w_gcount_2, wptr_0, wcount_0, wptr_1, wcount_1, 
        wptr_2, w_gcount_r0, ircount_0, rden_i, rcount_0, ircount_1, 
        rcount_1, ircount_2, rcount_2, r_gdata_0, r_gcount_0, r_gdata_1, 
        r_gcount_1, r_gcount_2, rptr_0, rptr_1, rptr_2, w_gcount_r1, 
        w_gcount_r2, w_gcount_r20, r_gcount_w0, r_gcount_w1, r_gcount_w2, 
        w_gcount_r21, w_gcount_r22, Full, full_d, r_gcount_w20, r_gcount_w21, 
        r_gcount_w22, empty_d, iwcount_0, w_gctr_ci, iwcount_1, co0, 
        r_gctr_ci, co0_1, cmp_ci, wcount_r0, wcount_r1, co0_2, empty_cmp_clr, 
        empty_cmp_set, empty_d_c, cmp_ci_1, rcount_w0, rcount_w1, 
        co0_3, full_cmp_clr, full_cmp_set, full_d_c, invout_1, invout_0;
    
    FD1P3AX FF_29 (.D(iwcount_2), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(192[13] 193[22])
    defparam FF_29.GSR = "ENABLED";
    FD1P3AX FF_28 (.D(w_gdata_0), .SP(wren_i), .CK(sdr_rxclk_c), .Q(w_gcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(196[13] 197[24])
    defparam FF_28.GSR = "ENABLED";
    FD1P3AX FF_27 (.D(w_gdata_1), .SP(wren_i), .CK(sdr_rxclk_c), .Q(w_gcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(200[13] 201[24])
    defparam FF_27.GSR = "ENABLED";
    FD1P3AX FF_26 (.D(wcount_2), .SP(wren_i), .CK(sdr_rxclk_c), .Q(w_gcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(204[13] 205[24])
    defparam FF_26.GSR = "ENABLED";
    FD1P3AX FF_25 (.D(wcount_0), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wptr_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(208[13] 209[20])
    defparam FF_25.GSR = "ENABLED";
    FD1P3AX FF_24 (.D(wcount_1), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wptr_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(212[13] 213[20])
    defparam FF_24.GSR = "ENABLED";
    FD1P3AX FF_23 (.D(wcount_2), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wptr_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(216[13] 217[20])
    defparam FF_23.GSR = "ENABLED";
    FD1S3AX FF_13 (.D(w_gcount_0), .CK(internal_80MHz), .Q(w_gcount_r0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(252[13:78])
    defparam FF_13.GSR = "ENABLED";
    FD1P3BX FF_22 (.D(ircount_0), .SP(rden_i), .CK(internal_80MHz), .PD(rRst), 
            .Q(rcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(220[13] 221[22])
    defparam FF_22.GSR = "DISABLED";
    FD1P3DX FF_21 (.D(ircount_1), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(224[13] 225[22])
    defparam FF_21.GSR = "DISABLED";
    FD1P3DX FF_20 (.D(ircount_2), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(228[13] 229[22])
    defparam FF_20.GSR = "DISABLED";
    FD1P3DX FF_19 (.D(r_gdata_0), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(232[13] 233[24])
    defparam FF_19.GSR = "DISABLED";
    FD1P3DX FF_18 (.D(r_gdata_1), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(236[13] 237[24])
    defparam FF_18.GSR = "DISABLED";
    FD1P3DX FF_17 (.D(rcount_2), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(240[13:87])
    defparam FF_17.GSR = "DISABLED";
    FD1P3DX FF_16 (.D(rcount_0), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(243[13:83])
    defparam FF_16.GSR = "DISABLED";
    FD1P3DX FF_15 (.D(rcount_1), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(246[13:83])
    defparam FF_15.GSR = "DISABLED";
    FD1P3DX FF_14 (.D(rcount_2), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(249[13:83])
    defparam FF_14.GSR = "DISABLED";
    FD1S3AX FF_12 (.D(w_gcount_1), .CK(internal_80MHz), .Q(w_gcount_r1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(255[13:78])
    defparam FF_12.GSR = "ENABLED";
    FD1S3AX FF_11 (.D(w_gcount_2), .CK(internal_80MHz), .Q(w_gcount_r2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(258[13:78])
    defparam FF_11.GSR = "ENABLED";
    FD1S3AX FF_7 (.D(w_gcount_r0), .CK(internal_80MHz), .Q(w_gcount_r20)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(270[13:79])
    defparam FF_7.GSR = "ENABLED";
    FD1S3DX FF_10 (.D(r_gcount_0), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(261[13:77])
    defparam FF_10.GSR = "DISABLED";
    FD1S3DX FF_9 (.D(r_gcount_1), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(264[13:76])
    defparam FF_9.GSR = "DISABLED";
    FD1S3DX FF_8 (.D(r_gcount_2), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(267[13:76])
    defparam FF_8.GSR = "DISABLED";
    FD1S3AX FF_6 (.D(w_gcount_r1), .CK(internal_80MHz), .Q(w_gcount_r21)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(273[13:79])
    defparam FF_6.GSR = "ENABLED";
    FD1S3AX FF_5 (.D(w_gcount_r2), .CK(internal_80MHz), .Q(w_gcount_r22)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(276[13:79])
    defparam FF_5.GSR = "ENABLED";
    FD1S3AX FF_0 (.D(full_d), .CK(sdr_rxclk_c), .Q(Full)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(291[13:68])
    defparam FF_0.GSR = "ENABLED";
    FD1S3DX FF_4 (.D(r_gcount_w0), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w20)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(279[13:78])
    defparam FF_4.GSR = "DISABLED";
    FD1S3DX FF_3 (.D(r_gcount_w1), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w21)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(282[13:78])
    defparam FF_3.GSR = "DISABLED";
    FD1S3DX FF_2 (.D(r_gcount_w2), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w22)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(285[13:78])
    defparam FF_2.GSR = "DISABLED";
    FD1S3BX FF_1 (.D(empty_d), .CK(internal_80MHz), .PD(rRst), .Q(subg_i_empty)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(288[13:69])
    defparam FF_1.GSR = "DISABLED";
    FD1P3AY FF_31 (.D(iwcount_0), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(184[13] 185[22])
    defparam FF_31.GSR = "ENABLED";
    CCU2C w_gctr_cia (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(VCC_net), .B1(VCC_net), .C1(VCC_net), .D1(VCC_net), .COUT(w_gctr_ci)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(298[11] 300[48])
    defparam w_gctr_cia.INIT0 = 16'b0110011010101010;
    defparam w_gctr_cia.INIT1 = 16'b0110011010101010;
    defparam w_gctr_cia.INJECT1_0 = "NO";
    defparam w_gctr_cia.INJECT1_1 = "NO";
    CCU2C w_gctr_0 (.A0(wcount_0), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(wcount_1), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(w_gctr_ci), 
          .COUT(co0), .S0(iwcount_0), .S1(iwcount_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(306[11] 308[69])
    defparam w_gctr_0.INIT0 = 16'b0110011010101010;
    defparam w_gctr_0.INIT1 = 16'b0110011010101010;
    defparam w_gctr_0.INJECT1_0 = "NO";
    defparam w_gctr_0.INJECT1_1 = "NO";
    CCU2C w_gctr_1 (.A0(wcount_2), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(co0), 
          .S0(iwcount_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(314[11] 316[54])
    defparam w_gctr_1.INIT0 = 16'b0110011010101010;
    defparam w_gctr_1.INIT1 = 16'b0110011010101010;
    defparam w_gctr_1.INJECT1_0 = "NO";
    defparam w_gctr_1.INJECT1_1 = "NO";
    CCU2C r_gctr_cia (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(VCC_net), .B1(VCC_net), .C1(VCC_net), .D1(VCC_net), .COUT(r_gctr_ci)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(322[11] 324[48])
    defparam r_gctr_cia.INIT0 = 16'b0110011010101010;
    defparam r_gctr_cia.INIT1 = 16'b0110011010101010;
    defparam r_gctr_cia.INJECT1_0 = "NO";
    defparam r_gctr_cia.INJECT1_1 = "NO";
    CCU2C r_gctr_0 (.A0(rcount_0), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(rcount_1), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(r_gctr_ci), 
          .COUT(co0_1), .S0(ircount_0), .S1(ircount_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(330[11] 332[71])
    defparam r_gctr_0.INIT0 = 16'b0110011010101010;
    defparam r_gctr_0.INIT1 = 16'b0110011010101010;
    defparam r_gctr_0.INJECT1_0 = "NO";
    defparam r_gctr_0.INJECT1_1 = "NO";
    CCU2C r_gctr_1 (.A0(rcount_2), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(co0_1), 
          .S0(ircount_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(338[11] 340[58])
    defparam r_gctr_1.INIT0 = 16'b0110011010101010;
    defparam r_gctr_1.INIT1 = 16'b0110011010101010;
    defparam r_gctr_1.INJECT1_0 = "NO";
    defparam r_gctr_1.INJECT1_1 = "NO";
    CCU2C empty_cmp_ci_a (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(rden_i), .B1(rden_i), .C1(VCC_net), .D1(VCC_net), .COUT(cmp_ci)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(346[11] 348[45])
    defparam empty_cmp_ci_a.INIT0 = 16'b0110011010101010;
    defparam empty_cmp_ci_a.INIT1 = 16'b0110011010101010;
    defparam empty_cmp_ci_a.INJECT1_0 = "NO";
    defparam empty_cmp_ci_a.INJECT1_1 = "NO";
    CCU2C empty_cmp_0 (.A0(rcount_0), .B0(wcount_r0), .C0(VCC_net), .D0(VCC_net), 
          .A1(rcount_1), .B1(wcount_r1), .C1(VCC_net), .D1(VCC_net), 
          .CIN(cmp_ci), .COUT(co0_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(354[11] 356[50])
    defparam empty_cmp_0.INIT0 = 16'b1001100110101010;
    defparam empty_cmp_0.INIT1 = 16'b1001100110101010;
    defparam empty_cmp_0.INJECT1_0 = "NO";
    defparam empty_cmp_0.INJECT1_1 = "NO";
    CCU2C empty_cmp_1 (.A0(empty_cmp_set), .B0(empty_cmp_clr), .C0(VCC_net), 
          .D0(VCC_net), .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), 
          .CIN(co0_2), .COUT(empty_d_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(362[11] 364[69])
    defparam empty_cmp_1.INIT0 = 16'b1001100110101010;
    defparam empty_cmp_1.INIT1 = 16'b1001100110101010;
    defparam empty_cmp_1.INJECT1_0 = "NO";
    defparam empty_cmp_1.INJECT1_1 = "NO";
    CCU2C a0 (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(empty_d_c), 
          .S0(empty_d)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(370[11] 372[55])
    defparam a0.INIT0 = 16'b0110011010101010;
    defparam a0.INIT1 = 16'b0110011010101010;
    defparam a0.INJECT1_0 = "NO";
    defparam a0.INJECT1_1 = "NO";
    CCU2C full_cmp_ci_a (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(wren_i), .B1(wren_i), .C1(VCC_net), .D1(VCC_net), .COUT(cmp_ci_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(378[11] 380[47])
    defparam full_cmp_ci_a.INIT0 = 16'b0110011010101010;
    defparam full_cmp_ci_a.INIT1 = 16'b0110011010101010;
    defparam full_cmp_ci_a.INJECT1_0 = "NO";
    defparam full_cmp_ci_a.INJECT1_1 = "NO";
    CCU2C full_cmp_0 (.A0(wcount_0), .B0(rcount_w0), .C0(VCC_net), .D0(VCC_net), 
          .A1(wcount_1), .B1(rcount_w1), .C1(VCC_net), .D1(VCC_net), 
          .CIN(cmp_ci_1), .COUT(co0_3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(386[11] 388[52])
    defparam full_cmp_0.INIT0 = 16'b1001100110101010;
    defparam full_cmp_0.INIT1 = 16'b1001100110101010;
    defparam full_cmp_0.INJECT1_0 = "NO";
    defparam full_cmp_0.INJECT1_1 = "NO";
    CCU2C full_cmp_1 (.A0(full_cmp_set), .B0(full_cmp_clr), .C0(VCC_net), 
          .D0(VCC_net), .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), 
          .CIN(co0_3), .COUT(full_d_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(394[11] 396[68])
    defparam full_cmp_1.INIT0 = 16'b1001100110101010;
    defparam full_cmp_1.INIT1 = 16'b1001100110101010;
    defparam full_cmp_1.INJECT1_0 = "NO";
    defparam full_cmp_1.INJECT1_1 = "NO";
    CCU2C a1 (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(full_d_c), 
          .S0(full_d)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(406[11] 408[53])
    defparam a1.INIT0 = 16'b0110011010101010;
    defparam a1.INIT1 = 16'b0110011010101010;
    defparam a1.INJECT1_0 = "NO";
    defparam a1.INJECT1_1 = "NO";
    INV INV_1 (.A(Full), .Z(invout_1)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(647[20] 658[2])
    AND2 AND2_t6 (.A(w_rx_09_fifo_push), .B(invout_1), .Z(wren_i)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(93[10:54])
    AND2 AND2_t5 (.A(subg_i_empty_N_227), .B(invout_0), .Z(rden_i)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(97[10:54])
    INV INV_0 (.A(subg_i_empty), .Z(invout_0)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(647[20] 658[2])
    XOR2 XOR2_t3 (.A(wcount_0), .B(wcount_1), .Z(w_gdata_0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(103[10:61])
    XOR2 XOR2_t2 (.A(wcount_1), .B(wcount_2), .Z(w_gdata_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(105[10:61])
    XOR2 XOR2_t1 (.A(rcount_0), .B(rcount_1), .Z(r_gdata_0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(107[10:61])
    XOR2 XOR2_t0 (.A(rcount_1), .B(rcount_2), .Z(r_gdata_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(109[10:61])
    ROM16X1A LUT4_7 (.AD0(GND_net), .AD1(GND_net), .AD2(w_gcount_r22), 
            .AD3(w_gcount_r21), .DO0(wcount_r1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(647[20] 658[2])
    defparam LUT4_7.initval = 16'b0110100110010110;
    ROM16X1A LUT4_6 (.AD0(GND_net), .AD1(w_gcount_r22), .AD2(w_gcount_r21), 
            .AD3(w_gcount_r20), .DO0(wcount_r0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(647[20] 658[2])
    defparam LUT4_6.initval = 16'b0110100110010110;
    ROM16X1A LUT4_5 (.AD0(GND_net), .AD1(GND_net), .AD2(r_gcount_w22), 
            .AD3(r_gcount_w21), .DO0(rcount_w1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(647[20] 658[2])
    defparam LUT4_5.initval = 16'b0110100110010110;
    ROM16X1A LUT4_4 (.AD0(GND_net), .AD1(r_gcount_w22), .AD2(r_gcount_w21), 
            .AD3(r_gcount_w20), .DO0(rcount_w0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(647[20] 658[2])
    defparam LUT4_4.initval = 16'b0110100110010110;
    ROM16X1A LUT4_3 (.AD0(GND_net), .AD1(w_gcount_r22), .AD2(rcount_2), 
            .AD3(rptr_2), .DO0(empty_cmp_set)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(647[20] 658[2])
    defparam LUT4_3.initval = 16'b0000010000010000;
    ROM16X1A LUT4_2 (.AD0(GND_net), .AD1(w_gcount_r22), .AD2(rcount_2), 
            .AD3(rptr_2), .DO0(empty_cmp_clr)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(647[20] 658[2])
    defparam LUT4_2.initval = 16'b0001000000000100;
    ROM16X1A LUT4_1 (.AD0(GND_net), .AD1(r_gcount_w22), .AD2(wcount_2), 
            .AD3(wptr_2), .DO0(full_cmp_set)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(647[20] 658[2])
    defparam LUT4_1.initval = 16'b0000000101000000;
    ROM16X1A LUT4_0 (.AD0(GND_net), .AD1(r_gcount_w22), .AD2(wcount_2), 
            .AD3(wptr_2), .DO0(full_cmp_clr)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(647[20] 658[2])
    defparam LUT4_0.initval = 16'b0100000000000001;
    DP16KD pdp_ram_0_0_0 (.DIA0(\w_rx_09_fifo_data[16] ), .DIA1(\w_rx_09_fifo_data[17] ), 
           .DIA2(\w_rx_09_fifo_data[18] ), .DIA3(\w_rx_09_fifo_data[19] ), 
           .DIA4(\w_rx_09_fifo_data[20] ), .DIA5(\w_rx_09_fifo_data[21] ), 
           .DIA6(\w_rx_09_fifo_data[22] ), .DIA7(\w_rx_09_fifo_data[23] ), 
           .DIA8(\w_rx_09_fifo_data[24] ), .DIA9(\w_rx_09_fifo_data[25] ), 
           .DIA10(\w_rx_09_fifo_data[26] ), .DIA11(\w_rx_09_fifo_data[27] ), 
           .DIA12(\w_rx_09_fifo_data[28] ), .DIA13(\w_rx_09_fifo_data[29] ), 
           .DIA14(\w_rx_09_fifo_data[30] ), .DIA15(\w_rx_09_fifo_data[31] ), 
           .DIA16(GND_net), .DIA17(GND_net), .ADA0(VCC_net), .ADA1(VCC_net), 
           .ADA2(GND_net), .ADA3(GND_net), .ADA4(wptr_0), .ADA5(wptr_1), 
           .ADA6(GND_net), .ADA7(GND_net), .ADA8(GND_net), .ADA9(GND_net), 
           .ADA10(GND_net), .ADA11(GND_net), .ADA12(GND_net), .ADA13(GND_net), 
           .CEA(wren_i), .OCEA(wren_i), .CLKA(sdr_rxclk_c), .WEA(VCC_net), 
           .CSA0(GND_net), .CSA1(GND_net), .CSA2(GND_net), .RSTA(main_reset_n_N_208), 
           .DIB0(GND_net), .DIB1(GND_net), .DIB2(GND_net), .DIB3(GND_net), 
           .DIB4(GND_net), .DIB5(GND_net), .DIB6(GND_net), .DIB7(GND_net), 
           .DIB8(GND_net), .DIB9(GND_net), .DIB10(GND_net), .DIB11(GND_net), 
           .DIB12(GND_net), .DIB13(GND_net), .DIB14(GND_net), .DIB15(GND_net), 
           .DIB16(GND_net), .DIB17(GND_net), .ADB0(GND_net), .ADB1(GND_net), 
           .ADB2(GND_net), .ADB3(GND_net), .ADB4(rptr_0), .ADB5(rptr_1), 
           .ADB6(GND_net), .ADB7(GND_net), .ADB8(GND_net), .ADB9(GND_net), 
           .ADB10(GND_net), .ADB11(GND_net), .ADB12(GND_net), .ADB13(GND_net), 
           .CEB(rden_i), .OCEB(rden_i), .CLKB(internal_80MHz), .WEB(GND_net), 
           .CSB0(GND_net), .CSB1(GND_net), .CSB2(GND_net), .RSTB(main_reset_n_N_208), 
           .DOB0(subg_i_fifo_data_out[0]), .DOB1(subg_i_fifo_data_out[1]), 
           .DOB2(subg_i_fifo_data_out[2]), .DOB3(subg_i_fifo_data_out[3]), 
           .DOB4(subg_i_fifo_data_out[4]), .DOB5(subg_i_fifo_data_out[5]), 
           .DOB6(subg_i_fifo_data_out[6]), .DOB7(subg_i_fifo_data_out[7]), 
           .DOB8(subg_i_fifo_data_out[8]), .DOB9(subg_i_fifo_data_out[9]), 
           .DOB10(subg_i_fifo_data_out[10]), .DOB11(subg_i_fifo_data_out[11]), 
           .DOB12(subg_i_fifo_data_out[12]), .DOB13(subg_i_fifo_data_out[13]), 
           .DOB14(subg_i_fifo_data_out[14]), .DOB15(subg_i_fifo_data_out[15])) /* synthesis MEM_LPC_FILE="fifo_dc_16in_16out.lpc", MEM_INIT_FILE="", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(647[20] 658[2])
    defparam pdp_ram_0_0_0.DATA_WIDTH_A = 18;
    defparam pdp_ram_0_0_0.DATA_WIDTH_B = 18;
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
    FD1P3AX FF_30 (.D(iwcount_1), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(188[13] 189[22])
    defparam FF_30.GSR = "ENABLED";
    
endmodule
//
// Verilog Description of module word_align_3state_U6
//

module word_align_3state_U6 (sample_count, n14337, n14294, \sample_count[6] , 
            r_state, n12902, sr, n11488, n13204, \sample_count[2] , 
            \sample_count[3] , sdr_rxclk_c, i_ddr_data, n14315, r_candidate_offset, 
            \candidate_sr[30] , n14316, sdr_rxclk_c_enable_88, \sample_count_next[0] , 
            n13401, w_rx_09_fifo_data, n14304, n14268, real_candidate, 
            \match_count[1] , n102, \sample_count[7] , \sample_count_next[1] , 
            n14363, \match_count_next[1] , n14917, \sample_count_next[7] , 
            w_rx_09_fifo_push, n11591, \match_count[0] , \match_count_next[0] , 
            \sample_count_next[3] , \sample_count_next[2] ) /* synthesis syn_module_defined=1 */ ;
    output [7:0]sample_count;
    output n14337;
    input n14294;
    output \sample_count[6] ;
    output [1:0]r_state;
    output n12902;
    output [32:0]sr;
    output n11488;
    output n13204;
    output \sample_count[2] ;
    output \sample_count[3] ;
    input sdr_rxclk_c;
    input [1:0]i_ddr_data;
    output n14315;
    output r_candidate_offset;
    output \candidate_sr[30] ;
    output n14316;
    input sdr_rxclk_c_enable_88;
    input \sample_count_next[0] ;
    input n13401;
    output [31:0]w_rx_09_fifo_data;
    output n14304;
    output n14268;
    output real_candidate;
    output \match_count[1] ;
    output n102;
    output \sample_count[7] ;
    input \sample_count_next[1] ;
    input n14363;
    input \match_count_next[1] ;
    input n14917;
    input \sample_count_next[7] ;
    output w_rx_09_fifo_push;
    input n11591;
    output \match_count[0] ;
    input \match_count_next[0] ;
    input \sample_count_next[3] ;
    input \sample_count_next[2] ;
    
    wire sdr_rxclk_c /* synthesis IO_TYPES="LVDS", is_clock=1, SET_AS_NETWORK=sdr_rxclk_c */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(10[13:22])
    wire [7:0]sample_count_c;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(36[16:28])
    
    wire n14273;
    wire [7:0]sample_count_next;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(36[30:47])
    
    wire n14358, n14364, n14361, n12314;
    wire [32:0]sr_c;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(27[16:18])
    
    wire sdr_rxclk_c_enable_2, n12718, n13296, n12145, n14362;
    wire [31:0]candidate_sr;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[14:26])
    
    wire sdr_rxclk_c_enable_40;
    wire [1:0]r_state_next;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(23[25:37])
    
    wire n12834, n14, n11728, sdr_rxclk_c_enable_86, n12490, n12492, 
        n12488, n39, n12476, n12478;
    wire [3:0]match_count;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(30[15:26])
    
    wire n12404, n13290, n10, n12486, n11628, n11658, n12520, 
        n12502, n11716, n12504, n12496, n12516, n12508, n14165, 
        n14164, n5716, valid_candidate_N_1125, n14282, n12682, n12171;
    
    LUT4 i1542_2_lut_rep_253 (.A(sample_count[1]), .B(sample_count[0]), 
         .Z(n14337)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(180[34:53])
    defparam i1542_2_lut_rep_253.init = 16'h8888;
    LUT4 i1_3_lut_4_lut (.A(sample_count_c[5]), .B(n14273), .C(n14294), 
         .D(\sample_count[6] ), .Z(sample_count_next[6])) /* synthesis lut_function=(!(A (B ((D)+!C)+!B !(C (D)))+!A !(C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(180[34:53])
    defparam i1_3_lut_4_lut.init = 16'h7080;
    LUT4 i1_1_lut_rep_274 (.A(r_state[0]), .Z(n14358)) /* synthesis lut_function=(!(A)) */ ;
    defparam i1_1_lut_rep_274.init = 16'h5555;
    LUT4 i1_3_lut_3_lut (.A(r_state[0]), .B(n14364), .C(n14361), .Z(n12902)) /* synthesis lut_function=((B+(C))+!A) */ ;
    defparam i1_3_lut_3_lut.init = 16'hfdfd;
    LUT4 i1_4_lut (.A(sr[16]), .B(n12314), .C(n11488), .D(sr_c[15]), 
         .Z(sdr_rxclk_c_enable_2)) /* synthesis lut_function=(!(A+!(B (C+!(D))+!B (C (D))))) */ ;
    defparam i1_4_lut.init = 16'h5044;
    LUT4 i1_4_lut_adj_185 (.A(sr_c[0]), .B(sr_c[30]), .C(sr_c[31]), .D(sr_c[14]), 
         .Z(n12314)) /* synthesis lut_function=(!(A+(B+!(C (D))))) */ ;
    defparam i1_4_lut_adj_185.init = 16'h1000;
    LUT4 i1_2_lut (.A(sr[16]), .B(sr_c[15]), .Z(n13204)) /* synthesis lut_function=(!(A+!(B))) */ ;
    defparam i1_2_lut.init = 16'h4444;
    LUT4 i1563_2_lut_rep_189_3_lut_4_lut (.A(\sample_count[2] ), .B(n14337), 
         .C(sample_count_c[4]), .D(\sample_count[3] ), .Z(n14273)) /* synthesis lut_function=(A (B (C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(180[34:53])
    defparam i1563_2_lut_rep_189_3_lut_4_lut.init = 16'h8000;
    FD1S3AX sr_i0 (.D(i_ddr_data[0]), .CK(sdr_rxclk_c), .Q(sr_c[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i0.GSR = "ENABLED";
    LUT4 i1_4_lut_4_lut_4_lut (.A(n14364), .B(n12718), .C(n13296), .D(n14315), 
         .Z(n12145)) /* synthesis lut_function=(!(A+(((D)+!C)+!B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam i1_4_lut_4_lut_4_lut.init = 16'h0040;
    LUT4 i6308_3_lut_rep_277 (.A(sr_c[17]), .B(sr_c[15]), .C(r_candidate_offset), 
         .Z(n14361)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i6308_3_lut_rep_277.init = 16'hcaca;
    LUT4 i10707_2_lut_4_lut (.A(sr_c[17]), .B(sr_c[15]), .C(r_candidate_offset), 
         .D(\candidate_sr[30] ), .Z(n13296)) /* synthesis lut_function=(!(A (B+((D)+!C))+!A (B (C+(D))+!B (D)))) */ ;
    defparam i10707_2_lut_4_lut.init = 16'h0035;
    LUT4 sr_32__I_0_112_i32_3_lut_rep_278 (.A(sr_c[32]), .B(sr_c[31]), .C(r_candidate_offset), 
         .Z(n14362)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i32_3_lut_rep_278.init = 16'hcaca;
    LUT4 i1_2_lut_rep_232_4_lut (.A(sr_c[32]), .B(sr_c[31]), .C(r_candidate_offset), 
         .D(candidate_sr[14]), .Z(n14316)) /* synthesis lut_function=(A (B (D)+!B !(C+!(D)))+!A (B (C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam i1_2_lut_rep_232_4_lut.init = 16'hca00;
    LUT4 i1_4_lut_adj_186 (.A(sr_c[17]), .B(sr_c[1]), .C(sr_c[31]), .D(sr_c[32]), 
         .Z(n11488)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i1_4_lut_adj_186.init = 16'h0100;
    FD1P3AX sample_count_i0 (.D(\sample_count_next[0] ), .SP(sdr_rxclk_c_enable_88), 
            .CK(sdr_rxclk_c), .Q(sample_count[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sample_count_i0.GSR = "ENABLED";
    FD1P3AX r_candidate_offset_100 (.D(n13401), .SP(sdr_rxclk_c_enable_2), 
            .CK(sdr_rxclk_c), .Q(r_candidate_offset)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam r_candidate_offset_100.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i0 (.D(n14364), .SP(sdr_rxclk_c_enable_40), .CK(sdr_rxclk_c), 
            .Q(w_rx_09_fifo_data[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i0.GSR = "ENABLED";
    FD1S3AX r_state_i0 (.D(r_state_next[0]), .CK(sdr_rxclk_c), .Q(r_state[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam r_state_i0.GSR = "ENABLED";
    LUT4 i1_4_lut_adj_187 (.A(n12834), .B(n14315), .C(n13296), .D(n14364), 
         .Z(sdr_rxclk_c_enable_40)) /* synthesis lut_function=(!((B+((D)+!C))+!A)) */ ;
    defparam i1_4_lut_adj_187.init = 16'h0020;
    LUT4 sr_32__I_0_112_i1_3_lut_rep_280 (.A(sr_c[1]), .B(sr_c[0]), .C(r_candidate_offset), 
         .Z(n14364)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i1_3_lut_rep_280.init = 16'hcaca;
    LUT4 i1_3_lut_4_lut_adj_188 (.A(\sample_count[3] ), .B(n14304), .C(n14294), 
         .D(sample_count_c[4]), .Z(sample_count_next[4])) /* synthesis lut_function=(!(A (B ((D)+!C)+!B !(C (D)))+!A !(C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(180[34:53])
    defparam i1_3_lut_4_lut_adj_188.init = 16'h7080;
    LUT4 i1570_2_lut_rep_184_3_lut_4_lut (.A(\sample_count[3] ), .B(n14304), 
         .C(sample_count_c[5]), .D(sample_count_c[4]), .Z(n14268)) /* synthesis lut_function=(A (B (C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(180[34:53])
    defparam i1570_2_lut_rep_184_3_lut_4_lut.init = 16'h8000;
    LUT4 i10726_4_lut (.A(r_state[0]), .B(n14), .C(n14315), .D(n11728), 
         .Z(sdr_rxclk_c_enable_86)) /* synthesis lut_function=(!(A (B+(C+!(D)))+!A (B))) */ ;
    defparam i10726_4_lut.init = 16'h1311;
    LUT4 i1_3_lut (.A(r_state[1]), .B(r_state[0]), .C(real_candidate), 
         .Z(n14)) /* synthesis lut_function=(A ((C)+!B)) */ ;
    defparam i1_3_lut.init = 16'ha2a2;
    LUT4 i8782_4_lut (.A(real_candidate), .B(n12490), .C(n12492), .D(n12488), 
         .Z(n11728)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i8782_4_lut.init = 16'hfffe;
    LUT4 i1_4_lut_adj_189 (.A(n39), .B(n12476), .C(n12478), .D(sr_c[21]), 
         .Z(n12490)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(77[43:62])
    defparam i1_4_lut_adj_189.init = 16'hfffe;
    LUT4 i1_2_lut_adj_190 (.A(sr_c[11]), .B(sr_c[25]), .Z(n12478)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(77[43:62])
    defparam i1_2_lut_adj_190.init = 16'heeee;
    LUT4 sr_32__I_0_112_i15_3_lut (.A(sr_c[15]), .B(sr_c[14]), .C(r_candidate_offset), 
         .Z(candidate_sr[14])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i15_3_lut.init = 16'hcaca;
    LUT4 i1_2_lut_adj_191 (.A(match_count[2]), .B(\match_count[1] ), .Z(n102)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut_adj_191.init = 16'heeee;
    LUT4 i1_4_lut_adj_192 (.A(n12404), .B(n14364), .C(\candidate_sr[30] ), 
         .D(n14361), .Z(real_candidate)) /* synthesis lut_function=(!((B+(C+(D)))+!A)) */ ;
    defparam i1_4_lut_adj_192.init = 16'h0002;
    LUT4 i10299_2_lut (.A(\sample_count[2] ), .B(\sample_count[3] ), .Z(n13290)) /* synthesis lut_function=(A (B)) */ ;
    defparam i10299_2_lut.init = 16'h8888;
    LUT4 i1_4_lut_adj_193 (.A(\sample_count[6] ), .B(sample_count[0]), .C(sample_count_c[4]), 
         .D(\sample_count[7] ), .Z(n10)) /* synthesis lut_function=(A+((C+(D))+!B)) */ ;
    defparam i1_4_lut_adj_193.init = 16'hfffb;
    LUT4 i45_3_lut (.A(sr_c[32]), .B(sr_c[0]), .C(r_candidate_offset), 
         .Z(n39)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(77[43:62])
    defparam i45_3_lut.init = 16'hcaca;
    LUT4 i1_2_lut_adj_194 (.A(sr_c[28]), .B(sr_c[8]), .Z(n12476)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(77[43:62])
    defparam i1_2_lut_adj_194.init = 16'heeee;
    LUT4 i1_4_lut_adj_195 (.A(n12486), .B(sr_c[3]), .C(n11628), .D(sr_c[31]), 
         .Z(n12492)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(77[43:62])
    defparam i1_4_lut_adj_195.init = 16'hfffe;
    LUT4 i1_4_lut_adj_196 (.A(sr_c[15]), .B(n11658), .C(n12520), .D(sr_c[13]), 
         .Z(n12486)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(77[43:62])
    defparam i1_4_lut_adj_196.init = 16'hfffe;
    LUT4 i8683_2_lut (.A(sr_c[26]), .B(sr_c[18]), .Z(n11628)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i8683_2_lut.init = 16'heeee;
    LUT4 i8713_2_lut (.A(sr_c[30]), .B(sr[16]), .Z(n11658)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i8713_2_lut.init = 16'heeee;
    LUT4 i1_2_lut_adj_197 (.A(sr_c[23]), .B(sr_c[29]), .Z(n12520)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(77[43:62])
    defparam i1_2_lut_adj_197.init = 16'heeee;
    LUT4 i1_4_lut_adj_198 (.A(n12502), .B(n11716), .C(n12504), .D(n12496), 
         .Z(n12488)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(77[43:62])
    defparam i1_4_lut_adj_198.init = 16'hfffe;
    LUT4 i1_2_lut_adj_199 (.A(sr_c[17]), .B(sr_c[1]), .Z(n12502)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(77[43:62])
    defparam i1_2_lut_adj_199.init = 16'heeee;
    LUT4 sr_32__I_0_112_i31_3_lut (.A(sr_c[31]), .B(sr_c[30]), .C(r_candidate_offset), 
         .Z(\candidate_sr[30] )) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i31_3_lut.init = 16'hcaca;
    LUT4 i1_4_lut_adj_200 (.A(sr_c[14]), .B(n12516), .C(n12508), .D(sr_c[22]), 
         .Z(n11716)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_adj_200.init = 16'hfffe;
    LUT4 i1_4_lut_adj_201 (.A(sr_c[7]), .B(sr_c[5]), .C(sr_c[19]), .D(sr_c[12]), 
         .Z(n12504)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(77[43:62])
    defparam i1_4_lut_adj_201.init = 16'hfffe;
    LUT4 i1_2_lut_adj_202 (.A(sr_c[27]), .B(sr_c[9]), .Z(n12496)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(77[43:62])
    defparam i1_2_lut_adj_202.init = 16'heeee;
    LUT4 i1_4_lut_adj_203 (.A(sr_c[2]), .B(sr_c[6]), .C(sr_c[10]), .D(sr_c[20]), 
         .Z(n12516)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_adj_203.init = 16'hfffe;
    LUT4 i1_2_lut_adj_204 (.A(sr_c[4]), .B(sr_c[24]), .Z(n12508)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut_adj_204.init = 16'heeee;
    LUT4 i5_rep_231 (.A(n13290), .B(n10), .C(sample_count[1]), .D(sample_count_c[5]), 
         .Z(n14315)) /* synthesis lut_function=((B+((D)+!C))+!A) */ ;
    defparam i5_rep_231.init = 16'hffdf;
    LUT4 sr_32__I_0_112_i2_3_lut (.A(sr_c[2]), .B(sr_c[1]), .C(r_candidate_offset), 
         .Z(candidate_sr[1])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i2_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i3_3_lut (.A(sr_c[3]), .B(sr_c[2]), .C(r_candidate_offset), 
         .Z(candidate_sr[2])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i3_3_lut.init = 16'hcaca;
    FD1P3AX sample_count_i1 (.D(\sample_count_next[1] ), .SP(sdr_rxclk_c_enable_88), 
            .CK(sdr_rxclk_c), .Q(sample_count[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sample_count_i1.GSR = "ENABLED";
    LUT4 sr_32__I_0_112_i4_3_lut (.A(sr_c[4]), .B(sr_c[3]), .C(r_candidate_offset), 
         .Z(candidate_sr[3])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i4_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i5_3_lut (.A(sr_c[5]), .B(sr_c[4]), .C(r_candidate_offset), 
         .Z(candidate_sr[4])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i5_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i6_3_lut (.A(sr_c[6]), .B(sr_c[5]), .C(r_candidate_offset), 
         .Z(candidate_sr[5])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i6_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i7_3_lut (.A(sr_c[7]), .B(sr_c[6]), .C(r_candidate_offset), 
         .Z(candidate_sr[6])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i7_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i8_3_lut (.A(sr_c[8]), .B(sr_c[7]), .C(r_candidate_offset), 
         .Z(candidate_sr[7])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i8_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i9_3_lut (.A(sr_c[9]), .B(sr_c[8]), .C(r_candidate_offset), 
         .Z(candidate_sr[8])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i9_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i10_3_lut (.A(sr_c[10]), .B(sr_c[9]), .C(r_candidate_offset), 
         .Z(candidate_sr[9])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i10_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i11_3_lut (.A(sr_c[11]), .B(sr_c[10]), .C(r_candidate_offset), 
         .Z(candidate_sr[10])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i11_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i12_3_lut (.A(sr_c[12]), .B(sr_c[11]), .C(r_candidate_offset), 
         .Z(candidate_sr[11])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i12_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i13_3_lut (.A(sr_c[13]), .B(sr_c[12]), .C(r_candidate_offset), 
         .Z(candidate_sr[12])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i13_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i14_3_lut (.A(sr_c[14]), .B(sr_c[13]), .C(r_candidate_offset), 
         .Z(candidate_sr[13])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i14_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i16_3_lut (.A(sr[16]), .B(sr_c[15]), .C(r_candidate_offset), 
         .Z(candidate_sr[15])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i16_3_lut.init = 16'hcaca;
    LUT4 i1_2_lut_3_lut (.A(candidate_sr[14]), .B(n14362), .C(sr[16]), 
         .Z(n12404)) /* synthesis lut_function=(!(((C)+!B)+!A)) */ ;
    defparam i1_2_lut_3_lut.init = 16'h0808;
    LUT4 sr_32__I_0_112_i17_3_lut (.A(sr_c[17]), .B(sr[16]), .C(r_candidate_offset), 
         .Z(candidate_sr[16])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i17_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i18_3_lut (.A(sr_c[18]), .B(sr_c[17]), .C(r_candidate_offset), 
         .Z(candidate_sr[17])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i18_3_lut.init = 16'hcaca;
    LUT4 i1_3_lut_4_lut_adj_205 (.A(candidate_sr[14]), .B(n14362), .C(n14363), 
         .D(sr[16]), .Z(n12834)) /* synthesis lut_function=(!((((D)+!C)+!B)+!A)) */ ;
    defparam i1_3_lut_4_lut_adj_205.init = 16'h0080;
    LUT4 i1_3_lut_4_lut_adj_206 (.A(candidate_sr[14]), .B(n14362), .C(n102), 
         .D(sr[16]), .Z(n12718)) /* synthesis lut_function=(!((((D)+!C)+!B)+!A)) */ ;
    defparam i1_3_lut_4_lut_adj_206.init = 16'h0080;
    LUT4 sr_32__I_0_112_i19_3_lut (.A(sr_c[19]), .B(sr_c[18]), .C(r_candidate_offset), 
         .Z(candidate_sr[18])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i19_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i20_3_lut (.A(sr_c[20]), .B(sr_c[19]), .C(r_candidate_offset), 
         .Z(candidate_sr[19])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i20_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i21_3_lut (.A(sr_c[21]), .B(sr_c[20]), .C(r_candidate_offset), 
         .Z(candidate_sr[20])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i21_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i22_3_lut (.A(sr_c[22]), .B(sr_c[21]), .C(r_candidate_offset), 
         .Z(candidate_sr[21])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i22_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i23_3_lut (.A(sr_c[23]), .B(sr_c[22]), .C(r_candidate_offset), 
         .Z(candidate_sr[22])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i23_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i24_3_lut (.A(sr_c[24]), .B(sr_c[23]), .C(r_candidate_offset), 
         .Z(candidate_sr[23])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i24_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i25_3_lut (.A(sr_c[25]), .B(sr_c[24]), .C(r_candidate_offset), 
         .Z(candidate_sr[24])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i25_3_lut.init = 16'hcaca;
    PFUMX i10920 (.BLUT(n14165), .ALUT(n14164), .C0(r_state[0]), .Z(r_state_next[0]));
    LUT4 sr_32__I_0_112_i26_3_lut (.A(sr_c[26]), .B(sr_c[25]), .C(r_candidate_offset), 
         .Z(candidate_sr[25])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i26_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i27_3_lut (.A(sr_c[27]), .B(sr_c[26]), .C(r_candidate_offset), 
         .Z(candidate_sr[26])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i27_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i28_3_lut (.A(sr_c[28]), .B(sr_c[27]), .C(r_candidate_offset), 
         .Z(candidate_sr[27])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i28_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i29_3_lut (.A(sr_c[29]), .B(sr_c[28]), .C(r_candidate_offset), 
         .Z(candidate_sr[28])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i29_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i30_3_lut (.A(sr_c[30]), .B(sr_c[29]), .C(r_candidate_offset), 
         .Z(candidate_sr[29])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i30_3_lut.init = 16'hcaca;
    FD1S3AX sr_i1 (.D(i_ddr_data[1]), .CK(sdr_rxclk_c), .Q(sr_c[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i1.GSR = "ENABLED";
    FD1S3AX sr_i2 (.D(sr_c[0]), .CK(sdr_rxclk_c), .Q(sr_c[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i2.GSR = "ENABLED";
    FD1S3AX sr_i3 (.D(sr_c[1]), .CK(sdr_rxclk_c), .Q(sr_c[3])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i3.GSR = "ENABLED";
    FD1S3AX sr_i4 (.D(sr_c[2]), .CK(sdr_rxclk_c), .Q(sr_c[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i4.GSR = "ENABLED";
    FD1S3AX sr_i5 (.D(sr_c[3]), .CK(sdr_rxclk_c), .Q(sr_c[5])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i5.GSR = "ENABLED";
    FD1S3AX sr_i6 (.D(sr_c[4]), .CK(sdr_rxclk_c), .Q(sr_c[6])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i6.GSR = "ENABLED";
    FD1S3AX sr_i7 (.D(sr_c[5]), .CK(sdr_rxclk_c), .Q(sr_c[7])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i7.GSR = "ENABLED";
    FD1S3AX sr_i8 (.D(sr_c[6]), .CK(sdr_rxclk_c), .Q(sr_c[8])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i8.GSR = "ENABLED";
    FD1S3AX sr_i9 (.D(sr_c[7]), .CK(sdr_rxclk_c), .Q(sr_c[9])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i9.GSR = "ENABLED";
    FD1S3AX sr_i10 (.D(sr_c[8]), .CK(sdr_rxclk_c), .Q(sr_c[10])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i10.GSR = "ENABLED";
    FD1S3AX sr_i11 (.D(sr_c[9]), .CK(sdr_rxclk_c), .Q(sr_c[11])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i11.GSR = "ENABLED";
    FD1S3AX sr_i12 (.D(sr_c[10]), .CK(sdr_rxclk_c), .Q(sr_c[12])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i12.GSR = "ENABLED";
    FD1S3AX sr_i13 (.D(sr_c[11]), .CK(sdr_rxclk_c), .Q(sr_c[13])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i13.GSR = "ENABLED";
    FD1S3AX sr_i14 (.D(sr_c[12]), .CK(sdr_rxclk_c), .Q(sr_c[14])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i14.GSR = "ENABLED";
    FD1S3AX sr_i15 (.D(sr_c[13]), .CK(sdr_rxclk_c), .Q(sr_c[15])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i15.GSR = "ENABLED";
    FD1S3AX sr_i16 (.D(sr_c[14]), .CK(sdr_rxclk_c), .Q(sr[16])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i16.GSR = "ENABLED";
    FD1S3AX sr_i17 (.D(sr_c[15]), .CK(sdr_rxclk_c), .Q(sr_c[17])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i17.GSR = "ENABLED";
    FD1S3AX sr_i18 (.D(sr[16]), .CK(sdr_rxclk_c), .Q(sr_c[18])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i18.GSR = "ENABLED";
    FD1S3AX sr_i19 (.D(sr_c[17]), .CK(sdr_rxclk_c), .Q(sr_c[19])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i19.GSR = "ENABLED";
    FD1S3AX sr_i20 (.D(sr_c[18]), .CK(sdr_rxclk_c), .Q(sr_c[20])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i20.GSR = "ENABLED";
    FD1S3AX sr_i21 (.D(sr_c[19]), .CK(sdr_rxclk_c), .Q(sr_c[21])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i21.GSR = "ENABLED";
    FD1S3AX sr_i22 (.D(sr_c[20]), .CK(sdr_rxclk_c), .Q(sr_c[22])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i22.GSR = "ENABLED";
    FD1S3AX sr_i23 (.D(sr_c[21]), .CK(sdr_rxclk_c), .Q(sr_c[23])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i23.GSR = "ENABLED";
    FD1S3AX sr_i24 (.D(sr_c[22]), .CK(sdr_rxclk_c), .Q(sr_c[24])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i24.GSR = "ENABLED";
    FD1S3AX sr_i25 (.D(sr_c[23]), .CK(sdr_rxclk_c), .Q(sr_c[25])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i25.GSR = "ENABLED";
    FD1S3AX sr_i26 (.D(sr_c[24]), .CK(sdr_rxclk_c), .Q(sr_c[26])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i26.GSR = "ENABLED";
    FD1S3AX sr_i27 (.D(sr_c[25]), .CK(sdr_rxclk_c), .Q(sr_c[27])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i27.GSR = "ENABLED";
    FD1S3AX sr_i28 (.D(sr_c[26]), .CK(sdr_rxclk_c), .Q(sr_c[28])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i28.GSR = "ENABLED";
    FD1S3AX sr_i29 (.D(sr_c[27]), .CK(sdr_rxclk_c), .Q(sr_c[29])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i29.GSR = "ENABLED";
    FD1S3AX sr_i30 (.D(sr_c[28]), .CK(sdr_rxclk_c), .Q(sr_c[30])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i30.GSR = "ENABLED";
    FD1S3AX sr_i31 (.D(sr_c[29]), .CK(sdr_rxclk_c), .Q(sr_c[31])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i31.GSR = "ENABLED";
    FD1S3AX sr_i32 (.D(sr_c[30]), .CK(sdr_rxclk_c), .Q(sr_c[32])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i32.GSR = "ENABLED";
    FD1P3AX match_count_i1 (.D(\match_count_next[1] ), .SP(sdr_rxclk_c_enable_86), 
            .CK(sdr_rxclk_c), .Q(\match_count[1] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam match_count_i1.GSR = "ENABLED";
    FD1P3AX match_count_i2 (.D(n14917), .SP(sdr_rxclk_c_enable_86), .CK(sdr_rxclk_c), 
            .Q(match_count[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam match_count_i2.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i1 (.D(candidate_sr[1]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i1.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i2 (.D(candidate_sr[2]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i2.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i3 (.D(candidate_sr[3]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[3])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i3.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i4 (.D(candidate_sr[4]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i4.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i5 (.D(candidate_sr[5]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[5])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i5.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i6 (.D(candidate_sr[6]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[6])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i6.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i7 (.D(candidate_sr[7]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[7])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i7.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i8 (.D(candidate_sr[8]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[8])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i8.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i9 (.D(candidate_sr[9]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[9])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i9.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i10 (.D(candidate_sr[10]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[10])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i10.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i11 (.D(candidate_sr[11]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[11])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i11.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i12 (.D(candidate_sr[12]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[12])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i12.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i13 (.D(candidate_sr[13]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[13])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i13.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i14 (.D(candidate_sr[14]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[14])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i14.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i15 (.D(candidate_sr[15]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[15])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i15.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i16 (.D(candidate_sr[16]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[16])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i16.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i17 (.D(candidate_sr[17]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[17])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i17.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i18 (.D(candidate_sr[18]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[18])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i18.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i19 (.D(candidate_sr[19]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[19])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i19.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i20 (.D(candidate_sr[20]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[20])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i20.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i21 (.D(candidate_sr[21]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[21])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i21.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i22 (.D(candidate_sr[22]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[22])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i22.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i23 (.D(candidate_sr[23]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[23])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i23.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i24 (.D(candidate_sr[24]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[24])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i24.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i25 (.D(candidate_sr[25]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[25])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i25.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i26 (.D(candidate_sr[26]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[26])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i26.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i27 (.D(candidate_sr[27]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[27])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i27.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i28 (.D(candidate_sr[28]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[28])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i28.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i29 (.D(candidate_sr[29]), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[29])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i29.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i30 (.D(\candidate_sr[30] ), .SP(sdr_rxclk_c_enable_40), 
            .CK(sdr_rxclk_c), .Q(w_rx_09_fifo_data[30])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i30.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i31 (.D(n14362), .SP(sdr_rxclk_c_enable_40), .CK(sdr_rxclk_c), 
            .Q(w_rx_09_fifo_data[31])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i31.GSR = "ENABLED";
    FD1S3IX r_state_i1 (.D(n5716), .CK(sdr_rxclk_c), .CD(n14358), .Q(r_state[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam r_state_i1.GSR = "ENABLED";
    LUT4 n15_bdd_3_lut (.A(n14315), .B(valid_candidate_N_1125), .C(real_candidate), 
         .Z(n14164)) /* synthesis lut_function=(A+(B+(C))) */ ;
    defparam n15_bdd_3_lut.init = 16'hfefe;
    LUT4 n15_bdd_2_lut (.A(sdr_rxclk_c_enable_2), .B(r_state[1]), .Z(n14165)) /* synthesis lut_function=(!((B)+!A)) */ ;
    defparam n15_bdd_2_lut.init = 16'h2222;
    LUT4 i1549_2_lut_rep_220_3_lut (.A(sample_count[1]), .B(sample_count[0]), 
         .C(\sample_count[2] ), .Z(n14304)) /* synthesis lut_function=(A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(180[34:53])
    defparam i1549_2_lut_rep_220_3_lut.init = 16'h8080;
    LUT4 i1556_2_lut_rep_198_3_lut_4_lut (.A(sample_count[1]), .B(sample_count[0]), 
         .C(\sample_count[3] ), .D(\sample_count[2] ), .Z(n14282)) /* synthesis lut_function=(A (B (C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(180[34:53])
    defparam i1556_2_lut_rep_198_3_lut_4_lut.init = 16'h8000;
    LUT4 i10702_4_lut (.A(n39), .B(n12492), .C(n12488), .D(n12682), 
         .Z(valid_candidate_N_1125)) /* synthesis lut_function=(!(A+(B+(C+(D))))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(77[43:62])
    defparam i10702_4_lut.init = 16'h0001;
    LUT4 i1_4_lut_adj_207 (.A(sr_c[21]), .B(n12476), .C(sr_c[11]), .D(sr_c[25]), 
         .Z(n12682)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_adj_207.init = 16'hfffe;
    PFUMX i2839 (.BLUT(n12145), .ALUT(n12171), .C0(r_state[1]), .Z(n5716));
    FD1P3AX sample_count_i7 (.D(\sample_count_next[7] ), .SP(sdr_rxclk_c_enable_88), 
            .CK(sdr_rxclk_c), .Q(\sample_count[7] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sample_count_i7.GSR = "ENABLED";
    FD1P3AX sample_count_i6 (.D(sample_count_next[6]), .SP(sdr_rxclk_c_enable_88), 
            .CK(sdr_rxclk_c), .Q(\sample_count[6] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sample_count_i6.GSR = "ENABLED";
    LUT4 i1_3_lut_adj_208 (.A(valid_candidate_N_1125), .B(real_candidate), 
         .C(n14315), .Z(n12171)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(188[14] 193[8])
    defparam i1_3_lut_adj_208.init = 16'hfefe;
    LUT4 i1_3_lut_4_lut_adj_209 (.A(sample_count_c[4]), .B(n14282), .C(n14294), 
         .D(sample_count_c[5]), .Z(sample_count_next[5])) /* synthesis lut_function=(!(A (B ((D)+!C)+!B !(C (D)))+!A !(C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(180[34:53])
    defparam i1_3_lut_4_lut_adj_209.init = 16'h7080;
    FD1P3AX sample_count_i5 (.D(sample_count_next[5]), .SP(sdr_rxclk_c_enable_88), 
            .CK(sdr_rxclk_c), .Q(sample_count_c[5])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sample_count_i5.GSR = "ENABLED";
    FD1S3IX o_fifo_push_102 (.D(real_candidate), .CK(sdr_rxclk_c), .CD(n11591), 
            .Q(w_rx_09_fifo_push)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_push_102.GSR = "ENABLED";
    FD1P3AX sample_count_i4 (.D(sample_count_next[4]), .SP(sdr_rxclk_c_enable_88), 
            .CK(sdr_rxclk_c), .Q(sample_count_c[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sample_count_i4.GSR = "ENABLED";
    FD1P3AX match_count_i0 (.D(\match_count_next[0] ), .SP(sdr_rxclk_c_enable_86), 
            .CK(sdr_rxclk_c), .Q(\match_count[0] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam match_count_i0.GSR = "ENABLED";
    FD1P3AX sample_count_i3 (.D(\sample_count_next[3] ), .SP(sdr_rxclk_c_enable_88), 
            .CK(sdr_rxclk_c), .Q(\sample_count[3] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sample_count_i3.GSR = "ENABLED";
    FD1P3AX sample_count_i2 (.D(\sample_count_next[2] ), .SP(sdr_rxclk_c_enable_88), 
            .CK(sdr_rxclk_c), .Q(\sample_count[2] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=622, LSE_RLINE=629 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sample_count_i2.GSR = "ENABLED";
    
endmodule
//
// Verilog Description of module fifo_dc_16in_16out_U1
//

module fifo_dc_16in_16out_U1 (sdr_rxclk_c, internal_80MHz, rRst, wifi_i_empty, 
            GND_net, VCC_net, w_rx_24_fifo_push, n14347, \w_rx_24_fifo_data[31] , 
            \w_rx_24_fifo_data[30] , \w_rx_24_fifo_data[29] , \w_rx_24_fifo_data[28] , 
            \w_rx_24_fifo_data[27] , \w_rx_24_fifo_data[26] , \w_rx_24_fifo_data[25] , 
            \w_rx_24_fifo_data[24] , \w_rx_24_fifo_data[23] , \w_rx_24_fifo_data[22] , 
            \w_rx_24_fifo_data[21] , \w_rx_24_fifo_data[20] , \w_rx_24_fifo_data[19] , 
            \w_rx_24_fifo_data[18] , \w_rx_24_fifo_data[17] , \w_rx_24_fifo_data[16] , 
            main_reset_n_N_208, wifi_i_fifo_data_out) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;
    input sdr_rxclk_c;
    input internal_80MHz;
    input rRst;
    output wifi_i_empty;
    input GND_net;
    input VCC_net;
    input w_rx_24_fifo_push;
    input n14347;
    input \w_rx_24_fifo_data[31] ;
    input \w_rx_24_fifo_data[30] ;
    input \w_rx_24_fifo_data[29] ;
    input \w_rx_24_fifo_data[28] ;
    input \w_rx_24_fifo_data[27] ;
    input \w_rx_24_fifo_data[26] ;
    input \w_rx_24_fifo_data[25] ;
    input \w_rx_24_fifo_data[24] ;
    input \w_rx_24_fifo_data[23] ;
    input \w_rx_24_fifo_data[22] ;
    input \w_rx_24_fifo_data[21] ;
    input \w_rx_24_fifo_data[20] ;
    input \w_rx_24_fifo_data[19] ;
    input \w_rx_24_fifo_data[18] ;
    input \w_rx_24_fifo_data[17] ;
    input \w_rx_24_fifo_data[16] ;
    input main_reset_n_N_208;
    output [15:0]wifi_i_fifo_data_out;
    
    wire sdr_rxclk_c /* synthesis IO_TYPES="LVDS", is_clock=1, SET_AS_NETWORK=sdr_rxclk_c */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(10[13:22])
    wire internal_80MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_80MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(84[6:20])
    wire VCC_net /* synthesis CE_NET_FOR_BUS20=20, DSPPORT_20=CE3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(26[14:27])
    
    wire wcount_1, wren_i, iwcount_1, wcount_2, iwcount_2, w_gcount_0, 
        w_gdata_0, w_gcount_1, w_gdata_1, w_gcount_2, wptr_0, wcount_0, 
        wptr_1, wptr_2, w_gcount_r0, ircount_0, rden_i, rcount_0, 
        ircount_1, rcount_1, ircount_2, rcount_2, r_gdata_0, r_gcount_0, 
        r_gdata_1, r_gcount_1, r_gcount_2, rptr_0, rptr_1, rptr_2, 
        w_gcount_r1, w_gcount_r2, w_gcount_r20, r_gcount_w0, r_gcount_w1, 
        r_gcount_w2, w_gcount_r21, w_gcount_r22, Full, full_d, r_gcount_w20, 
        r_gcount_w21, r_gcount_w22, empty_d, iwcount_0, w_gctr_ci, 
        co0, r_gctr_ci, co0_1, cmp_ci, wcount_r0, wcount_r1, co0_2, 
        empty_cmp_clr, empty_cmp_set, empty_d_c, cmp_ci_1, rcount_w0, 
        rcount_w1, co0_3, full_cmp_clr, full_cmp_set, full_d_c, invout_1, 
        invout_0;
    
    FD1P3AX FF_30 (.D(iwcount_1), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(188[13] 189[22])
    defparam FF_30.GSR = "ENABLED";
    FD1P3AX FF_29 (.D(iwcount_2), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(192[13] 193[22])
    defparam FF_29.GSR = "ENABLED";
    FD1P3AX FF_28 (.D(w_gdata_0), .SP(wren_i), .CK(sdr_rxclk_c), .Q(w_gcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(196[13] 197[24])
    defparam FF_28.GSR = "ENABLED";
    FD1P3AX FF_27 (.D(w_gdata_1), .SP(wren_i), .CK(sdr_rxclk_c), .Q(w_gcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(200[13] 201[24])
    defparam FF_27.GSR = "ENABLED";
    FD1P3AX FF_26 (.D(wcount_2), .SP(wren_i), .CK(sdr_rxclk_c), .Q(w_gcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(204[13] 205[24])
    defparam FF_26.GSR = "ENABLED";
    FD1P3AX FF_25 (.D(wcount_0), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wptr_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(208[13] 209[20])
    defparam FF_25.GSR = "ENABLED";
    FD1P3AX FF_24 (.D(wcount_1), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wptr_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(212[13] 213[20])
    defparam FF_24.GSR = "ENABLED";
    FD1P3AX FF_23 (.D(wcount_2), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wptr_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(216[13] 217[20])
    defparam FF_23.GSR = "ENABLED";
    FD1S3AX FF_13 (.D(w_gcount_0), .CK(internal_80MHz), .Q(w_gcount_r0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(252[13:78])
    defparam FF_13.GSR = "ENABLED";
    FD1P3BX FF_22 (.D(ircount_0), .SP(rden_i), .CK(internal_80MHz), .PD(rRst), 
            .Q(rcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(220[13] 221[22])
    defparam FF_22.GSR = "DISABLED";
    FD1P3DX FF_21 (.D(ircount_1), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(224[13] 225[22])
    defparam FF_21.GSR = "DISABLED";
    FD1P3DX FF_20 (.D(ircount_2), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(228[13] 229[22])
    defparam FF_20.GSR = "DISABLED";
    FD1P3DX FF_19 (.D(r_gdata_0), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(232[13] 233[24])
    defparam FF_19.GSR = "DISABLED";
    FD1P3DX FF_18 (.D(r_gdata_1), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(236[13] 237[24])
    defparam FF_18.GSR = "DISABLED";
    FD1P3DX FF_17 (.D(rcount_2), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(240[13:87])
    defparam FF_17.GSR = "DISABLED";
    FD1P3DX FF_16 (.D(rcount_0), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(243[13:83])
    defparam FF_16.GSR = "DISABLED";
    FD1P3DX FF_15 (.D(rcount_1), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(246[13:83])
    defparam FF_15.GSR = "DISABLED";
    FD1P3DX FF_14 (.D(rcount_2), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(249[13:83])
    defparam FF_14.GSR = "DISABLED";
    FD1S3AX FF_12 (.D(w_gcount_1), .CK(internal_80MHz), .Q(w_gcount_r1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(255[13:78])
    defparam FF_12.GSR = "ENABLED";
    FD1S3AX FF_11 (.D(w_gcount_2), .CK(internal_80MHz), .Q(w_gcount_r2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(258[13:78])
    defparam FF_11.GSR = "ENABLED";
    FD1S3AX FF_7 (.D(w_gcount_r0), .CK(internal_80MHz), .Q(w_gcount_r20)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(270[13:79])
    defparam FF_7.GSR = "ENABLED";
    FD1S3DX FF_10 (.D(r_gcount_0), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(261[13:77])
    defparam FF_10.GSR = "DISABLED";
    FD1S3DX FF_9 (.D(r_gcount_1), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(264[13:76])
    defparam FF_9.GSR = "DISABLED";
    FD1S3DX FF_8 (.D(r_gcount_2), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(267[13:76])
    defparam FF_8.GSR = "DISABLED";
    FD1S3AX FF_6 (.D(w_gcount_r1), .CK(internal_80MHz), .Q(w_gcount_r21)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(273[13:79])
    defparam FF_6.GSR = "ENABLED";
    FD1S3AX FF_5 (.D(w_gcount_r2), .CK(internal_80MHz), .Q(w_gcount_r22)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(276[13:79])
    defparam FF_5.GSR = "ENABLED";
    FD1S3AX FF_0 (.D(full_d), .CK(sdr_rxclk_c), .Q(Full)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(291[13:68])
    defparam FF_0.GSR = "ENABLED";
    FD1S3DX FF_4 (.D(r_gcount_w0), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w20)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(279[13:78])
    defparam FF_4.GSR = "DISABLED";
    FD1S3DX FF_3 (.D(r_gcount_w1), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w21)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(282[13:78])
    defparam FF_3.GSR = "DISABLED";
    FD1S3DX FF_2 (.D(r_gcount_w2), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w22)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(285[13:78])
    defparam FF_2.GSR = "DISABLED";
    FD1S3BX FF_1 (.D(empty_d), .CK(internal_80MHz), .PD(rRst), .Q(wifi_i_empty)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(288[13:69])
    defparam FF_1.GSR = "DISABLED";
    FD1P3AY FF_31 (.D(iwcount_0), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(184[13] 185[22])
    defparam FF_31.GSR = "ENABLED";
    CCU2C w_gctr_cia (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(VCC_net), .B1(VCC_net), .C1(VCC_net), .D1(VCC_net), .COUT(w_gctr_ci)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(298[11] 300[48])
    defparam w_gctr_cia.INIT0 = 16'b0110011010101010;
    defparam w_gctr_cia.INIT1 = 16'b0110011010101010;
    defparam w_gctr_cia.INJECT1_0 = "NO";
    defparam w_gctr_cia.INJECT1_1 = "NO";
    CCU2C w_gctr_0 (.A0(wcount_0), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(wcount_1), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(w_gctr_ci), 
          .COUT(co0), .S0(iwcount_0), .S1(iwcount_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(306[11] 308[69])
    defparam w_gctr_0.INIT0 = 16'b0110011010101010;
    defparam w_gctr_0.INIT1 = 16'b0110011010101010;
    defparam w_gctr_0.INJECT1_0 = "NO";
    defparam w_gctr_0.INJECT1_1 = "NO";
    CCU2C w_gctr_1 (.A0(wcount_2), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(co0), 
          .S0(iwcount_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(314[11] 316[54])
    defparam w_gctr_1.INIT0 = 16'b0110011010101010;
    defparam w_gctr_1.INIT1 = 16'b0110011010101010;
    defparam w_gctr_1.INJECT1_0 = "NO";
    defparam w_gctr_1.INJECT1_1 = "NO";
    CCU2C r_gctr_cia (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(VCC_net), .B1(VCC_net), .C1(VCC_net), .D1(VCC_net), .COUT(r_gctr_ci)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(322[11] 324[48])
    defparam r_gctr_cia.INIT0 = 16'b0110011010101010;
    defparam r_gctr_cia.INIT1 = 16'b0110011010101010;
    defparam r_gctr_cia.INJECT1_0 = "NO";
    defparam r_gctr_cia.INJECT1_1 = "NO";
    CCU2C r_gctr_0 (.A0(rcount_0), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(rcount_1), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(r_gctr_ci), 
          .COUT(co0_1), .S0(ircount_0), .S1(ircount_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(330[11] 332[71])
    defparam r_gctr_0.INIT0 = 16'b0110011010101010;
    defparam r_gctr_0.INIT1 = 16'b0110011010101010;
    defparam r_gctr_0.INJECT1_0 = "NO";
    defparam r_gctr_0.INJECT1_1 = "NO";
    CCU2C r_gctr_1 (.A0(rcount_2), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(co0_1), 
          .S0(ircount_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(338[11] 340[58])
    defparam r_gctr_1.INIT0 = 16'b0110011010101010;
    defparam r_gctr_1.INIT1 = 16'b0110011010101010;
    defparam r_gctr_1.INJECT1_0 = "NO";
    defparam r_gctr_1.INJECT1_1 = "NO";
    CCU2C empty_cmp_ci_a (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(rden_i), .B1(rden_i), .C1(VCC_net), .D1(VCC_net), .COUT(cmp_ci)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(346[11] 348[45])
    defparam empty_cmp_ci_a.INIT0 = 16'b0110011010101010;
    defparam empty_cmp_ci_a.INIT1 = 16'b0110011010101010;
    defparam empty_cmp_ci_a.INJECT1_0 = "NO";
    defparam empty_cmp_ci_a.INJECT1_1 = "NO";
    CCU2C empty_cmp_0 (.A0(rcount_0), .B0(wcount_r0), .C0(VCC_net), .D0(VCC_net), 
          .A1(rcount_1), .B1(wcount_r1), .C1(VCC_net), .D1(VCC_net), 
          .CIN(cmp_ci), .COUT(co0_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(354[11] 356[50])
    defparam empty_cmp_0.INIT0 = 16'b1001100110101010;
    defparam empty_cmp_0.INIT1 = 16'b1001100110101010;
    defparam empty_cmp_0.INJECT1_0 = "NO";
    defparam empty_cmp_0.INJECT1_1 = "NO";
    CCU2C empty_cmp_1 (.A0(empty_cmp_set), .B0(empty_cmp_clr), .C0(VCC_net), 
          .D0(VCC_net), .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), 
          .CIN(co0_2), .COUT(empty_d_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(362[11] 364[69])
    defparam empty_cmp_1.INIT0 = 16'b1001100110101010;
    defparam empty_cmp_1.INIT1 = 16'b1001100110101010;
    defparam empty_cmp_1.INJECT1_0 = "NO";
    defparam empty_cmp_1.INJECT1_1 = "NO";
    CCU2C a0 (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(empty_d_c), 
          .S0(empty_d)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(370[11] 372[55])
    defparam a0.INIT0 = 16'b0110011010101010;
    defparam a0.INIT1 = 16'b0110011010101010;
    defparam a0.INJECT1_0 = "NO";
    defparam a0.INJECT1_1 = "NO";
    CCU2C full_cmp_ci_a (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(wren_i), .B1(wren_i), .C1(VCC_net), .D1(VCC_net), .COUT(cmp_ci_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(378[11] 380[47])
    defparam full_cmp_ci_a.INIT0 = 16'b0110011010101010;
    defparam full_cmp_ci_a.INIT1 = 16'b0110011010101010;
    defparam full_cmp_ci_a.INJECT1_0 = "NO";
    defparam full_cmp_ci_a.INJECT1_1 = "NO";
    CCU2C full_cmp_0 (.A0(wcount_0), .B0(rcount_w0), .C0(VCC_net), .D0(VCC_net), 
          .A1(wcount_1), .B1(rcount_w1), .C1(VCC_net), .D1(VCC_net), 
          .CIN(cmp_ci_1), .COUT(co0_3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(386[11] 388[52])
    defparam full_cmp_0.INIT0 = 16'b1001100110101010;
    defparam full_cmp_0.INIT1 = 16'b1001100110101010;
    defparam full_cmp_0.INJECT1_0 = "NO";
    defparam full_cmp_0.INJECT1_1 = "NO";
    CCU2C full_cmp_1 (.A0(full_cmp_set), .B0(full_cmp_clr), .C0(VCC_net), 
          .D0(VCC_net), .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), 
          .CIN(co0_3), .COUT(full_d_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(394[11] 396[68])
    defparam full_cmp_1.INIT0 = 16'b1001100110101010;
    defparam full_cmp_1.INIT1 = 16'b1001100110101010;
    defparam full_cmp_1.INJECT1_0 = "NO";
    defparam full_cmp_1.INJECT1_1 = "NO";
    CCU2C a1 (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(full_d_c), 
          .S0(full_d)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(406[11] 408[53])
    defparam a1.INIT0 = 16'b0110011010101010;
    defparam a1.INIT1 = 16'b0110011010101010;
    defparam a1.INJECT1_0 = "NO";
    defparam a1.INJECT1_1 = "NO";
    AND2 AND2_t6 (.A(w_rx_24_fifo_push), .B(invout_1), .Z(wren_i)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(93[10:54])
    INV INV_1 (.A(Full), .Z(invout_1)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(680[20] 691[2])
    AND2 AND2_t5 (.A(n14347), .B(invout_0), .Z(rden_i)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(97[10:54])
    INV INV_0 (.A(wifi_i_empty), .Z(invout_0)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(680[20] 691[2])
    XOR2 XOR2_t3 (.A(wcount_0), .B(wcount_1), .Z(w_gdata_0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(103[10:61])
    XOR2 XOR2_t2 (.A(wcount_1), .B(wcount_2), .Z(w_gdata_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(105[10:61])
    XOR2 XOR2_t1 (.A(rcount_0), .B(rcount_1), .Z(r_gdata_0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(107[10:61])
    XOR2 XOR2_t0 (.A(rcount_1), .B(rcount_2), .Z(r_gdata_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(109[10:61])
    ROM16X1A LUT4_7 (.AD0(GND_net), .AD1(GND_net), .AD2(w_gcount_r22), 
            .AD3(w_gcount_r21), .DO0(wcount_r1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(680[20] 691[2])
    defparam LUT4_7.initval = 16'b0110100110010110;
    ROM16X1A LUT4_6 (.AD0(GND_net), .AD1(w_gcount_r22), .AD2(w_gcount_r21), 
            .AD3(w_gcount_r20), .DO0(wcount_r0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(680[20] 691[2])
    defparam LUT4_6.initval = 16'b0110100110010110;
    ROM16X1A LUT4_5 (.AD0(GND_net), .AD1(GND_net), .AD2(r_gcount_w22), 
            .AD3(r_gcount_w21), .DO0(rcount_w1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(680[20] 691[2])
    defparam LUT4_5.initval = 16'b0110100110010110;
    ROM16X1A LUT4_4 (.AD0(GND_net), .AD1(r_gcount_w22), .AD2(r_gcount_w21), 
            .AD3(r_gcount_w20), .DO0(rcount_w0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(680[20] 691[2])
    defparam LUT4_4.initval = 16'b0110100110010110;
    ROM16X1A LUT4_3 (.AD0(GND_net), .AD1(w_gcount_r22), .AD2(rcount_2), 
            .AD3(rptr_2), .DO0(empty_cmp_set)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(680[20] 691[2])
    defparam LUT4_3.initval = 16'b0000010000010000;
    ROM16X1A LUT4_2 (.AD0(GND_net), .AD1(w_gcount_r22), .AD2(rcount_2), 
            .AD3(rptr_2), .DO0(empty_cmp_clr)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(680[20] 691[2])
    defparam LUT4_2.initval = 16'b0001000000000100;
    ROM16X1A LUT4_1 (.AD0(GND_net), .AD1(r_gcount_w22), .AD2(wcount_2), 
            .AD3(wptr_2), .DO0(full_cmp_set)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(680[20] 691[2])
    defparam LUT4_1.initval = 16'b0000000101000000;
    ROM16X1A LUT4_0 (.AD0(GND_net), .AD1(r_gcount_w22), .AD2(wcount_2), 
            .AD3(wptr_2), .DO0(full_cmp_clr)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(680[20] 691[2])
    defparam LUT4_0.initval = 16'b0100000000000001;
    DP16KD pdp_ram_0_0_0 (.DIA0(\w_rx_24_fifo_data[16] ), .DIA1(\w_rx_24_fifo_data[17] ), 
           .DIA2(\w_rx_24_fifo_data[18] ), .DIA3(\w_rx_24_fifo_data[19] ), 
           .DIA4(\w_rx_24_fifo_data[20] ), .DIA5(\w_rx_24_fifo_data[21] ), 
           .DIA6(\w_rx_24_fifo_data[22] ), .DIA7(\w_rx_24_fifo_data[23] ), 
           .DIA8(\w_rx_24_fifo_data[24] ), .DIA9(\w_rx_24_fifo_data[25] ), 
           .DIA10(\w_rx_24_fifo_data[26] ), .DIA11(\w_rx_24_fifo_data[27] ), 
           .DIA12(\w_rx_24_fifo_data[28] ), .DIA13(\w_rx_24_fifo_data[29] ), 
           .DIA14(\w_rx_24_fifo_data[30] ), .DIA15(\w_rx_24_fifo_data[31] ), 
           .DIA16(GND_net), .DIA17(GND_net), .ADA0(VCC_net), .ADA1(VCC_net), 
           .ADA2(GND_net), .ADA3(GND_net), .ADA4(wptr_0), .ADA5(wptr_1), 
           .ADA6(GND_net), .ADA7(GND_net), .ADA8(GND_net), .ADA9(GND_net), 
           .ADA10(GND_net), .ADA11(GND_net), .ADA12(GND_net), .ADA13(GND_net), 
           .CEA(wren_i), .OCEA(wren_i), .CLKA(sdr_rxclk_c), .WEA(VCC_net), 
           .CSA0(GND_net), .CSA1(GND_net), .CSA2(GND_net), .RSTA(main_reset_n_N_208), 
           .DIB0(GND_net), .DIB1(GND_net), .DIB2(GND_net), .DIB3(GND_net), 
           .DIB4(GND_net), .DIB5(GND_net), .DIB6(GND_net), .DIB7(GND_net), 
           .DIB8(GND_net), .DIB9(GND_net), .DIB10(GND_net), .DIB11(GND_net), 
           .DIB12(GND_net), .DIB13(GND_net), .DIB14(GND_net), .DIB15(GND_net), 
           .DIB16(GND_net), .DIB17(GND_net), .ADB0(GND_net), .ADB1(GND_net), 
           .ADB2(GND_net), .ADB3(GND_net), .ADB4(rptr_0), .ADB5(rptr_1), 
           .ADB6(GND_net), .ADB7(GND_net), .ADB8(GND_net), .ADB9(GND_net), 
           .ADB10(GND_net), .ADB11(GND_net), .ADB12(GND_net), .ADB13(GND_net), 
           .CEB(rden_i), .OCEB(rden_i), .CLKB(internal_80MHz), .WEB(GND_net), 
           .CSB0(GND_net), .CSB1(GND_net), .CSB2(GND_net), .RSTB(main_reset_n_N_208), 
           .DOB0(wifi_i_fifo_data_out[0]), .DOB1(wifi_i_fifo_data_out[1]), 
           .DOB2(wifi_i_fifo_data_out[2]), .DOB3(wifi_i_fifo_data_out[3]), 
           .DOB4(wifi_i_fifo_data_out[4]), .DOB5(wifi_i_fifo_data_out[5]), 
           .DOB6(wifi_i_fifo_data_out[6]), .DOB7(wifi_i_fifo_data_out[7]), 
           .DOB8(wifi_i_fifo_data_out[8]), .DOB9(wifi_i_fifo_data_out[9]), 
           .DOB10(wifi_i_fifo_data_out[10]), .DOB11(wifi_i_fifo_data_out[11]), 
           .DOB12(wifi_i_fifo_data_out[12]), .DOB13(wifi_i_fifo_data_out[13]), 
           .DOB14(wifi_i_fifo_data_out[14]), .DOB15(wifi_i_fifo_data_out[15])) /* synthesis MEM_LPC_FILE="fifo_dc_16in_16out.lpc", MEM_INIT_FILE="", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=680, LSE_RLINE=691 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(680[20] 691[2])
    defparam pdp_ram_0_0_0.DATA_WIDTH_A = 18;
    defparam pdp_ram_0_0_0.DATA_WIDTH_B = 18;
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
// Verilog Description of module fifo_dc_16in_16out_U3
//

module fifo_dc_16in_16out_U3 (sdr_rxclk_c, internal_80MHz, rRst, subg_q_empty, 
            GND_net, VCC_net, w_rx_09_fifo_push, n14348, \w_rx_09_fifo_data[15] , 
            \w_rx_09_fifo_data[14] , \w_rx_09_fifo_data[13] , \w_rx_09_fifo_data[12] , 
            \w_rx_09_fifo_data[11] , \w_rx_09_fifo_data[10] , \w_rx_09_fifo_data[9] , 
            \w_rx_09_fifo_data[8] , \w_rx_09_fifo_data[7] , \w_rx_09_fifo_data[6] , 
            \w_rx_09_fifo_data[5] , \w_rx_09_fifo_data[4] , \w_rx_09_fifo_data[3] , 
            \w_rx_09_fifo_data[2] , \w_rx_09_fifo_data[1] , \w_rx_09_fifo_data[0] , 
            main_reset_n_N_208, subg_q_fifo_data_out) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;
    input sdr_rxclk_c;
    input internal_80MHz;
    input rRst;
    output subg_q_empty;
    input GND_net;
    input VCC_net;
    input w_rx_09_fifo_push;
    input n14348;
    input \w_rx_09_fifo_data[15] ;
    input \w_rx_09_fifo_data[14] ;
    input \w_rx_09_fifo_data[13] ;
    input \w_rx_09_fifo_data[12] ;
    input \w_rx_09_fifo_data[11] ;
    input \w_rx_09_fifo_data[10] ;
    input \w_rx_09_fifo_data[9] ;
    input \w_rx_09_fifo_data[8] ;
    input \w_rx_09_fifo_data[7] ;
    input \w_rx_09_fifo_data[6] ;
    input \w_rx_09_fifo_data[5] ;
    input \w_rx_09_fifo_data[4] ;
    input \w_rx_09_fifo_data[3] ;
    input \w_rx_09_fifo_data[2] ;
    input \w_rx_09_fifo_data[1] ;
    input \w_rx_09_fifo_data[0] ;
    input main_reset_n_N_208;
    output [15:0]subg_q_fifo_data_out;
    
    wire sdr_rxclk_c /* synthesis IO_TYPES="LVDS", is_clock=1, SET_AS_NETWORK=sdr_rxclk_c */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(10[13:22])
    wire internal_80MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_80MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(84[6:20])
    wire VCC_net /* synthesis CE_NET_FOR_BUS20=20, DSPPORT_20=CE3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(26[14:27])
    
    wire wcount_1, wren_i, iwcount_1, wcount_2, iwcount_2, w_gcount_0, 
        w_gdata_0, w_gcount_1, w_gdata_1, w_gcount_2, wptr_0, wcount_0, 
        wptr_1, wptr_2, w_gcount_r0, ircount_0, rden_i, rcount_0, 
        ircount_1, rcount_1, ircount_2, rcount_2, r_gdata_0, r_gcount_0, 
        r_gdata_1, r_gcount_1, r_gcount_2, rptr_0, rptr_1, rptr_2, 
        w_gcount_r1, w_gcount_r2, w_gcount_r20, r_gcount_w0, r_gcount_w1, 
        r_gcount_w2, w_gcount_r21, w_gcount_r22, Full, full_d, r_gcount_w20, 
        r_gcount_w21, r_gcount_w22, empty_d, iwcount_0, w_gctr_ci, 
        co0, r_gctr_ci, co0_1, cmp_ci, wcount_r0, wcount_r1, co0_2, 
        empty_cmp_clr, empty_cmp_set, empty_d_c, cmp_ci_1, rcount_w0, 
        rcount_w1, co0_3, full_cmp_clr, full_cmp_set, full_d_c, invout_1, 
        invout_0;
    
    FD1P3AX FF_30 (.D(iwcount_1), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(188[13] 189[22])
    defparam FF_30.GSR = "ENABLED";
    FD1P3AX FF_29 (.D(iwcount_2), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(192[13] 193[22])
    defparam FF_29.GSR = "ENABLED";
    FD1P3AX FF_28 (.D(w_gdata_0), .SP(wren_i), .CK(sdr_rxclk_c), .Q(w_gcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(196[13] 197[24])
    defparam FF_28.GSR = "ENABLED";
    FD1P3AX FF_27 (.D(w_gdata_1), .SP(wren_i), .CK(sdr_rxclk_c), .Q(w_gcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(200[13] 201[24])
    defparam FF_27.GSR = "ENABLED";
    FD1P3AX FF_26 (.D(wcount_2), .SP(wren_i), .CK(sdr_rxclk_c), .Q(w_gcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(204[13] 205[24])
    defparam FF_26.GSR = "ENABLED";
    FD1P3AX FF_25 (.D(wcount_0), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wptr_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(208[13] 209[20])
    defparam FF_25.GSR = "ENABLED";
    FD1P3AX FF_24 (.D(wcount_1), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wptr_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(212[13] 213[20])
    defparam FF_24.GSR = "ENABLED";
    FD1P3AX FF_23 (.D(wcount_2), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wptr_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(216[13] 217[20])
    defparam FF_23.GSR = "ENABLED";
    FD1S3AX FF_13 (.D(w_gcount_0), .CK(internal_80MHz), .Q(w_gcount_r0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(252[13:78])
    defparam FF_13.GSR = "ENABLED";
    FD1P3BX FF_22 (.D(ircount_0), .SP(rden_i), .CK(internal_80MHz), .PD(rRst), 
            .Q(rcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(220[13] 221[22])
    defparam FF_22.GSR = "DISABLED";
    FD1P3DX FF_21 (.D(ircount_1), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(224[13] 225[22])
    defparam FF_21.GSR = "DISABLED";
    FD1P3DX FF_20 (.D(ircount_2), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(228[13] 229[22])
    defparam FF_20.GSR = "DISABLED";
    FD1P3DX FF_19 (.D(r_gdata_0), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(232[13] 233[24])
    defparam FF_19.GSR = "DISABLED";
    FD1P3DX FF_18 (.D(r_gdata_1), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(236[13] 237[24])
    defparam FF_18.GSR = "DISABLED";
    FD1P3DX FF_17 (.D(rcount_2), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(240[13:87])
    defparam FF_17.GSR = "DISABLED";
    FD1P3DX FF_16 (.D(rcount_0), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(243[13:83])
    defparam FF_16.GSR = "DISABLED";
    FD1P3DX FF_15 (.D(rcount_1), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(246[13:83])
    defparam FF_15.GSR = "DISABLED";
    FD1P3DX FF_14 (.D(rcount_2), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(249[13:83])
    defparam FF_14.GSR = "DISABLED";
    FD1S3AX FF_12 (.D(w_gcount_1), .CK(internal_80MHz), .Q(w_gcount_r1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(255[13:78])
    defparam FF_12.GSR = "ENABLED";
    FD1S3AX FF_11 (.D(w_gcount_2), .CK(internal_80MHz), .Q(w_gcount_r2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(258[13:78])
    defparam FF_11.GSR = "ENABLED";
    FD1S3AX FF_7 (.D(w_gcount_r0), .CK(internal_80MHz), .Q(w_gcount_r20)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(270[13:79])
    defparam FF_7.GSR = "ENABLED";
    FD1S3DX FF_10 (.D(r_gcount_0), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(261[13:77])
    defparam FF_10.GSR = "DISABLED";
    FD1S3DX FF_9 (.D(r_gcount_1), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(264[13:76])
    defparam FF_9.GSR = "DISABLED";
    FD1S3DX FF_8 (.D(r_gcount_2), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(267[13:76])
    defparam FF_8.GSR = "DISABLED";
    FD1S3AX FF_6 (.D(w_gcount_r1), .CK(internal_80MHz), .Q(w_gcount_r21)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(273[13:79])
    defparam FF_6.GSR = "ENABLED";
    FD1S3AX FF_5 (.D(w_gcount_r2), .CK(internal_80MHz), .Q(w_gcount_r22)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(276[13:79])
    defparam FF_5.GSR = "ENABLED";
    FD1S3AX FF_0 (.D(full_d), .CK(sdr_rxclk_c), .Q(Full)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(291[13:68])
    defparam FF_0.GSR = "ENABLED";
    FD1S3DX FF_4 (.D(r_gcount_w0), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w20)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(279[13:78])
    defparam FF_4.GSR = "DISABLED";
    FD1S3DX FF_3 (.D(r_gcount_w1), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w21)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(282[13:78])
    defparam FF_3.GSR = "DISABLED";
    FD1S3DX FF_2 (.D(r_gcount_w2), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w22)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(285[13:78])
    defparam FF_2.GSR = "DISABLED";
    FD1S3BX FF_1 (.D(empty_d), .CK(internal_80MHz), .PD(rRst), .Q(subg_q_empty)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(288[13:69])
    defparam FF_1.GSR = "DISABLED";
    FD1P3AY FF_31 (.D(iwcount_0), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(184[13] 185[22])
    defparam FF_31.GSR = "ENABLED";
    CCU2C w_gctr_cia (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(VCC_net), .B1(VCC_net), .C1(VCC_net), .D1(VCC_net), .COUT(w_gctr_ci)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(298[11] 300[48])
    defparam w_gctr_cia.INIT0 = 16'b0110011010101010;
    defparam w_gctr_cia.INIT1 = 16'b0110011010101010;
    defparam w_gctr_cia.INJECT1_0 = "NO";
    defparam w_gctr_cia.INJECT1_1 = "NO";
    CCU2C w_gctr_0 (.A0(wcount_0), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(wcount_1), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(w_gctr_ci), 
          .COUT(co0), .S0(iwcount_0), .S1(iwcount_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(306[11] 308[69])
    defparam w_gctr_0.INIT0 = 16'b0110011010101010;
    defparam w_gctr_0.INIT1 = 16'b0110011010101010;
    defparam w_gctr_0.INJECT1_0 = "NO";
    defparam w_gctr_0.INJECT1_1 = "NO";
    CCU2C w_gctr_1 (.A0(wcount_2), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(co0), 
          .S0(iwcount_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(314[11] 316[54])
    defparam w_gctr_1.INIT0 = 16'b0110011010101010;
    defparam w_gctr_1.INIT1 = 16'b0110011010101010;
    defparam w_gctr_1.INJECT1_0 = "NO";
    defparam w_gctr_1.INJECT1_1 = "NO";
    CCU2C r_gctr_cia (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(VCC_net), .B1(VCC_net), .C1(VCC_net), .D1(VCC_net), .COUT(r_gctr_ci)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(322[11] 324[48])
    defparam r_gctr_cia.INIT0 = 16'b0110011010101010;
    defparam r_gctr_cia.INIT1 = 16'b0110011010101010;
    defparam r_gctr_cia.INJECT1_0 = "NO";
    defparam r_gctr_cia.INJECT1_1 = "NO";
    CCU2C r_gctr_0 (.A0(rcount_0), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(rcount_1), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(r_gctr_ci), 
          .COUT(co0_1), .S0(ircount_0), .S1(ircount_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(330[11] 332[71])
    defparam r_gctr_0.INIT0 = 16'b0110011010101010;
    defparam r_gctr_0.INIT1 = 16'b0110011010101010;
    defparam r_gctr_0.INJECT1_0 = "NO";
    defparam r_gctr_0.INJECT1_1 = "NO";
    CCU2C r_gctr_1 (.A0(rcount_2), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(co0_1), 
          .S0(ircount_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(338[11] 340[58])
    defparam r_gctr_1.INIT0 = 16'b0110011010101010;
    defparam r_gctr_1.INIT1 = 16'b0110011010101010;
    defparam r_gctr_1.INJECT1_0 = "NO";
    defparam r_gctr_1.INJECT1_1 = "NO";
    CCU2C empty_cmp_ci_a (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(rden_i), .B1(rden_i), .C1(VCC_net), .D1(VCC_net), .COUT(cmp_ci)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(346[11] 348[45])
    defparam empty_cmp_ci_a.INIT0 = 16'b0110011010101010;
    defparam empty_cmp_ci_a.INIT1 = 16'b0110011010101010;
    defparam empty_cmp_ci_a.INJECT1_0 = "NO";
    defparam empty_cmp_ci_a.INJECT1_1 = "NO";
    CCU2C empty_cmp_0 (.A0(rcount_0), .B0(wcount_r0), .C0(VCC_net), .D0(VCC_net), 
          .A1(rcount_1), .B1(wcount_r1), .C1(VCC_net), .D1(VCC_net), 
          .CIN(cmp_ci), .COUT(co0_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(354[11] 356[50])
    defparam empty_cmp_0.INIT0 = 16'b1001100110101010;
    defparam empty_cmp_0.INIT1 = 16'b1001100110101010;
    defparam empty_cmp_0.INJECT1_0 = "NO";
    defparam empty_cmp_0.INJECT1_1 = "NO";
    CCU2C empty_cmp_1 (.A0(empty_cmp_set), .B0(empty_cmp_clr), .C0(VCC_net), 
          .D0(VCC_net), .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), 
          .CIN(co0_2), .COUT(empty_d_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(362[11] 364[69])
    defparam empty_cmp_1.INIT0 = 16'b1001100110101010;
    defparam empty_cmp_1.INIT1 = 16'b1001100110101010;
    defparam empty_cmp_1.INJECT1_0 = "NO";
    defparam empty_cmp_1.INJECT1_1 = "NO";
    CCU2C a0 (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(empty_d_c), 
          .S0(empty_d)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(370[11] 372[55])
    defparam a0.INIT0 = 16'b0110011010101010;
    defparam a0.INIT1 = 16'b0110011010101010;
    defparam a0.INJECT1_0 = "NO";
    defparam a0.INJECT1_1 = "NO";
    CCU2C full_cmp_ci_a (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(wren_i), .B1(wren_i), .C1(VCC_net), .D1(VCC_net), .COUT(cmp_ci_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(378[11] 380[47])
    defparam full_cmp_ci_a.INIT0 = 16'b0110011010101010;
    defparam full_cmp_ci_a.INIT1 = 16'b0110011010101010;
    defparam full_cmp_ci_a.INJECT1_0 = "NO";
    defparam full_cmp_ci_a.INJECT1_1 = "NO";
    CCU2C full_cmp_0 (.A0(wcount_0), .B0(rcount_w0), .C0(VCC_net), .D0(VCC_net), 
          .A1(wcount_1), .B1(rcount_w1), .C1(VCC_net), .D1(VCC_net), 
          .CIN(cmp_ci_1), .COUT(co0_3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(386[11] 388[52])
    defparam full_cmp_0.INIT0 = 16'b1001100110101010;
    defparam full_cmp_0.INIT1 = 16'b1001100110101010;
    defparam full_cmp_0.INJECT1_0 = "NO";
    defparam full_cmp_0.INJECT1_1 = "NO";
    CCU2C full_cmp_1 (.A0(full_cmp_set), .B0(full_cmp_clr), .C0(VCC_net), 
          .D0(VCC_net), .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), 
          .CIN(co0_3), .COUT(full_d_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(394[11] 396[68])
    defparam full_cmp_1.INIT0 = 16'b1001100110101010;
    defparam full_cmp_1.INIT1 = 16'b1001100110101010;
    defparam full_cmp_1.INJECT1_0 = "NO";
    defparam full_cmp_1.INJECT1_1 = "NO";
    CCU2C a1 (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(full_d_c), 
          .S0(full_d)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(406[11] 408[53])
    defparam a1.INIT0 = 16'b0110011010101010;
    defparam a1.INIT1 = 16'b0110011010101010;
    defparam a1.INJECT1_0 = "NO";
    defparam a1.INJECT1_1 = "NO";
    AND2 AND2_t6 (.A(w_rx_09_fifo_push), .B(invout_1), .Z(wren_i)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(93[10:54])
    INV INV_1 (.A(Full), .Z(invout_1)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(663[20] 674[2])
    AND2 AND2_t5 (.A(n14348), .B(invout_0), .Z(rden_i)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(97[10:54])
    INV INV_0 (.A(subg_q_empty), .Z(invout_0)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(663[20] 674[2])
    XOR2 XOR2_t3 (.A(wcount_0), .B(wcount_1), .Z(w_gdata_0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(103[10:61])
    XOR2 XOR2_t2 (.A(wcount_1), .B(wcount_2), .Z(w_gdata_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(105[10:61])
    XOR2 XOR2_t1 (.A(rcount_0), .B(rcount_1), .Z(r_gdata_0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(107[10:61])
    XOR2 XOR2_t0 (.A(rcount_1), .B(rcount_2), .Z(r_gdata_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(109[10:61])
    ROM16X1A LUT4_7 (.AD0(GND_net), .AD1(GND_net), .AD2(w_gcount_r22), 
            .AD3(w_gcount_r21), .DO0(wcount_r1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(663[20] 674[2])
    defparam LUT4_7.initval = 16'b0110100110010110;
    ROM16X1A LUT4_6 (.AD0(GND_net), .AD1(w_gcount_r22), .AD2(w_gcount_r21), 
            .AD3(w_gcount_r20), .DO0(wcount_r0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(663[20] 674[2])
    defparam LUT4_6.initval = 16'b0110100110010110;
    ROM16X1A LUT4_5 (.AD0(GND_net), .AD1(GND_net), .AD2(r_gcount_w22), 
            .AD3(r_gcount_w21), .DO0(rcount_w1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(663[20] 674[2])
    defparam LUT4_5.initval = 16'b0110100110010110;
    ROM16X1A LUT4_4 (.AD0(GND_net), .AD1(r_gcount_w22), .AD2(r_gcount_w21), 
            .AD3(r_gcount_w20), .DO0(rcount_w0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(663[20] 674[2])
    defparam LUT4_4.initval = 16'b0110100110010110;
    ROM16X1A LUT4_3 (.AD0(GND_net), .AD1(w_gcount_r22), .AD2(rcount_2), 
            .AD3(rptr_2), .DO0(empty_cmp_set)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(663[20] 674[2])
    defparam LUT4_3.initval = 16'b0000010000010000;
    ROM16X1A LUT4_2 (.AD0(GND_net), .AD1(w_gcount_r22), .AD2(rcount_2), 
            .AD3(rptr_2), .DO0(empty_cmp_clr)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(663[20] 674[2])
    defparam LUT4_2.initval = 16'b0001000000000100;
    ROM16X1A LUT4_1 (.AD0(GND_net), .AD1(r_gcount_w22), .AD2(wcount_2), 
            .AD3(wptr_2), .DO0(full_cmp_set)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(663[20] 674[2])
    defparam LUT4_1.initval = 16'b0000000101000000;
    ROM16X1A LUT4_0 (.AD0(GND_net), .AD1(r_gcount_w22), .AD2(wcount_2), 
            .AD3(wptr_2), .DO0(full_cmp_clr)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(663[20] 674[2])
    defparam LUT4_0.initval = 16'b0100000000000001;
    DP16KD pdp_ram_0_0_0 (.DIA0(\w_rx_09_fifo_data[0] ), .DIA1(\w_rx_09_fifo_data[1] ), 
           .DIA2(\w_rx_09_fifo_data[2] ), .DIA3(\w_rx_09_fifo_data[3] ), 
           .DIA4(\w_rx_09_fifo_data[4] ), .DIA5(\w_rx_09_fifo_data[5] ), 
           .DIA6(\w_rx_09_fifo_data[6] ), .DIA7(\w_rx_09_fifo_data[7] ), 
           .DIA8(\w_rx_09_fifo_data[8] ), .DIA9(\w_rx_09_fifo_data[9] ), 
           .DIA10(\w_rx_09_fifo_data[10] ), .DIA11(\w_rx_09_fifo_data[11] ), 
           .DIA12(\w_rx_09_fifo_data[12] ), .DIA13(\w_rx_09_fifo_data[13] ), 
           .DIA14(\w_rx_09_fifo_data[14] ), .DIA15(\w_rx_09_fifo_data[15] ), 
           .DIA16(GND_net), .DIA17(GND_net), .ADA0(VCC_net), .ADA1(VCC_net), 
           .ADA2(GND_net), .ADA3(GND_net), .ADA4(wptr_0), .ADA5(wptr_1), 
           .ADA6(GND_net), .ADA7(GND_net), .ADA8(GND_net), .ADA9(GND_net), 
           .ADA10(GND_net), .ADA11(GND_net), .ADA12(GND_net), .ADA13(GND_net), 
           .CEA(wren_i), .OCEA(wren_i), .CLKA(sdr_rxclk_c), .WEA(VCC_net), 
           .CSA0(GND_net), .CSA1(GND_net), .CSA2(GND_net), .RSTA(main_reset_n_N_208), 
           .DIB0(GND_net), .DIB1(GND_net), .DIB2(GND_net), .DIB3(GND_net), 
           .DIB4(GND_net), .DIB5(GND_net), .DIB6(GND_net), .DIB7(GND_net), 
           .DIB8(GND_net), .DIB9(GND_net), .DIB10(GND_net), .DIB11(GND_net), 
           .DIB12(GND_net), .DIB13(GND_net), .DIB14(GND_net), .DIB15(GND_net), 
           .DIB16(GND_net), .DIB17(GND_net), .ADB0(GND_net), .ADB1(GND_net), 
           .ADB2(GND_net), .ADB3(GND_net), .ADB4(rptr_0), .ADB5(rptr_1), 
           .ADB6(GND_net), .ADB7(GND_net), .ADB8(GND_net), .ADB9(GND_net), 
           .ADB10(GND_net), .ADB11(GND_net), .ADB12(GND_net), .ADB13(GND_net), 
           .CEB(rden_i), .OCEB(rden_i), .CLKB(internal_80MHz), .WEB(GND_net), 
           .CSB0(GND_net), .CSB1(GND_net), .CSB2(GND_net), .RSTB(main_reset_n_N_208), 
           .DOB0(subg_q_fifo_data_out[0]), .DOB1(subg_q_fifo_data_out[1]), 
           .DOB2(subg_q_fifo_data_out[2]), .DOB3(subg_q_fifo_data_out[3]), 
           .DOB4(subg_q_fifo_data_out[4]), .DOB5(subg_q_fifo_data_out[5]), 
           .DOB6(subg_q_fifo_data_out[6]), .DOB7(subg_q_fifo_data_out[7]), 
           .DOB8(subg_q_fifo_data_out[8]), .DOB9(subg_q_fifo_data_out[9]), 
           .DOB10(subg_q_fifo_data_out[10]), .DOB11(subg_q_fifo_data_out[11]), 
           .DOB12(subg_q_fifo_data_out[12]), .DOB13(subg_q_fifo_data_out[13]), 
           .DOB14(subg_q_fifo_data_out[14]), .DOB15(subg_q_fifo_data_out[15])) /* synthesis MEM_LPC_FILE="fifo_dc_16in_16out.lpc", MEM_INIT_FILE="", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=663, LSE_RLINE=674 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(663[20] 674[2])
    defparam pdp_ram_0_0_0.DATA_WIDTH_A = 18;
    defparam pdp_ram_0_0_0.DATA_WIDTH_B = 18;
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

module pll_10MHzInput (dpll_clkout0_c, n14343, second_pll_lock, GND_net) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;
    input dpll_clkout0_c;
    input n14343;
    output second_pll_lock;
    input GND_net;
    
    wire dpll_clkout0_c /* synthesis is_clock=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(6[13:25])
    wire CLKOP /* synthesis is_clock=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/pll_10mhzinput/pll_10mhzinput.v(11[17:22])
    
    EHXPLLL PLLInst_0 (.CLKI(dpll_clkout0_c), .CLKFB(CLKOP), .PHASESEL0(GND_net), 
            .PHASESEL1(GND_net), .PHASEDIR(GND_net), .PHASESTEP(GND_net), 
            .PHASELOADREG(GND_net), .STDBY(GND_net), .PLLWAKESYNC(GND_net), 
            .RST(n14343), .ENCLKOP(GND_net), .ENCLKOS(GND_net), .ENCLKOS2(GND_net), 
            .ENCLKOS3(GND_net), .CLKOP(CLKOP), .LOCK(second_pll_lock)) /* synthesis FREQUENCY_PIN_CLKOP="200.000000", FREQUENCY_PIN_CLKI="10.000000", ICP_CURRENT="5", LPF_RESISTOR="16", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=16, LSE_RCOL=2, LSE_LLINE=101, LSE_RLINE=106 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(101[16] 106[2])
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
// Verilog Description of module ecp5_spi_master_top
//

module ecp5_spi_master_top (internal_80MHz_enable_68, shift_reg_15__N_1175, 
            internal_80MHz, spi4_mosi_c, main_reset_n_N_208, n14285, 
            internal_80MHz_enable_67, GND_net, spi4_sck_c, spi4_sck_N_442) /* synthesis syn_module_defined=1 */ ;
    input internal_80MHz_enable_68;
    output shift_reg_15__N_1175;
    input internal_80MHz;
    output spi4_mosi_c;
    input main_reset_n_N_208;
    input n14285;
    input internal_80MHz_enable_67;
    input GND_net;
    output spi4_sck_c;
    input [15:0]spi4_sck_N_442;
    
    wire internal_80MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_80MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(84[6:20])
    
    wire n14286;
    wire [5:0]bit_counter;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(386[15:26])
    wire [5:0]bit_counter_5__N_1144;
    
    wire n14309, n6346, o_mosi_N_1176;
    wire [5:0]bit_counter_5__N_1168;
    wire [15:0]shift_reg;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(385[16:25])
    wire [15:0]shift_reg_15__N_1126;
    
    wire n6352, n6354, n6350, n13140, n13138;
    
    LUT4 i6164_3_lut_4_lut (.A(internal_80MHz_enable_68), .B(shift_reg_15__N_1175), 
         .C(n14286), .D(bit_counter[4]), .Z(bit_counter_5__N_1144[4])) /* synthesis lut_function=(A ((C (D)+!C !(D))+!B)+!A (C (D)+!C !(D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[17:44])
    defparam i6164_3_lut_4_lut.init = 16'hf22f;
    LUT4 i1_3_lut_4_lut (.A(bit_counter[3]), .B(n14309), .C(bit_counter[4]), 
         .D(bit_counter[5]), .Z(n6346)) /* synthesis lut_function=(A (D)+!A (B (D)+!B (C (D)+!C !(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1_3_lut_4_lut.init = 16'hfe01;
    ODDRX1F mosi_ddr (.D0(o_mosi_N_1176), .D1(o_mosi_N_1176), .SCLK(internal_80MHz), 
            .RST(main_reset_n_N_208), .Q(spi4_mosi_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(786[21] 794[2])
    defparam mosi_ddr.GSR = "ENABLED";
    FD1S3IX bit_counter_i0 (.D(bit_counter_5__N_1168[0]), .CK(internal_80MHz), 
            .CD(n14285), .Q(bit_counter[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i0.GSR = "ENABLED";
    FD1P3AX shift_reg_i0 (.D(shift_reg_15__N_1126[0]), .SP(internal_80MHz_enable_67), 
            .CK(internal_80MHz), .Q(shift_reg[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i0.GSR = "ENABLED";
    ODDRX1F sclk_ddr (.D0(shift_reg_15__N_1175), .D1(GND_net), .SCLK(internal_80MHz), 
            .RST(main_reset_n_N_208), .Q(spi4_sck_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(786[21] 794[2])
    defparam sclk_ddr.GSR = "ENABLED";
    FD1P3IX bit_counter_i1 (.D(n6352), .SP(shift_reg_15__N_1175), .CD(n14285), 
            .CK(internal_80MHz), .Q(bit_counter[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i1.GSR = "ENABLED";
    FD1P3IX bit_counter_i2 (.D(n6354), .SP(shift_reg_15__N_1175), .CD(n14285), 
            .CK(internal_80MHz), .Q(bit_counter[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i2.GSR = "ENABLED";
    FD1P3IX bit_counter_i3 (.D(n6350), .SP(shift_reg_15__N_1175), .CD(n14285), 
            .CK(internal_80MHz), .Q(bit_counter[3])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i3.GSR = "ENABLED";
    FD1P3AX bit_counter_i4 (.D(bit_counter_5__N_1144[4]), .SP(internal_80MHz_enable_67), 
            .CK(internal_80MHz), .Q(bit_counter[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i4.GSR = "ENABLED";
    FD1P3IX bit_counter_i5 (.D(n6346), .SP(shift_reg_15__N_1175), .CD(n14285), 
            .CK(internal_80MHz), .Q(bit_counter[5])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam bit_counter_i5.GSR = "ENABLED";
    FD1P3AX shift_reg_i1 (.D(shift_reg_15__N_1126[1]), .SP(internal_80MHz_enable_67), 
            .CK(internal_80MHz), .Q(shift_reg[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i1.GSR = "ENABLED";
    FD1P3AX shift_reg_i2 (.D(shift_reg_15__N_1126[2]), .SP(internal_80MHz_enable_67), 
            .CK(internal_80MHz), .Q(shift_reg[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i2.GSR = "ENABLED";
    FD1P3AX shift_reg_i3 (.D(shift_reg_15__N_1126[3]), .SP(internal_80MHz_enable_67), 
            .CK(internal_80MHz), .Q(shift_reg[3])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i3.GSR = "ENABLED";
    FD1P3AX shift_reg_i4 (.D(shift_reg_15__N_1126[4]), .SP(internal_80MHz_enable_67), 
            .CK(internal_80MHz), .Q(shift_reg[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i4.GSR = "ENABLED";
    FD1P3AX shift_reg_i5 (.D(shift_reg_15__N_1126[5]), .SP(internal_80MHz_enable_67), 
            .CK(internal_80MHz), .Q(shift_reg[5])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i5.GSR = "ENABLED";
    FD1P3AX shift_reg_i6 (.D(shift_reg_15__N_1126[6]), .SP(internal_80MHz_enable_67), 
            .CK(internal_80MHz), .Q(shift_reg[6])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i6.GSR = "ENABLED";
    FD1P3AX shift_reg_i7 (.D(shift_reg_15__N_1126[7]), .SP(internal_80MHz_enable_67), 
            .CK(internal_80MHz), .Q(shift_reg[7])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i7.GSR = "ENABLED";
    FD1P3AX shift_reg_i8 (.D(shift_reg_15__N_1126[8]), .SP(internal_80MHz_enable_67), 
            .CK(internal_80MHz), .Q(shift_reg[8])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i8.GSR = "ENABLED";
    FD1P3AX shift_reg_i9 (.D(shift_reg_15__N_1126[9]), .SP(internal_80MHz_enable_67), 
            .CK(internal_80MHz), .Q(shift_reg[9])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i9.GSR = "ENABLED";
    FD1P3AX shift_reg_i10 (.D(shift_reg_15__N_1126[10]), .SP(internal_80MHz_enable_67), 
            .CK(internal_80MHz), .Q(shift_reg[10])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i10.GSR = "ENABLED";
    FD1P3AX shift_reg_i11 (.D(shift_reg_15__N_1126[11]), .SP(internal_80MHz_enable_67), 
            .CK(internal_80MHz), .Q(shift_reg[11])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i11.GSR = "ENABLED";
    FD1P3AX shift_reg_i12 (.D(shift_reg_15__N_1126[12]), .SP(internal_80MHz_enable_67), 
            .CK(internal_80MHz), .Q(shift_reg[12])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i12.GSR = "ENABLED";
    FD1P3AX shift_reg_i13 (.D(shift_reg_15__N_1126[13]), .SP(internal_80MHz_enable_67), 
            .CK(internal_80MHz), .Q(shift_reg[13])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i13.GSR = "ENABLED";
    FD1P3AX shift_reg_i14 (.D(shift_reg_15__N_1126[14]), .SP(internal_80MHz_enable_67), 
            .CK(internal_80MHz), .Q(shift_reg[14])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i14.GSR = "ENABLED";
    FD1P3IX shift_reg_i15 (.D(spi4_sck_N_442[15]), .SP(internal_80MHz_enable_68), 
            .CD(shift_reg_15__N_1175), .CK(internal_80MHz), .Q(shift_reg[15])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=21, LSE_RCOL=2, LSE_LLINE=786, LSE_RLINE=794 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(410[12] 417[6])
    defparam shift_reg_i15.GSR = "ENABLED";
    LUT4 i1_2_lut (.A(bit_counter[1]), .B(bit_counter[0]), .Z(n6352)) /* synthesis lut_function=(A (B)+!A !(B)) */ ;
    defparam i1_2_lut.init = 16'h9999;
    LUT4 i2497_3_lut (.A(spi4_sck_N_442[1]), .B(shift_reg[2]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[1])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2497_3_lut.init = 16'hcaca;
    LUT4 i2499_3_lut (.A(spi4_sck_N_442[2]), .B(shift_reg[3]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[2])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2499_3_lut.init = 16'hcaca;
    LUT4 i2501_3_lut (.A(spi4_sck_N_442[3]), .B(shift_reg[4]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[3])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2501_3_lut.init = 16'hcaca;
    LUT4 i2503_3_lut (.A(spi4_sck_N_442[4]), .B(shift_reg[5]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[4])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2503_3_lut.init = 16'hcaca;
    LUT4 i2505_3_lut (.A(spi4_sck_N_442[5]), .B(shift_reg[6]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[5])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2505_3_lut.init = 16'hcaca;
    LUT4 i2507_3_lut (.A(spi4_sck_N_442[6]), .B(shift_reg[7]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[6])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2507_3_lut.init = 16'hcaca;
    LUT4 i2509_3_lut (.A(spi4_sck_N_442[7]), .B(shift_reg[8]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[7])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2509_3_lut.init = 16'hcaca;
    LUT4 i2511_3_lut (.A(spi4_sck_N_442[8]), .B(shift_reg[9]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[8])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2511_3_lut.init = 16'hcaca;
    LUT4 i2513_3_lut (.A(spi4_sck_N_442[9]), .B(shift_reg[10]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[9])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2513_3_lut.init = 16'hcaca;
    LUT4 i2515_3_lut (.A(spi4_sck_N_442[10]), .B(shift_reg[11]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[10])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2515_3_lut.init = 16'hcaca;
    LUT4 i2517_3_lut (.A(spi4_sck_N_442[11]), .B(shift_reg[12]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[11])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2517_3_lut.init = 16'hcaca;
    LUT4 i2519_3_lut (.A(spi4_sck_N_442[12]), .B(shift_reg[13]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[12])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2519_3_lut.init = 16'hcaca;
    LUT4 i2521_3_lut (.A(spi4_sck_N_442[13]), .B(shift_reg[14]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[13])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2521_3_lut.init = 16'hcaca;
    LUT4 i2523_3_lut (.A(spi4_sck_N_442[14]), .B(shift_reg[15]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[14])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2523_3_lut.init = 16'hcaca;
    LUT4 i1_2_lut_3_lut (.A(bit_counter[1]), .B(bit_counter[0]), .C(bit_counter[2]), 
         .Z(n6354)) /* synthesis lut_function=(A (C)+!A (B (C)+!B !(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1_2_lut_3_lut.init = 16'he1e1;
    LUT4 i1904_2_lut_rep_225_3_lut (.A(bit_counter[1]), .B(bit_counter[0]), 
         .C(bit_counter[2]), .Z(n14309)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1904_2_lut_rep_225_3_lut.init = 16'hfefe;
    LUT4 i1_2_lut_3_lut_4_lut (.A(bit_counter[1]), .B(bit_counter[0]), .C(bit_counter[3]), 
         .D(bit_counter[2]), .Z(n6350)) /* synthesis lut_function=(A (C)+!A (B (C)+!B (C (D)+!C !(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1_2_lut_3_lut_4_lut.init = 16'hf0e1;
    LUT4 i1912_2_lut_rep_202_3_lut_4_lut (.A(bit_counter[1]), .B(bit_counter[0]), 
         .C(bit_counter[3]), .D(bit_counter[2]), .Z(n14286)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(416[19:37])
    defparam i1912_2_lut_rep_202_3_lut_4_lut.init = 16'hfffe;
    LUT4 i6087_2_lut (.A(shift_reg[0]), .B(shift_reg_15__N_1175), .Z(o_mosi_N_1176)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(398[8:46])
    defparam i6087_2_lut.init = 16'h8888;
    LUT4 i1_4_lut (.A(bit_counter[4]), .B(n13140), .C(n13138), .D(bit_counter[5]), 
         .Z(shift_reg_15__N_1175)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(390[8:24])
    defparam i1_4_lut.init = 16'hfffe;
    LUT4 i1_2_lut_adj_183 (.A(bit_counter[0]), .B(bit_counter[3]), .Z(n13140)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(390[8:24])
    defparam i1_2_lut_adj_183.init = 16'heeee;
    LUT4 i1_2_lut_adj_184 (.A(bit_counter[2]), .B(bit_counter[1]), .Z(n13138)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(390[8:24])
    defparam i1_2_lut_adj_184.init = 16'heeee;
    LUT4 i2092_2_lut (.A(bit_counter[0]), .B(shift_reg_15__N_1175), .Z(bit_counter_5__N_1168[0])) /* synthesis lut_function=(!(A (B)+!A !(B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2092_2_lut.init = 16'h6666;
    LUT4 i2148_3_lut (.A(spi4_sck_N_442[0]), .B(shift_reg[1]), .C(shift_reg_15__N_1175), 
         .Z(shift_reg_15__N_1126[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/myspi.v(414[12] 417[6])
    defparam i2148_3_lut.init = 16'hcaca;
    
endmodule
//
// Verilog Description of module \i2c_slave_wbm(WB_DATA_WIDTH=8,WB_ADDR_WIDTH=16,WB_SELECT_WIDTH=1) 
//

module \i2c_slave_wbm(WB_DATA_WIDTH=8,WB_ADDR_WIDTH=16,WB_SELECT_WIDTH=1)  (n13302, 
            int_clk_out_enable_99, wb_adr_o, int_clk_out, \wb_adr_o[7] , 
            n14356, \wb_adr_o[2] , \wb_adr_o[6] , \wb_adr_o[0] , \wb_adr_o[3] , 
            \ufl_p8_sel[7] , \reg2[7] , n14056, \ufl_p8_sel[5] , \reg2[5] , 
            n14019, \ufl_p8_sel[6] , \reg2[6] , n14029, \ufl_p8_sel[4] , 
            \reg2[4] , n14002, \reg2[2] , n2797, n11601, n12798, 
            int_clk_out_enable_54, int_clk_out_enable_55, n14330, int_clk_out_enable_77, 
            n12168, n11664, n12618, n14354, n9012, n13044, n14351, 
            int_clk_out_enable_107, int_clk_out_enable_83, wb_dat_o, n14352, 
            n14343, n11958, n12153, wb_stb_o, n12812, int_clk_out_enable_39, 
            \wb_adr_o[4] , \wb_adr_o[5] , wb_we_o, n13180, int_clk_out_enable_15, 
            bus_addressed, stm_fpga_spare5_c, wb_ack_i, n14325, n14384, 
            int_clk_out_enable_134, int_clk_out_enable_136, int_clk_out_enable_141, 
            int_clk_out_enable_129, int_clk_out_enable_143, int_clk_out_enable_122, 
            GND_net, VCC_net, wb_dat_i, int_clk_out_enable_111, \state_reg[0] , 
            n13400, sda_i_reg, n14324, mode_read_reg, fpga_scl_in, 
            fpga_sda_in, fpga_scl_out, n13402, fpga_sda_out, n12584, 
            \tx_lvds_test_pattern_31__N_119[25] , int_clk_out_enable_62, 
            int_clk_out_enable_28, int_clk_out_enable_114, int_clk_out_enable_46, 
            int_clk_out_enable_69, int_clk_out_enable_150, led_rst, fpga_led_N_383, 
            int_clk_out_enable_121, \tx_lvds_test_pattern_31__N_119[6] , 
            int_clk_out_enable_53, \tx_lvds_test_pattern_31__N_119[26] , 
            int_clk_out_enable_27, int_clk_out_enable_164, int_clk_out_enable_171, 
            int_clk_out_enable_106, \ufl_p7_sel_7__N_35[0] , n12964, n12966, 
            int_clk_out_enable_212, int_clk_out_enable_128, int_clk_out_enable_84, 
            int_clk_out_enable_76, \tx_lvds_test_pattern_31__N_119[31] , 
            int_clk_out_enable_98, \tx_lvds_test_pattern_31__N_119[27] , 
            \spi3_test_pattern_15__N_83[13] , \tx_lvds_test_pattern_31__N_119[28] , 
            n14299, n13324) /* synthesis syn_module_defined=1 */ ;
    output n13302;
    output int_clk_out_enable_99;
    output [15:0]wb_adr_o;
    input int_clk_out;
    output \wb_adr_o[7] ;
    output n14356;
    output \wb_adr_o[2] ;
    output \wb_adr_o[6] ;
    output \wb_adr_o[0] ;
    output \wb_adr_o[3] ;
    input \ufl_p8_sel[7] ;
    input \reg2[7] ;
    output n14056;
    input \ufl_p8_sel[5] ;
    input \reg2[5] ;
    output n14019;
    input \ufl_p8_sel[6] ;
    input \reg2[6] ;
    output n14029;
    input \ufl_p8_sel[4] ;
    input \reg2[4] ;
    output n14002;
    input \reg2[2] ;
    output n2797;
    output n11601;
    input n12798;
    output int_clk_out_enable_54;
    output int_clk_out_enable_55;
    input n14330;
    output int_clk_out_enable_77;
    output n12168;
    input n11664;
    output n12618;
    output n14354;
    input n9012;
    input n13044;
    input n14351;
    output int_clk_out_enable_107;
    output int_clk_out_enable_83;
    output [7:0]wb_dat_o;
    output n14352;
    output n14343;
    output n11958;
    output n12153;
    output wb_stb_o;
    input n12812;
    output int_clk_out_enable_39;
    output \wb_adr_o[4] ;
    output \wb_adr_o[5] ;
    output wb_we_o;
    input n13180;
    output int_clk_out_enable_15;
    output bus_addressed;
    input stm_fpga_spare5_c;
    input wb_ack_i;
    output n14325;
    output n14384;
    output int_clk_out_enable_134;
    output int_clk_out_enable_136;
    output int_clk_out_enable_141;
    output int_clk_out_enable_129;
    output int_clk_out_enable_143;
    output int_clk_out_enable_122;
    input GND_net;
    input VCC_net;
    input [7:0]wb_dat_i;
    output int_clk_out_enable_111;
    output \state_reg[0] ;
    input n13400;
    output sda_i_reg;
    output n14324;
    output mode_read_reg;
    input fpga_scl_in;
    input fpga_sda_in;
    output fpga_scl_out;
    input n13402;
    output fpga_sda_out;
    output n12584;
    output \tx_lvds_test_pattern_31__N_119[25] ;
    output int_clk_out_enable_62;
    output int_clk_out_enable_28;
    output int_clk_out_enable_114;
    output int_clk_out_enable_46;
    output int_clk_out_enable_69;
    output int_clk_out_enable_150;
    input led_rst;
    output fpga_led_N_383;
    output int_clk_out_enable_121;
    output \tx_lvds_test_pattern_31__N_119[6] ;
    output int_clk_out_enable_53;
    output \tx_lvds_test_pattern_31__N_119[26] ;
    output int_clk_out_enable_27;
    output int_clk_out_enable_164;
    output int_clk_out_enable_171;
    output int_clk_out_enable_106;
    output \ufl_p7_sel_7__N_35[0] ;
    input n12964;
    input n12966;
    output int_clk_out_enable_212;
    output int_clk_out_enable_128;
    output int_clk_out_enable_84;
    output int_clk_out_enable_76;
    output \tx_lvds_test_pattern_31__N_119[31] ;
    output int_clk_out_enable_98;
    output \tx_lvds_test_pattern_31__N_119[27] ;
    output \spi3_test_pattern_15__N_83[13] ;
    output \tx_lvds_test_pattern_31__N_119[28] ;
    output n14299;
    output n13324;
    
    wire int_clk_out /* synthesis DSPPORT_20=CLK3, CLOCK_NET_FOR_BUS20=20, is_clock=1, SET_AS_NETWORK=int_clk_out */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(76[6:17])
    wire VCC_net /* synthesis CE_NET_FOR_BUS20=20, DSPPORT_20=CE3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(26[14:27])
    wire fpga_led_N_383 /* synthesis DSPPORT_20=RST3, RESET_NET_FOR_BUS20=20 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(2[14:22])
    
    wire n12984, n14383, n13014;
    wire [15:0]wb_adr_o_c;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(190[13:21])
    
    wire n13008;
    wire [7:0]count_reg;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(229[11:20])
    
    wire int_clk_out_enable_157, n14412, n13176, n3, n13354, last_cycle_reg, 
        int_clk_out_enable_12, data_out_last, n12648;
    wire [7:0]n1521;
    
    wire n12071, n14371, n12291, n6551, n13246, n11558, n14291, 
        n12822, n14350, n13362, n12994, n14377, n12612, n12606, 
        n13056, n13030, n13300;
    wire [31:0]n550;
    
    wire n14277, n3934, n14276, n11253, data_out_ready_next, n14319, 
        n14382, n12978, int_clk_out_enable_178, n3914, n12972, n14386, 
        n13286, n7342, data_in_valid_reg, n12324, n14339, n12212, 
        n14298, n5080, data_out_ready_reg, wb_stb_o_next, n7320, n12878, 
        n12886, n13358, n14353, n13350, n14332, n14272;
    wire [7:0]n3925;
    wire [7:0]data_in_reg;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(242[11:22])
    
    wire n2323, n7338, n13182, data_out_valid, n11557, n14342, int_clk_out_enable_202, 
        int_clk_out_enable_38, n4894;
    wire [15:0]n69;
    
    wire n11149;
    wire [7:0]n3935;
    
    wire n11183;
    wire [7:0]n3915;
    
    wire n13214, n14376, n11, n14328, n13212, n14378, n14327;
    wire [7:0]data_out;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(246[12:20])
    wire [7:0]data_next_7__N_737;
    
    wire n11604, n14385, n14331, n6568, n14333, n3913, n3912, 
        n3911, n3910, n3909, n3908, n3907, n5087, n5085, n5083, 
        n12054, n5053, n14387, n13360, n14344, n4964, n12842, 
        n13294, n12850, n14388, n13098, n3863, n3866, n3893, n12588, 
        n10838, n10804, n10802, n10837, n10792, n10790, n10836, 
        n10812, n10810, n10835, n10800, n10814, n10834, n10833, 
        n10832, n10831, int_clk_out_enable_210, n7341, n14278, data_in_ready, 
        n7340, n7339, n13090, n14340, n14307, n12856, n14275, 
        n14317, n14411, n14410, n14300, n13310, n13382, n11566, 
        n12632, n13334, n14336, n14335, n12728, n7337, n7336, 
        n14267, n16, n11568, n12874, n1554, n13196, n14303, n13188, 
        n5052, n13068, n14281, n16_adj_1179, n12456, n14334, n12450, 
        n14301;
    
    LUT4 i1_4_lut (.A(n13302), .B(n12984), .C(n14383), .D(n13014), .Z(int_clk_out_enable_99)) /* synthesis lut_function=(!(A+((C+!(D))+!B))) */ ;
    defparam i1_4_lut.init = 16'h0400;
    LUT4 i1_4_lut_adj_119 (.A(wb_adr_o[1]), .B(wb_adr_o[8]), .C(wb_adr_o_c[13]), 
         .D(n13008), .Z(n13014)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i1_4_lut_adj_119.init = 16'h0100;
    FD1P3AX count_reg_i0_i0 (.D(n14412), .SP(int_clk_out_enable_157), .CK(int_clk_out), 
            .Q(count_reg[0])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam count_reg_i0_i0.GSR = "DISABLED";
    LUT4 i10281_2_lut_rep_272 (.A(wb_adr_o[8]), .B(\wb_adr_o[7] ), .Z(n14356)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i10281_2_lut_rep_272.init = 16'heeee;
    LUT4 i1_3_lut_4_lut (.A(wb_adr_o[8]), .B(\wb_adr_o[7] ), .C(\wb_adr_o[2] ), 
         .D(\wb_adr_o[6] ), .Z(n13176)) /* synthesis lut_function=(!(A+(B+((D)+!C)))) */ ;
    defparam i1_3_lut_4_lut.init = 16'h0010;
    LUT4 i1_2_lut (.A(count_reg[0]), .B(count_reg[1]), .Z(n3)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(301[17:44])
    defparam i1_2_lut.init = 16'heeee;
    LUT4 i1_3_lut (.A(\wb_adr_o[2] ), .B(\wb_adr_o[0] ), .C(\wb_adr_o[3] ), 
         .Z(n13008)) /* synthesis lut_function=(A (B (C))) */ ;
    defparam i1_3_lut.init = 16'h8080;
    LUT4 reg0_7__bdd_4_lut_4_lut (.A(\wb_adr_o[0] ), .B(\ufl_p8_sel[7] ), 
         .C(\reg2[7] ), .D(\wb_adr_o[2] ), .Z(n14056)) /* synthesis lut_function=(!(A+!(B (C+(D))+!B !((D)+!C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam reg0_7__bdd_4_lut_4_lut.init = 16'h4450;
    LUT4 reg0_5__bdd_4_lut_4_lut (.A(\wb_adr_o[0] ), .B(\ufl_p8_sel[5] ), 
         .C(\reg2[5] ), .D(\wb_adr_o[2] ), .Z(n14019)) /* synthesis lut_function=(!(A+!(B (C+(D))+!B !((D)+!C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam reg0_5__bdd_4_lut_4_lut.init = 16'h4450;
    LUT4 reg0_6__bdd_4_lut_4_lut (.A(\wb_adr_o[0] ), .B(\ufl_p8_sel[6] ), 
         .C(\reg2[6] ), .D(\wb_adr_o[2] ), .Z(n14029)) /* synthesis lut_function=(!(A+!(B (C+(D))+!B !((D)+!C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam reg0_6__bdd_4_lut_4_lut.init = 16'h4450;
    LUT4 reg0_4__bdd_4_lut_4_lut (.A(\wb_adr_o[0] ), .B(\ufl_p8_sel[4] ), 
         .C(\reg2[4] ), .D(\wb_adr_o[2] ), .Z(n14002)) /* synthesis lut_function=(!(A+!(B (C+(D))+!B !((D)+!C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam reg0_4__bdd_4_lut_4_lut.init = 16'h4450;
    LUT4 i6178_2_lut_2_lut (.A(\wb_adr_o[0] ), .B(\reg2[2] ), .Z(n2797)) /* synthesis lut_function=(!(A+!(B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam i6178_2_lut_2_lut.init = 16'h4444;
    LUT4 i1_4_lut_adj_120 (.A(n11601), .B(n12798), .C(n13302), .D(n13354), 
         .Z(int_clk_out_enable_54)) /* synthesis lut_function=(!(((C+(D))+!B)+!A)) */ ;
    defparam i1_4_lut_adj_120.init = 16'h0008;
    FD1P3AX last_cycle_reg_137 (.D(data_out_last), .SP(int_clk_out_enable_12), 
            .CK(int_clk_out), .Q(last_cycle_reg)) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam last_cycle_reg_137.GSR = "DISABLED";
    LUT4 i1_4_lut_adj_121 (.A(n12648), .B(n1521[3]), .C(n12071), .D(n14371), 
         .Z(n12291)) /* synthesis lut_function=(A+(B (C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i1_4_lut_adj_121.init = 16'heeea;
    LUT4 i1_4_lut_adj_122 (.A(n6551), .B(n13246), .C(n11558), .D(int_clk_out_enable_12), 
         .Z(n12648)) /* synthesis lut_function=(A+(B (C+(D))+!B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i1_4_lut_adj_122.init = 16'hfefa;
    LUT4 i1_4_lut_adj_123 (.A(n13302), .B(n11601), .C(n14291), .D(n12822), 
         .Z(int_clk_out_enable_55)) /* synthesis lut_function=(!(A+!(B (C (D))))) */ ;
    defparam i1_4_lut_adj_123.init = 16'h4000;
    LUT4 i1_4_lut_adj_124 (.A(n14383), .B(wb_adr_o_c[13]), .C(wb_adr_o[8]), 
         .D(n14350), .Z(n12822)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i1_4_lut_adj_124.init = 16'h0100;
    LUT4 i1_4_lut_adj_125 (.A(n13362), .B(n14330), .C(n12994), .D(\wb_adr_o[0] ), 
         .Z(int_clk_out_enable_77)) /* synthesis lut_function=(!(A+(((D)+!C)+!B))) */ ;
    defparam i1_4_lut_adj_125.init = 16'h0040;
    LUT4 i1_2_lut_adj_126 (.A(n1521[1]), .B(data_out_last), .Z(n13246)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i1_2_lut_adj_126.init = 16'h8888;
    LUT4 i1_4_lut_adj_127 (.A(wb_adr_o[8]), .B(wb_adr_o_c[13]), .C(n14377), 
         .D(\wb_adr_o[2] ), .Z(n12994)) /* synthesis lut_function=(!(A+(B+!(C (D))))) */ ;
    defparam i1_4_lut_adj_127.init = 16'h1000;
    LUT4 i1_2_lut_rep_266 (.A(\wb_adr_o[0] ), .B(wb_adr_o[1]), .Z(n14350)) /* synthesis lut_function=(A (B)) */ ;
    defparam i1_2_lut_rep_266.init = 16'h8888;
    LUT4 i6045_rep_47_2_lut_3_lut (.A(\wb_adr_o[0] ), .B(wb_adr_o[1]), .C(\wb_adr_o[2] ), 
         .Z(n12168)) /* synthesis lut_function=(A (B (C))) */ ;
    defparam i6045_rep_47_2_lut_3_lut.init = 16'h8080;
    LUT4 i1_4_lut_adj_128 (.A(n11664), .B(n12612), .C(n12606), .D(\wb_adr_o[0] ), 
         .Z(n12618)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_adj_128.init = 16'hfffe;
    LUT4 i1_4_lut_adj_129 (.A(n14354), .B(n9012), .C(n13044), .D(n14351), 
         .Z(n13056)) /* synthesis lut_function=(!(A+(B+!(C (D))))) */ ;
    defparam i1_4_lut_adj_129.init = 16'h1000;
    LUT4 i1_4_lut_adj_130 (.A(n13362), .B(n13030), .C(n14330), .D(n13300), 
         .Z(int_clk_out_enable_107)) /* synthesis lut_function=(!(A+(((D)+!C)+!B))) */ ;
    defparam i1_4_lut_adj_130.init = 16'h0040;
    LUT4 i11_4_lut (.A(n550[1]), .B(n14277), .C(n3934), .D(n14276), 
         .Z(n11253)) /* synthesis lut_function=(A (B (C))+!A !(C+!(D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i11_4_lut.init = 16'h8580;
    LUT4 i1454_2_lut (.A(count_reg[1]), .B(count_reg[0]), .Z(n550[1])) /* synthesis lut_function=(!(A (B)+!A !(B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(377[30:43])
    defparam i1454_2_lut.init = 16'h6666;
    LUT4 i1123_2_lut (.A(n1521[3]), .B(n1521[4]), .Z(n3934)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1123_2_lut.init = 16'heeee;
    LUT4 i1_2_lut_adj_131 (.A(n1521[1]), .B(n1521[4]), .Z(data_out_ready_next)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut_adj_131.init = 16'heeee;
    LUT4 i1_4_lut_adj_132 (.A(n14319), .B(n12984), .C(n14382), .D(n12978), 
         .Z(int_clk_out_enable_83)) /* synthesis lut_function=(!(A+((C+!(D))+!B))) */ ;
    defparam i1_4_lut_adj_132.init = 16'h0400;
    FD1P3AX data_reg_i0_i0 (.D(n3914), .SP(int_clk_out_enable_178), .CK(int_clk_out), 
            .Q(wb_dat_o[0])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam data_reg_i0_i0.GSR = "DISABLED";
    LUT4 i1_4_lut_adj_133 (.A(wb_adr_o_c[13]), .B(wb_adr_o[8]), .C(n12972), 
         .D(n14377), .Z(n12978)) /* synthesis lut_function=(!(A+(B+!(C (D))))) */ ;
    defparam i1_4_lut_adj_133.init = 16'h1000;
    LUT4 i1_2_lut_adj_134 (.A(\wb_adr_o[0] ), .B(\wb_adr_o[2] ), .Z(n12972)) /* synthesis lut_function=(A (B)) */ ;
    defparam i1_2_lut_adj_134.init = 16'h8888;
    LUT4 i8677_2_lut_rep_268 (.A(wb_adr_o_c[9]), .B(wb_adr_o_c[14]), .Z(n14352)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i8677_2_lut_rep_268.init = 16'heeee;
    FD1S3JX state_reg_FSM_i1 (.D(n12291), .CK(int_clk_out), .PD(n14343), 
            .Q(n1521[0]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam state_reg_FSM_i1.GSR = "DISABLED";
    LUT4 i10295_2_lut_3_lut_4_lut (.A(wb_adr_o_c[9]), .B(wb_adr_o_c[14]), 
         .C(n14386), .D(n14383), .Z(n13286)) /* synthesis lut_function=(A+(B+((D)+!C))) */ ;
    defparam i10295_2_lut_3_lut_4_lut.init = 16'hffef;
    LUT4 i4378_1_lut (.A(wb_dat_o[7]), .Z(n7342)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam i4378_1_lut.init = 16'h5555;
    FD1S3IX data_in_valid_reg_146 (.D(n14339), .CK(int_clk_out), .CD(n12324), 
            .Q(data_in_valid_reg)) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam data_in_valid_reg_146.GSR = "DISABLED";
    LUT4 i10373_3_lut_4_lut (.A(wb_adr_o_c[9]), .B(wb_adr_o_c[14]), .C(wb_adr_o[8]), 
         .D(n11958), .Z(n12153)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i10373_3_lut_4_lut.init = 16'hfffe;
    LUT4 i1_3_lut_4_lut_adj_135 (.A(wb_adr_o_c[9]), .B(wb_adr_o_c[14]), 
         .C(wb_adr_o[8]), .D(\wb_adr_o[6] ), .Z(n12212)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_3_lut_4_lut_adj_135.init = 16'hfffe;
    LUT4 i2215_2_lut_4_lut (.A(int_clk_out_enable_12), .B(data_out_last), 
         .C(n14298), .D(n1521[4]), .Z(n5080)) /* synthesis lut_function=(!(A (B+!(C (D)))+!A !(D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(320[26] 327[20])
    defparam i2215_2_lut_4_lut.init = 16'h7500;
    FD1S3IX data_out_ready_reg_147 (.D(data_out_ready_next), .CK(int_clk_out), 
            .CD(n14343), .Q(data_out_ready_reg)) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam data_out_ready_reg_147.GSR = "DISABLED";
    FD1S3IX wb_stb_o_reg_142 (.D(wb_stb_o_next), .CK(int_clk_out), .CD(n14343), 
            .Q(wb_stb_o)) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam wb_stb_o_reg_142.GSR = "DISABLED";
    LUT4 i4356_1_lut (.A(wb_dat_o[0]), .Z(n7320)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam i4356_1_lut.init = 16'h5555;
    LUT4 i1_4_lut_adj_136 (.A(n14382), .B(n14330), .C(n12878), .D(wb_adr_o[8]), 
         .Z(n12886)) /* synthesis lut_function=(!(A+(((D)+!C)+!B))) */ ;
    defparam i1_4_lut_adj_136.init = 16'h0040;
    LUT4 i1_2_lut_adj_137 (.A(wb_adr_o_c[13]), .B(\wb_adr_o[2] ), .Z(n12878)) /* synthesis lut_function=(!(A+!(B))) */ ;
    defparam i1_2_lut_adj_137.init = 16'h4444;
    LUT4 i1_2_lut_3_lut (.A(wb_adr_o_c[13]), .B(wb_adr_o[8]), .C(wb_adr_o[1]), 
         .Z(n12606)) /* synthesis lut_function=(A+(B+(C))) */ ;
    defparam i1_2_lut_3_lut.init = 16'hfefe;
    LUT4 i10367_3_lut_4_lut (.A(wb_adr_o_c[9]), .B(wb_adr_o_c[14]), .C(wb_adr_o[8]), 
         .D(wb_adr_o[1]), .Z(n13358)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i10367_3_lut_4_lut.init = 16'hfffe;
    LUT4 i1_2_lut_3_lut_adj_138 (.A(wb_adr_o_c[9]), .B(wb_adr_o_c[14]), 
         .C(\wb_adr_o[3] ), .Z(n12612)) /* synthesis lut_function=(A+(B+!(C))) */ ;
    defparam i1_2_lut_3_lut_adj_138.init = 16'hefef;
    LUT4 i1_4_lut_adj_139 (.A(n11601), .B(n12812), .C(n13354), .D(n14330), 
         .Z(int_clk_out_enable_39)) /* synthesis lut_function=(!(((C+!(D))+!B)+!A)) */ ;
    defparam i1_4_lut_adj_139.init = 16'h0800;
    LUT4 i2_2_lut_rep_269 (.A(wb_adr_o_c[11]), .B(wb_adr_o_c[12]), .Z(n14353)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i2_2_lut_rep_269.init = 16'heeee;
    LUT4 i10359_3_lut_4_lut (.A(wb_adr_o_c[11]), .B(wb_adr_o_c[12]), .C(\wb_adr_o[4] ), 
         .D(\wb_adr_o[2] ), .Z(n13350)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i10359_3_lut_4_lut.init = 16'hfffe;
    LUT4 i120_2_lut_rep_270 (.A(\wb_adr_o[5] ), .B(\wb_adr_o[3] ), .Z(n14354)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i120_2_lut_rep_270.init = 16'heeee;
    LUT4 i1_2_lut_3_lut_adj_140 (.A(\wb_adr_o[5] ), .B(\wb_adr_o[3] ), .C(\wb_adr_o[4] ), 
         .Z(n11601)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;
    defparam i1_2_lut_3_lut_adj_140.init = 16'h1010;
    LUT4 i1_2_lut_rep_248_3_lut_4_lut (.A(\wb_adr_o[5] ), .B(\wb_adr_o[3] ), 
         .C(wb_we_o), .D(wb_stb_o), .Z(n14332)) /* synthesis lut_function=(!(A+(B+!(C (D))))) */ ;
    defparam i1_2_lut_rep_248_3_lut_4_lut.init = 16'h1000;
    LUT4 i6201_3_lut_4_lut (.A(count_reg[5]), .B(n14272), .C(n14277), 
         .D(count_reg[6]), .Z(n3925[6])) /* synthesis lut_function=(!(A (B ((D)+!C)+!B !(C (D)))+!A !(C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(377[30:43])
    defparam i6201_3_lut_4_lut.init = 16'h7080;
    FD1S3IX data_in_reg__i7 (.D(n2323), .CK(int_clk_out), .CD(n7342), 
            .Q(data_in_reg[7])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam data_in_reg__i7.GSR = "DISABLED";
    LUT4 i4374_1_lut (.A(wb_dat_o[3]), .Z(n7338)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam i4374_1_lut.init = 16'h5555;
    LUT4 i1_4_lut_adj_141 (.A(n13180), .B(n11958), .C(n13182), .D(n14354), 
         .Z(int_clk_out_enable_15)) /* synthesis lut_function=(!((B+((D)+!C))+!A)) */ ;
    defparam i1_4_lut_adj_141.init = 16'h0020;
    LUT4 data_out_valid_I_0_2_lut_rep_287 (.A(data_out_valid), .B(bus_addressed), 
         .Z(n14371)) /* synthesis lut_function=(A+!(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(351[17:48])
    defparam data_out_valid_I_0_2_lut_rep_287.init = 16'hbbbb;
    LUT4 i1_3_lut_4_lut_adj_142 (.A(data_out_valid), .B(bus_addressed), 
         .C(stm_fpga_spare5_c), .D(n1521[3]), .Z(n12324)) /* synthesis lut_function=(A+!(B (C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(351[17:48])
    defparam i1_3_lut_4_lut_adj_142.init = 16'hbfff;
    LUT4 i1_2_lut_3_lut_adj_143 (.A(n1521[5]), .B(wb_ack_i), .C(last_cycle_reg), 
         .Z(n11558)) /* synthesis lut_function=(A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i1_2_lut_3_lut_adj_143.init = 16'h8080;
    LUT4 i1_2_lut_3_lut_adj_144 (.A(n1521[5]), .B(wb_ack_i), .C(last_cycle_reg), 
         .Z(n11557)) /* synthesis lut_function=(!(((C)+!B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i1_2_lut_3_lut_adj_144.init = 16'h0808;
    FD1S3IX data_in_reg__i0 (.D(n2323), .CK(int_clk_out), .CD(n7320), 
            .Q(data_in_reg[0])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam data_in_reg__i0.GSR = "DISABLED";
    LUT4 i1_3_lut_4_lut_adj_145 (.A(int_clk_out_enable_12), .B(n1521[1]), 
         .C(n14342), .D(n3), .Z(int_clk_out_enable_202)) /* synthesis lut_function=(A (B (C+!(D))+!B (C))+!A (C)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i1_3_lut_4_lut_adj_145.init = 16'hf0f8;
    FD1P3AX wb_we_o_reg_140 (.D(n4894), .SP(int_clk_out_enable_38), .CK(int_clk_out), 
            .Q(wb_we_o)) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam wb_we_o_reg_140.GSR = "DISABLED";
    FD1P3AX addr_reg_1305__i0 (.D(n69[0]), .SP(int_clk_out_enable_202), 
            .CK(int_clk_out), .Q(\wb_adr_o[0] )) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305__i0.GSR = "DISABLED";
    LUT4 i1_4_lut_adj_146 (.A(wb_adr_o[1]), .B(n13176), .C(\wb_adr_o[0] ), 
         .D(\wb_adr_o[4] ), .Z(n13182)) /* synthesis lut_function=(!(A+((C+(D))+!B))) */ ;
    defparam i1_4_lut_adj_146.init = 16'h0004;
    FD1P3AX count_reg_i0_i7 (.D(n11149), .SP(int_clk_out_enable_157), .CK(int_clk_out), 
            .Q(count_reg[7])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam count_reg_i0_i7.GSR = "DISABLED";
    FD1P3AX count_reg_i0_i6 (.D(n3935[6]), .SP(int_clk_out_enable_157), 
            .CK(int_clk_out), .Q(count_reg[6])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam count_reg_i0_i6.GSR = "DISABLED";
    FD1P3AX count_reg_i0_i5 (.D(n3935[5]), .SP(int_clk_out_enable_157), 
            .CK(int_clk_out), .Q(count_reg[5])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam count_reg_i0_i5.GSR = "DISABLED";
    FD1P3AX count_reg_i0_i4 (.D(n11183), .SP(int_clk_out_enable_157), .CK(int_clk_out), 
            .Q(count_reg[4])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam count_reg_i0_i4.GSR = "DISABLED";
    FD1P3AX count_reg_i0_i3 (.D(n3935[3]), .SP(int_clk_out_enable_157), 
            .CK(int_clk_out), .Q(count_reg[3])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam count_reg_i0_i3.GSR = "DISABLED";
    FD1P3AX count_reg_i0_i2 (.D(n3935[2]), .SP(int_clk_out_enable_157), 
            .CK(int_clk_out), .Q(count_reg[2])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam count_reg_i0_i2.GSR = "DISABLED";
    FD1P3AX count_reg_i0_i1 (.D(n11253), .SP(int_clk_out_enable_157), .CK(int_clk_out), 
            .Q(count_reg[1])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam count_reg_i0_i1.GSR = "DISABLED";
    LUT4 i1_3_lut_4_lut_adj_147 (.A(n1521[1]), .B(n14298), .C(n3), .D(count_reg[2]), 
         .Z(n3915[2])) /* synthesis lut_function=(A (B (C (D)+!C !(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i1_3_lut_4_lut_adj_147.init = 16'h8008;
    LUT4 i1_3_lut_4_lut_adj_148 (.A(count_reg[1]), .B(count_reg[2]), .C(count_reg[4]), 
         .D(count_reg[3]), .Z(n13214)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(301[17:44])
    defparam i1_3_lut_4_lut_adj_148.init = 16'hfffe;
    LUT4 i1_3_lut_rep_193 (.A(n14298), .B(n1521[4]), .C(data_out_last), 
         .Z(n14277)) /* synthesis lut_function=(!((B (C))+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i1_3_lut_rep_193.init = 16'h2a2a;
    LUT4 i2_2_lut_rep_292 (.A(count_reg[5]), .B(count_reg[6]), .Z(n14376)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(303[21:35])
    defparam i2_2_lut_rep_292.init = 16'heeee;
    LUT4 i10339_2_lut_rep_244_3_lut (.A(count_reg[5]), .B(count_reg[6]), 
         .C(n11), .Z(n14328)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(303[21:35])
    defparam i10339_2_lut_rep_244_3_lut.init = 16'hfefe;
    LUT4 i1_2_lut_3_lut_adj_149 (.A(count_reg[5]), .B(count_reg[6]), .C(count_reg[0]), 
         .Z(n13212)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(303[21:35])
    defparam i1_2_lut_3_lut_adj_149.init = 16'hfefe;
    LUT4 i1_2_lut_rep_293 (.A(wb_adr_o[1]), .B(\wb_adr_o[3] ), .Z(n14377)) /* synthesis lut_function=(A (B)) */ ;
    defparam i1_2_lut_rep_293.init = 16'h8888;
    LUT4 i1_3_lut_4_lut_adj_150 (.A(wb_adr_o[1]), .B(\wb_adr_o[3] ), .C(wb_adr_o[8]), 
         .D(\wb_adr_o[0] ), .Z(n13030)) /* synthesis lut_function=(!(((C+(D))+!B)+!A)) */ ;
    defparam i1_3_lut_4_lut_adj_150.init = 16'h0008;
    LUT4 i1_2_lut_rep_294 (.A(count_reg[1]), .B(count_reg[3]), .Z(n14378)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(301[17:44])
    defparam i1_2_lut_rep_294.init = 16'heeee;
    LUT4 i1_2_lut_rep_243_3_lut (.A(count_reg[1]), .B(count_reg[3]), .C(count_reg[0]), 
         .Z(n14327)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(301[17:44])
    defparam i1_2_lut_rep_243_3_lut.init = 16'hfefe;
    LUT4 mux_76_i1_3_lut (.A(data_out[0]), .B(wb_dat_o[0]), .C(count_reg[0]), 
         .Z(data_next_7__N_737[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(376[17:26])
    defparam mux_76_i1_3_lut.init = 16'hcaca;
    LUT4 i8699_2_lut_rep_298 (.A(wb_adr_o_c[15]), .B(wb_adr_o_c[11]), .Z(n14382)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i8699_2_lut_rep_298.init = 16'heeee;
    LUT4 i10311_2_lut_3_lut_4_lut (.A(wb_adr_o_c[15]), .B(wb_adr_o_c[11]), 
         .C(wb_adr_o_c[14]), .D(wb_adr_o_c[9]), .Z(n13302)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i10311_2_lut_3_lut_4_lut.init = 16'hfffe;
    LUT4 i8703_2_lut_rep_299 (.A(wb_adr_o_c[10]), .B(wb_adr_o_c[12]), .Z(n14383)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i8703_2_lut_rep_299.init = 16'heeee;
    LUT4 i10277_2_lut_rep_235_3_lut_4_lut (.A(wb_adr_o_c[10]), .B(wb_adr_o_c[12]), 
         .C(wb_adr_o_c[14]), .D(wb_adr_o_c[9]), .Z(n14319)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i10277_2_lut_rep_235_3_lut_4_lut.init = 16'hfffe;
    LUT4 i10363_2_lut_3_lut_4_lut (.A(wb_adr_o_c[10]), .B(wb_adr_o_c[12]), 
         .C(wb_adr_o[8]), .D(wb_adr_o_c[13]), .Z(n13354)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i10363_2_lut_3_lut_4_lut.init = 16'hfffe;
    LUT4 i10325_2_lut_rep_241_3_lut_4_lut (.A(wb_adr_o_c[10]), .B(wb_adr_o_c[12]), 
         .C(wb_adr_o_c[11]), .D(wb_adr_o_c[15]), .Z(n14325)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i10325_2_lut_rep_241_3_lut_4_lut.init = 16'hfffe;
    LUT4 i1_4_lut_adj_151 (.A(wb_adr_o_c[10]), .B(n14353), .C(wb_adr_o_c[15]), 
         .D(wb_adr_o_c[13]), .Z(n11958)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_adj_151.init = 16'hfffe;
    LUT4 i1_2_lut_rep_300 (.A(wb_adr_o[1]), .B(\wb_adr_o[0] ), .Z(n14384)) /* synthesis lut_function=(!((B)+!A)) */ ;
    defparam i1_2_lut_rep_300.init = 16'h2222;
    LUT4 i1_2_lut_3_lut_3_lut_4_lut (.A(wb_adr_o[1]), .B(\wb_adr_o[0] ), 
         .C(n11604), .D(stm_fpga_spare5_c), .Z(int_clk_out_enable_134)) /* synthesis lut_function=(!(A (B (D)+!B !(C+!(D)))+!A (D))) */ ;
    defparam i1_2_lut_3_lut_3_lut_4_lut.init = 16'h20ff;
    LUT4 i1_2_lut_rep_195_3_lut (.A(wb_adr_o[1]), .B(\wb_adr_o[0] ), .C(n11604), 
         .Z(int_clk_out_enable_136)) /* synthesis lut_function=(!((B+!(C))+!A)) */ ;
    defparam i1_2_lut_rep_195_3_lut.init = 16'h2020;
    LUT4 i1_2_lut_rep_301 (.A(wb_adr_o[1]), .B(\wb_adr_o[0] ), .Z(n14385)) /* synthesis lut_function=(!(A+!(B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam i1_2_lut_rep_301.init = 16'h4444;
    LUT4 i1_2_lut_rep_247_3_lut (.A(wb_adr_o[1]), .B(\wb_adr_o[0] ), .C(\wb_adr_o[2] ), 
         .Z(n14331)) /* synthesis lut_function=(!(A+((C)+!B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam i1_2_lut_rep_247_3_lut.init = 16'h0404;
    LUT4 i1_2_lut_rep_196_3_lut (.A(wb_adr_o[1]), .B(\wb_adr_o[0] ), .C(n11604), 
         .Z(int_clk_out_enable_141)) /* synthesis lut_function=(!(A+!(B (C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam i1_2_lut_rep_196_3_lut.init = 16'h4040;
    LUT4 i1_2_lut_rep_187_3_lut_4_lut (.A(wb_adr_o[1]), .B(\wb_adr_o[0] ), 
         .C(n6568), .D(\wb_adr_o[2] ), .Z(int_clk_out_enable_129)) /* synthesis lut_function=(!(A+(((D)+!C)+!B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam i1_2_lut_rep_187_3_lut_4_lut.init = 16'h0040;
    LUT4 i1_2_lut_3_lut_3_lut_4_lut_adj_152 (.A(wb_adr_o[1]), .B(\wb_adr_o[0] ), 
         .C(n11604), .D(stm_fpga_spare5_c), .Z(int_clk_out_enable_143)) /* synthesis lut_function=(!(A (D)+!A !(B (C+!(D))+!B !(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam i1_2_lut_3_lut_3_lut_4_lut_adj_152.init = 16'h40ff;
    LUT4 i10732_2_lut_rep_302 (.A(\wb_adr_o[0] ), .B(wb_adr_o[1]), .Z(n14386)) /* synthesis lut_function=(!(A+(B))) */ ;
    defparam i10732_2_lut_rep_302.init = 16'h1111;
    LUT4 i1_2_lut_rep_207_3_lut_4_lut (.A(\wb_adr_o[0] ), .B(wb_adr_o[1]), 
         .C(n14330), .D(\wb_adr_o[2] ), .Z(n14291)) /* synthesis lut_function=(!(A ((D)+!C)+!A (B ((D)+!C)+!B !(C (D))))) */ ;
    defparam i1_2_lut_rep_207_3_lut_4_lut.init = 16'h10e0;
    LUT4 i6141_2_lut_rep_249_3_lut (.A(\wb_adr_o[0] ), .B(wb_adr_o[1]), 
         .C(\wb_adr_o[2] ), .Z(n14333)) /* synthesis lut_function=(A+(B+(C))) */ ;
    defparam i6141_2_lut_rep_249_3_lut.init = 16'hfefe;
    LUT4 i1_2_lut_rep_186_3_lut_4_lut (.A(\wb_adr_o[0] ), .B(wb_adr_o[1]), 
         .C(n6568), .D(\wb_adr_o[2] ), .Z(int_clk_out_enable_122)) /* synthesis lut_function=(!(A+(B+((D)+!C)))) */ ;
    defparam i1_2_lut_rep_186_3_lut_4_lut.init = 16'h0010;
    FD1P3AX data_reg_i0_i1 (.D(n3913), .SP(int_clk_out_enable_178), .CK(int_clk_out), 
            .Q(wb_dat_o[1])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam data_reg_i0_i1.GSR = "DISABLED";
    FD1P3AX data_reg_i0_i2 (.D(n3912), .SP(int_clk_out_enable_178), .CK(int_clk_out), 
            .Q(wb_dat_o[2])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam data_reg_i0_i2.GSR = "DISABLED";
    FD1P3AX data_reg_i0_i3 (.D(n3911), .SP(int_clk_out_enable_178), .CK(int_clk_out), 
            .Q(wb_dat_o[3])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam data_reg_i0_i3.GSR = "DISABLED";
    FD1P3AX data_reg_i0_i4 (.D(n3910), .SP(int_clk_out_enable_178), .CK(int_clk_out), 
            .Q(wb_dat_o[4])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam data_reg_i0_i4.GSR = "DISABLED";
    FD1P3AX data_reg_i0_i5 (.D(n3909), .SP(int_clk_out_enable_178), .CK(int_clk_out), 
            .Q(wb_dat_o[5])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam data_reg_i0_i5.GSR = "DISABLED";
    FD1P3AX data_reg_i0_i6 (.D(n3908), .SP(int_clk_out_enable_178), .CK(int_clk_out), 
            .Q(wb_dat_o[6])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam data_reg_i0_i6.GSR = "DISABLED";
    FD1P3AX data_reg_i0_i7 (.D(n3907), .SP(int_clk_out_enable_178), .CK(int_clk_out), 
            .Q(wb_dat_o[7])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam data_reg_i0_i7.GSR = "DISABLED";
    FD1S3IX state_reg_FSM_i2 (.D(n5087), .CK(int_clk_out), .CD(n14343), 
            .Q(n1521[1]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam state_reg_FSM_i2.GSR = "DISABLED";
    FD1S3IX state_reg_FSM_i3 (.D(n5085), .CK(int_clk_out), .CD(n14343), 
            .Q(n1521[2]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam state_reg_FSM_i3.GSR = "DISABLED";
    FD1S3IX state_reg_FSM_i4 (.D(n5083), .CK(int_clk_out), .CD(n14343), 
            .Q(n1521[3]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam state_reg_FSM_i4.GSR = "DISABLED";
    FD1S3IX state_reg_FSM_i5 (.D(n12054), .CK(int_clk_out), .CD(n14343), 
            .Q(n1521[4]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam state_reg_FSM_i5.GSR = "DISABLED";
    FD1S3IX state_reg_FSM_i6 (.D(n5053), .CK(int_clk_out), .CD(n14343), 
            .Q(n1521[5]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam state_reg_FSM_i6.GSR = "DISABLED";
    LUT4 i10321_2_lut_rep_303 (.A(wb_adr_o_c[10]), .B(wb_adr_o_c[15]), .Z(n14387)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i10321_2_lut_rep_303.init = 16'heeee;
    LUT4 i10369_2_lut_3_lut (.A(wb_adr_o_c[10]), .B(wb_adr_o_c[15]), .C(\wb_adr_o[4] ), 
         .Z(n13360)) /* synthesis lut_function=(A+(B+(C))) */ ;
    defparam i10369_2_lut_3_lut.init = 16'hfefe;
    LUT4 i2109_3_lut_4_lut (.A(n14344), .B(n14339), .C(n14342), .D(wb_ack_i), 
         .Z(n4964)) /* synthesis lut_function=(!(A (B (C (D))+!B ((D)+!C))+!A ((D)+!C))) */ ;
    defparam i2109_3_lut_4_lut.init = 16'h08f8;
    LUT4 i1_4_lut_adj_153 (.A(n12842), .B(n14353), .C(n13294), .D(wb_adr_o_c[13]), 
         .Z(n12850)) /* synthesis lut_function=(!((B+(C+(D)))+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam i1_4_lut_adj_153.init = 16'h0002;
    LUT4 i1_2_lut_rep_304 (.A(count_reg[3]), .B(count_reg[2]), .Z(n14388)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(301[17:44])
    defparam i1_2_lut_rep_304.init = 16'heeee;
    LUT4 i1_3_lut_4_lut_adj_154 (.A(count_reg[3]), .B(count_reg[2]), .C(count_reg[5]), 
         .D(count_reg[4]), .Z(n13098)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(301[17:44])
    defparam i1_3_lut_4_lut_adj_154.init = 16'hfffe;
    LUT4 i1_2_lut_adj_155 (.A(wb_adr_o_c[15]), .B(\wb_adr_o[4] ), .Z(n12842)) /* synthesis lut_function=(!(A+!(B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam i1_2_lut_adj_155.init = 16'h4444;
    FD1P3AX addr_reg_1305__i1 (.D(n69[1]), .SP(int_clk_out_enable_202), 
            .CK(int_clk_out), .Q(wb_adr_o[1])) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305__i1.GSR = "DISABLED";
    LUT4 i10677_4_lut (.A(n3863), .B(n3866), .C(n3893), .D(n12588), 
         .Z(int_clk_out_enable_157)) /* synthesis lut_function=(!(A+(B+(C+(D))))) */ ;
    defparam i10677_4_lut.init = 16'h0001;
    LUT4 i1_2_lut_4_lut (.A(\wb_adr_o[6] ), .B(\wb_adr_o[7] ), .C(n14351), 
         .D(n11664), .Z(n12984)) /* synthesis lut_function=(!(A+(B+((D)+!C)))) */ ;
    defparam i1_2_lut_4_lut.init = 16'h0010;
    LUT4 i10371_3_lut_4_lut (.A(n14382), .B(n14383), .C(n14352), .D(n11664), 
         .Z(n13362)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i10371_3_lut_4_lut.init = 16'hfffe;
    LUT4 i10389_3_lut_rep_214_4_lut (.A(n14378), .B(count_reg[0]), .C(n11), 
         .D(n14376), .Z(n14298)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(301[17:44])
    defparam i10389_3_lut_rep_214_4_lut.init = 16'hfffe;
    CCU2C addr_reg_1305_add_4_17 (.A0(n10804), .B0(n1521[5]), .C0(n1521[2]), 
          .D0(wb_adr_o_c[14]), .A1(n10802), .B1(n1521[5]), .C1(n1521[2]), 
          .D1(wb_adr_o_c[15]), .CIN(n10838), .S0(n69[14]), .S1(n69[15]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305_add_4_17.INIT0 = 16'h56aa;
    defparam addr_reg_1305_add_4_17.INIT1 = 16'h56aa;
    defparam addr_reg_1305_add_4_17.INJECT1_0 = "NO";
    defparam addr_reg_1305_add_4_17.INJECT1_1 = "NO";
    CCU2C addr_reg_1305_add_4_15 (.A0(n10792), .B0(n1521[5]), .C0(n1521[2]), 
          .D0(wb_adr_o_c[12]), .A1(n10790), .B1(n1521[5]), .C1(n1521[2]), 
          .D1(wb_adr_o_c[13]), .CIN(n10837), .COUT(n10838), .S0(n69[12]), 
          .S1(n69[13]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305_add_4_15.INIT0 = 16'h56aa;
    defparam addr_reg_1305_add_4_15.INIT1 = 16'h56aa;
    defparam addr_reg_1305_add_4_15.INJECT1_0 = "NO";
    defparam addr_reg_1305_add_4_15.INJECT1_1 = "NO";
    CCU2C addr_reg_1305_add_4_13 (.A0(n10812), .B0(n1521[5]), .C0(n1521[2]), 
          .D0(wb_adr_o_c[10]), .A1(n10810), .B1(n1521[5]), .C1(n1521[2]), 
          .D1(wb_adr_o_c[11]), .CIN(n10836), .COUT(n10837), .S0(n69[10]), 
          .S1(n69[11]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305_add_4_13.INIT0 = 16'h56aa;
    defparam addr_reg_1305_add_4_13.INIT1 = 16'h56aa;
    defparam addr_reg_1305_add_4_13.INJECT1_0 = "NO";
    defparam addr_reg_1305_add_4_13.INJECT1_1 = "NO";
    CCU2C addr_reg_1305_add_4_11 (.A0(n10800), .B0(n1521[5]), .C0(n1521[2]), 
          .D0(wb_adr_o[8]), .A1(n10814), .B1(n1521[5]), .C1(n1521[2]), 
          .D1(wb_adr_o_c[9]), .CIN(n10835), .COUT(n10836), .S0(n69[8]), 
          .S1(n69[9]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305_add_4_11.INIT0 = 16'h56aa;
    defparam addr_reg_1305_add_4_11.INIT1 = 16'h56aa;
    defparam addr_reg_1305_add_4_11.INJECT1_0 = "NO";
    defparam addr_reg_1305_add_4_11.INJECT1_1 = "NO";
    CCU2C addr_reg_1305_add_4_9 (.A0(n10804), .B0(n1521[5]), .C0(n1521[2]), 
          .D0(\wb_adr_o[6] ), .A1(n10802), .B1(n1521[5]), .C1(n1521[2]), 
          .D1(\wb_adr_o[7] ), .CIN(n10834), .COUT(n10835), .S0(n69[6]), 
          .S1(n69[7]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305_add_4_9.INIT0 = 16'h56aa;
    defparam addr_reg_1305_add_4_9.INIT1 = 16'h56aa;
    defparam addr_reg_1305_add_4_9.INJECT1_0 = "NO";
    defparam addr_reg_1305_add_4_9.INJECT1_1 = "NO";
    CCU2C addr_reg_1305_add_4_7 (.A0(n10792), .B0(n1521[5]), .C0(n1521[2]), 
          .D0(\wb_adr_o[4] ), .A1(n10790), .B1(n1521[5]), .C1(n1521[2]), 
          .D1(\wb_adr_o[5] ), .CIN(n10833), .COUT(n10834), .S0(n69[4]), 
          .S1(n69[5]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305_add_4_7.INIT0 = 16'h56aa;
    defparam addr_reg_1305_add_4_7.INIT1 = 16'h56aa;
    defparam addr_reg_1305_add_4_7.INJECT1_0 = "NO";
    defparam addr_reg_1305_add_4_7.INJECT1_1 = "NO";
    CCU2C addr_reg_1305_add_4_5 (.A0(n10812), .B0(n1521[5]), .C0(n1521[2]), 
          .D0(\wb_adr_o[2] ), .A1(n10810), .B1(n1521[5]), .C1(n1521[2]), 
          .D1(\wb_adr_o[3] ), .CIN(n10832), .COUT(n10833), .S0(n69[2]), 
          .S1(n69[3]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305_add_4_5.INIT0 = 16'h56aa;
    defparam addr_reg_1305_add_4_5.INIT1 = 16'h56aa;
    defparam addr_reg_1305_add_4_5.INJECT1_0 = "NO";
    defparam addr_reg_1305_add_4_5.INJECT1_1 = "NO";
    CCU2C addr_reg_1305_add_4_3 (.A0(\wb_adr_o[0] ), .B0(n14342), .C0(data_out[0]), 
          .D0(wb_ack_i), .A1(n10814), .B1(n1521[5]), .C1(n1521[2]), 
          .D1(wb_adr_o[1]), .CIN(n10831), .COUT(n10832), .S0(n69[0]), 
          .S1(n69[1]));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305_add_4_3.INIT0 = 16'h74b8;
    defparam addr_reg_1305_add_4_3.INIT1 = 16'h56aa;
    defparam addr_reg_1305_add_4_3.INJECT1_0 = "NO";
    defparam addr_reg_1305_add_4_3.INJECT1_1 = "NO";
    CCU2C addr_reg_1305_add_4_1 (.A0(GND_net), .B0(GND_net), .C0(GND_net), 
          .D0(VCC_net), .A1(n1521[2]), .B1(n1521[5]), .C1(GND_net), 
          .D1(VCC_net), .COUT(n10831));   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305_add_4_1.INIT0 = 16'h0000;
    defparam addr_reg_1305_add_4_1.INIT1 = 16'hfff0;
    defparam addr_reg_1305_add_4_1.INJECT1_0 = "NO";
    defparam addr_reg_1305_add_4_1.INJECT1_1 = "NO";
    FD1P3AX addr_reg_1305__i2 (.D(n69[2]), .SP(int_clk_out_enable_202), 
            .CK(int_clk_out), .Q(\wb_adr_o[2] )) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305__i2.GSR = "DISABLED";
    FD1P3AX addr_reg_1305__i3 (.D(n69[3]), .SP(int_clk_out_enable_202), 
            .CK(int_clk_out), .Q(\wb_adr_o[3] )) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305__i3.GSR = "DISABLED";
    FD1P3AX addr_reg_1305__i4 (.D(n69[4]), .SP(int_clk_out_enable_202), 
            .CK(int_clk_out), .Q(\wb_adr_o[4] )) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305__i4.GSR = "DISABLED";
    FD1P3AX addr_reg_1305__i5 (.D(n69[5]), .SP(int_clk_out_enable_202), 
            .CK(int_clk_out), .Q(\wb_adr_o[5] )) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305__i5.GSR = "DISABLED";
    FD1P3AX addr_reg_1305__i6 (.D(n69[6]), .SP(int_clk_out_enable_202), 
            .CK(int_clk_out), .Q(\wb_adr_o[6] )) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305__i6.GSR = "DISABLED";
    FD1P3AX addr_reg_1305__i7 (.D(n69[7]), .SP(int_clk_out_enable_202), 
            .CK(int_clk_out), .Q(\wb_adr_o[7] )) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305__i7.GSR = "DISABLED";
    FD1P3AX addr_reg_1305__i8 (.D(n69[8]), .SP(int_clk_out_enable_210), 
            .CK(int_clk_out), .Q(wb_adr_o[8])) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305__i8.GSR = "DISABLED";
    FD1P3AX addr_reg_1305__i9 (.D(n69[9]), .SP(int_clk_out_enable_210), 
            .CK(int_clk_out), .Q(wb_adr_o_c[9])) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305__i9.GSR = "DISABLED";
    FD1P3AX addr_reg_1305__i10 (.D(n69[10]), .SP(int_clk_out_enable_210), 
            .CK(int_clk_out), .Q(wb_adr_o_c[10])) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305__i10.GSR = "DISABLED";
    FD1P3AX addr_reg_1305__i11 (.D(n69[11]), .SP(int_clk_out_enable_210), 
            .CK(int_clk_out), .Q(wb_adr_o_c[11])) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305__i11.GSR = "DISABLED";
    FD1P3AX addr_reg_1305__i12 (.D(n69[12]), .SP(int_clk_out_enable_210), 
            .CK(int_clk_out), .Q(wb_adr_o_c[12])) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305__i12.GSR = "DISABLED";
    FD1P3AX addr_reg_1305__i13 (.D(n69[13]), .SP(int_clk_out_enable_210), 
            .CK(int_clk_out), .Q(wb_adr_o_c[13])) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305__i13.GSR = "DISABLED";
    FD1P3AX addr_reg_1305__i14 (.D(n69[14]), .SP(int_clk_out_enable_210), 
            .CK(int_clk_out), .Q(wb_adr_o_c[14])) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305__i14.GSR = "DISABLED";
    FD1P3AX addr_reg_1305__i15 (.D(n69[15]), .SP(int_clk_out_enable_210), 
            .CK(int_clk_out), .Q(wb_adr_o_c[15])) /* synthesis syn_use_carry_chain=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(401[29:103])
    defparam addr_reg_1305__i15.GSR = "DISABLED";
    FD1S3IX data_in_reg__i6 (.D(n2323), .CK(int_clk_out), .CD(n7341), 
            .Q(data_in_reg[6])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam data_in_reg__i6.GSR = "DISABLED";
    LUT4 i1_2_lut_rep_194_3_lut_4_lut (.A(n14378), .B(count_reg[0]), .C(data_out_last), 
         .D(n14328), .Z(n14278)) /* synthesis lut_function=(A (C)+!A (B (C)+!B (C+!(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(301[17:44])
    defparam i1_2_lut_rep_194_3_lut_4_lut.init = 16'hf0f1;
    LUT4 data_in_ready_I_0_2_lut_rep_255 (.A(data_in_ready), .B(data_in_valid_reg), 
         .Z(n14339)) /* synthesis lut_function=(!((B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(287[26:60])
    defparam data_in_ready_I_0_2_lut_rep_255.init = 16'h2222;
    FD1S3IX data_in_reg__i5 (.D(n2323), .CK(int_clk_out), .CD(n7340), 
            .Q(data_in_reg[5])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam data_in_reg__i5.GSR = "DISABLED";
    FD1S3IX data_in_reg__i4 (.D(n2323), .CK(int_clk_out), .CD(n7339), 
            .Q(data_in_reg[4])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam data_in_reg__i4.GSR = "DISABLED";
    LUT4 i1_3_lut_adj_156 (.A(count_reg[2]), .B(count_reg[0]), .C(count_reg[4]), 
         .Z(n13090)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(301[17:44])
    defparam i1_3_lut_adj_156.init = 16'hfefe;
    FD1S3IX data_in_reg__i3 (.D(n2323), .CK(int_clk_out), .CD(n7338), 
            .Q(data_in_reg[3])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam data_in_reg__i3.GSR = "DISABLED";
    LUT4 i1_2_lut_3_lut_4_lut (.A(data_in_ready), .B(data_in_valid_reg), 
         .C(n1521[3]), .D(n14340), .Z(n2323)) /* synthesis lut_function=(!((B+!(C (D)))+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(287[26:60])
    defparam i1_2_lut_3_lut_4_lut.init = 16'h2000;
    LUT4 i1103_2_lut_3_lut_4_lut (.A(data_in_ready), .B(data_in_valid_reg), 
         .C(n1521[3]), .D(n14340), .Z(n3866)) /* synthesis lut_function=(A (B (C)+!B !((D)+!C))+!A (C)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(287[26:60])
    defparam i1103_2_lut_3_lut_4_lut.init = 16'hd0f0;
    LUT4 i1_2_lut_rep_256 (.A(data_out_valid), .B(bus_addressed), .Z(n14340)) /* synthesis lut_function=(!(A+!(B))) */ ;
    defparam i1_2_lut_rep_256.init = 16'h4444;
    LUT4 i1_2_lut_rep_223_3_lut_4_lut (.A(data_out_valid), .B(bus_addressed), 
         .C(data_in_valid_reg), .D(data_in_ready), .Z(n14307)) /* synthesis lut_function=(!(A+((C+!(D))+!B))) */ ;
    defparam i1_2_lut_rep_223_3_lut_4_lut.init = 16'h0400;
    LUT4 i1_2_lut_3_lut_adj_157 (.A(data_out_valid), .B(bus_addressed), 
         .C(n1521[3]), .Z(n12856)) /* synthesis lut_function=(!(A+!(B (C)))) */ ;
    defparam i1_2_lut_3_lut_adj_157.init = 16'h4040;
    LUT4 data_out_ready_reg_I_0_2_lut_rep_257 (.A(data_out_ready_reg), .B(data_out_valid), 
         .Z(int_clk_out_enable_12)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(299[17:52])
    defparam data_out_ready_reg_I_0_2_lut_rep_257.init = 16'h8888;
    LUT4 i355_3_lut_rep_191_4_lut (.A(data_out_ready_reg), .B(data_out_valid), 
         .C(n14298), .D(data_out_last), .Z(n14275)) /* synthesis lut_function=(!(A (B ((D)+!C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(299[17:52])
    defparam i355_3_lut_rep_191_4_lut.init = 16'h77f7;
    LUT4 i620_2_lut_rep_233_3_lut (.A(data_out_ready_reg), .B(data_out_valid), 
         .C(n1521[1]), .Z(n14317)) /* synthesis lut_function=(A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(299[17:52])
    defparam i620_2_lut_rep_233_3_lut.init = 16'h8080;
    LUT4 i2110_3_lut_4_lut (.A(n14278), .B(int_clk_out_enable_12), .C(n1521[4]), 
         .D(n4964), .Z(wb_stb_o_next)) /* synthesis lut_function=(A (B (C+(D))+!B !(C+!(D)))+!A !(C+!(D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(389[22] 391[16])
    defparam i2110_3_lut_4_lut.init = 16'h8f80;
    LUT4 i1100_2_lut_3_lut (.A(data_out_ready_reg), .B(data_out_valid), 
         .C(n1521[1]), .Z(n3863)) /* synthesis lut_function=(!(A (B+!(C))+!A !(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(299[17:52])
    defparam i1100_2_lut_3_lut.init = 16'h7070;
    LUT4 i1114_2_lut_3_lut (.A(data_out_ready_reg), .B(data_out_valid), 
         .C(n1521[4]), .Z(n3893)) /* synthesis lut_function=(!(A (B+!(C))+!A !(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(299[17:52])
    defparam i1114_2_lut_3_lut.init = 16'h7070;
    LUT4 mux_1123_i1_then_3_lut (.A(count_reg[0]), .B(data_out_last), .C(n14298), 
         .Z(n14411)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;
    defparam mux_1123_i1_then_3_lut.init = 16'h1010;
    LUT4 mux_1123_i1_else_3_lut (.A(count_reg[0]), .B(n1521[3]), .C(n14298), 
         .D(n1521[1]), .Z(n14410)) /* synthesis lut_function=(!(A (B+(D))+!A !(B (C)+!B (C+!(D))))) */ ;
    defparam mux_1123_i1_else_3_lut.init = 16'h5073;
    LUT4 i1_2_lut_rep_258 (.A(n1521[2]), .B(n1521[5]), .Z(n14342)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i1_2_lut_rep_258.init = 16'heeee;
    LUT4 i6126_2_lut_3_lut_4_lut (.A(data_out_last), .B(n14300), .C(n1521[4]), 
         .D(int_clk_out_enable_12), .Z(n4894)) /* synthesis lut_function=(A (C (D))+!A !(B+!(C (D)))) */ ;
    defparam i6126_2_lut_3_lut_4_lut.init = 16'hb000;
    LUT4 i7924_2_lut_3_lut (.A(n1521[2]), .B(n1521[5]), .C(data_out[3]), 
         .Z(n10810)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i7924_2_lut_3_lut.init = 16'h1010;
    LUT4 i7923_2_lut_3_lut (.A(n1521[2]), .B(n1521[5]), .C(data_out[2]), 
         .Z(n10812)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i7923_2_lut_3_lut.init = 16'h1010;
    LUT4 i10391_4_lut (.A(n12212), .B(n13360), .C(n14353), .D(n13310), 
         .Z(n13382)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i10391_4_lut.init = 16'hfffe;
    LUT4 i10319_2_lut (.A(wb_adr_o_c[13]), .B(\wb_adr_o[7] ), .Z(n13310)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i10319_2_lut.init = 16'heeee;
    LUT4 i7918_2_lut_3_lut (.A(n1521[2]), .B(n1521[5]), .C(data_out[5]), 
         .Z(n10790)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i7918_2_lut_3_lut.init = 16'h1010;
    LUT4 i7920_2_lut_3_lut (.A(n1521[2]), .B(n1521[5]), .C(data_out[4]), 
         .Z(n10792)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i7920_2_lut_3_lut.init = 16'h1010;
    LUT4 i7917_2_lut_3_lut (.A(n1521[2]), .B(n1521[5]), .C(data_out[7]), 
         .Z(n10802)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i7917_2_lut_3_lut.init = 16'h1010;
    LUT4 i7929_2_lut_3_lut (.A(n1521[2]), .B(n1521[5]), .C(data_out[6]), 
         .Z(n10804)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i7929_2_lut_3_lut.init = 16'h1010;
    LUT4 i7919_2_lut_3_lut (.A(n1521[2]), .B(n1521[5]), .C(data_out[0]), 
         .Z(n10800)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i7919_2_lut_3_lut.init = 16'h1010;
    LUT4 i7921_2_lut_3_lut (.A(n1521[2]), .B(n1521[5]), .C(data_out[1]), 
         .Z(n10814)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i7921_2_lut_3_lut.init = 16'h1010;
    LUT4 i1_4_lut_adj_158 (.A(n3), .B(n14276), .C(count_reg[4]), .D(n14388), 
         .Z(n11566)) /* synthesis lut_function=(A (B (C))+!A (B (C (D)+!C !(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i1_4_lut_adj_158.init = 16'hc084;
    LUT4 i1_4_lut_adj_159 (.A(n12212), .B(n14332), .C(n12632), .D(n14353), 
         .Z(n11604)) /* synthesis lut_function=(!(A+(((D)+!C)+!B))) */ ;
    defparam i1_4_lut_adj_159.init = 16'h0040;
    LUT4 i1_4_lut_adj_160 (.A(n13294), .B(n13334), .C(wb_adr_o_c[15]), 
         .D(\wb_adr_o[2] ), .Z(n12632)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i1_4_lut_adj_160.init = 16'h0100;
    LUT4 i10343_2_lut (.A(\wb_adr_o[4] ), .B(wb_adr_o_c[13]), .Z(n13334)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i10343_2_lut.init = 16'heeee;
    LUT4 i10303_2_lut (.A(\wb_adr_o[7] ), .B(wb_adr_o_c[10]), .Z(n13294)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i10303_2_lut.init = 16'heeee;
    LUT4 i1_2_lut_rep_252 (.A(count_reg[1]), .B(count_reg[2]), .Z(n14336)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(301[17:44])
    defparam i1_2_lut_rep_252.init = 16'heeee;
    LUT4 i1_4_lut_adj_161 (.A(n14276), .B(count_reg[3]), .C(n14336), .D(count_reg[0]), 
         .Z(n3915[3])) /* synthesis lut_function=(A (B (C+(D))+!B !(C+(D)))) */ ;
    defparam i1_4_lut_adj_161.init = 16'h8882;
    LUT4 i1_4_lut_adj_162 (.A(n14276), .B(count_reg[5]), .C(n13090), .D(n14378), 
         .Z(n3915[5])) /* synthesis lut_function=(A (B (C+(D))+!B !(C+(D)))) */ ;
    defparam i1_4_lut_adj_162.init = 16'h8882;
    LUT4 i12_3_lut_4_lut (.A(n14278), .B(int_clk_out_enable_12), .C(n1521[4]), 
         .D(n1521[0]), .Z(int_clk_out_enable_38)) /* synthesis lut_function=(A (B (C+(D))+!B !(C+!(D)))+!A !(C+!(D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(389[22] 391[16])
    defparam i12_3_lut_4_lut.init = 16'h8f80;
    LUT4 i1685_2_lut_rep_251 (.A(count_reg[1]), .B(count_reg[0]), .Z(n14335)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(302[30:43])
    defparam i1685_2_lut_rep_251.init = 16'h8888;
    LUT4 i1_4_lut_adj_163 (.A(n13302), .B(n12984), .C(n14383), .D(n12728), 
         .Z(n6568)) /* synthesis lut_function=(!(A+((C+!(D))+!B))) */ ;
    defparam i1_4_lut_adj_163.init = 16'h0400;
    LUT4 i4373_1_lut (.A(wb_dat_o[2]), .Z(n7337)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam i4373_1_lut.init = 16'h5555;
    LUT4 i1_3_lut_adj_164 (.A(wb_adr_o[8]), .B(wb_adr_o_c[13]), .C(\wb_adr_o[3] ), 
         .Z(n12728)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;
    defparam i1_3_lut_adj_164.init = 16'h1010;
    LUT4 i4372_1_lut (.A(wb_dat_o[1]), .Z(n7336)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam i4372_1_lut.init = 16'h5555;
    LUT4 select_1065_Select_1_i11_4_lut (.A(wb_dat_i[1]), .B(data_next_7__N_737[1]), 
         .C(n1521[2]), .D(n1521[4]), .Z(n3913)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam select_1065_Select_1_i11_4_lut.init = 16'heca0;
    LUT4 mux_76_i2_3_lut (.A(data_out[1]), .B(wb_dat_o[1]), .C(count_reg[0]), 
         .Z(data_next_7__N_737[1])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(376[17:26])
    defparam mux_76_i2_3_lut.init = 16'hcaca;
    LUT4 select_1065_Select_2_i11_4_lut (.A(wb_dat_i[2]), .B(data_next_7__N_737[2]), 
         .C(n1521[2]), .D(n1521[4]), .Z(n3912)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam select_1065_Select_2_i11_4_lut.init = 16'heca0;
    LUT4 mux_76_i3_3_lut (.A(data_out[2]), .B(wb_dat_o[2]), .C(count_reg[0]), 
         .Z(data_next_7__N_737[2])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(376[17:26])
    defparam mux_76_i3_3_lut.init = 16'hcaca;
    LUT4 i1_4_lut_adj_165 (.A(n14276), .B(count_reg[6]), .C(n13098), .D(n3), 
         .Z(n3915[6])) /* synthesis lut_function=(A (B (C+(D))+!B !(C+(D)))) */ ;
    defparam i1_4_lut_adj_165.init = 16'h8882;
    LUT4 select_1065_Select_3_i11_4_lut (.A(wb_dat_i[3]), .B(data_next_7__N_737[3]), 
         .C(n1521[2]), .D(n1521[4]), .Z(n3911)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam select_1065_Select_3_i11_4_lut.init = 16'heca0;
    FD1S3IX data_in_reg__i2 (.D(n2323), .CK(int_clk_out), .CD(n7337), 
            .Q(data_in_reg[2])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam data_in_reg__i2.GSR = "DISABLED";
    LUT4 i1_4_lut_adj_166 (.A(n14277), .B(count_reg[6]), .C(count_reg[7]), 
         .D(n14267), .Z(n16)) /* synthesis lut_function=(!((B (C (D)+!C !(D))+!B !(C))+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i1_4_lut_adj_166.init = 16'h28a0;
    LUT4 mux_76_i4_3_lut (.A(data_out[3]), .B(wb_dat_o[3]), .C(count_reg[0]), 
         .Z(data_next_7__N_737[3])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(376[17:26])
    defparam mux_76_i4_3_lut.init = 16'hcaca;
    LUT4 select_1065_Select_4_i11_4_lut (.A(wb_dat_i[4]), .B(data_next_7__N_737[4]), 
         .C(n1521[2]), .D(n1521[4]), .Z(n3910)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam select_1065_Select_4_i11_4_lut.init = 16'heca0;
    LUT4 mux_76_i5_3_lut (.A(data_out[4]), .B(wb_dat_o[4]), .C(count_reg[0]), 
         .Z(data_next_7__N_737[4])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(376[17:26])
    defparam mux_76_i5_3_lut.init = 16'hcaca;
    LUT4 select_1065_Select_5_i11_4_lut (.A(wb_dat_i[5]), .B(data_next_7__N_737[5]), 
         .C(n1521[2]), .D(n1521[4]), .Z(n3909)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam select_1065_Select_5_i11_4_lut.init = 16'heca0;
    LUT4 mux_76_i6_3_lut (.A(data_out[5]), .B(wb_dat_o[5]), .C(count_reg[0]), 
         .Z(data_next_7__N_737[5])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(376[17:26])
    defparam mux_76_i6_3_lut.init = 16'hcaca;
    LUT4 i1_4_lut_adj_167 (.A(n13214), .B(n14276), .C(count_reg[7]), .D(n13212), 
         .Z(n11568)) /* synthesis lut_function=(A (B (C))+!A (B (C (D)+!C !(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i1_4_lut_adj_167.init = 16'hc084;
    LUT4 select_1065_Select_6_i11_4_lut (.A(wb_dat_i[6]), .B(data_next_7__N_737[6]), 
         .C(n1521[2]), .D(n1521[4]), .Z(n3908)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam select_1065_Select_6_i11_4_lut.init = 16'heca0;
    LUT4 mux_76_i7_3_lut (.A(data_out[6]), .B(wb_dat_o[6]), .C(count_reg[0]), 
         .Z(data_next_7__N_737[6])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(376[17:26])
    defparam mux_76_i7_3_lut.init = 16'hcaca;
    LUT4 select_1065_Select_7_i11_4_lut (.A(wb_dat_i[7]), .B(data_next_7__N_737[7]), 
         .C(n1521[2]), .D(n1521[4]), .Z(n3907)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam select_1065_Select_7_i11_4_lut.init = 16'heca0;
    LUT4 mux_76_i8_3_lut (.A(data_out[7]), .B(wb_dat_o[7]), .C(count_reg[0]), 
         .Z(data_next_7__N_737[7])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(376[17:26])
    defparam mux_76_i8_3_lut.init = 16'hcaca;
    PFUMX i30 (.BLUT(n11568), .ALUT(n16), .C0(n3934), .Z(n11149));
    FD1S3IX data_in_reg__i1 (.D(n2323), .CK(int_clk_out), .CD(n7336), 
            .Q(data_in_reg[1])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=3, LSE_LCOL=4, LSE_RCOL=2, LSE_LLINE=202, LSE_RLINE=238 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam data_in_reg__i1.GSR = "DISABLED";
    LUT4 i1_4_lut_adj_168 (.A(n13350), .B(n14384), .C(n13310), .D(n14387), 
         .Z(n12874)) /* synthesis lut_function=(!(A+((C+(D))+!B))) */ ;
    defparam i1_4_lut_adj_168.init = 16'h0004;
    LUT4 i2222_4_lut (.A(n1521[1]), .B(data_out_valid), .C(n14275), .D(n1521[0]), 
         .Z(n5087)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i2222_4_lut.init = 16'heca0;
    LUT4 i2218_4_lut (.A(n12856), .B(n1554), .C(n14339), .D(n14298), 
         .Z(n5083)) /* synthesis lut_function=(A (B+((D)+!C))+!A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i2218_4_lut.init = 16'heece;
    PFUMX mux_1123_i7 (.BLUT(n3915[6]), .ALUT(n3925[6]), .C0(n3934), .Z(n3935[6]));
    LUT4 i405_2_lut (.A(wb_ack_i), .B(n1521[2]), .Z(n1554)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i405_2_lut.init = 16'h8888;
    LUT4 i1_4_lut_adj_169 (.A(n14328), .B(n5080), .C(n11557), .D(n13196), 
         .Z(n12054)) /* synthesis lut_function=(A (B+(C))+!A (B+(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i1_4_lut_adj_169.init = 16'hfdfc;
    LUT4 i1484_2_lut_rep_183_3_lut_4_lut (.A(count_reg[3]), .B(n14303), 
         .C(count_reg[5]), .D(count_reg[4]), .Z(n14267)) /* synthesis lut_function=(A (B (C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(377[30:43])
    defparam i1484_2_lut_rep_183_3_lut_4_lut.init = 16'h8000;
    LUT4 i1_4_lut_adj_170 (.A(int_clk_out_enable_12), .B(n3), .C(n13188), 
         .D(count_reg[3]), .Z(n13196)) /* synthesis lut_function=(!((B+((D)+!C))+!A)) */ ;
    defparam i1_4_lut_adj_170.init = 16'h0020;
    LUT4 i2187_2_lut (.A(wb_ack_i), .B(n1521[5]), .Z(n5052)) /* synthesis lut_function=(!(A+!(B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i2187_2_lut.init = 16'h4444;
    LUT4 i1_4_lut_adj_171 (.A(n14352), .B(n12984), .C(n14325), .D(n13068), 
         .Z(int_clk_out_enable_111)) /* synthesis lut_function=(!(A+((C+!(D))+!B))) */ ;
    defparam i1_4_lut_adj_171.init = 16'h0400;
    LUT4 i1_2_lut_rep_192_4_lut (.A(n14376), .B(n11), .C(n14327), .D(n1521[1]), 
         .Z(n14276)) /* synthesis lut_function=(A (D)+!A (B (D)+!B (C (D)))) */ ;
    defparam i1_2_lut_rep_192_4_lut.init = 16'hfe00;
    LUT4 i1098_2_lut_rep_260 (.A(n1521[0]), .B(data_out_valid), .Z(n14344)) /* synthesis lut_function=(!((B)+!A)) */ ;
    defparam i1098_2_lut_rep_260.init = 16'h2222;
    LUT4 i1_2_lut_4_lut_adj_172 (.A(n14376), .B(n11), .C(n14327), .D(n14307), 
         .Z(n12071)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i1_2_lut_4_lut_adj_172.init = 16'h0100;
    LUT4 i1463_2_lut_rep_219_3_lut (.A(count_reg[1]), .B(count_reg[0]), 
         .C(count_reg[2]), .Z(n14303)) /* synthesis lut_function=(A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(302[30:43])
    defparam i1463_2_lut_rep_219_3_lut.init = 16'h8080;
    PFUMX mux_1123_i6 (.BLUT(n3915[5]), .ALUT(n3925[5]), .C0(n3934), .Z(n3935[5]));
    LUT4 i6200_3_lut_4_lut (.A(count_reg[4]), .B(n14281), .C(n14277), 
         .D(count_reg[5]), .Z(n3925[5])) /* synthesis lut_function=(!(A (B ((D)+!C)+!B !(C (D)))+!A !(C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(377[30:43])
    defparam i6200_3_lut_4_lut.init = 16'h7080;
    LUT4 i1_4_lut_adj_173 (.A(n13300), .B(wb_adr_o[8]), .C(n14377), .D(\wb_adr_o[0] ), 
         .Z(n13068)) /* synthesis lut_function=(!(A+(B+!(C (D))))) */ ;
    defparam i1_4_lut_adj_173.init = 16'h1000;
    LUT4 i1_2_lut_3_lut_4_lut_adj_174 (.A(n1521[0]), .B(data_out_valid), 
         .C(n1521[5]), .D(n1521[2]), .Z(n12588)) /* synthesis lut_function=(A ((C+(D))+!B)+!A (C+(D))) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_174.init = 16'hfff2;
    LUT4 i1_2_lut_3_lut_4_lut_adj_175 (.A(n1521[0]), .B(data_out_valid), 
         .C(data_in_valid_reg), .D(data_in_ready), .Z(n6551)) /* synthesis lut_function=(!((B+!(C+!(D)))+!A)) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_175.init = 16'h2022;
    LUT4 i10309_2_lut (.A(\wb_adr_o[2] ), .B(wb_adr_o_c[13]), .Z(n13300)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i10309_2_lut.init = 16'heeee;
    LUT4 i1_2_lut_adj_176 (.A(data_out_last), .B(n1521[1]), .Z(n13188)) /* synthesis lut_function=(!(A+!(B))) */ ;
    defparam i1_2_lut_adj_176.init = 16'h4444;
    LUT4 i6198_3_lut_4_lut (.A(count_reg[1]), .B(count_reg[0]), .C(n14277), 
         .D(count_reg[2]), .Z(n3925[2])) /* synthesis lut_function=(!(A (B ((D)+!C)+!B !(C (D)))+!A !(C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(302[30:43])
    defparam i6198_3_lut_4_lut.init = 16'h7080;
    PFUMX mux_1123_i4 (.BLUT(n3915[3]), .ALUT(n3925[3]), .C0(n3934), .Z(n3935[3]));
    LUT4 i2188_4_lut (.A(n5052), .B(int_clk_out_enable_12), .C(n14278), 
         .D(n1521[4]), .Z(n5053)) /* synthesis lut_function=(A+(B (C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i2188_4_lut.init = 16'heaaa;
    LUT4 i1_3_lut_adj_177 (.A(count_reg[4]), .B(count_reg[2]), .C(count_reg[7]), 
         .Z(n11)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(303[21:35])
    defparam i1_3_lut_adj_177.init = 16'hfefe;
    PFUMX mux_1123_i3 (.BLUT(n3915[2]), .ALUT(n3925[2]), .C0(n3934), .Z(n3935[2]));
    LUT4 i10377_2_lut_rep_216_3_lut_4_lut (.A(n11), .B(n14376), .C(count_reg[0]), 
         .D(n14378), .Z(n14300)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i10377_2_lut_rep_216_3_lut_4_lut.init = 16'hfffe;
    LUT4 i1470_2_lut_rep_197_3_lut_4_lut (.A(count_reg[1]), .B(count_reg[0]), 
         .C(count_reg[3]), .D(count_reg[2]), .Z(n14281)) /* synthesis lut_function=(A (B (C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(302[30:43])
    defparam i1470_2_lut_rep_197_3_lut_4_lut.init = 16'h8000;
    LUT4 i1_3_lut_4_lut_adj_178 (.A(count_reg[3]), .B(n14303), .C(count_reg[4]), 
         .D(n14277), .Z(n16_adj_1179)) /* synthesis lut_function=(!(A (B (C+!(D))+!B !(C (D)))+!A !(C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(377[30:43])
    defparam i1_3_lut_4_lut_adj_178.init = 16'h7800;
    PFUMX i30_adj_179 (.BLUT(n11566), .ALUT(n16_adj_1179), .C0(n3934), 
          .Z(n11183));
    LUT4 i1_4_lut_adj_180 (.A(count_reg[0]), .B(n14342), .C(n14317), .D(count_reg[1]), 
         .Z(int_clk_out_enable_210)) /* synthesis lut_function=(A (B+!((D)+!C))+!A (B)) */ ;
    defparam i1_4_lut_adj_180.init = 16'hccec;
    LUT4 i10688_4_lut (.A(n12456), .B(n1521[1]), .C(n14300), .D(int_clk_out_enable_12), 
         .Z(int_clk_out_enable_178)) /* synthesis lut_function=(!(A+(B (C+!(D))))) */ ;
    defparam i10688_4_lut.init = 16'h1511;
    LUT4 i1_4_lut_adj_181 (.A(n3893), .B(n14334), .C(n5052), .D(n12450), 
         .Z(n12456)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_adj_181.init = 16'hfffe;
    LUT4 i1_2_lut_adj_182 (.A(n1521[3]), .B(n1521[0]), .Z(n12450)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut_adj_182.init = 16'heeee;
    LUT4 select_1065_Select_0_i11_4_lut (.A(wb_dat_i[0]), .B(data_next_7__N_737[0]), 
         .C(n1521[2]), .D(n1521[4]), .Z(n3914)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam select_1065_Select_0_i11_4_lut.init = 16'heca0;
    LUT4 i1_2_lut_rep_217_3_lut_4_lut (.A(\wb_adr_o[2] ), .B(n14386), .C(n14354), 
         .D(n14351), .Z(n14301)) /* synthesis lut_function=(!(A+((C+!(D))+!B))) */ ;
    defparam i1_2_lut_rep_217_3_lut_4_lut.init = 16'h0400;
    LUT4 i6199_3_lut_4_lut (.A(count_reg[2]), .B(n14335), .C(n14277), 
         .D(count_reg[3]), .Z(n3925[3])) /* synthesis lut_function=(!(A (B ((D)+!C)+!B !(C (D)))+!A !(C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(377[30:43])
    defparam i6199_3_lut_4_lut.init = 16'h7080;
    LUT4 i2219_2_lut_rep_250 (.A(n1521[2]), .B(wb_ack_i), .Z(n14334)) /* synthesis lut_function=(!((B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i2219_2_lut_rep_250.init = 16'h2222;
    PFUMX i10998 (.BLUT(n14410), .ALUT(n14411), .C0(n1521[4]), .Z(n14412));
    LUT4 i4377_1_lut (.A(wb_dat_o[6]), .Z(n7341)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam i4377_1_lut.init = 16'h5555;
    LUT4 i4376_1_lut (.A(wb_dat_o[5]), .Z(n7340)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam i4376_1_lut.init = 16'h5555;
    LUT4 i4375_1_lut (.A(wb_dat_o[4]), .Z(n7339)) /* synthesis lut_function=(!(A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(418[8] 450[4])
    defparam i4375_1_lut.init = 16'h5555;
    LUT4 i2220_2_lut_3_lut_4_lut (.A(n1521[2]), .B(wb_ack_i), .C(n14339), 
         .D(n14344), .Z(n5085)) /* synthesis lut_function=(A ((C (D))+!B)+!A (C (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(278[5] 415[12])
    defparam i2220_2_lut_3_lut_4_lut.init = 16'hf222;
    LUT4 i1477_2_lut_rep_188_3_lut_4_lut (.A(count_reg[2]), .B(n14335), 
         .C(count_reg[4]), .D(count_reg[3]), .Z(n14272)) /* synthesis lut_function=(A (B (C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(377[30:43])
    defparam i1477_2_lut_rep_188_3_lut_4_lut.init = 16'h8000;
    i2c_slave i2c_slave_inst (.\state_reg[0] (\state_reg[0] ), .int_clk_out(int_clk_out), 
            .n14343(n14343), .bus_addressed(bus_addressed), .n13400(n13400), 
            .sda_i_reg(sda_i_reg), .n14324(n14324), .data_in_ready(data_in_ready), 
            .mode_read_reg(mode_read_reg), .fpga_scl_in(fpga_scl_in), .data_out_last(data_out_last), 
            .fpga_sda_in(fpga_sda_in), .data_out_valid(data_out_valid), 
            .fpga_scl_out(fpga_scl_out), .n13402(n13402), .data_in_valid_reg(data_in_valid_reg), 
            .data_out({data_out}), .fpga_sda_out(fpga_sda_out), .data_out_ready_reg(data_out_ready_reg), 
            .n12584(n12584), .stm_fpga_spare5_c(stm_fpga_spare5_c), .data_in_reg({data_in_reg}), 
            .wb_dat_o({wb_dat_o}), .\tx_lvds_test_pattern_31__N_119[25] (\tx_lvds_test_pattern_31__N_119[25] ), 
            .int_clk_out_enable_55(int_clk_out_enable_55), .int_clk_out_enable_62(int_clk_out_enable_62), 
            .n13358(n13358), .n11958(n11958), .n13056(n13056), .int_clk_out_enable_28(int_clk_out_enable_28), 
            .int_clk_out_enable_111(int_clk_out_enable_111), .int_clk_out_enable_114(int_clk_out_enable_114), 
            .int_clk_out_enable_39(int_clk_out_enable_39), .int_clk_out_enable_46(int_clk_out_enable_46), 
            .n12886(n12886), .n11601(n11601), .n13286(n13286), .int_clk_out_enable_69(int_clk_out_enable_69), 
            .n13382(n13382), .n14332(n14332), .n14333(n14333), .int_clk_out_enable_150(int_clk_out_enable_150), 
            .led_rst(led_rst), .fpga_led_N_383(fpga_led_N_383), .n6568(n6568), 
            .n14386(n14386), .\wb_adr_o[2] (\wb_adr_o[2] ), .int_clk_out_enable_121(int_clk_out_enable_121), 
            .\tx_lvds_test_pattern_31__N_119[6] (\tx_lvds_test_pattern_31__N_119[6] ), 
            .int_clk_out_enable_54(int_clk_out_enable_54), .int_clk_out_enable_53(int_clk_out_enable_53), 
            .\tx_lvds_test_pattern_31__N_119[26] (\tx_lvds_test_pattern_31__N_119[26] ), 
            .n12850(n12850), .n12212(n12212), .n14301(n14301), .int_clk_out_enable_27(int_clk_out_enable_27), 
            .n14331(n14331), .int_clk_out_enable_164(int_clk_out_enable_164), 
            .n12874(n12874), .int_clk_out_enable_171(int_clk_out_enable_171), 
            .int_clk_out_enable_107(int_clk_out_enable_107), .int_clk_out_enable_106(int_clk_out_enable_106), 
            .\ufl_p7_sel_7__N_35[0] (\ufl_p7_sel_7__N_35[0] ), .n12964(n12964), 
            .n12966(n12966), .int_clk_out_enable_212(int_clk_out_enable_212), 
            .n14385(n14385), .int_clk_out_enable_128(int_clk_out_enable_128), 
            .int_clk_out_enable_83(int_clk_out_enable_83), .int_clk_out_enable_84(int_clk_out_enable_84), 
            .int_clk_out_enable_77(int_clk_out_enable_77), .int_clk_out_enable_76(int_clk_out_enable_76), 
            .\tx_lvds_test_pattern_31__N_119[31] (\tx_lvds_test_pattern_31__N_119[31] ), 
            .int_clk_out_enable_99(int_clk_out_enable_99), .int_clk_out_enable_98(int_clk_out_enable_98), 
            .\tx_lvds_test_pattern_31__N_119[27] (\tx_lvds_test_pattern_31__N_119[27] ), 
            .\spi3_test_pattern_15__N_83[13] (\spi3_test_pattern_15__N_83[13] ), 
            .\tx_lvds_test_pattern_31__N_119[28] (\tx_lvds_test_pattern_31__N_119[28] ), 
            .n14299(n14299), .n13324(n13324)) /* synthesis syn_module_defined=1 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave_wbm.v(455[1] 490[2])
    
endmodule
//
// Verilog Description of module i2c_slave
//

module i2c_slave (\state_reg[0] , int_clk_out, n14343, bus_addressed, 
            n13400, sda_i_reg, n14324, data_in_ready, mode_read_reg, 
            fpga_scl_in, data_out_last, fpga_sda_in, data_out_valid, 
            fpga_scl_out, n13402, data_in_valid_reg, data_out, fpga_sda_out, 
            data_out_ready_reg, n12584, stm_fpga_spare5_c, data_in_reg, 
            wb_dat_o, \tx_lvds_test_pattern_31__N_119[25] , int_clk_out_enable_55, 
            int_clk_out_enable_62, n13358, n11958, n13056, int_clk_out_enable_28, 
            int_clk_out_enable_111, int_clk_out_enable_114, int_clk_out_enable_39, 
            int_clk_out_enable_46, n12886, n11601, n13286, int_clk_out_enable_69, 
            n13382, n14332, n14333, int_clk_out_enable_150, led_rst, 
            fpga_led_N_383, n6568, n14386, \wb_adr_o[2] , int_clk_out_enable_121, 
            \tx_lvds_test_pattern_31__N_119[6] , int_clk_out_enable_54, 
            int_clk_out_enable_53, \tx_lvds_test_pattern_31__N_119[26] , 
            n12850, n12212, n14301, int_clk_out_enable_27, n14331, 
            int_clk_out_enable_164, n12874, int_clk_out_enable_171, int_clk_out_enable_107, 
            int_clk_out_enable_106, \ufl_p7_sel_7__N_35[0] , n12964, n12966, 
            int_clk_out_enable_212, n14385, int_clk_out_enable_128, int_clk_out_enable_83, 
            int_clk_out_enable_84, int_clk_out_enable_77, int_clk_out_enable_76, 
            \tx_lvds_test_pattern_31__N_119[31] , int_clk_out_enable_99, 
            int_clk_out_enable_98, \tx_lvds_test_pattern_31__N_119[27] , 
            \spi3_test_pattern_15__N_83[13] , \tx_lvds_test_pattern_31__N_119[28] , 
            n14299, n13324) /* synthesis syn_module_defined=1 */ ;
    output \state_reg[0] ;
    input int_clk_out;
    output n14343;
    output bus_addressed;
    input n13400;
    output sda_i_reg;
    output n14324;
    output data_in_ready;
    output mode_read_reg;
    input fpga_scl_in;
    output data_out_last;
    input fpga_sda_in;
    output data_out_valid;
    output fpga_scl_out;
    input n13402;
    input data_in_valid_reg;
    output [7:0]data_out;
    output fpga_sda_out;
    input data_out_ready_reg;
    output n12584;
    input stm_fpga_spare5_c;
    input [7:0]data_in_reg;
    input [7:0]wb_dat_o;
    output \tx_lvds_test_pattern_31__N_119[25] ;
    input int_clk_out_enable_55;
    output int_clk_out_enable_62;
    input n13358;
    input n11958;
    input n13056;
    output int_clk_out_enable_28;
    input int_clk_out_enable_111;
    output int_clk_out_enable_114;
    input int_clk_out_enable_39;
    output int_clk_out_enable_46;
    input n12886;
    input n11601;
    input n13286;
    output int_clk_out_enable_69;
    input n13382;
    input n14332;
    input n14333;
    output int_clk_out_enable_150;
    input led_rst;
    output fpga_led_N_383;
    input n6568;
    input n14386;
    input \wb_adr_o[2] ;
    output int_clk_out_enable_121;
    output \tx_lvds_test_pattern_31__N_119[6] ;
    input int_clk_out_enable_54;
    output int_clk_out_enable_53;
    output \tx_lvds_test_pattern_31__N_119[26] ;
    input n12850;
    input n12212;
    input n14301;
    output int_clk_out_enable_27;
    input n14331;
    output int_clk_out_enable_164;
    input n12874;
    output int_clk_out_enable_171;
    input int_clk_out_enable_107;
    output int_clk_out_enable_106;
    output \ufl_p7_sel_7__N_35[0] ;
    input n12964;
    input n12966;
    output int_clk_out_enable_212;
    input n14385;
    output int_clk_out_enable_128;
    input int_clk_out_enable_83;
    output int_clk_out_enable_84;
    input int_clk_out_enable_77;
    output int_clk_out_enable_76;
    output \tx_lvds_test_pattern_31__N_119[31] ;
    input int_clk_out_enable_99;
    output int_clk_out_enable_98;
    output \tx_lvds_test_pattern_31__N_119[27] ;
    output \spi3_test_pattern_15__N_83[13] ;
    output \tx_lvds_test_pattern_31__N_119[28] ;
    output n14299;
    output n13324;
    
    wire int_clk_out /* synthesis DSPPORT_20=CLK3, CLOCK_NET_FOR_BUS20=20, is_clock=1, SET_AS_NETWORK=int_clk_out */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(76[6:17])
    wire fpga_led_N_383 /* synthesis DSPPORT_20=RST3, RESET_NET_FOR_BUS20=20 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(2[14:22])
    wire [4:0]state_next;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(181[35:45])
    
    wire int_clk_out_enable_1, n6297, n13, n19;
    wire [4:0]state_reg;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(181[11:20])
    
    wire n22, n13424, n14370, n11585, n14916;
    wire [7:0]data_reg;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(184[11:19])
    
    wire n12526, n14375, n14372, data_valid_reg, n12664;
    wire [7:0]n296;
    wire [7:0]n3042;
    wire [7:0]data_next_7__N_843;
    wire [3:0]scl_i_filter;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(199[22:34])
    
    wire scl_i_reg_N_956;
    wire [3:0]sda_i_filter;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(200[22:34])
    
    wire sda_i_reg_N_943, data_out_reg_valid_reg, n6480, m_axis_data_tvalid_next, 
        n8188, n14297, int_clk_out_enable_25, n14318, n12668, n12272, 
        n12748, last_scl_i_reg, n12342, n6, n13244, s_axis_data_tready_next_N_934, 
        n14374, n14367, n23;
    wire [3:0]bit_count_reg;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(191[11:24])
    
    wire int_clk_out_enable_180;
    wire [3:0]bit_count_next;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(191[33:47])
    
    wire n7314, scl_i_reg, int_clk_out_enable_21, int_clk_out_enable_22, 
        last_sda_i_reg, n12524, n12528, n11479, n12562, n13966, 
        n14292, n14320, int_clk_out_enable_29, sda_o_next_N_968, n14234, 
        n14233, n14235, int_clk_out_enable_188, n32, int_clk_out_enable_36, 
        n14368, n4, n14369, n6_adj_1177, int_clk_out_enable_195, int_clk_out_enable_34, 
        scl_o_next_N_961, n13965, n13967, n4_adj_1178, n14308, int_clk_out_enable_35, 
        n12249, n14373;
    wire [7:0]n91;
    
    wire n12211, n3102, n4095, n14321, n11584, n12184, n11155, 
        n14322, n14296, n14, n14379, n14329, start_bit, n14381, 
        n14326, n14323, n11865, int_clk_out_enable_181, n9276, n14178, 
        n14265, n12227;
    wire [2:0]n3785;
    
    wire n13386, n8344;
    wire [2:0]n3789;
    
    wire n4108, n12346, n14405, n14404;
    wire [2:0]n3793;
    wire [2:0]n3797;
    
    wire n4111, n14406, n13560, n12470, n4085;
    
    FD1S3IX state_reg__i1 (.D(state_next[0]), .CK(int_clk_out), .CD(n14343), 
            .Q(\state_reg[0] )) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam state_reg__i1.GSR = "DISABLED";
    FD1P3IX bus_addressed_reg_236 (.D(n13400), .SP(int_clk_out_enable_1), 
            .CD(n6297), .CK(int_clk_out), .Q(bus_addressed)) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam bus_addressed_reg_236.GSR = "DISABLED";
    PFUMX i38 (.BLUT(n13), .ALUT(n19), .C0(state_reg[2]), .Z(n22));
    LUT4 i10720_2_lut (.A(\state_reg[0] ), .B(state_reg[2]), .Z(n13424)) /* synthesis lut_function=(!(A (B))) */ ;
    defparam i10720_2_lut.init = 16'h7777;
    LUT4 state_reg_0__bdd_4_lut (.A(\state_reg[0] ), .B(n14370), .C(n11585), 
         .D(state_reg[1]), .Z(n14916)) /* synthesis lut_function=(A (C (D))+!A (B (C (D))+!B (C+!(D)))) */ ;
    defparam state_reg_0__bdd_4_lut.init = 16'hf011;
    LUT4 i1_2_lut (.A(data_reg[1]), .B(data_reg[6]), .Z(n12526)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(300[39:118])
    defparam i1_2_lut.init = 16'heeee;
    LUT4 i1_4_lut (.A(n14375), .B(n14372), .C(\state_reg[0] ), .D(data_valid_reg), 
         .Z(n12664)) /* synthesis lut_function=(A+(B+!(C (D)))) */ ;
    defparam i1_4_lut.init = 16'hefff;
    PFUMX mux_874_i2 (.BLUT(n296[1]), .ALUT(n3042[1]), .C0(n13424), .Z(data_next_7__N_843[1]));
    PFUMX mux_874_i3 (.BLUT(n296[2]), .ALUT(n3042[2]), .C0(n13424), .Z(data_next_7__N_843[2]));
    LUT4 i1_4_lut_adj_81 (.A(scl_i_filter[1]), .B(scl_i_filter[2]), .C(scl_i_filter[0]), 
         .D(scl_i_filter[3]), .Z(scl_i_reg_N_956)) /* synthesis lut_function=(A (B (C (D)))) */ ;
    defparam i1_4_lut_adj_81.init = 16'h8000;
    LUT4 i1_4_lut_adj_82 (.A(sda_i_filter[1]), .B(sda_i_filter[2]), .C(sda_i_filter[0]), 
         .D(sda_i_filter[3]), .Z(sda_i_reg_N_943)) /* synthesis lut_function=(A (B (C (D)))) */ ;
    defparam i1_4_lut_adj_82.init = 16'h8000;
    PFUMX mux_874_i4 (.BLUT(n296[3]), .ALUT(n3042[3]), .C0(n13424), .Z(data_next_7__N_843[3]));
    LUT4 i1_2_lut_3_lut (.A(\state_reg[0] ), .B(sda_i_reg), .C(state_reg[2]), 
         .Z(n11585)) /* synthesis lut_function=(!((B+!(C))+!A)) */ ;
    defparam i1_2_lut_3_lut.init = 16'h2020;
    PFUMX mux_874_i5 (.BLUT(n296[4]), .ALUT(n3042[4]), .C0(n13424), .Z(data_next_7__N_843[4]));
    LUT4 i2208_4_lut (.A(data_out_reg_valid_reg), .B(n14372), .C(n6480), 
         .D(n14324), .Z(m_axis_data_tvalid_next)) /* synthesis lut_function=(A (B+((D)+!C))+!A !(((D)+!C)+!B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(273[14] 436[8])
    defparam i2208_4_lut.init = 16'haaca;
    LUT4 i14_4_lut (.A(n14324), .B(state_reg[2]), .C(n8188), .D(n14297), 
         .Z(int_clk_out_enable_25)) /* synthesis lut_function=(A+!(B (D)+!B !(C))) */ ;
    defparam i14_4_lut.init = 16'hbafe;
    LUT4 i1_4_lut_adj_83 (.A(n14318), .B(n14324), .C(n14372), .D(n12668), 
         .Z(n12272)) /* synthesis lut_function=(!((B+(C+!(D)))+!A)) */ ;
    defparam i1_4_lut_adj_83.init = 16'h0200;
    LUT4 i1_4_lut_4_lut (.A(\state_reg[0] ), .B(n12748), .C(sda_i_reg), 
         .D(last_scl_i_reg), .Z(n12342)) /* synthesis lut_function=(!(A ((C+(D))+!B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam i1_4_lut_4_lut.init = 16'h555d;
    LUT4 i5295_4_lut_4_lut (.A(\state_reg[0] ), .B(state_reg[2]), .C(n6), 
         .D(n13244), .Z(s_axis_data_tready_next_N_934)) /* synthesis lut_function=(A (B (C))+!A (B (C)+!B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam i5295_4_lut_4_lut.init = 16'hd1c0;
    LUT4 mux_865_i2_4_lut_4_lut_4_lut (.A(\state_reg[0] ), .B(data_reg[0]), 
         .C(n14370), .D(n14374), .Z(n3042[1])) /* synthesis lut_function=(A (B (C (D)))+!A (B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam mux_865_i2_4_lut_4_lut_4_lut.init = 16'hc400;
    LUT4 mux_865_i7_4_lut_4_lut_4_lut (.A(\state_reg[0] ), .B(data_reg[5]), 
         .C(n14370), .D(n14374), .Z(n3042[6])) /* synthesis lut_function=(A (B (C (D)))+!A (B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam mux_865_i7_4_lut_4_lut_4_lut.init = 16'hc400;
    LUT4 mux_865_i6_4_lut_4_lut_4_lut (.A(\state_reg[0] ), .B(data_reg[4]), 
         .C(n14370), .D(n14374), .Z(n3042[5])) /* synthesis lut_function=(A (B (C (D)))+!A (B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam mux_865_i6_4_lut_4_lut_4_lut.init = 16'hc400;
    PFUMX mux_874_i6 (.BLUT(n296[5]), .ALUT(n3042[5]), .C0(n13424), .Z(data_next_7__N_843[5]));
    LUT4 mux_865_i4_4_lut_4_lut_4_lut (.A(\state_reg[0] ), .B(data_reg[2]), 
         .C(n14370), .D(n14374), .Z(n3042[3])) /* synthesis lut_function=(A (B (C (D)))+!A (B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam mux_865_i4_4_lut_4_lut_4_lut.init = 16'hc400;
    LUT4 mux_865_i8_4_lut_4_lut_4_lut (.A(\state_reg[0] ), .B(data_reg[6]), 
         .C(n14370), .D(n14374), .Z(n3042[7])) /* synthesis lut_function=(A (B (C (D)))+!A (B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam mux_865_i8_4_lut_4_lut_4_lut.init = 16'hc400;
    LUT4 mux_865_i3_4_lut_4_lut_4_lut (.A(\state_reg[0] ), .B(data_reg[1]), 
         .C(n14370), .D(n14374), .Z(n3042[2])) /* synthesis lut_function=(A (B (C (D)))+!A (B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam mux_865_i3_4_lut_4_lut_4_lut.init = 16'hc400;
    FD1S3IX s_axis_data_tready_reg_222 (.D(s_axis_data_tready_next_N_934), 
            .CK(int_clk_out), .CD(n6297), .Q(data_in_ready)) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam s_axis_data_tready_reg_222.GSR = "DISABLED";
    LUT4 i1_3_lut_4_lut_4_lut (.A(\state_reg[0] ), .B(n8188), .C(mode_read_reg), 
         .D(n14367), .Z(n23)) /* synthesis lut_function=(A (B)+!A (B+(C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam i1_3_lut_4_lut_4_lut.init = 16'hdccc;
    FD1P3AX bit_count_reg_i0 (.D(bit_count_next[0]), .SP(int_clk_out_enable_180), 
            .CK(int_clk_out), .Q(bit_count_reg[0])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam bit_count_reg_i0.GSR = "DISABLED";
    PFUMX mux_874_i7 (.BLUT(n296[6]), .ALUT(n3042[6]), .C0(n13424), .Z(data_next_7__N_843[6]));
    LUT4 mux_865_i5_4_lut_4_lut_4_lut (.A(\state_reg[0] ), .B(data_reg[3]), 
         .C(n14370), .D(n14374), .Z(n3042[4])) /* synthesis lut_function=(A (B (C (D)))+!A (B (D))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam mux_865_i5_4_lut_4_lut_4_lut.init = 16'hc400;
    FD1S3AY scl_i_filter_i0 (.D(fpga_scl_in), .CK(int_clk_out), .Q(scl_i_filter[0])) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam scl_i_filter_i0.GSR = "DISABLED";
    FD1S3JX m_axis_data_tlast_reg_225 (.D(n7314), .CK(int_clk_out), .PD(n14324), 
            .Q(data_out_last)) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam m_axis_data_tlast_reg_225.GSR = "DISABLED";
    FD1S3AY sda_i_filter_i0 (.D(fpga_sda_in), .CK(int_clk_out), .Q(sda_i_filter[0])) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam sda_i_filter_i0.GSR = "DISABLED";
    FD1P3AY scl_i_reg_228 (.D(scl_i_reg_N_956), .SP(int_clk_out_enable_21), 
            .CK(int_clk_out), .Q(scl_i_reg)) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam scl_i_reg_228.GSR = "DISABLED";
    FD1P3AY sda_i_reg_229 (.D(sda_i_reg_N_943), .SP(int_clk_out_enable_22), 
            .CK(int_clk_out), .Q(sda_i_reg)) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam sda_i_reg_229.GSR = "DISABLED";
    FD1S3AY last_scl_i_reg_232 (.D(scl_i_reg), .CK(int_clk_out), .Q(last_scl_i_reg)) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam last_scl_i_reg_232.GSR = "DISABLED";
    FD1S3AY last_sda_i_reg_233 (.D(sda_i_reg), .CK(int_clk_out), .Q(last_sda_i_reg)) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam last_sda_i_reg_233.GSR = "DISABLED";
    FD1S3IX m_axis_data_tvalid_reg_224 (.D(m_axis_data_tvalid_next), .CK(int_clk_out), 
            .CD(n14343), .Q(data_out_valid)) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam m_axis_data_tvalid_reg_224.GSR = "DISABLED";
    LUT4 i1_4_lut_adj_84 (.A(n12524), .B(data_reg[4]), .C(n12528), .D(n12526), 
         .Z(n11479)) /* synthesis lut_function=(A+((C+(D))+!B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(300[39:118])
    defparam i1_4_lut_adj_84.init = 16'hfffb;
    LUT4 i1_3_lut (.A(state_reg[2]), .B(\state_reg[0] ), .C(state_reg[1]), 
         .Z(n12562)) /* synthesis lut_function=(!(A ((C)+!B)+!A !(B (C)))) */ ;
    defparam i1_3_lut.init = 16'h4848;
    LUT4 scl_negedge_I_38_2_lut_rep_283 (.A(scl_i_reg), .B(last_scl_i_reg), 
         .Z(n14367)) /* synthesis lut_function=(!(A+!(B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(233[22:50])
    defparam scl_negedge_I_38_2_lut_rep_283.init = 16'h4444;
    PFUMX mux_874_i8 (.BLUT(n296[7]), .ALUT(n3042[7]), .C0(n13424), .Z(data_next_7__N_843[7]));
    FD1P3AX data_out_reg_valid_reg_218 (.D(n12272), .SP(int_clk_out_enable_25), 
            .CK(int_clk_out), .Q(data_out_reg_valid_reg)) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam data_out_reg_valid_reg_218.GSR = "DISABLED";
    LUT4 scl_negedge_I_0_2_lut_rep_234_3_lut (.A(scl_i_reg), .B(last_scl_i_reg), 
         .C(fpga_scl_out), .Z(n14318)) /* synthesis lut_function=(!(A (C)+!A !(B+!(C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(233[22:50])
    defparam scl_negedge_I_0_2_lut_rep_234_3_lut.init = 16'h4f4f;
    LUT4 data_valid_next_N_895_bdd_2_lut_10870_3_lut (.A(scl_i_reg), .B(last_scl_i_reg), 
         .C(state_reg[1]), .Z(n13966)) /* synthesis lut_function=(!(A+!(B (C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(233[22:50])
    defparam data_valid_next_N_895_bdd_2_lut_10870_3_lut.init = 16'h4040;
    LUT4 i1_2_lut_rep_208_3_lut_4_lut (.A(scl_i_reg), .B(last_scl_i_reg), 
         .C(data_valid_reg), .D(fpga_scl_out), .Z(n14292)) /* synthesis lut_function=(!(A ((D)+!C)+!A !(B (C)+!B !((D)+!C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(233[22:50])
    defparam i1_2_lut_rep_208_3_lut_4_lut.init = 16'h40f0;
    LUT4 i1_2_lut_rep_236_3_lut (.A(scl_i_reg), .B(last_scl_i_reg), .C(mode_read_reg), 
         .Z(n14320)) /* synthesis lut_function=(!(A+!(B (C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(233[22:50])
    defparam i1_2_lut_rep_236_3_lut.init = 16'h4040;
    FD1P3AX mode_read_reg_220 (.D(n13402), .SP(int_clk_out_enable_29), .CK(int_clk_out), 
            .Q(mode_read_reg)) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam mode_read_reg_220.GSR = "DISABLED";
    LUT4 i1_2_lut_adj_85 (.A(data_reg[2]), .B(data_reg[5]), .Z(n12524)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(300[39:118])
    defparam i1_2_lut_adj_85.init = 16'heeee;
    LUT4 mux_951_Mux_0_i7_4_lut (.A(\state_reg[0] ), .B(data_reg[7]), .C(state_reg[2]), 
         .D(state_reg[1]), .Z(sda_o_next_N_968)) /* synthesis lut_function=(A (B+((D)+!C))+!A (B (C)+!B (C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(282[9] 435[16])
    defparam mux_951_Mux_0_i7_4_lut.init = 16'hfaca;
    PFUMX i10963 (.BLUT(n14234), .ALUT(n14233), .C0(\state_reg[0] ), .Z(n14235));
    FD1P3AX data_reg_i0_i0 (.D(data_next_7__N_843[0]), .SP(int_clk_out_enable_188), 
            .CK(int_clk_out), .Q(data_reg[0])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam data_reg_i0_i0.GSR = "DISABLED";
    LUT4 i1_4_lut_adj_86 (.A(n14374), .B(n32), .C(n14324), .D(n14916), 
         .Z(int_clk_out_enable_36)) /* synthesis lut_function=(A (B+(C+(D)))+!A (B+(C))) */ ;
    defparam i1_4_lut_adj_86.init = 16'hfefc;
    LUT4 s_axis_data_tready_I_0_2_lut_rep_284 (.A(data_in_ready), .B(data_in_valid_reg), 
         .Z(n14368)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(377[21:61])
    defparam s_axis_data_tready_I_0_2_lut_rep_284.init = 16'h8888;
    LUT4 i6322_3_lut_3_lut_4_lut (.A(data_in_ready), .B(data_in_valid_reg), 
         .C(data_valid_reg), .D(\state_reg[0] ), .Z(n4)) /* synthesis lut_function=(!(A (B+(C+!(D)))+!A (C+!(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(377[21:61])
    defparam i6322_3_lut_3_lut_4_lut.init = 16'h0700;
    LUT4 i1_2_lut_rep_285 (.A(state_reg[1]), .B(state_reg[2]), .Z(n14369)) /* synthesis lut_function=(A+!(B)) */ ;
    defparam i1_2_lut_rep_285.init = 16'hbbbb;
    LUT4 i1_2_lut_adj_87 (.A(data_reg[0]), .B(data_reg[3]), .Z(n12528)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(300[39:118])
    defparam i1_2_lut_adj_87.init = 16'heeee;
    LUT4 i1_2_lut_3_lut_adj_88 (.A(state_reg[1]), .B(state_reg[2]), .C(\state_reg[0] ), 
         .Z(n6_adj_1177)) /* synthesis lut_function=(A (C)+!A !(B+!(C))) */ ;
    defparam i1_2_lut_3_lut_adj_88.init = 16'hb0b0;
    FD1P3AX m_axis_data_tdata_reg_i0_i0 (.D(data_reg[0]), .SP(int_clk_out_enable_195), 
            .CK(int_clk_out), .Q(data_out[0])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam m_axis_data_tdata_reg_i0_i0.GSR = "DISABLED";
    FD1P3JX scl_o_reg_230 (.D(scl_o_next_N_961), .SP(int_clk_out_enable_34), 
            .PD(n14343), .CK(int_clk_out), .Q(fpga_scl_out)) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam scl_o_reg_230.GSR = "DISABLED";
    PFUMX i10815 (.BLUT(n13966), .ALUT(n13965), .C0(\state_reg[0] ), .Z(n13967));
    LUT4 i37_4_lut (.A(n14374), .B(n14368), .C(\state_reg[0] ), .D(n14292), 
         .Z(n19)) /* synthesis lut_function=(A (B+((D)+!C))+!A (B (C)+!B (C (D)))) */ ;
    defparam i37_4_lut.init = 16'hfaca;
    LUT4 i1_4_lut_rep_286 (.A(bit_count_reg[2]), .B(bit_count_reg[1]), .C(bit_count_reg[0]), 
         .D(bit_count_reg[3]), .Z(n14370)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_rep_286.init = 16'hfffe;
    LUT4 i1944_2_lut_3_lut_4_lut (.A(bit_count_reg[2]), .B(bit_count_reg[1]), 
         .C(bit_count_reg[0]), .D(bit_count_reg[3]), .Z(n4_adj_1178)) /* synthesis lut_function=(A (B+(C))+!A (B+(C+!(D)))) */ ;
    defparam i1944_2_lut_3_lut_4_lut.init = 16'hfcfd;
    LUT4 i1_2_lut_rep_224_4_lut (.A(bit_count_reg[2]), .B(bit_count_reg[1]), 
         .C(bit_count_reg[0]), .D(bit_count_reg[3]), .Z(n14308)) /* synthesis lut_function=(A (C)+!A (B (C)+!B (C+!(D)))) */ ;
    defparam i1_2_lut_rep_224_4_lut.init = 16'hf0f1;
    LUT4 i1_3_lut_4_lut (.A(\state_reg[0] ), .B(state_reg[2]), .C(data_valid_reg), 
         .D(state_reg[1]), .Z(n12668)) /* synthesis lut_function=(!((B+!(C (D)))+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam i1_3_lut_4_lut.init = 16'h2000;
    FD1P3JX sda_o_reg_231 (.D(sda_o_next_N_968), .SP(int_clk_out_enable_35), 
            .PD(n14343), .CK(int_clk_out), .Q(fpga_sda_out)) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam sda_o_reg_231.GSR = "DISABLED";
    FD1P3AX data_valid_reg_217 (.D(n12249), .SP(int_clk_out_enable_36), 
            .CK(int_clk_out), .Q(data_valid_reg)) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam data_valid_reg_217.GSR = "DISABLED";
    LUT4 m_axis_data_tvalid_I_0_2_lut_rep_288 (.A(data_out_valid), .B(data_out_ready_reg), 
         .Z(n14372)) /* synthesis lut_function=(!((B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(337[25:66])
    defparam m_axis_data_tvalid_I_0_2_lut_rep_288.init = 16'h2222;
    LUT4 i5305_3_lut_4_lut (.A(data_out_valid), .B(data_out_ready_reg), 
         .C(state_reg[2]), .D(data_valid_reg), .Z(scl_o_next_N_961)) /* synthesis lut_function=(A (B ((D)+!C)+!B (C (D)))+!A ((D)+!C)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(337[25:66])
    defparam i5305_3_lut_4_lut.init = 16'hfd0d;
    LUT4 i1_2_lut_rep_289 (.A(scl_i_reg), .B(last_scl_i_reg), .Z(n14373)) /* synthesis lut_function=((B)+!A) */ ;
    defparam i1_2_lut_rep_289.init = 16'hdddd;
    PFUMX mux_865_i1 (.BLUT(n91[0]), .ALUT(n12211), .C0(state_reg[2]), 
          .Z(n3042[0]));
    LUT4 i2082_3_lut_4_lut_3_lut (.A(scl_i_reg), .B(last_scl_i_reg), .C(n3102), 
         .Z(n4095)) /* synthesis lut_function=(A (B+!(C))+!A ((C)+!B)) */ ;
    defparam i2082_3_lut_4_lut_3_lut.init = 16'hdbdb;
    LUT4 i1_2_lut_rep_237_3_lut (.A(scl_i_reg), .B(last_scl_i_reg), .C(n14370), 
         .Z(n14321)) /* synthesis lut_function=((B+(C))+!A) */ ;
    defparam i1_2_lut_rep_237_3_lut.init = 16'hfdfd;
    LUT4 scl_i_reg_I_0_284_2_lut_rep_290 (.A(scl_i_reg), .B(last_scl_i_reg), 
         .Z(n14374)) /* synthesis lut_function=(!((B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(232[22:50])
    defparam scl_i_reg_I_0_284_2_lut_rep_290.init = 16'h2222;
    LUT4 i1_2_lut_3_lut_4_lut (.A(scl_i_reg), .B(last_scl_i_reg), .C(sda_i_reg), 
         .D(\state_reg[0] ), .Z(n11584)) /* synthesis lut_function=(!((B+(C+!(D)))+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(232[22:50])
    defparam i1_2_lut_3_lut_4_lut.init = 16'h0200;
    FD1S3IX state_reg__i2 (.D(n11155), .CK(int_clk_out), .CD(n12184), 
            .Q(state_reg[1])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam state_reg__i2.GSR = "DISABLED";
    LUT4 i1_2_lut_3_lut_4_lut_adj_89 (.A(scl_i_reg), .B(last_scl_i_reg), 
         .C(state_reg[2]), .D(\state_reg[0] ), .Z(n12584)) /* synthesis lut_function=(!((B+(C+!(D)))+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(232[22:50])
    defparam i1_2_lut_3_lut_4_lut_adj_89.init = 16'h0200;
    LUT4 i10674_2_lut_rep_238_3_lut (.A(scl_i_reg), .B(last_scl_i_reg), 
         .C(sda_i_reg), .Z(n14322)) /* synthesis lut_function=((B+!(C))+!A) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(232[22:50])
    defparam i10674_2_lut_rep_238_3_lut.init = 16'hdfdf;
    LUT4 i6088_2_lut_3_lut_4_lut (.A(scl_i_reg), .B(last_scl_i_reg), .C(sda_i_reg), 
         .D(n14370), .Z(n91[0])) /* synthesis lut_function=(!((B+!(C (D)))+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(232[22:50])
    defparam i6088_2_lut_3_lut_4_lut.init = 16'h2000;
    LUT4 i1_2_lut_3_lut_4_lut_adj_90 (.A(scl_i_reg), .B(last_scl_i_reg), 
         .C(\state_reg[0] ), .D(n14370), .Z(n13)) /* synthesis lut_function=(!((B+!(C (D)))+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(232[22:50])
    defparam i1_2_lut_3_lut_4_lut_adj_90.init = 16'h2000;
    LUT4 i1_3_lut_rep_212_4_lut (.A(n14367), .B(fpga_scl_out), .C(state_reg[1]), 
         .D(n14372), .Z(n14296)) /* synthesis lut_function=(!(A ((D)+!C)+!A (B+((D)+!C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(335[21:46])
    defparam i1_3_lut_rep_212_4_lut.init = 16'h00b0;
    LUT4 i1_2_lut_rep_291 (.A(state_reg[2]), .B(state_reg[1]), .Z(n14375)) /* synthesis lut_function=(A+!(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam i1_2_lut_rep_291.init = 16'hbbbb;
    LUT4 i1_4_lut_3_lut (.A(state_reg[2]), .B(state_reg[1]), .C(\state_reg[0] ), 
         .Z(n14)) /* synthesis lut_function=(A ((C)+!B)+!A !(B (C)+!B !(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam i1_4_lut_3_lut.init = 16'hb6b6;
    PFUMX mux_964_Mux_0_i6 (.BLUT(n4), .ALUT(n11584), .C0(state_reg[1]), 
          .Z(n6));
    LUT4 sda_i_reg_I_0_2_lut_rep_295 (.A(sda_i_reg), .B(last_sda_i_reg), 
         .Z(n14379)) /* synthesis lut_function=(!((B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(234[22:50])
    defparam sda_i_reg_I_0_2_lut_rep_295.init = 16'h2222;
    LUT4 sda_posedge_I_0_2_lut_rep_245_3_lut (.A(sda_i_reg), .B(last_sda_i_reg), 
         .C(scl_i_reg), .Z(n14329)) /* synthesis lut_function=(!((B+!(C))+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(234[22:50])
    defparam sda_posedge_I_0_2_lut_rep_245_3_lut.init = 16'h2020;
    LUT4 i8755_3_lut_rep_240_4_lut_3_lut (.A(sda_i_reg), .B(last_sda_i_reg), 
         .C(scl_i_reg), .Z(n14324)) /* synthesis lut_function=(!(A (B+!(C))+!A !(B (C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(235[22:50])
    defparam i8755_3_lut_rep_240_4_lut_3_lut.init = 16'h6060;
    LUT4 sda_negedge_I_0_2_lut_3_lut (.A(sda_i_reg), .B(last_sda_i_reg), 
         .C(scl_i_reg), .Z(start_bit)) /* synthesis lut_function=(!(A+!(B (C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(235[22:50])
    defparam sda_negedge_I_0_2_lut_3_lut.init = 16'h4040;
    LUT4 i1_2_lut_rep_297 (.A(\state_reg[0] ), .B(state_reg[1]), .Z(n14381)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam i1_2_lut_rep_297.init = 16'heeee;
    LUT4 i1_2_lut_rep_242_3_lut (.A(\state_reg[0] ), .B(state_reg[1]), .C(state_reg[2]), 
         .Z(n14326)) /* synthesis lut_function=(A+(B+(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam i1_2_lut_rep_242_3_lut.init = 16'hfefe;
    LUT4 i1_2_lut_3_lut_4_lut_adj_91 (.A(\state_reg[0] ), .B(state_reg[1]), 
         .C(state_reg[2]), .D(n14323), .Z(n6480)) /* synthesis lut_function=(A+(B+((D)+!C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam i1_2_lut_3_lut_4_lut_adj_91.init = 16'hffef;
    LUT4 i10679_3_lut_4_lut (.A(n14367), .B(fpga_scl_out), .C(n12664), 
         .D(n14324), .Z(int_clk_out_enable_195)) /* synthesis lut_function=(!(A (C+(D))+!A (B+(C+(D))))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(335[21:46])
    defparam i10679_3_lut_4_lut.init = 16'h000b;
    LUT4 scl_i_filter_1__bdd_4_lut (.A(scl_i_filter[1]), .B(scl_i_filter[3]), 
         .C(scl_i_filter[0]), .D(scl_i_filter[2]), .Z(int_clk_out_enable_21)) /* synthesis lut_function=(A (B (C (D)))+!A !(B+(C+(D)))) */ ;
    defparam scl_i_filter_1__bdd_4_lut.init = 16'h8001;
    LUT4 sda_i_filter_0__bdd_4_lut (.A(sda_i_filter[0]), .B(sda_i_filter[3]), 
         .C(sda_i_filter[1]), .D(sda_i_filter[2]), .Z(int_clk_out_enable_22)) /* synthesis lut_function=(A (B (C (D)))+!A !(B+(C+(D)))) */ ;
    defparam sda_i_filter_0__bdd_4_lut.init = 16'h8001;
    LUT4 i4350_3_lut_4_lut (.A(n14367), .B(fpga_scl_out), .C(data_out_last), 
         .D(n12664), .Z(n7314)) /* synthesis lut_function=(A (C (D))+!A (B (C)+!B (C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(335[21:46])
    defparam i4350_3_lut_4_lut.init = 16'hf040;
    LUT4 i1_3_lut_4_lut_adj_92 (.A(n14367), .B(fpga_scl_out), .C(n14370), 
         .D(data_valid_reg), .Z(n11865)) /* synthesis lut_function=(A (C+!(D))+!A (B+(C+!(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(335[21:46])
    defparam i1_3_lut_4_lut_adj_92.init = 16'hf4ff;
    FD1P3AX bit_count_reg_i1 (.D(bit_count_next[1]), .SP(int_clk_out_enable_180), 
            .CK(int_clk_out), .Q(bit_count_reg[1])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam bit_count_reg_i1.GSR = "DISABLED";
    FD1P3AX bit_count_reg_i2 (.D(bit_count_next[2]), .SP(int_clk_out_enable_180), 
            .CK(int_clk_out), .Q(bit_count_reg[2])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam bit_count_reg_i2.GSR = "DISABLED";
    FD1P3IX bit_count_reg_i3 (.D(n9276), .SP(int_clk_out_enable_181), .CD(start_bit), 
            .CK(int_clk_out), .Q(bit_count_reg[3])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam bit_count_reg_i3.GSR = "DISABLED";
    FD1S3AY scl_i_filter_i1 (.D(scl_i_filter[0]), .CK(int_clk_out), .Q(scl_i_filter[1])) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam scl_i_filter_i1.GSR = "DISABLED";
    FD1S3AY scl_i_filter_i2 (.D(scl_i_filter[1]), .CK(int_clk_out), .Q(scl_i_filter[2])) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam scl_i_filter_i2.GSR = "DISABLED";
    FD1S3AY scl_i_filter_i3 (.D(scl_i_filter[2]), .CK(int_clk_out), .Q(scl_i_filter[3])) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam scl_i_filter_i3.GSR = "DISABLED";
    FD1S3AY sda_i_filter_i1 (.D(sda_i_filter[0]), .CK(int_clk_out), .Q(sda_i_filter[1])) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam sda_i_filter_i1.GSR = "DISABLED";
    FD1S3AY sda_i_filter_i2 (.D(sda_i_filter[1]), .CK(int_clk_out), .Q(sda_i_filter[2])) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam sda_i_filter_i2.GSR = "DISABLED";
    FD1S3AY sda_i_filter_i3 (.D(sda_i_filter[2]), .CK(int_clk_out), .Q(sda_i_filter[3])) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam sda_i_filter_i3.GSR = "DISABLED";
    FD1P3AX data_reg_i0_i1 (.D(data_next_7__N_843[1]), .SP(int_clk_out_enable_188), 
            .CK(int_clk_out), .Q(data_reg[1])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam data_reg_i0_i1.GSR = "DISABLED";
    LUT4 n11614_bdd_3_lut_4_lut (.A(n14370), .B(n14373), .C(state_reg[1]), 
         .D(n14178), .Z(n14265)) /* synthesis lut_function=(!(A ((D)+!C)+!A (B ((D)+!C)+!B (C (D))))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(181[11:20])
    defparam n11614_bdd_3_lut_4_lut.init = 16'h01f1;
    LUT4 n3759_bdd_4_lut_10962 (.A(n14296), .B(n14322), .C(state_reg[1]), 
         .D(state_reg[2]), .Z(n14233)) /* synthesis lut_function=(A (B+!(C (D)))+!A (B (D)+!B !(C+!(D)))) */ ;
    defparam n3759_bdd_4_lut_10962.init = 16'hcfaa;
    LUT4 i1_3_lut_4_lut_4_lut_adj_93 (.A(state_reg[1]), .B(\state_reg[0] ), 
         .C(data_in_valid_reg), .D(data_in_ready), .Z(n12227)) /* synthesis lut_function=(!(A+!(B (C (D))))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam i1_3_lut_4_lut_4_lut_adj_93.init = 16'h4000;
    LUT4 i10394_3_lut_4_lut_4_lut (.A(state_reg[1]), .B(n3785[1]), .C(last_scl_i_reg), 
         .D(scl_i_reg), .Z(n13386)) /* synthesis lut_function=(A (C+!(D))+!A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam i10394_3_lut_4_lut_4_lut.init = 16'he4ee;
    LUT4 mux_874_i1_3_lut_4_lut (.A(sda_i_reg), .B(n14374), .C(\state_reg[0] ), 
         .D(n3042[0]), .Z(data_next_7__N_843[0])) /* synthesis lut_function=(A (B ((D)+!C)+!B (C (D)))+!A (C (D))) */ ;
    defparam mux_874_i1_3_lut_4_lut.init = 16'hf808;
    LUT4 n3759_bdd_4_lut (.A(n14320), .B(n14321), .C(state_reg[1]), .D(state_reg[2]), 
         .Z(n14234)) /* synthesis lut_function=(A (B+(C))+!A (B ((D)+!C)+!B (C (D)))) */ ;
    defparam n3759_bdd_4_lut.init = 16'hfcac;
    LUT4 i5385_3_lut_4_lut (.A(sda_i_reg), .B(n14374), .C(state_reg[2]), 
         .D(n8344), .Z(n3789[0])) /* synthesis lut_function=(!(A (B (C+!(D))+!B !(C+(D)))+!A !(C+(D)))) */ ;
    defparam i5385_3_lut_4_lut.init = 16'h7f70;
    LUT4 i1_3_lut_rep_239 (.A(n14370), .B(scl_i_reg), .C(last_scl_i_reg), 
         .Z(n14323)) /* synthesis lut_function=(A+((C)+!B)) */ ;
    defparam i1_3_lut_rep_239.init = 16'hfbfb;
    LUT4 i1_2_lut_rep_213_4_lut (.A(n14370), .B(scl_i_reg), .C(last_scl_i_reg), 
         .D(n14381), .Z(n14297)) /* synthesis lut_function=(A+((C+(D))+!B)) */ ;
    defparam i1_2_lut_rep_213_4_lut.init = 16'hfffb;
    FD1P3AX data_reg_i0_i2 (.D(data_next_7__N_843[2]), .SP(int_clk_out_enable_188), 
            .CK(int_clk_out), .Q(data_reg[2])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam data_reg_i0_i2.GSR = "DISABLED";
    FD1P3AX data_reg_i0_i3 (.D(data_next_7__N_843[3]), .SP(int_clk_out_enable_188), 
            .CK(int_clk_out), .Q(data_reg[3])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam data_reg_i0_i3.GSR = "DISABLED";
    FD1P3AX data_reg_i0_i4 (.D(data_next_7__N_843[4]), .SP(int_clk_out_enable_188), 
            .CK(int_clk_out), .Q(data_reg[4])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam data_reg_i0_i4.GSR = "DISABLED";
    FD1P3AX data_reg_i0_i5 (.D(data_next_7__N_843[5]), .SP(int_clk_out_enable_188), 
            .CK(int_clk_out), .Q(data_reg[5])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam data_reg_i0_i5.GSR = "DISABLED";
    FD1P3AX data_reg_i0_i6 (.D(data_next_7__N_843[6]), .SP(int_clk_out_enable_188), 
            .CK(int_clk_out), .Q(data_reg[6])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam data_reg_i0_i6.GSR = "DISABLED";
    FD1P3AX data_reg_i0_i7 (.D(data_next_7__N_843[7]), .SP(int_clk_out_enable_188), 
            .CK(int_clk_out), .Q(data_reg[7])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam data_reg_i0_i7.GSR = "DISABLED";
    FD1P3AX m_axis_data_tdata_reg_i0_i1 (.D(data_reg[1]), .SP(int_clk_out_enable_195), 
            .CK(int_clk_out), .Q(data_out[1])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam m_axis_data_tdata_reg_i0_i1.GSR = "DISABLED";
    FD1P3AX m_axis_data_tdata_reg_i0_i2 (.D(data_reg[2]), .SP(int_clk_out_enable_195), 
            .CK(int_clk_out), .Q(data_out[2])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam m_axis_data_tdata_reg_i0_i2.GSR = "DISABLED";
    FD1P3AX m_axis_data_tdata_reg_i0_i3 (.D(data_reg[3]), .SP(int_clk_out_enable_195), 
            .CK(int_clk_out), .Q(data_out[3])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam m_axis_data_tdata_reg_i0_i3.GSR = "DISABLED";
    FD1P3AX m_axis_data_tdata_reg_i0_i4 (.D(data_reg[4]), .SP(int_clk_out_enable_195), 
            .CK(int_clk_out), .Q(data_out[4])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam m_axis_data_tdata_reg_i0_i4.GSR = "DISABLED";
    FD1P3AX m_axis_data_tdata_reg_i0_i5 (.D(data_reg[5]), .SP(int_clk_out_enable_195), 
            .CK(int_clk_out), .Q(data_out[5])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam m_axis_data_tdata_reg_i0_i5.GSR = "DISABLED";
    FD1P3AX m_axis_data_tdata_reg_i0_i6 (.D(data_reg[6]), .SP(int_clk_out_enable_195), 
            .CK(int_clk_out), .Q(data_out[6])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam m_axis_data_tdata_reg_i0_i6.GSR = "DISABLED";
    FD1P3AX m_axis_data_tdata_reg_i0_i7 (.D(data_reg[7]), .SP(int_clk_out_enable_195), 
            .CK(int_clk_out), .Q(data_out[7])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam m_axis_data_tdata_reg_i0_i7.GSR = "DISABLED";
    LUT4 i1_2_lut_4_lut (.A(n14), .B(n4108), .C(n14329), .D(start_bit), 
         .Z(int_clk_out_enable_180)) /* synthesis lut_function=(A (B (D)+!B ((D)+!C))+!A (D)) */ ;
    defparam i1_2_lut_4_lut.init = 16'hff02;
    LUT4 i10712_3_lut_4_lut (.A(state_reg[2]), .B(n14381), .C(stm_fpga_spare5_c), 
         .D(n14324), .Z(n12184)) /* synthesis lut_function=(A ((D)+!C)+!A (((D)+!C)+!B)) */ ;
    defparam i10712_3_lut_4_lut.init = 16'hff1f;
    LUT4 i10717_2_lut_4_lut_4_lut (.A(scl_i_reg), .B(sda_i_reg), .C(last_sda_i_reg), 
         .D(n14369), .Z(n12249)) /* synthesis lut_function=(!(A (B ((D)+!C)+!B (C+(D)))+!A (D))) */ ;
    defparam i10717_2_lut_4_lut_4_lut.init = 16'h00d7;
    LUT4 i10746_2_lut_rep_211_4_lut_4_lut (.A(scl_i_reg), .B(sda_i_reg), 
         .C(last_sda_i_reg), .D(state_reg[1]), .Z(int_clk_out_enable_29)) /* synthesis lut_function=(!(A (B ((D)+!C)+!B (C+(D)))+!A (D))) */ ;
    defparam i10746_2_lut_rep_211_4_lut_4_lut.init = 16'h00d7;
    LUT4 i2_2_lut_4_lut_4_lut_4_lut (.A(stm_fpga_spare5_c), .B(sda_i_reg), 
         .C(last_sda_i_reg), .D(scl_i_reg), .Z(n6297)) /* synthesis lut_function=(!(A (B (C+!(D))+!B !(C (D))))) */ ;
    defparam i2_2_lut_4_lut_4_lut_4_lut.init = 16'h7d55;
    LUT4 mux_90_i2_4_lut_4_lut (.A(n14292), .B(n14368), .C(data_in_reg[1]), 
         .D(data_reg[0]), .Z(n296[1])) /* synthesis lut_function=(A (D)+!A (B (C))) */ ;
    defparam mux_90_i2_4_lut_4_lut.init = 16'hea40;
    LUT4 n11614_bdd_3_lut_10983_4_lut (.A(last_scl_i_reg), .B(mode_read_reg), 
         .C(state_reg[2]), .D(scl_i_reg), .Z(n14178)) /* synthesis lut_function=(!(((C+(D))+!B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(233[22:50])
    defparam n11614_bdd_3_lut_10983_4_lut.init = 16'h0008;
    LUT4 i1_3_lut_4_lut_adj_94 (.A(last_scl_i_reg), .B(mode_read_reg), .C(state_reg[1]), 
         .D(scl_i_reg), .Z(n13244)) /* synthesis lut_function=(!((((D)+!C)+!B)+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(233[22:50])
    defparam i1_3_lut_4_lut_adj_94.init = 16'h0080;
    LUT4 i5291_4_lut (.A(n14323), .B(n12346), .C(\state_reg[0] ), .D(n14318), 
         .Z(n3785[1])) /* synthesis lut_function=(A (B (C (D)))+!A (B ((D)+!C)+!B !(C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(181[11:20])
    defparam i5291_4_lut.init = 16'hc505;
    LUT4 i1_2_lut_adj_95 (.A(n14370), .B(data_valid_reg), .Z(n12346)) /* synthesis lut_function=(!(A+!(B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam i1_2_lut_adj_95.init = 16'h4444;
    LUT4 i10393_4_lut_then_4_lut (.A(last_scl_i_reg), .B(scl_i_reg), .C(n14372), 
         .D(fpga_scl_out), .Z(n14405)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (C+(D))) */ ;
    defparam i10393_4_lut_then_4_lut.init = 16'hfdf0;
    LUT4 i10393_4_lut_else_4_lut (.A(last_scl_i_reg), .B(scl_i_reg), .C(n11479), 
         .D(n14370), .Z(n14404)) /* synthesis lut_function=(!(A+((C+(D))+!B))) */ ;
    defparam i10393_4_lut_else_4_lut.init = 16'h0004;
    LUT4 mux_90_i8_4_lut_4_lut (.A(n14292), .B(n14368), .C(data_in_reg[7]), 
         .D(data_reg[6]), .Z(n296[7])) /* synthesis lut_function=(A (D)+!A (B (C))) */ ;
    defparam mux_90_i8_4_lut_4_lut.init = 16'hea40;
    LUT4 i1_3_lut_3_lut_4_lut (.A(n14318), .B(data_valid_reg), .C(n14368), 
         .D(data_in_reg[0]), .Z(n12211)) /* synthesis lut_function=(!(A (B+!(C (D)))+!A !(C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam i1_3_lut_3_lut_4_lut.init = 16'h7000;
    LUT4 i9_1_lut_rep_259 (.A(stm_fpga_spare5_c), .Z(n14343)) /* synthesis lut_function=(!(A)) */ ;
    defparam i9_1_lut_rep_259.init = 16'h5555;
    LUT4 mux_1077_i1_4_lut (.A(n11865), .B(n14367), .C(state_reg[1]), 
         .D(\state_reg[0] ), .Z(n3793[0])) /* synthesis lut_function=(A (B (C+(D))+!B !(C+!(D)))+!A (B (C))) */ ;
    defparam mux_1077_i1_4_lut.init = 16'hcac0;
    LUT4 mux_90_i5_4_lut_4_lut (.A(n14292), .B(n14368), .C(data_in_reg[4]), 
         .D(data_reg[3]), .Z(n296[4])) /* synthesis lut_function=(A (D)+!A (B (C))) */ ;
    defparam mux_90_i5_4_lut_4_lut.init = 16'hea40;
    LUT4 i6138_2_lut_2_lut (.A(stm_fpga_spare5_c), .B(wb_dat_o[1]), .Z(\tx_lvds_test_pattern_31__N_119[25] )) /* synthesis lut_function=((B)+!A) */ ;
    defparam i6138_2_lut_2_lut.init = 16'hdddd;
    LUT4 i1_2_lut_2_lut (.A(stm_fpga_spare5_c), .B(int_clk_out_enable_55), 
         .Z(int_clk_out_enable_62)) /* synthesis lut_function=((B)+!A) */ ;
    defparam i1_2_lut_2_lut.init = 16'hdddd;
    LUT4 i1_4_lut_4_lut_adj_96 (.A(stm_fpga_spare5_c), .B(n13358), .C(n11958), 
         .D(n13056), .Z(int_clk_out_enable_28)) /* synthesis lut_function=(!(A (B+(C+!(D))))) */ ;
    defparam i1_4_lut_4_lut_adj_96.init = 16'h5755;
    LUT4 i1_2_lut_2_lut_adj_97 (.A(stm_fpga_spare5_c), .B(int_clk_out_enable_111), 
         .Z(int_clk_out_enable_114)) /* synthesis lut_function=((B)+!A) */ ;
    defparam i1_2_lut_2_lut_adj_97.init = 16'hdddd;
    LUT4 i1_2_lut_2_lut_adj_98 (.A(stm_fpga_spare5_c), .B(int_clk_out_enable_39), 
         .Z(int_clk_out_enable_46)) /* synthesis lut_function=((B)+!A) */ ;
    defparam i1_2_lut_2_lut_adj_98.init = 16'hdddd;
    LUT4 i1_4_lut_4_lut_adj_99 (.A(stm_fpga_spare5_c), .B(n12886), .C(n11601), 
         .D(n13286), .Z(int_clk_out_enable_69)) /* synthesis lut_function=(!(A (((D)+!C)+!B))) */ ;
    defparam i1_4_lut_4_lut_adj_99.init = 16'h55d5;
    LUT4 i1_3_lut_4_lut_4_lut_adj_100 (.A(stm_fpga_spare5_c), .B(n13382), 
         .C(n14332), .D(n14333), .Z(int_clk_out_enable_150)) /* synthesis lut_function=(!(A (B+((D)+!C)))) */ ;
    defparam i1_3_lut_4_lut_4_lut_adj_100.init = 16'h5575;
    LUT4 stm_fpga_spare5_N_2_I_0_2_lut_2_lut (.A(stm_fpga_spare5_c), .B(led_rst), 
         .Z(fpga_led_N_383)) /* synthesis lut_function=((B)+!A) */ ;
    defparam stm_fpga_spare5_N_2_I_0_2_lut_2_lut.init = 16'hdddd;
    LUT4 i1_2_lut_3_lut_4_lut_4_lut (.A(stm_fpga_spare5_c), .B(n6568), .C(n14386), 
         .D(\wb_adr_o[2] ), .Z(int_clk_out_enable_121)) /* synthesis lut_function=(!(A (((D)+!C)+!B))) */ ;
    defparam i1_2_lut_3_lut_4_lut_4_lut.init = 16'h55d5;
    LUT4 i6139_2_lut_2_lut (.A(stm_fpga_spare5_c), .B(wb_dat_o[6]), .Z(\tx_lvds_test_pattern_31__N_119[6] )) /* synthesis lut_function=((B)+!A) */ ;
    defparam i6139_2_lut_2_lut.init = 16'hdddd;
    LUT4 i1_2_lut_2_lut_adj_101 (.A(stm_fpga_spare5_c), .B(int_clk_out_enable_54), 
         .Z(int_clk_out_enable_53)) /* synthesis lut_function=((B)+!A) */ ;
    defparam i1_2_lut_2_lut_adj_101.init = 16'hdddd;
    LUT4 i6137_2_lut_2_lut (.A(stm_fpga_spare5_c), .B(wb_dat_o[2]), .Z(\tx_lvds_test_pattern_31__N_119[26] )) /* synthesis lut_function=((B)+!A) */ ;
    defparam i6137_2_lut_2_lut.init = 16'hdddd;
    LUT4 data_valid_next_N_895_bdd_4_lut_10869 (.A(n14318), .B(state_reg[1]), 
         .C(data_valid_reg), .D(state_reg[2]), .Z(n13965)) /* synthesis lut_function=(!((B (D)+!B !(C (D)))+!A)) */ ;
    defparam data_valid_next_N_895_bdd_4_lut_10869.init = 16'h2088;
    LUT4 i1_4_lut_4_lut_adj_102 (.A(stm_fpga_spare5_c), .B(n12850), .C(n12212), 
         .D(n14301), .Z(int_clk_out_enable_27)) /* synthesis lut_function=(!(A ((C+!(D))+!B))) */ ;
    defparam i1_4_lut_4_lut_adj_102.init = 16'h5d55;
    LUT4 i1_4_lut_4_lut_adj_103 (.A(stm_fpga_spare5_c), .B(n14332), .C(n13382), 
         .D(n14331), .Z(int_clk_out_enable_164)) /* synthesis lut_function=(!(A ((C+!(D))+!B))) */ ;
    defparam i1_4_lut_4_lut_adj_103.init = 16'h5d55;
    LUT4 i1_4_lut_4_lut_adj_104 (.A(stm_fpga_spare5_c), .B(n12212), .C(n12874), 
         .D(n14332), .Z(int_clk_out_enable_171)) /* synthesis lut_function=(!(A (B+!(C (D))))) */ ;
    defparam i1_4_lut_4_lut_adj_104.init = 16'h7555;
    LUT4 i1_2_lut_2_lut_adj_105 (.A(stm_fpga_spare5_c), .B(int_clk_out_enable_107), 
         .Z(int_clk_out_enable_106)) /* synthesis lut_function=((B)+!A) */ ;
    defparam i1_2_lut_2_lut_adj_105.init = 16'hdddd;
    LUT4 i1_2_lut_3_lut_adj_106 (.A(state_reg[1]), .B(n14324), .C(n22), 
         .Z(int_clk_out_enable_188)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;
    defparam i1_2_lut_3_lut_adj_106.init = 16'h1010;
    LUT4 i6119_2_lut_2_lut (.A(stm_fpga_spare5_c), .B(wb_dat_o[0]), .Z(\ufl_p7_sel_7__N_35[0] )) /* synthesis lut_function=((B)+!A) */ ;
    defparam i6119_2_lut_2_lut.init = 16'hdddd;
    LUT4 i1_4_lut_4_lut_adj_107 (.A(stm_fpga_spare5_c), .B(n12964), .C(n11958), 
         .D(n12966), .Z(int_clk_out_enable_212)) /* synthesis lut_function=(!(A ((C+!(D))+!B))) */ ;
    defparam i1_4_lut_4_lut_adj_107.init = 16'h5d55;
    LUT4 i1_3_lut_rep_182_4_lut (.A(n14379), .B(scl_i_reg), .C(n4108), 
         .D(n14), .Z(int_clk_out_enable_181)) /* synthesis lut_function=(!(A (B+(C+!(D)))+!A (C+!(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(238[19:43])
    defparam i1_3_lut_rep_182_4_lut.init = 16'h0700;
    LUT4 mux_90_i3_4_lut_4_lut (.A(n14292), .B(n14368), .C(data_in_reg[2]), 
         .D(data_reg[1]), .Z(n296[2])) /* synthesis lut_function=(A (D)+!A (B (C))) */ ;
    defparam mux_90_i3_4_lut_4_lut.init = 16'hea40;
    LUT4 i1_2_lut_3_lut_4_lut_4_lut_adj_108 (.A(stm_fpga_spare5_c), .B(n6568), 
         .C(n14385), .D(\wb_adr_o[2] ), .Z(int_clk_out_enable_128)) /* synthesis lut_function=(!(A (((D)+!C)+!B))) */ ;
    defparam i1_2_lut_3_lut_4_lut_4_lut_adj_108.init = 16'h55d5;
    LUT4 i1_4_lut_4_lut_adj_109 (.A(stm_fpga_spare5_c), .B(n12562), .C(n14324), 
         .D(n14318), .Z(int_clk_out_enable_34)) /* synthesis lut_function=(!(A ((C+!(D))+!B))) */ ;
    defparam i1_4_lut_4_lut_adj_109.init = 16'h5d55;
    LUT4 i1_2_lut_2_lut_adj_110 (.A(stm_fpga_spare5_c), .B(int_clk_out_enable_83), 
         .Z(int_clk_out_enable_84)) /* synthesis lut_function=((B)+!A) */ ;
    defparam i1_2_lut_2_lut_adj_110.init = 16'hdddd;
    LUT4 mux_90_i7_4_lut_4_lut (.A(n14292), .B(n14368), .C(data_in_reg[6]), 
         .D(data_reg[5]), .Z(n296[6])) /* synthesis lut_function=(A (D)+!A (B (C))) */ ;
    defparam mux_90_i7_4_lut_4_lut.init = 16'hea40;
    LUT4 i1_3_lut_3_lut (.A(stm_fpga_spare5_c), .B(n13967), .C(n14324), 
         .Z(int_clk_out_enable_35)) /* synthesis lut_function=(!(A ((C)+!B))) */ ;
    defparam i1_3_lut_3_lut.init = 16'h5d5d;
    LUT4 i6093_4_lut (.A(n14329), .B(start_bit), .C(n3797[0]), .D(n14326), 
         .Z(state_next[0])) /* synthesis lut_function=(A (B)+!A (B+(C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(273[14] 436[8])
    defparam i6093_4_lut.init = 16'hdccc;
    LUT4 i1_2_lut_2_lut_adj_111 (.A(stm_fpga_spare5_c), .B(int_clk_out_enable_77), 
         .Z(int_clk_out_enable_76)) /* synthesis lut_function=((B)+!A) */ ;
    defparam i1_2_lut_2_lut_adj_111.init = 16'hdddd;
    LUT4 mux_90_i6_4_lut_4_lut (.A(n14292), .B(n14368), .C(data_in_reg[5]), 
         .D(data_reg[4]), .Z(n296[5])) /* synthesis lut_function=(A (D)+!A (B (C))) */ ;
    defparam mux_90_i6_4_lut_4_lut.init = 16'hea40;
    LUT4 i1_4_lut_adj_112 (.A(bit_count_reg[1]), .B(n4111), .C(start_bit), 
         .D(n14308), .Z(bit_count_next[1])) /* synthesis lut_function=(A (B+(C+(D)))+!A (B+(C+!(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(273[14] 436[8])
    defparam i1_4_lut_adj_112.init = 16'hfefd;
    LUT4 i1_4_lut_adj_113 (.A(bit_count_reg[2]), .B(n4111), .C(start_bit), 
         .D(n4_adj_1178), .Z(bit_count_next[2])) /* synthesis lut_function=(A (B+(C+(D)))+!A (B+(C+!(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(273[14] 436[8])
    defparam i1_4_lut_adj_113.init = 16'hfefd;
    LUT4 i10655_1_lut_3_lut (.A(n14406), .B(n13386), .C(state_reg[2]), 
         .Z(n13560)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(181[11:20])
    defparam i10655_1_lut_3_lut.init = 16'hcaca;
    LUT4 i6134_2_lut_2_lut (.A(stm_fpga_spare5_c), .B(wb_dat_o[7]), .Z(\tx_lvds_test_pattern_31__N_119[31] )) /* synthesis lut_function=((B)+!A) */ ;
    defparam i6134_2_lut_2_lut.init = 16'hdddd;
    LUT4 i1_2_lut_2_lut_adj_114 (.A(stm_fpga_spare5_c), .B(int_clk_out_enable_99), 
         .Z(int_clk_out_enable_98)) /* synthesis lut_function=((B)+!A) */ ;
    defparam i1_2_lut_2_lut_adj_114.init = 16'hdddd;
    FD1S3IX state_reg__i3 (.D(n14235), .CK(int_clk_out), .CD(n12184), 
            .Q(state_reg[2])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=16, LSE_LCOL=1, LSE_RCOL=2, LSE_LLINE=455, LSE_RLINE=490 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam state_reg__i3.GSR = "DISABLED";
    LUT4 i6136_2_lut_2_lut (.A(stm_fpga_spare5_c), .B(wb_dat_o[3]), .Z(\tx_lvds_test_pattern_31__N_119[27] )) /* synthesis lut_function=((B)+!A) */ ;
    defparam i6136_2_lut_2_lut.init = 16'hdddd;
    LUT4 i6140_2_lut_2_lut (.A(stm_fpga_spare5_c), .B(wb_dat_o[5]), .Z(\spi3_test_pattern_15__N_83[13] )) /* synthesis lut_function=((B)+!A) */ ;
    defparam i6140_2_lut_2_lut.init = 16'hdddd;
    LUT4 i10723_4_lut (.A(bit_count_reg[3]), .B(n4111), .C(bit_count_reg[2]), 
         .D(n4_adj_1178), .Z(n9276)) /* synthesis lut_function=(!(A (B+!(C+(D)))+!A (B+(C+(D))))) */ ;
    defparam i10723_4_lut.init = 16'h2221;
    LUT4 mux_90_i4_4_lut_4_lut (.A(n14292), .B(n14368), .C(data_in_reg[3]), 
         .D(data_reg[2]), .Z(n296[3])) /* synthesis lut_function=(A (D)+!A (B (C))) */ ;
    defparam mux_90_i4_4_lut_4_lut.init = 16'hea40;
    LUT4 i6135_2_lut_2_lut (.A(stm_fpga_spare5_c), .B(wb_dat_o[4]), .Z(\tx_lvds_test_pattern_31__N_119[28] )) /* synthesis lut_function=((B)+!A) */ ;
    defparam i6135_2_lut_2_lut.init = 16'hdddd;
    PFUMX i28 (.BLUT(n14265), .ALUT(n13560), .C0(\state_reg[0] ), .Z(n11155));
    LUT4 i5227_3_lut_4_lut (.A(n14372), .B(n14318), .C(state_reg[1]), 
         .D(\state_reg[0] ), .Z(n8188)) /* synthesis lut_function=(!(A (C+(D))+!A !(B (C (D)+!C !(D))+!B !(C+(D))))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(439[8] 501[4])
    defparam i5227_3_lut_4_lut.init = 16'h400f;
    LUT4 i1_2_lut_rep_215 (.A(n14370), .B(n11479), .Z(n14299)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(300[39:118])
    defparam i1_2_lut_rep_215.init = 16'heeee;
    LUT4 i2083_4_lut_4_lut (.A(n14292), .B(scl_i_reg), .C(state_reg[1]), 
         .D(n12470), .Z(n4085)) /* synthesis lut_function=(A (B (C (D))+!B (C))+!A (((D)+!C)+!B)) */ ;
    defparam i2083_4_lut_4_lut.init = 16'hf535;
    LUT4 i1_4_lut_adj_115 (.A(start_bit), .B(n4111), .C(n14370), .D(bit_count_reg[0]), 
         .Z(bit_count_next[0])) /* synthesis lut_function=(A+(B+!(C (D)+!C !(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(273[14] 436[8])
    defparam i1_4_lut_adj_115.init = 16'heffe;
    LUT4 i46_3_lut_4_lut (.A(n14370), .B(n11479), .C(\state_reg[0] ), 
         .D(n14374), .Z(int_clk_out_enable_1)) /* synthesis lut_function=(!(A (C)+!A (B (C)+!B !((D)+!C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(300[39:118])
    defparam i46_3_lut_4_lut.init = 16'h1f0f;
    LUT4 i1276_4_lut (.A(n12342), .B(n3102), .C(n4085), .D(n14374), 
         .Z(n4111)) /* synthesis lut_function=(!(A (B (D))+!A (B ((D)+!C)+!B !(C)))) */ ;
    defparam i1276_4_lut.init = 16'h32fa;
    LUT4 i1_2_lut_adj_116 (.A(state_reg[1]), .B(scl_i_reg), .Z(n12748)) /* synthesis lut_function=(A (B)) */ ;
    defparam i1_2_lut_adj_116.init = 16'h8888;
    LUT4 i10333_3_lut (.A(state_reg[1]), .B(stm_fpga_spare5_c), .C(state_reg[2]), 
         .Z(n13324)) /* synthesis lut_function=(A (B)+!A (B (C))) */ ;
    defparam i10333_3_lut.init = 16'hc8c8;
    LUT4 i2081_4_lut (.A(n4085), .B(n4095), .C(n3102), .D(\state_reg[0] ), 
         .Z(n4108)) /* synthesis lut_function=(A (B+!(C+!(D)))+!A (B (C+!(D)))) */ ;
    defparam i2081_4_lut.init = 16'hcacc;
    PFUMX mux_1078_i1 (.BLUT(n3793[0]), .ALUT(n3789[0]), .C0(n6_adj_1177), 
          .Z(n3797[0]));
    LUT4 i5384_3_lut_4_lut (.A(n14372), .B(n14318), .C(state_reg[1]), 
         .D(n14323), .Z(n8344)) /* synthesis lut_function=(A (C+(D))+!A !(B (C+!(D))+!B !(C+(D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/i2c_slave.v(352[26] 354[20])
    defparam i5384_3_lut_4_lut.init = 16'hbfb0;
    LUT4 i1_2_lut_adj_117 (.A(last_scl_i_reg), .B(sda_i_reg), .Z(n12470)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut_adj_117.init = 16'heeee;
    PFUMX i38_adj_118 (.BLUT(n23), .ALUT(n12227), .C0(state_reg[2]), .Z(n32));
    LUT4 i2_3_lut (.A(state_reg[1]), .B(\state_reg[0] ), .C(state_reg[2]), 
         .Z(n3102)) /* synthesis lut_function=(!(A+(B (C)+!B !(C)))) */ ;
    defparam i2_3_lut.init = 16'h1414;
    PFUMX i10994 (.BLUT(n14404), .ALUT(n14405), .C0(state_reg[1]), .Z(n14406));
    
endmodule
//
// Verilog Description of module word_align_3state
//

module word_align_3state (n14284, n15, r_state, sdr_rxclk_c, i_ddr_data, 
            \sample_count[0] , \sample_count_next[0] , w_rx_24_fifo_data, 
            \sample_count[2] , n14338, \sample_count[3] , n14305, n14269, 
            \sample_count[1] , \sample_count[7] , \sample_count[6] , n14917, 
            n1, \sample_count_next[7] , \sample_count_next[3] , n14360, 
            \sample_count_next[2] , w_rx_24_fifo_push, \sample_count_next[1] ) /* synthesis syn_module_defined=1 */ ;
    input n14284;
    output n15;
    output [1:0]r_state;
    input sdr_rxclk_c;
    input [1:0]i_ddr_data;
    output \sample_count[0] ;
    input \sample_count_next[0] ;
    output [31:0]w_rx_24_fifo_data;
    output \sample_count[2] ;
    output n14338;
    output \sample_count[3] ;
    output n14305;
    output n14269;
    output \sample_count[1] ;
    output \sample_count[7] ;
    output \sample_count[6] ;
    input n14917;
    input n1;
    input \sample_count_next[7] ;
    input \sample_count_next[3] ;
    input n14360;
    input \sample_count_next[2] ;
    output w_rx_24_fifo_push;
    input \sample_count_next[1] ;
    
    wire sdr_rxclk_c /* synthesis IO_TYPES="LVDS", is_clock=1, SET_AS_NETWORK=sdr_rxclk_c */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(10[13:22])
    
    wire r_candidate_offset;
    wire [32:0]sr;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(27[16:18])
    wire [31:0]candidate_sr;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[14:26])
    wire [3:0]match_count;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(30[15:26])
    
    wire n14357;
    wire [7:0]sample_count;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(36[16:28])
    
    wire n14283;
    wire [7:0]sample_count_next;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(36[30:47])
    
    wire n12642, n14359, n12244, sdr_rxclk_c_enable_80, sdr_rxclk_c_enable_5, 
        r_candidate_offset_next_N_1098, sdr_rxclk_c_enable_73;
    wire [1:0]r_state_next;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(23[25:37])
    
    wire n14274, n68, n14392, n14393, n14394, n14355, n9573, n12257, 
        n11, n13280, n12254, n9592, n12183, real_candidate, n12434, 
        n12428, n36, n12436, n12364, n42, n14391, n12446, n24, 
        n12444, n12400, n12360, n12358, n12390, n12382, n5175, 
        n25, sdr_rxclk_c_enable_82, n14389, n14390, n13106;
    wire [3:0]match_count_next;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(30[28:44])
    
    wire n5848, n13114, n40, n14236, n14237, n14238;
    
    LUT4 i1_3_lut_3_lut (.A(r_candidate_offset), .B(sr[32]), .C(sr[31]), 
         .Z(candidate_sr[31])) /* synthesis lut_function=(A (C)+!A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam i1_3_lut_3_lut.init = 16'he4e4;
    LUT4 i1_2_lut_rep_273 (.A(match_count[2]), .B(match_count[1]), .Z(n14357)) /* synthesis lut_function=(A+(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam i1_2_lut_rep_273.init = 16'heeee;
    LUT4 i1_3_lut_4_lut (.A(sample_count[4]), .B(n14283), .C(n14284), 
         .D(sample_count[5]), .Z(sample_count_next[5])) /* synthesis lut_function=(!(A (B ((D)+!C)+!B !(C (D)))+!A !(C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(180[34:53])
    defparam i1_3_lut_4_lut.init = 16'h7080;
    LUT4 i1_2_lut_3_lut (.A(match_count[2]), .B(match_count[1]), .C(n15), 
         .Z(n12642)) /* synthesis lut_function=(!(A (C)+!A ((C)+!B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam i1_2_lut_3_lut.init = 16'h0e0e;
    LUT4 i1_2_lut_rep_275 (.A(r_state[0]), .B(r_state[1]), .Z(n14359)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(181[17:38])
    defparam i1_2_lut_rep_275.init = 16'h8888;
    LUT4 i1_2_lut_3_lut_adj_47 (.A(r_state[0]), .B(r_state[1]), .C(n15), 
         .Z(n12244)) /* synthesis lut_function=(((C)+!B)+!A) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(181[17:38])
    defparam i1_2_lut_3_lut_adj_47.init = 16'hf7f7;
    FD1S3AX sr_i0 (.D(i_ddr_data[0]), .CK(sdr_rxclk_c), .Q(sr[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i0.GSR = "ENABLED";
    FD1P3AX sample_count_i0 (.D(\sample_count_next[0] ), .SP(sdr_rxclk_c_enable_80), 
            .CK(sdr_rxclk_c), .Q(\sample_count[0] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sample_count_i0.GSR = "ENABLED";
    FD1P3AX r_candidate_offset_100 (.D(r_candidate_offset_next_N_1098), .SP(sdr_rxclk_c_enable_5), 
            .CK(sdr_rxclk_c), .Q(r_candidate_offset)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam r_candidate_offset_100.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i0 (.D(candidate_sr[0]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i0.GSR = "ENABLED";
    FD1S3AX r_state_i0 (.D(r_state_next[0]), .CK(sdr_rxclk_c), .Q(r_state[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam r_state_i0.GSR = "ENABLED";
    LUT4 i1649_2_lut_rep_190_3_lut_4_lut (.A(\sample_count[2] ), .B(n14338), 
         .C(sample_count[4]), .D(\sample_count[3] ), .Z(n14274)) /* synthesis lut_function=(A (B (C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(180[34:53])
    defparam i1649_2_lut_rep_190_3_lut_4_lut.init = 16'h8000;
    LUT4 i1_3_lut_4_lut_adj_48 (.A(\sample_count[3] ), .B(n14305), .C(n14284), 
         .D(sample_count[4]), .Z(sample_count_next[4])) /* synthesis lut_function=(!(A (B ((D)+!C)+!B !(C (D)))+!A !(C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(180[34:53])
    defparam i1_3_lut_4_lut_adj_48.init = 16'h7080;
    LUT4 i1656_2_lut_rep_185_3_lut_4_lut (.A(\sample_count[3] ), .B(n14305), 
         .C(sample_count[5]), .D(sample_count[4]), .Z(n14269)) /* synthesis lut_function=(A (B (C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(180[34:53])
    defparam i1656_2_lut_rep_185_3_lut_4_lut.init = 16'h8000;
    LUT4 i1_2_lut (.A(sr[14]), .B(sr[31]), .Z(n68)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam i1_2_lut.init = 16'h8888;
    LUT4 i1_2_lut_adj_49 (.A(r_state[0]), .B(r_state[1]), .Z(sdr_rxclk_c_enable_80)) /* synthesis lut_function=(A+!(B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam i1_2_lut_adj_49.init = 16'hbbbb;
    PFUMX i10986 (.BLUT(n14392), .ALUT(n14393), .C0(r_candidate_offset), 
          .Z(n14394));
    LUT4 i1_2_lut_rep_271 (.A(r_candidate_offset), .B(sr[32]), .Z(n14355)) /* synthesis lut_function=(!(A+!(B))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam i1_2_lut_rep_271.init = 16'h4444;
    LUT4 i1_4_lut_3_lut (.A(r_candidate_offset), .B(sr[30]), .C(sr[29]), 
         .Z(candidate_sr[29])) /* synthesis lut_function=(A (C)+!A (B)) */ ;
    defparam i1_4_lut_3_lut.init = 16'he4e4;
    LUT4 i1_3_lut (.A(sr[15]), .B(n9573), .C(sr[16]), .Z(r_candidate_offset_next_N_1098)) /* synthesis lut_function=(((C)+!B)+!A) */ ;
    defparam i1_3_lut.init = 16'hf7f7;
    LUT4 i1_4_lut (.A(sr[31]), .B(sr[17]), .C(sr[1]), .D(sr[32]), .Z(n9573)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i1_4_lut.init = 16'h0100;
    LUT4 i1_4_lut_3_lut_adj_50 (.A(r_candidate_offset), .B(sr[1]), .C(sr[2]), 
         .Z(candidate_sr[1])) /* synthesis lut_function=(A (B)+!A (C)) */ ;
    defparam i1_4_lut_3_lut_adj_50.init = 16'hd8d8;
    LUT4 i1_2_lut_2_lut (.A(r_candidate_offset), .B(n9573), .Z(n12257)) /* synthesis lut_function=(!(A+!(B))) */ ;
    defparam i1_2_lut_2_lut.init = 16'h4444;
    LUT4 i1_4_lut_adj_51 (.A(n11), .B(n15), .C(sr[16]), .D(n14359), 
         .Z(sdr_rxclk_c_enable_73)) /* synthesis lut_function=(!((B+(C+!(D)))+!A)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(181[17:38])
    defparam i1_4_lut_adj_51.init = 16'h0200;
    LUT4 i5541_3_lut (.A(sr[1]), .B(sr[0]), .C(r_candidate_offset), .Z(candidate_sr[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(33[16:34])
    defparam i5541_3_lut.init = 16'hcaca;
    LUT4 i1_4_lut_adj_52 (.A(n13280), .B(n12254), .C(\sample_count[1] ), 
         .D(\sample_count[7] ), .Z(n15)) /* synthesis lut_function=((B+((D)+!C))+!A) */ ;
    defparam i1_4_lut_adj_52.init = 16'hffdf;
    LUT4 i10289_2_lut (.A(\sample_count[3] ), .B(\sample_count[2] ), .Z(n13280)) /* synthesis lut_function=(A (B)) */ ;
    defparam i10289_2_lut.init = 16'h8888;
    LUT4 i1_4_lut_adj_53 (.A(\sample_count[6] ), .B(\sample_count[0] ), 
         .C(sample_count[5]), .D(sample_count[4]), .Z(n12254)) /* synthesis lut_function=(A+((C+(D))+!B)) */ ;
    defparam i1_4_lut_adj_53.init = 16'hfffb;
    LUT4 i1_4_lut_3_lut_adj_54 (.A(r_candidate_offset), .B(sr[14]), .C(sr[15]), 
         .Z(candidate_sr[14])) /* synthesis lut_function=(A (B)+!A (C)) */ ;
    defparam i1_4_lut_3_lut_adj_54.init = 16'hd8d8;
    LUT4 i1_3_lut_adj_55 (.A(r_state[0]), .B(sdr_rxclk_c_enable_5), .C(n9592), 
         .Z(r_state_next[0])) /* synthesis lut_function=(A (B+(C))+!A (B)) */ ;
    defparam i1_3_lut_adj_55.init = 16'hecec;
    LUT4 i1_4_lut_3_lut_adj_56 (.A(r_candidate_offset), .B(sr[10]), .C(sr[11]), 
         .Z(candidate_sr[10])) /* synthesis lut_function=(A (B)+!A (C)) */ ;
    defparam i1_4_lut_3_lut_adj_56.init = 16'hd8d8;
    PFUMX i22 (.BLUT(n12183), .ALUT(n12257), .C0(sr[15]), .Z(n11));
    LUT4 i1_2_lut_adj_57 (.A(sr[16]), .B(n11), .Z(real_candidate)) /* synthesis lut_function=(!(A+!(B))) */ ;
    defparam i1_2_lut_adj_57.init = 16'h4444;
    LUT4 i1_4_lut_adj_58 (.A(n12434), .B(n12428), .C(n36), .D(n14394), 
         .Z(n12436)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_adj_58.init = 16'hfffe;
    LUT4 i1_4_lut_adj_59 (.A(n12364), .B(n42), .C(r_candidate_offset), 
         .D(sr[30]), .Z(n12434)) /* synthesis lut_function=(A+(B+!(C+!(D)))) */ ;
    defparam i1_4_lut_adj_59.init = 16'hefee;
    LUT4 i1_4_lut_adj_60 (.A(n14391), .B(n12446), .C(n24), .D(n12444), 
         .Z(n12428)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_adj_60.init = 16'hfffe;
    LUT4 i1_4_lut_adj_61 (.A(n12400), .B(r_candidate_offset), .C(sr[19]), 
         .D(sr[2]), .Z(n36)) /* synthesis lut_function=(A+(B (C)+!B (C+(D)))) */ ;
    defparam i1_4_lut_adj_61.init = 16'hfbfa;
    LUT4 i1_4_lut_adj_62 (.A(r_candidate_offset), .B(n12360), .C(sr[10]), 
         .D(n12358), .Z(n12364)) /* synthesis lut_function=(A (B+(C+(D)))+!A (B+(D))) */ ;
    defparam i1_4_lut_adj_62.init = 16'hffec;
    LUT4 i1_4_lut_adj_63 (.A(n12390), .B(n14355), .C(n12382), .D(sr[15]), 
         .Z(n42)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_adj_63.init = 16'hfffe;
    LUT4 i1_4_lut_adj_64 (.A(sr[31]), .B(sr[1]), .C(sr[17]), .D(sr[29]), 
         .Z(n12360)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_adj_64.init = 16'hfffe;
    LUT4 i1_4_lut_adj_65 (.A(sr[7]), .B(sr[27]), .C(sr[23]), .D(sr[20]), 
         .Z(n12358)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_adj_65.init = 16'hfffe;
    LUT4 i1_4_lut_adj_66 (.A(sr[24]), .B(n5175), .C(sr[22]), .D(r_candidate_offset), 
         .Z(n12446)) /* synthesis lut_function=(A (B+(C+!(D)))+!A (B+(C (D)))) */ ;
    defparam i1_4_lut_adj_66.init = 16'hfcee;
    LUT4 i1_3_lut_adj_67 (.A(sr[9]), .B(r_candidate_offset), .C(sr[14]), 
         .Z(n24)) /* synthesis lut_function=(A+(B (C))) */ ;
    defparam i1_3_lut_adj_67.init = 16'heaea;
    LUT4 i1_4_lut_adj_68 (.A(sr[6]), .B(sr[28]), .C(sr[4]), .D(r_candidate_offset), 
         .Z(n12444)) /* synthesis lut_function=(A (B+(C+!(D)))+!A (B (D)+!B (C (D)))) */ ;
    defparam i1_4_lut_adj_68.init = 16'hfcaa;
    LUT4 i2299_3_lut (.A(sr[4]), .B(sr[2]), .C(r_candidate_offset), .Z(n5175)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(77[43:62])
    defparam i2299_3_lut.init = 16'hcaca;
    LUT4 i1_2_lut_adj_69 (.A(sr[3]), .B(sr[5]), .Z(n12400)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut_adj_69.init = 16'heeee;
    LUT4 i6678_4_lut (.A(r_state[1]), .B(n25), .C(r_state[0]), .D(n9592), 
         .Z(sdr_rxclk_c_enable_82)) /* synthesis lut_function=(!(A ((D)+!C)+!A !(B+!(C)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(23[16:23])
    defparam i6678_4_lut.init = 16'h45e5;
    LUT4 i1_4_lut_then_3_lut (.A(sr[6]), .B(sr[8]), .C(sr[26]), .Z(n14393)) /* synthesis lut_function=(A+(B+(C))) */ ;
    defparam i1_4_lut_then_3_lut.init = 16'hfefe;
    LUT4 i1_4_lut_else_3_lut (.A(sr[28]), .B(sr[8]), .C(sr[14]), .D(sr[10]), 
         .Z(n14392)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_else_3_lut.init = 16'hfffe;
    PFUMX i10984 (.BLUT(n14389), .ALUT(n14390), .C0(r_candidate_offset), 
          .Z(n14391));
    LUT4 i1_4_lut_adj_70 (.A(n13106), .B(n11), .C(n14357), .D(sr[16]), 
         .Z(match_count_next[1])) /* synthesis lut_function=(!(((C+(D))+!B)+!A)) */ ;
    defparam i1_4_lut_adj_70.init = 16'h0008;
    LUT4 i1_4_lut_adj_71 (.A(r_state[1]), .B(match_count[1]), .C(r_state[0]), 
         .D(match_count[0]), .Z(n13106)) /* synthesis lut_function=(!(A+(B ((D)+!C)+!B !(C (D))))) */ ;
    defparam i1_4_lut_adj_71.init = 16'h1040;
    LUT4 i5729_3_lut (.A(sr[3]), .B(sr[2]), .C(r_candidate_offset), .Z(candidate_sr[2])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(33[16:34])
    defparam i5729_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i4_3_lut (.A(sr[4]), .B(sr[3]), .C(r_candidate_offset), 
         .Z(candidate_sr[3])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i4_3_lut.init = 16'hcaca;
    LUT4 i1_4_lut_adj_72 (.A(sr[11]), .B(sr[21]), .C(sr[18]), .D(sr[25]), 
         .Z(n12390)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_adj_72.init = 16'hfffe;
    LUT4 sr_32__I_0_112_i5_3_lut (.A(sr[5]), .B(sr[4]), .C(r_candidate_offset), 
         .Z(candidate_sr[4])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i5_3_lut.init = 16'hcaca;
    FD1S3AX sr_i1 (.D(i_ddr_data[1]), .CK(sdr_rxclk_c), .Q(sr[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i1.GSR = "ENABLED";
    LUT4 sr_32__I_0_112_i6_3_lut (.A(sr[6]), .B(sr[5]), .C(r_candidate_offset), 
         .Z(candidate_sr[5])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i6_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i7_3_lut (.A(sr[7]), .B(sr[6]), .C(r_candidate_offset), 
         .Z(candidate_sr[6])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i7_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i8_3_lut (.A(sr[8]), .B(sr[7]), .C(r_candidate_offset), 
         .Z(candidate_sr[7])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i8_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i9_3_lut (.A(sr[9]), .B(sr[8]), .C(r_candidate_offset), 
         .Z(candidate_sr[8])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i9_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i10_3_lut (.A(sr[10]), .B(sr[9]), .C(r_candidate_offset), 
         .Z(candidate_sr[9])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i10_3_lut.init = 16'hcaca;
    LUT4 i5521_3_lut (.A(sr[12]), .B(sr[11]), .C(r_candidate_offset), 
         .Z(candidate_sr[11])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(33[16:34])
    defparam i5521_3_lut.init = 16'hcaca;
    LUT4 i5520_3_lut (.A(sr[13]), .B(sr[12]), .C(r_candidate_offset), 
         .Z(candidate_sr[12])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(33[16:34])
    defparam i5520_3_lut.init = 16'hcaca;
    LUT4 i6698_3_lut (.A(sr[14]), .B(sr[13]), .C(r_candidate_offset), 
         .Z(candidate_sr[13])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(33[16:34])
    defparam i6698_3_lut.init = 16'hcaca;
    LUT4 i6703_3_lut (.A(sr[16]), .B(sr[15]), .C(r_candidate_offset), 
         .Z(candidate_sr[15])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(33[16:34])
    defparam i6703_3_lut.init = 16'hcaca;
    LUT4 i5732_3_lut (.A(sr[17]), .B(sr[16]), .C(r_candidate_offset), 
         .Z(candidate_sr[16])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(33[16:34])
    defparam i5732_3_lut.init = 16'hcaca;
    FD1S3AX sr_i2 (.D(sr[0]), .CK(sdr_rxclk_c), .Q(sr[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i2.GSR = "ENABLED";
    FD1S3AX sr_i3 (.D(sr[1]), .CK(sdr_rxclk_c), .Q(sr[3])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i3.GSR = "ENABLED";
    FD1S3AX sr_i4 (.D(sr[2]), .CK(sdr_rxclk_c), .Q(sr[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i4.GSR = "ENABLED";
    FD1S3AX sr_i5 (.D(sr[3]), .CK(sdr_rxclk_c), .Q(sr[5])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i5.GSR = "ENABLED";
    FD1S3AX sr_i6 (.D(sr[4]), .CK(sdr_rxclk_c), .Q(sr[6])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i6.GSR = "ENABLED";
    FD1S3AX sr_i7 (.D(sr[5]), .CK(sdr_rxclk_c), .Q(sr[7])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i7.GSR = "ENABLED";
    FD1S3AX sr_i8 (.D(sr[6]), .CK(sdr_rxclk_c), .Q(sr[8])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i8.GSR = "ENABLED";
    FD1S3AX sr_i9 (.D(sr[7]), .CK(sdr_rxclk_c), .Q(sr[9])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i9.GSR = "ENABLED";
    FD1S3AX sr_i10 (.D(sr[8]), .CK(sdr_rxclk_c), .Q(sr[10])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i10.GSR = "ENABLED";
    FD1S3AX sr_i11 (.D(sr[9]), .CK(sdr_rxclk_c), .Q(sr[11])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i11.GSR = "ENABLED";
    FD1S3AX sr_i12 (.D(sr[10]), .CK(sdr_rxclk_c), .Q(sr[12])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i12.GSR = "ENABLED";
    FD1S3AX sr_i13 (.D(sr[11]), .CK(sdr_rxclk_c), .Q(sr[13])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i13.GSR = "ENABLED";
    FD1S3AX sr_i14 (.D(sr[12]), .CK(sdr_rxclk_c), .Q(sr[14])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i14.GSR = "ENABLED";
    FD1S3AX sr_i15 (.D(sr[13]), .CK(sdr_rxclk_c), .Q(sr[15])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i15.GSR = "ENABLED";
    FD1S3AX sr_i16 (.D(sr[14]), .CK(sdr_rxclk_c), .Q(sr[16])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i16.GSR = "ENABLED";
    FD1S3AX sr_i17 (.D(sr[15]), .CK(sdr_rxclk_c), .Q(sr[17])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i17.GSR = "ENABLED";
    FD1S3AX sr_i18 (.D(sr[16]), .CK(sdr_rxclk_c), .Q(sr[18])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i18.GSR = "ENABLED";
    FD1S3AX sr_i19 (.D(sr[17]), .CK(sdr_rxclk_c), .Q(sr[19])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i19.GSR = "ENABLED";
    FD1S3AX sr_i20 (.D(sr[18]), .CK(sdr_rxclk_c), .Q(sr[20])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i20.GSR = "ENABLED";
    FD1S3AX sr_i21 (.D(sr[19]), .CK(sdr_rxclk_c), .Q(sr[21])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i21.GSR = "ENABLED";
    FD1S3AX sr_i22 (.D(sr[20]), .CK(sdr_rxclk_c), .Q(sr[22])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i22.GSR = "ENABLED";
    FD1S3AX sr_i23 (.D(sr[21]), .CK(sdr_rxclk_c), .Q(sr[23])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i23.GSR = "ENABLED";
    FD1S3AX sr_i24 (.D(sr[22]), .CK(sdr_rxclk_c), .Q(sr[24])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i24.GSR = "ENABLED";
    FD1S3AX sr_i25 (.D(sr[23]), .CK(sdr_rxclk_c), .Q(sr[25])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i25.GSR = "ENABLED";
    FD1S3AX sr_i26 (.D(sr[24]), .CK(sdr_rxclk_c), .Q(sr[26])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i26.GSR = "ENABLED";
    FD1S3AX sr_i27 (.D(sr[25]), .CK(sdr_rxclk_c), .Q(sr[27])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i27.GSR = "ENABLED";
    FD1S3AX sr_i28 (.D(sr[26]), .CK(sdr_rxclk_c), .Q(sr[28])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i28.GSR = "ENABLED";
    FD1S3AX sr_i29 (.D(sr[27]), .CK(sdr_rxclk_c), .Q(sr[29])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i29.GSR = "ENABLED";
    FD1S3AX sr_i30 (.D(sr[28]), .CK(sdr_rxclk_c), .Q(sr[30])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i30.GSR = "ENABLED";
    FD1S3AX sr_i31 (.D(sr[29]), .CK(sdr_rxclk_c), .Q(sr[31])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i31.GSR = "ENABLED";
    FD1S3AX sr_i32 (.D(sr[30]), .CK(sdr_rxclk_c), .Q(sr[32])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sr_i32.GSR = "ENABLED";
    FD1P3AX match_count_i1 (.D(match_count_next[1]), .SP(sdr_rxclk_c_enable_82), 
            .CK(sdr_rxclk_c), .Q(match_count[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam match_count_i1.GSR = "ENABLED";
    FD1P3AX match_count_i2 (.D(n14917), .SP(sdr_rxclk_c_enable_82), .CK(sdr_rxclk_c), 
            .Q(match_count[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam match_count_i2.GSR = "ENABLED";
    LUT4 i5730_3_lut (.A(sr[18]), .B(sr[17]), .C(r_candidate_offset), 
         .Z(candidate_sr[17])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(33[16:34])
    defparam i5730_3_lut.init = 16'hcaca;
    FD1P3AX o_fifo_data_i1 (.D(candidate_sr[1]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i1.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i2 (.D(candidate_sr[2]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[2])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i2.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i3 (.D(candidate_sr[3]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[3])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i3.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i4 (.D(candidate_sr[4]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i4.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i5 (.D(candidate_sr[5]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[5])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i5.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i6 (.D(candidate_sr[6]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[6])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i6.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i7 (.D(candidate_sr[7]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[7])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i7.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i8 (.D(candidate_sr[8]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[8])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i8.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i9 (.D(candidate_sr[9]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[9])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i9.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i10 (.D(candidate_sr[10]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[10])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i10.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i11 (.D(candidate_sr[11]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[11])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i11.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i12 (.D(candidate_sr[12]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[12])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i12.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i13 (.D(candidate_sr[13]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[13])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i13.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i14 (.D(candidate_sr[14]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[14])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i14.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i15 (.D(candidate_sr[15]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[15])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i15.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i16 (.D(candidate_sr[16]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[16])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i16.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i17 (.D(candidate_sr[17]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[17])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i17.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i18 (.D(candidate_sr[18]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[18])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i18.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i19 (.D(candidate_sr[19]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[19])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i19.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i20 (.D(candidate_sr[20]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[20])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i20.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i21 (.D(candidate_sr[21]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[21])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i21.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i22 (.D(candidate_sr[22]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[22])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i22.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i23 (.D(candidate_sr[23]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[23])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i23.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i24 (.D(candidate_sr[24]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[24])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i24.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i25 (.D(candidate_sr[25]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[25])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i25.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i26 (.D(candidate_sr[26]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[26])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i26.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i27 (.D(candidate_sr[27]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[27])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i27.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i28 (.D(candidate_sr[28]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[28])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i28.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i29 (.D(candidate_sr[29]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[29])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i29.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i30 (.D(candidate_sr[30]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[30])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i30.GSR = "ENABLED";
    FD1P3AX o_fifo_data_i31 (.D(candidate_sr[31]), .SP(sdr_rxclk_c_enable_73), 
            .CK(sdr_rxclk_c), .Q(w_rx_24_fifo_data[31])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_data_i31.GSR = "ENABLED";
    FD1S3IX r_state_i1 (.D(n5848), .CK(sdr_rxclk_c), .CD(n1), .Q(r_state[1])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam r_state_i1.GSR = "ENABLED";
    LUT4 i5717_3_lut (.A(sr[19]), .B(sr[18]), .C(r_candidate_offset), 
         .Z(candidate_sr[18])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(33[16:34])
    defparam i5717_3_lut.init = 16'hcaca;
    LUT4 i5718_3_lut (.A(sr[20]), .B(sr[19]), .C(r_candidate_offset), 
         .Z(candidate_sr[19])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(33[16:34])
    defparam i5718_3_lut.init = 16'hcaca;
    LUT4 i5725_3_lut (.A(sr[21]), .B(sr[20]), .C(r_candidate_offset), 
         .Z(candidate_sr[20])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(33[16:34])
    defparam i5725_3_lut.init = 16'hcaca;
    LUT4 i5731_3_lut (.A(sr[22]), .B(sr[21]), .C(r_candidate_offset), 
         .Z(candidate_sr[21])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(33[16:34])
    defparam i5731_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i23_3_lut (.A(sr[23]), .B(sr[22]), .C(r_candidate_offset), 
         .Z(candidate_sr[22])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i23_3_lut.init = 16'hcaca;
    LUT4 i1_4_lut_then_4_lut (.A(sr[0]), .B(sr[16]), .C(sr[30]), .D(sr[24]), 
         .Z(n14390)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_then_4_lut.init = 16'hfffe;
    LUT4 sr_32__I_0_112_i24_3_lut (.A(sr[24]), .B(sr[23]), .C(r_candidate_offset), 
         .Z(candidate_sr[23])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i24_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i25_3_lut (.A(sr[25]), .B(sr[24]), .C(r_candidate_offset), 
         .Z(candidate_sr[24])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i25_3_lut.init = 16'hcaca;
    LUT4 i1_2_lut_adj_73 (.A(sr[12]), .B(sr[13]), .Z(n12382)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1_2_lut_adj_73.init = 16'heeee;
    LUT4 i1_3_lut_adj_74 (.A(r_state[1]), .B(match_count[0]), .C(r_state[0]), 
         .Z(n13114)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;
    defparam i1_3_lut_adj_74.init = 16'h1010;
    LUT4 sr_32__I_0_112_i26_3_lut (.A(sr[26]), .B(sr[25]), .C(r_candidate_offset), 
         .Z(candidate_sr[25])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i26_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i27_3_lut (.A(sr[27]), .B(sr[26]), .C(r_candidate_offset), 
         .Z(candidate_sr[26])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i27_3_lut.init = 16'hcaca;
    LUT4 sr_32__I_0_112_i28_3_lut (.A(sr[28]), .B(sr[27]), .C(r_candidate_offset), 
         .Z(candidate_sr[27])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(107[29:77])
    defparam sr_32__I_0_112_i28_3_lut.init = 16'hcaca;
    LUT4 i5538_3_lut (.A(sr[29]), .B(sr[28]), .C(r_candidate_offset), 
         .Z(candidate_sr[28])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(33[16:34])
    defparam i5538_3_lut.init = 16'hcaca;
    LUT4 i5535_3_lut (.A(sr[31]), .B(sr[30]), .C(r_candidate_offset), 
         .Z(candidate_sr[30])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(33[16:34])
    defparam i5535_3_lut.init = 16'hcaca;
    LUT4 i6670_4_lut (.A(n12642), .B(n9592), .C(r_state[1]), .D(real_candidate), 
         .Z(n5848)) /* synthesis lut_function=(A (B (C+(D))+!B !(C+!(D)))+!A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(23[16:23])
    defparam i6670_4_lut.init = 16'hcac0;
    LUT4 i1_4_lut_adj_75 (.A(sr[0]), .B(sr[30]), .C(n68), .D(r_candidate_offset), 
         .Z(n12183)) /* synthesis lut_function=(!(A+(B+!(C (D))))) */ ;
    defparam i1_4_lut_adj_75.init = 16'h1000;
    LUT4 i1_4_lut_adj_76 (.A(n13114), .B(n11), .C(n14357), .D(sr[16]), 
         .Z(match_count_next[0])) /* synthesis lut_function=(!(((C+(D))+!B)+!A)) */ ;
    defparam i1_4_lut_adj_76.init = 16'h0008;
    LUT4 n40_bdd_2_lut (.A(n40), .B(sr[14]), .Z(n14236)) /* synthesis lut_function=(!(A+!(B))) */ ;
    defparam n40_bdd_2_lut.init = 16'h4444;
    LUT4 sr_16__bdd_4_lut_11049 (.A(sr[15]), .B(sr[32]), .C(sr[1]), .D(sr[17]), 
         .Z(n14237)) /* synthesis lut_function=(!(((C+(D))+!B)+!A)) */ ;
    defparam sr_16__bdd_4_lut_11049.init = 16'h0008;
    LUT4 n14237_bdd_2_lut (.A(n14237), .B(sr[16]), .Z(n14238)) /* synthesis lut_function=(!((B)+!A)) */ ;
    defparam n14237_bdd_2_lut.init = 16'h2222;
    LUT4 i1_3_lut_4_lut_adj_77 (.A(n15), .B(n12436), .C(sr[16]), .D(n11), 
         .Z(n25)) /* synthesis lut_function=(!(A+!(B+!(C+!(D))))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(181[17:38])
    defparam i1_3_lut_4_lut_adj_77.init = 16'h4544;
    LUT4 i1_3_lut_4_lut_adj_78 (.A(sr[16]), .B(n11), .C(n12436), .D(n15), 
         .Z(n9592)) /* synthesis lut_function=(A ((D)+!C)+!A (B+((D)+!C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(181[17:38])
    defparam i1_3_lut_4_lut_adj_78.init = 16'hff4f;
    LUT4 i1628_2_lut_rep_254 (.A(\sample_count[1] ), .B(\sample_count[0] ), 
         .Z(n14338)) /* synthesis lut_function=(A (B)) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(180[34:53])
    defparam i1628_2_lut_rep_254.init = 16'h8888;
    LUT4 i1635_2_lut_rep_221_3_lut (.A(\sample_count[1] ), .B(\sample_count[0] ), 
         .C(\sample_count[2] ), .Z(n14305)) /* synthesis lut_function=(A (B (C))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(180[34:53])
    defparam i1635_2_lut_rep_221_3_lut.init = 16'h8080;
    LUT4 i1642_2_lut_rep_199_3_lut_4_lut (.A(\sample_count[1] ), .B(\sample_count[0] ), 
         .C(\sample_count[3] ), .D(\sample_count[2] ), .Z(n14283)) /* synthesis lut_function=(A (B (C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(180[34:53])
    defparam i1642_2_lut_rep_199_3_lut_4_lut.init = 16'h8000;
    FD1P3AX sample_count_i7 (.D(\sample_count_next[7] ), .SP(sdr_rxclk_c_enable_80), 
            .CK(sdr_rxclk_c), .Q(\sample_count[7] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sample_count_i7.GSR = "ENABLED";
    FD1P3AX sample_count_i6 (.D(sample_count_next[6]), .SP(sdr_rxclk_c_enable_80), 
            .CK(sdr_rxclk_c), .Q(\sample_count[6] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sample_count_i6.GSR = "ENABLED";
    FD1P3AX sample_count_i5 (.D(sample_count_next[5]), .SP(sdr_rxclk_c_enable_80), 
            .CK(sdr_rxclk_c), .Q(sample_count[5])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sample_count_i5.GSR = "ENABLED";
    FD1P3AX sample_count_i4 (.D(sample_count_next[4]), .SP(sdr_rxclk_c_enable_80), 
            .CK(sdr_rxclk_c), .Q(sample_count[4])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sample_count_i4.GSR = "ENABLED";
    LUT4 i1_4_lut_adj_79 (.A(sr[15]), .B(sr[30]), .C(sr[16]), .D(sr[0]), 
         .Z(n40)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_4_lut_adj_79.init = 16'hfffe;
    FD1P3AX sample_count_i3 (.D(\sample_count_next[3] ), .SP(sdr_rxclk_c_enable_80), 
            .CK(sdr_rxclk_c), .Q(\sample_count[3] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sample_count_i3.GSR = "ENABLED";
    LUT4 n14238_bdd_4_lut (.A(n14238), .B(n14236), .C(sr[31]), .D(n14360), 
         .Z(sdr_rxclk_c_enable_5)) /* synthesis lut_function=(!(A (B (D)+!B (C+(D)))+!A (((D)+!C)+!B))) */ ;
    defparam n14238_bdd_4_lut.init = 16'h00ca;
    FD1P3AX sample_count_i2 (.D(\sample_count_next[2] ), .SP(sdr_rxclk_c_enable_80), 
            .CK(sdr_rxclk_c), .Q(\sample_count[2] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sample_count_i2.GSR = "ENABLED";
    FD1S3IX o_fifo_push_102 (.D(real_candidate), .CK(sdr_rxclk_c), .CD(n12244), 
            .Q(w_rx_24_fifo_push)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam o_fifo_push_102.GSR = "ENABLED";
    FD1P3AX sample_count_i1 (.D(\sample_count_next[1] ), .SP(sdr_rxclk_c_enable_80), 
            .CK(sdr_rxclk_c), .Q(\sample_count[1] )) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam sample_count_i1.GSR = "ENABLED";
    FD1P3AX match_count_i0 (.D(match_count_next[0]), .SP(sdr_rxclk_c_enable_82), 
            .CK(sdr_rxclk_c), .Q(match_count[0])) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=19, LSE_RCOL=2, LSE_LLINE=631, LSE_RLINE=638 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(215[14] 226[12])
    defparam match_count_i0.GSR = "ENABLED";
    LUT4 i1_4_lut_else_4_lut (.A(sr[26]), .B(sr[22]), .C(sr[16]), .Z(n14389)) /* synthesis lut_function=(A+(B+(C))) */ ;
    defparam i1_4_lut_else_4_lut.init = 16'hfefe;
    LUT4 i1_3_lut_4_lut_adj_80 (.A(sample_count[5]), .B(n14274), .C(n14284), 
         .D(\sample_count[6] ), .Z(sample_count_next[6])) /* synthesis lut_function=(!(A (B ((D)+!C)+!B !(C (D)))+!A !(C (D)))) */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/my_lvds_rx.v(180[34:53])
    defparam i1_3_lut_4_lut_adj_80.init = 16'h7080;
    
endmodule
//
// Verilog Description of module fifo_dc_16in_16out
//

module fifo_dc_16in_16out (main_reset_n_N_208, rRst, sdr_rxclk_c, internal_80MHz, 
            wifi_q_empty, GND_net, VCC_net, w_rx_24_fifo_push, n14346, 
            \w_rx_24_fifo_data[15] , \w_rx_24_fifo_data[14] , \w_rx_24_fifo_data[13] , 
            \w_rx_24_fifo_data[12] , \w_rx_24_fifo_data[11] , \w_rx_24_fifo_data[10] , 
            \w_rx_24_fifo_data[9] , \w_rx_24_fifo_data[8] , \w_rx_24_fifo_data[7] , 
            \w_rx_24_fifo_data[6] , \w_rx_24_fifo_data[5] , \w_rx_24_fifo_data[4] , 
            \w_rx_24_fifo_data[3] , \w_rx_24_fifo_data[2] , \w_rx_24_fifo_data[1] , 
            \w_rx_24_fifo_data[0] , wifi_q_fifo_data_out) /* synthesis NGD_DRC_MASK=1, syn_module_defined=1 */ ;
    input main_reset_n_N_208;
    output rRst;
    input sdr_rxclk_c;
    input internal_80MHz;
    output wifi_q_empty;
    input GND_net;
    input VCC_net;
    input w_rx_24_fifo_push;
    input n14346;
    input \w_rx_24_fifo_data[15] ;
    input \w_rx_24_fifo_data[14] ;
    input \w_rx_24_fifo_data[13] ;
    input \w_rx_24_fifo_data[12] ;
    input \w_rx_24_fifo_data[11] ;
    input \w_rx_24_fifo_data[10] ;
    input \w_rx_24_fifo_data[9] ;
    input \w_rx_24_fifo_data[8] ;
    input \w_rx_24_fifo_data[7] ;
    input \w_rx_24_fifo_data[6] ;
    input \w_rx_24_fifo_data[5] ;
    input \w_rx_24_fifo_data[4] ;
    input \w_rx_24_fifo_data[3] ;
    input \w_rx_24_fifo_data[2] ;
    input \w_rx_24_fifo_data[1] ;
    input \w_rx_24_fifo_data[0] ;
    output [15:0]wifi_q_fifo_data_out;
    
    wire sdr_rxclk_c /* synthesis IO_TYPES="LVDS", is_clock=1, SET_AS_NETWORK=sdr_rxclk_c */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(10[13:22])
    wire internal_80MHz /* synthesis is_clock=1, SET_AS_NETWORK=internal_80MHz */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(84[6:20])
    wire VCC_net /* synthesis CE_NET_FOR_BUS20=20, DSPPORT_20=CE3 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(26[14:27])
    
    wire wcount_1, wren_i, iwcount_1, wcount_2, iwcount_2, w_gcount_0, 
        w_gdata_0, w_gcount_1, w_gdata_1, w_gcount_2, wptr_0, wcount_0, 
        wptr_1, wptr_2, w_gcount_r0, ircount_0, rden_i, rcount_0, 
        ircount_1, rcount_1, ircount_2, rcount_2, r_gdata_0, r_gcount_0, 
        r_gdata_1, r_gcount_1, r_gcount_2, rptr_0, rptr_1, rptr_2, 
        w_gcount_r1, w_gcount_r2, w_gcount_r20, r_gcount_w0, r_gcount_w1, 
        r_gcount_w2, w_gcount_r21, w_gcount_r22, Full, full_d, r_gcount_w20, 
        r_gcount_w21, r_gcount_w22, empty_d, iwcount_0, w_gctr_ci, 
        co0, r_gctr_ci, co0_1, cmp_ci, wcount_r0, wcount_r1, co0_2, 
        empty_cmp_clr, empty_cmp_set, empty_d_c, cmp_ci_1, rcount_w0, 
        rcount_w1, co0_3, full_cmp_clr, full_cmp_set, full_d_c, invout_1, 
        invout_0;
    
    OR2 OR2_t4 (.A(main_reset_n_N_208), .B(main_reset_n_N_208), .Z(rRst)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=647, LSE_RLINE=658 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(101[9:50])
    FD1P3AX FF_30 (.D(iwcount_1), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(188[13] 189[22])
    defparam FF_30.GSR = "ENABLED";
    FD1P3AX FF_29 (.D(iwcount_2), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(192[13] 193[22])
    defparam FF_29.GSR = "ENABLED";
    FD1P3AX FF_28 (.D(w_gdata_0), .SP(wren_i), .CK(sdr_rxclk_c), .Q(w_gcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(196[13] 197[24])
    defparam FF_28.GSR = "ENABLED";
    FD1P3AX FF_27 (.D(w_gdata_1), .SP(wren_i), .CK(sdr_rxclk_c), .Q(w_gcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(200[13] 201[24])
    defparam FF_27.GSR = "ENABLED";
    FD1P3AX FF_26 (.D(wcount_2), .SP(wren_i), .CK(sdr_rxclk_c), .Q(w_gcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(204[13] 205[24])
    defparam FF_26.GSR = "ENABLED";
    FD1P3AX FF_25 (.D(wcount_0), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wptr_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(208[13] 209[20])
    defparam FF_25.GSR = "ENABLED";
    FD1P3AX FF_24 (.D(wcount_1), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wptr_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(212[13] 213[20])
    defparam FF_24.GSR = "ENABLED";
    FD1P3AX FF_23 (.D(wcount_2), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wptr_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(216[13] 217[20])
    defparam FF_23.GSR = "ENABLED";
    FD1S3AX FF_13 (.D(w_gcount_0), .CK(internal_80MHz), .Q(w_gcount_r0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(252[13:78])
    defparam FF_13.GSR = "ENABLED";
    FD1P3BX FF_22 (.D(ircount_0), .SP(rden_i), .CK(internal_80MHz), .PD(rRst), 
            .Q(rcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(220[13] 221[22])
    defparam FF_22.GSR = "DISABLED";
    FD1P3DX FF_21 (.D(ircount_1), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(224[13] 225[22])
    defparam FF_21.GSR = "DISABLED";
    FD1P3DX FF_20 (.D(ircount_2), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(228[13] 229[22])
    defparam FF_20.GSR = "DISABLED";
    FD1P3DX FF_19 (.D(r_gdata_0), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(232[13] 233[24])
    defparam FF_19.GSR = "DISABLED";
    FD1P3DX FF_18 (.D(r_gdata_1), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(236[13] 237[24])
    defparam FF_18.GSR = "DISABLED";
    FD1P3DX FF_17 (.D(rcount_2), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(r_gcount_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(240[13:87])
    defparam FF_17.GSR = "DISABLED";
    FD1P3DX FF_16 (.D(rcount_0), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(243[13:83])
    defparam FF_16.GSR = "DISABLED";
    FD1P3DX FF_15 (.D(rcount_1), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(246[13:83])
    defparam FF_15.GSR = "DISABLED";
    FD1P3DX FF_14 (.D(rcount_2), .SP(rden_i), .CK(internal_80MHz), .CD(rRst), 
            .Q(rptr_2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(249[13:83])
    defparam FF_14.GSR = "DISABLED";
    FD1S3AX FF_12 (.D(w_gcount_1), .CK(internal_80MHz), .Q(w_gcount_r1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(255[13:78])
    defparam FF_12.GSR = "ENABLED";
    FD1S3AX FF_11 (.D(w_gcount_2), .CK(internal_80MHz), .Q(w_gcount_r2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(258[13:78])
    defparam FF_11.GSR = "ENABLED";
    FD1S3AX FF_7 (.D(w_gcount_r0), .CK(internal_80MHz), .Q(w_gcount_r20)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(270[13:79])
    defparam FF_7.GSR = "ENABLED";
    FD1S3DX FF_10 (.D(r_gcount_0), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(261[13:77])
    defparam FF_10.GSR = "DISABLED";
    FD1S3DX FF_9 (.D(r_gcount_1), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w1)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(264[13:76])
    defparam FF_9.GSR = "DISABLED";
    FD1S3DX FF_8 (.D(r_gcount_2), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w2)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(267[13:76])
    defparam FF_8.GSR = "DISABLED";
    FD1S3AX FF_6 (.D(w_gcount_r1), .CK(internal_80MHz), .Q(w_gcount_r21)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(273[13:79])
    defparam FF_6.GSR = "ENABLED";
    FD1S3AX FF_5 (.D(w_gcount_r2), .CK(internal_80MHz), .Q(w_gcount_r22)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(276[13:79])
    defparam FF_5.GSR = "ENABLED";
    FD1S3AX FF_0 (.D(full_d), .CK(sdr_rxclk_c), .Q(Full)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(291[13:68])
    defparam FF_0.GSR = "ENABLED";
    FD1S3DX FF_4 (.D(r_gcount_w0), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w20)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(279[13:78])
    defparam FF_4.GSR = "DISABLED";
    FD1S3DX FF_3 (.D(r_gcount_w1), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w21)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(282[13:78])
    defparam FF_3.GSR = "DISABLED";
    FD1S3DX FF_2 (.D(r_gcount_w2), .CK(sdr_rxclk_c), .CD(rRst), .Q(r_gcount_w22)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(285[13:78])
    defparam FF_2.GSR = "DISABLED";
    FD1S3BX FF_1 (.D(empty_d), .CK(internal_80MHz), .PD(rRst), .Q(wifi_q_empty)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(288[13:69])
    defparam FF_1.GSR = "DISABLED";
    FD1P3AY FF_31 (.D(iwcount_0), .SP(wren_i), .CK(sdr_rxclk_c), .Q(wcount_0)) /* synthesis GSR="ENABLED", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(184[13] 185[22])
    defparam FF_31.GSR = "ENABLED";
    CCU2C w_gctr_cia (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(VCC_net), .B1(VCC_net), .C1(VCC_net), .D1(VCC_net), .COUT(w_gctr_ci)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(298[11] 300[48])
    defparam w_gctr_cia.INIT0 = 16'b0110011010101010;
    defparam w_gctr_cia.INIT1 = 16'b0110011010101010;
    defparam w_gctr_cia.INJECT1_0 = "NO";
    defparam w_gctr_cia.INJECT1_1 = "NO";
    CCU2C w_gctr_0 (.A0(wcount_0), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(wcount_1), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(w_gctr_ci), 
          .COUT(co0), .S0(iwcount_0), .S1(iwcount_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(306[11] 308[69])
    defparam w_gctr_0.INIT0 = 16'b0110011010101010;
    defparam w_gctr_0.INIT1 = 16'b0110011010101010;
    defparam w_gctr_0.INJECT1_0 = "NO";
    defparam w_gctr_0.INJECT1_1 = "NO";
    CCU2C w_gctr_1 (.A0(wcount_2), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(co0), 
          .S0(iwcount_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(314[11] 316[54])
    defparam w_gctr_1.INIT0 = 16'b0110011010101010;
    defparam w_gctr_1.INIT1 = 16'b0110011010101010;
    defparam w_gctr_1.INJECT1_0 = "NO";
    defparam w_gctr_1.INJECT1_1 = "NO";
    CCU2C r_gctr_cia (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(VCC_net), .B1(VCC_net), .C1(VCC_net), .D1(VCC_net), .COUT(r_gctr_ci)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(322[11] 324[48])
    defparam r_gctr_cia.INIT0 = 16'b0110011010101010;
    defparam r_gctr_cia.INIT1 = 16'b0110011010101010;
    defparam r_gctr_cia.INJECT1_0 = "NO";
    defparam r_gctr_cia.INJECT1_1 = "NO";
    CCU2C r_gctr_0 (.A0(rcount_0), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(rcount_1), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(r_gctr_ci), 
          .COUT(co0_1), .S0(ircount_0), .S1(ircount_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(330[11] 332[71])
    defparam r_gctr_0.INIT0 = 16'b0110011010101010;
    defparam r_gctr_0.INIT1 = 16'b0110011010101010;
    defparam r_gctr_0.INJECT1_0 = "NO";
    defparam r_gctr_0.INJECT1_1 = "NO";
    CCU2C r_gctr_1 (.A0(rcount_2), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(co0_1), 
          .S0(ircount_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(338[11] 340[58])
    defparam r_gctr_1.INIT0 = 16'b0110011010101010;
    defparam r_gctr_1.INIT1 = 16'b0110011010101010;
    defparam r_gctr_1.INJECT1_0 = "NO";
    defparam r_gctr_1.INJECT1_1 = "NO";
    CCU2C empty_cmp_ci_a (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(rden_i), .B1(rden_i), .C1(VCC_net), .D1(VCC_net), .COUT(cmp_ci)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(346[11] 348[45])
    defparam empty_cmp_ci_a.INIT0 = 16'b0110011010101010;
    defparam empty_cmp_ci_a.INIT1 = 16'b0110011010101010;
    defparam empty_cmp_ci_a.INJECT1_0 = "NO";
    defparam empty_cmp_ci_a.INJECT1_1 = "NO";
    CCU2C empty_cmp_0 (.A0(rcount_0), .B0(wcount_r0), .C0(VCC_net), .D0(VCC_net), 
          .A1(rcount_1), .B1(wcount_r1), .C1(VCC_net), .D1(VCC_net), 
          .CIN(cmp_ci), .COUT(co0_2)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(354[11] 356[50])
    defparam empty_cmp_0.INIT0 = 16'b1001100110101010;
    defparam empty_cmp_0.INIT1 = 16'b1001100110101010;
    defparam empty_cmp_0.INJECT1_0 = "NO";
    defparam empty_cmp_0.INJECT1_1 = "NO";
    CCU2C empty_cmp_1 (.A0(empty_cmp_set), .B0(empty_cmp_clr), .C0(VCC_net), 
          .D0(VCC_net), .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), 
          .CIN(co0_2), .COUT(empty_d_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(362[11] 364[69])
    defparam empty_cmp_1.INIT0 = 16'b1001100110101010;
    defparam empty_cmp_1.INIT1 = 16'b1001100110101010;
    defparam empty_cmp_1.INJECT1_0 = "NO";
    defparam empty_cmp_1.INJECT1_1 = "NO";
    CCU2C a0 (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(empty_d_c), 
          .S0(empty_d)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(370[11] 372[55])
    defparam a0.INIT0 = 16'b0110011010101010;
    defparam a0.INIT1 = 16'b0110011010101010;
    defparam a0.INJECT1_0 = "NO";
    defparam a0.INJECT1_1 = "NO";
    CCU2C full_cmp_ci_a (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(wren_i), .B1(wren_i), .C1(VCC_net), .D1(VCC_net), .COUT(cmp_ci_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(378[11] 380[47])
    defparam full_cmp_ci_a.INIT0 = 16'b0110011010101010;
    defparam full_cmp_ci_a.INIT1 = 16'b0110011010101010;
    defparam full_cmp_ci_a.INJECT1_0 = "NO";
    defparam full_cmp_ci_a.INJECT1_1 = "NO";
    CCU2C full_cmp_0 (.A0(wcount_0), .B0(rcount_w0), .C0(VCC_net), .D0(VCC_net), 
          .A1(wcount_1), .B1(rcount_w1), .C1(VCC_net), .D1(VCC_net), 
          .CIN(cmp_ci_1), .COUT(co0_3)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(386[11] 388[52])
    defparam full_cmp_0.INIT0 = 16'b1001100110101010;
    defparam full_cmp_0.INIT1 = 16'b1001100110101010;
    defparam full_cmp_0.INJECT1_0 = "NO";
    defparam full_cmp_0.INJECT1_1 = "NO";
    CCU2C full_cmp_1 (.A0(full_cmp_set), .B0(full_cmp_clr), .C0(VCC_net), 
          .D0(VCC_net), .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), 
          .CIN(co0_3), .COUT(full_d_c)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(394[11] 396[68])
    defparam full_cmp_1.INIT0 = 16'b1001100110101010;
    defparam full_cmp_1.INIT1 = 16'b1001100110101010;
    defparam full_cmp_1.INJECT1_0 = "NO";
    defparam full_cmp_1.INJECT1_1 = "NO";
    CCU2C a1 (.A0(GND_net), .B0(GND_net), .C0(VCC_net), .D0(VCC_net), 
          .A1(GND_net), .B1(GND_net), .C1(VCC_net), .D1(VCC_net), .CIN(full_d_c), 
          .S0(full_d)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(406[11] 408[53])
    defparam a1.INIT0 = 16'b0110011010101010;
    defparam a1.INIT1 = 16'b0110011010101010;
    defparam a1.INJECT1_0 = "NO";
    defparam a1.INJECT1_1 = "NO";
    AND2 AND2_t6 (.A(w_rx_24_fifo_push), .B(invout_1), .Z(wren_i)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(93[10:54])
    INV INV_1 (.A(Full), .Z(invout_1)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(696[20] 707[2])
    AND2 AND2_t5 (.A(n14346), .B(invout_0), .Z(rden_i)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(97[10:54])
    INV INV_0 (.A(wifi_q_empty), .Z(invout_0)) /* synthesis LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(696[20] 707[2])
    XOR2 XOR2_t3 (.A(wcount_0), .B(wcount_1), .Z(w_gdata_0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(103[10:61])
    XOR2 XOR2_t2 (.A(wcount_1), .B(wcount_2), .Z(w_gdata_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(105[10:61])
    XOR2 XOR2_t1 (.A(rcount_0), .B(rcount_1), .Z(r_gdata_0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(107[10:61])
    XOR2 XOR2_t0 (.A(rcount_1), .B(rcount_2), .Z(r_gdata_1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/fifo_dc_16in_16out/fifo_dc_16in_16out.v(109[10:61])
    ROM16X1A LUT4_7 (.AD0(GND_net), .AD1(GND_net), .AD2(w_gcount_r22), 
            .AD3(w_gcount_r21), .DO0(wcount_r1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(696[20] 707[2])
    defparam LUT4_7.initval = 16'b0110100110010110;
    ROM16X1A LUT4_6 (.AD0(GND_net), .AD1(w_gcount_r22), .AD2(w_gcount_r21), 
            .AD3(w_gcount_r20), .DO0(wcount_r0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(696[20] 707[2])
    defparam LUT4_6.initval = 16'b0110100110010110;
    ROM16X1A LUT4_5 (.AD0(GND_net), .AD1(GND_net), .AD2(r_gcount_w22), 
            .AD3(r_gcount_w21), .DO0(rcount_w1)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(696[20] 707[2])
    defparam LUT4_5.initval = 16'b0110100110010110;
    ROM16X1A LUT4_4 (.AD0(GND_net), .AD1(r_gcount_w22), .AD2(r_gcount_w21), 
            .AD3(r_gcount_w20), .DO0(rcount_w0)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(696[20] 707[2])
    defparam LUT4_4.initval = 16'b0110100110010110;
    ROM16X1A LUT4_3 (.AD0(GND_net), .AD1(w_gcount_r22), .AD2(rcount_2), 
            .AD3(rptr_2), .DO0(empty_cmp_set)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(696[20] 707[2])
    defparam LUT4_3.initval = 16'b0000010000010000;
    ROM16X1A LUT4_2 (.AD0(GND_net), .AD1(w_gcount_r22), .AD2(rcount_2), 
            .AD3(rptr_2), .DO0(empty_cmp_clr)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(696[20] 707[2])
    defparam LUT4_2.initval = 16'b0001000000000100;
    ROM16X1A LUT4_1 (.AD0(GND_net), .AD1(r_gcount_w22), .AD2(wcount_2), 
            .AD3(wptr_2), .DO0(full_cmp_set)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(696[20] 707[2])
    defparam LUT4_1.initval = 16'b0000000101000000;
    ROM16X1A LUT4_0 (.AD0(GND_net), .AD1(r_gcount_w22), .AD2(wcount_2), 
            .AD3(wptr_2), .DO0(full_cmp_clr)) /* synthesis syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(696[20] 707[2])
    defparam LUT4_0.initval = 16'b0100000000000001;
    DP16KD pdp_ram_0_0_0 (.DIA0(\w_rx_24_fifo_data[0] ), .DIA1(\w_rx_24_fifo_data[1] ), 
           .DIA2(\w_rx_24_fifo_data[2] ), .DIA3(\w_rx_24_fifo_data[3] ), 
           .DIA4(\w_rx_24_fifo_data[4] ), .DIA5(\w_rx_24_fifo_data[5] ), 
           .DIA6(\w_rx_24_fifo_data[6] ), .DIA7(\w_rx_24_fifo_data[7] ), 
           .DIA8(\w_rx_24_fifo_data[8] ), .DIA9(\w_rx_24_fifo_data[9] ), 
           .DIA10(\w_rx_24_fifo_data[10] ), .DIA11(\w_rx_24_fifo_data[11] ), 
           .DIA12(\w_rx_24_fifo_data[12] ), .DIA13(\w_rx_24_fifo_data[13] ), 
           .DIA14(\w_rx_24_fifo_data[14] ), .DIA15(\w_rx_24_fifo_data[15] ), 
           .DIA16(GND_net), .DIA17(GND_net), .ADA0(VCC_net), .ADA1(VCC_net), 
           .ADA2(GND_net), .ADA3(GND_net), .ADA4(wptr_0), .ADA5(wptr_1), 
           .ADA6(GND_net), .ADA7(GND_net), .ADA8(GND_net), .ADA9(GND_net), 
           .ADA10(GND_net), .ADA11(GND_net), .ADA12(GND_net), .ADA13(GND_net), 
           .CEA(wren_i), .OCEA(wren_i), .CLKA(sdr_rxclk_c), .WEA(VCC_net), 
           .CSA0(GND_net), .CSA1(GND_net), .CSA2(GND_net), .RSTA(main_reset_n_N_208), 
           .DIB0(GND_net), .DIB1(GND_net), .DIB2(GND_net), .DIB3(GND_net), 
           .DIB4(GND_net), .DIB5(GND_net), .DIB6(GND_net), .DIB7(GND_net), 
           .DIB8(GND_net), .DIB9(GND_net), .DIB10(GND_net), .DIB11(GND_net), 
           .DIB12(GND_net), .DIB13(GND_net), .DIB14(GND_net), .DIB15(GND_net), 
           .DIB16(GND_net), .DIB17(GND_net), .ADB0(GND_net), .ADB1(GND_net), 
           .ADB2(GND_net), .ADB3(GND_net), .ADB4(rptr_0), .ADB5(rptr_1), 
           .ADB6(GND_net), .ADB7(GND_net), .ADB8(GND_net), .ADB9(GND_net), 
           .ADB10(GND_net), .ADB11(GND_net), .ADB12(GND_net), .ADB13(GND_net), 
           .CEB(rden_i), .OCEB(rden_i), .CLKB(internal_80MHz), .WEB(GND_net), 
           .CSB0(GND_net), .CSB1(GND_net), .CSB2(GND_net), .RSTB(main_reset_n_N_208), 
           .DOB0(wifi_q_fifo_data_out[0]), .DOB1(wifi_q_fifo_data_out[1]), 
           .DOB2(wifi_q_fifo_data_out[2]), .DOB3(wifi_q_fifo_data_out[3]), 
           .DOB4(wifi_q_fifo_data_out[4]), .DOB5(wifi_q_fifo_data_out[5]), 
           .DOB6(wifi_q_fifo_data_out[6]), .DOB7(wifi_q_fifo_data_out[7]), 
           .DOB8(wifi_q_fifo_data_out[8]), .DOB9(wifi_q_fifo_data_out[9]), 
           .DOB10(wifi_q_fifo_data_out[10]), .DOB11(wifi_q_fifo_data_out[11]), 
           .DOB12(wifi_q_fifo_data_out[12]), .DOB13(wifi_q_fifo_data_out[13]), 
           .DOB14(wifi_q_fifo_data_out[14]), .DOB15(wifi_q_fifo_data_out[15])) /* synthesis MEM_LPC_FILE="fifo_dc_16in_16out.lpc", MEM_INIT_FILE="", syn_instantiated=1, LSE_LINE_FILE_ID=3, LSE_LCOL=20, LSE_RCOL=2, LSE_LLINE=696, LSE_RLINE=707 */ ;   // c:/users/julianstj/desktop/worknotes/projects/ptp/wiwi/sdr/software/ecp5_test/top.v(696[20] 707[2])
    defparam pdp_ram_0_0_0.DATA_WIDTH_A = 18;
    defparam pdp_ram_0_0_0.DATA_WIDTH_B = 18;
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
