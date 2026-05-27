module mem_wb_reg (
    input logic clk,
    input logic reset,
    
    input logic [31:0] mem_alu_result,
    input logic [31:0] mem_read_data,
    input logic [31:0] mem_pc_plus_4,
    input logic [4:0] mem_rd_addr,
    
    output logic [31:0] wb_alu_result,
    output logic [31:0] wb_read_data,
    output logic [31:0] wb_pc_plus_4,
    output logic [4:0] wb_rd_addr,
    
    // control signals
    input logic mem_RegWrite,
    input logic mem_MemtoReg,
    input logic mem_JumpWrite,
    
    output logic wb_RegWrite,
    output logic wb_MemtoReg,
    output logic wb_JumpWrite
);

    always_ff @(posedge clk) begin
        if (reset) begin
            wb_alu_result <= 32'h00000000;
            wb_read_data <= 32'h00000000;
            wb_pc_plus_4 <= 32'h00000000;
            wb_rd_addr <= 5'b00000;
            
            // control signals
            wb_RegWrite <= 1'b0;
            wb_MemtoReg <= 1'b0;
            wb_JumpWrite <= 1'b0;
        end else begin
            wb_alu_result <= mem_alu_result;
            wb_read_data <= mem_read_data;
            wb_pc_plus_4 <= mem_pc_plus_4;
            wb_rd_addr <= mem_rd_addr;
            
            // control signals
            wb_RegWrite <= mem_RegWrite;
            wb_MemtoReg <= mem_MemtoReg;
            wb_JumpWrite <= mem_JumpWrite;
        end
    end

endmodule