import cpu_defs_pkg::*;

module imm_generator(
    input logic [31:0] instr,
    output logic [31:0] imm
);

    always_comb begin
        case (instr[6:0])
            OPCODE_ITYPE,
            OPCODE_LOADS,
            OPCODE_JALR: begin
                imm = {{20{instr[31]}}, instr[31:20]};
            end
            
            OPCODE_STYPE: begin
                imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            end
            
            OPCODE_BTYPE: begin
                imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            end
            
            OPCODE_JAL: begin
                imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
            end
            
            OPCODE_LUI,
            OPCODE_AUIPC: begin
                imm = {instr[31:12], 12'h000};
            end
            
            default: begin
                imm = 32'h00000000;
            end
        endcase       
    end

endmodule
