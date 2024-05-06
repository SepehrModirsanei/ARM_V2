module IF(clk, rst, freeze, Branch_taken, BranchAddr, PC, Instruction);
    input clk, rst, freeze, Branch_taken;
    input [31:0] BranchAddr;
    output [31:0] PC, Instruction;

    wire [31:0] PC_in, PC_out, PC_plus4;

    assign PC = PC_plus4;
    
    Mux2 #(32) PC_IN (
        .d0(PC_plus4),
        .d1(BranchAddr),
        .sel(Branch_taken),
        .w(PC_in)
    );
    
    Register #(32) PC_inst (
        .clk(clk),
        .rst(rst),
        .ld(~freeze),
        .regIn(PC_in),
        .regOut(PC_out)
    );

    PC_Addr PC_Adder_inst (
        .PC(PC_out),
        .PC_plus4(PC_plus4)
    );
    
    InstructionMem InstMem_inst (
        .Address(PC_out),
        .Instruction(Instruction)
    );

endmodule