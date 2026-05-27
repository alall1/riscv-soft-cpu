`timescale 1ns / 1ps

module tb_if_stage;

    logic clk;
    logic reset;
    logic [31:0] redirect_target;
    logic redirect_taken;
    logic [31:0] if_instr;
    logic [31:0] if_pc;
    logic [31:0] if_pc_plus_4;
    
    if_stage #(
        .PROGRAM_FILE("instrmem_test.mem")
    ) dut (
        .clk(clk),
        .reset(reset),
        .redirect_target(redirect_target),
        .redirect_taken(redirect_taken),
        .if_instr(if_instr),
        .if_pc(if_pc),
        .if_pc_plus_4(if_pc_plus_4)
    );
    
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        reset = 1'b1;
        redirect_target = 32'd20;
        redirect_taken = 1'b0;
        
        @(posedge clk);
        #1;
        reset = 1'b0;
        
        if (if_instr !== 32'h00f00093) $fatal("if_instr=%h expected=%h", if_instr, 32'h00f00093);
        
        @(posedge clk);
        
        #1;
        if (if_pc !== 32'd4) $fatal("if_pc=%d expected=%d", if_pc, 32'd4);
        if (if_pc_plus_4 !== 32'd8) $fatal("if_pc_plus_4=%d expected=%d", if_pc_plus_4, 32'd8);
        
        if (if_instr !== 32'h00e00113) $fatal("if_instr=%h expected=%h", if_instr, 32'h00e00113);
        
        @(posedge clk);
        
        #1;
        if (if_pc !== 32'd8) $fatal("if_pc=%d expected=%d", if_pc, 32'd8);
        if (if_pc_plus_4 !== 32'd12) $fatal("if_pc_plus_4=%d expected=%d", if_pc_plus_4, 32'd12);
        
        if (if_instr !== 32'h002081b3) $fatal("if_instr=%h expected=%h", if_instr, 32'h002081b3);
        
        redirect_taken = 1'b1;
        
        @(posedge clk);
        
        #1;
        if (if_pc !== 32'd20) $fatal("if_pc=%d expected=%d", if_pc, 32'd20);
        if (if_pc_plus_4 !== 32'd24) $fatal("if_pc_plus_4=%d expected=%d", if_pc_plus_4, 32'd24);
        
        if (if_instr !== 32'h00000033) $fatal("if_instr=%h expected=%h", if_instr, 32'h00000033);
        
        #1;
        redirect_taken = 1'b0;
        
        @(posedge clk);
        
        #1;
        if (if_pc !== 32'd24) $fatal("if_pc=%d expected=%d", if_pc, 32'd24);
        if (if_pc_plus_4 !== 32'd28) $fatal("if_pc_plus_4=%d expected=%d", if_pc_plus_4, 32'd28);
        
        if (if_instr !== 32'h00e00113) $fatal("if_instr=%h expected=%h", if_instr, 32'h00e00113);
        
        #20;
        
        $display("PASS");
        $finish;
    end
    
endmodule