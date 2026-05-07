module data_memory #(
    parameter int DEPTH = 64
)(
    input logic clk,
    input logic MemRead,
    input logic MemWrite,
    input logic [31:0] addr,
    input logic [31:0] write_data,
    output logic [31:0] read_data
);

    logic [31:0] mem [0:DEPTH-1];   // word-addressed for now, change to byte-addressed later
    
    initial begin
        for (int i = 0; i < DEPTH; i++) begin
            mem[i] = 32'h00000000;  // initialize all memory to 0
        end
    end
    
    always_ff @(posedge clk) begin
        if (MemWrite) begin
            if (addr[31:2] < DEPTH) // verifying addr is in-range
                mem[addr[31:2]] <= write_data;
        end
    end

    always_comb begin
        read_data = 32'h00000000;
        if (MemRead) begin
            if (addr[31:2] < DEPTH) // verifying addr is in-range
                read_data = mem[addr[31:2]];
        end
    end

endmodule
