import cpu_defs_pkg::*;

module ex_stage(
    input logic [31:0] rs1_data,
    input logic [31:0] rs2_data,
    input logic [31:0] imm,
    input logic [31:0] pc,
    
    // control signals
    input logic ALUSrcA,
    input logic ALUSrcB,
    input alu_ctrl_t ALUctrl,
    input logic Branch,
    input logic JAL,
    input logic JALR,
    
    output logic [31:0] ex_alu_result,
    output logic [31:0] ex_redirect_target,
    output logic ex_redirect_taken
);

    logic [31:0] input_1;   // input_1 into ALU
    logic [31:0] input_2;   // input_2 into ALU
    logic branch_cond;      // output branch_cond from ALU, if Branch and branch_cond, redirect_taken = 1
    logic [31:0] pc_plus_imm;
    logic [31:0] alu_result;
    
    mux32 ALUSrcA_mux (
        .A(rs2_data),
        .B(imm),
        .sel(ALUSrcA),
        .result(input_2)
    );
    
    mux32 ALUSrcB_mux (
        .A(rs1_data),
        .B(pc),
        .sel(ALUSrcB),
        .result(input_1)
    );
    
    alu alu_unit (
        .ALUctrl(ALUctrl),
        .input_1(input_1),
        .input_2(input_2),
        .result(alu_result),
        .branch_cond(branch_cond)
    );
    
    adder pc_adder (
        .A(pc),
        .B(imm),
        .S(pc_plus_imm)
    );
    
    redirect_logic redirect_log (
        .pc_plus_imm(pc_plus_imm),
        .Branch(Branch),
        .branch_cond(branch_cond),
        .JAL(JAL),
        .JALR(JALR),
        .alu_result(alu_result),
        .redirect_target(ex_redirect_target),
        .redirect_taken(ex_redirect_taken)
    );
    
    assign ex_alu_result = alu_result;

endmodule