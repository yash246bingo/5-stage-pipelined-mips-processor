`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2026 11:32:52 AM
// Design Name: 
// Module Name: HazardUnit
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


module HazardUnit(
input ID_EX_MemRead,
input [4:0] ID_EX_rt,
input [4:0] IF_ID_rs,
input [4:0] IF_ID_rt,
output reg stall
);

always @(*) begin
if(ID_EX_MemRead &&
ID_EX_rt!=0 &&
((ID_EX_rt==IF_ID_rs)||(ID_EX_rt==IF_ID_rt)))
stall=1;
else
stall=0;
end

endmodule