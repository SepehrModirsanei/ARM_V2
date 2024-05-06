//done
module IF_Reg(
	CLK,
	RST,
	freeze,
	PC_In,
	flush,
	InstructionMemory_In,
	PC_Out,
	InstructionMemory_Out
	);

	input CLK,RST,flush,freeze;
	input [31:0] PC_In, InstructionMemory_In;
	output [31:0] PC_Out, InstructionMemory_Out;

	// wire reset = RST || flush;
/* 	wire clock = CLK && ~freeze;

	always @(posedge clock) begin
		if(reset)
			{PC_Out, InstructionMemory_Out} <= 0;
		else
			{PC_Out, InstructionMemory_Out} <= {PC_In, InstructionMemory_In};
	end */

	RegisterSynch #(32) IF_PC_Reg (
        .clk(CLK),
        .rst(RST),
		.clr(flush),
        .ld(~freeze),
        .regIn(PC_In),
        .regOut(PC_Out)
    );

	RegisterSynch #(32) IF_InstMem_Reg (
        .clk(CLK),
        .rst(RST),
		.clr(flush),
        .ld(~freeze),
        .regIn(InstructionMemory_In),
        .regOut(InstructionMemory_Out)
    );

endmodule