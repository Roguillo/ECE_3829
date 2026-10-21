`timescale 10ns / 10ps

module cycle_fsm #(
        parameter STEP_INTERVAL = 6 // ms

    )(
        input  wire clk     , rst     , auto_mode  , echo_done            , at_min        , at_max, ms_tick,
        
        output wire step_one, step_dir, ping_sensor, update_newest_minimum, actually_flush
    );

    wire start_timer, timer_done;
    
    timer #(.DURATION(STEP_INTERVAL)) timer_0 (
        .clk(clk)        , .rst(rst), .start(start_timer), .ms_tick(ms_tick),
        .done(timer_done)
    );
    
    localparam S_IDLE                  = 3'b000;
    localparam S_STEP                  = 3'b001;
    localparam S_COOLDOWN              = 3'b010;
    localparam S_PING_SENSOR           = 3'b011;
    localparam S_UPDATE_NEWEST_MINIMUM = 3'b100;
    
    reg       dir_cmd   , must_flush;
    reg [2:0] curr_state, next_state;
    
    always @(posedge clk) curr_state <= (rst) ? (S_IDLE) : (next_state);
    
    always @(posedge clk) begin
        if(rst) begin
            dir_cmd    <= 1'b1;
            must_flush <= 1'b0;
        end
        
        else begin
            must_flush <= 1'b0;
            
            if(curr_state == S_UPDATE_NEWEST_MINIMUM) begin
                if(at_max) begin
                    must_flush <= 1'b1;
                    dir_cmd    <= 1'b0;
                end
                
                else if(at_min) begin
                    must_flush <= 1'b1;
                    dir_cmd    <= 1'b1;
                end
            end
        end
    end
    
    always @(*) begin
        next_state = curr_state;
        
        if(auto_mode) begin
            case(curr_state)
                S_IDLE                 :                next_state = S_STEP;
                S_STEP                 :                next_state = S_COOLDOWN;
                S_COOLDOWN             : if(timer_done) next_state = S_PING_SENSOR;
                S_PING_SENSOR          : if(echo_done)  next_state = S_UPDATE_NEWEST_MINIMUM;
                S_UPDATE_NEWEST_MINIMUM:                next_state = S_STEP;
                
                default                :                next_state = S_IDLE;
            endcase
        end
    end
    
    assign step_one              = (curr_state == S_STEP);
    assign step_dir              = dir_cmd;
    assign start_timer           = (curr_state == S_STEP);
    assign ping_sensor           = (curr_state == S_PING_SENSOR);
    assign update_newest_minimum = (curr_state == S_UPDATE_NEWEST_MINIMUM);
    assign actually_flush        = must_flush && (curr_state == S_STEP);
endmodule
