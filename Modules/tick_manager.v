`timescale 10ns / 10ps

module tick_manager #(
        parameter DISPLAY_RATE     = 1000 // Hz

    )(
        input  wire clk         , rst,
        
        output wire display_tick, ms_tick, echo_tick
    );
    
    // System clock frequency and terminal count values
    localparam CLOCK_FREQUENCY    =  100_000_000;
    localparam DISPLAY_TERM_COUNT =  CLOCK_FREQUENCY / DISPLAY_RATE;
    localparam MS_TERM_COUNT      =  CLOCK_FREQUENCY / 1000;
    localparam ECHO_TERM_COUNT    =  5_800;
    
    // Bits for each terminal count
    localparam DISPLAY_TERM_COUNT_BITS = $clog2(DISPLAY_TERM_COUNT);
    localparam MS_TERM_COUNT_BITS      = $clog2(MS_TERM_COUNT);
    localparam ECHO_TERM_COUNT_BITS    = $clog2(ECHO_TERM_COUNT);
    
    // count registers
    reg [DISPLAY_TERM_COUNT_BITS-1:0] display_count;
    reg [MS_TERM_COUNT_BITS     -1:0] ms_count;
    reg [ECHO_TERM_COUNT_BITS   -1:0] echo_count;

    // tick output assignment
    assign display_tick = display_count == DISPLAY_TERM_COUNT - 1;
    assign ms_tick      = ms_count      == MS_TERM_COUNT      - 1;
    assign echo_tick    = echo_count    == ECHO_TERM_COUNT    - 1;
    
    always @(posedge clk) begin
        if(rst) begin
            display_count <= {DISPLAY_TERM_COUNT_BITS {1'd0}};
            ms_count      <= {MS_TERM_COUNT_BITS      {1'd0}};
            echo_count    <= {ECHO_TERM_COUNT_BITS    {1'd0}};
        end
        
        // reset if terminal, count upwards otherwise
        else begin
            // for display
            display_count <= (display_count >= DISPLAY_TERM_COUNT - 1) ? ({DISPLAY_TERM_COUNT_BITS{1'd0}}) : (display_count + 1'd1);
            
            // for debouncers and timers
            ms_count      <= (ms_count      >= MS_TERM_COUNT      - 1) ? ({MS_TERM_COUNT_BITS     {1'd0}}) : (ms_count      + 1'd1);
            
             // for echo handler
            echo_count    <= (echo_count    >= ECHO_TERM_COUNT    - 1) ? ({ECHO_TERM_COUNT_BITS   {1'd0}}) : (echo_count    + 1'd1);
        end
    end
endmodule
