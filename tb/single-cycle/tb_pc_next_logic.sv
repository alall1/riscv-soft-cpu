`timescale 1ns / 1ps

module tb_pc_next_logic;

    logic [31:0] pc_plus_4;
    logic [31:0] pc_plus_imm;
    logic Branch;
    logic branch_cond;
    logic JAL;
    logic JALR;
    logic [31:0] alu_result;
    logic [31:0] pc_next;
    
    pc_next_logic dut (
        .pc_plus_4(pc_plus_4),
        .pc_plus_imm(pc_plus_imm),
        .Branch(Branch),
        .branch_cond(branch_cond),
        .JAL(JAL),
        .JALR(JALR),
        .alu_result(alu_result),
        .pc_next(pc_next)
    );
    
    initial begin
        pc_plus_4 = 32'h00000004;   // pc + 4 = 4
        pc_plus_imm = 32'h00000014; // pc + imm = 20
        Branch = 1'b0;
        branch_cond = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;
        alu_result = 32'h00000029;  // rounds down to 40
        
        #10;
        if (pc_next !== 32'h00000004) $error("pc_next=%h expected=%h", pc_next, 32'h00000004);
        
        branch_cond = 1'b1;
        
        #10;
        if (pc_next !== 32'h00000004) $error("pc_next=%h expected=%h", pc_next, 32'h00000004);
        
        Branch = 1'b1;
        branch_cond = 1'b0;
        
        #10;
        if (pc_next !== 32'h00000004) $error("pc_next=%h expected=%h", pc_next, 32'h00000004);
        
        branch_cond = 1'b1;
        
        #10;
        if (pc_next !== 32'h00000014) $error("pc_next=%h expected=%h", pc_next, 32'h00000014);
        
        pc_plus_imm = 32'h00000020;
        JALR = 1'b1;
        
        #10;
        if (pc_next !== 32'h00000028) $error("pc_next=%h expected=%h", pc_next, 32'h00000028);
        
        JALR = 1'b0;
        JAL = 1'b1;
        
        #10;
        if (pc_next !== 32'h00000020) $error("pc_next=%h expected=%h", pc_next, 32'h00000020);
        
        $display("pc_next_logic testbench finished");
        $finish;
    end

endmodule
