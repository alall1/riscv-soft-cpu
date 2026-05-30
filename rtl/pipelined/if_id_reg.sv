module if_id_reg (
    input logic clk,
    input logic reset,
    
    input logic if_id_flush,
    
    input logic [31:0] if_instr,
    input logic [31:0] if_pc,
    input logic [31:0] if_pc_plus_4,
    input logic if_is_ebreak,
    
    output logic [31:0] id_instr,
    output logic [31:0] id_pc,
    output logic [31:0] id_pc_plus_4,
    output logic id_is_ebreak
);

    always_ff @(posedge clk) begin
        if (reset) begin
            id_instr <= 32'h00000013;
            id_pc <= 32'h00000000;
            id_pc_plus_4 <= 32'h00000000;
            id_is_ebreak <= 1'b0;
        end else if (if_id_flush) begin
            id_instr <= 32'h00000013;
            id_pc <= 32'h00000000;
            id_pc_plus_4 <= 32'h00000000;
            id_is_ebreak <= 1'b0;
        end else begin
            id_instr <= if_instr;
            id_pc <= if_pc;
            id_pc_plus_4 <= if_pc_plus_4;
            id_is_ebreak <= if_is_ebreak;
        end
    end

endmodule