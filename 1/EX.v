module EX(
/* 	CLK,
	RST, */
	EXE_CMD,
	SR_In,
	MEM_R_EN,
	MEM_W_EN,
	PC,
	Val_Rn,
	Val_Rm,
	Shift_operand,
	imm,
	Signed_EX_imm_24,
	ALU_Result,
	Branch_Address,
	SR_Out
);

	// input CLK,RST;
	input [3:0] EXE_CMD;
	input [3:0] SR_In;
	input MEM_R_EN, MEM_W_EN;
	input [31:0] PC;
	input [31:0] Val_Rn, Val_Rm;
    input [11:0] Shift_operand;
    input imm;
	input [23:0] Signed_EX_imm_24;

	output [31:0] ALU_Result, Branch_Address;
	output [3:0] SR_Out;

	wire [31:0] Val2;

	ALU alu_inst (
		.in1(Val_Rn),
		.in2(Val2),
		.Cin(SR_In[1]),
		.Vin(SR_In[0]),
		.SR(SR_Out),
		.EXE_CMD(EXE_CMD),
		.result(ALU_Result)
	);

	Val2_Generator v2gen_inst (
		.Val_Rm(Val_Rm),
		.imm(imm),
		.memRW(MEM_R_EN | MEM_W_EN),
		.Shift_operand(Shift_operand),
		.Val2(Val2)
	);

	PC_Branch_Addr branchAdder_inst (
		.PC(PC),
		.signed_immed_24({{8{Signed_EX_imm_24[23]}}, Signed_EX_imm_24}),
		.Branch_Address(Branch_Address)
	);

endmodule 
