package cpu_defs_pkg;

    // opcodes
    localparam logic [6:0] OPCODE_RTYPE = 7'b0110011;
    localparam logic [6:0] OPCODE_ITYPE = 7'b0010011;   // I-type (not loads)
    localparam logic [6:0] OPCODE_LOADS = 7'b0000011;   // I-type (loads)
    localparam logic [6:0] OPCODE_STYPE = 7'b0100011;
    localparam logic [6:0] OPCODE_BTYPE = 7'b1100011;
    localparam logic [6:0] OPCODE_JAL = 7'b1101111;
    localparam logic [6:0] OPCODE_JALR = 7'b1100111;
    localparam logic [6:0] OPCODE_LUI = 7'b0110111;
    localparam logic [6:0] OPCODE_AUIPC = 7'b0010111;

    typedef enum logic [2:0] {  // ALUOp encodings
        ALUOP_ADD    = 3'b000,
        ALUOP_RTYPE  = 3'b001,
        ALUOP_ITYPE  = 3'b010,
        ALUOP_LOADS  = 3'b011,
        ALUOP_STYPE  = 3'b100,
        ALUOP_BTYPE  = 3'b101,
        ALUOP_JALR   = 3'b110,
        ALUOP_LUI    = 3'b111
    } alu_op_t;

    typedef enum logic [4:0] {  // ALUctrl encodings
        ALU_ADD    = 5'b00000,
        ALU_SUB    = 5'b00001,
        ALU_AND    = 5'b00010,
        ALU_OR     = 5'b00011,
        ALU_XOR    = 5'b00100,
        ALU_SLL    = 5'b00101,
        ALU_SRL    = 5'b00110,
        ALU_SRA    = 5'b00111,
        ALU_SLT    = 5'b01000,
        ALU_SLTU   = 5'b01001,
        ALU_BEQ    = 5'b01010,
        ALU_BNE    = 5'b01011,
        ALU_BLT    = 5'b01100,
        ALU_BGE    = 5'b01101,
        ALU_BLTU   = 5'b01110,
        ALU_BGEU   = 5'b01111,
        ALU_LUI    = 5'b10000
    } alu_ctrl_t;

endpackage