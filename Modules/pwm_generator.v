`timescale 10ns / 10ps

module pwm_generator #(
        parameter PERIOD     =  50, // Hz
        parameter START_POS  = 600, // us
        parameter US_PER_DEG = 10
        
    )(
        input  wire      clk       , rst,
        input  wire [7:0]angle,
        
        output wire      pwm_signal
    );

    // system clock and counter + bits needed
    localparam CLOCK_FREQUENCY = 100_000_000;              // Hz
    localparam TERM_COUNT      = CLOCK_FREQUENCY / PERIOD;
    localparam TERM_COUNT_BITS = $clog2(TERM_COUNT);
    
    // counter register
    reg  [TERM_COUNT_BITS-1:0]count;
    
    // transfer function to get angle value in us, along with equivalent value in counts to compare against 50Hz counter
    wire [11:0]angle_us    = START_POS + (angle * US_PER_DEG);
    wire [17:0]pulse_width = angle_us * (CLOCK_FREQUENCY / 1_000_000);
    
    // high above zero and low below angle value
    assign pwm_signal = (count > 0) && (count <= pulse_width);
    
    always @(posedge clk) begin
        if(rst) count <= {TERM_COUNT_BITS{1'd0}};
        else    count <= (count >= TERM_COUNT - 1) ? ({TERM_COUNT_BITS{1'd0}}) : (count + 1'd1);
    end
endmodule
