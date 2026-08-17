module control_unit (
    input  logic [5:0] opcode,

    output logic       reg_dst,
    output logic       alu_src,
    output logic       mem_to_reg,
    output logic       reg_write,
    output logic       mem_read,
    output logic       mem_write,
    output logic       branch,
    output logic       jump,

    output logic [2:0] alu_control
);

    always_comb begin

        // Default values
        reg_dst    = 1'b0;
        alu_src    = 1'b0;
        mem_to_reg = 1'b0;
        reg_write  = 1'b0;
        mem_read   = 1'b0;
        mem_write  = 1'b0;
        branch     = 1'b0;
        jump       = 1'b0;
        alu_control = 3'b000;

        case (opcode)

            // R-type
            6'b000000: begin
                reg_dst     = 1'b1;
                reg_write   = 1'b1;
                alu_control = 3'b000;
            end

            // ADDI
            6'b001000: begin
                alu_src     = 1'b1;
                reg_write   = 1'b1;
                alu_control = 3'b000;
            end

            // LW
            6'b100011: begin
                alu_src     = 1'b1;
                mem_to_reg  = 1'b1;
                reg_write   = 1'b1;
                mem_read    = 1'b1;
                alu_control = 3'b000;
            end

            // SW
            6'b101011: begin
                alu_src     = 1'b1;
                mem_write   = 1'b1;
                alu_control = 3'b000;
            end

            // BEQ
            6'b000100: begin
                branch      = 1'b1;
                alu_control = 3'b001;
            end

            // JUMP
            6'b000010: begin
                jump = 1'b1;
            end

            default: begin
                // Keep default control signals
            end

        endcase
    end

endmodule
