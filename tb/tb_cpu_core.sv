`timescale 1ns / 1ps

import cpu_defs_pkg::*;

module tb_cpu_core;

    logic clk;
    logic reset;
    logic [31:0] debug_pc;
    logic [31:0] debug_instr;
    logic [31:0] debug_alu;
    logic [31:0] debug_imm;
    
    cpu_core core (
        .clk(clk),
        .reset(reset),
        .debug_pc(debug_pc),
        .debug_instr(debug_instr),
        .debug_alu(debug_alu),
        .debug_imm(debug_imm)
    );
    
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end
    
    initial begin
        reset = 1'b1;

        #1;
        core.instr_mem.mem[0] = 32'h002081B3; // 1. add x3, x1, x2
        core.instr_mem.mem[1] = 32'h40208233; // 2. sub x4, x1, x2
        core.instr_mem.mem[2] = 32'hffe08293; // 3. addi x5, x1, -2
        

        @(posedge clk);     // first posedge clk, reset is high for 1ns before instructions are executed (instr 1)
        #1;
        reset = 1'b0;

        core.register_file.registers[1] = 32'd10;
        core.register_file.registers[2] = 32'd7;

        @(posedge clk);     // second posedge clk, pc_current = 4 (instr 2)
        #1;

        if (core.register_file.registers[3] !== 32'd17) begin
            $error("ADD failed: x3=%h expected=%h", core.register_file.registers[3], 32'd17);
        end
        
        @(posedge clk);     // third posedge clk, pc_current = 8 (instr 3)
        #1;

        if (core.register_file.registers[4] !== 32'd3) begin
            $error("SUB failed: x4=%h expected=%h", core.register_file.registers[4], 32'd3);
        end
        
        @(posedge clk);     // fourth posedge clk, pc_current = 12 (instr 4)
        #1;

        if (core.register_file.registers[5] !== 32'd8) begin
            $error("ADDI failed: x5=%h expected=%h", core.register_file.registers[5], 32'd8);
        end
        
        
        #9;
        $display("cpu_core testbench finished");
        $finish;
    end

endmodule
