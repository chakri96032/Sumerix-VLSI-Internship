module ripple_adder(A,B,Cin,Sum,Cout);
  input [3:0] A,B;
  input Cin;
  output [3:0] Sum;
  output Cout;
  wire c1,c2,c3;

  full_adder fa0(A[0],B[0],Cin,Sum[0],c1);
  full_adder fa1(A[1],B[1],c1,Sum[1],c2);
  full_adder fa2(A[2],B[2],c2,Sum[2],c3);
  full_adder fa3(A[3],B[3],c3,Sum[3],Cout);
endmodule

module tb_ripple_adder;
  reg [3:0] A,B;
  reg Cin;
  wire [3:0] Sum;
  wire Cout;

  ripple_adder uut(A,B,Cin,Sum,Cout);

  initial begin
    $monitor("A=%b B=%b Cin=%b | Sum=%b Cout=%b",A,B,Cin,Sum,Cout);
    A=4'b0000; B=4'b0000; Cin=0;
    #10 A=4'b0011; B=4'b0101; Cin=0;
    #10 A=4'b1111; B=4'b0001; Cin=1;
    #10 $finish;
  end
endmodule
