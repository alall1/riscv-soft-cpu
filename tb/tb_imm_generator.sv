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
        
        instr = 32'hFFE00013;   // addi x0, x0, 5 -> imm = -2
        #10;
        if (imm !== 32'hFFFFFFFE) $error("I-type error. imm=%h expected=%h", imm, 32'hFFFFFFFE);
        
        instr = 32'hFF802003;   // lw x0, -8(x0) -> imm = -8
        #10;
        if (imm !== 32'hFFFFFFF8) $error("Load instr error. imm=%h expected=%h", imm, 32'hFFFFFFF8);
        
        instr = 32'hFE002823;   // sw x0, -16(x0) -> imm = -16
        #10;
        if (imm !== 32'hFFFFFFF0) $error("Store instr error. imm=%h expected=%h", imm, 32'hFFFFFFF0);
        
        instr = 32'h00001463;   // bne x0, x0, 8 -> imm = 8
        #10;
        if (imm !== 32'h00000008) $error("B-type error. imm=%h expected=%h", imm, 32'h00000008);
       
        instr = 32'h0180006f;   // jal x0, 24 -> imm = 24
        #10;
        if (imm !== 32'h00000018) $error("JAL error. imm=%h expected=%h", imm, 32'h00000018);
        
        instr = 32'h01800067;   // jalr x0, 24(x0) -> imm = 24
        #10;
        if (imm !== 32'h00000018) $error("JALR error. imm=%h expected=%h", imm, 32'h00000018);
        
        $display("imm_generator testbench finished");
        $finish;
    end

endmodule
