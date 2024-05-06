module PC_Branch_Addr(PC, signed_immed_24, Branch_Address);
    input [31:0] PC, signed_immed_24; // signed immediate must be 24 bits. change needed.
    output [31:0] Branch_Address;
    assign Branch_Address = PC + (signed_immed_24 << 2);
endmodule