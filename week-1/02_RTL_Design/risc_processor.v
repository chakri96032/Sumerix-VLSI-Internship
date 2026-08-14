module risc_processor (
    input clk,
    input reset
);
    reg [31:0] pc;
    wire [31:0] instruction, alu_result;

    // Instruction Memory (placeholder)
    reg [31:0] instr_mem [0:255];
    assign instruction = instr_mem[pc[7:0]];

    datapath dp (
        .clk(clk),
        .instruction(instruction),
        .alu_result(alu_result)
    );

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 0;
        else
            pc <= pc + 4; // Next instruction
    end
endmodule

