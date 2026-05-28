`timescale 1ns / 1ps

import cpu_defs_pkg::*;

module tb_mem_stage;

    logic clk;

    logic [31:0] alu_result;
    logic [31:0] store_data;

    logic MemRead;
    logic MemWrite;
    mem_op_t MemOp;

    logic [31:0] mem_read_data;

    mem_stage dut (
        .clk(clk),
        .alu_result(alu_result),
        .store_data(store_data),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemOp(MemOp),
        .mem_read_data(mem_read_data)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task write_mem;
        input logic [31:0] addr;
        input logic [31:0] data;
        input mem_op_t op;

        begin
            alu_result = addr;
            store_data = data;
            MemOp = op;
            MemRead = 1'b0;
            MemWrite = 1'b1;

            @(posedge clk);

            #1;
            MemWrite = 1'b0;
        end
    endtask

    task read_mem;
        input logic [31:0] addr;
        input mem_op_t op;
        input logic [31:0] expected;

        begin
            alu_result = addr;
            store_data = 32'h00000000;
            MemOp = op;
            MemRead = 1'b1;
            MemWrite = 1'b0;

            #1;

            if (mem_read_data !== expected) $fatal("read addr=%0d op=%0d data=%h expected=%h", addr, op, mem_read_data, expected);

            MemRead = 1'b0;
        end
    endtask

    task check_byte;
        input int addr;
        input logic [7:0] expected;

        begin
            #1;
            if (dut.data_mem.mem[addr] !== expected) $fatal("mem[%0d]=%h expected=%h", addr, dut.data_mem.mem[addr], expected);
        end
    endtask

    task check_unchanged_word;
        input logic [31:0] addr;
        input logic [31:0] expected;

        begin
            read_mem(addr, MEM_WORD, expected);
        end
    endtask

    initial begin
        alu_result = 32'h00000000;
        store_data = 32'h00000000;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemOp = MEM_WORD;

        #10;

        write_mem(32'd0, 32'h12345678, MEM_WORD);
        check_byte(0, 8'h78);
        check_byte(1, 8'h56);
        check_byte(2, 8'h34);
        check_byte(3, 8'h12);
        read_mem(32'd0, MEM_WORD, 32'h12345678);

        read_mem(32'd0, MEM_BYTE, 32'h00000078);
        read_mem(32'd0, MEM_BYTE_U, 32'h00000078);
        read_mem(32'd1, MEM_HALF, 32'h00003456);
        read_mem(32'd1, MEM_HALF_U, 32'h00003456);

        write_mem(32'd8, 32'hffff_ff80, MEM_BYTE);
        check_byte(8, 8'h80);
        read_mem(32'd8, MEM_BYTE, 32'hffffff80);
        read_mem(32'd8, MEM_BYTE_U, 32'h00000080);

        write_mem(32'd12, 32'h0000_ff80, MEM_HALF);
        check_byte(12, 8'h80);
        check_byte(13, 8'hff);
        read_mem(32'd12, MEM_HALF, 32'hffffff80);
        read_mem(32'd12, MEM_HALF_U, 32'h0000ff80);

        write_mem(32'd16, 32'h00007f80, MEM_HALF);
        check_byte(16, 8'h80);
        check_byte(17, 8'h7f);
        read_mem(32'd16, MEM_HALF, 32'h00007f80);
        read_mem(32'd16, MEM_HALF_U, 32'h00007f80);

        write_mem(32'd20, 32'hdeadbeef, MEM_WORD);
        read_mem(32'd20, MEM_WORD, 32'hdeadbeef);
        read_mem(32'd20, MEM_BYTE, 32'hffffffef);
        read_mem(32'd20, MEM_BYTE_U, 32'h000000ef);
        read_mem(32'd22, MEM_HALF, 32'hffffdead);
        read_mem(32'd22, MEM_HALF_U, 32'h0000dead);

        write_mem(32'd20, 32'h000000aa, MEM_BYTE);
        check_byte(20, 8'haa);
        check_byte(21, 8'hbe);
        check_byte(22, 8'had);
        check_byte(23, 8'hde);
        read_mem(32'd20, MEM_WORD, 32'hdeadbeaa);

        write_mem(32'd24, 32'h11223344, MEM_WORD);
        read_mem(32'd24, MEM_WORD, 32'h11223344);

        alu_result = 32'd24;
        store_data = 32'haabbccdd;
        MemOp = MEM_WORD;
        MemRead = 1'b0;
        MemWrite = 1'b0;

        @(posedge clk);
        #1;

        check_unchanged_word(32'd24, 32'h11223344);

        write_mem(32'd28, 32'h00001234, MEM_HALF);
        read_mem(32'd28, MEM_WORD, 32'h00001234);

        write_mem(32'd30, 32'h0000abcd, MEM_HALF);
        check_byte(28, 8'h34);
        check_byte(29, 8'h12);
        check_byte(30, 8'hcd);
        check_byte(31, 8'hab);
        read_mem(32'd28, MEM_WORD, 32'habcd1234);

        write_mem(32'd36, 32'h01020304, MEM_WORD);
        read_mem(32'd36, MEM_WORD, 32'h01020304);
        read_mem(32'd37, MEM_BYTE, 32'h00000003);
        read_mem(32'd38, MEM_BYTE, 32'h00000002);
        read_mem(32'd39, MEM_BYTE, 32'h00000001);

        #20;

        $display("PASS");
        $finish;
    end

endmodule