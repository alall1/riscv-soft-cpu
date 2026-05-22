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
        core.instr_mem.mem[0] = 32'h002081B3; // PC = 0 1. add x3, x1, x2
        core.instr_mem.mem[1] = 32'h40208233; // PC = 4 2. sub x4, x1, x2
        core.instr_mem.mem[2] = 32'hffe08293; // PC = 8 3. addi x5, x1, -2
        core.instr_mem.mem[3] = 32'h0002a103; // PC = 12 4. lw x2 0(x5)     -> loading mem[2] into x2
        core.instr_mem.mem[4] = 32'h00202223; // PC = 16 5. sw x2 4(x0)     -> storing x2 into mem[1]
        core.instr_mem.mem[5] = 32'h0041da63; // PC = 20 6. bge x3, x4, 20  -> branch to pc + 20 = 40
        core.instr_mem.mem[6] = 32'h00500113; // PC = 24 7. addi x2, x0, 5
        core.instr_mem.mem[7] = 32'h00008067; // PC = 28 8. jalr x0, 0(x1)  -> return to pc = 48
        // xxx
        core.instr_mem.mem[10] = 32'h00100313; // PC = 40 11. addi x6, x0, 1;
        core.instr_mem.mem[11] = 32'hfedff0ef; // PC = 44 12. jal x1, 16;   -> branch to pc - 20 = 24
        core.instr_mem.mem[12] = 32'h00510113; // PC = 48 13. addi x2, x2, 5
        core.instr_mem.mem[13] = 32'h123450b7; // PC = 52 14. lui x1, 74565
        core.instr_mem.mem[14] = 32'h12345117; // PC = 56 15. auipc x2, 74565


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
        
        @(posedge clk);     // eighth posedge clk, pc_current = 44 (instr 12)
        #1;
        
        if (core.register_file.registers[6] !== 32'h00000001) begin
            $error("BGE->ADDI failed: x6=%h expected=%h", core.register_file.registers[6], 32'h00000001);
        end
        
        @(posedge clk);     // ninth posedge clk, pc_current = 24 (instr 7)
        #1;
        
        if (core.register_file.registers[1] !== 32'h00000030) begin
            $error("JAL failed: x1=%h expected=%h", core.register_file.registers[1], 32'h00000030);
        end
        
        @(posedge clk);     // tenth posedge clk, pc_current = 28 (instr 8)
        #1;
        
        if (core.register_file.registers[1] !== 32'h00000030) begin
            $error("JAL failed: x1=%h expected=%h", core.register_file.registers[1], 32'h00000030);
        end
        
        @(posedge clk);     // eleventh posedge clk, pc_current = 48 (instr 13)
        #1;
        
        if (core.register_file.registers[2] !== 32'h00000005) begin
            $error("JAL->ADDI failed: x2=%h expected=%h", core.register_file.registers[2], 32'h00000005);
        end
        
        @(posedge clk);     // twelvth posedge clk, pc_current = 52 (instr 14)
        #1;
        
        if (core.register_file.registers[2] !== 32'h0000000A) begin
            $error("JALR->ADDI failed: x2=%h expected=%h", core.register_file.registers[2], 32'h0000000A);
        end
        
        @(posedge clk);     // thirteenth posedge clk, pc_current = 56 (instr 15)
        #1;
        
        if (core.register_file.registers[1] !== 32'h12345000) begin
            $error("LUI failed: x1=%h expected=%h", core.register_file.registers[1], 32'h1234500);
        end
        
        @(posedge clk);     // fifteenth posedge clk, pc_current = 60 (instr 16)
        #1;
        
        if (core.register_file.registers[2] !== 32'h12345038) begin
            $error("AUIPC failed: x2=%h expected=%h", core.register_file.registers[2], 32'h12345038);
        end
        
        #9;
        $display("cpu_core testbench finished");
        $finish;
    end

endmodule
