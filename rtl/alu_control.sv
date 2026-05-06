import cpu_defs_pkg::*;

module alu_control(
    input alu_op_t ALUOp,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    output alu_ctrl_t ALUctrl
);

    always_comb begin
        ALUctrl = ALU_ADD;
        
        case (ALUOp)
            ALUOP_RTYPE: begin // R-type ops
                case ({funct7, funct3})
                    {7'b0000000, 3'b000}: ALUctrl = ALU_ADD;
                    {7'b0100000, 3'b000}: ALUctrl = ALU_SUB;
                    default: ALUctrl = ALU_ADD;
                endcase
            end
            
            default: begin
                ALUctrl = ALU_ADD;
            end

        endcase
     end

endmodule
