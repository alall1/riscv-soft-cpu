import cpu_defs_pkg::*;

module control_unit(
    input logic [6:0] opcode,
    output logic RegWrite,
    output alu_op_t ALUOp
);

    always_comb begin
        RegWrite = 1'b0;
        ALUOp = ALUOP_ADD;
        
        case (opcode)
            OPCODE_RTYPE: begin // R-type instructions
                RegWrite = 1'b1;
                ALUOp = ALUOP_RTYPE;
            end
            
            default: begin // default case
            end
        endcase
    end

endmodule
