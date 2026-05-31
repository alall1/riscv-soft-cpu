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
    
    always_comb begin
        if_id_flush = 1'b0;
        id_ex_flush = 1'b0;
        pc_stall = 1'b0;
        if_id_stall = 1'b0;
        
        // control hazard logic (branches and jumps)
        if (redirect_taken) begin
            if_id_flush = 1'b1;
            id_ex_flush = 1'b1;
        end
        
        // RAW hazard logic (read after write)
        if ((id_rs1_addr != 5'b0) && id_uses_rs1) begin
            if ((id_rs1_addr == id_ex_rd_addr) && id_ex_RegWrite) begin
                pc_stall = 1'b1;
                if_id_stall = 1'b1;
                id_ex_flush = 1'b1;
            end else if ((id_rs1_addr == ex_mem_rd_addr) && ex_mem_RegWrite) begin
                pc_stall = 1'b1;
                if_id_stall = 1'b1;
                id_ex_flush = 1'b1;
            end else if ((id_rs1_addr == mem_wb_rd_addr) && mem_wb_RegWrite) begin
                pc_stall = 1'b1;
                if_id_stall = 1'b1;
                id_ex_flush = 1'b1;
            end
        end
        if ((id_rs2_addr != 5'b0) && id_uses_rs2) begin
            if ((id_rs2_addr == id_ex_rd_addr) && id_ex_RegWrite) begin
                pc_stall = 1'b1;
                if_id_stall = 1'b1;
                id_ex_flush = 1'b1;
            end else if ((id_rs2_addr == ex_mem_rd_addr) && ex_mem_RegWrite) begin
                pc_stall = 1'b1;
                if_id_stall = 1'b1;
                id_ex_flush = 1'b1;
            end else if ((id_rs2_addr == mem_wb_rd_addr) && mem_wb_RegWrite) begin
                pc_stall = 1'b1;
                if_id_stall = 1'b1;
                id_ex_flush = 1'b1;
            end
        end
    end

endmodule
