`timescale 10ns / 10ps

module echo(
        input  wire      clk         , rst , echo_rise, echo_fall, echo_tick,
        
        output reg       done,
        output reg  [8:0]distance_val
    );
    
    reg       run;
    reg [8:0] count;
    
    always @(posedge clk) begin
        if(rst) begin
            run          <= 1'b0;
            count        <= 9'd0;
            done         <= 1'b0;
            distance_val <= 9'd0;
        end
        
        else begin
            done <= 1'b0;
            
            if(echo_rise) begin
                run   <= 1'b1;
                count <= 9'd0;
            end
            
            if(run) begin
                if(echo_fall || (count == 400)) begin
                    run          <= 1'b0;
                    done         <= 1'b1;
                    distance_val <= count;
                end
                
                else if(echo_tick) count <= count + 1'd1;
            end
        end
    end
endmodule