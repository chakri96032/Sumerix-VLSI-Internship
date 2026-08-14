module control_unit (
    input [5:0] opcode,
    output reg_dst, alu_src, mem_to_reg, reg_write,
    output mem_read, mem_write, branch, jump,
    output [1:0] alu_op
);
    reg [8:0] controls;
    assign {reg_dst, alu_src, mem_to_reg, reg_write,
            mem_read, mem_write, branch, jump, alu_op} = controls;

    always @(*) begin
        case (opcode)
            6'b000000: controls = 9'b100100000; // R-type
            6'b100011: controls = 9'b011110000; // LW
            6'b101011: controls = 9'b010001000; // SW
            6'b000100: controls = 9'b000000100; // BEQ
            6'b000010: controls = 9'b000000010; // JUMP
            default:   controls = 9'b000000000;
        endcase
    end
endmodule

