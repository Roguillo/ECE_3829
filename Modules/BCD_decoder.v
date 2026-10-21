`timescale 10ns / 10ps

module BCD_decoder(
    input  wire [8:0] num_b,
    
    output reg  [3:0] dig_0, dig_1, dig_2
    );
    
    reg [20:0]dabblespace;
        
    always @(*) begin
        dabblespace = {12'd0, num_b};
        
        repeat(9) begin
            if(dabblespace[12:9]  >= 5) dabblespace[12:9]  = dabblespace[12:9]  + 3;
            if(dabblespace[16:13] >= 5) dabblespace[16:13] = dabblespace[16:13] + 3;
            if(dabblespace[20:17] >= 5) dabblespace[20:17] = dabblespace[20:17] + 3;
            dabblespace = dabblespace << 1;
        end
        
        dig_0 = dabblespace[12:9];
        dig_1 = dabblespace[16:13];
        dig_2 = dabblespace[20:17];
    end
endmodule
