module pc(
    input logic clk,
    input logic reset,
    input logic [31:0] pc_next,
    input logic pc_stall,
    output logic [31:0] pc
);

    always_ff @(posedge clk) begin
        if (reset)
            pc = 32'h00000000;
        else if (~pc_stall)
            pc = pc_next;
    end

endmodule
