module hazard_unit(
    input logic redirect_taken,
    output logic if_id_flush,
    output logic id_ex_flush
);
    
    always_comb begin
        if_id_flush = 1'b0;
        id_ex_flush = 1'b0;
        
        // control hazard logic (branches and jumps)
        if (redirect_taken) begin
            if_id_flush = 1'b1;
            id_ex_flush = 1'b1;
        end
    end

endmodule
