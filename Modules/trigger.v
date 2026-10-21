`timescale 10ns / 10ps

module trigger #(
        parameter COOLDOWN = 60 // ms
        
    )(
        input  wire clk           , rst, start, free_run_mode,
    
        output wire trigger_signal
    );
    
    localparam CLOCK_FREQUENCY          =  100_000_000;
    localparam PULSE_TERM_COUNT         =  CLOCK_FREQUENCY / 100_000;
    localparam COOLDOWN_TERM_COUNT      = (CLOCK_FREQUENCY / 1000 ) * COOLDOWN;
    localparam COOLDOWN_TERM_COUNT_BITS = $clog2(COOLDOWN_TERM_COUNT);
    
    reg                               run;
    reg [COOLDOWN_TERM_COUNT_BITS-1:0]cooldown_count;
    
    assign trigger_signal = (cooldown_count > 0) && (cooldown_count <= PULSE_TERM_COUNT);
    
    always @(posedge clk) begin
        if(rst) begin
            run            <= 1'b0;
            cooldown_count <= {COOLDOWN_TERM_COUNT_BITS{1'd0}};
        end
        
        else begin
            if(start || (free_run_mode && !run)) run <= 1'b1;
            
            if(run) begin
                if(cooldown_count >= COOLDOWN_TERM_COUNT - 1) begin
                    cooldown_count <= {COOLDOWN_TERM_COUNT_BITS{1'd0}};
                    run            <= 1'b0;
                end
                
                else cooldown_count <= cooldown_count + 1'd1;
            end
        end
    end
endmodule
