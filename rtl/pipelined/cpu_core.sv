import cpu_defs_pkg::*;

module cpu_core #(
    parameter string PROGRAM_FILE = "program_file.mem"
)(
    input logic clk,
    input logic reset,
    
    output logic [31:0] debug_instr,
    output logic [31:0] debug_alu,
    output logic [31:0] debug_writeback,
    output logic [31:0] debug_pc,
    output logic [4:0] debug_rd,
    output logic debug_halt
);

    logic [31:0] pc_current, pc_next;       // current pc and next pc
    logic [31:0] pc_plus_4, pc_plus_imm;    // pc+4 and pc+imm
    logic [31:0] instr;                     // current instruction
    logic [31:0] rs1, rs2;                  // data read from reg_file
    logic [31:0] data_result;               // result from data_mem (for load instructions)
    logic [31:0] memtoreg_result;           // result from memtoreg mux
    logic [31:0] write_result;              // result to write to reg_file (through jumpwrite mux)
    logic [31:0] imm;                       // generated immediate from imm_generator
    logic [31:0] alu_input_2;               // selected input_2 into ALU (imm or rs2)
    logic [31:0] alu_input_1;               // selected input_1 into ALU (PC or rs1)
    logic [31:0] alu_result;                // result from ALU
    logic branch_cond;                      // branch_cond result from ALU
    
    assign debug_instr = instr;
    assign debug_alu = alu_result;
    assign debug_writeback = write_result;
    assign debug_pc = pc_current;
    assign debug_rd = instr[11:7];
    assign debug_halt = (instr == 32'h00100073);    // stop simulation @ ebreak
    
    
    // control signals
    logic RegWrite;
    logic ALUSrcA;
    logic ALUSrcB;
    logic MemRead;
    logic MemWrite;
    logic MemtoReg;
    logic Branch;
    logic JAL;
    logic JALR;
    logic JumpWrite;
    alu_op_t ALUOp;
    alu_ctrl_t ALUctrl;
    
    mem_op_t MemOp;
    
endmodule
