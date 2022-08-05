`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/03 22:27:40
// Design Name: 
// Module Name: mem_sel
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


module mem_sel(
    input wire [1:0]addr,
    input wire [1:0]mem_op,
    output reg [3:0]mem_sel
    );
    always @(*)begin
    if(mem_op == `mem_sel_SW)begin
        mem_sel <= 4'b1111;
    end
    else if(mem_op == `mem_sel_SB)begin
        case(addr)
        2'd0: mem_sel <= 4'b0001;
        2'd1: mem_sel <= 4'b0010;
        2'd2: mem_sel <= 4'b0100;
        2'd3: mem_sel <= 4'b1000;
        default: mem_sel <= 4'b0000;
        endcase
    end
    else begin mem_sel <= 4'b0000;end
    end
endmodule
