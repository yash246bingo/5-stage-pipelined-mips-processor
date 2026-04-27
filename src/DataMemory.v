`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2026 11:25:41 AM
// Design Name: 
// Module Name: DataMemory
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



module DataMemory(
input clk,
input MemRead,
input MemWrite,
input [31:0] addr,
input [31:0] write_data,
output reg [31:0] read_data
);

reg [7:0] DMEM [0:1023];
wire [9:0] a = addr[9:0];
integer i;

always @(posedge clk) begin
    if(MemWrite) begin
        DMEM[a]   <= write_data[31:24];
        DMEM[a+1] <= write_data[23:16];
        DMEM[a+2] <= write_data[15:8];
        DMEM[a+3] <= write_data[7:0];
    end
end

always @(*) begin
    if(MemRead)
        read_data = {DMEM[a],DMEM[a+1],DMEM[a+2],DMEM[a+3]};
    else
        read_data = 32'b0;
end

initial begin
    for(i=0;i<1024;i=i+1)
        DMEM[i] = 8'b0;
// Preload value for LW at address 12
    DMEM[12] = 8'h00;
    DMEM[13] = 8'h00;
    DMEM[14] = 8'h00;
    DMEM[15] = 8'h0C;
end

endmodule