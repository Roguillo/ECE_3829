`timescale 10ns / 10ps

module synchronizer(
    input  wire clk          , rst, ext_signal,
    
    output reg  synced_signal
    );

    // intermediary flip-flop
    reg ff;
    
    always @(posedge clk) begin
        if(rst) begin
            ff            <= 1'b0;
            synced_signal <= 1'b0;
        end
        
        // two-stage assignment
        else begin
            ff            <= ext_signal;
            synced_signal <= ff;
        end
    end
endmodule
