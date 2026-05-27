import cpu_defs_pkg::*;

module alu(
    input alu_ctrl_t ALUctrl,
    input logic [31:0] input_1,
    input logic [31:0] input_2,
    output logic [31:0] result,
    output logic branch_cond
);

    always_comb begin
        result = 32'h00000000;
        branch_cond = 1'b0;
        
        case (ALUctrl)
            ALU_ADD: result = input_1 + input_2;
            ALU_SUB: result = input_1 - input_2;
            ALU_AND: result = input_1 & input_2;
            ALU_OR: result = input_1 | input_2;
            ALU_XOR: result = input_1 ^ input_2;
            ALU_SLL: result = input_1 << input_2[4:0];
            ALU_SRL: result = input_1 >> input_2[4:0];
            ALU_SRA: result = $signed(input_1) >>> input_2[4:0];
            ALU_SLT: result = ($signed(input_1) < $signed(input_2)) ? 32'h00000001 : 32'h00000000;
            ALU_SLTU: result = (input_1 < input_2) ? 32'h00000001 : 32'h00000000;
            ALU_BEQ: branch_cond = (input_1 == input_2);
            ALU_BNE: branch_cond = (input_1 != input_2);
            ALU_BLT: branch_cond = ($signed(input_1) < $signed(input_2));
            ALU_BGE: branch_cond = ($signed(input_1) >= $signed(input_2));
            ALU_BLTU: branch_cond = (input_1 < input_2);
            ALU_BGEU: branch_cond = (input_1 >= input_2);
            ALU_LUI: result = input_2;
            
            default begin
                result = 32'h00000000;
                branch_cond = 1'b0;
            end
        endcase
    end

endmodule