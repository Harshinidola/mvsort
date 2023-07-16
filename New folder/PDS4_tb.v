`include  "PDS4.v"
module tb;
reg clk;
reg [4:0]pc;
wire [4:0] out;
wire[31:0] instruction;
instr hut(.clk(clk),.pc(pc),.instruction(instruction));
initial begin
clk = 1;
forever #10 clk = ~clk;
 end
initial begin
  $monitor("%t %b %b",$time,pc,instruction);
     pc=5'b01100;
     #40
     pc=5'b01110;
     
    #100 $finish;
 end
endmodule