`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/10 15:00:38
// Design Name: 
// Module Name: Comparator
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
`include "Defines.vh"

module Comparator(
    input wire[31:0]a_val,
    input wire[31:0]b_val,
    input wire[2:0]ctrl,
    output wire result
    );
    reg res;
    wire [31:0]sign = 32'h8000_0000;
    wire [31:0]a_adder = a_val+sign;
    wire [31:0]b_adder = b_val+sign;
    assign result = res;
    always @(*) begin
    case(ctrl)
    `CMP_EQ: res=(a_val==b_val)?1'b1:0;
    `CMP_LT: res=(a_adder<b_adder)?1'b1:0;
    `CMP_GE: res=(a_adder<b_adder)?0:1'b1;
    `CMP_GT: res=(a_adder>b_adder)?1'b1:0;
    `CMP_NE: res=(a_val==b_val)?0:1'b1;
    `CMP_LTU:res=(a_val<b_val)?1'b1:0;
    `CMP_GEU:res=(a_val<b_val)?0:1'b1;
    default: res=0;
    endcase
    end
endmodule
