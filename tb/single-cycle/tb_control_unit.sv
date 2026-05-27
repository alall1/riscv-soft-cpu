`timescale 1ns / 1ps

import cpu_defs_pkg::*;

module tb_control_unit;

    logic [6:0] opcode;
    logic RegWrite;
    logic ALUSrcA;
    logic ALUSrcB;
    logic MemRead;
    logic MemWrite;
    logic MemtoReg;
    logic Branch;
    logic JAL;
    logic JALR;
    logic JumpWrite;
    alu_op_t ALUOp;
    
    control_unit dut (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .Branch(Branch),
        .JAL(JAL),
        .JALR(JALR),
        .JumpWrite(JumpWrite),
        .ALUOp(ALUOp)
    );
    
    initial begin
        opcode = 7'b0000000;    // default case
        
        #10;
        if (RegWrite !== 0) $error("default case RegWrite=%b expected=%b", RegWrite, 1'b0);
        if (ALUSrcA !== 0) $error("default case ALUSrcA=%b expected=%b", ALUSrcA, 1'b0);
        if (ALUSrcB !== 0) $error("default case ALUSrcB=%b expected=%b", ALUSrcB, 1'b0);
        if (MemRead !== 0) $error("default case MemRead=%b expected=%b", MemRead, 1'b0);
        if (MemWrite !== 0) $error("default case MemWrite=%b expected=%b", MemWrite, 1'b0);
        if (MemtoReg !== 0) $error("default case MemtoReg=%b expected=%b", MemtoReg, 1'b0);
        if (Branch !== 0) $error("default case Branch=%b expected=%b", Branch, 1'b0);
        if (ALUOp !== ALUOP_ADD) $error("default case ALUOp=%b expected=%b", ALUOp, ALUOP_ADD);
        
        opcode = OPCODE_RTYPE;  // R-Type
        
        #10;
        if (RegWrite !== 1) $error("R-Type RegWrite=%b expected=%b", RegWrite, 1'b1);
        if (ALUSrcA !== 0) $error("R-Type ALUSrcA=%b expected=%b", ALUSrcA, 1'b0);
        if (ALUSrcB !== 0) $error("R-Type ALUSrcB=%b expected=%b", ALUSrcB, 1'b0);
        if (MemRead !== 0) $error("R-Type MemRead=%b expected=%b", MemRead, 1'b0);
        if (MemWrite !== 0) $error("R-Type MemWrite=%b expected=%b", MemWrite, 1'b0);
        if (MemtoReg !== 0) $error("R-Type MemtoReg=%b expected=%b", MemtoReg, 1'b0);
        if (Branch !== 0) $error("R-Type Branch=%b expected=%b", Branch, 1'b0);
        if (ALUOp !== ALUOP_RTYPE) $error("R-Type ALUOp=%b expected=%b", ALUOp, ALUOP_RTYPE);
        
        opcode = OPCODE_ITYPE;  // I-Type (not loads)
        
        #10;
        if (RegWrite !== 1) $error("I-Type RegWrite=%b expected=%b", RegWrite, 1'b1);
        if (ALUSrcA !== 1) $error("I-Type ALUSrcA=%b expected=%b", ALUSrcA, 1'b1);
        if (ALUSrcB !== 0) $error("I-Type ALUSrcB=%b expected=%b", ALUSrcB, 1'b0);
        if (MemRead !== 0) $error("I-Type MemRead=%b expected=%b", MemRead, 1'b0);
        if (MemWrite !== 0) $error("I-Type MemWrite=%b expected=%b", MemWrite, 1'b0);
        if (MemtoReg !== 0) $error("I-Type MemtoReg=%b expected=%b", MemtoReg, 1'b0);
        if (Branch !== 0) $error("I-Type Branch=%b expected=%b", Branch, 1'b0);
        if (ALUOp !== ALUOP_ITYPE) $error("I-Type ALUOp=%b expected=%b", ALUOp, ALUOP_ITYPE);
        
        opcode = OPCODE_LOADS;  // I-Type loads
        
        #10;
        if (RegWrite !== 1) $error("I-Type(load) RegWrite=%b expected=%b", RegWrite, 1'b1);
        if (ALUSrcA !== 1) $error("I-Type(load) ALUSrcA=%b expected=%b", ALUSrcA, 1'b1);
        if (ALUSrcB !== 0) $error("I-Type(load) ALUSrcB=%b expected=%b", ALUSrcB, 1'b0);
        if (MemRead !== 1) $error("I-Type(load) MemRead=%b expected=%b", MemRead, 1'b1);
        if (MemWrite !== 0) $error("I-Type(load) MemWrite=%b expected=%b", MemWrite, 1'b0);
        if (MemtoReg !== 1) $error("I-Type(load) MemtoReg=%b expected=%b", MemtoReg, 1'b1);
        if (Branch !== 0) $error("I-Type(load) Branch=%b expected=%b", Branch, 1'b0);
        if (ALUOp !== ALUOP_LOADS) $error("I-Type(load) ALUOp=%b expected=%b", ALUOp, ALUOP_LOADS);
        
        opcode = OPCODE_STYPE;  // S-Type
        
        #10;
        if (RegWrite !== 0) $error("S-Type RegWrite=%b expected=%b", RegWrite, 1'b0);
        if (ALUSrcA !== 1) $error("S-Type ALUSrcA=%b expected=%b", ALUSrcA, 1'b1);
        if (ALUSrcB !== 0) $error("S-Type ALUSrcB=%b expected=%b", ALUSrcB, 1'b0);
        if (MemRead !== 0) $error("S-Type MemRead=%b expected=%b", MemRead, 1'b0);
        if (MemWrite !== 1) $error("S-Type MemWrite=%b expected=%b", MemWrite, 1'b1);
        if (MemtoReg !== 0) $error("S-Type MemtoReg=%b expected=%b", MemtoReg, 1'b0);
        if (Branch !== 0) $error("S-Type Branch=%b expected=%b", Branch, 1'b0);
        if (ALUOp !== ALUOP_STYPE) $error("S-Type ALUOp=%b expected=%b", ALUOp, ALUOP_STYPE);
        
        opcode = OPCODE_BTYPE;  // B-Type
        
        #10;
        if (RegWrite !== 0) $error("B-Type RegWrite=%b expected=%b", RegWrite, 1'b0);
        if (ALUSrcA !== 0) $error("B-Type ALUSrcA=%b expected=%b", ALUSrcA, 1'b0);
        if (ALUSrcB !== 0) $error("B-Type ALUSrcB=%b expected=%b", ALUSrcB, 1'b0);
        if (MemRead !== 0) $error("B-Type MemRead=%b expected=%b", MemRead, 1'b0);
        if (MemWrite !== 0) $error("B-Type MemWrite=%b expected=%b", MemWrite, 1'b0);
        if (MemtoReg !== 0) $error("B-Type MemtoReg=%b expected=%b", MemtoReg, 1'b0);
        if (Branch !== 1) $error("B-Type Branch=%b expected=%b", Branch, 1'b1);
        if (ALUOp !== ALUOP_BTYPE) $error("B-Type ALUOp=%b expected=%b", ALUOp, ALUOP_BTYPE);
        
        opcode = OPCODE_JAL;  // JAL opcode
        
        #10;
        if (RegWrite !== 1) $error("JAL RegWrite=%b expected=%b", RegWrite, 1'b1);
        if (ALUSrcA !== 0) $error("JAL ALUSrcA=%b expected=%b", ALUSrcA, 1'b0);
        if (ALUSrcB !== 0) $error("JAL ALUSrcB=%b expected=%b", ALUSrcB, 1'b0);
        if (MemRead !== 0) $error("JAL MemRead=%b expected=%b", MemRead, 1'b0);
        if (MemWrite !== 0) $error("JAL MemWrite=%b expected=%b", MemWrite, 1'b0);
        if (MemtoReg !== 0) $error("JAL MemtoReg=%b expected=%b", MemtoReg, 1'b0);
        if (Branch !== 0) $error("JAL Branch=%b expected=%b", Branch, 1'b0);
        if (JAL !== 1) $error("JAL JAL=%b expected=%b", JAL, 1'b1);
        if (JumpWrite !== 1) $error("JAL JumpWrite=%b expected=%b", JumpWrite, 1'b1);
        if (ALUOp !== ALUOP_ADD) $error("JAL ALUOp=%b expected=%b", ALUOp, ALUOP_ADD);
        
        opcode = OPCODE_JALR;  // JALR opcode
        
        #10;
        if (RegWrite !== 1) $error("JALR RegWrite=%b expected=%b", RegWrite, 1'b1);
        if (ALUSrcA !== 1) $error("JALR ALUSrcA=%b expected=%b", ALUSrcA, 1'b1);
        if (ALUSrcB !== 0) $error("JALR ALUSrcB=%b expected=%b", ALUSrcB, 1'b0);
        if (MemRead !== 0) $error("JALR MemRead=%b expected=%b", MemRead, 1'b0);
        if (MemWrite !== 0) $error("JALR MemWrite=%b expected=%b", MemWrite, 1'b0);
        if (MemtoReg !== 0) $error("JALR MemtoReg=%b expected=%b", MemtoReg, 1'b0);
        if (Branch !== 0) $error("JALR Branch=%b expected=%b", Branch, 1'b0);
        if (JALR !== 1) $error("JALR Jump=%b expected=%b", JALR, 1'b1);
        if (JumpWrite !== 1) $error("JARL JumpWrite=%b expected=%b", JumpWrite, 1'b1);
        if (ALUOp !== ALUOP_JALR) $error("JALR ALUOp=%b expected=%b", ALUOp, ALUOP_JALR);
        
        opcode = OPCODE_LUI;  // LUI opcode
        
        #10;
        if (RegWrite !== 1) $error("LUI RegWrite=%b expected=%b", RegWrite, 1'b1);
        if (ALUSrcA !== 1) $error("LUI ALUSrcA=%b expected=%b", ALUSrcA, 1'b1);
        if (ALUSrcB !== 0) $error("LUI ALUSrcB=%b expected=%b", ALUSrcB, 1'b0);
        if (MemRead !== 0) $error("LUI MemRead=%b expected=%b", MemRead, 1'b0);
        if (MemWrite !== 0) $error("LUI MemWrite=%b expected=%b", MemWrite, 1'b0);
        if (MemtoReg !== 0) $error("LUI MemtoReg=%b expected=%b", MemtoReg, 1'b0);
        if (Branch !== 0) $error("LUI Branch=%b expected=%b", Branch, 1'b0);
        if (JALR !== 0) $error("LUI Jump=%b expected=%b", JALR, 1'b0);
        if (JumpWrite !== 0) $error("LUI JumpWrite=%b expected=%b", JumpWrite, 1'b0);
        if (ALUOp !== ALUOP_LUI) $error("LUI ALUOp=%b expected=%b", ALUOp, ALUOP_LUI);
        
        opcode = OPCODE_AUIPC;  // AUIPC opcode
        
        #10;
        if (RegWrite !== 1) $error("AUIPC RegWrite=%b expected=%b", RegWrite, 1'b1);
        if (ALUSrcA !== 1) $error("AUIPC ALUSrcA=%b expected=%b", ALUSrcA, 1'b1);
        if (ALUSrcB !== 1) $error("AUIPC ALUSrcB=%b expected=%b", ALUSrcB, 1'b1);
        if (MemRead !== 0) $error("AUIPC MemRead=%b expected=%b", MemRead, 1'b0);
        if (MemWrite !== 0) $error("AUIPC MemWrite=%b expected=%b", MemWrite, 1'b0);
        if (MemtoReg !== 0) $error("AUIPC MemtoReg=%b expected=%b", MemtoReg, 1'b0);
        if (Branch !== 0) $error("AUIPC Branch=%b expected=%b", Branch, 1'b0);
        if (JALR !== 0) $error("AUIPC Jump=%b expected=%b", JALR, 1'b0);
        if (JumpWrite !== 0) $error("AUIPC JumpWrite=%b expected=%b", JumpWrite, 1'b0);
        if (ALUOp !== ALUOP_ADD) $error("AUIPC ALUOp=%b expected=%b", ALUOp, ALUOP_ADD);
        
        $display("control_unit testbench finished");
        $finish;
    end
    
endmodule