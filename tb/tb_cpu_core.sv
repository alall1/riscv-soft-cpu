`timescale 1ns / 1ps

import cpu_defs_pkg::*;

module tb_cpu_core;

    logic clk;
    logic reset;
    logic [31:0] debug_instr;
    logic [31:0] debug_alu;
    logic [31:0] debug_imm;
    logic [31:0] debug_writeback;
    logic [31:0] debug_pc_curr;
    logic [31:0] debug_pc_next;

    cpu_core core (
        .clk(clk),
        .reset(reset),
        .debug_instr(debug_instr),
        .debug_alu(debug_alu),
        .debug_imm(debug_imm),
        .debug_writeback(debug_writeback),
        .debug_pc_curr(debug_pc_curr),
        .debug_pc_next(debug_pc_next)
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
        core.instr_mem.mem[3] = 32'h0002a103; // 4. lw x2 0(x5)     -> loading mem[2] into x2
        core.instr_mem.mem[4] = 32'h00202223; // 5. sw x2 4(x0)     -> storing x2 into mem[1]
        core.instr_mem.mem[5] = 32'h0041da63; // 6. bge x3, x4, 20  -> branch to pc + 20 = 40
        // xxx
        core.instr_mem.mem[10] = 32'h00100313; // 11. addi x6, x0, 1;
        

        @(posedge clk);     // first posedge clk, reset is high for 1ns before instructions are executed (instr 1)
        #1;
        reset = 1'b0;

        // initial setup for registers + memory
        core.register_file.registers[1] = 32'd10;
        core.register_file.registers[2] = 32'd7;
        
        core.data_mem.mem[2] = 32'hFFFFFFF8;
        
        //////////////// R-TYPE ////////////////

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
        
        //////////////// I-TYPE ////////////////

        if (core.register_file.registers[5] !== 32'd8) begin
            $error("ADDI failed: x5=%h expected=%h", core.register_file.registers[5], 32'd8);
        end
        
        @(posedge clk);     // fifth posedge clk, pc_current = 16 (instr 5)
        #1;
        
        //////////////// LOADS ////////////////
        
        if (core.register_file.registers[2] !== 32'hFFFFFFF8) begin
            $error("LW failed: x2=%h expected=%h", core.register_file.registers[2], 32'hFFFFFFF8);
        end
        
        @(posedge clk);     // sixth posedge clk, pc_current = 20 (instr 6) --> branch to 40
        #1;
        
        //////////////// STORES ////////////////
        
        if (core.data_mem.mem[1] !== 32'hFFFFFFF8) begin
            $error("SW failed: mem[1]=%h expected=%h", core.data_mem.mem[1], 32'hFFFFFFF8);
        end
        
        @(posedge clk);     // seventh posedge clk, pc_current = 40 (instr 11)
        #1;
        
        //////////////// BRANCHES ////////////////
        
        if (core.pc_current !== 32'h00000028) begin
            $error("BGE failed: pc_curr=%h expected=%h", core.pc_current, 32'h00000028);
        end
        
        @(posedge clk);     // seventh posedge clk, pc_current = 40 (instr 11)
        #1;
        
        if (core.register_file.registers[6] !== 32'h00000001) begin
            $error("BGE->ADDI failed: x6=%h expected=%h", core.register_file.registers[6], 32'h00000001);
        end
        
        #9;
        $display("cpu_core testbench finished");
        $finish;
    end

endmodule
