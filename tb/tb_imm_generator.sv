`timescale 1ns / 1ps

import cpu_defs_pkg::*;

module tb_imm_generator;

    logic [31:0] instr;
    logic [31:0] imm;
    
    imm_generator dut (
        .instr(instr),
        .imm(imm)
    );
    
    initial begin
        instr = 32'h00000013;   // addi x0, x0, 0 -> imm = 0
        #10;
        if (imm !== 32'h00000000) $error("I-type error. imm=%h expected=%h", imm, 32'h00000000);
        
        instr = 32'h00500013;   // addi x0, x0, 5 -> imm = 5
        #10;
        if (imm !== 32'h00000005) $error("I-type error. imm=%h expected=%h", imm, 32'h00000005);
        
        instr = 32'hffe00013;   // addi x0, x0, 5 -> imm = -2
        #10;
        if (imm !== 32'hFFFFFFFE) $error("I-type error. imm=%h expected=%h", imm, 32'hFFFFFFFE);
        
        $display("imm_generator testbench finished");
        $finish;
    end

endmodule
