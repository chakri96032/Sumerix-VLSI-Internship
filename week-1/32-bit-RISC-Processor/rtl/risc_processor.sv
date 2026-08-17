module risc_processor (
    input  logic clk,
    input  logic reset
);

    // -------------------------------------------------
    // Program Counter
    // -------------------------------------------------

    logic [31:0] pc;
    logic [31:0] next_pc;

    program_counter pc_unit (
        .clk     (clk),
        .reset   (reset),
        .next_pc (next_pc),
        .pc      (pc)
    );

    // -------------------------------------------------
    // Instruction Memory
    // -------------------------------------------------

    logic [31:0] instruction;

    instruction_memory imem (
        .address     (pc),
        .instruction (instruction)
    );

    // -------------------------------------------------
    // Instruction Fields
    // -------------------------------------------------

    logic [5:0] opcode;
    logic [4:0] rs;
    logic [4:0] rt;
    logic [4:0] rd;
    logic [5:0] funct;

    logic [15:0] immediate;

    assign opcode    = instruction[31:26];
    assign rs        = instruction[25:21];
    assign rt        = instruction[20:16];
    assign rd        = instruction[15:11];
    assign immediate = instruction[15:0];
    assign funct     = instruction[5:0];

    // -------------------------------------------------
    // Control Unit
    // -------------------------------------------------

    logic       reg_dst;
    logic       alu_src;
    logic       mem_to_reg;
    logic       reg_write;
    logic       mem_read;
    logic       mem_write;
    logic       branch;
    logic       jump;

    logic [2:0] alu_control;

    control_unit control (
        .opcode      (opcode),
        .reg_dst     (reg_dst),
        .alu_src     (alu_src),
        .mem_to_reg  (mem_to_reg),
        .reg_write   (reg_write),
        .mem_read    (mem_read),
        .mem_write   (mem_write),
        .branch      (branch),
        .jump        (jump),
        .alu_control (alu_control)
    );

    // -------------------------------------------------
    // Register File
    // -------------------------------------------------

    logic [31:0] read_data1;
    logic [31:0] read_data2;

    logic [31:0] write_data;
    logic [4:0]  write_register;

    assign write_register = reg_dst ? rd : rt;

    register_file registers (
        .clk          (clk),
        .reset        (reset),

        .read_addr1   (rs),
        .read_addr2   (rt),

        .write_addr   (write_register),
        .write_data   (write_data),
        .write_enable (reg_write),

        .read_data1   (read_data1),
        .read_data2   (read_data2)
    );

    // -------------------------------------------------
    // Immediate Generator
    // -------------------------------------------------

    logic [31:0] sign_extended_immediate;

    assign sign_extended_immediate =
        {{16{immediate[15]}}, immediate};

    // -------------------------------------------------
    // ALU Input Selection
    // -------------------------------------------------

    logic [31:0] alu_input_b;
    logic [31:0] alu_result;

    assign alu_input_b =
        alu_src ? sign_extended_immediate : read_data2;

    // -------------------------------------------------
    // ALU
    // -------------------------------------------------

    logic alu_zero;
    logic alu_carry;
    logic alu_overflow;

    alu processor_alu (
        .a           (read_data1),
        .b           (alu_input_b),
        .alu_control (alu_control),

        .result      (alu_result),
        .zero        (alu_zero),
        .carry       (alu_carry),
        .overflow    (alu_overflow)
    );

    // -------------------------------------------------
    // Data Memory
    // -------------------------------------------------

    logic [31:0] data_memory [0:255];
    logic [31:0] memory_read_data;

    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            data_memory[i] = 32'b0;
    end

    always_comb begin
        if (mem_read)
            memory_read_data = data_memory[alu_result[9:2]];
        else
            memory_read_data = 32'b0;
    end

    always_ff @(posedge clk) begin
        if (mem_write)
            data_memory[alu_result[9:2]] <= read_data2;
    end

    // -------------------------------------------------
    // Write-Back
    // -------------------------------------------------

    assign write_data =
        mem_to_reg ? memory_read_data : alu_result;

    // -------------------------------------------------
    // Program Counter Logic
    // -------------------------------------------------

    logic [31:0] pc_plus_4;
    logic [31:0] branch_target;

    logic branch_taken;

    assign pc_plus_4 = pc + 32'd4;

    assign branch_target =
        pc_plus_4 +
        (sign_extended_immediate << 2);

    assign branch_taken = branch && alu_zero;

    always_comb begin

        if (jump) begin

            next_pc = {
                pc_plus_4[31:28],
                instruction[25:0],
                2'b00
            };

        end
        else if (branch_taken) begin

            next_pc = branch_target;

        end
        else begin

            next_pc = pc_plus_4;

        end

    end

endmodule
