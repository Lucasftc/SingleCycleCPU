`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/23 19:08:32
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ALU(Operand1,Operand2,ALUOperation,Result,Zero);
input [31:0] Operand1;
input [31:0] Operand2;
input [1:0] ALUOperation;
output reg[31:0] Result;
output reg Zero;

begin initial
    Result=0;
end

always @ (Operand1 or Operand2 or ALUOperation)
begin
    case(ALUOperation)
        2'b00: Result=Operand1+Operand2;
        2'b01: Result=Operand1-Operand2;
        2'b10: Result=Operand2<<16;
        2'b11: Result=Operand1 | Operand2;
    endcase
    Zero=(Result==0)?1:0;
    ///$display("alu :%h op %h = %h\n",Operand1,Operand2,Result);
end
endmodule
