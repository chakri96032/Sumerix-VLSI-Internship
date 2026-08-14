module datapath (
    input clk,
    input [31:0] instruction,
    output [31:0] alu_result
);
    wire [31:0] read_data1, read_data2, alu_out;
    wire [4:0] rs, rt, rd;
    wire [3:0] alu_control;

    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = instruction[15:11];

    register_file rf (
        .clk(clk),
        .reg_write(1'b1),
        .read_reg1(rs),
        .read_reg2(rt),
        .write_reg(rd),
        .write_data(alu_out),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    alu alu_inst (
        .a(read_data1),
        .b(read_data2),
        .alu_control(alu_control),
        .result(alu_out),
        .zero()
    );

    assign alu_result = alu_out;
endmodule

