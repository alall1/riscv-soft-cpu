import cpu_defs_pkg::*;

module imm_generator(
    input logic [31:0] instr,
    output logic [31:0] imm
);

    always_comb begin
        case (instr[6:0])
            OPCODE_ITYPE: begin
                imm = {{20{instr[31]}}, instr[31:20]};
            end
            
            default: begin
                imm = 32'h00000000;
            end
        endcase       
    end

endmodule
