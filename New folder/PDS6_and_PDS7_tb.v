`include "PDS6_and_PDS7.v"
module tb;
reg clk;
wire [4:0]pc;
wire [4:0] out;
wire[31:0] instruction;
wire[31:0]os;
alu hut(.clk(clk),.pc(pc),.os(os),.out(out),.instruction(instruction));
initial begin
clk = 1;
forever #10 clk = ~clk;
 end
initial begin
  $monitor("%t %b %b %b %b",$time,pc,os,out,instruction);
   
     
    #300 $finish;
 end
endmodule