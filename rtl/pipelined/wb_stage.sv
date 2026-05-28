module wb_stage(  
    input logic [31:0] alu_result,
    input logic [31:0] read_data,
    input logic [31:0] pc_plus_4,
    
    // control signals
    input logic MemtoReg,
    input logic JumpWrite,
    
    output logic [31:0] write_data
);

    logic [31:0] mem_or_res;    // result of MemtoReg mux (either alu_result or read_data)

    mux32 MemtoReg_mux (
        .A(alu_result),
        .B(read_data),
        .sel(MemtoReg),
        .result(mem_or_res)
    );
    
    mux32 JumpWrite_mux (
        .A(mem_or_res),
        .B(pc_plus_4),
        .sel(JumpWrite),
        .result(write_data)
    );

endmodule