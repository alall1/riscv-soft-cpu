module mux32(
    input logic [31:0] A,   // result = A if sel = 0
    input logic [31:0] B,   // result = B if sel = 1
    input logic sel,
    output logic [31:0] result
);

    always_comb begin
        result = (sel) ? B : A;
    end

endmodule
