`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2026 11:22:42 AM
// Design Name: 
// Module Name: IF
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



module IF(
input clk,
input reset,
input stall,
input jump,
input [31:0] jump_addr,
output reg [31:0] PC,
output [31:0] instruction
);

reg [31:0] IMEM [0:255];
integer i;

assign instruction = IMEM[PC >> 2];

always @(posedge clk or posedge reset) begin
    if(reset)
        PC <= 0;
    else if(!stall) begin
        if(jump)
            PC <= jump_addr;
        else
            PC <= PC + 4;
    end
end

initial begin
    
    for(i=0;i<256;i=i+1)
        IMEM[i] = 32'b0;

    IMEM[0] = 32'b101000_01011_00001_0000000000001100; // LW R1,R11,#12
    IMEM[1] = 32'b111011_01000_00010_00011_00000_000000; // RSR R3,R8,R2
    IMEM[2] = 32'b110010_00001_00011_00010_00000_000000; // LSR R2,R1,R3
    IMEM[3] = 32'b000010_00000000000000000000000101; // J L1
    IMEM[4] = 32'b111011_00110_00110_00110_00000_000000; // skipped
    IMEM[5] = 32'b111011_00011_00101_00100_00000_000000; // L1
end

endmodule
