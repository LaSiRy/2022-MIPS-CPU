`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/10 16:15:20
// Design Name: 
// Module Name: sub32
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


module sub32(
    input wire[31:0]A,
    input wire[31:0]B,
    output reg[31:0]res
    );
    wire [31:0]B_sign;
    wire [31:0]B_adder;
    assign B_sign = 32'hFFFF_FFFF;
    assign B_adder = B_sign ^ B;
    always @* begin
     res = A + B_adder + 1'b1;
    end
endmodule
