`timescale 1ns / 1ps

module tb_pc;

    logic clk;
    logic reset;
    logic [31:0] pc_next;
    logic [31:0] pc;
    
    pc dut (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );
    
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        reset = 1'b1;
        pc_next = 32'd0;
        
        @(posedge clk);
        reset = 1'b0;
        pc_next = 32'd4;
        
        @(posedge clk);
        pc_next = 32'd8;
        
        @(posedge clk);
        pc_next = 32'd12;
        
        #20;
        
        $display("pc testbench finished");
        $finish;
    end
    
endmodule