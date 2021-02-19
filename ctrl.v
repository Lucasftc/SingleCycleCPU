`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/23 17:08:53
// Design Name: 
// Module Name: control
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


module Control(inst,rs,rt,rd,imm16,imm26,PCSrc,RegWriteSrc,RegWrite,MemWrite,ALUOperation,RegDst,ALUSrc);
input [31:0] inst;
output [4:0] rs;
output [4:0] rt;
output [4:0] rd;
output [15:0] imm16;
output [25:0] imm26;
output [1:0]PCSrc;
output [1:0]RegWriteSrc;
output RegWrite;
output MemWrite;
output [1:0] ALUOperation;
output [1:0] RegDst;
output ALUSrc;

wire [5:0] op;
assign op=inst[31:26];
wire [5:0] func;
assign func=inst[5:0];
assign rd=inst[15:11];
assign rt=inst[20:16];
assign rs=inst[25:21];
assign imm16=inst[15:0];
assign imm26=inst[25:00];

wire I_addu;
wire I_subu;
wire I_ori;
wire I_lw;
wire I_sw;
wire I_beq;
wire I_lui;
wire I_jal;
wire I_jr;
wire R_type;

assign R_type=!op;
assign I_addu=R_type & func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & func[0];
assign I_subu=R_type & func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & func[0];
assign I_ori=~op[5] & ~op[4] & op[3] & op[2] & ~op[1] & op[0];
assign I_lw=op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];
assign I_sw=op[5] & ~op[4] & op[3] & ~op[2] & op[1] & op[0];
assign I_beq=~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & ~op[0];
assign I_lui=~op[5] & ~op[4] & op[3] & op[2] & op[1] & op[0];
assign I_jal=~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];
assign I_jr=R_type & ~func[5] & ~func[4] & func[3] & ~func[2] & ~func[1] & ~func[0];

assign PCSrc[0]=I_beq | I_jr;
assign PCSrc[1]=I_jal | I_jr;
assign RegWriteSrc[0]=I_lw;
assign RegWriteSrc[1]=I_jal;
assign RegWrite=I_addu | I_subu | I_ori | I_lw | I_lui | I_jal;
assign MemWrite=I_sw;
assign RegDst[0]=I_addu | I_subu;
assign RegDst[1]=I_jal;
assign ALUSrc=I_addu | I_subu | I_beq;
assign ALUOperation[0]=I_subu | I_ori | I_beq;
assign ALUOperation[1]=I_ori | I_lui;


endmodule
