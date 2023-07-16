//operations modules
module add_n(a,b,out);
    input  [31:0] a,b;
    output  [31:0] out;
    assign out=a+b;
endmodule

module sub_n(a,b,out);
    input  [31:0] a,b;
    output  [31:0] out;
    assign out=a-b;
endmodule

module and_n(a,b,out);
    input  [31:0] a,b;
    output  [31:0] out;
    assign out=a&b;
endmodule

module sll_n(a,b,out);
    input  [31:0] a,b;
    output  [31:0] out;
    assign out=a<<b;
endmodule
module vedamemory(clk,address,datain,mode,data_out);
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

module alu(clk,pc,instruction,os);
input clk;
output reg  [5:0]pc;
 output wire[31:0] instruction;
  wire[4:0] out;
 wire[5:0] opcode,fun,p;
  wire[4:0] rs,rt,shamt,rd;
  wire[25:0] tar;
  wire[15:0] offset;
 wire [31:0] d;
 reg[31:0]lw,sw,subi,addi;
 output reg [31:0]os;
  reg [31:0] risc_bubble [31:0];
  reg[2:0]flag;
  reg [31:0]veda_memory[63:0];
  integer i;
 initial begin
    veda_memory[0]=32'b000000_00000_00000_00000_00000_001010;
    veda_memory[1]=32'b000000_00000_00000_00000_00000_001010;
    veda_memory[2]=32'b000000_00000_00000_00000_00000_001010;
    veda_memory[3]=32'b000000_00000_00000_00000_00000_001010;
    veda_memory[4]=32'b000000_00000_00000_00000_00000_001010;
    veda_memory[5]=32'b000000_00000_00000_00000_00000_001010;
    veda_memory[6]=32'b000000_00000_00000_00000_00000_000011;
    veda_memory[7]=32'b000000_00000_00000_00000_00000_000001;
    veda_memory[8]=32'b000000_00000_00000_00000_00000_000101;
    veda_memory[9]=32'b000000_00000_00000_00000_00000_100111;
    veda_memory[10]=32'b000000_00000_00000_00000_00000_000000;
    //data memory veda_memory[]0-31
    veda_memory[32]=32'b100011_00000_00110_00000_00000_000000;//lw  Load the array size into reg[6]
    veda_memory[33]=32'b100010_00110_01000_00000_00000_000001;//subi load array size-1 into reg[8]
    veda_memory[34]=32'b001000_00000_00111_00000_00000_000001;//addi Load the array address into reg[7]
    //Outer loop for bubble sort
    veda_memory[35]=32'b001000_00000_01001_00000_00000_000001;//addi  set flag to 1
    veda_memory[36]=32'b000010_00000_00000_00000_00000_100101;//j
    //loop
    veda_memory[37]=32'b000100_01001_00000_00000_00000_111011;//beq if flag == 0, then done
    veda_memory[38]=32'b000100_01000_00000_00000_00000_111011;//beq 
    veda_memory[39]=32'b001000_00000_01001_00000_00000_000000;//addi reset flag
    // Inner loop for each pass of bubble sort
    veda_memory[40]=32'b001000_00000_01010_00000_00000_000000;//addi  i = 0
    veda_memory[41]=32'b001000_00111_01011_00000_00000_000001;//addi adress of sceond element in array let it be a
    //inner_loop
    veda_memory[42]=32'b000000_01010_01000_01100_00000_101010;//slt  if i < size
    veda_memory[43]=32'b000100_01100_00000_00000_00000_110111;//beq  jump to end of inner loop
    veda_memory[44]=32'b100011_01011_01101_00000_00000_000000;//lw  load a
    veda_memory[45]=32'b100010_01011_01111_00000_00000_000001;//subi
    veda_memory[46]=32'b100011_01111_01110_00000_00000_000000;//lw  load a-1
    veda_memory[47]=32'b000000_01101_01110_01100_00000_101010;//slt if a < a - 1
    veda_memory[48]=32'b000100_01100_00000_00000_00000_110100;//beq jump to inner_iter
    //Swap a and a - 1
    veda_memory[49]=32'b101011_01111_01101_00000_00000_000000;//sw
    veda_memory[50]=32'b101011_01011_01110_00000_00000_000000;//sw
    veda_memory[51]=32'b001000_00000_01001_00000_00000_000001;//addi set flag to 1
    //inner_iter
    veda_memory[52]=32'b001000_01010_01010_00000_00000_000001;//addi i++
    veda_memory[53]=32'b001000_01011_01011_00000_00000_000001;//addi a++
    veda_memory[54]=32'b000010_00000_00000_00000_00000_101010;//j
    //inner_done
    veda_memory[55]=32'b001000_00000_01010_00000_00000_000000;//addi reset i to 0
    veda_memory[56]=32'b001000_00111_01011_00000_00000_000001;//addi reset a
    veda_memory[57]=32'b100010_01000_01000_00000_00000_000001;//subi
    veda_memory[58]=32'b000010_00000_00000_00000_00000_100101;//j
    //done
    veda_memory[59]=32'b111111_00000_00000_00000_00000_000000;//print
    //instruction memory veda_memory[]32-59
    risc_bubble[0]=32'b000000_00000_00000_00000_00000_000000;//zero register
   
 end
 initial begin
    pc=6'b100000;
    flag=3'b111;
 end
 assign instruction=veda_memory[pc];
 assign opcode=instruction[31:26];
 assign fun=instruction[5:0];

    assign  rs=instruction[25:21];
    assign  rt=instruction[20:16];
    assign rd=instruction[15:11];
    assign shamt=instruction[10:6];
    assign offset=instruction[15:0];
   
   assign d=offset+risc_bubble[rs];
   
    assign tar=instruction[25:0];
     
always@(posedge clk)
begin
  
    if(opcode==6'b000000)
    begin
        case(fun)
        6'b101010:begin
            if(risc_bubble[rs]<risc_bubble[rt])
            risc_bubble[rd]=32'b000000_00000_00000_00000_00000_000001;
            else risc_bubble[rd]=32'b000000_00000_00000_00000_00000_000000;
            os=risc_bubble[rd];
            pc=pc+6'b1;
           // flag=3'b111;
        end//slt
        default:os=5'b00000;
        endcase
    end
    else begin
        if(opcode==6'b000010)
        begin
            pc=tar;
       //j
        end
        else begin
            case(opcode)
            6'b001000:begin
                addi=risc_bubble[rs]+offset;
                risc_bubble[rt]=addi;
                os=addi;
                pc=pc+6'b1;
              
            end
                 //addi
            6'b100010:begin
            subi=risc_bubble[rs]-offset;
            risc_bubble[rt]=subi;
            os=risc_bubble[rt];
            pc=pc+6'b1;
          
        end //subi
            6'b000100:begin
                if(risc_bubble[rs]==risc_bubble[rt])
                  pc=offset;
                  else
                  pc=pc+6'b1;
                
            end
                 //beq
            6'b100011:begin
              
                lw=veda_memory[d];
                risc_bubble[rt]=lw;
                os=lw;
    
               pc=pc+6'b1;
                flag=3'b000;
            end //lw
            6'b101011:begin
               sw=risc_bubble[rt];
               veda_memory[d]=sw;
               os=veda_memory[d];
             pc=pc+6'b1;
         
                end//sw
                6'b111111:begin
                

                  flag=3'b111;
                    
                end
                
            default:os=5'b00000;
            endcase
        end
    end
end
always@(*) begin
    if(pc==6'b100000)
    begin
            $display("before sorting");
         for(i=1;i<11;i=i+1)begin
        
                   $display(" %d ",veda_memory[i]);
                    end
                   
        
    end
    if(pc==6'b111011) 
    begin
          $display("after sorting");
          for(i=1;i<11;i=i+1)begin
          
                   $display(" %d ",veda_memory[i]);
                    end
                   
        
    end
end


 endmodule