module instr_memory #(
    parameter int DEPTH = 64
)(
    input logic [31:0] addr,
    output logic [31:0] instr    
);
    
    logic [31:0] mem [0:DEPTH-1];
    
    initial begin
        for (int i = 0; i < DEPTH; i++) begin
            mem[i] = 32'h00000033; // (NOP) add x0, x0, x0
        end
    end
    
    always_comb begin
        if (addr[31:2] < DEPTH) // verifying PC is in-range
            instr = mem[addr[31:2]];
        else
            instr = 32'h00000033; // (NOP) add x0, x0, x0
    end
    
endmodule