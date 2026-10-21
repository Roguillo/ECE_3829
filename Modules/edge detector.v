`timescale 10ns / 10ps

module edge_detector(
        input  wire clk, rst, signal_lvl,
        
        output wire edge_rise, edge_fall 
    );

    // past signal
    reg signal_past;
    
    // edge assignments
    assign edge_rise = ~signal_past &&  signal_lvl;
    assign edge_fall =  signal_past && ~signal_lvl;

    // update past signal
    always @(posedge clk) signal_past <= (rst) ? (1'b0) : (signal_lvl);
endmodule
