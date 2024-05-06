module ID(
	CLK,
	RST,
	Instruction,
	Result_WB,
	writeBackEn,
	Dest_wb,
	hazard,
	SR,
	WB_EN, MEM_R_EN, MEM_W_EN, B, S,
	EXE_CMD,
	Val_Rn, Val_Rm,
	imm,
	Shift_operand,
	Signed_imm_24,
	Dest,
	src1, src2,
	Two_src
);
	input CLK,RST;
	
	// from IF Reg
	input [31:0] Instruction;
	// from WB stage
	input [31:0] Result_WB;
	input writeBackEn;
	input [3:0] Dest_wb;
	// from hazard detect module
	input hazard;
	// from Status Register
	input [3:0] SR;
	// to next stage
	output WB_EN, MEM_R_EN, MEM_W_EN, B, S;
	output [3:0] EXE_CMD;
	output [31:0] Val_Rn, Val_Rm;
	output imm;
	output [11:0] Shift_operand;
	output [23:0] Signed_imm_24;
	output [3:0] Dest;
	// to hazard detect module
	output [3:0] src1, src2;
	output Two_src;
	assign Two_src = (~imm) || MEM_W_EN;

	wire condition;

	wire ctrl_WB_EN, ctrl_MEM_R_EN, ctrl_MEM_W_EN, ctrl_B, ctrl_S;
	wire [3:0] ctrl_EXE_CMD;

	assign src1 = Instruction[19:16]; // Instruction[19:16] -> Rn
	assign src2 = MEM_W_EN ? Instruction[15:12]:Instruction[3:0];
	assign Dest = Instruction[15:12]; // Instruction[15:12] -> Rd
	assign imm = Instruction[25];	// imm -> I
	assign Shift_operand = Instruction[11:0];
	assign Signed_imm_24 = Instruction[23:0];


	ControlUnit ctrl_inst (
		.S(Instruction[20]),
		.mode(Instruction[27:26]),
		.Opcode(Instruction[24:21]),
		.Stat_update(ctrl_S),
		.B(ctrl_B),
		.MEM_W_EN(ctrl_MEM_W_EN),
		.MEM_R_EN(ctrl_MEM_R_EN),
		.WB_EN(ctrl_WB_EN),
		.EXE_CMD(ctrl_EXE_CMD)
	);

	RegisterFile #( .WORD_SIZE(32), .ADDRESS_SIZE(4)) regfile_inst (
        .src1(src1), .src2(src2), .Dest_wb(Dest_wb),
        .Result_WB(Result_WB),
        .clk(CLK), .rst(RST), .writeBackEn(writeBackEn),
        .reg1(Val_Rn), .reg2(Val_Rm)
	);

	ConditionCheck CC_inst (
		.Cond(Instruction[31:28]),
		.N(SR[3]),
		.Zee(SR[2]),
		.C(SR[1]),
		.V(SR[0]),
		.Result(condition)
	);

/* 	Mux2 #(9) cond_mux (
		.d0(),
		.d1(9'b000000000),
		.sel(hazard | (~condition)),
		.w({S, B, MEM_W_EN, MEM_R_EN, WB_EN, EXE_CMD})
	); */

	assign {S, B, MEM_W_EN, MEM_R_EN, WB_EN, EXE_CMD} = (hazard | (~condition)) ? 9'b0:
		{ctrl_S, ctrl_B, ctrl_MEM_W_EN, ctrl_MEM_R_EN, ctrl_WB_EN, ctrl_EXE_CMD};


endmodule 