`timescale 10ns / 10ps

module display_driver(
        input wire      clk  , rst  , display_tick,
        input wire [7:0]dig_0, dig_1, dig_2,
        
        output reg [3:0]anode,
        output reg [7:0]segments
    );
    
    always @(posedge clk) begin
        if(rst) begin
            segments <= dig_0;
            anode    <= 4'b1110;
        end
        
        // cycle through anodes
        else if(display_tick) begin
            case(anode)
                4'b1110: begin
                    anode      <= 4'b1101; 
                    segments   <= dig_1;
                end
                
                4'b1101: begin
                    anode      <= 4'b1011; 
                    segments   <= dig_2;
                end
                
                4'b1011: begin
                    anode      <= 4'b1110;
                    segments   <= dig_0;
                end
                
                default: begin
                    anode      <= 4'b1110;
                    segments   <= dig_0;
                end
            endcase
        end
    end
    
endmodule
