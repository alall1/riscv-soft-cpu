`timescale 1ns / 1ps

import cpu_defs_pkg::*;

module tb_data_memory;

    logic clk;
    logic MemRead;
    logic MemWrite;
    mem_op_t MemOp;
    logic [31:0] addr;
    logic [31:0] write_data;
    logic [31:0] read_data;
    
    data_memory dut (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemOp(MemOp),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );
    
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        dut.mem[0] = 8'hFF;
        dut.mem[1] = 8'hBB;
        dut.mem[2] = 8'hAA;
        dut.mem[3] = 8'hEE;
        
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemOp = MEM_BYTE;
        addr = 32'h00000002;
        write_data = 32'hA000AF0F;
        
        @(posedge clk);
        
        MemRead = 1'b1;     // lb
        
        @(posedge clk);
        #1;
        if (read_data !== 32'hFFFFFFAA) $error("read_data=%h expected=%h", read_data, 32'hFFFFFFAA);
        
        MemOp = MEM_BYTE_U; // lbu
        
        @(posedge clk);
        #1;
        if (read_data !== 32'h000000AA) $error("read_data=%h expected=%h", read_data, 32'h000000AA);
        
        MemOp = MEM_HALF; // lh
        
        @(posedge clk);
        #1;
        if (read_data !== 32'hFFFFEEAA) $error("read_data=%h expected=%h", read_data, 32'hFFFFEEAA);
        
        MemOp = MEM_HALF_U; // lh
        
        @(posedge clk);
        #1;
        if (read_data !== 32'h0000EEAA) $error("read_data=%h expected=%h", read_data, 32'h0000EEAA);
        
        addr = 32'h00000000;
        
        MemOp = MEM_WORD; // lw
        
        @(posedge clk);
        #1;
        if (read_data !== 32'hEEAABBFF) $error("read_data=%h expected=%h", read_data, 32'hEEAABBFF);
        
        MemRead = 1'b0;
        MemWrite = 1'b1;
        
        addr = 32'h00000002;
        
        MemOp = MEM_BYTE; // sb
        
        @(posedge clk);
        #1;
        if (dut.mem[2] !== 8'h0F) $error("write data failed. mem[2]=%h expected=%h", dut.mem[2], 8'h0F);
        
        MemOp = MEM_HALF; // sh
        
        @(posedge clk);
        #1;
        if (dut.mem[2] !== 8'h0F) $error("write data failed. mem[2]=%h expected=%h", dut.mem[2], 8'h0F);
        if (dut.mem[3] !== 8'hAF) $error("write data failed. mem[3]=%h expected=%h", dut.mem[3], 8'hAF);
        
        addr = 32'h00000000;
        
        MemOp = MEM_WORD; // sw
        
        @(posedge clk);
        #1;
        if (dut.mem[0] !== 8'h0F) $error("write data failed. mem[0]=%h expected=%h", dut.mem[0], 8'h0F);
        if (dut.mem[1] !== 8'hAF) $error("write data failed. mem[1]=%h expected=%h", dut.mem[1], 8'hAF);
        if (dut.mem[2] !== 8'h00) $error("write data failed. mem[2]=%h expected=%h", dut.mem[2], 8'h00);
        if (dut.mem[3] !== 8'hA0) $error("write data failed. mem[3]=%h expected=%h", dut.mem[3], 8'hA0);
        
        #5;
        
        $display("data_memory testbench finished");
        $finish;
    end

endmodule
