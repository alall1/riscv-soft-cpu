`timescale 1ns / 1ps

module tb_mux32;

    logic [31:0] A;
    logic [31:0] B;
    logic sel;
    logic [31:0] result;
    
    mux32 dut (
        .A(A),
        .B(B),
        .sel(sel),
        .result(result)
    );

    initial begin
        A = 32'h00000000;
        B = 32'hFFFFFFFF;
        sel = 1'b0;
        #10;
        if (result !== 32'h00000000) $error("result=%h expected=%h", result, 32'h00000000);
        sel = 1'b1;
        #10;
        if (result !== 32'hFFFFFFFF) $error("result=%h expected=%h", result, 32'hFFFFFFFF);
        
        $display("mux32 testbench finished");
        $finish;
    end

endmodule
