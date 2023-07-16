module add_n(a,b,out);//performs add operation on a and b
    input  [31:0] a,b;
    output  [31:0] out;
    assign out=a+b;
endmodule

module sub_n(a,b,out);//sub operation
    input  [31:0] a,b;
    output  [31:0] out;
    assign out=a-b;
endmodule

module and_n(a,b,out);//and operation
    input  [31:0] a,b;
    output  [31:0] out;
    assign out=a&b;
endmodule

module sll_n(a,b,out);//left shift operation
    input  [31:0] a,b;
    output  [31:0] out;
    assign out=a<<b;
endmodule
module vedamemory(clk,address,datain,mode,data_out);//memory stores data and instructions
    input wrt_enb,mode,clk;
    input [31:0]datain;
    input [4:0]address;
    output reg [31:0]data_out;
    reg [31:0]data;
    reg [31:0] mem [31:0];
    initial
    begin
    mem[0]=32'b000000_00000_00000_00000_00000_001001;
    mem[1]=32'b000000_00000_00000_00000_00000_000110;
    mem[2]=32'b000000_00000_00000_00000_00000_000010;
    mem[3]=32'b000000_00000_00000_00000_00000_000100;
    mem[12]=32'b000000_00000_00010_xxxxx_xxxxx_100000;
    mem[13]=32'b000000_00011_00010_xxxxx_xxxxx_100010;
    mem[14]=32'b000000_00001_00000_xxxxx_xxxxx_100100;
    mem[15]=32'b000000_xxxxx_00000_xxxxx_00010_000000; 
    mem[16]=32'b100011_00001_xxxxx_00000_00000_000010;
    mem[18]=32'b000010_00000_00000_00000_00000_001111;
    mem[17]=32'b000011_00000_00000_00000_00000_001101;
    end 

    always @(posedge clk) begin: loop
        if(mode == 1'b1) begin
            data_out = data;
        data = mem[address];
        end
        else begin
            data_out = data;
            mem[address] = datain;
            data = datain;
        end
    end
endmodule

module instr(clk,pc,instruction);//instruction fetch module
input clk;
input[4:0]pc;
output reg [31:0] instruction;
wire [31:0]data_out;
vedamemory uut(
    .clk(clk),
    .address(pc),
    .datain(0),
    .mode(1),
    .data_out(data_out)

);
always@(posedge clk)
begin
        instruction=data_out;
end
endmodule

module instruction_decoder(clk,instruction,out);//decodes the instruction
input clk;
input [31:0] instruction;
output reg[4:0] out;
always@(posedge clk)
begin
    out=5'b0;
    if(instruction[31:26]==6'b000000)
    begin
        case(instruction[5:0])
        6'b100000:out=5'b00001; //add
        6'b100001:out=5'b00010; //addu
        6'b100100:out=5'b00011; //and
        6'b011010:out=5'b00100; //div
        6'b011000:out=5'b00101; //mult
        6'b100101:out=5'b00110; //or
        6'b100111:out=5'b00111; //nor
        6'b000000:out=5'b01000; //sll
        6'b100010:out=5'b01001; //sub
        6'b100110:out=5'b01010; //xor
        default:out=5'b00000;
        endcase
    end
    else begin
        if(instruction[31:26]==6'b000010)
        begin
            out=5'b01011; //j
        end
        else if(instruction[31:26]==6'b000011)
        begin
            out=5'b01100; //jal
        end
        else begin
            case(instruction[31:26])
            6'b001000:out=5'b01101; //addi
            6'b001001:out=5'b01110; //addiu
            6'b001100:out=5'b01111; //andi
            6'b001101:out=5'b10000; //ori
            6'b000100:out=5'b10001; //beq
            6'b000101:out=5'b10010; //bne
            6'b100011:out=5'b10011; //lw
            6'b101011:out=5'b10100; //sw
            default:out=5'b00000;
            endcase
        end
    end
end
endmodule
module alu(clk,pc,os,instruction,out);
input clk;
output reg  [4:0]pc;//memory address of instruction
 output wire[31:0] instruction;//instruction
 reg[4:0] npc;
 output wire[4:0] out;//instruction decoded code
 wire[31:0] a,b,c;
  wire[4:0] rs,rt,shamt,d;
  wire[15:0] imm;
 wire [31:0] add,sub,ands,sll,lw;
 output reg [31:0]os;//final output after operation
instr uut(.clk(clk),.pc(pc),.instruction(instruction));//fetches instruction
 instruction_decoder dut(.clk(clk),.instruction(instruction),.out(out));//decodes the instruction
 initial begin
    pc=5'b01100;
 end
//breaks the instruction into rs rt ...
    assign  rs=instruction[25:21];
    assign  rt=instruction[20:16];
    assign shamt=instruction[10:6];
    assign imm=instruction[15:0];
    assign d=imm+rs;
//fetches the data from the memory addresses rs rt ...
instr uut1(.clk(clk),.pc(rs),.instruction(a));
instr uut2(.clk(clk),.pc(rt),.instruction(b));
instr uut3(.clk(clk),.pc(shamt),.instruction(c));
instr iut(.clk(clk),.pc(d),.instruction(lw));
//performs the operations
add_n uut4(.a(a),.b(b),.out(add));
sub_n uut5(.a(a),.b(b),.out(sub));
and_n uut6(.a(a),.b(b),.out(ands));
sll_n uut7(.a(b),.b(c),.out(sll));

always@(posedge clk)
begin
case(out)
  5'b00001:
  begin
    os=add;
   #80 pc=pc+5'b1;//pc increment
   if(pc==5'b10011)
   pc=5'b01100;
  end

  5'b01001:
  begin
    os=sub;
   #80 pc=pc+5'b1;
   if(pc==5'b10011)
   pc=5'b01100;
  end
  5'b00011:
  begin
    os=ands;
   #80 pc=pc+5'b1;
  if(pc==5'b10011)
   pc=5'b01100;
  end
  5'b01000:
  begin
    os=sll;
   #80 pc=pc+5'b1;
   if(pc==5'b10011)
   pc=5'b01100;
  end
  5'b10011:
  begin
    os=lw;
   #80 pc=pc+5'b1;
   if(pc==5'b10011)
   pc=5'b01100;
  end
  5'b01011:
  begin
    pc=instruction[4:0];
    #80  pc=pc+5'b1;
   if(pc==5'b10011)
   pc=5'b01100;
  end
 5'b01100:
 begin
    npc=pc;
    pc=instruction[4:0];
      pc=npc;

 end
default: os=32'b0;

endcase
end



 endmodule