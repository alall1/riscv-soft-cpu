import cpu_defs_pkg::*;

module cpu_core(
    input logic clk,
    input logic reset,
    
    output logic [31:0] debug_pc,
    output logic [31:0] debug_instr,
    output logic [31:0] debug_alu
);

    logic [31:0] pc_current, pc_next;   // current pc and next pc
    logic [31:0] instr;                 // current instruction
    logic [31:0] rs1, rs2;              // data read from reg_file
    logic [31:0] alu_result;            // result from ALU
    
    assign debug_pc = pc_current;
    assign debug_instr = instr;
    assign debug_alu = alu_result;
    
    // control signals
    logic RegWrite;
    alu_op_t ALUOp;              
    alu_ctrl_t ALUctrl;
    
    pc program_counter (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc_current)
    );
    
    adder pc_adder (
        .A(pc_current),
        .B(32'h00000004),
        .S(pc_next)
    );
    
    instr_memory instr_mem (
        .addr(pc_current),
        .instr(instr)
    );
    
    control_unit c_unit (
        .opcode(instr[6:0]),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp)
    );
    
    alu_control alu_c_unit (
        .ALUOp(ALUOp),
        .funct7(instr[31:25]),
        .funct3(instr[14:12]),
        .ALUctrl(ALUctrl)
    );
    
    reg_file register_file (
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWrite),
        .rs1_addr(instr[19:15]),
        .rs2_addr(instr[24:20]),
        .rd_addr(instr[11:7]),
        .write_data(alu_result),
        .rs1_data(rs1),
        .rs2_data(rs2)
    );

    alu alu_unit (
        .ALUctrl(ALUctrl),
        .input_1(rs1),
        .input_2(rs2),
        .result(alu_result)
    );
    
endmodule
