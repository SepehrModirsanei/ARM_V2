//not complete
module ID_Reg(
	CLK,
	RST,
	flush,
	WB_EN_In,
	MEM_R_EN_In,
	MEM_W_EN_In,
	EXE_CMD_In,
	B_In,
	S_In,
	PC_In,
	Val_Rn_In,
	Val_Rm_In,
	imm_In,
	Shift_operand_In,
	Signed_imm_24_In,
	Dest_In,
	SR_In,
	WB_EN_Out,
	MEM_R_EN_Out,
	MEM_W_EN_Out,
	EXE_CMD_Out,
	B_Out,
	S_Out,
	PC_Out,
	Val_Rn_Out,
	Val_Rm_Out,
	imm_Out,
	Shift_operand_Out,
	Signed_imm_24_Out,
	Dest_Out,
	SR_Out
	);
	input CLK, RST, flush;
	input WB_EN_In, MEM_R_EN_In, MEM_W_EN_In;
	input B_In, S_In;
	input [3:0] EXE_CMD_In;
	input [31:0] PC_In;
	input [31:0] Val_Rn_In, Val_Rm_In;
	input imm_In;
	input [11:0] Shift_operand_In;
	input [23:0] Signed_imm_24_In;
	input [3:0] Dest_In;
	input [3:0] SR_In;

	output WB_EN_Out, MEM_R_EN_Out, MEM_W_EN_Out, B_Out, S_Out;
	output [3:0] EXE_CMD_Out;
	output [31:0] PC_Out;
	output [31:0] Val_Rn_Out, Val_Rm_Out;
	output imm_Out;
	output [11:0] Shift_operand_Out;
	output [23:0] Signed_imm_24_Out;
	output [3:0] Dest_Out;
	output [3:0] SR_Out;

	RegisterSynch #(150) ID_Reg_inst (
        .clk(CLK),
        .rst(RST),
		.clr(flush),
        .ld(1'b1),
        .regIn(
			{
				WB_EN_In,
				MEM_R_EN_In,
				MEM_W_EN_In,
				B_In,
				S_In,
				EXE_CMD_In,
				PC_In,
				Val_Rn_In,
				Val_Rm_In,
				imm_In,
				Shift_operand_In,
				Signed_imm_24_In,
				Dest_In,
				SR_In
			}
		),
        .regOut(
			{
				WB_EN_Out,
				MEM_R_EN_Out,
				MEM_W_EN_Out,
				B_Out,
				S_Out,
				EXE_CMD_Out,
				PC_Out,
				Val_Rn_Out,
				Val_Rm_Out,
				imm_Out,
				Shift_operand_Out,
				Signed_imm_24_Out,
				Dest_Out,
				SR_Out
			}
		)
    );

endmodule
