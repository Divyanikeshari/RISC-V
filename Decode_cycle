`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.06.2025 22:04:49
// Design Name: 
// Module Name: Decode_Cycle
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


module Decode_Cycle(clk, rst, InstrD, PCD, PCPlus4D,RegWriteW, RDW, ResultW,
                     ZeroE, ResultSrcE, MemWriteE, ALUSrcE, RegWriteE, 
                     PCSrcE, ALUControlE, RD1_E, RD2_E, ImmExtE,RdE, PCPlus4E, PCE, Rs1D_out, Rs2D_out, RdD_out);

input [31:0] InstrD, PCD, PCPlus4D, RDW, ResultW;
input clk, rst, RegWriteW, ZeroE;

output ResultSrcE, MemWriteE, ALUSrcE, RegWriteE, PCSrcE;
output [2:0] ALUControlE;
output [31:0] RD1_E, RD2_E, ImmExtE, PCPlus4E, PCE;
output [4:0] RdE; 
output [4:0] Rs1D_out, Rs2D_out, RdD_out;

//output [4:0] Rs1E, Rs2E;


wire ResultSrcD, MemWriteD, ALUSrcD, RegWriteD, PCSrcD;
wire [2:0] ALUControlD;
wire [1:0] ImmSrcD;
wire [31:0] RD1_D, RD2_D, ImmExtD;
wire [4:0] regfile_a1, regfile_a2;
// regfile_a3;


reg ResultSrcD_r, MemWriteD_r, ALUSrcD_r, RegWriteD_r, PCSrcD_r;
reg [2:0] ALUControlD_r;
reg [31:0] RD1_D_r, RD2_D_r, ImmExtD_r, PCPlus4D_r, PCD_r;
reg [4:0] RdD_r, Rs1D_r, Rs2D_r;


control_unit ctrl_block (
                        .Zero(ZeroE), 
                        .op(InstrD[6:0]), 
                        .funct3(InstrD[14:12]), 
                        .funct7_5(InstrD[30]), 
                        .PCSrc(PCSrcD), 
                        .ResultSrc(ResultSrcD), 
                        .MemWrite(MemWriteD), 
                        .ALUSrc(ALUSrcD), 
                        .ImmSrc(ImmSrcD), 
                        .RegWrite(RegWriteD), 
                        .ALUControl(ALUControlD)
                        );
 
                        
assign regfile_a1 = InstrD[19:15];
assign regfile_a2 = InstrD[24:20];

assign Rs1D_out = regfile_a1;
assign Rs2D_out = regfile_a2;
assign RdD_out = InstrD[11:7];

//assign regfile_a3 = InstrD[11:7];

register_file reg_file (
    .A1(regfile_a1), 
    .A2(regfile_a2), 
    .A3(RDW), 
    .WE3(RegWriteW), 
    .WD3(ResultW), 
    .CLK(clk), 
    .RST(rst), 
    .RD1(RD1_D), 
    .RD2(RD2_D)
);
                                
              
Sign_extension extend_block (
                            .in(InstrD), 
                            .out(ImmExtD), 
                            .ImmSrc(ImmSrcD[0])
                            );


always @ (posedge clk or negedge rst) begin
    if (rst == 1'b0) begin
        ResultSrcD_r <= 1'b0;
        MemWriteD_r <= 1'b0;
        ALUSrcD_r <= 1'b0;
        RegWriteD_r <= 1'b0;
        PCSrcD_r <= 1'b0;
        ALUControlD_r <= 3'b000;
        RD1_D_r <= 32'h00000000;
        RD2_D_r <= 32'h00000000;
        ImmExtD_r <= 32'h00000000; 
        RdD_r <= 5'b00000;
        PCD_r <= 32'h00000000;
        PCPlus4D_r <= 32'h00000000;
//        Rs1D_r <= 5'b00000;
//        Rs2D_r <= 5'b00000;
    end
    else begin
        ResultSrcD_r <= ResultSrcD;
        MemWriteD_r <= MemWriteD;
        ALUSrcD_r <= ALUSrcD;
        RegWriteD_r <= RegWriteD;
        PCSrcD_r <= PCSrcD;
        ALUControlD_r <= ALUControlD;
        RD1_D_r <= RD1_D;
        RD2_D_r <= RD2_D;
        ImmExtD_r <= ImmExtD; 
        RdD_r <= InstrD[11:7];
        PCD_r <= PCD;
        PCPlus4D_r <= PCPlus4D;
//        Rs1D_r <= regfile_a1;
//        Rs2D_r <= regfile_a2; 
    end
end

assign ResultSrcE = ResultSrcD_r;
assign MemWriteE = MemWriteD_r;
assign ALUSrcE = ALUSrcD_r;
assign RegWriteE = RegWriteD_r;
assign PCSrcE = PCSrcD_r;
assign ALUControlE = ALUControlD_r;
assign RD1_E = RD1_D_r;
assign RD2_E = RD2_D_r;
assign ImmExtE = ImmExtD_r;
assign RdE = RdD_r;
assign PCE = PCD;
assign PCPlus4E = PCPlus4D;
//assign Rs1E = Rs1D_r;
//assign Rs2E = Rs2D_r;

endmodule


