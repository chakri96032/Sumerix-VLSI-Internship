`timescale 1ns/1ps

module processor_tb;

    reg clk;
    reg reset;

    wire [31:0] debug_pc;
    wire [31:0] debug_instruction;
    wire [31:0] debug_alu_result;

    // Instantiate processor
    risc_processor uut (
        .clk(clk),
        .reset(reset),
        .debug_pc(debug_pc),
        .debug_instruction(debug_instruction),
        .debug_alu_result(debug_alu_result)
    );

    // --------------------------------
    // Clock generation
    // --------------------------------

    always #5 clk = ~clk;

    // --------------------------------
    // Test program
    // --------------------------------

    initial begin

        // Initialize
        clk = 0;
        reset = 1;

        // -----------------------------
        // Instruction 0
        // ADD R3,R1,R2
        // R3 = 20 + 10 = 30
        // -----------------------------

        uut.instr_mem[0] =
            32'b000000_00001_00010_00011_00000_100000;

        // -----------------------------
        // Instruction 1
        // SUB R4,R3,R1
        // R4 = 30 - 20 = 10
        // -----------------------------

        uut.instr_mem[1] =
            32'b000000_00011_00001_00100_00000_100010;

        // -----------------------------
        // Instruction 2
        // AND R5,R3,R4
        // R5 = 30 & 10
        // -----------------------------

        uut.instr_mem[2] =
            32'b000000_00011_00100_00101_00000_100100;

        // -----------------------------
        // Instruction 3
        // OR R6,R3,R4
        // R6 = 30 | 10
        // -----------------------------

        uut.instr_mem[3] =
            32'b000000_00011_00100_00110_00000_100101;

        // -----------------------------
        // Instruction 4
        // SLT R7,R3,R4
        // 30 < 10 = 0
        // -----------------------------

        uut.instr_mem[4] =
            32'b000000_00011_00100_00111_00000_101010;

        // -----------------------------
        // Reset processor
        // -----------------------------

        #12;
        reset = 0;

        // Initialize registers
        #1;

        uut.dp.registers.registers[1] = 32'd20;
        uut.dp.registers.registers[2] = 32'd10;

        // Allow processor to execute
        #70;

        // --------------------------------
        // Display final register values
        // --------------------------------

        $display("");
        $display("======================================");
        $display("PROCESSOR VERIFICATION RESULTS");
        $display("======================================");

        $display("R1 = %d",
            uut.dp.registers.registers[1]);

        $display("R2 = %d",
            uut.dp.registers.registers[2]);

        $display("R3 = %d  Expected = 30",
            uut.dp.registers.registers[3]);

        $display("R4 = %d  Expected = 10",
            uut.dp.registers.registers[4]);

        $display("R5 = %d  Expected = 10",
            uut.dp.registers.registers[5]);

        $display("R6 = %d  Expected = 30",
            uut.dp.registers.registers[6]);

        $display("R7 = %d  Expected = 0",
            uut.dp.registers.registers[7]);

        $display("======================================");

        // --------------------------------
        // Automatic verification
        // --------------------------------

        if (uut.dp.registers.registers[3] == 32'd30)
            $display("ADD TEST: PASS");
        else
            $display("ADD TEST: FAIL");

        if (uut.dp.registers.registers[4] == 32'd10)
            $display("SUB TEST: PASS");
        else
            $display("SUB TEST: FAIL");

        if (uut.dp.registers.registers[5] == 32'd10)
            $display("AND TEST: PASS");
        else
            $display("AND TEST: FAIL");

        if (uut.dp.registers.registers[6] == 32'd30)
            $display("OR TEST: PASS");
        else
            $display("OR TEST: FAIL");

        if (uut.dp.registers.registers[7] == 32'd0)
            $display("SLT TEST: PASS");
        else
            $display("SLT TEST: FAIL");

        $display("======================================");

        #10;
        $finish;

    end

    // --------------------------------
    // Generate GTKWave VCD
    // --------------------------------

    initial begin

        $dumpfile("processor.vcd");
        $dumpvars(0, processor_tb);

    end

endmodule
