`include "PDS5.v"
 module tb;
reg clk;
wire [4:0] out;
reg[31:0] instruction;
instruction_decoder gut(.clk(clk),.out(out),.instruction(instruction));
initial begin
clk = 1;
forever #10 clk = ~clk;
 end
initial begin
  $monitor("%t %b %b",$time,out,instruction);
   instruction=32'b000000_00000_00010_xxxxx_xxxxx_100000;
   #20
   instruction=32'b000000_xxxxx_00000_xxxxx_00010_000000;   
    #20 $finish;
 end
endmodule