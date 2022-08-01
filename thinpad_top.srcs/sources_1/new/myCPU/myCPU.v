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
//�߼���ˮ��ȡַ��Ҫ����ʱ���������
module myCPU(
    input wire clk,//ʱ���ź�
    input wire resetn,//��λ�ź�
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
      
     .isRead_inst(isRead_inst),//IF�׶�
     .isRead_data(isRead_data),//MEM�׶�
     .mem_sel(mem_sel),
     .clk(clk),
     .rst(rst),
     .Din_addr(data_addr),//�������ȡ���ݵĵ�ַ
     .Data_in(data_sram_rdata),//���������Dmem������
     .inst_field_in(inst_sram_rdata),//����Ķ�����ָ������
     .dmem_wen(dmem_wen),//���DMEM��дʹ���ź�
     .Data_out(data_out),//����Ĵ�д������
     .PC_out(PC)//�����ָ���ַ
  );

endmodule
