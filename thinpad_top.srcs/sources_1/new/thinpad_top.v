`default_nettype none
//`include "Defines.vh"
module thinpad_top(
    input wire clk_50M,           
    input wire clk_11M0592,       

    input wire clock_btn,         
    input wire reset_btn,         

    input  wire[3:0]  touch_btn,  
    input  wire[31:0] dip_sw,     
    output wire[15:0] leds,       
    output wire[7:0]  dpy0,       
    output wire[7:0]  dpy1,       

    inout wire[31:0] base_ram_data,  
    output wire[19:0] base_ram_addr, 
    output wire[3:0] base_ram_be_n,  
    output wire base_ram_ce_n,       
    output wire base_ram_oe_n,      
    output wire base_ram_we_n,       

    inout wire[31:0] ext_ram_data,  
    output wire[19:0] ext_ram_addr, 
    output wire[3:0] ext_ram_be_n,  
    output wire ext_ram_ce_n,       
    output wire ext_ram_oe_n,       
    output wire ext_ram_we_n,       

    output wire txd,  
    input  wire rxd,  
    
//debug
//    `DBG_Core_Outputs
// output wire [31:0] debug_wb_pc,
// output wire [3:0] debug_wb_rf_wen,
// output wire [4:0] debug_wb_rf_wnum,
// output wire [31:0] debug_wb_rf_wdata,

    
    output wire [22:0]flash_a,      
    inout  wire [15:0]flash_d,      
    output wire flash_rp_n,         
    output wire flash_vpen,         
    output wire flash_ce_n,         
    output wire flash_oe_n,         
    output wire flash_we_n,         
    output wire flash_byte_n,       

    output wire[2:0] video_red,    
    output wire[2:0] video_green,  
    output wire[1:0] video_blue,   
    output wire video_hsync,      
    output wire video_vsync,      
    output wire video_clk,        
    output wire video_de           
);

// PLL��Ƶ
wire locked, clk_10M, clk_20M;
pll_example clock_gen 
 (
  // Clock in ports
  .clk_in1(clk_50M),  
  // Clock out ports
  .clk_out1(clk_10M), 
  .clk_out2(clk_20M), 
//   Status and control signals
  .reset(reset_btn), 
  .locked(locked)                   
 );

reg reset_of_clk10M;
always@(posedge clk_10M or negedge locked) begin
    if(~locked) reset_of_clk10M <= 1'b1;
    else        reset_of_clk10M <= 1'b0;
end


wire inst_sram_en; 
wire [3:0] inst_sram_wen; 
wire [31:0] inst_sram_addr;
wire [31:0] inst_sram_wdata;
wire [31:0] inst_sram_rdata;
              
wire data_sram_en; 
wire [3:0] data_sram_wen; 
wire [31:0] data_sram_addr;
wire [31:0] data_sram_wdata;
wire [31:0] data_sram_rdata;

myCPU mycpu(              
    .clk(clk_10M),
    .resetn(~reset_of_clk10M),
    .inst_sram_en(inst_sram_en),
    .inst_sram_wen(inst_sram_wen),
    .inst_sram_addr(inst_sram_addr),
    .inst_sram_wdata(inst_sram_wdata),
    .inst_sram_rdata(inst_sram_rdata),
    //debug
//    `DBG_Core_Arguments
//    .debug_wb_pc(debug_wb_pc),
//    .debug_wb_rf_wen(debug_wb_rf_wen),
//    .debug_wb_rf_wnum(debug_wb_rf_wnum),
//    .debug_wb_rf_wdata(debug_wb_rf_wdata),
    
    .debug_wb_pc(),                
    .debug_wb_rf_wen(),        
    .debug_wb_rf_wnum(),      
    .debug_wb_rf_wdata(),    
    .data_sram_en(data_sram_en),
    .data_sram_wen(data_sram_wen),
    .data_sram_addr(data_sram_addr),
    .data_sram_wdata(data_sram_wdata),
    .data_sram_rdata(data_sram_rdata)
);

reg [31:0] cpu_inst_rdata_r;  
reg [31:0] cpu_data_rdata_r;  

reg [31:0] base_ram_data_r;                    
reg [19:0] base_ram_addr_r;                             
reg [3:0] base_ram_be_n_r;                 
reg base_ram_ce_n_r;                                      
reg base_ram_oe_n_r;                                 
reg base_ram_we_n_r;                                     

reg [31:0] ext_ram_data_r;     
reg [19:0] ext_ram_addr_r;  
reg [3:0] ext_ram_be_n_r;   
reg ext_ram_ce_n_r;         
reg ext_ram_oe_n_r;         
reg ext_ram_we_n_r;         

reg sel_base_sram; 
reg sel_uart; 
reg sel_uart_flag; 

wire [31:0] uart_rdata;

wire [7:0] ext_uart_rx;
reg  [7:0] ext_uart_buffer, ext_uart_tx;
wire ext_uart_ready, ext_uart_busy;
wire already_read;
reg ext_uart_clear;
reg ext_uart_start;

assign base_ram_data = ~base_ram_we_n_r ? base_ram_data_r : 32'bz;
assign ext_ram_data = ~ext_ram_we_n_r ? ext_ram_data_r : 32'bz;

assign base_ram_addr = base_ram_addr_r; 
assign base_ram_be_n = base_ram_be_n_r;
assign base_ram_ce_n = base_ram_ce_n_r;
assign base_ram_oe_n = base_ram_oe_n_r;
assign base_ram_we_n = base_ram_we_n_r;

assign ext_ram_addr = ext_ram_addr_r;
assign ext_ram_be_n = ext_ram_be_n_r;
assign ext_ram_ce_n = ext_ram_ce_n_r;
assign ext_ram_oe_n = ext_ram_oe_n_r;
assign ext_ram_we_n = ext_ram_we_n_r;

assign already_read = ext_uart_ready & (sel_uart & (~sel_uart_flag));

always @ (*) begin
    if (reset_of_clk10M) begin
        cpu_inst_rdata_r <= 32'b0;
        cpu_data_rdata_r <= 32'b0;
    end
    else begin
        cpu_inst_rdata_r <= ~sel_base_sram ? 32'b0 : ~base_ram_oe_n_r ? base_ram_data : 32'b0;
        cpu_data_rdata_r <= sel_uart ? uart_rdata : sel_base_sram ? (~ext_ram_oe_n_r ? ext_ram_data : 32'b0) : (~base_ram_oe_n_r ? base_ram_data : 32'b0);
    end
end
assign inst_sram_rdata = cpu_inst_rdata_r;
assign data_sram_rdata = cpu_data_rdata_r;
assign uart_rdata = sel_uart_flag ? {30'b0,ext_uart_ready,~ext_uart_busy} : {24'b0,ext_uart_buffer};

always @ (posedge clk_10M) begin
    if (reset_of_clk10M) begin
        base_ram_addr_r <= 19'b0;
        base_ram_be_n_r <= 4'b0;
        base_ram_ce_n_r <= 1'b1;
        base_ram_oe_n_r <= 1'b1;
        base_ram_data_r <= 32'b0;

        ext_ram_addr_r <= 19'b0;
        ext_ram_be_n_r <= 4'b0;
        ext_ram_ce_n_r <= 1'b1;
        ext_ram_oe_n_r <= 1'b1;
        ext_ram_data_r <= 32'b0;

        base_ram_we_n_r <= 1'b1;
        ext_ram_we_n_r <= 1'b1;
        
        ext_uart_tx <= 0;
        ext_uart_start <= 0;
        
        sel_base_sram <= 1'b0;
        sel_uart <= 1'b0;
        sel_uart_flag <= 1'b0;
    end
    else if (data_sram_addr >= 32'h80000000 && data_sram_addr <= 32'h803fffff && data_sram_en) begin
        base_ram_addr_r <= data_sram_addr[21:2];                    
        base_ram_be_n_r <= (|data_sram_wen) ? ~data_sram_wen : 4'b0;
        base_ram_ce_n_r <= ~data_sram_en;                           
        base_ram_oe_n_r <= ~(data_sram_en & ~(|data_sram_wen));   
        base_ram_data_r <= data_sram_wdata;                         

        ext_ram_addr_r <= 19'b0;
        ext_ram_be_n_r <= 4'b0;
        ext_ram_ce_n_r <= 1'b1;
        ext_ram_oe_n_r <= 1'b1;
        ext_ram_data_r <= 32'b0;
        
        base_ram_we_n_r <= ~(data_sram_en & (|data_sram_wen));      
        ext_ram_we_n_r <= 1'b1;  

        ext_uart_tx <= 0;
        ext_uart_start <= 0;

        sel_base_sram <= 1'b0;
        sel_uart <= 1'b0;
        sel_uart_flag <= 1'b0;
    end
    else if (data_sram_addr >= 32'h80400000 && data_sram_addr <= 32'h807fffff && data_sram_en) begin       
        base_ram_addr_r <= inst_sram_addr[21:2];
        base_ram_be_n_r <= 4'b0;
        base_ram_ce_n_r <= ~inst_sram_en;
        base_ram_oe_n_r <= ~inst_sram_en ;
        base_ram_data_r <= inst_sram_wdata;
        
        ext_ram_addr_r <= data_sram_addr[21:2];
        ext_ram_be_n_r <= (|data_sram_wen) ? ~data_sram_wen : 4'b0;
        ext_ram_ce_n_r <= ~data_sram_en;
        ext_ram_oe_n_r <= ~(data_sram_en & ~(|data_sram_wen));
        ext_ram_data_r <= data_sram_wdata;

        base_ram_we_n_r <= 1'b1;
        ext_ram_we_n_r <= ~(data_sram_en & (|data_sram_wen)); 
        
        ext_uart_tx <= 0;
        ext_uart_start <= 0;

        sel_base_sram <= 1'b1;
        sel_uart <= 1'b0;
        sel_uart_flag <= 1'b0;
    end
    else if (data_sram_addr == 32'hBFD003FC && data_sram_en) begin // 
        base_ram_addr_r <= inst_sram_addr[21:2];
        base_ram_be_n_r <= 4'b0;
        base_ram_ce_n_r <= ~inst_sram_en;
        base_ram_oe_n_r <= ~inst_sram_en ;
        base_ram_data_r <= inst_sram_wdata;
      
        ext_ram_addr_r <= 19'b0;
        ext_ram_be_n_r <= 4'b0;
        ext_ram_ce_n_r <= 1'b1;
        ext_ram_oe_n_r <= 1'b1;
        ext_ram_data_r <= 32'b0;

        base_ram_we_n_r <= 1'b1;
        ext_ram_we_n_r <= 1'b1;
        
        ext_uart_tx <= 0;
        ext_uart_start <= 0;

        sel_base_sram <= 1'b1;
        sel_uart <= 1'b1;
        sel_uart_flag <= 1'b1;
    end
    else if (data_sram_addr == 32'hBFD003F8 && data_sram_en) begin        
        base_ram_addr_r <= inst_sram_addr[21:2];
        base_ram_be_n_r <= 4'b0;
        base_ram_ce_n_r <= ~inst_sram_en;
        base_ram_oe_n_r <= ~inst_sram_en ;
        base_ram_data_r <= inst_sram_wdata;
       
        ext_ram_addr_r <= 19'b0;
        ext_ram_be_n_r <= 4'b0;
        ext_ram_ce_n_r <= 1'b1;
        ext_ram_oe_n_r <= 1'b1;
        ext_ram_data_r <= 32'b0;

        base_ram_we_n_r <= 1'b1;
        ext_ram_we_n_r <= 1'b1;
        
        ext_uart_tx <= (|data_sram_wen)? data_sram_wdata[7:0]:0;
        ext_uart_start <= (|data_sram_wen)? 1'b1:0;

        sel_base_sram <= 1'b1;
        sel_uart <= 1'b1;
        sel_uart_flag <= 1'b0;
    end
    else begin        
        base_ram_addr_r <= inst_sram_addr[21:2];
        base_ram_be_n_r <= 4'b0;
        base_ram_ce_n_r <= ~inst_sram_en;
        base_ram_oe_n_r <= ~inst_sram_en ;
        base_ram_data_r <= inst_sram_wdata;
      
        ext_ram_addr_r <= 19'b0;
        ext_ram_be_n_r <= 4'b0;
        ext_ram_ce_n_r <= 1'b1;
        ext_ram_oe_n_r <= 1'b1;
        ext_ram_data_r <= 32'b0;

        base_ram_we_n_r <= 1'b1;
        ext_ram_we_n_r <= 1'b1;
        
        ext_uart_tx <= 0;
        ext_uart_start <= 0;

        sel_base_sram <= 1'b1;
        sel_uart <= 1'b0;
        sel_uart_flag <= 1'b0;
    end
end

async_receiver #(.ClkFrequency(25000000),.Baud(9600)) 
    ext_uart_r(
        .clk(clk_10M),                      
        .RxD(rxd),                          
        .RxD_data_ready(ext_uart_ready),  
        .RxD_clear(ext_uart_clear),       
        .RxD_data(ext_uart_rx)            
    );
async_transmitter #(.ClkFrequency(25000000),.Baud(9600)) 
    ext_uart_t(
        .clk(clk_10M),                
        .TxD(txd),                      
        .TxD_busy(ext_uart_busy),      
        .TxD_start(ext_uart_start),    
        .TxD_data(ext_uart_tx)        
    );

//uart read 
always @(posedge clk_10M) begin 
    if (reset_of_clk10M) begin
        ext_uart_buffer <= 8'b0;
    end
    else if(ext_uart_ready)begin
        ext_uart_buffer <= ext_uart_rx;
    end 
    else begin end
end

always @(negedge clk_10M) begin 
    if (reset_of_clk10M) begin
        ext_uart_clear <= 1'b1;
    end
    else if(already_read && ext_uart_clear == 0)begin
        ext_uart_clear <= 1'b1;
    end
    else begin
        ext_uart_clear <= 0;
    end
end



// wire[7:0] number;
// SEG7_LUT segL(.oSEG1(dpy0), .iDIG(number[3:0])); //dpy0�ǵ�λ�����
// SEG7_LUT segH(.oSEG1(dpy1), .iDIG(number[7:4])); //dpy1�Ǹ�λ�����
// reg [7:0] wdata_r;

// assign number = wdata_r;

//uart clear signal
//always @(negedge clk_10M)begin
//    if(reset_of_clk10M) begin
//        ext_uart_clear_r <= 0;
//    end
//    else begin
//        if(already_read && ext_uart_clear_r == 0)begin
//            ext_uart_clear_r <= 1'b1;
//        end
//        else if(ext_uart_clear_r == 1'b1)begin
//            ext_uart_clear_r <= 0;
//        end
//        else begin end
//    end
//end

//uart write
//always @(posedge clk_10M) begin 
//     if (reset_of_clk10M) begin
//        ext_uart_tx <= 0;
//        ext_uart_start <= 0;
//    end
//    else if((~ext_uart_busy) && data_sram_addr == 32'hBFD003F8 && (data_sram_en & (|data_sram_wen)))begin 
//        ext_uart_tx <= data_sram_wdata[7:0];
//        ext_uart_start <= 1'b1;
//    end 
//    else begin 
//        ext_uart_start <= 0;
//    end
//end

endmodule