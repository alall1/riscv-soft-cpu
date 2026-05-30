`timescale 1ns / 1ps

import cpu_defs_pkg::*;

module tb_cpu_core;

    logic clk;
    logic reset;
    logic debug_halt;

    cpu_core #(
        .PROGRAM_FILE("ctrlhazard_test.mem")
    ) dut (
        .clk(clk),
        .reset(reset),
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
            $display("%0d cycles taken", cycles);
        end
    endtask
    
    task check_mem_byte;
        input int byte_addr;
        input logic [7:0] expected;
        
        begin
            if (dut.memory_access.data_mem.mem[byte_addr] !== expected) begin
                $fatal("FAIL: mem[%0d]=%h expected=%h", byte_addr, dut.memory_access.data_mem.mem[byte_addr], expected);
            end
        end
    endtask
    
    task check_mem_word;    // addresses should be in multiples of 4 for check_mem_word
        input int byte_addr;
        input logic [31:0] expected;
        
        logic [31:0] word;
        
        begin
            word = {dut.memory_access.data_mem.mem[byte_addr+3], dut.memory_access.data_mem.mem[byte_addr+2], dut.memory_access.data_mem.mem[byte_addr+1], dut.memory_access.data_mem.mem[byte_addr]};
            if (word !== expected) begin
                $fatal("FAIL: mem[%0d]=%h expected=%h", byte_addr, word, expected);
            end
        end
    endtask

    initial begin
        trace_enable = 1'b0;
        run_program(100, 1'b1);
        
        check_mem_word(64, 32'h0000000d);
        check_mem_word(68, 32'h00000017);
        check_mem_word(72, 32'h0000002a);

        $display("PASS");
        $finish;
    end
    
endmodule
