module mem_stage(
    input logic clk,
    input logic reset,
    
    input logic [31:0] alu_result,
    input logic [31:0] store_data,
    
    // control signals
    input logic MemRead,
    input logic MemWrite,
    input mem_op_t MemOp,
    
    output logic [31:0] read_data
);

endmodule