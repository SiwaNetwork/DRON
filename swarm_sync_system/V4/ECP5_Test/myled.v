module led_toggle (
    input wire clk,  // Input clock (95 MHz approximate)
    input wire reset,           // Asynchronous reset
    output reg led         // LED output
);

    reg [25:0] counter = 0;      // 26-bit counter to count 47,500,000 cycles

    // LED toggle logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            led <= 0;
        end else begin
            //if (counter == 12_000_000) begin // 25MHz value about
			if (counter == 4_800_000) begin // 9.6MHz value
                counter <= 0;         // Reset counter
                led <= ~led; // Toggle LED
            end else begin
                counter <= counter + 1; // Increment counter
            end
        end
    end

endmodule




module rising_edge_detector (
    input wire clk,  // Clock input
	input wire reset,           // Active-high reset
    input wire sig,        // Signal to detect rising edge on
    output reg rising_edge_detected // Output: 1 if rising edge detected
);

    reg sig_d1; // Delayed signal (previous state)
    reg sig_d2; // Delayed signal (two cycles ago)

    always @(posedge  clk or posedge reset) begin
        if (reset) begin
            sig_d1 <= 1'b0;
            sig_d2 <= 1'b0;
            rising_edge_detected <= 1'b0;
        end else begin
            // Update the delayed signals
            sig_d2 <= sig_d1;
            sig_d1 <= sig;

            // Detect a rising edge
            rising_edge_detected <= ~sig_d2 & sig_d1;
        end
    end
endmodule


module tristate_io_pin (
    inout  wire scl_pin, // Physical SCL pin
    input  wire scl_out, // Output control: 0 = drive low, 1 = release
    input  wire scl_oe,  // Output enable: 1 = enable scl_out, 0 = tri-state
    output wire scl_in   // Pin input (read the current SCL level)
);

    // If scl_oe = 1 and scl_out = 0 -> drive the pin low.
    // Otherwise -> tri-state (Z).
    assign scl_pin = (scl_oe && (scl_out == 1'b0)) ? 1'b0 : 1'bz;

    // Always read the pin level (whether driven or pulled up externally).
    assign scl_in = scl_pin;

endmodule
