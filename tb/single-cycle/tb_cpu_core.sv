`timescale 1ns / 1ps

import cpu_defs_pkg::*;

module tb_cpu_core;

    logic clk;
    logic reset;
    logic [31:0] debug_instr;
    logic [31:0] debug_alu;
    logic [31:0] debug_writeback;
    logic [31:0] debug_pc;
    logic [4:0] debug_rd;
    logic debug_halt;

    cpu_core #(
        .PROGRAM_FILE("checksum_test.mem")
    ) dut (
        .clk(clk),
        .reset(reset),
        .debug_instr(debug_instr),
        .debug_alu(debug_alu),
        .debug_writeback(debug_writeback),
        .debug_pc(debug_pc),
        .debug_rd(debug_rd),
        .debug_halt(debug_halt)
    );
    
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    
    logic trace_enable;
    
    task run_program;
        input int max_cycles;
        input bit enable_trace;
        int cycles;
        
        begin
            trace_enable = enable_trace;
            
            reset = 1'b1;
            repeat (2) @(posedge clk);
            reset = 0;
            
            cycles = 0;
            
            while (!debug_halt && cycles < max_cycles) begin
                @(posedge clk);
                cycles++;
            end
            
            trace_enable = 1'b0;
            
            if (cycles >= max_cycles) begin
                $fatal("FAIL: timeout");
            end
        end
    endtask
    
    task check_mem_byte;
        input int byte_addr;
        input logic [7:0] expected;
        
        begin
            if (dut.data_mem.mem[byte_addr] !== expected) begin
                $fatal("FAIL: mem[%0d]=%h expected=%h", byte_addr, dut.data_mem.mem[byte_addr], expected);
            end
        end
    endtask
    
    task check_mem_word;    // addresses should be in multiples of 4 for check_mem_word
        input int byte_addr;
        input logic [31:0] expected;
        
        logic [31:0] word;
        
        begin
            assign word = {dut.data_mem.mem[byte_addr+3], dut.data_mem.mem[byte_addr+2], dut.data_mem.mem[byte_addr+1], dut.data_mem.mem[byte_addr]};
            if (word !== expected) begin
                $fatal("FAIL: mem[%0d]=%h expected=%h", byte_addr, word, expected);
            end
        end
    endtask

    initial begin
        trace_enable = 1'b0;
        run_program(100, 1'b1);
        
        check_mem_word(124, 32'h00000003);  // count
        check_mem_word(128, 32'hffffff82);  // checksum
        check_mem_word(132, 32'h00000003);  // copied count

        $display("PASS");
        $finish;
    end
    
    always @(posedge clk) begin
        #1;
        if (trace_enable) begin
            $display("PC=%h INSTR=%h RD=%0d WB=%h",
                 debug_pc,
                 debug_instr,
                 debug_rd,
                 debug_writeback);
        end
    end
    
endmodule
