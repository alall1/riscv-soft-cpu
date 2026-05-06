import cpu_defs_pkg::*;

module control_unit(
    input logic [6:0] opcode,
    output logic RegWrite,
    output logic ALUSrc,
    output alu_op_t ALUOp
);

    always_comb begin
        RegWrite = 1'b0;
        ALUSrc = 1'b0;
        ALUOp = ALUOP_ADD;
        
        case (opcode)
            OPCODE_RTYPE: begin     // R-type instructions
                RegWrite = 1'b1;
                ALUSrc = 1'b0;
                ALUOp = ALUOP_RTYPE;
            end
            
            OPCODE_ITYPE: begin     // I-type instructions (not loads)
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUOp = ALUOP_ITYPE;
            end
            
            default: begin          // default case
                RegWrite = 1'b0;
                ALUSrc = 1'b0;
                ALUOp = ALUOP_ADD;
            end
        endcase
    end

endmodule
