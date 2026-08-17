module control_unit (
    input [5:0] opcode,

    output reg_dst,
    output alu_src,
    output mem_to_reg,
    output reg_write,
    output mem_read,
    output mem_write,
    output branch,
    output jump,

    output [1:0] alu_op
);

    reg [9:0] controls;

    assign {
        reg_dst,
        alu_src,
        mem_to_reg,
        reg_write,
        mem_read,
        mem_write,
        branch,
        jump,
        alu_op
    } = controls;

    always @(*) begin
        case (opcode)

            // R-type
            6'b000000:
                controls = 10'b100100001;

            // LW
            6'b100011:
                controls = 10'b011110000;

            // SW
            6'b101011:
                controls = 10'b010001000;

            // BEQ
            6'b000100:
                controls = 10'b000000101;

            // J
            6'b000010:
                controls = 10'b000000010;

            default:
                controls = 10'b000000000;

        endcase
    end

endmodule
