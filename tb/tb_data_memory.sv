`timescale 1ns / 1ps

module tb_data_memory;

    logic clk;
    logic MemRead;
    logic MemWrite;
    logic [31:0] addr;
    logic [31:0] write_data;
    logic [31:0] read_data;
    
    data_memory dut (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );
    
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        dut.mem[0] = 32'h00000000;
        dut.mem[1] = 32'hFFFFFFFF;
        
        MemRead = 1'b0;
        MemWrite = 1'b0;
        addr = 32'h00000004;
        write_data = 32'hA0000000;
        
        @(posedge clk);
        #1;
        if (read_data !== 32'h00000000) $error("read_data=%h expected=%h", read_data, 32'h00000000);
        
        MemRead = 1'b1;
        
        @(posedge clk);
        #1;
        if (read_data !== 32'hFFFFFFFF) $error("read_data=%h expected=%h", read_data, 32'hFFFFFFFF);
        
        addr = 32'h00000000;
        MemRead = 1'b0;
        MemWrite = 1'b1;
        
        @(posedge clk);
        #1;
        if (read_data !== 32'h00000000) $error("read_data=%h expected=%h", read_data, 32'h00000000);
        if (dut.mem[0] !== 32'hA0000000) $error("write data failed. mem[0]=%h expected=%h", dut.mem[0], write_data);
        
        #5;
        
        $display("data_memory testbench finished");
        $finish;
    end

endmodule
