`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2026 11:32:03 AM
// Design Name: 
// Module Name: ForwardingUnit
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


module ForwardingUnit(
input [4:0] EX_rs, EX_rt,
input [4:0] MEM_rd, WB_rd,
input MEM_RegWrite, WB_RegWrite,
output reg [1:0] ForwardA, ForwardB
);

always @(*) begin
ForwardA = 2'b00;
ForwardB = 2'b00;

if(MEM_RegWrite && MEM_rd!=0 && MEM_rd==EX_rs)
ForwardA = 2'b10;
else if(WB_RegWrite && WB_rd!=0 && WB_rd==EX_rs)
ForwardA = 2'b01;

if(MEM_RegWrite && MEM_rd!=0 && MEM_rd==EX_rt)
ForwardB = 2'b10;
else if(WB_RegWrite && WB_rd!=0 && WB_rd==EX_rt)
ForwardB = 2'b01;
end

endmodule