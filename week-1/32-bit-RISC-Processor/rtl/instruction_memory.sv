module instruction_memory (
    input  logic [31:0] address,

    output logic [31:0] instruction
);

    logic [31:0] memory [0:255];

    integer i;

    initial begin

        // Initialize memory to NOP
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 32'b0;

        // Example instructions
        //
        // These will be replaced with actual programs
        // when we build the complete processor.

        memory[0] = 32'h00000000;
        memory[1] = 32'h00000000;
        memory[2] = 32'h00000000;
        memory[3] = 32'h00000000;

    end

    // Word-aligned addressing
    always_comb begin
        instruction = memory[address[9:2]];
    end

endmodule
