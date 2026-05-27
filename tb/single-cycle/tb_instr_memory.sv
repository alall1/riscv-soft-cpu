`timescale 1ns / 1ps

module tb_instr_memory;

    logic [31:0] addr;
    logic [31:0] instr;
    
    instr_memory #(
        .PROGRAM_FILE("instrmem_test.mem")
    ) dut (
        .addr(addr),
        .instr(instr)
    );
    
    initial begin
        addr = 32'h00000000;
        
        #10;
        if (instr !== 32'h00f00093) $error("instr=%h expected=%h", instr, 32'h00f00093);
        
        addr = 32'h00000004; // incrementing by 4 to mimic PC
        
        #10;
        if (instr !== 32'h00e00113) $error("instr=%h expected=%h", instr, 32'h00e00113);
        
        addr = 32'h00000008;
        
        #10;
        if (instr !== 32'h002081b3) $error("instr=%h expected=%h", instr, 32'h002081b3);
        
        addr = 32'h0000000C;
        
        #10;
        if (instr !== 32'h00000013) $error("instr=%h expected=%h", instr, 32'h00000013);
        
        $display("instr_memory testbench finished");
        $finish;
    end
    
endmodule