`timescale 1ns/1ps
module processor_tb;
    reg clk, reset;

    risc_processor uut (
        .clk(clk),
        .reset(reset)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    initial begin
        reset = 1;
        #10 reset = 0;

        // Run for some cycles
        #200;

        $stop;
    end
endmodule
