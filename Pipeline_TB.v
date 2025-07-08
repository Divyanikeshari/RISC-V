`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2025 20:59:28
// Design Name: 
// Module Name: Pipiline_tb
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


module Pipiline_TB();

reg clk, rst;
integer cycle;


Pipeline_Core dut(.clk(clk), .rst(rst));

initial begin
clk = 1'b1;
end


always 
    begin 
    clk = ~clk;
    #50;
    end

always @(posedge clk) begin
    if (rst) cycle <= cycle + 1;
end 
    
initial begin
    rst = 1'b0;
    #100;
    rst = 1'b1;
    #900;
    $finish;

end

integer i;
initial begin
    #900;  // After enough time for instructions to execute
    $display("---- Register File Contents ----");
    for (i = 0; i < 32; i = i + 1) begin
        $display("x%0d = %h", i, dut.decode_block.reg_file.mem[i]);
    end
end


 initial begin
    $monitor("%d\t%h\t%h\t%d\t%d\t%d", 
         cycle,
         dut.PCD,
         dut.InstrD,
         dut.decode_block.Rs1D_out,
         dut.decode_block.Rs2D_out,
         dut.decode_block.RdD_out);

end


endmodule
