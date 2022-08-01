`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/28 15:24:47
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
    input wire[1:0]addr,
    input wire[1:0]mem_op,
    output reg[3:0]mem_sel
    );
    always @* begin
        if(mem_op==`mem_sel_SW)begin
            mem_sel<=4'b1111;
        end
        else if(mem_op==`mem_sel_SB)begin
         case(addr)
            2'b00:mem_sel<=4'b0001;
            2'b01:mem_sel<=4'b0010;
            2'b10:mem_sel<=4'b0100;
            2'b11:mem_sel<=4'b1000;
            default:mem_sel<=4'b0;
         endcase
        end
        else
            mem_sel<=4'b0;
    end
 
endmodule
