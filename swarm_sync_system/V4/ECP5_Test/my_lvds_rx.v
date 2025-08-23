

module word_align_3state #(
    parameter MATCH_THRESHOLD = 2
)(
    input  wire        i_rst_b,     // Active-low reset
    input  wire        i_ddr_clk,   // 2 bits arrive each clock
    input  wire [1:0]  i_ddr_data,  // Incoming 2-bit data
    output reg         o_fifo_push, // Strobe when a valid 32-bit word is found
    output reg [31:0]  o_fifo_data  // The 32-bit word pushed out
);

    //--------------------------------------------------------
    // 1) FSM States
    //--------------------------------------------------------
    localparam [1:0] ST_SEARCH  = 2'd0,
                     ST_CONFIRM = 2'd1,
                     ST_LOCKED  = 2'd2;

    //--------------------------------------------------------
    // 2) State & Registers
    //--------------------------------------------------------
    reg [1:0]  r_state, r_state_next;

    // 33-bit shift register (to allow offset=0 or offset=1).
    // We'll hold the "current" version in sr, the "next" version in sr_next.
    reg [32:0] sr, sr_next;

    // Consecutive valid hits 
    reg [3:0] match_count, match_count_next;

    // The offset we are confirming or have locked (0 or 1)
    reg        r_candidate_offset, r_candidate_offset_next;

    // Once locked or in confirm, we wait 16 clocks for a new 32-bit boundary
    reg [7:0]  sample_count, sample_count_next;

    // Next-cycle outputs
    reg        fifo_push_next;
    reg [31:0] fifo_data_next;

    //--------------------------------------------------------
    // 3) Next-Shift Register (Combinational)
    //
    // We'll shift left by 2 bits: sr_next[32:2] = sr[30:0]
    // and the new bits go into sr_next[1:0] = i_ddr_data.
    // Then we do the validity check on sr_next in the same cycle.
    //--------------------------------------------------------
    always @* begin
        sr_next = { sr[30:0], i_ddr_data };  // left-shift by 2
    end

    //--------------------------------------------------------
    // 4) Candidate Words for offset=0 or offset=1
    //    (from sr_next, the *new* shift register contents)
    //--------------------------------------------------------
    wire [31:0] word_offset0 = sr[32:1]; // offset=0
    wire [31:0] word_offset1 = sr[31:0]; // offset=1

    //--------------------------------------------------------
    // 5) Validity Check Function
    //--------------------------------------------------------
    function is_valid_word;
        input [31:0] w;
        reg   pattern_ok;
        begin
            // Known pattern bits:
            //   w[31:30] = 2'b10
            //   w[16]    = 1'b0
            //   w[15:14] = 2'b01
            //   w[0]     = 1'b0
            pattern_ok = (w[31:30] == 2'b10) &&
                         (w[16]    == 1'b0 ) &&
                         (w[15:14] == 2'b01) &&
                         (w[0]     == 1'b0  );
            // Valid if pattern_ok or all zero
            is_valid_word = pattern_ok || (w == 32'h00000000);
        end
    endfunction
	
	function is_real_word;
        input [31:0] w;
        reg   pattern_ok;
        begin
            // Known pattern bits:
            //   w[31:30] = 2'b10
            //   w[16]    = 1'b0
            //   w[15:14] = 2'b01
            //   w[0]     = 1'b0
            pattern_ok = (w[31:30] == 2'b10) &&
                         (w[16]    == 1'b0 ) &&
                         (w[15:14] == 2'b01) &&
                         (w[0]     == 1'b0  );
            // Valid if pattern_ok or all zero
            is_real_word = pattern_ok ;
        end
    endfunction
	

    wire valid_0 = is_valid_word(word_offset0);
    wire valid_1 = is_valid_word(word_offset1);
	
	wire real_0 = is_real_word(word_offset0);
    wire real_1 = is_real_word(word_offset1);
	
	// helper mux 	
	wire [31:0] candidate_sr = r_candidate_offset ? word_offset1 : word_offset0;	
	wire real_candidate = is_real_word(candidate_sr);
	wire valid_candidate = is_valid_word(candidate_sr);

    //--------------------------------------------------------
    // 6) Combinational FSM & Next-State Logic
    //--------------------------------------------------------
    always @* begin
        // Default assignments
        r_state_next           = r_state;
        match_count_next     = match_count;
        r_candidate_offset_next= r_candidate_offset;
        sample_count_next      = sample_count;
        fifo_push_next         = 1'b0;
        fifo_data_next         = o_fifo_data;

        case (r_state)
        //----------------------------------------------------
        // ST_SEARCH:
        //  Each clock, we have sr_next with new bits => check
        //  offset=0 or offset=1. If consecutive hits reach
        //  MATCH_THRESHOLD => ST_CONFIRM.
        //----------------------------------------------------
        ST_SEARCH: begin
            // Not using sample_count/error_count here
            sample_count_next = 8'd0;
			match_count_next = 4'd0;

            // found real word, confirm it
            if (real_0) begin
				r_state_next = ST_CONFIRM;
				r_candidate_offset_next = 1'b0; // setup mux
				sample_count_next = 8'd0; // not sure about this, off by one? I think need to set this here
			end
			else if (real_1) begin
				r_state_next = ST_CONFIRM;
				r_candidate_offset_next = 1'b1;
				sample_count_next = 8'd0;
			end
        end

        //----------------------------------------------------
        // ST_CONFIRM:
        //  We have a candidate offset. Wait 16 clocks
        //  to see if the next 32-bit boundary is also valid.
        //  If yes enough times => ST_LOCKED, else => ST_SEARCH.
        //----------------------------------------------------
        ST_CONFIRM: begin
            sample_count_next  = sample_count + 8'd1; // keep adding samples 
            if (sample_count == 8'd15) begin // 16 or 15 not sure?????? 
                sample_count_next = 8'd0; // reset back to zero, maybe reset to 1???				
				if (real_candidate) begin
					if ( match_count >= MATCH_THRESHOLD ) begin
						match_count_next = 4'd0;
						r_state_next = ST_LOCKED; 
					end else begin
						match_count_next = match_count + 4'd1; 
					end
				end else if ( valid_candidate ) begin
					// 0 frame case
					//don't do anything , doesn't hurt but not validating 
				end else begin
					// not valid 
					match_count_next = 4'd0;
					r_state_next = ST_SEARCH;
				end
            end
        end

        //----------------------------------------------------
        // ST_LOCKED:
        //----------------------------------------------------
        ST_LOCKED: begin
            sample_count_next  = sample_count + 1'b1;
            if (sample_count == 8'd15) begin // 16 or 15 not sure?????? 
                sample_count_next = 8'd0; // reset back to zero, maybe reset to 1???				
				if (real_candidate) begin
					fifo_data_next = candidate_sr;
					fifo_push_next = 1'b1; // found real candidate and it's still valid , push it 					
				end else if ( valid_candidate ) begin
					// zero word, do nothing 
				end else begin
					// invalid word, hopefully shouldn't happen
					match_count_next = 4'd0;
					sample_count_next = 8'd0; // reset counters 
					r_state_next = ST_SEARCH;
				end
			end 
        end

        default: r_state_next = ST_SEARCH;
        endcase
    end

    //--------------------------------------------------------
    // 7) Sequential Logic: Latch sr_next & FSM registers
    //--------------------------------------------------------
    always @(posedge i_ddr_clk or negedge i_rst_b) begin
        if (!i_rst_b) begin
            // Asynch reset
            r_state            <= ST_SEARCH;
            sr                 <= 33'd0;
            match_count      <= 4'd0;
            r_candidate_offset <= 1'b0;
            sample_count       <= 8'd0;
            o_fifo_push        <= 1'b0;
            o_fifo_data        <= 32'd0;
        end
        else begin
            // Latch the new shift register (computed in comb block)
            sr                 <= sr_next;
            // Update FSM
            r_state            <= r_state_next;
            match_count      <= match_count_next;
            r_candidate_offset <= r_candidate_offset_next;
            sample_count       <= sample_count_next;
            // Update outputs
            o_fifo_push <= fifo_push_next;
            o_fifo_data <= fifo_data_next;
        end
    end

endmodule

