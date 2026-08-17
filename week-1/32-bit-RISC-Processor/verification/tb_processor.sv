`timescale 1ns/1ps

module tb_processor;

    logic clk;
    logic reset;

    risc_processor dut (
        .clk   (clk),
        .reset (reset)
    );

    // 10 ns clock
    always #5 clk = ~clk;

    initial begin

        clk = 1'b0;
        reset = 1'b1;

        // Reset CPU
        #10;
        reset = 1'b0;

        // Run program
        #100;

        $display("----------------------------------------");
        $display("      32-bit RISC Processor Test        ");
        $display("----------------------------------------");

        $display("x1 = %0d", dut.registers.registers[1]);
        $display("x2 = %0d", dut.registers.registers[2]);
        $display("x3 = %0d", dut.registers.registers[3]);
        $display("x4 = %0d", dut.registers.registers[4]);
        $display("x5 = %0d", dut.registers.registers[5]);
        $display("x6 = %0d", dut.registers.registers[6]);
        $display("x7 = %0d", dut.registers.registers[7]);

        $display("Memory[0] = %0d",
                 dut.data_memory[0]);

        $display("----------------------------------------");

        if (dut.registers.registers[1] == 10 &&
            dut.registers.registers[2] == 20 &&
            dut.registers.registers[3] == 30 &&
            dut.registers.registers[4] == 10 &&
            dut.registers.registers[5] == 0 &&
            dut.registers.registers[6] == 30 &&
            dut.registers.registers[7] == 30 &&
            dut.data_memory[0] == 30) begin

            $display("PASS: Processor test successful!");

        end
        else begin

            $display("FAIL: Processor test failed!");

        end

        $display("----------------------------------------");

        $finish;

    end

endmodule
