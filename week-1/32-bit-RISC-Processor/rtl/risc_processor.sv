logic [2:0] alu_op;
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
    .alu_op      (alu_op)
);

alu_decoder decoder (
    .funct       (funct),
    .alu_op      (alu_op),
    .alu_control (alu_control)
);
