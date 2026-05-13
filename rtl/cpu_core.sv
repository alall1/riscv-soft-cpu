import cpu_defs_pkg::*;

module cpu_core(
    input logic clk,
    input logic reset,
    
    output logic [31:0] debug_instr,
    output logic [31:0] debug_alu,
    output logic [31:0] debug_imm,
    output logic [31:0] debug_writeback,
    output logic [31:0] debug_pc_curr,
    output logic [31:0] debug_pc_next
);

    logic [31:0] pc_current, pc_next;       // current pc and next pc
    logic [31:0] pc_plus_4, pc_plus_imm;    // pc+4 and pc+imm
    logic [31:0] instr;                     // current instruction
    logic [31:0] rs1, rs2;                  // data read from reg_file
    logic [31:0] data_result;               // result from data_mem (for load instructions)
    logic [31:0] memtoreg_result;           // result from memtoreg mux
    logic [31:0] write_result;              // result to write to reg_file (through jumpwrite mux)
    logic [31:0] imm;                       // generated immediate from imm_generator
    logic [31:0] alu_src_input;             // selected input_2 into ALU (imm or rs2)
    logic [31:0] alu_result;                // result from ALU
    logic branch_cond;                      // branch_cond result from ALU
    
    assign debug_instr = instr;
    assign debug_alu = alu_result;
    assign debug_imm = imm;
    assign debug_writeback = write_result;
    assign debug_pc_curr = pc_current;
    assign debug_pc_next = pc_next;
    
    
    // control signals
    logic RegWrite;
    logic ALUSrc;
    logic MemRead;
    logic MemWrite;
    logic MemtoReg;
    logic Branch;
    logic JAL;
    logic JALR;
    logic JumpWrite;
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
    adder pc_increment (
        .A(pc_current),
        .B(32'h00000004),
        .S(pc_plus_4)
    );
    
    // PC = PC + imm adder
    adder pc_branch (
        .A(pc_current),
        .B(imm),
        .S(pc_plus_imm)
    );
    
    // PC_next logic
    pc_next_logic pc_logic (
        .pc_plus_4(pc_plus_4),
        .pc_plus_imm(pc_plus_imm),
        .Branch(Branch),
        .branch_cond(branch_cond),
        .JAL(JAL),
        .JALR(JALR),
        .alu_result(alu_result),
        .pc_next(pc_next)
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
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .Branch(Branch),
        .JAL(JAL),
        .JALR(JALR),
        .JumpWrite(JumpWrite),
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
        .write_data(write_result),
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
    
    // ALU
    alu alu_unit (
        .ALUctrl(ALUctrl),
        .input_1(rs1),
        .input_2(alu_src_input),
        .result(alu_result),
        .branch_cond(branch_cond)
    );
    
    // data memory
    data_memory data_mem (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(alu_result),
        .write_data(rs2),
        .read_data(data_result)
    );
    
    // memtoreg mux -> jumpwrite mux input
    mux32 memtoreg_mux (
        .A(alu_result),
        .B(data_result),
        .sel(MemtoReg),
        .result(memtoreg_result)
    );
    
    // jumpwrite mux -> reg_file.write_data
    mux32 jumpwrite_mux (
        .A(memtoreg_result),
        .B(pc_plus_4),
        .sel(JumpWrite),
        .result(write_result)
    );
    
endmodule
