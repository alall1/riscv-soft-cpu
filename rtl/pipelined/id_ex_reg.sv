import cpu_defs_pkg::*;

module id_ex_reg (
    input logic clk,
    input logic reset,
    
    input logic [31:0] id_rs1_data,
    input logic [31:0] id_rs2_data,
    input logic [4:0] id_rd_addr,
    input logic [31:0] id_imm,
    input logic [31:0] id_pc,
    input logic [31:0] id_pc_plus_4,
    
    output logic [31:0] ex_rs1_data,
    output logic [31:0] ex_rs2_data,
    output logic [4:0] ex_rd_addr,
    output logic [31:0] ex_imm,
    output logic [31:0] ex_pc,
    output logic [31:0] ex_pc_plus_4,
    
    // control signals
    input logic id_RegWrite,
    input logic id_ALUSrcA,
    input logic id_ALUSrcB,
    input logic id_MemRead,
    input logic id_MemWrite,
    input logic id_MemtoReg,
    input logic id_Branch,
    input logic id_JAL,
    input logic id_JALR,
    input logic id_JumpWrite,
    input alu_ctrl_t id_ALUctrl,
    input mem_op_t id_MemOp,
    
    output logic ex_RegWrite,
    output logic ex_ALUSrcA,
    output logic ex_ALUSrcB,
    output logic ex_MemRead,
    output logic ex_MemWrite,
    output logic ex_MemtoReg,
    output logic ex_Branch,
    output logic ex_JAL,
    output logic ex_JALR,
    output logic ex_JumpWrite,
    output alu_ctrl_t ex_ALUctrl,
    output mem_op_t ex_MemOp
);

    always_ff @(posedge clk) begin
        if (reset) begin
            ex_rs1_data <= 32'h00000000;
            ex_rs2_data <= 32'h00000000;
            ex_rd_addr <= 5'b00000;
            ex_imm <= 32'h00000000;
            ex_pc <= 32'h00000000;
            ex_pc_plus_4 <= 32'h00000000;
            
            // control signals
            ex_RegWrite <= 1'b0;
            ex_ALUSrcA <= 1'b0;
            ex_ALUSrcB <= 1'b0;
            ex_MemRead <= 1'b0;
            ex_MemWrite <= 1'b0;
            ex_MemtoReg <= 1'b0;
            ex_Branch <= 1'b0;
            ex_JAL <= 1'b0;
            ex_JALR <= 1'b0;
            ex_JumpWrite <= 1'b0;
            ex_ALUctrl <= ALU_ADD;
            ex_MemOp <= MEM_WORD;
        end else begin
            ex_rs1_data <= id_rs1_data;
            ex_rs2_data <= id_rs2_data;
            ex_rd_addr <= id_rd_addr;
            ex_imm <= id_imm;
            ex_pc <= id_pc;
            ex_pc_plus_4 <= id_pc_plus_4;
            
            // control signals
            ex_RegWrite <= id_RegWrite;
            ex_ALUSrcA <= id_ALUSrcA;
            ex_ALUSrcB <= id_ALUSrcB;
            ex_MemRead <= id_MemRead;
            ex_MemWrite <= id_MemWrite;
            ex_MemtoReg <= id_MemtoReg;
            ex_Branch <= id_Branch;
            ex_JAL <= id_JAL;
            ex_JALR <= id_JALR;
            ex_JumpWrite <= id_JumpWrite;
            ex_ALUctrl <= id_ALUctrl;
            ex_MemOp <= id_MemOp;
        end
    end

endmodule