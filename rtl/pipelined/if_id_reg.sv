module if_id_reg (
    input logic clk,
    input logic reset,
    
    input logic [31:0] if_instr,
    input logic [31:0] if_pc,
    input logic [31:0] if_pc_plus_4,
    output logic [31:0] id_instr,
    output logic [31:0] id_pc,
    output logic [31:0] id_pc_plus_4
);

    always_ff @(posedge clk) begin
        if (reset) begin
            id_instr <= 32'h00000013;
            id_pc <= 32'h00000000;
            id_pc_plus_4 <= 32'h00000000;
        end else begin
            id_instr <= if_instr;
            id_pc <= if_pc;
            id_pc_plus_4 <= if_pc_plus_4;
        end
    end

endmodule