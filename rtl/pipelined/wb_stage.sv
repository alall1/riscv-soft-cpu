module wb_stage(  
    input logic [31:0] alu_result,
    input logic [31:0] read_data,
    input logic [31:0] pc_plus_4,
    
    // control signals
    input logic MemtoReg,
    input logic JumpWrite,
    
    output logic [31:0] write_data
);

endmodule