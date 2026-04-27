`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2026 11:23:33 AM
// Design Name: 
// Module Name: RegFile
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


// =========================================
// UPDATED RegFile.v (DEBUG VERSION)
// Use this for simulation verification first
// =========================================
module RegFile(
input clk,
input RegWrite,
input [4:0] rs,
input [4:0] rt,
input [4:0] rd,
input [31:0] write_data,
output reg [31:0] read_data1,
output reg [31:0] read_data2
);

reg [31:0] regs [0:31];
integer i;

initial begin
    for(i=0;i<32;i=i+1)
        regs[i] = 0;

    // Debug test values
    regs[2]  = 1;    // shift amount for RSR
    regs[5]  = 1;    // shift amount for final RSR
    regs[8]  = 16;   // source value for first RSR
    regs[11] = 0;    // base address for LW
end

always @(posedge clk) begin
    if(RegWrite && rd != 0)
        regs[rd] <= write_data;

    regs[0] <= 0;
end

always @(negedge clk) begin
    read_data1 <= (rs == 0) ? 0 : regs[rs];
    read_data2 <= (rt == 0) ? 0 : regs[rt];
end

endmodule
