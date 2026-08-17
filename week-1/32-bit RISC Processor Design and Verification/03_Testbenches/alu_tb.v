`timescale 1ns/1ps

module alu_tb;

    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] alu_control;

    wire [31:0] result;
    wire zero;

    // Instantiate ALU
    alu uut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );

    initial begin

        // Generate VCD waveform
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);

        // Display results
        $monitor(
            "Time=%0t | A=%d | B=%d | Control=%b | Result=%d | Zero=%b",
            $time, a, b, alu_control, result, zero
        );

        // -----------------------------
        // Test 1: ADD
        // 20 + 10 = 30
        // -----------------------------
        a = 32'd20;
        b = 32'd10;
        alu_control = 4'b0010;

        #10;

        if (result == 32'd30)
            $display("TEST 1 ADD: PASS");
        else
            $display("TEST 1 ADD: FAIL");

        // -----------------------------
        // Test 2: SUB
        // 20 - 10 = 10
        // -----------------------------
        a = 32'd20;
        b = 32'd10;
        alu_control = 4'b0110;

        #10;

        if (result == 32'd10)
            $display("TEST 2 SUB: PASS");
        else
            $display("TEST 2 SUB: FAIL");

        // -----------------------------
        // Test 3: AND
        // 0xF0F0 & 0x0FF0
        // -----------------------------
        a = 32'h0000F0F0;
        b = 32'h00000FF0;
        alu_control = 4'b0000;

        #10;

        if (result == 32'h000000F0)
            $display("TEST 3 AND: PASS");
        else
            $display("TEST 3 AND: FAIL");

        // -----------------------------
        // Test 4: OR
        // -----------------------------
        a = 32'h0000F000;
        b = 32'h0000000F;
        alu_control = 4'b0001;

        #10;

        if (result == 32'h0000F00F)
            $display("TEST 4 OR: PASS");
        else
            $display("TEST 4 OR: FAIL");

        // -----------------------------
        // Test 5: SLT
        // 10 < 20 = 1
        // -----------------------------
        a = 32'd10;
        b = 32'd20;
        alu_control = 4'b0111;

        #10;

        if (result == 32'd1)
            $display("TEST 5 SLT: PASS");
        else
            $display("TEST 5 SLT: FAIL");

        // -----------------------------
        // Test 6: SLT
        // 20 < 10 = 0
        // -----------------------------
        a = 32'd20;
        b = 32'd10;
        alu_control = 4'b0111;

        #10;

        if (result == 32'd0)
            $display("TEST 6 SLT: PASS");
        else
            $display("TEST 6 SLT: FAIL");

        // -----------------------------
        // Test 7: ZERO FLAG
        // 20 - 20 = 0
        // -----------------------------
        a = 32'd20;
        b = 32'd20;
        alu_control = 4'b0110;

        #10;

        if ((result == 32'd0) && (zero == 1'b1))
            $display("TEST 7 ZERO FLAG: PASS");
        else
            $display("TEST 7 ZERO FLAG: FAIL");

        #10;

        $display("--------------------------------");
        $display("ALU TESTBENCH COMPLETE");
        $display("--------------------------------");

        $finish;

    end

endmodule
