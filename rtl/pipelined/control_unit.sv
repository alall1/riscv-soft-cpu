import cpu_defs_pkg::*;

module control_unit(
    input logic [6:0] opcode,
    output logic RegWrite,
    output logic ALUSrcA,   // ALUSrcA is for mux to choose between rs2 and imm
    output logic ALUSrcB,   // ALUSrcB is for mux to choose between rs1 and PC (specifically for AUIPC)
    output logic MemRead,
    output logic MemWrite,
    output logic MemtoReg,
    output logic Branch,
    output logic JAL,
    output logic JALR,
    output logic JumpWrite, // JumpWrite controls mux to select for writing PC + 4 to rd
    output alu_op_t ALUOp,
    
    output logic uses_rs1,
    output logic uses_rs2
);

    always_comb begin
        unique case (opcode)
            OPCODE_RTYPE: begin     // R-type instructions
                RegWrite = 1'b1;
                ALUSrcA = 1'b0;
                ALUSrcB = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                Branch = 1'b0;
                JAL = 1'b0;
                JALR = 1'b0;
                JumpWrite = 1'b0;
                ALUOp = ALUOP_RTYPE;
                
                uses_rs1 = 1'b1;
                uses_rs2 = 1'b1;
            end
            
            OPCODE_ITYPE: begin     // I-type instructions (not loads)
                RegWrite = 1'b1;
                ALUSrcA = 1'b1;
                ALUSrcB = 1'b0;
                MemRead = 1'b0; 
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                Branch = 1'b0;
                JAL = 1'b0;
                JALR = 1'b0;
                JumpWrite = 1'b0;
                ALUOp = ALUOP_ITYPE;
                
                uses_rs1 = 1'b1;
                uses_rs2 = 1'b0;
            end
            
            OPCODE_LOADS: begin     // I-type instructions (loads)
                RegWrite = 1'b1;
                ALUSrcA = 1'b1;
                ALUSrcB = 1'b0;
                MemRead = 1'b1;
                MemWrite = 1'b0;
                MemtoReg = 1'b1;
                Branch = 1'b0;
                JAL = 1'b0;
                JALR = 1'b0;
                JumpWrite = 1'b0;
                ALUOp = ALUOP_LOADS;
                
                uses_rs1 = 1'b1;
                uses_rs2 = 1'b0;
            end
            
            OPCODE_STYPE: begin     // S-type instructions
                RegWrite = 1'b0;
                ALUSrcA = 1'b1;
                ALUSrcB = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b1;
                MemtoReg = 1'b0;
                Branch = 1'b0;
                JAL = 1'b0;
                JALR = 1'b0;
                JumpWrite = 1'b0;
                ALUOp = ALUOP_STYPE;
                
                uses_rs1 = 1'b1;
                uses_rs2 = 1'b1;
            end
            
            OPCODE_BTYPE: begin     // B-type instructions
                RegWrite = 1'b0;
                ALUSrcA = 1'b0;
                ALUSrcB = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                Branch = 1'b1;
                JAL = 1'b0;
                JALR = 1'b0;
                JumpWrite = 1'b0;
                ALUOp = ALUOP_BTYPE;
                
                uses_rs1 = 1'b1;
                uses_rs2 = 1'b1;
            end
            
            OPCODE_JAL: begin     // JAL instructions
                RegWrite = 1'b1;
                ALUSrcA = 1'b0;
                ALUSrcB = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                Branch = 1'b0;
                JAL = 1'b1;
                JALR = 1'b0;
                JumpWrite = 1'b1;
                ALUOp = ALUOP_ADD;
                
                uses_rs1 = 1'b0;
                uses_rs2 = 1'b0;
            end
            
            OPCODE_JALR: begin     // JALR instructions
                RegWrite = 1'b1;
                ALUSrcA = 1'b1;
                ALUSrcB = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                Branch = 1'b0;
                JAL = 1'b0;
                JALR = 1'b1;
                JumpWrite = 1'b1;
                ALUOp = ALUOP_JALR;
                
                uses_rs1 = 1'b1;
                uses_rs2 = 1'b0;
            end
            
            OPCODE_LUI: begin     // LUI instruction
                RegWrite = 1'b1;
                ALUSrcA = 1'b1;     // ALU will do 0 + imm
                ALUSrcB = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                Branch = 1'b0;
                JAL = 1'b0;
                JALR = 1'b0;
                JumpWrite = 1'b0;
                ALUOp = ALUOP_LUI;
                
                uses_rs1 = 1'b0;
                uses_rs2 = 1'b0;
            end
            
            OPCODE_AUIPC: begin     // AUIPC instruction
                RegWrite = 1'b1;
                ALUSrcA = 1'b1;
                ALUSrcB = 1'b1;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                Branch = 1'b0;
                JAL = 1'b0;
                JALR = 1'b0;
                JumpWrite = 1'b0;
                ALUOp = ALUOP_ADD;
                
                uses_rs1 = 1'b0;
                uses_rs2 = 1'b0;
            end
            
            OPCODE_EBREAK: begin    // ebreak
                RegWrite = 1'b0;
                ALUSrcA = 1'b0;
                ALUSrcB = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                Branch = 1'b0;
                JAL = 1'b0;
                JALR = 1'b0;
                JumpWrite = 1'b0;
                ALUOp = ALUOP_ADD;
                
                uses_rs1 = 1'b0;
                uses_rs2 = 1'b0;
            end
            
            default: begin          // default case (invalid opcode)
                RegWrite = 1'b0;
                ALUSrcA = 1'b0;
                ALUSrcB = 1'b0;
                MemRead = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                Branch = 1'b0;
                JAL = 1'b0;
                JALR = 1'b0;
                JumpWrite = 1'b0;
                ALUOp = ALUOP_ADD;
                
                uses_rs1 = 1'b0;
                uses_rs2 = 1'b0;
            end
        endcase
    end

endmodule
