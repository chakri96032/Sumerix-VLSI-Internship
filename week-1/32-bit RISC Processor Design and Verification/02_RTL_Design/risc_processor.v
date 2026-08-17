module risc_processor (
    input clk,
    input reset,

    output [31:0] debug_pc,
    output [31:0] debug_instruction,
    output [31:0] debug_alu_result
);

    reg [31:0] pc;

    reg [31:0] instr_mem [0:255];

    wire [31:0] instruction;

    wire [31:0] alu_result;
    wire [31:0] write_data;
    wire [31:0] read_data;

    wire [3:0] alu_control;
    wire zero;

    wire reg_write;
    wire mem_read;
    wire mem_write;

    // Instruction memory
    assign instruction = instr_mem[pc[9:2]];

    // Datapath
    datapath dp (
        .clk(clk),
        .reset(reset),

        .instruction(instruction),

        .alu_result(alu_result),
        .write_data(write_data),
        .read_data(read_data),

        .alu_control(alu_control),
        .zero(zero),

        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write)
    );

    // Debug outputs
    assign debug_pc = pc;
    assign debug_instruction = instruction;
    assign debug_alu_result = alu_result;

    // PC
    always @(posedge clk or posedge reset) begin

        if (reset)
            pc <= 32'd0;

        else
            pc <= pc + 32'd4;

    end

endmodule
