`timescale 1ns / 1ps

module step_mux(
        input  wire auto_mode, auto_step, auto_dir, btnl_press, btnr_press,
        
        output wire step_one , step_dir
    );
    
    assign step_one = (auto_mode) ? (auto_step) : (btnl_press || btnr_press);
    assign step_dir = (auto_mode) ? (auto_dir)  : (btnl_press);
endmodule
