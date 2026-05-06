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
        
        ALUOp = ALUOP_RTYPE;
        funct7 = 7'b0000000;
        funct3 = 3'b000;
        
        #10;
        if (ALUctrl !== ALU_ADD) begin
            $error("ADD instruction failed. ALUctrl=%b expected=%b", ALUctrl, ALU_ADD);
        end
        
        ALUOp = ALUOP_RTYPE;
        funct7 = 7'b0100000;
        funct3 = 3'b000;
        
        #10;
        if (ALUctrl !== ALU_SUB) begin
            $error("SUB instruction failed. ALUctrl=%b expected=%b", ALUctrl, ALU_ADD);
        end
        
        $display("alu_control testbench finished");
        $finish;
    end
    
endmodule