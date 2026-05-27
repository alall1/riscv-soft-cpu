module if_stage #(
    parameter string PROGRAM_FILE = "program_file.mem"
)(
    input logic clk,
    input logic reset,
    
    input logic [31:0] redirect_target,
    input logic redirect_taken,
    
    output logic [31:0] if_instr,
    output logic [31:0] if_pc,
    output logic [31:0] if_pc_plus_4
);

    logic [31:0] pc;
    logic [31:0] pc_next;
    logic [31:0] pc_plus_4;

    pc prog_counter (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );
    
    adder pc_adder (
        .A(pc),
        .B(32'h00000004),
        .S(pc_plus_4)
    );
    
    mux32 pc_mux (
        .A(pc_plus_4),
        .B(redirect_target),
        .sel(redirect_taken),
        .result(pc_next)
    );
    
    instr_memory #(
        .PROGRAM_FILE(PROGRAM_FILE)
    ) instr_mem (
        .addr(pc),
        .instr(if_instr)
    );
    
    assign if_pc = pc;
    assign if_pc_plus_4 = pc_plus_4;

endmodule