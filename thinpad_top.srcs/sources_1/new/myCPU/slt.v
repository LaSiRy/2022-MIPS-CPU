`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/10 16:46:36
// Design Name: 
// Module Name: slt
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


module slt(
    input wire[31:0]A,
    input wire[31:0]B,
    output reg res
    );
    wire [31:0]sign = 32'h8000_0000;
    wire [31:0]a_adder = A + sign;
    wire [31:0]b_adder = B + sign;
    always @* begin
     res = ( a_adder < b_adder )? 1 : 0;
    end
endmodule
