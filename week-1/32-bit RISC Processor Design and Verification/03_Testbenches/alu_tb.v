`timescale 1ns/1ps
module alu_tb;
    reg [31:0] a, b;
    reg [3:0] alu_control;
    wire [31:0] result;
    wire zero;

    alu uut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    initial begin
        // Test AND
        a = 32'hA5A5A5A5; b = 32'h5A5A5A5A; alu_control = 4'b0000;
        #10;

        // Test OR
        alu_control = 4'b0001;
        #10;

        // Test ADD
        a = 32'd10; b = 32'd20; alu_control = 4'b0010;
        #10;

        // Test SUB
        alu_control = 4'b0110;
        #10;

        // Test SLT
        a = 32'd5; b = 32'd10; alu_control = 4'b0111;
        #10;

        $stop;
    end
endmodule
