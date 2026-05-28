import cpu_defs_pkg::*;

module data_memory #(
    parameter int DEPTH = 64
)(
    input logic clk,
    input logic MemRead,
    input logic MemWrite,
    input mem_op_t MemOp,   // funct3 from instruction
    input logic [31:0] addr,
    input logic [31:0] write_data,
    output logic [31:0] read_data
);

    logic [7:0] mem [0:(4*DEPTH)-1];   // byte-addressed, DEPTH*4 because DEPTH is 
    
    initial begin
        for (int i = 0; i < 4*DEPTH; i++) begin
            mem[i] = 8'h00;  // initialize all memory to 0
        end
    end
    
    always_ff @(posedge clk) begin
        if (MemWrite) begin
            case (MemOp)
                MEM_BYTE: begin
                    mem[addr] <= write_data[7:0];
                end
                
                MEM_HALF: begin
                    mem[addr] <= write_data[7:0];
                    mem[addr + 1] <= write_data[15:8];
                end
                
                MEM_WORD: begin
                    mem[addr] <= write_data[7:0];
                    mem[addr + 1] <= write_data[15:8];
                    mem[addr + 2] <= write_data[23:16];
                    mem[addr + 3] <= write_data[31:24];
                end
            endcase
        end
    end

    always_comb begin
        read_data = 32'h00000000;
        if (MemRead) begin
            case (MemOp)
                MEM_BYTE: begin
                    read_data = {{24{mem[addr][7]}}, mem[addr]};
                end
                
                MEM_HALF: begin
                    read_data = {{16{mem[addr + 1][7]}}, mem[addr + 1], mem[addr]};
                end
                
                MEM_WORD: begin
                    read_data = {mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr]};
                end
                
                MEM_BYTE_U: begin
                    read_data = {24'b0, mem[addr]};
                end
                
                MEM_HALF_U: begin
                    read_data = {16'b0, mem[addr + 1], mem[addr]};
                end
                
                default: begin
                    read_data = 32'h00000000;
                end
            endcase
        end
    end

endmodule
