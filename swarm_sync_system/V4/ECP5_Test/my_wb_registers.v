module wb_8bit_regs_alternate (
    input  wire        wb_clk_i,   // Wishbone clock
    input  wire        wb_rst_i,   // Wishbone reset (active high)
    input  wire        wb_cyc_i,   // Wishbone cycle
    input  wire        wb_stb_i,   // Wishbone strobe
    input  wire        wb_we_i,    // Write enable (1=write, 0=read)
    input  wire [7:0]  wb_adr_i,   // 8-bit address
    input  wire [7:0]  wb_dat_i,   // 8-bit data input (for writes)
    output reg  [7:0]  wb_dat_o,   // 8-bit data output (for reads)
    output reg         wb_ack_o    // Acknowledge
);

  //------------------------------------------------
  // Three 8-bit registers in this slave
  //------------------------------------------------
  reg [7:0] reg0, reg1, reg2;

  //------------------------------------------------
  // 1) WRITE LOGIC
  //    If WE=1, store wb_dat_i into the selected reg
  //    This happens on the rising edge of wb_clk_i.
  //------------------------------------------------
  always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
      reg0 <= 8'h00;
      reg1 <= 8'h00;
      reg2 <= 8'h00;
    end 
    else if (wb_cyc_i && wb_stb_i && wb_we_i) begin
      case (wb_adr_i)
        8'h00: reg0 <= wb_dat_i;
        8'h01: reg1 <= wb_dat_i;
        8'h02: reg2 <= wb_dat_i;
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
    case (wb_adr_i)
      8'h00: data_mux = reg0;
      8'h01: data_mux = reg1;
      8'h02: data_mux = reg2;
      default: data_mux = 8'hFF; // Default for invalid address
    endcase
  end

  //------------------------------------------------
  // 3) OUTPUT DATA & ACK (SYNCHRONOUS)
  //    - wb_dat_o is latched each clock from data_mux
  //    - wb_ack_o = 1 if cyc_i & stb_i, else 0
  //------------------------------------------------
  always @(posedge wb_clk_i) begin
    if (wb_rst_i) begin
      wb_dat_o <= 8'h00;
      wb_ack_o <= 1'b0;
    end 
    else begin
      // Latch the selected register into wb_dat_o
      wb_dat_o <= data_mux;

      // Single-cycle ACK: assert it when cyc_i & stb_i are active
      wb_ack_o <= (wb_cyc_i && wb_stb_i);
    end
  end

endmodule
