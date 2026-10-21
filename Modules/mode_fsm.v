`timescale 10ns / 10ps

module mode_fsm #(
        parameter TOGGLE_PATTERN_DURATION = 1000 // ms

    )(
        input  wire clk      , rst           , btnu_press, ms_tick,
        
        output reg  auto_mode, toggle_pattern
    );

    reg  start_timer;
    wire timer_done;
    
    timer #(.DURATION(TOGGLE_PATTERN_DURATION)) timer_0 (
        .clk(clk)        , .rst(rst), .start(start_timer), .ms_tick(ms_tick),
        .done(timer_done)
    );

    always @(posedge clk) begin
        if(rst) begin
            start_timer    <= 1'b0;
            auto_mode      <= 1'b1;
            toggle_pattern <= 1'b0;
        end
        
        else begin
            start_timer <= 1'b0;
            
            if(btnu_press) begin
                auto_mode      <= ~auto_mode;
                toggle_pattern <= 1'b1;
                start_timer    <= 1'b1;
            end
            
            if(timer_done) toggle_pattern <= 1'b0;
        end
    end
endmodule
