`timescale 10ns / 10ps

module led_mux(
        input  wire       auto_mode , toggle_pattern, dir,
        input  wire [7:0] angle,
        
        output reg  [15:0]led_values
    );
    
    always @(*) begin
        if(toggle_pattern) led_values = 16'b1100_1000_0001_0011;
        
        else begin
            if(auto_mode) begin
                if      (angle <   11)                   led_values = 16'b0000_0000_0000_0001;
                else if((angle >=  11) && (angle <  22)) led_values = 16'b0000_0000_0000_0010;
                else if((angle >=  22) && (angle <  33)) led_values = 16'b0000_0000_0000_0100;
                else if((angle >=  33) && (angle <  45)) led_values = 16'b0000_0000_0000_1000;
                else if((angle >=  45) && (angle <  56)) led_values = 16'b0000_0000_0001_0000;
                else if((angle >=  56) && (angle <  67)) led_values = 16'b0000_0000_0010_0000;
                else if((angle >=  67) && (angle <  78)) led_values = 16'b0000_0000_0100_0000;
                else if((angle >=  78) && (angle <  90)) led_values = 16'b0000_0000_1000_0000;
                else if((angle >=  90) && (angle < 101)) led_values = 16'b0000_0001_0000_0000;
                else if((angle >= 101) && (angle < 112)) led_values = 16'b0000_0010_0000_0000;
                else if((angle >= 112) && (angle < 123)) led_values = 16'b0000_0100_0000_0000;
                else if((angle >= 123) && (angle < 135)) led_values = 16'b0000_1000_0000_0000;
                else if((angle >= 135) && (angle < 146)) led_values = 16'b0001_0000_0000_0000;
                else if((angle >= 146) && (angle < 157)) led_values = 16'b0010_0000_0000_0000;
                else if((angle >= 157) && (angle < 168)) led_values = 16'b0100_0000_0000_0000;
                else                                     led_values = 16'b1000_0000_0000_0000;
            end
            
            else led_values = (dir) ? (16'b1111_1111_0000_0000) : (16'b0000_0000_1111_1111);
        end
    end
endmodule
