// This page include code for memory cyle inculding all the module instantiate with it
// Please find the associated module below the main module of memory cycle

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2025 01:23:08
// Design Name: 
// Module Name: Memory_Cycle
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


module Memory_Cycle(clk, rst, PCPlus4M, ALUResultM, WriteDataM, RdM,
                    ResultSrcM, RegWriteM, MemWriteM, ALUResultW, 
                    ReadDataW, PCPlus4W, RegWriteW, ResultSrcW, RdW);
                    
input clk, rst;
input RegWriteM, MemWriteM, ResultSrcM;
input [31:0] PCPlus4M, ALUResultM, WriteDataM;
input [4:0] RdM;  

output RegWriteW, ResultSrcW;
output [31:0] ALUResultW, ReadDataW, PCPlus4W;
output [4:0] RdW;

wire [31:0] RD_result_M;

reg [31:0] RD_result_M_r, PCPlus4M_r, ALUResultM_r;
reg RegWriteM_r, ResultSrcM_r;
reg [4:0] RdM_r;

Data_memory data_mem_block (
                            .A(ALUResultM), 
                            .WD(WriteDataM), 
                            .CLK(clk),
                            .RST(rst), 
                            .WE(MemWriteM), 
                            .RD(RD_result_M)
                            );

always @ (posedge clk or negedge rst) begin
    if (rst ==1'b0) begin
        RegWriteM_r <= 1'b0;
        ResultSrcM_r <= 1'b0;
        RD_result_M_r <= 32'h00000000;
        RdM_r <= 5'b00000;
        PCPlus4M_r <= 32'h00000000;
        ALUResultM_r <= 32'h00000000; 
    end
    else begin
        RegWriteM_r <= RegWriteM;
        ResultSrcM_r <= ResultSrcM;
        RD_result_M_r <= RD_result_M;
        RdM_r <= RdM;
        PCPlus4M_r <= PCPlus4M;
        ALUResultM_r <= ALUResultM;
    end
end

assign RegWriteW = RegWriteM_r;
assign ResultSrcW = ResultSrcM_r;
assign ALUResultW = ALUResultM_r;
assign ReadDataW = RD_result_M_r;
assign RdW = RdM_r;
assign PCPlus4W = PCPlus4M_r;

endmodule


//*********************************************************************************************************//

//***************************************       DATA_MEMORY     *******************************************//

//*********************************************************************************************************//

module Data_memory(A, WD, CLK, RST, WE, RD);
    input CLK, WE, RST;
    input [31:0] A, WD;
    output [31:0] RD;

    reg [31:0] data_mem [1023:0];
    integer i;
 //Read operation
   
assign RD = (WE == 1'b0)? data_mem[A] : 32'h00000000;

//write operation
    
  always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            data_mem [A] <=32'h00000000; 
        end else if (WE) begin
            data_mem[A] <= WD;
        end
    end

initial begin
        data_mem[28] = 32'h000000F0;
        data_mem[27] = 32'h000000F1;
        data_mem[248] = 32'hF00000AC;
    end
    
endmodule
