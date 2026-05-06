import cpu_defs_pkg::*;

module cpu_core(
    input logic clk,
    input logic reset,
    
    output logic [31:0] debug_pc,
    output logic [31:0] debug_instr,
    output logic [31:0] debug_alu,
    output logic [31:0] debug_imm
);

    logic [31:0] pc_current, pc_next;   // current pc and next pc
    logic [31:0] instr;                 // current instruction
    logic [31:0] rs1, rs2;              // data read from reg_file
    logic [31:0] alu_result;            // result from ALU
    logic [31:0] imm;                   // generated immediate from imm_generator
    logic [31:0] alu_src_input;            // selected input_2 into ALU (imm or rs2)
    
    assign debug_pc = pc_current;
    assign debug_instr = instr;
    assign debug_alu = alu_result;
    assign debug_imm = imm;
    
    
    // control signals
    logic RegWrite;
    logic ALUSrc;
    alu_op_t ALUOp;              
    alu_ctrl_t ALUctrl;
    
    // program counter
    pc program_counter (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc_current)
    );
    
    // PC = PC + 4 adder
    adder pc_adder (
        .A(pc_current),
        .B(32'h00000004),
        .S(pc_next)
    );
    
    // instruction memory
    instr_memory instr_mem (
        .addr(pc_current),
        .instr(instr)
    );
    
    // control unit
    control_unit c_unit (
        .opcode(instr[6:0]),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp)
    );
    
    // alu control unit
    alu_control alu_c_unit (
        .ALUOp(ALUOp),
        .funct7(instr[31:25]),
        .funct3(instr[14:12]),
        .ALUctrl(ALUctrl)
    );
    
    // register file
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
    
    // immediate generator
    imm_generator imm_gen (
        .instr(instr),
        .imm(imm)
    );
    
    // ALUSrc mux
    mux32 alu_src_mux (
        .A(rs2),
        .B(imm),
        .sel(ALUSrc),
        .result(alu_src_input)
    );

    alu alu_unit (
        .ALUctrl(ALUctrl),
        .input_1(rs1),
        .input_2(alu_src_input),
        .result(alu_result)
    );
    
endmodule
