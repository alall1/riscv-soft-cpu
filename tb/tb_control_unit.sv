`timescale 1ns / 1ps

import cpu_defs_pkg::*;

module tb_control_unit;

    logic [6:0] opcode;
    logic RegWrite;
    alu_op_t ALUOp;
    
    control_unit dut (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp)
    );
    
    initial begin
        opcode = 7'b0000000;
        
        #10;
        if (RegWrite !== 0) $error("default case RegWrite=%b expected=%b", RegWrite, 1'b0);
        if (ALUOp !== ALUOP_ADD) $error("default case ALUOp=%b expected=%b", ALUOp, ALUOP_ADD);
        
        opcode = OPCODE_RTYPE;
        
        #10;
        if (RegWrite !== 1) $error("R-Type RegWrite=%b expected=%b", RegWrite, 1'b1);
        if (ALUOp !== ALUOP_RTYPE) $error("R-Type ALUOp=%b expected=%b", ALUOp, ALUOP_RTYPE);
        
        #10;
        
        $display("control_unit testbench finished");
        $finish;
    end
    
endmodule