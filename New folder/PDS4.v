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
        if(mode == 1'b1) begin//mode 1 is to read from the memory
            data_out = data;
        data = mem[address];
        end
        else begin
            data_out = data;
            mem[address] = datain;//mode 0 is to write datain into the memory address
            data = datain;
        end
    end
endmodule
module instr(clk,pc,instruction);//fetches instruction from address pc of the memory
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