`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/31 10:45:43
// Design Name: 
// Module Name: mul
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


module mul (
    input wire[31:0]A,
    input wire[31:0]B,
    output wire[31:0] res
    );
    reg [63:0]P;
    assign res = P[31:0];
    always @* begin
     P = ($signed(A)) * ($signed(B));
    end
endmodule
