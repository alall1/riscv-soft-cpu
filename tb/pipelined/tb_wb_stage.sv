`timescale 1ns / 1ps

module tb_wb_stage;

    logic [31:0] alu_result;
    logic [31:0] read_data;
    logic [31:0] pc_plus_4;

    logic MemtoReg;
    logic JumpWrite;

    logic [31:0] write_data;

    wb_stage dut (
        .alu_result(alu_result),
        .read_data(read_data),
        .pc_plus_4(pc_plus_4),
        .MemtoReg(MemtoReg),
        .JumpWrite(JumpWrite),
        .write_data(write_data)
    );

    task check_wb;
        input string test_name;
        input logic [31:0] expected_write_data;

        begin
            #1;

            if (write_data !== expected_write_data) begin
                $fatal("%s: write_data=%h expected=%h", test_name, write_data, expected_write_data);
            end
        end
    endtask

    initial begin
        alu_result = 32'h00000000;
        read_data = 32'h00000000;
        pc_plus_4 = 32'h00000000;
        MemtoReg = 1'b0;
        JumpWrite = 1'b0;

        #1;

        alu_result = 32'h12345678;
        read_data = 32'haabbccdd;
        pc_plus_4 = 32'h00000004;
        MemtoReg = 1'b0;
        JumpWrite = 1'b0;
        check_wb("R-type writeback", 32'h12345678);

        alu_result = 32'h00000020;
        read_data = 32'hdeadbeef;
        pc_plus_4 = 32'h00000008;
        MemtoReg = 1'b1;
        JumpWrite = 1'b0;
        check_wb("load writeback", 32'hdeadbeef);

        alu_result = 32'h00000044;
        read_data = 32'hcafebabe;
        pc_plus_4 = 32'h00000104;
        MemtoReg = 1'b0;
        JumpWrite = 1'b1;
        check_wb("jal writeback", 32'h00000104);

        alu_result = 32'h00000088;
        read_data = 32'hfeedface;
        pc_plus_4 = 32'h00000204;
        MemtoReg = 1'b1;
        JumpWrite = 1'b1;
        check_wb("jump overrides load data", 32'h00000204);

        alu_result = 32'hfffffff0;
        read_data = 32'h0000000f;
        pc_plus_4 = 32'h00000304;
        MemtoReg = 1'b0;
        JumpWrite = 1'b0;
        check_wb("negative ALU result writeback", 32'hfffffff0);

        alu_result = 32'h11111111;
        read_data = 32'h22222222;
        pc_plus_4 = 32'h33333333;
        MemtoReg = 1'b1;
        JumpWrite = 1'b0;
        check_wb("MemtoReg selects read_data", 32'h22222222);

        alu_result = 32'h11111111;
        read_data = 32'h22222222;
        pc_plus_4 = 32'h33333333;
        MemtoReg = 1'b0;
        JumpWrite = 1'b0;
        check_wb("MemtoReg selects alu_result", 32'h11111111);

        alu_result = 32'h11111111;
        read_data = 32'h22222222;
        pc_plus_4 = 32'h33333333;
        MemtoReg = 1'b0;
        JumpWrite = 1'b1;
        check_wb("JumpWrite selects pc_plus_4", 32'h33333333);

        #20;

        $display("PASS");
        $finish;
    end

endmodule