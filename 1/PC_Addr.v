module PC_Addr(PC, PC_plus4);
    input [31:0] PC;
    output [31:0] PC_plus4;
    assign PC_plus4 = PC + 32'h00000004;
endmodule