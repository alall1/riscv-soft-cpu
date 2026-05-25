module adder(
    input logic [31:0] A,
    input logic [31:0] B,
    output logic [31:0] S
);

    always_comb begin
        S = A + B;
    end

endmodule
