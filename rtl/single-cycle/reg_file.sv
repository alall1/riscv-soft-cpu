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
        rs1_data = registers[rs1_addr];
        rs2_data = registers[rs2_addr];
    end

endmodule
