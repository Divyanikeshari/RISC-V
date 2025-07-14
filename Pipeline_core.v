`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2025 18:56:23
// Design Name: 
// Module Name: Pipeline_Core
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


module Pipeline_Core(clk, rst, PCF, InstrD);

input clk, rst;
output wire [31:0] PCF, InstrD; 


wire [31:0] PCTargetE, PCSrcE, PCD, PCPlus4D, ResultW, RD1_E, RD2_E, ImmExtE,PCPlus4M,
            PCPlus4E,PCE, ALUResultM, WriteDataM, ALUResultW, ReadDataW, PCPlus4W;
wire RegWriteW, MemWriteE, ALUSrcE, RegWriteE, RegWriteM;
wire [1:0] ResultSrcE, ResultSrcM, ResultSrcW, ForwardAE, ForwardBE;
wire [2:0] ALUControlE;
wire [4:0] RdE, RDW, RdM;
wire [4:0] Rs1E, Rs2E;

Fetch_cycle fetch_block(
                    .clk(clk), 
                    .rst(rst), 
                    .PCTargetE(PCTargetE), 
                    .PCSrcE(PCSrcE), 
                    .InstrD(InstrD), 
                    .PCD(PCD), 
                    .PCPlus4D(PCPlus4D)
                    );
                    
                    
Decode_Cycle decode_block(
                        .clk(clk), 
                        .rst(rst), 
                        .InstrD(InstrD), 
                        .PCD(PCD), 
                        .PCPlus4D(PCPlus4D),
                        .RegWriteW(RegWriteW), 
                        .RDW(RDW), 
                        .ResultW(ResultW),
                        .ZeroE(), 
                        .ResultSrcE(ResultSrcE), 
                        .MemWriteE(MemWriteE), 
                        .ALUSrcE(ALUSrcE), 
                        .RegWriteE(RegWriteE), 
                        .PCSrcE(PCSrcE), 
                        .ALUControlE(ALUControlE),
                        .RD1_E(RD1_E), 
                        .RD2_E(RD2_E), 
                        .ImmExtE(ImmExtE),
                        .RdE(RdE), 
                        .PCPlus4E(PCPlus4E), 
                        .PCE(PCE),
                        .Rs1E(Rs1E), 
                        .Rs2E(Rs2E),
                        .Rs1D_out(), 
                        .Rs2D_out(), 
                        .RdD_out()
                        );


Execute_cycle execute_block(
                            .clk(clk), 
                            .rst(rst), 
                            .RD1E(RD1_E), 
                            .RD2E(RD2_E), 
                            .PCE(PCE), 
                            .RdE(RdE), 
                            .ImmExtE(ImmExtE), 
                            .PCPlus4E(PCPlus4E), 
                            .RegWriteE(RegWriteE), 
                            .MemWriteE(MemWriteE), 
                            .ALUSrcE(ALUSrcE), 
                            .ALUControlE(ALUControlE), 
                            .ResultSrcE(ResultSrcE), 
                            .PCSrcE(PCSrcE), 
                            .PCTargetE(PCTargetE), 
                            .PCPlus4M(PCPlus4M), 
                            .ALUResultM(ALUResultM), 
                            .WriteDataM(WriteDataM),
                            .RdM(RdM), 
                            .ResultSrcM(ResultSrcM), 
                            .RegWriteM(RegWriteM), 
                            .MemWriteM(MemWriteM),
                            .ReadDataW (ReadDataW), 
                            .ForwardAE(ForwardAE), 
                            .ForwardBE(ForwardBE),
                            .Rs1E(Rs1E), 
                            .Rs2E(Rs2E),
                            .ResultW(ResultW),
                            .RD_result_M(memory_block.RD_result_M)
                            );


Memory_Cycle memory_block(
                        .clk(clk), 
                        .rst(rst), 
                        .PCPlus4M(PCPlus4M), 
                        .ALUResultM(ALUResultM), 
                        .WriteDataM(WriteDataM), 
                        .RdM(RdM),
                        .ResultSrcM(ResultSrcM), 
                        .RegWriteM(RegWriteM), 
                        .MemWriteM(MemWriteM), 
                        .ALUResultW(ALUResultW), 
                        .ReadDataW(ReadDataW), 
                        .PCPlus4W(PCPlus4W), 
                        .RegWriteW(RegWriteW), 
                        .ResultSrcW(ResultSrcW), 
                        .RdW(RDW)
                        );


WriteBack_cycle write_block(
                            .clk(clk), 
                            .rst(rst), 
                            .ResultSrcW(ResultSrcW), 
                            .ALUResultW(ALUResultW), 
                            .ReadDataW(ReadDataW),
                            .PCPlus4W(PCPlus4W), 
                            .ResultW(ResultW)
                            );


assign PCF = fetch_block.PC_F;   // Expose internal PCF wire
assign InstrD = fetch_block.InstrD; // Expose instruction

Hazard_Unit hazard_block (
                        .rst(rst), 
                        .RdM(RdM), 
                        .RegWriteM(RegWriteM), 
                        .RdW(RDW), 
                        .RegWriteW(RegWriteW), 
                        .Rs1E(Rs1E), 
                        .Rs2E(Rs2E), 
                        .ForwardAE(ForwardAE), 
                        .ForwardBE(ForwardBE)
                        );


endmodule
