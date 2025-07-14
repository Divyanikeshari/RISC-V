// This page include code for execute cyle inculding all the module instantiate with it
// Please find the associated module below the main module of execute cycle


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2025 23:54:01
// Design Name: 
// Module Name: Execute_ Cycle
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


module Execute_cycle(clk, rst, RD1E, RD2E, PCE, RdE, ImmExtE, PCPlus4E, 
                    RegWriteE, MemWriteE, ALUSrcE, ALUControlE, ResultSrcE, 
                    PCSrcE, PCTargetE, PCPlus4M, ALUResultM, WriteDataM,
                    RdM, ResultSrcM, RegWriteM, MemWriteM, 
                    ReadDataW, Rs1E, Rs2E, ForwardAE, ForwardBE, ResultW, RD_result_M);

input clk, rst;
input [31:0] RD1E, RD2E, ImmExtE,PCE,PCPlus4E;
input RegWriteE, MemWriteE, ALUSrcE, ResultSrcE;
input [2:0] ALUControlE;
input [4:0] RdE;
input [4:0] Rs1E, Rs2E;
input [31:0] ReadDataW, ResultW, RD_result_M;
input [1:0] ForwardAE, ForwardBE; 

output [31:0] PCTargetE, PCSrcE;
output RegWriteM, MemWriteM, ResultSrcM;
output [4:0] RdM;
output [31:0] PCPlus4M, ALUResultM, WriteDataM;

wire [31:0] SrcBE, alu_result, SrcAE, mux3_mux2, ForwardAE2; 
wire ZeroE;

reg RegWriteE_r, MemWriteE_r;
reg [1:0] ResultSrcE_r;
reg [4:0] RdE_r;
reg [31:0] PCPlus4E_r, alu_result_r, RD2E_r;

Mux mux_2x1_ForwardAE2(
        .a(ALUResultM),
        .b(RD_result_M),
        .s(ResultSrcM),
        .out(ForwardAE2)
        );


mux3x1 mux_3x1_a(
                .a(RD1E),
                .b(ResultW),
                .c(ForwardAE2),
                .s(ForwardAE),
                .out(SrcAE)
                );
                
                
mux3x1 mux_3x1_b(
                .a(RD2E),
                .b(ResultW),
                .c(ForwardAE2),
                .s(ForwardBE),
                .out(mux3_mux2)
                );


Mux mux_2x1(
        .a(mux3_mux2),
        .b(ImmExtE),
        .s(ALUSrcE),
        .out(SrcBE)
        );
        
        
pc_adder adder(
                .a(PCE),
                .b(ImmExtE),
                .sum(PCTargetE)
                );


alu  alu_block(
                .A(SrcAE), 
                .B(SrcBE), 
                .RESULT(alu_result), 
                .ALUcontrol(ALUControlE), 
                .N(),
                .Z(ZeroE),
                .V(),
                .C(),
                .PF()
                );
                
               
always @ (posedge clk or negedge rst) begin
    if(rst == 1'b0) begin
        RegWriteE_r <= 1'b0;
        MemWriteE_r <= 1'b0;
        ResultSrcE_r <= 1'b0;
        RdE_r <= 5'b00000;
        PCPlus4E_r <= 32'h00000000;
        alu_result_r <= 32'h00000000;
        RD2E_r <= 32'h00000000;
    end
    else begin
        RegWriteE_r <= RegWriteE;
        MemWriteE_r <= MemWriteE;
        ResultSrcE_r <= ResultSrcE;
        RdE_r <= RdE;
        PCPlus4E_r <= PCPlus4E; 
        alu_result_r <= alu_result;
        RD2E_r <= mux3_mux2;
    end
end

assign RegWriteM = RegWriteE_r;
assign MemWriteM = MemWriteE_r;
assign ResultSrcM = ResultSrcE_r;
assign RdM = RdE_r;
assign PCPlus4M = PCPlus4E_r;
assign ALUResultM = alu_result_r;
assign WriteDataM = RD2E_r;

endmodule


//**********************************************************************************************************************//

//*************************************          MUX          **********************************************************//

//**********************************************************************************************************************//

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.06.2025 21:23:24
// Design Name: 
// Module Name: MUX
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


module Mux(a,b,s,out);
input [31:0] a,b;
input s;
output [31:0] out;

assign out = (!s) ? a : b;

endmodule


//**********************************************************************************************************************//

//*************************************       MUX(3X1)        **********************************************************//

//**********************************************************************************************************************//


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.06.2025 01:44:55
// Design Name: 
// Module Name: Hazard_Unit
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


module mux3x1 (a,b,c,s,out);
input [31:0] a,b,c;
input [1:0] s;
output wire [31:0] out;

assign out = (s == 2'b00) ? a :
             (s == 2'b01) ? b : 
             (s == 2'b10) ? c : 32'h00000000;

endmodule



//**********************************************************************************************************************//

//*************************************        PC_ADDER       **********************************************************//

//**********************************************************************************************************************//


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2025 23:50:59
// Design Name: 
// Module Name: pc_adder
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


module pc_adder(a,b,sum);
input [31:0] a,b;
output [31:0] sum;

assign sum = a+b;
endmodule


//**********************************************************************************************************************//

//*************************************          ALU          **********************************************************//

//**********************************************************************************************************************//


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2025 22:33:46
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


module alu ( A, B, RESULT, ALUcontrol, N,Z,V,C,PF);
input [31:0] A,B;
input [2:0] ALUcontrol;
output [31:0] RESULT;
output N,Z,C,V,PF;

wire [31:0] a_and_b, a_or_b;
wire  [31:0]not_b;
wire [31:0] a_xor_b;
wire [31:0] mux1;
wire [31:0] sum;
wire carry_out;
wire [31:0] mux2;
wire [31:0] slt;
wire [31:0] sll;
wire [31:0] srl;


assign a_and_b = A & B;
assign a_or_b = A | B;
assign not_b = ~B;
assign a_xor_b = A ^ B;

assign mux1 = (ALUcontrol[0]==1'b0)? B : not_b; 

assign {carry_out, sum} = A + mux1 + ALUcontrol[0];

assign slt = {31'b0000000000000000000000000000000 , sum[31]};

assign sll = A << B[4:0];

assign srl = A >> B[4:0];

assign mux2 = (ALUcontrol[2:0]==3'b000) ? sum:
              (ALUcontrol[2:0]==3'b001) ? sum:  
              (ALUcontrol[2:0]==3'b010) ? a_and_b:
              (ALUcontrol[2:0]==3'b011) ? a_or_b:
              (ALUcontrol[2:0]==3'b100) ? a_xor_b:
              (ALUcontrol[2:0]==3'b101) ? slt:
              (ALUcontrol[2:0]==3'b110) ? sll: srl;

assign RESULT = mux2;

assign Z = &(~RESULT);
assign PF= ^(RESULT);
assign N = (ALUcontrol[2]==1'b0)? RESULT[31]: 1'b0;
assign C = carry_out & (~ALUcontrol[2]);
assign V = (ALUcontrol[2:0] == 3'b000) ? ((A[31] == B[31]) & (A[31] != sum[31])) :
           (ALUcontrol[2:0] == 3'b001) ? ((A[31] != B[31]) & (A[31] != sum[31])) :
           (ALUcontrol[2:0] == 3'b010) ? (A == 32'h7FFFFFFF) :
           (ALUcontrol[2:0] == 3'b011) ? (A == 32'h80000000) :
           1'b0;
endmodule
