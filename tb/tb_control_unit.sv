`timescale 1ns / 1ps

import cpu_defs_pkg::*;

module tb_control_unit;

    logic [6:0] opcode;
    logic RegWrite;
    logic ALUSrc;
    alu_op_t ALUOp;
    
    control_unit dut (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp)
    );
    
    initial begin
        opcode = 7'b0000000;
        
        #10;
        if (RegWrite !== 0) $error("default case RegWrite=%b expected=%b", RegWrite, 1'b0);
        if (ALUSrc !== 0) $error("default case ALUSrc=%b expected=%b", RegWrite, 1'b0);
        if (ALUOp !== ALUOP_ADD) $error("default case ALUOp=%b expected=%b", ALUOp, ALUOP_ADD);
        
        opcode = OPCODE_RTYPE;  // R-Type
        
        #10;
        if (RegWrite !== 1) $error("R-Type RegWrite=%b expected=%b", RegWrite, 1'b1);
        if (ALUSrc !== 0) $error("R-Type ALUSrc=%b expected=%b", RegWrite, 1'b0);
        if (ALUOp !== ALUOP_RTYPE) $error("R-Type ALUOp=%b expected=%b", ALUOp, ALUOP_RTYPE);
        
        opcode = OPCODE_ITYPE;  // I-Type (not loads)
        
        #10;
        if (RegWrite !== 1) $error("R-Type RegWrite=%b expected=%b", RegWrite, 1'b1);
        if (ALUSrc !== 1) $error("R-Type ALUSrc=%b expected=%b", RegWrite, 1'b1);
        if (ALUOp !== ALUOP_ITYPE) $error("R-Type ALUOp=%b expected=%b", ALUOp, ALUOP_ITYPE);
        
        $display("control_unit testbench finished");
        $finish;
    end
    
endmodule