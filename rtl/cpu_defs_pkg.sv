package cpu_defs_pkg;

    // opcodes
    localparam logic [6:0] OPCODE_RTYPE = 7'b0110011;
    localparam logic [6:0] OPCODE_ITYPE = 7'b0010011;   // I-type (not loads)
    localparam logic [6:0] OPCODE_LOADS = 7'b0000011;   // I-type (loads)
    localparam logic [6:0] OPCODE_STYPE = 7'b0100011;

    typedef enum logic [2:0] {  // ALUOp encodings
        ALUOP_ADD    = 3'b000,
        ALUOP_RTYPE  = 3'b001,
        ALUOP_ITYPE  = 3'b010,
        ALUOP_LOADS  = 3'b011,
        ALUOP_STYPE  = 3'b100
    } alu_op_t;

    typedef enum logic [3:0] {  // ALUctrl encodings
        ALU_ADD    = 4'b0000,
        ALU_SUB    = 4'b0001,
        ALU_AND    = 4'b0010,
        ALU_OR     = 4'b0011,
        ALU_XOR    = 4'b0100,
        ALU_SLL    = 4'b0101,
        ALU_SRL    = 4'b0110,
        ALU_SRA    = 4'b0111,
        ALU_SLT    = 4'b1000,
        ALU_SLTU   = 4'b1001
    } alu_ctrl_t;

endpackage