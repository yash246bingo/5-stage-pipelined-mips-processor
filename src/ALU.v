`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2026 11:24:37 AM
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


module ALU(
input [31:0] A,
input [31:0] B,
input [2:0] ALUControl,
output reg [31:0] result
);

always @(*) begin
case(ALUControl)
3'b000: result = A + B;
3'b001: result = A << B;
3'b010: result = A >> B;
default: result = 0;
endcase
end

endmodule

