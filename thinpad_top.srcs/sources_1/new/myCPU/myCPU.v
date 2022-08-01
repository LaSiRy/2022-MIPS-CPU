`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/17 13:14:42
// Design Name: 
// Module Name: myCPU
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
//七级流水：取址需要两个时钟周期完成
module myCPU(
    input wire clk,//时钟信号
    input wire resetn,//复位信号
    output wire inst_sram_en,    
    output wire [3:0] inst_sram_wen,   
    output wire [31:0] inst_sram_addr,  
    output wire [31:0] inst_sram_wdata,
    input wire [31:0] inst_sram_rdata, 
//    `DBG_Core_Outputs
    output wire [31:0] debug_wb_pc,
    output wire [3:0]  debug_wb_rf_wen,
    output wire [4:0]  debug_wb_rf_wnum,
    output wire [31:0] debug_wb_rf_wdata,
    
    output wire data_sram_en,    
    output wire [3:0] data_sram_wen,   
    output wire [31:0] data_sram_addr,  
    output wire [31:0] data_sram_wdata, 
    input  wire [31:0] data_sram_rdata    
   );
    wire rst;
    wire [31:0] PC;
    wire [3:0] mem_sel;//sw_byte_select
    wire dmem_wen;
    wire isRead_inst;
    wire isRead_data;
    wire [31:0]data_addr;
    wire [31:0]data_out;
    

assign inst_sram_addr = rst? 0: PC;
assign inst_sram_en = rst? 0: isRead_inst;
assign inst_sram_wdata = 0;
assign inst_sram_wen = 0;

assign data_sram_en = rst? 0: isRead_data;
assign data_sram_wen = rst? 0: mem_sel & {4{dmem_wen}};
assign data_sram_addr = rst? 0: data_addr;
assign data_sram_wdata = rst? 0: data_out;

assign rst=~resetn;  
 DataPath  datapath(
//     `DBG_Core_Arguments
     .debug_wb_pc(debug_wb_pc),        
     .debug_wb_rf_wen(debug_wb_rf_wen),    
     .debug_wb_rf_wnum(debug_wb_rf_wnum),   
     .debug_wb_rf_wdata(debug_wb_rf_wdata),  
      
     .isRead_inst(isRead_inst),//IF阶段
     .isRead_data(isRead_data),//MEM阶段
     .mem_sel(mem_sel),
     .clk(clk),
     .rst(rst),
     .Din_addr(data_addr),//输出待读取数据的地址
     .Data_in(data_sram_rdata),//输入读到的Dmem的数据
     .inst_field_in(inst_sram_rdata),//输入的读到的指令数据
     .dmem_wen(dmem_wen),//输出DMEM的写使能信号
     .Data_out(data_out),//输出的待写入数据
     .PC_out(PC)//输出的指令地址
  );

endmodule
