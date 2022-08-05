/*
 * Description:
 *   Some macro definations, contains
 *   1. opcode used in decoder
 *   2. some control signals outputed by decoder
 *   3. some other definations
 *   This file is included by almost all other files about CPU
 */

`define NOP_INST 32'h0

// opcode[31:26]
`define OP      6'b000000
`define ANDI    6'b001100
`define ORI     6'b001101
`define XORI    6'b001110
`define LUI     6'b001111
`define SLTI    6'b001010
`define SLTIU   6'b001011   
`define ADDI    6'b001000
`define ADDIU   6'b001001
`define MUL     6'b011100
`define J       6'b000010
`define JAL     6'b000011

//branch
`define BEQ     6'b000100
`define BNE     6'b000101
`define BGEZ    6'b000001
`define BGTZ    6'b000111
`define BLEZ    6'b000110
`define BLTZ    6'b000001

`define LB   6'b100000
`define LBU  6'b100100
`define LH   6'b100001
`define LHU  6'b100101
`define LW   6'b100011
`define LWL  6'b100010
`define LWR  6'b100110
`define SB   6'b101000
`define SH   6'b101001
`define SW   6'b101011
`define SWL  6'b101010
`define SWR  6'b101110
`define LL  6'b110000
`define SC  6'b111000

`define SYSCALL 6'b001100
`define BREAK 6'b001101
   
`define ERET 6'b011000

// R - funct6 5..0
`define OP_ADD   6'b100000
`define OP_ADDU  6'b100001
`define OP_SUB   6'b100010
`define OP_SUBU  6'b100011
`define OP_AND   6'b100100
`define OP_OR    6'b100101
`define OP_XOR   6'b100110
`define OP_NOR   6'b100111
`define OP_SLT   6'b101010
`define OP_SLTU  6'b101011
`define OP_SLL   6'b000000
`define OP_SRL   6'b000010
`define OP_SRA   6'b000011
`define OP_SLLV  6'b000100
`define OP_SRLV  6'b000110
`define OP_SRAV  6'b000111
`define OP_JR    6'b001000
`define OP_JALR  6'b001001
`define OP_MUL   6'b000010

`define OP_BGEZ    5'b00001
`define OP_BGEZAL  5'b10001
`define OP_BLTZ    5'b00000
`define OP_BLTZAL  5'b10000

// alu_ctrl
`define ALU_CTRL_BITS 4
`define ALU_ADDU `ALU_CTRL_BITS'd0
`define ALU_SUBU `ALU_CTRL_BITS'd1
`define ALU_SLL  `ALU_CTRL_BITS'd2
`define ALU_SLT  `ALU_CTRL_BITS'd3
`define ALU_MUL  `ALU_CTRL_BITS'd4
`define ALU_XOR  `ALU_CTRL_BITS'd5
`define ALU_SRL  `ALU_CTRL_BITS'd6
`define ALU_SRA  `ALU_CTRL_BITS'd7
`define ALU_OR   `ALU_CTRL_BITS'd8
`define ALU_AND  `ALU_CTRL_BITS'd9
`define ALU_ADD  `ALU_CTRL_BITS'd10

// cmp_ctrl
`define CMP_CTRL_BITS 3
`define CMP_EQ  `CMP_CTRL_BITS'd0
`define CMP_NE  `CMP_CTRL_BITS'd1
`define CMP_LT  `CMP_CTRL_BITS'd2
`define CMP_LTU `CMP_CTRL_BITS'd3
`define CMP_GE  `CMP_CTRL_BITS'd4
`define CMP_GEU `CMP_CTRL_BITS'd5
`define CMP_GT  `CMP_CTRL_BITS'd6

//mem_sel
`define mem_sel_LW 2'd0
`define mem_sel_LB 2'd1
`define mem_sel_SW 2'd2
`define mem_sel_SB 2'd3

//Ö¸Áî´æ´¢Æ÷
`define InstAddrBus 31:0 
`define InstBus 31:0 
`define InstMemNum 131071 
`define InstMemNumLog2 17 
//Êý¾Ý´æ´¢Æ÷
`define DataAddrBus 31:0 
`define DataBus 31:0 
`define DataMemNum 131071 
`define DataMemNumLog2 17 
`define ByteWidth 7:0 
//Í¨ÓÃ¼Ä´æÆ÷
`define RegAddrBus 4:0 
`define RegBus 31:0 
`define RegWidth 32 
`define DoubleRegWidth 64 
`define DoubleRegBus 63:0 
`define RegNum 32 
`define RegNumLog2 5 
`define NOPRegAddr 5'b00000 

//CP0¼Ä´æÆ÷µØÖ· 
`define CP0_REG_COUNT 5'b01001 //¿É¶ÁÐ´ 
`define CP0_REG_COMPARE 5'b01011 //¿É¶ÁÐ´ 
`define CP0_REG_STATUS 5'b01100 //¿É¶ÁÐ´ 
`define CP0_REG_CAUSE 5'b01101 //Ö»¶Á 
`define CP0_REG_EPC 5'b01110 //¿É¶ÁÐ´ 
`define CP0_REG_CONFIG 5'b10000 //Ö»¶Á 
`define CP0_REG_BADADDR 5'b01000 

`define DBG_Core_Outputs \
    output wire [31:0] dbg_pc, \
    output wire [31:0] dbg_inst, \
    output wire [31:0] dbg_IfId_pc, \
    output wire [31:0] dbg_IfId_inst, \
    output wire [4:0] dbg_IfId_rd, \
    output wire dbg_IfId_valid, \
    output wire [31:0] dbg_IdEx_pc, \
    output wire [31:0] dbg_IdEx_inst, \
    output wire dbg_IdEx_valid, \
    output wire [4:0] dbg_IdEx_rd, \
    output wire [4:0] dbg_IdEx_rs1, \
    output wire [4:0] dbg_IdEx_rs2, \
    output wire [31:0] dbg_IdEx_rs1_val, \
    output wire [31:0] dbg_IdEx_rs2_val, \
    output wire dbg_IdEx_reg_wen, \
    output wire dbg_IdEx_is_imm, \
    output wire [31:0] dbg_IdEx_imm, \
    output wire dbg_IdEx_mem_wen, \
    output wire dbg_IdEx_mem_ren, \
    output wire dbg_IdEx_is_branch, \
    output wire dbg_IdEx_is_jump,\
    output wire dbg_IdEx_is_jal, \
    output wire dbg_IdEx_is_jalr, \
    output wire [3:0] dbg_IdEx_alu_ctrl, \
    output wire [2:0] dbg_IdEx_cmp_ctrl, \
    output wire [31:0] dbg_ExMa_pc, \
    output wire [31:0] dbg_ExMa_inst, \
    output wire dbg_ExMa_valid, \
    output wire [4:0] dbg_ExMa_rd, \
    output wire dbg_ExMa_reg_wen, \
    output wire [31:0] dbg_ExMa_rs1_val, \
    output wire [31:0] dbg_ExMa_rs2_val, \
    output wire [31:0] dbg_ExMa_mem_w_data, \
    output wire [31:0] dbg_ExMa_alu_res, \
    output wire dbg_ExMa_mem_wen, \
    output wire dbg_ExMa_mem_ren, \
    output wire dbg_ExMa_is_jal, \
    output wire dbg_ExMa_is_jalr, \
    output wire [31:0] dbg_MaWb_pc, \
    output wire [31:0] dbg_MaWb_inst, \
    output wire dbg_MaWb_valid, \
    output wire [4:0] dbg_MaWb_rd, \
    output wire dbg_MaWb_reg_wen, \
    output wire [31:0] dbg_MaWb_reg_w_data, \
    output wire [31:0] dbg_x0, \
    output wire [31:0] dbg_at, \
    output wire [31:0] dbg_v0, \
    output wire [31:0] dbg_v1, \
    output wire [31:0] dbg_a0, \
    output wire [31:0] dbg_a1, \
    output wire [31:0] dbg_a2, \
    output wire [31:0] dbg_a3, \
    output wire [31:0] dbg_t0, \
    output wire [31:0] dbg_t1, \
    output wire [31:0] dbg_t2, \
    output wire [31:0] dbg_t3, \
    output wire [31:0] dbg_t4, \
    output wire [31:0] dbg_t5, \
    output wire [31:0] dbg_t6, \
    output wire [31:0] dbg_t7, \
    output wire [31:0] dbg_s0, \
    output wire [31:0] dbg_s1, \
    output wire [31:0] dbg_s2, \
    output wire [31:0] dbg_s3, \
    output wire [31:0] dbg_s4, \
    output wire [31:0] dbg_s5, \
    output wire [31:0] dbg_s6, \
    output wire [31:0] dbg_s7, \
    output wire [31:0] dbg_t8, \
    output wire [31:0] dbg_t9, \
    output wire [31:0] dbg_s8, \
    output wire [31:0] dbg_s9, \
    output wire [31:0] dbg_gp, \
    output wire [31:0] dbg_sp, \
    output wire [31:0] dbg_fp, \
    output wire [31:0] dbg_ra,

`define DBG_Core_Assignments \
    assign dbg_pc = pre_pc; \
    assign dbg_inst = inst_field; \
    assign dbg_IfId_pc = IFID_pc; \
    assign dbg_IfId_inst = IFID_inst; \
    assign dbg_IfId_valid = IFIDWen; \
    assign dbg_IfId_rd = rd; \
    assign dbg_IdEx_pc = IDEX_pc; \
    assign dbg_IdEx_inst = IDEX_inst; \
    assign dbg_IdEx_valid = IDEX_valid; \
    assign dbg_IdEx_rd = IDEX_rd; \
    assign dbg_IdEx_rs1 = IDEX_inst[25:21]; \
    assign dbg_IdEx_rs2 = IDEX_inst[20:16]; \
    assign dbg_IdEx_rs1_val = IDEX_rs1_val; \
    assign dbg_IdEx_rs2_val = IDEX_rs2_val; \
    assign dbg_IdEx_reg_wen = IDEX_WB; \
    assign dbg_IdEx_is_imm = ALUSrc_B; \
    assign dbg_IdEx_imm = IDEX_Imm; \
    assign dbg_IdEx_mem_wen = IDEX_MemRW[0]; \
    assign dbg_IdEx_mem_ren = IDEX_MemRW[1]; \
    assign dbg_IdEx_is_branch = IDEX_branch; \
    assign dbg_IdEx_is_jump = res_comp;\
    assign dbg_IdEx_is_jal = IDEX_isjl; \
    assign dbg_IdEx_is_jalr = IDEX_isjr; \
    assign dbg_IdEx_alu_ctrl = IDEX_Aluop; \
    assign dbg_IdEx_cmp_ctrl = IDEX_Comop; \
    assign dbg_ExMa_pc = EXpreMEM_pc; \
    assign dbg_ExMa_inst = EXpreMEM_inst; \
    assign dbg_ExMa_valid = EXpreMEM_valid; \
    assign dbg_ExMa_rd = EXpreMEM_rd; \
    assign dbg_ExMa_reg_wen = EXpreMEM_WB; \
    assign dbg_ExMa_mem_w_data = EXpreMEM_rs2; \
    assign dbg_ExMa_alu_res = EXpreMEM_Alu; \
    assign dbg_ExMa_mem_wen = EXpreMEM_MemRW[0]; \
    assign dbg_ExMa_mem_ren = EXpreMEM_MemRW[1]; \
    assign dbg_ExMa_rs1_val = Alu_rs1;\
    assign dbg_ExMa_rs2_val = Alu_rs2;\
    assign dbg_ExMa_is_jal = 0; \
    assign dbg_ExMa_is_jalr = 0; \
    assign dbg_MaWb_pc = MEMWB_pc; \
    assign dbg_MaWb_inst = MEMWB_inst; \
    assign dbg_MaWb_valid = MEMWB_valid; \
    assign dbg_MaWb_rd = MEMWB_rd; \
    assign dbg_MaWb_reg_wen = MEMWB_WB; \
    assign dbg_MaWb_reg_w_data = rd_val;

`define DBG_Core_Declaration \
    wire [31:0] dbg_pc; \
    wire [31:0] dbg_inst; \
    wire [31:0] dbg_IfId_pc; \
    wire [31:0] dbg_IfId_inst; \
    wire [4:0]dbg_IfId_rd;\
    wire dbg_IfId_valid; \
    wire [31:0] dbg_IdEx_pc; \
    wire [31:0] dbg_IdEx_inst; \
    wire dbg_IdEx_valid; \
    wire [4:0] dbg_IdEx_rd; \
    wire [4:0] dbg_IdEx_rs1; \
    wire [4:0] dbg_IdEx_rs2; \
    wire [31:0] dbg_IdEx_rs1_val; \
    wire [31:0] dbg_IdEx_rs2_val; \
    wire dbg_IdEx_reg_wen; \
    wire dbg_IdEx_is_imm; \
    wire [31:0] dbg_IdEx_imm; \
    wire dbg_IdEx_mem_wen; \
    wire dbg_IdEx_mem_ren; \
    wire dbg_IdEx_is_branch; \
    wire dbg_IdEx_is_jump; \
    wire dbg_IdEx_is_jal; \
    wire dbg_IdEx_is_jalr; \
    wire [3:0] dbg_IdEx_alu_ctrl; \
    wire [2:0] dbg_IdEx_cmp_ctrl; \
    wire [31:0] dbg_ExMa_pc; \
    wire [31:0] dbg_ExMa_inst; \
    wire dbg_ExMa_valid; \
    wire [4:0] dbg_ExMa_rd; \
    wire dbg_ExMa_reg_wen; \
    wire [31:0] dbg_ExMa_mem_w_data; \
    wire [31:0] dbg_ExMa_alu_res; \
    wire [31:0] dbg_ExMa_rs1_val;\
    wire [31:0] dbg_ExMa_rs2_val;\
    wire dbg_ExMa_mem_wen; \
    wire dbg_ExMa_mem_ren; \
    wire dbg_ExMa_is_jal; \
    wire dbg_ExMa_is_jalr; \
    wire [31:0] dbg_MaWb_pc; \
    wire [31:0] dbg_MaWb_inst; \
    wire dbg_MaWb_valid; \
    wire [4:0] dbg_MaWb_rd; \
    wire dbg_MaWb_reg_wen; \
    wire [31:0] dbg_MaWb_reg_w_data;

`define DBG_Core_Arguments \
    .dbg_pc(dbg_pc), \
    .dbg_inst(dbg_inst), \
    .dbg_IfId_pc(dbg_IfId_pc), \
    .dbg_IfId_inst(dbg_IfId_inst), \
    .dbg_IfId_valid(dbg_IfId_valid), \
    .dbg_IfId_rd(dbg_IfId_rd),\
    .dbg_IdEx_pc(dbg_IdEx_pc), \
    .dbg_IdEx_inst(dbg_IdEx_inst), \
    .dbg_IdEx_valid(dbg_IdEx_valid), \
    .dbg_IdEx_rd(dbg_IdEx_rd), \
    .dbg_IdEx_rs1(dbg_IdEx_rs1), \
    .dbg_IdEx_rs2(dbg_IdEx_rs2), \
    .dbg_IdEx_rs1_val(dbg_IdEx_rs1_val), \
    .dbg_IdEx_rs2_val(dbg_IdEx_rs2_val), \
    .dbg_IdEx_reg_wen(dbg_IdEx_reg_wen), \
    .dbg_IdEx_is_imm(dbg_IdEx_is_imm), \
    .dbg_IdEx_imm(dbg_IdEx_imm), \
    .dbg_IdEx_mem_wen(dbg_IdEx_mem_wen), \
    .dbg_IdEx_mem_ren(dbg_IdEx_mem_ren), \
    .dbg_IdEx_is_branch(dbg_IdEx_is_branch), \
    .dbg_IdEx_is_jump(dbg_IdEx_is_jump),\
    .dbg_IdEx_is_jal(dbg_IdEx_is_jal), \
    .dbg_IdEx_is_jalr(dbg_IdEx_is_jalr), \
    .dbg_IdEx_alu_ctrl(dbg_IdEx_alu_ctrl), \
    .dbg_IdEx_cmp_ctrl(dbg_IdEx_cmp_ctrl), \
    .dbg_ExMa_pc(dbg_ExMa_pc), \
    .dbg_ExMa_inst(dbg_ExMa_inst), \
    .dbg_ExMa_valid(dbg_ExMa_valid), \
    .dbg_ExMa_rd(dbg_ExMa_rd), \
    .dbg_ExMa_reg_wen(dbg_ExMa_reg_wen), \
    .dbg_ExMa_mem_w_data(dbg_ExMa_mem_w_data), \
    .dbg_ExMa_alu_res(dbg_ExMa_alu_res), \
    .dbg_ExMa_rs1_val(dbg_ExMa_rs1_val),\
    .dbg_ExMa_rs2_val(dbg_ExMa_rs2_val),\
    .dbg_ExMa_mem_wen(dbg_ExMa_mem_wen), \
    .dbg_ExMa_mem_ren(dbg_ExMa_mem_ren), \
    .dbg_ExMa_is_jal(dbg_ExMa_is_jal), \
    .dbg_ExMa_is_jalr(dbg_ExMa_is_jalr), \
    .dbg_MaWb_pc(dbg_MaWb_pc), \
    .dbg_MaWb_inst(dbg_MaWb_inst), \
    .dbg_MaWb_valid(dbg_MaWb_valid), \
    .dbg_MaWb_rd(dbg_MaWb_rd), \
    .dbg_MaWb_reg_wen(dbg_MaWb_reg_wen), \
    .dbg_MaWb_reg_w_data(dbg_MaWb_reg_w_data), \
    .dbg_x0(dbg_x0), \
    .dbg_at(dbg_at), \
    .dbg_v0(dbg_v0), \
    .dbg_v1(dbg_v1), \
    .dbg_a0(dbg_a0), \
    .dbg_a1(dbg_a1), \
    .dbg_a2(dbg_a2), \
    .dbg_a3(dbg_a3), \
    .dbg_t0(dbg_t0), \
    .dbg_t1(dbg_t1), \
    .dbg_t2(dbg_t2), \
    .dbg_t3(dbg_t3), \
    .dbg_t4(dbg_t4), \
    .dbg_t5(dbg_t5), \
    .dbg_t6(dbg_t6), \
    .dbg_t7(dbg_t7), \
    .dbg_s0(dbg_s0), \
    .dbg_s1(dbg_s1), \
    .dbg_s2(dbg_s2), \
    .dbg_s3(dbg_s3), \
    .dbg_s4(dbg_s4), \
    .dbg_s5(dbg_s5), \
    .dbg_s6(dbg_s6), \
    .dbg_s7(dbg_s7), \
    .dbg_t8(dbg_t8), \
    .dbg_t9(dbg_t9), \
    .dbg_s8(dbg_s8), \
    .dbg_s9(dbg_s9), \
    .dbg_gp(dbg_gp), \
    .dbg_sp(dbg_sp), \
    .dbg_fp(dbg_fp), \
    .dbg_ra(dbg_ra),

`define DBG_RegFile_Outputs \
    output wire [31:0] dbg_x0, \
    output wire [31:0] dbg_at, \
    output wire [31:0] dbg_v0, \
    output wire [31:0] dbg_v1, \
    output wire [31:0] dbg_a0, \
    output wire [31:0] dbg_a1, \
    output wire [31:0] dbg_a2, \
    output wire [31:0] dbg_a3, \
    output wire [31:0] dbg_t0, \
    output wire [31:0] dbg_t1, \
    output wire [31:0] dbg_t2, \
    output wire [31:0] dbg_t3, \
    output wire [31:0] dbg_t4, \
    output wire [31:0] dbg_t5, \
    output wire [31:0] dbg_t6, \
    output wire [31:0] dbg_t7, \
    output wire [31:0] dbg_s0, \
    output wire [31:0] dbg_s1, \
    output wire [31:0] dbg_s2, \
    output wire [31:0] dbg_s3, \
    output wire [31:0] dbg_s4, \
    output wire [31:0] dbg_s5, \
    output wire [31:0] dbg_s6, \
    output wire [31:0] dbg_s7, \
    output wire [31:0] dbg_t8, \
    output wire [31:0] dbg_t9, \
    output wire [31:0] dbg_s8, \
    output wire [31:0] dbg_s9, \
    output wire [31:0] dbg_gp, \
    output wire [31:0] dbg_sp, \
    output wire [31:0] dbg_fp, \
    output wire [31:0] dbg_ra,

`define DBG_RegFile_Assignments \
    assign dbg_x0 = regs[0]; \
    assign dbg_at = regs[1]; \
    assign dbg_v0 = regs[2]; \
    assign dbg_v1 = regs[3]; \
    assign dbg_a0 = regs[4]; \
    assign dbg_a1 = regs[5]; \
    assign dbg_a2 = regs[6]; \
    assign dbg_a3 = regs[7]; \
    assign dbg_t0 = regs[8]; \
    assign dbg_t1 = regs[9]; \
    assign dbg_t2 = regs[10]; \
    assign dbg_t3 = regs[11]; \
    assign dbg_t4 = regs[12]; \
    assign dbg_t5 = regs[13]; \
    assign dbg_t6 = regs[14]; \
    assign dbg_t7 = regs[15]; \
    assign dbg_s0 = regs[16]; \
    assign dbg_s1 = regs[17]; \
    assign dbg_s2 = regs[18]; \
    assign dbg_s3 = regs[19]; \
    assign dbg_s4 = regs[20]; \
    assign dbg_s5 = regs[21]; \
    assign dbg_s6 = regs[22]; \
    assign dbg_s7 = regs[23]; \
    assign dbg_t8 = regs[24]; \
    assign dbg_t9 = regs[25]; \
    assign dbg_s8 = regs[26]; \
    assign dbg_s9 = regs[27]; \
    assign dbg_gp = regs[28]; \
    assign dbg_sp = regs[29]; \
    assign dbg_fp = regs[30]; \
    assign dbg_ra = regs[31];

`define DBG_RegFile_Declaration \
    wire [31:0] dbg_x0; \
    wire [31:0] dbg_at; \
    wire [31:0] dbg_v0; \
    wire [31:0] dbg_v1; \
    wire [31:0] dbg_a0; \
    wire [31:0] dbg_a1; \
    wire [31:0] dbg_a2; \
    wire [31:0] dbg_a3; \
    wire [31:0] dbg_t0; \
    wire [31:0] dbg_t1; \
    wire [31:0] dbg_t2; \
    wire [31:0] dbg_t3; \
    wire [31:0] dbg_t4; \
    wire [31:0] dbg_t5; \
    wire [31:0] dbg_t6; \
    wire [31:0] dbg_t7; \
    wire [31:0] dbg_s0; \
    wire [31:0] dbg_s1; \
    wire [31:0] dbg_s2; \
    wire [31:0] dbg_s3; \
    wire [31:0] dbg_s4; \
    wire [31:0] dbg_s5; \
    wire [31:0] dbg_s6; \
    wire [31:0] dbg_s7; \
    wire [31:0] dbg_t8; \
    wire [31:0] dbg_t9; \
    wire [31:0] dbg_s8; \
    wire [31:0] dbg_s9; \
    wire [31:0] dbg_gp; \
    wire [31:0] dbg_sp; \
    wire [31:0] dbg_fp; \
    wire [31:0] dbg_ra;

`define DBG_RegFile_Arguments \
    .dbg_x0(dbg_x0), \
    .dbg_at(dbg_at), \
    .dbg_v0(dbg_v0), \
    .dbg_v1(dbg_v1), \
    .dbg_a0(dbg_a0), \
    .dbg_a1(dbg_a1), \
    .dbg_a2(dbg_a2), \
    .dbg_a3(dbg_a3), \
    .dbg_t0(dbg_t0), \
    .dbg_t1(dbg_t1), \
    .dbg_t2(dbg_t2), \
    .dbg_t3(dbg_t3), \
    .dbg_t4(dbg_t4), \
    .dbg_t5(dbg_t5), \
    .dbg_t6(dbg_t6), \
    .dbg_t7(dbg_t7), \
    .dbg_s0(dbg_s0), \
    .dbg_s1(dbg_s1), \
    .dbg_s2(dbg_s2), \
    .dbg_s3(dbg_s3), \
    .dbg_s4(dbg_s4), \
    .dbg_s5(dbg_s5), \
    .dbg_s6(dbg_s6), \
    .dbg_s7(dbg_s7), \
    .dbg_t8(dbg_t8), \
    .dbg_t9(dbg_t9), \
    .dbg_s8(dbg_s8), \
    .dbg_s9(dbg_s9), \
    .dbg_gp(dbg_gp), \
    .dbg_sp(dbg_sp), \
    .dbg_fp(dbg_fp), \
    .dbg_ra(dbg_ra),

