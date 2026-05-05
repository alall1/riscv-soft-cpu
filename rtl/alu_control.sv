import cpu_defs_pkg::*;

module alu_control(
    input alu_op_t ALUOp,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    output alu_ctrl_t alu_ctrl
);

    always_comb begin
        alu_ctrl = ALU_ADD;
        
        case (ALUOp)
            ALUOP_RTYPE: begin // R-type ops
                case ({funct7, funct3})
                    {7'b0000000, 3'b000}: alu_ctrl = ALU_ADD;
                    default: alu_ctrl = ALU_ADD;
                endcase
            end
            
            default: begin
            end
            
        endcase
     end

endmodule
