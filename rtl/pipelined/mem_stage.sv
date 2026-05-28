import cpu_defs_pkg::*;

module mem_stage(
    input logic clk,
    
    input logic [31:0] alu_result,
    input logic [31:0] store_data,
    
    // control signals
    input logic MemRead,
    input logic MemWrite,
    input mem_op_t MemOp,
    
    output logic [31:0] mem_read_data
);

    data_memory data_mem (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemOp(MemOp),
        .addr(alu_result),
        .write_data(store_data),
        .read_data(mem_read_data)
    );

endmodule