`timescale 10ns / 10ps

module angle_register #(
        parameter MINIMUM_ANGLE   =   0, // deg
        parameter MAXIMUM_ANGLE   = 180, // deg
        parameter STEP_SIZE       =  22  // deg

    )(
        input  wire      clk    , rst   , load, step_one, step_dir, auto_mode,
        input  wire [7:0]value,
        
        output wire      at_min , at_max,
        output reg       dir_reg,
        output reg  [7:0]angle
    );

    wire [7:0] step;

    assign step   = (auto_mode) ? (1'd1) : (STEP_SIZE);
    assign at_max = (angle == MAXIMUM_ANGLE);
    assign at_min = (angle == MINIMUM_ANGLE);

    always @(posedge clk) begin
        if(rst) begin
            dir_reg <= 1'b0;
            angle   <= 8'd0;
        end
                          
        else if(!auto_mode && load) begin
            if     (value >= MAXIMUM_ANGLE) angle <= MAXIMUM_ANGLE;
            else if(value <= MINIMUM_ANGLE) angle <= MINIMUM_ANGLE;
            else                            angle <= value;
        end
        
        else if(step_one) begin
            if(step_dir) angle <= ((angle + step) >= MAXIMUM_ANGLE)          ? (MAXIMUM_ANGLE) : (angle + step);
            else         angle <= (angle          <= (step + MINIMUM_ANGLE)) ? (MINIMUM_ANGLE) : (angle - step);
            
            dir_reg <= step_dir;
        end
    end
endmodule
