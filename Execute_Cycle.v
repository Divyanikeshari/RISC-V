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
                    RdM, ResultSrcM, RegWriteM, MemWriteM);

input clk, rst;
input [31:0] RD1E, RD2E, ImmExtE,PCE,PCPlus4E;
input RegWriteE, MemWriteE, ALUSrcE, ResultSrcE;
input [2:0] ALUControlE;
input [4:0] RdE;
//input [4:0] Rs1E, Rs2E;
//input [31:0] ResultW;
//input [1:0] ForwardAE, ForwardBE; 


output [31:0] PCTargetE, PCSrcE;
output RegWriteM, MemWriteM, ResultSrcM;
output [4:0] RdM;
output [31:0] PCPlus4M, ALUResultM, WriteDataM;
 


wire [31:0] SrcBE, alu_result, SrcAE, mux3_mux2; 
wire ZeroE;

reg RegWriteE_r, MemWriteE_r;
reg [1:0] ResultSrcE_r;
reg [4:0] RdE_r;
reg [31:0] PCPlus4E_r, alu_result_r, RD2E_r;


//mux3x1 mux_3x1_a(
//                .a(RD1E),
//                .b(ResultW),
//                .c(ALUResultM),
//                .s(ForwardAE),
//                .out(SrcAE)
//                );
                
                
//mux3x1 mux_3x1_b(
//                .a(RD2E),
//                .b(ResultW),
//                .c(ALUResultM),
//                .s(ForwardBE),
//                .out(mux3_mux2)
//                );


Mux mux_2x1(
        .a(RD2E),
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
                .A(RD1E), 
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
        RD2E_r <= RD2E;
    end
end

assign RegWriteM = RegWriteE_r;
assign MemWriteM = MemWriteE_r;
assign ResultSrcM = ResultSrcE_r;
assign RdM = RdE_r;
assign PCPlus4M = PCPlus4E_r;
assign ALUResultM = alu_result_r;
assign WriteDataM = RD2E;

endmodule
