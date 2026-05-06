`timescale 1ns / 1ps

module tb_adder;

    logic [31:0] A;
    logic [31:0] B;
    logic [31:0] S;
    
    adder dut (
        .A(A),
        .B(B),
        .S(S)
    );
    
    initial begin
        A = 32'd0;
        B = 32'd4;
        #10;
        
        if (S !== 32'd4) begin
            $error("Test 1 failed: A=%h B=%h S=%h expected=%h", A, B, S, 32'd4);
        end
        
        A = 32'd12;
        B = 32'd4;
        #10;
        
        if (S !== 32'd16) begin
            $error("Test 2 failed: A=%h B=%h S=%h expected=%h", A, B, S, 32'd16);
        end
        
        A = 32'hFFFFFFFF;
        B = 32'd1;
        #10;
        
        if (S !== 32'h00000000) begin
            $error("Test 3 failed: A=%h B=%h S=%h expected=%h", A, B, S, 32'h00000000);
        end
        
        $display("adder testbench finished");
        $finish;
    end
    
endmodule
