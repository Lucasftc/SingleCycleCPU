`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/23 20:25:43
// Design Name: 
// Module Name: mips
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


module mips(CLK,Reset);
    input CLK;
    input Reset;

    wire [31:0] PC,PCAdd4,PCAdd8,NextPC,PCBranch,PCJump;
    wire [31:0] Inst;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [15:0] imm16;
    wire [25:0] imm26;
    wire [31:0] SignExtend;
    wire [31:0] UnsignExtend;
    wire [31:0] LeftShift2;

    wire [1:0]PCSrc;
    wire [1:0]RegWriteSrc;
    wire RegWrite;
    wire MemWrite;
    wire [1:0] ALUOperation;
    wire [1:0] RegDst;
    wire ALUSrc;
    
    wire [4:0] GPRWriteReg;
    wire [31:0] GPRWriteData;
    wire [31:0] GPRReadData1;
    wire [31:0] GPRReadData2;
    wire [31:0] ALUOperand2;
    wire [31:0] ALUResult;
    wire ALUZero;
    wire [31:0] DMWriteData;
    wire [31:0] DMReadData;

    PC pc(NextPC,Reset,CLK,PC);
    PCAdd4 pcadd4(PC,PCAdd4,PCAdd8);
    im_4k im(PC[11:2],Inst);
    Control control(Inst,rs,rt,rd,imm16,imm26,PCSrc,RegWriteSrc,RegWrite,MemWrite,ALUOperation,RegDst,ALUSrc);
    PCJump pcjump(imm26,PCAdd4,PCJump);
    Extend extend(imm16,1,SignExtend,UnsignExtend);
    LeftShift2 leftshift2(SignExtend,LeftShift2);
    
    MUX3x5 mux3x5(rt,rd,5'b11111,RegDst,GPRWriteReg);
    GPR gpr(rs,rt,GPRWriteReg,GPRWriteData,RegWrite,CLK,GPRReadData1,GPRReadData2);
    MUX2x32 mux2x32(SignExtend,GPRReadData2,ALUSrc,ALUOperand2);
    ALU alu(GPRReadData1,ALUOperand2,ALUOperation,ALUResult,ALUZero);
    dm_4k dm(ALUResult[11:2],GPRReadData2,MemWrite,CLK,DMReadData);

    MUX3x32 mux3x32(ALUResult,DMReadData,PCAdd4,RegWriteSrc,GPRWriteData);
    
    
    PCBranch pcbranch(LeftShift2,ALUZero,PCAdd4,PCBranch);
    
    MUX4x32 mux4x32(PCAdd4,PCBranch,PCJump,GPRReadData1,PCSrc,NextPC);
    
    always @(negedge CLK)
    begin
        $display("new instruction:%h %h",PC,Inst);
        $display("rs:%h,rt:%h,rd:%h,imm16:%h, imm26:%h",rs,rt,rd,imm16,imm26);
        $display("gpr readdata1: %h gpr readdata2: %h",GPRReadData1,GPRReadData2);
        $display("signext: %h shiftleft2: %h",SignExtend,LeftShift2);
        $display("alu: %h op %h = %h",GPRReadData1,ALUOperand2,ALUResult);
        $display("RegWrite: %h, WriteReg: %h, WriteData: %h",RegWrite,GPRWriteReg,GPRWriteData);
        $display("MemWrite: %h,DM address: %h, DM read: %h, DM write: %h",MemWrite,ALUResult,DMReadData,GPRReadData2,);
        $display("PCSrc: %h ,PCBranch: %h, PCJump: %h NextPC:%h",PCSrc,PCBranch,PCJump,NextPC);
    end    
endmodule

