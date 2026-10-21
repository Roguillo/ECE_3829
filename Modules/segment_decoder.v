`timescale 10ns / 10ps

module segment_decoder(
    input  wire [3:0]nibble,
    
    output reg  [7:0]segments
    );
    
    // active-low
    always @(*) begin
        case(nibble)             //DpGFE_DCBA
            4'h0   : segments = ~8'b0011_1111;
            4'h1   : segments = ~8'b0000_0110;
            4'h2   : segments = ~8'b0101_1011;
            4'h3   : segments = ~8'b0100_1111;
            4'h4   : segments = ~8'b0110_0110;
            4'h5   : segments = ~8'b0110_1101;
            4'h6   : segments = ~8'b0111_1101;
            4'h7   : segments = ~8'b0000_0111;
            4'h8   : segments = ~8'b0111_1111;
            4'h9   : segments = ~8'b0110_1111;
            
            default: segments = ~8'b0011_1111;
        endcase
    end
    
endmodule
