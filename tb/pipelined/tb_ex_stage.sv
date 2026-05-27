`timescale 1ns / 1ps

import cpu_defs_pkg::*;

module tb_ex_stage;

    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [31:0] imm;
    logic [31:0] pc;

    logic ALUSrcA;
    logic ALUSrcB;
    alu_ctrl_t ALUctrl;
    logic Branch;
    logic JAL;
    logic JALR;

    logic [31:0] ex_alu_result;
    logic [31:0] ex_redirect_target;
    logic ex_redirect_taken;

    ex_stage dut (
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .imm(imm),
        .pc(pc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ALUctrl(ALUctrl),
        .Branch(Branch),
        .JAL(JAL),
        .JALR(JALR),
        .ex_alu_result(ex_alu_result),
        .ex_redirect_target(ex_redirect_target),
        .ex_redirect_taken(ex_redirect_taken)
    );

    task check_ex;
        input string test_name;
        input logic [31:0] expected_alu_result;
        input logic [31:0] expected_redirect_target;
        input logic expected_redirect_taken;

        begin
            #1;

            if (ex_alu_result !== expected_alu_result) $fatal("%s: ex_alu_result=%h expected=%h", test_name, ex_alu_result, expected_alu_result);
            if (ex_redirect_target !== expected_redirect_target) $fatal("%s: ex_redirect_target=%h expected=%h", test_name, ex_redirect_target, expected_redirect_target);
            if (ex_redirect_taken !== expected_redirect_taken) $fatal("%s: ex_redirect_taken=%b expected=%b", test_name, ex_redirect_taken, expected_redirect_taken);
        end
    endtask

    initial begin
        rs1_data = 32'd0;
        rs2_data = 32'd0;
        imm = 32'd0;
        pc = 32'd0;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_ADD;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;

        #1;

        rs1_data = 32'd10;
        rs2_data = 32'd7;
        imm = 32'd100;
        pc = 32'd32;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_ADD;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("add x?, x?, x?", 32'd17, 32'h00000000, 1'b0);

        rs1_data = 32'd10;
        rs2_data = 32'd7;
        imm = 32'd100;
        pc = 32'd32;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_SUB;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("sub x?, x?, x?", 32'd3, 32'h00000000, 1'b0);

        rs1_data = 32'h000000f0;
        rs2_data = 32'h0000000f;
        imm = 32'd8;
        pc = 32'd64;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_AND;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("and x?, x?, x?", 32'h00000000, 32'h00000000, 1'b0);

        rs1_data = 32'h000000f0;
        rs2_data = 32'h0000000f;
        imm = 32'd8;
        pc = 32'd64;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_OR;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("or x?, x?, x?", 32'h000000ff, 32'h00000000, 1'b0);

        rs1_data = 32'h000000f0;
        rs2_data = 32'h0000000f;
        imm = 32'd8;
        pc = 32'd64;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_XOR;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("xor x?, x?, x?", 32'h000000ff, 32'h00000000, 1'b0);

        rs1_data = 32'h00000004;
        rs2_data = 32'h00000003;
        imm = 32'd16;
        pc = 32'd100;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_SLL;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("sll x?, x?, x?", 32'h00000020, 32'h00000000, 1'b0);

        rs1_data = 32'h80000000;
        rs2_data = 32'h00000004;
        imm = 32'd16;
        pc = 32'd100;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_SRL;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("srl x?, x?, x?", 32'h08000000, 32'h00000000, 1'b0);

        rs1_data = 32'h80000000;
        rs2_data = 32'h00000004;
        imm = 32'd16;
        pc = 32'd100;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_SRA;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("sra x?, x?, x?", 32'hf8000000, 32'h00000000, 1'b0);

        rs1_data = 32'hfffffff0;
        rs2_data = 32'h00000001;
        imm = 32'd20;
        pc = 32'd200;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_SLT;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("slt x?, x?, x?", 32'h00000001, 32'h00000000, 1'b0);

        rs1_data = 32'hfffffff0;
        rs2_data = 32'h00000001;
        imm = 32'd20;
        pc = 32'd200;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_SLTU;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("sltu x?, x?, x?", 32'h00000000, 32'h00000000, 1'b0);

        rs1_data = 32'd10;
        rs2_data = 32'd123;
        imm = 32'd25;
        pc = 32'd300;
        ALUSrcA = 1'b1;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_ADD;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("addi x?, x?, 25", 32'd35, 32'h00000000, 1'b0);

        rs1_data = 32'h000000f0;
        rs2_data = 32'd123;
        imm = 32'h0000000f;
        pc = 32'd300;
        ALUSrcA = 1'b1;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_OR;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("ori x?, x?, 15", 32'h000000ff, 32'h00000000, 1'b0);

        rs1_data = 32'h00000004;
        rs2_data = 32'd123;
        imm = 32'd3;
        pc = 32'd300;
        ALUSrcA = 1'b1;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_SLL;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("slli x?, x?, 3", 32'h00000020, 32'h00000000, 1'b0);

        rs1_data = 32'h80000000;
        rs2_data = 32'd123;
        imm = 32'd4;
        pc = 32'd300;
        ALUSrcA = 1'b1;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_SRA;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("srai x?, x?, 4", 32'hf8000000, 32'h00000000, 1'b0);

        rs1_data = 32'd100;
        rs2_data = 32'd0;
        imm = 32'd12;
        pc = 32'd400;
        ALUSrcA = 1'b1;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_ADD;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("lw/sw address rs1 + imm", 32'd112, 32'h00000000, 1'b0);

        rs1_data = 32'd999;
        rs2_data = 32'd888;
        imm = 32'h12345000;
        pc = 32'd500;
        ALUSrcA = 1'b1;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_LUI;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("lui x?, 0x12345", 32'h12345000, 32'h00000000, 1'b0);

        rs1_data = 32'd999;
        rs2_data = 32'd888;
        imm = 32'h00012000;
        pc = 32'h00000080;
        ALUSrcA = 1'b1;
        ALUSrcB = 1'b1;
        ALUctrl = ALU_ADD;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("auipc x?, 0x00012", 32'h00012080, 32'h00000000, 1'b0);

        rs1_data = 32'd50;
        rs2_data = 32'd50;
        imm = 32'd16;
        pc = 32'd1000;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_BEQ;
        Branch = 1'b1;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("beq x?, x?, 16 taken", 32'h00000000, 32'd1016, 1'b1);

        rs1_data = 32'd50;
        rs2_data = 32'd51;
        imm = 32'd16;
        pc = 32'd1000;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_BEQ;
        Branch = 1'b1;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("beq x?, x?, 16 not taken", 32'h00000000, 32'h00000000, 1'b0);

        rs1_data = 32'd50;
        rs2_data = 32'd51;
        imm = 32'hfffffff0;
        pc = 32'd1000;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_BNE;
        Branch = 1'b1;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("bne x?, x?, -16 taken", 32'h00000000, 32'd984, 1'b1);

        rs1_data = 32'hfffffff0;
        rs2_data = 32'd10;
        imm = 32'd20;
        pc = 32'd1000;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_BLT;
        Branch = 1'b1;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("blt x?, x?, 20 taken", 32'h00000000, 32'd1020, 1'b1);

        rs1_data = 32'd10;
        rs2_data = 32'hfffffff0;
        imm = 32'd20;
        pc = 32'd1000;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_BLTU;
        Branch = 1'b1;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("bltu x?, x?, 20 taken", 32'h00000000, 32'd1020, 1'b1);

        rs1_data = 32'd10;
        rs2_data = 32'hfffffff0;
        imm = 32'd20;
        pc = 32'd1000;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_BGEU;
        Branch = 1'b1;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("bgeu x?, x?, 20 not taken", 32'h00000000, 32'h00000000, 1'b0);

        rs1_data = 32'd50;
        rs2_data = 32'd51;
        imm = 32'd24;
        pc = 32'd1000;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_BGE;
        Branch = 1'b1;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("bge x?, x?, 24 not taken", 32'h00000000, 32'h00000000, 1'b0);

        rs1_data = 32'd51;
        rs2_data = 32'd50;
        imm = 32'd24;
        pc = 32'd1000;
        ALUSrcA = 1'b0;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_BGE;
        Branch = 1'b1;
        JAL = 1'b0;
        JALR = 1'b0;
        check_ex("bge x?, x?, 24 taken", 32'h00000000, 32'd1024, 1'b1);

        rs1_data = 32'd0;
        rs2_data = 32'd0;
        imm = 32'd40;
        pc = 32'd2000;
        ALUSrcA = 1'b1;
        ALUSrcB = 1'b1;
        ALUctrl = ALU_ADD;
        Branch = 1'b0;
        JAL = 1'b1;
        JALR = 1'b0;
        check_ex("jal x?, 40", 32'd2040, 32'd2040, 1'b1);

        rs1_data = 32'd3000;
        rs2_data = 32'd0;
        imm = 32'd12;
        pc = 32'd2000;
        ALUSrcA = 1'b1;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_ADD;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b1;
        check_ex("jalr x?, 12(x?)", 32'd3012, 32'd3012, 1'b1);

        rs1_data = 32'd3001;
        rs2_data = 32'd0;
        imm = 32'd12;
        pc = 32'd2000;
        ALUSrcA = 1'b1;
        ALUSrcB = 1'b0;
        ALUctrl = ALU_ADD;
        Branch = 1'b0;
        JAL = 1'b0;
        JALR = 1'b1;
        check_ex("jalr x?, 12(x?) odd target", 32'd3013, 32'd3012, 1'b1);

        #20;

        $display("PASS");
        $finish;
    end

endmodule