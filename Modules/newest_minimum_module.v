`timescale 10ns / 10ps

module newest_minimum_register(
        input  wire      clk            , rst, flush, update,
        input  wire [8:0]value,
        
        output reg  [8:0]display_minimum
    );
    
    localparam MAX_DISTANCE = 400; // cm
    
    reg [8:0] newest_minimum;
    
    always @(posedge clk) begin
        if (rst) begin
            newest_minimum  <= MAX_DISTANCE;
            display_minimum <= MAX_DISTANCE;
        end

        else if(flush) begin
            display_minimum <= newest_minimum;
            newest_minimum  <= MAX_DISTANCE;
        end

        else if(update && (value < newest_minimum)) newest_minimum <= value;
    end
endmodule
