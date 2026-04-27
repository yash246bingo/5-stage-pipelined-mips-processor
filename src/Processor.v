`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2026 11:33:45 AM
// Design Name: 
// Module Name: Processor
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


module Processor(input clk, reset);

//wire stall, jump;
wire jump;
wire stall = 1'b0;
wire [31:0] jump_addr;
wire [31:0] PC, instruction;

IF if_stage(clk, reset, stall, jump, jump_addr, PC, instruction);

reg [31:0] IF_ID_instr;


reg [31:0] ID_EX_A, ID_EX_B, ID_EX_imm;
reg [4:0] ID_EX_rs, ID_EX_rt, ID_EX_rd;
reg ID_EX_RegWrite, ID_EX_MemRead, ID_EX_MemWrite, ID_EX_MemToReg;
reg [2:0] ID_EX_ALUControl;


reg [31:0] EX_MEM_ALUResult, EX_MEM_WriteData;
reg [4:0] EX_MEM_rd;
reg EX_MEM_RegWrite, EX_MEM_MemRead, EX_MEM_MemWrite, EX_MEM_MemToReg;


reg [31:0] MEM_WB_ReadData, MEM_WB_ALUResult;
reg [4:0] MEM_WB_rd;
reg MEM_WB_RegWrite, MEM_WB_MemToReg;


wire [5:0] opcode = IF_ID_instr[31:26];
wire [4:0] rs = IF_ID_instr[25:21];
wire [4:0] rt = IF_ID_instr[20:16];
wire [4:0] rd = IF_ID_instr[15:11];
wire [15:0] imm16 = IF_ID_instr[15:0];
wire [31:0] sign_ext_imm = {{16{imm16[15]}}, imm16};

assign jump = (opcode==6'b000010);
assign jump_addr = {PC[31:28], IF_ID_instr[25:0], 2'b00};


reg [4:0] dest_reg;
always @(*) begin
case(opcode)
6'b101000: dest_reg = rt;
6'b110010: dest_reg = rd;
6'b111011: dest_reg = rd;
default: dest_reg = 0;
endcase
end

wire [31:0] read1, read2;
wire [31:0] wb_data;
assign wb_data = MEM_WB_MemToReg ? MEM_WB_ReadData : MEM_WB_ALUResult;
RegFile rf(
clk,
MEM_WB_RegWrite,
rs, rt,
MEM_WB_rd,
wb_data,
read1, read2
);


//HazardUnit hz(ID_EX_MemRead,ID_EX_rt,rs,rt,stall);


wire [1:0] ForwardA, ForwardB;
ForwardingUnit fu(
ID_EX_rs, ID_EX_rt,
EX_MEM_rd,
MEM_WB_rd,
EX_MEM_RegWrite,
MEM_WB_RegWrite,
ForwardA, ForwardB
);


// Forward Muxes
reg [31:0] ALU_in1, ALU_in2;
always @(*) begin
case(ForwardA)
2'b00: ALU_in1 = ID_EX_A;
2'b10: ALU_in1 = EX_MEM_ALUResult;
2'b01: ALU_in1 = wb_data;
default: ALU_in1 = ID_EX_A;
endcase

case(ForwardB)
2'b00: ALU_in2 = ID_EX_B;
2'b10: ALU_in2 = EX_MEM_ALUResult;
2'b01: ALU_in2 = wb_data;
default: ALU_in2 = ID_EX_B;
endcase
end


wire [31:0] alu_out;
ALU alu(
ALU_in1,
(ID_EX_MemRead || ID_EX_MemWrite) ? ID_EX_imm : ALU_in2,
ID_EX_ALUControl,
alu_out
);


wire [31:0] mem_data;
DataMemory dm(
clk,
EX_MEM_MemRead,
EX_MEM_MemWrite,
EX_MEM_ALUResult,
EX_MEM_WriteData,
mem_data
);


always @(posedge clk or posedge reset) begin
if(reset) begin

IF_ID_instr <= 0;

ID_EX_A<=0; ID_EX_B<=0; ID_EX_imm<=0;
ID_EX_rs<=0; ID_EX_rt<=0; ID_EX_rd<=0;
ID_EX_RegWrite<=0; ID_EX_MemRead<=0;
ID_EX_MemWrite<=0; ID_EX_MemToReg<=0;
ID_EX_ALUControl<=0;

EX_MEM_ALUResult<=0;
EX_MEM_WriteData<=0;
EX_MEM_rd<=0;
EX_MEM_RegWrite<=0;
EX_MEM_MemRead<=0;
EX_MEM_MemWrite<=0;
EX_MEM_MemToReg<=0;

MEM_WB_ReadData<=0;
MEM_WB_ALUResult<=0;
MEM_WB_rd<=0;
MEM_WB_RegWrite<=0;
MEM_WB_MemToReg<=0;

end
else begin

// IF/ID
if(jump) begin
    IF_ID_instr <= 0;
end
else if(!stall) begin
    IF_ID_instr <= instruction;
end
else begin
    IF_ID_instr <= IF_ID_instr;
end

// ID/EX
if(stall || jump) begin
    ID_EX_A <= 0;
    ID_EX_B <= 0;
    ID_EX_imm <= 0;

    ID_EX_rs <= 0;
    ID_EX_rt <= 0;
    ID_EX_rd <= 0;

    ID_EX_RegWrite <= 0;
    ID_EX_MemRead <= 0;
    ID_EX_MemWrite <= 0;
    ID_EX_MemToReg <= 0;
    ID_EX_ALUControl <= 0;
end
else begin

ID_EX_A <= read1;
ID_EX_B <= read2;
ID_EX_imm <= sign_ext_imm;
ID_EX_rs <= rs;
ID_EX_rt <= rt;
ID_EX_rd <= dest_reg;

ID_EX_RegWrite<=0;
ID_EX_MemRead<=0;
ID_EX_MemWrite<=0;
ID_EX_MemToReg<=0;
ID_EX_ALUControl<=0;

case(opcode)
6'b101000: begin
ID_EX_RegWrite<=1;
ID_EX_MemRead<=1;
ID_EX_MemToReg<=1;
ID_EX_ALUControl<=3'b000;
end

6'b100011: begin
ID_EX_MemWrite<=1;
ID_EX_ALUControl<=3'b000;
end

6'b110010: begin
ID_EX_RegWrite<=1;
ID_EX_ALUControl<=3'b001;
end

6'b111011: begin
ID_EX_RegWrite<=1;
ID_EX_ALUControl<=3'b010;
end
endcase
end


// EX/MEM
EX_MEM_ALUResult <= alu_out;
EX_MEM_WriteData <= ALU_in2;
EX_MEM_rd <= ID_EX_rd;
EX_MEM_RegWrite <= ID_EX_RegWrite;
EX_MEM_MemRead <= ID_EX_MemRead;
EX_MEM_MemWrite <= ID_EX_MemWrite;
EX_MEM_MemToReg <= ID_EX_MemToReg;


// MEM/WB
MEM_WB_ReadData <= mem_data;
MEM_WB_ALUResult <= EX_MEM_ALUResult;
MEM_WB_rd <= EX_MEM_rd;
MEM_WB_RegWrite <= EX_MEM_RegWrite;
MEM_WB_MemToReg <= EX_MEM_MemToReg;

end
end
endmodule
