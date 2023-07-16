module instruction_decoder(clk,instruction,out);//decodes a given instruction to give a 5 bit output
input clk;
input [31:0] instruction;//given instruction
output reg[4:0] out;//5 bit decoded code
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