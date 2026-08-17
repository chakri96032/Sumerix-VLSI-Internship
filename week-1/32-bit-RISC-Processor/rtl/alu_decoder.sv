module alu_decoder (
    input  logic [5:0] funct,
    input  logic [2:0] alu_op,

    output logic [2:0] alu_control
);

    always_comb begin

        case (alu_op)

            // R-type instructions
            3'b010: begin
                case (funct)

                    6'b100000: alu_control = 3'b000; // ADD
                    6'b100010: alu_control = 3'b001; // SUB
                    6'b100100: alu_control = 3'b010; // AND
                    6'b100101: alu_control = 3'b011; // OR
                    6'b100110: alu_control = 3'b100; // XOR
                    6'b101010: alu_control = 3'b111; // SLT

                    default:   alu_control = 3'b000;

                endcase
            end

            // ADD / ADDI / LW / SW
            3'b000: alu_control = 3'b000;

            // SUB / BEQ
            3'b001: alu_control = 3'b001;

            default: alu_control = 3'b000;

        endcase

    end

endmodule
