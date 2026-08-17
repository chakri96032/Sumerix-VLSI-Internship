module datapath (
    input clk,
    input reset,

    input [31:0] instruction,

    output [31:0] alu_result,
    output [31:0] write_data,
    output [31:0] read_data,

    output [3:0] alu_control,
    output zero,

    output reg_write,
    output mem_read,
    output mem_write
);

    // Instruction fields
    wire [5:0] opcode;
    wire [5:0] funct;

    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;

    wire [15:0] immediate;

    assign opcode    = instruction[31:26];
    assign rs        = instruction[25:21];
    assign rt        = instruction[20:16];
    assign rd        = instruction[15:11];
    assign immediate = instruction[15:0];
    assign funct     = instruction[5:0];

    // Control signals
    wire reg_dst;
    wire alu_src;
    wire mem_to_reg;
    wire branch;
    wire jump;
    wire [1:0] alu_op;

    // Register file
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // ALU
    wire [31:0] alu_out;

    // Immediate
    wire [31:0] sign_extended_immediate;

    // Write-back
    wire [4:0] destination_register;
    wire [31:0] write_back_data;

    assign sign_extended_immediate =
        {{16{immediate[15]}}, immediate};

    // Destination register
    assign destination_register =
        reg_dst ? rd : rt;

    // ALU second operand
    assign write_data = read_data2;

    wire [31:0] alu_input_b;

    assign alu_input_b =
        alu_src ? sign_extended_immediate : read_data2;

    // Control unit
    control_unit control (
        .opcode(opcode),

        .reg_dst(reg_dst),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .reg_write(reg_write),

        .mem_read(mem_read),
        .mem_write(mem_write),

        .branch(branch),
        .jump(jump),

        .alu_op(alu_op)
    );

    // ALU control generation
    reg [3:0] alu_control_reg;

    always @(*) begin

        case (alu_op)

            // R-type
            2'b10: begin
                case (funct)

                    6'b100000:
                        alu_control_reg = 4'b0010; // ADD

                    6'b100010:
                        alu_control_reg = 4'b0110; // SUB

                    6'b100100:
                        alu_control_reg = 4'b0000; // AND

                    6'b100101:
                        alu_control_reg = 4'b0001; // OR

                    6'b101010:
                        alu_control_reg = 4'b0111; // SLT

                    default:
                        alu_control_reg = 4'b0010;

                endcase
            end

            // ADD for LW/SW
            2'b00:
                alu_control_reg = 4'b0010;

            // SUB for BEQ
            2'b01:
                alu_control_reg = 4'b0110;

            default:
                alu_control_reg = 4'b0010;

        endcase
    end

    assign alu_control = alu_control_reg;

    // ALU
    alu alu_unit (
        .a(read_data1),
        .b(alu_input_b),
        .alu_control(alu_control_reg),
        .result(alu_out),
        .zero(zero)
    );

    assign alu_result = alu_out;

    // Data memory
    reg [31:0] data_memory [0:255];

    assign read_data =
        mem_read ? data_memory[alu_out[9:2]] : 32'd0;

    always @(posedge clk) begin
        if (mem_write)
            data_memory[alu_out[9:2]] <= read_data2;
    end

    // Write-back
    assign write_back_data =
        mem_to_reg ? read_data : alu_out;

    // Register file
    register_file registers (
        .clk(clk),
        .reset(reset),

        .reg_write(reg_write),

        .read_reg1(rs),
        .read_reg2(rt),
        .write_reg(destination_register),

        .write_data(write_back_data),

        .read_data1(read_data1),
        .read_data2(read_data2)
    );

endmodule
