module pc_next_logic(
    input logic [31:0] pc_plus_4,
    input logic [31:0] pc_plus_imm,
    input logic Branch,
    input logic branch_cond,
    input logic JAL,
    input logic JALR,
    input logic [31:0] alu_result,
    output logic [31:0] pc_next
);

    always_comb begin
        if (JALR) begin
            pc_next = alu_result & 32'hFFFFFFFE; // alu_result with bottom bit set to 0
        end else if (JAL || (Branch && branch_cond)) begin
            pc_next = pc_plus_imm;
        end else begin
            pc_next = pc_plus_4;
        end
    end

endmodule
