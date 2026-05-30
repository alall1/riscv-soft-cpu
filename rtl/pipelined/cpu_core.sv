`timescale 1ns / 1ps

import cpu_defs_pkg::*;

module cpu_core #(
    parameter string PROGRAM_FILE = "program_file.mem"
)(
    input logic clk,
    input logic reset,
    output logic debug_halt
);

    // hazard unit signals
    logic if_id_flush;
    logic id_ex_flush;

    // IF stage input signals
    logic [31:0] ex_redirect_target;
    logic ex_redirect_taken;
    
    // IF/ID input signals
    logic [31:0] if_instr;
    logic [31:0] if_pc;
    logic [31:0] if_pc_plus_4;
    logic if_is_ebreak;
    
    // IF/ID output signals
    logic [31:0] id_instr;
    logic [31:0] id_pc;
    logic [31:0] id_pc_plus_4;
    logic id_is_ebreak;

    if_stage #(
        .PROGRAM_FILE(PROGRAM_FILE)
    ) fetch (
        .clk(clk),
        .reset(reset),
        .redirect_target(ex_redirect_target),
        .redirect_taken(ex_redirect_taken),
        .if_instr(if_instr),
        .if_pc(if_pc),
        .if_pc_plus_4(if_pc_plus_4),
        .if_is_ebreak(if_is_ebreak)
    );
    
    if_id_reg if_id_register (
        .clk(clk),
        .reset(reset),
        
        .if_id_flush(if_id_flush),
        
        .if_instr(if_instr),
        .if_pc(if_pc),
        .if_pc_plus_4(if_pc_plus_4),
        .if_is_ebreak(if_is_ebreak),
        
        .id_instr(id_instr),
        .id_pc(id_pc),
        .id_pc_plus_4(id_pc_plus_4),
        .id_is_ebreak(id_is_ebreak)
    );
    
    // ID stage input signals
    logic [31:0] wb_write_data;
    logic [4:0] wb_rd_addr;
    logic wb_RegWrite;
    
    // ID/EX input signals
    logic [31:0] id_rs1_data;
    logic [31:0] id_rs2_data;
    logic [4:0] id_rd_addr;
    logic [31:0] id_imm;
    
    logic id_RegWrite;
    logic id_ALUSrcA;
    logic id_ALUSrcB;
    logic id_MemRead;
    logic id_MemWrite;
    logic id_MemtoReg;
    logic id_Branch;
    logic id_JAL;
    logic id_JALR;
    logic id_JumpWrite;
    alu_ctrl_t id_ALUctrl;
    mem_op_t id_MemOp;
    
    // ID/EX output signals
    logic [31:0] ex_rs1_data;
    logic [31:0] ex_rs2_data;
    logic [4:0] ex_rd_addr;
    logic [31:0] ex_imm;
    logic [31:0] ex_pc;
    logic [31:0] ex_pc_plus_4;
    logic ex_is_ebreak;

    logic ex_RegWrite;
    logic ex_ALUSrcA;
    logic ex_ALUSrcB;
    logic ex_MemRead;
    logic ex_MemWrite;
    logic ex_MemtoReg;
    logic ex_Branch;
    logic ex_JAL;
    logic ex_JALR;
    logic ex_JumpWrite;
    alu_ctrl_t ex_ALUctrl;
    mem_op_t ex_MemOp;
    
    id_stage decode (
        .clk(clk),
        .reset(reset),
        .instr(id_instr),
        .wb_write_data(wb_write_data),
        .wb_rd_addr(wb_rd_addr),
        .wb_RegWrite(wb_RegWrite),
        .id_rs1_data(id_rs1_data),
        .id_rs2_data(id_rs2_data),
        .id_rd_addr(id_rd_addr),
        .id_imm(id_imm),
        .id_RegWrite(id_RegWrite),
        .id_ALUSrcA(id_ALUSrcA),
        .id_ALUSrcB(id_ALUSrcB),
        .id_MemRead(id_MemRead),
        .id_MemWrite(id_MemWrite),
        .id_MemtoReg(id_MemtoReg),
        .id_Branch(id_Branch),
        .id_JAL(id_JAL),
        .id_JALR(id_JALR),
        .id_JumpWrite(id_JumpWrite),
        .id_ALUctrl(id_ALUctrl),
        .id_MemOp(id_MemOp)
    );
    
    id_ex_reg id_ex_register (
        .clk(clk),
        .reset(reset),
        
        .id_ex_flush(id_ex_flush),
    
        .id_rs1_data(id_rs1_data),
        .id_rs2_data(id_rs2_data),
        .id_rd_addr(id_rd_addr),
        .id_imm(id_imm),
        .id_pc(id_pc),
        .id_pc_plus_4(id_pc_plus_4),
        .id_is_ebreak(id_is_ebreak),
    
        .ex_rs1_data(ex_rs1_data),
        .ex_rs2_data(ex_rs2_data),
        .ex_rd_addr(ex_rd_addr),
        .ex_imm(ex_imm),
        .ex_pc(ex_pc),
        .ex_pc_plus_4(ex_pc_plus_4),
        .ex_is_ebreak(ex_is_ebreak),
    
        .id_RegWrite(id_RegWrite),
        .id_ALUSrcA(id_ALUSrcA),
        .id_ALUSrcB(id_ALUSrcB),
        .id_MemRead(id_MemRead),
        .id_MemWrite(id_MemWrite),
        .id_MemtoReg(id_MemtoReg),
        .id_Branch(id_Branch),
        .id_JAL(id_JAL),
        .id_JALR(id_JALR),
        .id_JumpWrite(id_JumpWrite),
        .id_ALUctrl(id_ALUctrl),
        .id_MemOp(id_MemOp),
    
        .ex_RegWrite(ex_RegWrite),
        .ex_ALUSrcA(ex_ALUSrcA),
        .ex_ALUSrcB(ex_ALUSrcB),
        .ex_MemRead(ex_MemRead),
        .ex_MemWrite(ex_MemWrite),
        .ex_MemtoReg(ex_MemtoReg),
        .ex_Branch(ex_Branch),
        .ex_JAL(ex_JAL),
        .ex_JALR(ex_JALR),
        .ex_JumpWrite(ex_JumpWrite),
        .ex_ALUctrl(ex_ALUctrl),
        .ex_MemOp(ex_MemOp)
    );

    // EX/MEM input signals
    logic [31:0] ex_alu_result;
    
    // EX/MEM output signals
    logic [31:0] mem_alu_result;
    logic [31:0] mem_store_data;
    logic [31:0] mem_pc_plus_4;
    logic [4:0] mem_rd_addr;
    logic mem_is_ebreak;
    
    logic mem_RegWrite;
    logic mem_MemRead;
    logic mem_MemWrite;
    logic mem_MemtoReg;
    logic mem_JumpWrite;
    mem_op_t mem_MemOp;
    
    ex_stage execute (
        .rs1_data(ex_rs1_data),
        .rs2_data(ex_rs2_data),
        .imm(ex_imm),
        .pc(ex_pc),
        .ALUSrcA(ex_ALUSrcA),
        .ALUSrcB(ex_ALUSrcB),
        .ALUctrl(ex_ALUctrl),
        .Branch(ex_Branch),
        .JAL(ex_JAL),
        .JALR(ex_JALR),
        .ex_alu_result(ex_alu_result),
        .ex_redirect_target(ex_redirect_target),
        .ex_redirect_taken(ex_redirect_taken)
    );
    
    ex_mem_reg ex_mem_register (
        .clk(clk),
        .reset(reset),

        .ex_alu_result(ex_alu_result),
        .ex_store_data(ex_rs2_data),
        .ex_pc_plus_4(ex_pc_plus_4),
        .ex_rd_addr(ex_rd_addr),
        .ex_is_ebreak(ex_is_ebreak),
    
        .mem_alu_result(mem_alu_result),
        .mem_store_data(mem_store_data),
        .mem_pc_plus_4(mem_pc_plus_4),
        .mem_rd_addr(mem_rd_addr),
        .mem_is_ebreak(mem_is_ebreak),
    
        .ex_RegWrite(ex_RegWrite),
        .ex_MemRead(ex_MemRead),
        .ex_MemWrite(ex_MemWrite),
        .ex_MemtoReg(ex_MemtoReg),
        .ex_JumpWrite(ex_JumpWrite),
        .ex_MemOp(ex_MemOp),
    
        .mem_RegWrite(mem_RegWrite),
        .mem_MemRead(mem_MemRead),
        .mem_MemWrite(mem_MemWrite),
        .mem_MemtoReg(mem_MemtoReg),
        .mem_JumpWrite(mem_JumpWrite),
        .mem_MemOp(mem_MemOp)
    );
    
    // MEM/WB input signals
    logic [31:0] mem_read_data;
    
    // MEM/WB output signals
    logic [31:0] wb_alu_result;
    logic [31:0] wb_read_data;
    logic [31:0] wb_pc_plus_4;
    logic wb_is_ebreak;
    
    logic wb_MemtoReg;
    logic wb_JumpWrite;
    
    mem_stage memory_access (
        .clk(clk),
        .alu_result(mem_alu_result),
        .store_data(mem_store_data),
        .MemRead(mem_MemRead),
        .MemWrite(mem_MemWrite),
        .MemOp(mem_MemOp),
        .mem_read_data(mem_read_data)
    );
    
    mem_wb_reg mem_wb_register (
        .clk(clk),
        .reset(reset),
    
        .mem_alu_result(mem_alu_result),
        .mem_read_data(mem_read_data),
        .mem_pc_plus_4(mem_pc_plus_4),
        .mem_rd_addr(mem_rd_addr),
        .mem_is_ebreak(mem_is_ebreak),
    
        .wb_alu_result(wb_alu_result),
        .wb_read_data(wb_read_data),
        .wb_pc_plus_4(wb_pc_plus_4),
        .wb_rd_addr(wb_rd_addr),
        .wb_is_ebreak(wb_is_ebreak),
    
        .mem_RegWrite(mem_RegWrite),
        .mem_MemtoReg(mem_MemtoReg),
        .mem_JumpWrite(mem_JumpWrite),
    
        .wb_RegWrite(wb_RegWrite),
        .wb_MemtoReg(wb_MemtoReg),
        .wb_JumpWrite(wb_JumpWrite)
    );
    
    wb_stage writeback (
        .alu_result(wb_alu_result),
        .read_data(wb_read_data),
        .pc_plus_4(wb_pc_plus_4),
        .MemtoReg(wb_MemtoReg),
        .JumpWrite(wb_JumpWrite),
        .write_data(wb_write_data)
    );   
    
    hazard_unit h_unit (
        .redirect_taken(ex_redirect_taken),
        .if_id_flush(if_id_flush),
        .id_ex_flush(id_ex_flush)
    );
    
    assign debug_halt = wb_is_ebreak;
    
endmodule
