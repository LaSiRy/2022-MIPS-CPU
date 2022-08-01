`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/10 15:00:07
// Design Name: 
// Module Name: Alu
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

module Alu(
    input wire[31:0]a_val,
    input wire[31:0]b_val,
    input wire[3:0]ctrl,
    input wire[2:0]comp_ctrl,
    output wire[31:0]result,
    output wire res_comp
    );
    wire[31:0]res_AND;//and
    wire[31:0]res_OR;//or
    wire[31:0]res_xor;//xor
    //
    wire[31:0]res_srl;//srl
    wire[31:0]res_sll;//sll
    wire[31:0]res_mul;//mul
    wire res_slt;//slt
    wire[31:0]res_sra;//sra
    wire [31:0]res_add;//add
    wire [31:0]res_sub;//sub
    mux8to1_32 U0(.I0(res_add),.I1(res_sub),.I2(res_sll),.I3({31'b0,res_slt}),.I4(res_mul),
    .I5(res_xor),.I6(res_srl),.I7(res_sra),.I8(res_OR),.I9(res_AND),.select(ctrl),.res(result));
    add32 U1(.A(a_val),.B(b_val),.res(res_add)); //addu£¬ÎÞÒç³öÒì³£
    sub32 U2(.A(a_val),.B(b_val),.res(res_sub));
    and32 U3(.A(a_val),.B(b_val),.res(res_AND));
    or32 U4(.A(a_val),.B(b_val),.res(res_OR));
    xor32 U5(.A(a_val),.B(b_val),.res(res_xor));
    srl32 U6(.A(a_val),.B(b_val),.res(res_srl));
    sll32 U7(.A(a_val),.B(b_val),.res(res_sll));
    slt U8(.A(a_val),.B(b_val),.res(res_slt));
    mul U9(.A(a_val),.B(b_val),.res(res_mul));
    sra U10(.A(a_val),.B(b_val),.res(res_sra));    
    Comparator U11(.a_val(a_val),.b_val(b_val),.ctrl(comp_ctrl),.result(res_comp));
endmodule
