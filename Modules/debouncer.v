`timescale 10ns / 10ps

module debouncer #(
        parameter DEBOUNCE_WINDOW = 20 // ms
    )(
        input  wire clk       , rst, signal_raw, ms_tick,
        
        output reg  signal_lvl
    );
    
    // bits for count
    localparam COUNT_BITS = $clog2(DEBOUNCE_WINDOW);
    
    // past signal and counter
    reg                 signal_past;
    reg [COUNT_BITS-1:0]count;
    
    always@(posedge clk) begin
        if(rst) begin
            count       <= {COUNT_BITS{1'd0}};
            signal_past <= 1'b0;
            signal_lvl  <= 1'b0;
        end
        
        // reset count at change, update past signal
        else if(signal_raw != signal_past) begin
            signal_past <= signal_raw;
            count       <= {COUNT_BITS{1'd0}};
        end
        
        // count every ms, update signal if debounce window covered
        else if(ms_tick) begin
            if(count >= DEBOUNCE_WINDOW - 1) signal_lvl <= signal_past;
            else                             count      <= count + 1;
        end
    end
endmodule
