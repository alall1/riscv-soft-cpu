`timescale 1ns / 1ps

import cpu_defs_pkg::*;

module tb_alu;

    alu_ctrl_t ALUctrl;
    logic [31:0] input_1;
    logic [31:0] input_2;
    logic [31:0] result;
    logic branch_cond;
    
    alu dut (
        .ALUctrl(ALUctrl),
        .input_1(input_1),
        .input_2(input_2),
        .result(result),
        .branch_cond(branch_cond)
    );
    
    initial begin
        input_1 = 32'h00000001;
        input_2 = 32'h00000003;
        
        // ADD
        ALUctrl = ALU_ADD;
        #10;
        if (result !== 32'h00000004) $error("ADD op error. result=%h expected=%h", result, 32'h00000004);
        
        // SUB
        ALUctrl = ALU_SUB;
        #10;
        if (result !== 32'hFFFFFFFE) $error("SUB op error. result=%h expected=%h", result, 32'hFFFFFFFE);
        
        // AND
        ALUctrl = ALU_AND;
        #10;
        if (result !== 32'h00000001) $error("AND op error. result=%h expected=%h", result, 32'h00000001);
        
        // OR
        ALUctrl = ALU_OR;
        #10;
        if (result !== 32'h00000003) $error("OR op error. result=%h expected=%h", result, 32'h00000003);
        
        // XOR
        ALUctrl = ALU_XOR;
        #10;
        if (result !== 32'h00000002) $error("XOR op error. result=%h expected=%h", result, 32'h00000002);
        
        // SLL
        ALUctrl = ALU_SLL;
        #10;
        if (result !== 32'h00000008) $error("SLL op error. result=%h expected=%h", result, 32'h00000008);
        
        // SRL
        input_1 = 32'hFFFFFF11;
        input_2 = 32'h00000002;
        ALUctrl = ALU_SRL;
        #10;
        if (result !== 32'h3FFFFFC4) $error("SRL op error. result=%h expected=%h", result, 32'h3FFFFFC4);
        
        // SRA
        ALUctrl = ALU_SRA;
        #10;
        if (result !== 32'hFFFFFFC4) $error("SRA op error. result=%h expected=%h", result, 32'hFFFFFFC4);
        
        // SLT
        input_1 = 32'h00000001;
        input_2 = 32'h00000003;
        ALUctrl = ALU_SLT;
        #10;
        if (result !== 32'h00000001) $error("SLT op error. result=%h expected=%h", result, 32'h00000001);
        input_1 = 32'hFFFFFFFE; // -2 in decimal (signed)
        #10;
        if (result !== 32'h00000001) $error("SLT op error. result=%h expected=%h", result, 32'h00000001);
  
        // SLTU
        ALUctrl = ALU_SLTU;
        #10;
        if (result !== 32'h00000000) $error("SLTU op error. result=%h expected=%h", result, 32'h00000000);
        
        ALUctrl = ALU_BEQ;
        input_1 = 32'hFFFFFFFE;     // signed: -2
        input_2 = 32'h00000001;
        #10;
        if (branch_cond !== 1'b0) $error("BEQ op error. branch_cond=%b expected=%b", branch_cond, 1'b0);
        
        ALUctrl = ALU_BNE;
        #10;
        if (branch_cond !== 1'b1) $error("BNE op error. branch_cond=%b expected=%b", branch_cond, 1'b1);
        
        ALUctrl = ALU_BLT;
        #10;
        if (branch_cond !== 1'b1) $error("BLT op error. branch_cond=%b expected=%b", branch_cond, 1'b1);
        
        ALUctrl = ALU_BGE;
        #10;
        if (branch_cond !== 1'b0) $error("BGE op error. branch_cond=%b expected=%b", branch_cond, 1'b0);
        
        ALUctrl = ALU_BLTU;
        #10;
        if (branch_cond !== 1'b0) $error("BLTU op error. branch_cond=%b expected=%b", branch_cond, 1'b0);
        
        ALUctrl = ALU_BGEU;
        #10;
        if (branch_cond !== 1'b1) $error("BGEU op error. branch_cond=%b expected=%b", branch_cond, 1'b1);
        
        $display("alu testbench finished");
        $finish;
    end
    
endmodule