`timescale 1ns / 1ps

module tb_reg_file;

    logic clk;
    logic reset;
    logic RegWrite;
    logic [4:0] rs1_addr;
    logic [4:0] rs2_addr;
    logic [4:0] rd_addr;
    logic [31:0] write_data;
    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    
    reg_file dut (
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWrite),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .write_data(write_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );
    
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        reset = 1'b1;
        RegWrite = 1'b0;
        rs1_addr = 5'b00000;    // x0
        rs2_addr = 5'b00001;    // x1
        rd_addr = 5'b00000;     // x0
        write_data = 32'h00000010;
        
        @(posedge clk);
        #1;                     // reg_file updates using non-blocking assignments <=, so giving simulator time to apply update
        if (rs1_data !== 32'h00000000) $error("rs1_data=%h expected=%h", rs1_data, 32'h00000000);
        if (rs2_data !== 32'h00000000) $error("rs2_data=%h expected=%h", rs2_data, 32'h00000000);
        
        reset = 1'b0;
        RegWrite = 1'b1;        // writing write_data to x0, x0 should stay at 0
        
        @(posedge clk);
        #1;
        if (rs1_data !== 32'h00000000) $error("rs1_data=%h expected=%h", rs1_data, 32'h00000000);
        
        rd_addr = 5'b00001;     // x1
        
        @(posedge clk);
        #1;
        if (rs2_data !== 32'h00000010) $error("rs2_data=%h expected=%h", rs2_data, 32'h00000010);
        
        rd_addr = 5'b00010;     // x2
        rs1_addr = 5'b00010;    // x2
        RegWrite = 1'b0;        // x2 should stay 0 with RegWrite off
        
        @(posedge clk);
        #1;
        if (rs1_data !== 32'h00000000) $error("rs1_data=%h expected=%h", rs1_data, 32'h00000000);
        
        $display("reg_file testbench finished");
        $finish;
    end
    
endmodule