`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/21 20:30:02
// Design Name: 
// Module Name: dm
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


module dm_4k(addr,din,we,clk,dout);
input [11:2] addr;
input [31:0] din;
input we;
input clk;
output [31:0] dout;
reg [31:0] dm[1023:0];
integer i;

initial begin
dm[0]=0;
dm[1]=100;
dm[2]=1;
dm[3]=0;
dm[4]=0;
end

assign dout=dm[addr];

always@(posedge clk)begin
    if(we)
        dm[addr]<=din;
end;
endmodule
