module redirect_logic(
    input logic [31:0] pc_plus_imm,
    input logic Branch,
    input logic branch_cond,
    input logic JAL,
    input logic JALR,
    input logic [31:0] alu_result,
    output logic [31:0] redirect_target,
    output logic redirect_taken
);

    always_comb begin
        if (JALR) begin
            redirect_target = alu_result & 32'hFFFFFFFE; // alu_result with bottom bit set to 0
            redirect_taken = 1'b1;
        end else if (JAL || (Branch && branch_cond)) begin
            redirect_target = pc_plus_imm;
            redirect_taken = 1'b1;
        end else begin
            redirect_target = 32'h00000000;
            redirect_taken = 1'b0;
        end
    end

endmodule