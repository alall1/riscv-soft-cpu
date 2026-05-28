module ex_mem_reg (
    input logic clk,
    input logic reset,
    
    input logic [31:0] ex_alu_result,
    input logic [31:0] ex_store_data,
    input logic [31:0] ex_pc_plus_4,
    input logic [4:0] ex_rd_addr,
    input logic ex_is_ebreak,
    
    output logic [31:0] mem_alu_result,
    output logic [31:0] mem_store_data,
    output logic [31:0] mem_pc_plus_4,
    output logic [4:0] mem_rd_addr,
    output logic mem_is_ebreak,
    
    // control signals
    input logic ex_RegWrite,
    input logic ex_MemRead,
    input logic ex_MemWrite,
    input logic ex_MemtoReg,
    input logic ex_JumpWrite,
    input mem_op_t ex_MemOp,
    
    output logic mem_RegWrite,
    output logic mem_MemRead,
    output logic mem_MemWrite,
    output logic mem_MemtoReg,
    output logic mem_JumpWrite,
    output mem_op_t mem_MemOp
);

    always_ff @(posedge clk) begin
        if (reset) begin
            mem_alu_result <= 32'h00000000;
            mem_store_data <= 32'h00000000;
            mem_pc_plus_4 <= 32'h00000000;
            mem_rd_addr <= 5'b00000;
            mem_is_ebreak <= 1'b0;
            
            // control signals
            mem_RegWrite <= 1'b0;
            mem_MemRead <= 1'b0;
            mem_MemWrite <= 1'b0;
            mem_MemtoReg <= 1'b0;
            mem_JumpWrite <= 1'b0;
            mem_MemOp <= MEM_WORD;
        end else begin
            mem_alu_result <= ex_alu_result;
            mem_store_data <= ex_store_data;
            mem_pc_plus_4 <= ex_pc_plus_4;
            mem_rd_addr <= ex_rd_addr;
            mem_is_ebreak <= ex_is_ebreak;
            
            // control signals
            mem_RegWrite <= ex_RegWrite;
            mem_MemRead <= ex_MemRead;
            mem_MemWrite <= ex_MemWrite;
            mem_MemtoReg <= ex_MemtoReg;
            mem_JumpWrite <= ex_JumpWrite;
            mem_MemOp <= ex_MemOp;
        end
    end

endmodule