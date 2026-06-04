module hazard_unit(
    input logic redirect_taken,
    
    input logic [4:0] id_rs1_addr,
    input logic [4:0] id_rs2_addr,
    input logic id_uses_rs1,
    input logic id_uses_rs2,
    
    input logic [4:0] id_ex_rd_addr,
    input logic id_ex_RegWrite,
    
    input logic [4:0] ex_mem_rd_addr,
    input logic ex_mem_RegWrite,
    
    input logic [4:0] mem_wb_rd_addr,
    input logic mem_wb_RegWrite,
    
    output logic if_id_flush,
    output logic id_ex_flush,
    
    output logic pc_stall,
    output logic if_id_stall
);

    logic rs1_hazard;
    logic rs2_hazard;
    logic raw_stall;

    always_comb begin
        rs1_hazard = 1'b0;
        rs2_hazard = 1'b0;
        raw_stall  = 1'b0;

        if (id_uses_rs1 && (id_rs1_addr != 5'd0)) begin
            rs1_hazard =
                (id_ex_RegWrite  && (id_rs1_addr == id_ex_rd_addr))
                || (ex_mem_RegWrite && (id_rs1_addr == ex_mem_rd_addr));
//                || (mem_wb_RegWrite && (id_rs1_addr == mem_wb_rd_addr)); // uncomment this line and remove semicolon above to disable half-cycle-WB
        end

        if (id_uses_rs2 && (id_rs2_addr != 5'd0)) begin
            rs2_hazard =
                (id_ex_RegWrite  && (id_rs2_addr == id_ex_rd_addr))
                || (ex_mem_RegWrite && (id_rs2_addr == ex_mem_rd_addr));
//                || (mem_wb_RegWrite && (id_rs2_addr == mem_wb_rd_addr)); // uncomment this line and remove semicolon above to disable half-cycle-WB
        end

        raw_stall = rs1_hazard || rs2_hazard;

        pc_stall    = raw_stall && ~redirect_taken;
        if_id_stall = raw_stall && ~redirect_taken;

        if_id_flush = redirect_taken;
        id_ex_flush = redirect_taken || raw_stall;
    end

endmodule
