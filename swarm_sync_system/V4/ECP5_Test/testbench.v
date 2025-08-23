`timescale 1ns/1ps

module tb_word_align;

    //=================================================
    // 1) Clock & Reset Generation
    //=================================================
    reg  i_rst_b;
    reg  i_ddr_clk;
    reg  [1:0] i_ddr_data;

    wire        o_fifo_push;
    wire [31:0] o_fifo_data;

    // Clock period = 10ns -> 100 MHz
    parameter CLK_PER = 10;

    // Generate clock
    always begin
        #(CLK_PER/2);
        i_ddr_clk = ~i_ddr_clk;
    end

    //=================================================
    // 2) Instantiate the Word-Align DUT
    //    (the 3-state module)
    //=================================================
    word_align_3state #(
        .MATCH_THRESHOLD(2),
        .ERROR_THRESHOLD(4)
    ) dut (
        .i_rst_b     (i_rst_b),
        .i_ddr_clk   (i_ddr_clk),
        .i_ddr_data  (i_ddr_data),
        .o_fifo_push (o_fifo_push),
        .o_fifo_data (o_fifo_data)
    );

    //=================================================
    // 3) Tasks: feed a 32-bit word at a chosen offset
    //=================================================
    // feed_32bits(word, offset):
    //   - 'word' is the 32-bit data to feed
    //   - 'offset' can be 0 or 1 to artificially shift
    //     the bits by 0 or 1 within the 2-bit boundary.
    //
    // This means if offset=1, we will shift by 1 bit
    // before continuing. It's a simplistic approach
    // to demonstrate misalignment.
    //-------------------------------------------------

    task feed_32bits(
        input [31:0] data_word,
        input integer offset
    );
        integer i;
        reg [32:0] local_shift;
        begin
            // local_shift includes 1 extra bit for offset=1
            // We'll load the 32 bits + 1 "dummy" bit = 33.
            // Then we output them 2 bits at a time.
            local_shift = {1'b0, data_word}; // top bit is extra for offset=1

            // If offset=1, shift the data by 1 to the right
            // so the first bit goes out alone, then the next
            // bits are fed in 2-bit chunks.
            if (offset == 1) begin
                // Output 1 bit first
                i_ddr_data = {local_shift[0], 1'b0};  // The bottom bit + 0
                #(CLK_PER);
                i_ddr_clk = ~i_ddr_clk;
                #(CLK_PER/2);

                // Now shift out the rest 1 bit
                local_shift = local_shift >> 1;
            end

            // Now feed the rest 32 bits in pairs
            for (i = 0; i < 16; i = i + 1) begin
                i_ddr_data = local_shift[1:0];
                #(CLK_PER);
                i_ddr_clk = ~i_ddr_clk;
                #(CLK_PER/2);

                local_shift = local_shift >> 2;
            end
        end
    endtask

    //=================================================
    // 4) Known "Valid" Pattern Generator
    //    (Matches the DUT's pattern bits)
    //=================================================
    // Create a 32-bit word that meets:
    //   w[31:30] = 2'b10
    //   w[16]    = 1'b0
    //   w[15:14] = 2'b01
    //   w[0]     = 1'b0
    // Fill the other bits arbitrarily or zero them.
    //-------------------------------------------------
    function [31:0] make_valid_word;
        input [11:0] filler;
        reg   [31:0] w;
        begin
            w = 32'd0;
            // Force known pattern
            w[31:30] = 2'b10;
            w[16]    = 1'b0;
            w[15:14] = 2'b01;
            w[0]     = 1'b0;
            // Put filler bits somewhere (e.g., [29:18])
            w[29:18] = filler;  // just arbitrary
            make_valid_word = w;
        end
    endfunction

    // Zero word is also valid
    localparam [31:0] ZERO_WORD = 32'h00000000;

    //=================================================
    // 5) Test Stimulus
    //=================================================
    initial begin
        // Initialize
        i_ddr_clk  = 1'b0;
        i_ddr_data = 2'b00;
        i_rst_b    = 1'b0;

        // Wait a bit, release reset
        #(CLK_PER*5);
        i_rst_b = 1'b1;

        // Wait a couple of cycles
        #(CLK_PER*2);

        // CASE A: No offset, feed one valid word + zero word
        $display("\n=== CASE A: offset=0, valid word + zero word ===");
        feed_32bits(make_valid_word(12'hABC), 0);
        feed_32bits(ZERO_WORD, 0);

        // Wait a few cycles
        #(CLK_PER*5);

        // CASE B: offset=1, feed two valid words
        //  This tests the single-bit slip scenario
        $display("\n=== CASE B: offset=1, two valid words ===");
        feed_32bits(make_valid_word(12'h123), 1);
        feed_32bits(make_valid_word(12'h999), 1);

        #(CLK_PER*5);

        // CASE C: continuous valid words offset=0
        // This checks that we don't miss consecutive frames
        $display("\n=== CASE C: continuous valid words, offset=0 ===");
        feed_32bits(make_valid_word(12'h111), 0);
        feed_32bits(make_valid_word(12'h222), 0);
        feed_32bits(make_valid_word(12'h333), 0);
        feed_32bits(make_valid_word(12'h444), 0);

        #(CLK_PER*10);

        // CASE D: feed mid-stream
        //  We'll do a partial feed, then reset, then continue
        //  to show we can reacquire lock in the middle
        $display("\n=== CASE D: mid-stream start + offset=1 ===");
        feed_32bits({16'hABCD, 16'hEFAA}, 0); // random partial
        // short pause
        #(CLK_PER*3);
        // Reset mid-stream
        i_rst_b = 1'b0;
        #(CLK_PER*2);
        i_rst_b = 1'b1;
        #(CLK_PER*2);
        // now feed valid offset=1
        feed_32bits(make_valid_word(12'heee), 1);
        feed_32bits(make_valid_word(12'hFFF), 1);

        #(CLK_PER*20);

        $display("\n=== TEST COMPLETE ===");
        $stop;
    end

    //=================================================
    // 6) Monitor
    //=================================================
    // Optionally, monitor the pushes
    initial begin
        $display("Time=%t : Starting simulation...", $time);
        $monitor("Time=%t : push=%b data=%h", $time, o_fifo_push, o_fifo_data);
    end

endmodule
