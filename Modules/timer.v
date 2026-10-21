`timescale 10ns / 10ps

module timer #(
        parameter DURATION = 1000 // ms

        )(
        input  wire clk , rst, start, ms_tick,
        
        output reg  done
    );

    // bits for count
    localparam COUNT_BITS = $clog2(DURATION);
    
    // run flag and counter
    reg                 run;
    reg [COUNT_BITS-1:0]count;

    always @(posedge clk) begin
        if(rst) begin
            count <= {COUNT_BITS{1'd0}};
            run   <= 1'b0;
            done  <= 1'b0; 
        end

        else begin
            // set to zero every cycle by default to avoid waiting a millisecond to change it back
            done <= 1'b0;
            
            // raise run flag upon start signal high
            if(start) run <= 1'b1;
            
            // count every ms if running
            if(run && ms_tick) begin
                if(count >= DURATION - 1) begin
                    count <= {COUNT_BITS{1'd0}};
                    run   <= 1'b0;
                    done  <= 1'b1;
                end
                
                else count <= count + 1'd1;
            end
        end
    end
endmodule
