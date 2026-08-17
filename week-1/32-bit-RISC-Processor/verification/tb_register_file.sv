`timescale 1ns/1ps

module tb_register_file;

    logic        clk;
    logic        reset;

    logic [4:0]  read_addr1;
    logic [4:0]  read_addr2;

    logic [4:0]  write_addr;
    logic [31:0] write_data;
    logic        write_enable;

    logic [31:0] read_data1;
    logic [31:0] read_data2;

    register_file dut (
        .clk(clk),
        .reset(reset),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // 10 ns clock
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;
        read_addr1 = 0;
        read_addr2 = 0;
        write_addr = 0;
        write_data = 0;
        write_enable = 0;

        // Reset
        #10;
        reset = 0;

        // Write 100 to x1
        @(negedge clk);
        write_addr = 5'd1;
        write_data = 32'd100;
        write_enable = 1;

        @(negedge clk);
        write_enable = 0;

        // Read x1
        read_addr1 = 5'd1;
        #2;

        if (read_data1 == 32'd100)
            $display("PASS: x1 = %d", read_data1);
        else
            $display("FAIL: x1 = %d", read_data1);

        // Write 200 to x2
        @(negedge clk);
        write_addr = 5'd2;
        write_data = 32'd200;
        write_enable = 1;

        @(negedge clk);
        write_enable = 0;

        // Read x1 and x2 simultaneously
        read_addr1 = 5'd1;
        read_addr2 = 5'd2;

        #2;

        $display("x1 = %d", read_data1);
        $display("x2 = %d", read_data2);

        // Test x0
        read_addr1 = 5'd0;
        #2;

        if (read_data1 == 32'd0)
            $display("PASS: x0 is always zero");
        else
            $display("FAIL: x0 changed!");

        $display("--------------------------------");
        $display("Register File Test Complete");
        $display("--------------------------------");

        $finish;
    end

endmodule
