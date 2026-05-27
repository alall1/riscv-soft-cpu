`timescale 1ns / 1ps

import cpu_defs_pkg::*;

module tb_id_stage;

    logic clk;
    logic reset;

    logic [31:0] instr;
    logic [31:0] wb_write_data;
    logic [4:0] wb_rd_addr;
    logic wb_RegWrite;

    logic [31:0] id_rs1_data;
    logic [31:0] id_rs2_data;
    logic [4:0] id_rd_addr;
    logic [31:0] id_imm;

    logic id_RegWrite;
    logic id_ALUSrcA;
    logic id_ALUSrcB;
    logic id_MemRead;
    logic id_MemWrite;
    logic id_MemtoReg;
    logic id_Branch;
    logic id_JAL;
    logic id_JALR;
    logic id_JumpWrite;
    alu_ctrl_t id_ALUctrl;
    mem_op_t id_MemOp;

    id_stage dut (
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .wb_write_data(wb_write_data),
        .wb_rd_addr(wb_rd_addr),
        .wb_RegWrite(wb_RegWrite),
        .id_rs1_data(id_rs1_data),
        .id_rs2_data(id_rs2_data),
        .id_rd_addr(id_rd_addr),
        .id_imm(id_imm),
        .id_RegWrite(id_RegWrite),
        .id_ALUSrcA(id_ALUSrcA),
        .id_ALUSrcB(id_ALUSrcB),
        .id_MemRead(id_MemRead),
        .id_MemWrite(id_MemWrite),
        .id_MemtoReg(id_MemtoReg),
        .id_Branch(id_Branch),
        .id_JAL(id_JAL),
        .id_JALR(id_JALR),
        .id_JumpWrite(id_JumpWrite),
        .id_ALUctrl(id_ALUctrl),
        .id_MemOp(id_MemOp)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task write_reg;
        input logic [4:0] rd;
        input logic [31:0] data;

        begin
            wb_rd_addr = rd;
            wb_write_data = data;
            wb_RegWrite = 1'b1;

            @(posedge clk);

            #1;
            wb_RegWrite = 1'b0;
        end
    endtask

    task check_id;
        input string test_name;
        input logic [31:0] expected_rs1_data;
        input logic [31:0] expected_rs2_data;
        input logic [4:0] expected_rd_addr;
        input logic [31:0] expected_imm;
        input logic expected_RegWrite;
        input logic expected_ALUSrcA;
        input logic expected_ALUSrcB;
        input logic expected_MemRead;
        input logic expected_MemWrite;
        input logic expected_MemtoReg;
        input logic expected_Branch;
        input logic expected_JAL;
        input logic expected_JALR;
        input logic expected_JumpWrite;
        input alu_ctrl_t expected_ALUctrl;
        input mem_op_t expected_MemOp;

        begin
            #1;

            if (id_rs1_data !== expected_rs1_data) $fatal("%s: id_rs1_data=%h expected=%h", test_name, id_rs1_data, expected_rs1_data);
            if (id_rs2_data !== expected_rs2_data) $fatal("%s: id_rs2_data=%h expected=%h", test_name, id_rs2_data, expected_rs2_data);
            if (id_rd_addr !== expected_rd_addr) $fatal("%s: id_rd_addr=%d expected=%d", test_name, id_rd_addr, expected_rd_addr);
            if (id_imm !== expected_imm) $fatal("%s: id_imm=%h expected=%h", test_name, id_imm, expected_imm);

            if (id_RegWrite !== expected_RegWrite) $fatal("%s: id_RegWrite=%b expected=%b", test_name, id_RegWrite, expected_RegWrite);
            if (id_ALUSrcA !== expected_ALUSrcA) $fatal("%s: id_ALUSrcA=%b expected=%b", test_name, id_ALUSrcA, expected_ALUSrcA);
            if (id_ALUSrcB !== expected_ALUSrcB) $fatal("%s: id_ALUSrcB=%b expected=%b", test_name, id_ALUSrcB, expected_ALUSrcB);
            if (id_MemRead !== expected_MemRead) $fatal("%s: id_MemRead=%b expected=%b", test_name, id_MemRead, expected_MemRead);
            if (id_MemWrite !== expected_MemWrite) $fatal("%s: id_MemWrite=%b expected=%b", test_name, id_MemWrite, expected_MemWrite);
            if (id_MemtoReg !== expected_MemtoReg) $fatal("%s: id_MemtoReg=%b expected=%b", test_name, id_MemtoReg, expected_MemtoReg);
            if (id_Branch !== expected_Branch) $fatal("%s: id_Branch=%b expected=%b", test_name, id_Branch, expected_Branch);
            if (id_JAL !== expected_JAL) $fatal("%s: id_JAL=%b expected=%b", test_name, id_JAL, expected_JAL);
            if (id_JALR !== expected_JALR) $fatal("%s: id_JALR=%b expected=%b", test_name, id_JALR, expected_JALR);
            if (id_JumpWrite !== expected_JumpWrite) $fatal("%s: id_JumpWrite=%b expected=%b", test_name, id_JumpWrite, expected_JumpWrite);

            if (id_ALUctrl !== expected_ALUctrl) $fatal("%s: id_ALUctrl=%0d expected=%0d", test_name, id_ALUctrl, expected_ALUctrl);
            if (id_MemOp !== expected_MemOp) $fatal("%s: id_MemOp=%0d expected=%0d", test_name, id_MemOp, expected_MemOp);
        end
    endtask

    initial begin
        reset = 1'b1;
        instr = 32'h00000013;
        wb_write_data = 32'd0;
        wb_rd_addr = 5'd0;
        wb_RegWrite = 1'b0;

        @(posedge clk);
        #1;
        reset = 1'b0;

        write_reg(5'd1, 32'h00000111);
        write_reg(5'd2, 32'h00000222);
        write_reg(5'd3, 32'hfffffff0);
        write_reg(5'd4, 32'h00000004);
        write_reg(5'd5, 32'h80000000);
        write_reg(5'd6, 32'h0000000f);
        write_reg(5'd7, 32'h12345678);

        instr = 32'h002081b3; // add x3, x1, x2
        check_id("add x3, x1, x2", 32'h00000111, 32'h00000222, 5'd3, 32'h00000000, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_ADD, MEM_BYTE);

        instr = 32'h40208233; // sub x4, x1, x2
        check_id("sub x4, x1, x2", 32'h00000111, 32'h00000222, 5'd4, 32'h00000000, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_SUB, MEM_BYTE);

        instr = 32'h0060f2b3; // and x5, x1, x6
        check_id("and x5, x1, x6", 32'h00000111, 32'h0000000f, 5'd5, 32'h00000000, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_AND, mem_op_t'(3'b111));

        instr = 32'h0060e333; // or x6, x1, x6
        check_id("or x6, x1, x6", 32'h00000111, 32'h0000000f, 5'd6, 32'h00000000, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_OR, mem_op_t'(3'b110));

        instr = 32'h0060c3b3; // xor x7, x1, x6
        check_id("xor x7, x1, x6", 32'h00000111, 32'h0000000f, 5'd7, 32'h00000000, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_XOR, MEM_BYTE_U);

        instr = 32'h00409433; // sll x8, x1, x4
        check_id("sll x8, x1, x4", 32'h00000111, 32'h00000004, 5'd8, 32'h00000000, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_SLL, MEM_HALF);

        instr = 32'h0042d4b3; // srl x9, x5, x4
        check_id("srl x9, x5, x4", 32'h80000000, 32'h00000004, 5'd9, 32'h00000000, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_SRL, MEM_HALF_U);

        instr = 32'h4042d533; // sra x10, x5, x4
        check_id("sra x10, x5, x4", 32'h80000000, 32'h00000004, 5'd10, 32'h00000000, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_SRA, MEM_HALF_U);

        instr = 32'h0011a5b3; // slt x11, x3, x1
        check_id("slt x11, x3, x1", 32'hfffffff0, 32'h00000111, 5'd11, 32'h00000000, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_SLT, MEM_WORD);

        instr = 32'h0011b633; // sltu x12, x3, x1
        check_id("sltu x12, x3, x1", 32'hfffffff0, 32'h00000111, 5'd12, 32'h00000000, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_SLTU, mem_op_t'(3'b011));

        instr = 32'h00a08693; // addi x13, x1, 10
        check_id("addi x13, x1, 10", 32'h00000111, 32'h00000000, 5'd13, 32'h0000000a, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_ADD, MEM_BYTE);

        instr = 32'hfff0c713; // xori x14, x1, -1
        check_id("xori x14, x1, -1", 32'h00000111, 32'h00000000, 5'd14, 32'hffffffff, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_XOR, MEM_BYTE_U);

        instr = 32'h0f00e793; // ori x15, x1, 240
        check_id("ori x15, x1, 240", 32'h00000111, 32'h00000000, 5'd15, 32'h000000f0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_OR, mem_op_t'(3'b110));

        instr = 32'h0ff0f813; // andi x16, x1, 255
        check_id("andi x16, x1, 255", 32'h00000111, 32'h00000000, 5'd16, 32'h000000ff, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_AND, mem_op_t'(3'b111));

        instr = 32'h0001a893; // slti x17, x3, 0
        check_id("slti x17, x3, 0", 32'hfffffff0, 32'h00000000, 5'd17, 32'h00000000, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_SLT, MEM_WORD);

        instr = 32'hfff1b913; // sltiu x18, x3, -1
        check_id("sltiu x18, x3, -1", 32'hfffffff0, 32'h00000000, 5'd18, 32'hffffffff, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_SLTU, mem_op_t'(3'b011));

        instr = 32'h00331993; // slli x19, x6, 3
        check_id("slli x19, x6, 3", 32'h0000000f, 32'hfffffff0, 5'd19, 32'h00000003, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_SLL, MEM_HALF);

        instr = 32'h0032da13; // srli x20, x5, 3
        check_id("srli x20, x5, 3", 32'h80000000, 32'hfffffff0, 5'd20, 32'h00000003, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_SRL, MEM_HALF_U);

        instr = 32'h4032da93; // srai x21, x5, 3
        check_id("srai x21, x5, 3", 32'h80000000, 32'hfffffff0, 5'd21, 32'h00000403, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_SRA, MEM_HALF_U);

        instr = 32'hffe08b03; // lb x22, -2(x1)
        check_id("lb x22, -2(x1)", 32'h00000111, 32'h00000000, 5'd22, 32'hfffffffe, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, ALU_ADD, MEM_BYTE);

        instr = 32'h00409b83; // lh x23, 4(x1)
        check_id("lh x23, 4(x1)", 32'h00000111, 32'h00000004, 5'd23, 32'h00000004, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, ALU_ADD, MEM_HALF);

        instr = 32'h00812c03; // lw x24, 8(x2)
        check_id("lw x24, 8(x2)", 32'h00000222, 32'h00000000, 5'd24, 32'h00000008, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, ALU_ADD, MEM_WORD);

        instr = 32'h00c14c83; // lbu x25, 12(x2)
        check_id("lbu x25, 12(x2)", 32'h00000222, 32'h00000000, 5'd25, 32'h0000000c, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, ALU_ADD, MEM_BYTE_U);

        instr = 32'h01015d03; // lhu x26, 16(x2)
        check_id("lhu x26, 16(x2)", 32'h00000222, 32'h00000000, 5'd26, 32'h00000010, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, ALU_ADD, MEM_HALF_U);

        instr = 32'h00710423; // sb x7, 8(x2)
        check_id("sb x7, 8(x2)", 32'h00000222, 32'h12345678, 5'd8, 32'h00000008, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_ADD, MEM_BYTE);

        instr = 32'hfe309e23; // sh x3, -4(x1)
        check_id("sh x3, -4(x1)", 32'h00000111, 32'hfffffff0, 5'd28, 32'hfffffffc, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_ADD, MEM_HALF);

        instr = 32'h00512a23; // sw x5, 20(x2)
        check_id("sw x5, 20(x2)", 32'h00000222, 32'h80000000, 5'd20, 32'h00000014, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_ADD, MEM_WORD);

        instr = 32'h00208863; // beq x1, x2, 16
        check_id("beq x1, x2, 16", 32'h00000111, 32'h00000222, 5'd16, 32'h00000010, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, ALU_BEQ, MEM_BYTE);

        instr = 32'hfe209ce3; // bne x1, x2, -8
        check_id("bne x1, x2, -8", 32'h00000111, 32'h00000222, 5'd25, 32'hfffffff8, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, ALU_BNE, MEM_HALF);

        instr = 32'h0011c663; // blt x3, x1, 12
        check_id("blt x3, x1, 12", 32'hfffffff0, 32'h00000111, 5'd12, 32'h0000000c, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, ALU_BLT, MEM_BYTE_U);

        instr = 32'hfe30dae3; // bge x1, x3, -12
        check_id("bge x1, x3, -12", 32'h00000111, 32'hfffffff0, 5'd21, 32'hfffffff4, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, ALU_BGE, MEM_HALF_U);

        instr = 32'h0011ea63; // bltu x3, x1, 20
        check_id("bltu x3, x1, 20", 32'hfffffff0, 32'h00000111, 5'd20, 32'h00000014, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, ALU_BLTU, mem_op_t'(3'b110));

        instr = 32'hfe30f8e3; // bgeu x1, x3, -16
        check_id("bgeu x1, x3, -16", 32'h00000111, 32'hfffffff0, 5'd17, 32'hfffffff0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, ALU_BGEU, mem_op_t'(3'b111));

        instr = 32'h12345db7; // lui x27, 0x12345
        check_id("lui x27, 0x12345", 32'h00000000, 32'hfffffff0, 5'd27, 32'h12345000, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_LUI, MEM_HALF_U);

        instr = 32'h00012e17; // auipc x28, 0x00012
        check_id("auipc x28, 0x00012", 32'h00000222, 32'h00000000, 5'd28, 32'h00012000, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ALU_ADD, MEM_WORD);

        instr = 32'h00c00eef; // jal x29, 12
        check_id("jal x29, 12", 32'h00000000, 32'h00000000, 5'd29, 32'h0000000c, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, ALU_ADD, MEM_BYTE);

        instr = 32'h00408f67; // jalr x30, 4(x1)
        check_id("jalr x30, 4(x1)", 32'h00000111, 32'h00000004, 5'd30, 32'h00000004, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, ALU_ADD, MEM_BYTE);

        #20;

        $display("PASS");
        $finish;
    end

endmodule