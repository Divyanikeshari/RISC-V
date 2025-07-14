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


module Hazard_Unit(rst, RdM, RegWriteM, RdW, RegWriteW, Rs1E, Rs2E, ForwardAE, ForwardBE);

input rst, RegWriteM, RegWriteW;
input [4:0] RdM, RdW, Rs1E, Rs2E;
output [1:0] ForwardAE, ForwardBE;

assign ForwardAE = (rst == 1'b0) ? 2'b00 :
                   ((RegWriteM == 1'b1) && (RdM != 5'b00000) && (RdM == Rs1E)) ? 2'b10 : // When we need the result of previous instruction
                   ((RegWriteW == 1'b1) && (RdW != 5'b00000) && (RdW == Rs1E)) ? 2'b01 : // When we need the result of previous to previous instruction
                   2'b00;

assign ForwardBE = (rst == 1'b0) ? 2'b00 :
                   ((RegWriteM == 1'b1) && (RdM != 5'b00000) && (RdM == Rs2E)) ? 2'b10 : // When we need the result of previous instruction
                   ((RegWriteW == 1'b1) && (RdW != 5'b00000) && (RdW == Rs2E)) ? 2'b01 : // When we need the result of previous to previous instruction
                   2'b00;
                 

endmodule
