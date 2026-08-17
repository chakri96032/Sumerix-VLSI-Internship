initial begin

    // ADDI x1, x0, 10
    memory[0] = 32'h2001000A;

    // ADDI x2, x0, 20
    memory[1] = 32'h20020014;

    // ADD x3, x1, x2
    memory[2] = 32'h00221820;

    // SUB x4, x2, x1
    memory[3] = 32'h00412022;

    // AND x5, x1, x2
    memory[4] = 32'h00222824;

    // OR x6, x1, x2
    memory[5] = 32'h00223025;

    // SW x3, 0(x0)
    memory[6] = 32'hAC030000;

    // LW x7, 0(x0)
    memory[7] = 32'h8C070000;

end
