import cpu_defs_pkg::*;

module control_unit(
    input logic [6:0] opcode,
    output logic RegWrite,
    output logic ALUSrc,
    output logic MemRead,
    output logic MemWrite,
    output logic MemtoReg,
    output logic Branch,
    output alu_op_t ALUOp
);

    always_comb begin
        RegWrite = 1'b0;
        ALUSrc = 1'b0;
        ALUOp = ALUOP_ADD;
        
        unique case (opcode)
            OPCODE_RTYPE: begin     // R-type instructions
                RegWrite = 1'b1;
                ALUSrc = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                Branch = 1'b0;
                ALUOp = ALUOP_RTYPE;
            end
            
            OPCODE_ITYPE: begin     // I-type instructions (not loads)
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                MemRead = 1'b0; 
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                Branch = 1'b0;
                ALUOp = ALUOP_ITYPE;
            end
            
            OPCODE_LOADS: begin     // I-type instructions (loads)
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                MemRead = 1'b1;
                MemWrite = 1'b0;
                MemtoReg = 1'b1;
                Branch = 1'b0;
                ALUOp = ALUOP_LOADS;
            end
            
            OPCODE_STYPE: begin     // S-type instructions
                RegWrite = 1'b0;
                ALUSrc = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b1;
                MemtoReg = 1'b0;
                Branch = 1'b0;
                ALUOp = ALUOP_STYPE;
            end
            
            OPCODE_BTYPE: begin     // B-type instructions
                RegWrite = 1'b0;
                ALUSrc = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                Branch = 1'b1;
                ALUOp = ALUOP_BTYPE;
            end
            
            default: begin          // default case (invalid opcode)
                RegWrite = 1'b0;
                ALUSrc = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                Branch = 1'b0;
                ALUOp = ALUOP_ADD;
            end
        endcase
    end

endmodule
