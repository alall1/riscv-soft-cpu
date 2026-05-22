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
            ALUOP_RTYPE: begin  // R-type ops
                case ({funct7, funct3})
                    {7'b0000000, 3'b000}: ALUctrl = ALU_ADD;
                    {7'b0100000, 3'b000}: ALUctrl = ALU_SUB;
                    default: ALUctrl = ALU_ADD;
                endcase
            end
            
            ALUOP_ITYPE: begin  // I-type ops (not loads)
                case (funct3)
                    3'b000: ALUctrl = ALU_ADD;
                    default: ALUctrl = ALU_ADD;
                endcase
            end
            
            ALUOP_LOADS,        // I-type load ops
            ALUOP_STYPE: begin  // S-type ops
                ALUctrl = ALU_ADD;
            end
            
            ALUOP_BTYPE: begin  // B-type ops
                case (funct3)
                    3'b000: ALUctrl = ALU_BEQ;
                    3'b001: ALUctrl = ALU_BNE;
                    3'b100: ALUctrl = ALU_BLT;
                    3'b101: ALUctrl = ALU_BGE;
                    3'b110: ALUctrl = ALU_BLTU;
                    3'b111: ALUctrl = ALU_BGEU;
                    default: ALUctrl = ALU_BEQ;
                endcase
            end
            
            ALUOP_JALR: begin   // JALR
                ALUctrl = ALU_ADD;
            end
            
            ALUOP_LUI: begin    // LUI (result = imm)
                ALUctrl = ALU_LUI;
            end
            
            default: begin
                ALUctrl = ALU_ADD;
            end

        endcase
     end

endmodule
