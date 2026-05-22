`timescale 1ns / 1ps

import cpu_defs_pkg::*;

module tb_alu_control;

    alu_op_t ALUOp;
    logic [6:0] funct7;
    logic [2:0] funct3;
    alu_ctrl_t ALUctrl;
    
    alu_control dut (
        .ALUOp(ALUOp),
        .funct7(funct7),
        .funct3(funct3),
        .ALUctrl(ALUctrl)
    );
    
    initial begin
        ALUOp = ALUOP_ADD;
        funct7 = 7'b0000000;
        funct3 = 3'd000;
        
        #10;
        if (ALUctrl !== ALU_ADD) begin
            $error("Default case failed. ALUctrl=%b expected=%b", ALUctrl, ALU_ADD);
        end
        
        ALUOp = ALUOP_RTYPE;    // R-type instructions
        funct7 = 7'b0000000;
        funct3 = 3'b000;
        
        #10;
        if (ALUctrl !== ALU_ADD) begin
            $error("ADD instruction failed. ALUctrl=%b expected=%b", ALUctrl, ALU_ADD);
        end
        
        funct7 = 7'b0100000;
        funct3 = 3'b000;
        
        #10;
        if (ALUctrl !== ALU_SUB) begin
            $error("SUB instruction failed. ALUctrl=%b expected=%b", ALUctrl, ALU_SUB);
        end
        
        ALUOp = ALUOP_ITYPE;    // I-type instructions (not loads)
        funct3 = 3'b000;
        
        #10;
        if (ALUctrl !== ALU_ADD) begin
            $error("ADDI instruction failed. ALUctrl=%b expected=%b", ALUctrl, ALU_ADD);
        end
        
        ALUOp = ALUOP_LOADS;    // I-type loads (always ALU_ADD)
        
        #10;
        if (ALUctrl !== ALU_ADD) begin
            $error("Load instruction failed. ALUctrl=%b expected=%b", ALUctrl, ALU_ADD);
        end
        
        ALUOp = ALUOP_STYPE;    // S-type instructions (always ALU_ADD)
        
        #10;
        if (ALUctrl !== ALU_ADD) begin
            $error("Store instruction failed. ALUctrl=%b expected=%b", ALUctrl, ALU_ADD);
        end
        
        ALUOp = ALUOP_BTYPE;    // B-type instructions
        funct3 = 3'b000;
        
        #10;
        if (ALUctrl !== ALU_BEQ) begin
            $error("BEQ instruction failed. ALUctrl=%b expected=%b", ALUctrl, ALU_BEQ);
        end
        
        funct3 = 3'b001;
        
        #10;
        if (ALUctrl !== ALU_BNE) begin
            $error("BNE instruction failed. ALUctrl=%b expected=%b", ALUctrl, ALU_BNE);
        end
        
        funct3 = 3'b100;
        
        #10;
        if (ALUctrl !== ALU_BLT) begin
            $error("BLT instruction failed. ALUctrl=%b expected=%b", ALUctrl, ALU_BLT);
        end
        
        funct3 = 3'b101;
        
        #10;
        if (ALUctrl !== ALU_BGE) begin
            $error("BGE instruction failed. ALUctrl=%b expected=%b", ALUctrl, ALU_BGE);
        end
        
        funct3 = 3'b110;
        
        #10;
        if (ALUctrl !== ALU_BLTU) begin
            $error("BLTU instruction failed. ALUctrl=%b expected=%b", ALUctrl, ALU_BLTU);
        end
        
        funct3 = 3'b111;
        
        #10;
        if (ALUctrl !== ALU_BGEU) begin
            $error("BGEU instruction failed. ALUctrl=%b expected=%b", ALUctrl, ALU_BGEU);
        end
        
        ALUOp = ALUOP_JALR;
        
        #10;
        if (ALUctrl !== ALU_ADD) begin
            $error("JALR instruction failed. ALUctrl=%b expected=%b", ALUctrl, ALU_ADD);
        end
        
        ALUOp = ALUOP_LUI;
        
        #10;
        if (ALUctrl !== ALU_LUI) begin
            $error("LUI instruction failed. ALUctrl=%b expected=%b", ALUctrl, ALU_LUI);
        end
        
        $display("alu_control testbench finished");
        $finish;
    end
    
endmodule