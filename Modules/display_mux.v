`timescale 10ns / 10ps

module display_mux(
        input  wire      auto_mode,
        input  wire [8:0]curr_distance, newest_minimum,
        
        output wire [8:0]display_val
    );

    assign display_val = (auto_mode) ? (newest_minimum) : (curr_distance);
endmodule
