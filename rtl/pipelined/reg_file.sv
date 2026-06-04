module reg_file(
    input logic clk,
    input logic reset,
    input logic RegWrite,
    input logic [4:0] rs1_addr,
    input logic [4:0] rs2_addr,
    input logic [4:0] rd_addr,
    input logic [31:0] write_data,
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data
);

    logic [31:0] registers [0:31];
    
    always_ff @(posedge clk) begin
        if (reset) begin
            for (int i = 0; i < 32; i++) begin
                registers[i] <= 32'h00000000;
            end
        end
        else if (RegWrite && rd_addr != 5'd0) begin // if RegWrite is high and rd is not x0, set rd to write_data
            registers[rd_addr] <= write_data;
        end
    end
    
    always_comb begin
        if ((rs1_addr == rd_addr) && (RegWrite && rd_addr != 5'd0)) begin   // half-cycle WB bypass (comment these lines for non-half-cycle-WB version)
            rs1_data = write_data;
        end else begin
            rs1_data = registers[rs1_addr];
        end
        
        if ((rs2_addr == rd_addr) && (RegWrite && rd_addr != 5'd0)) begin
            rs2_data = write_data;
        end else begin
            rs2_data = registers[rs2_addr];
        end
        
        // rs1_data = registers[rs1_addr];  // uncomment these lines for non-half-cycle-WB version
        // rs2_data = registers[rs2_addr];
    end

endmodule
