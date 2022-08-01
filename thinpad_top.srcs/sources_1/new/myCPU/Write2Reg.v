`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/12 19:52:38
// Design Name: 
// Module Name: Write2Reg
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


module Write2Reg(
    input wire[31:0]pc,
    input wire[31:0]ALU,
    input wire[31:0]Mem,
    input wire[1:0]mem_op,
    input wire[31:0]lui,
    input wire[1:0]MemtoReg,//0:ALU,1:Mem,2:PC+8 3:lui
    output reg [31:0]res
    );
    wire [31:0]PC_8 = pc + 4'b1000;
  always @(*)begin
    case(MemtoReg)
    3'd0:res <= ALU;
    3'd1:begin
        if(mem_op==`mem_sel_LW)
            res <= Mem;
        else if(mem_op==`mem_sel_LB)begin
            case(ALU[1:0])
            2'b00:  res <= {{24{Mem[ 7]}}, Mem[7:0]};
            2'b01:  res <= {{24{Mem[15]}}, Mem[15:8]};
            2'b10:  res <= {{24{Mem[23]}}, Mem[23:16]};
            2'b11:  res <= {{24{Mem[31]}}, Mem[31:24]};
            default: begin res <= 32'b0; end
            endcase
        end
        else begin end
       end
    3'd2:res <= PC_8;
    3'd3:res <= lui;
    default:res <= 32'b0;
  endcase
    end
endmodule
