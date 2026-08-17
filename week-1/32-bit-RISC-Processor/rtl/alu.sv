module alu (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [2:0]  alu_control,

    output logic [31:0] result,
    output logic        zero,
    output logic        carry,
    output logic        overflow
);

    always_comb begin
        // Default values
        result   = 32'b0;
        carry    = 1'b0;
        overflow = 1'b0;

        case (alu_control)

            3'b000: begin // ADD
                {carry, result} = {1'b0, a} + {1'b0, b};

                overflow = (~(a[31] ^ b[31])) &
                           (result[31] ^ a[31]);
            end

            3'b001: begin // SUB
                result = a - b;

                overflow = (a[31] ^ b[31]) &
                           (result[31] ^ a[31]);

                carry = (a >= b);
            end

            3'b010: begin // AND
                result = a & b;
            end

            3'b011: begin // OR
                result = a | b;
            end

            3'b100: begin // XOR
                result = a ^ b;
            end

            3'b101: begin // Shift Left
                result = a << b[4:0];
            end

            3'b110: begin // Shift Right
                result = a >> b[4:0];
            end

            3'b111: begin // Set Less Than
                result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            end

            default: begin
                result = 32'b0;
            end

        endcase
    end

    assign zero = (result == 32'b0);

endmodule
