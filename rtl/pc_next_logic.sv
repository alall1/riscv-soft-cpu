module pc_next_logic(
    input logic [31:0] pc_plus_4,
    input logic [31:0] pc_plus_imm,
    input logic Branch,
    input logic branch_cond,
    output logic [31:0] pc_next
);

    always_comb begin
        pc_next = (Branch && branch_cond) ? pc_plus_imm : pc_plus_4;
    end

endmodule
