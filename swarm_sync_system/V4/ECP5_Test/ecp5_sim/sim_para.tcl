lappend auto_path "C:/lscc/diamond/3.14/data/script"
package require simulation_generation
set ::bali::simulation::Para(DEVICEFAMILYNAME) {ECP5U}
set ::bali::simulation::Para(PROJECT) {ecp5_sim}
set ::bali::simulation::Para(PROJECTPATH) {C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test}
set ::bali::simulation::Para(FILELIST) {"C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test/myspi.v" "C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test/fifo_dc_16in_16out/fifo_dc_16in_16out.v" "C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test/my_lvds_rx.v" "C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test/i2c_slave.v" "C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test/i2c_slave_wbm.v" "C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test/myled.v" "C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test/pll_10MHzInput/pll_10MHzInput.v" "C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test/internal_pll/internal_pll.v" "C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test/top.v" "C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test/lvds_rx.v" "C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test/i2cslave_controller.v" "C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test/filter.v" "C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test/i2cslave_controller_top.v" "C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test/fifo_dc_2in_2out/fifo_dc_2in_2out.v" "C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test/ddr_workaround.v" "C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test/fifo_dc_32in_1out/fifo_dc_32in_1out.v" "C:/Users/julianstj/Desktop/WorkNotes/Projects/PTP/WiWi/SDR/Software/ECP5_Test/testbench.v" }
set ::bali::simulation::Para(GLBINCLIST) {}
set ::bali::simulation::Para(INCLIST) {"none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none" "none"}
set ::bali::simulation::Para(WORKLIBLIST) {"work" "work" "work" "work" "work" "work" "work" "work" "work" "work" "work" "work" "work" "work" "work" "work" "work" }
set ::bali::simulation::Para(COMPLIST) {"VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" }
set ::bali::simulation::Para(LANGSTDLIST) {"Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" }
set ::bali::simulation::Para(SIMLIBLIST) {pmi_work ovi_ecp5u}
set ::bali::simulation::Para(MACROLIST) {}
set ::bali::simulation::Para(SIMULATIONTOPMODULE) {tb_word_align}
set ::bali::simulation::Para(SIMULATIONINSTANCE) {}
set ::bali::simulation::Para(LANGUAGE) {VERILOG}
set ::bali::simulation::Para(SDFPATH)  {}
set ::bali::simulation::Para(INSTALLATIONPATH) {C:/lscc/diamond/3.14}
set ::bali::simulation::Para(ADDTOPLEVELSIGNALSTOWAVEFORM)  {1}
set ::bali::simulation::Para(RUNSIMULATION)  {1}
set ::bali::simulation::Para(SIMULATION_RESOLUTION)  {ns}
set ::bali::simulation::Para(HDLPARAMETERS) {}
set ::bali::simulation::Para(POJO2LIBREFRESH)    {}
set ::bali::simulation::Para(POJO2MODELSIMLIB)   {}
set ::bali::simulation::Para(OPTIMIZEARGS)  {+acc}
set ::bali::simulation::Para(OPTIMIZATION_DEBUG)  {1}
::bali::simulation::QuestaSim_Run
