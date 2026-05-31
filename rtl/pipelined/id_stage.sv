import cpu_defs_pkg::*;

module id_stage(
    input logic clk,
    input logic reset,
    
    input logic [31:0] instr,
    input logic [31:0] wb_write_data,   // coming from WB stage
    input logic [4:0] wb_rd_addr,       // coming from WB stage
    input logic wb_RegWrite,            // coming from WB stage
    
    output logic [4:0] id_rs1_addr,
    output logic [4:0] id_rs2_addr,
    output logic id_uses_rs1,
    output logic id_uses_rs2,
    
    output logic [31:0] id_rs1_data,
    output logic [31:0] id_rs2_data,
    output logic [4:0] id_rd_addr,      // generated from current instr in ID
    output logic [31:0] id_imm,
    
    // control signals
    output logic id_RegWrite,           // generated from current instr in ID
    output logic id_ALUSrcA,
    output logic id_ALUSrcB,
    output logic id_MemRead,
    output logic id_MemWrite,
    output logic id_MemtoReg,
    output logic id_Branch,
    output logic id_JAL,
    output logic id_JALR,
    output logic id_JumpWrite,
    output alu_ctrl_t id_ALUctrl,
    output mem_op_t id_MemOp
);

    alu_op_t ALUOp;

    reg_file rf (
        .clk(clk),
        .reset(reset),
        .RegWrite(wb_RegWrite),
        .rs1_addr(instr[19:15]),
        .rs2_addr(instr[24:20]),
        .rd_addr(wb_rd_addr),
        .write_data(wb_write_data),
        .rs1_data(id_rs1_data),
        .rs2_data(id_rs2_data)
    );
    
    imm_generator imm_gen (
        .instr(instr),
        .imm(id_imm)
    );
    
    control_unit c_unit (
        .opcode(instr[6:0]),
        .RegWrite(id_RegWrite),
        .ALUSrcA(id_ALUSrcA),
        .ALUSrcB(id_ALUSrcB),
        .MemRead(id_MemRead),
        .MemWrite(id_MemWrite),
        .MemtoReg(id_MemtoReg),
        .Branch(id_Branch),
        .JAL(id_JAL),
        .JALR(id_JALR),
        .JumpWrite(id_JumpWrite),
        .ALUOp(ALUOp),
        
        .uses_rs1(id_uses_rs1),
        .uses_rs2(id_uses_rs2)
    );
    
    alu_control alu_c_unit (
        .ALUOp(ALUOp),
        .funct7(instr[31:25]),
        .funct3(instr[14:12]),
        .ALUctrl(id_ALUctrl)
    );

    assign id_MemOp = mem_op_t'(instr[14:12]);
    assign id_rd_addr = instr[11:7];
    assign id_rs1_addr = instr[19:15];
    assign id_rs2_addr = instr[24:20];
    
endmodule