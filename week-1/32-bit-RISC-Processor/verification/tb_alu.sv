`timescale 1ns/1ps

module tb_alu;

    logic [31:0] a;
    logic [31:0] b;
    logic [2:0]  alu_control;

    logic [31:0] result;
    logic        zero;
    logic        carry;
    logic        overflow;

    alu dut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero),
        .carry(carry),
        .overflow(overflow)
    );

    task test_operation(
        input logic [2:0] operation,
        input logic [31:0] input_a,
        input logic [31:0] input_b,
        input logic [31:0] expected
    );
        begin
            alu_control = operation;
            a = input_a;
            b = input_b;

            #10;

            if (result === expected)
                $display("PASS: A=%h B=%h OP=%b RESULT=%h",
                         a, b, alu_control, result);
            else
                $display("FAIL: A=%h B=%h OP=%b RESULT=%h EXPECTED=%h",
                         a, b, alu_control, result, expected);
        end
    endtask

    initial begin

        $display("================================");
        $display("       32-bit ALU Testbench     ");
        $display("================================");

        // ADD
        test_operation(3'b000, 32'd10, 32'd20, 32'd30);

        // SUB
        test_operation(3'b001, 32'd50, 32'd20, 32'd30);

        // AND
        test_operation(3'b010,
                       32'hFFFF0000,
                       32'h0F0F0F0F,
                       32'h0F0F0000);

        // OR
        test_operation(3'b011,
                       32'hFFFF0000,
                       32'h0000FFFF,
                       32'hFFFFFFFF);

        // XOR
        test_operation(3'b100,
                       32'hFFFF0000,
                       32'h0F0F0F0F,
                       32'hF0F00F0F);

        // Shift Left
        test_operation(3'b101, 32'd4, 32'd2, 32'd16);

        // Shift Right
        test_operation(3'b110, 32'd16, 32'd2, 32'd4);

        // Signed Less Than
        test_operation(3'b111, 32'd10, 32'd20, 32'd1);

        // Zero test
        test_operation(3'b001, 32'd20, 32'd20, 32'd0);

        $display("================================");
        $display("          TEST COMPLETE         ");
        $display("================================");

        $finish;
    end

endmodule
