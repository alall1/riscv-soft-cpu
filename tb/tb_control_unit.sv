`timescale 1ns / 1ps

import cpu_defs_pkg::*;

module tb_control_unit;

    logic [6:0] opcode;
    logic RegWrite;
    logic ALUSrc;
    logic MemRead;
    logic MemWrite;
    logic MemtoReg;
    logic Branch;
    alu_op_t ALUOp;
    
    control_unit dut (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );
    
    initial begin
        opcode = 7'b0000000;    // default case
        
        #10;
        if (RegWrite !== 0) $error("default case RegWrite=%b expected=%b", RegWrite, 1'b0);
        if (ALUSrc !== 0) $error("default case ALUSrc=%b expected=%b", ALUSrc, 1'b0);
        if (MemRead !== 0) $error("default case MemRead=%b expected=%b", MemRead, 1'b0);
        if (MemWrite !== 0) $error("default case MemWrite=%b expected=%b", MemWrite, 1'b0);
        if (MemtoReg !== 0) $error("default case MemtoReg=%b expected=%b", MemtoReg, 1'b0);
        if (Branch !== 0) $error("default case Branch=%b expected=%b", Branch, 1'b0);
        if (ALUOp !== ALUOP_ADD) $error("default case ALUOp=%b expected=%b", ALUOp, ALUOP_ADD);
        
        opcode = OPCODE_RTYPE;  // R-Type
        
        #10;
        if (RegWrite !== 1) $error("R-Type RegWrite=%b expected=%b", RegWrite, 1'b1);
        if (ALUSrc !== 0) $error("R-Type ALUSrc=%b expected=%b", ALUSrc, 1'b0);
        if (MemRead !== 0) $error("R-Type MemRead=%b expected=%b", MemRead, 1'b0);
        if (MemWrite !== 0) $error("R-Type MemWrite=%b expected=%b", MemWrite, 1'b0);
        if (MemtoReg !== 0) $error("R-Type MemtoReg=%b expected=%b", MemtoReg, 1'b0);
        if (Branch !== 0) $error("R-Type Branch=%b expected=%b", Branch, 1'b0);
        if (ALUOp !== ALUOP_RTYPE) $error("R-Type ALUOp=%b expected=%b", ALUOp, ALUOP_RTYPE);
        
        opcode = OPCODE_ITYPE;  // I-Type (not loads)
        
        #10;
        if (RegWrite !== 1) $error("I-Type RegWrite=%b expected=%b", RegWrite, 1'b1);
        if (ALUSrc !== 1) $error("I-Type ALUSrc=%b expected=%b", ALUSrc, 1'b1);
        if (MemRead !== 0) $error("I-Type MemRead=%b expected=%b", MemRead, 1'b0);
        if (MemWrite !== 0) $error("I-Type MemWrite=%b expected=%b", MemWrite, 1'b0);
        if (MemtoReg !== 0) $error("I-Type MemtoReg=%b expected=%b", MemtoReg, 1'b0);
        if (Branch !== 0) $error("I-Type Branch=%b expected=%b", Branch, 1'b0);
        if (ALUOp !== ALUOP_ITYPE) $error("I-Type ALUOp=%b expected=%b", ALUOp, ALUOP_ITYPE);
        
        opcode = OPCODE_LOADS;  // I-Type loads
        
        #10;
        if (RegWrite !== 1) $error("I-Type(load) RegWrite=%b expected=%b", RegWrite, 1'b1);
        if (ALUSrc !== 1) $error("I-Type(load) ALUSrc=%b expected=%b", ALUSrc, 1'b1);
        if (MemRead !== 1) $error("I-Type(load) MemRead=%b expected=%b", MemRead, 1'b1);
        if (MemWrite !== 0) $error("I-Type(load) MemWrite=%b expected=%b", MemWrite, 1'b0);
        if (MemtoReg !== 1) $error("I-Type(load) MemtoReg=%b expected=%b", MemtoReg, 1'b1);
        if (Branch !== 0) $error("I-Type(load) Branch=%b expected=%b", Branch, 1'b0);
        if (ALUOp !== ALUOP_LOADS) $error("I-Type(load) ALUOp=%b expected=%b", ALUOp, ALUOP_LOADS);
        
        opcode = OPCODE_STYPE;  // S-Type
        
        #10;
        if (RegWrite !== 0) $error("S-Type RegWrite=%b expected=%b", RegWrite, 1'b0);
        if (ALUSrc !== 1) $error("S-Type ALUSrc=%b expected=%b", ALUSrc, 1'b1);
        if (MemRead !== 0) $error("S-Type MemRead=%b expected=%b", MemRead, 1'b0);
        if (MemWrite !== 1) $error("S-Type MemWrite=%b expected=%b", MemWrite, 1'b1);
        if (MemtoReg !== 0) $error("S-Type MemtoReg=%b expected=%b", MemtoReg, 1'b0);
        if (Branch !== 0) $error("S-Type Branch=%b expected=%b", Branch, 1'b0);
        if (ALUOp !== ALUOP_STYPE) $error("S-Type ALUOp=%b expected=%b", ALUOp, ALUOP_STYPE);
        
        opcode = OPCODE_BTYPE;  // B-Type
        
        #10;
        if (RegWrite !== 0) $error("B-Type RegWrite=%b expected=%b", RegWrite, 1'b0);
        if (ALUSrc !== 0) $error("B-Type ALUSrc=%b expected=%b", ALUSrc, 1'b0);
        if (MemRead !== 0) $error("B-Type MemRead=%b expected=%b", MemRead, 1'b0);
        if (MemWrite !== 0) $error("B-Type MemWrite=%b expected=%b", MemWrite, 1'b0);
        if (MemtoReg !== 0) $error("B-Type MemtoReg=%b expected=%b", MemtoReg, 1'b0);
        if (Branch !== 1) $error("B-Type Branch=%b expected=%b", Branch, 1'b1);
        if (ALUOp !== ALUOP_BTYPE) $error("B-Type ALUOp=%b expected=%b", ALUOp, ALUOP_BTYPE);
        
        $display("control_unit testbench finished");
        $finish;
    end
    
endmodule