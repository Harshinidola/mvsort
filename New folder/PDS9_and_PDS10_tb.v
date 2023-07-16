`include "PDS9_and_PDS10.v"
module tb;
reg clk;
wire [5:0]pc;
wire[31:0] instruction;
wire[31:0]os;
alu hut(.clk(clk),.pc(pc),.os(os),.instruction(instruction));
initial begin
clk = 0;
forever #10 clk = ~clk;
 end
initial begin
 // $monitor("%t %b %b %b ",$time,pc,os,instruction);
  #15000 $finish;
end
 endmodule