module ARM(clk, rst, beep);
    input clk, rst;


	// beep boop?
	output beep;


    wire [31:0] ID_Instruction;

    wire [31:0] IF_PC, ID_PC, EX_PC;
    wire [31:0] Branch_Address;
    wire [31:0] IF_Instruction, ID_Val_Rn, ID_Val_Rm,
				EX_Val_Rn, EX_Val_Rm, EX_ALU_Res,
				MEM_ALU_Res, MEM_Val_Rm,
				WB_Data, MEM_Data, WB_ALU_Res, WB_Value;
	wire ID_WB_EN, ID_MEM_R_EN, ID_MEM_W_EN, ID_B, ID_S, ID_imm,
		EX_WB_EN, EX_MEM_R_EN, EX_MEM_W_EN, EX_S, EX_imm,
		MEM_WB_EN, MEM_MEM_R_EN, MEM_MEM_W_EN,
		WB_WB_EN, WB_MEM_R_EN, Branch_taken;
	wire hazard, Two_src;
	wire [23:0] ID_signed_immed_24, EX_signed_immed_24;
	wire [11:0] ID_Shift_operand, EX_Shift_operand;
	wire [3:0] src1, src2;
	wire [3:0] SR_In, SR_Out, ID_EXE_CMD, ID_Dest,
	EX_EXE_CMD, EX_SR, EX_Dest, MEM_Dest, WB_Dest;

	// beep boop?
	assign beep = WB_Value[0];

	StatusReg status_reg_inst (
		.clk(clk),
		.rst(rst),
		.S(EX_S),
		.SR_In(SR_In),
		.SR_Out(SR_Out)
	);

	hazard_detection_unit hazard_detection_inst (
    	.src1(src1),
		.src2(src2),
		.EXE_Dest(EX_Dest),
		.MEM_Dest(MEM_Dest),
		.EXE_WB_EN(EX_WB_EN),
		.MEM_WB_EN(MEM_WB_EN),
		.Two_src(Two_src),
		.hazard_detected(hazard)
	);

    IF IF_inst(
        .clk(clk),
        .rst(rst),
        .freeze(hazard),
        .Branch_taken(Branch_taken),
        .BranchAddr(Branch_Address),
        .PC(IF_PC),
        .Instruction(IF_Instruction)
    );
    IF_Reg IF_Reg_inst(
	    .CLK(clk),
	    .RST(rst),
	    .freeze(hazard),
	    .PC_In(IF_PC),
	    .flush(Branch_taken),
	    .InstructionMemory_In(IF_Instruction),
	    .PC_Out(ID_PC),
	    .InstructionMemory_Out(ID_Instruction)
	);
    ID ID_inst(
		.CLK(clk),
		.RST(rst),
		.Instruction(ID_Instruction),
		.Result_WB(WB_Value),
		.writeBackEn(WB_WB_EN),
		.Dest_wb(WB_Dest),
		.hazard(hazard),
		.SR(SR_Out),
		.WB_EN(ID_WB_EN),
		.MEM_R_EN(ID_MEM_R_EN),
		.MEM_W_EN(ID_MEM_W_EN),
		.B(ID_B),
		.S(ID_S),
		.EXE_CMD(ID_EXE_CMD),
		.Val_Rn(ID_Val_Rn), .Val_Rm(ID_Val_Rm),
		.imm(ID_imm),
		.Shift_operand(ID_Shift_operand),
		.Signed_imm_24(ID_signed_immed_24),
		.Dest(ID_Dest),
		// to hazard unit
		.src1(src1), .src2(src2),
		.Two_src(Two_src)
    );
    ID_Reg ID_Reg_inst(
		.CLK(clk),
		.RST(rst),
		.flush(Branch_taken),
		.WB_EN_In(ID_WB_EN),
		.MEM_R_EN_In(ID_MEM_R_EN),
		.MEM_W_EN_In(ID_MEM_W_EN),
		.EXE_CMD_In(ID_EXE_CMD),
		.B_In(ID_B),
		.S_In(ID_S),
		.PC_In(ID_PC),
		.Val_Rn_In(ID_Val_Rn),
		.Val_Rm_In(ID_Val_Rm),
		.imm_In(ID_imm),
		.Shift_operand_In(ID_Shift_operand),
		.Signed_imm_24_In(ID_signed_immed_24),
		.Dest_In(ID_Dest),
		.SR_In(SR_Out),
		.WB_EN_Out(EX_WB_EN),
		.MEM_R_EN_Out(EX_MEM_R_EN),
		.MEM_W_EN_Out(EX_MEM_W_EN),
		.EXE_CMD_Out(EX_EXE_CMD),
		.B_Out(Branch_taken),
		.S_Out(EX_S),
		.PC_Out(EX_PC),
		.Val_Rn_Out(EX_Val_Rn),
		.Val_Rm_Out(EX_Val_Rm),
		.imm_Out(EX_imm),
		.Shift_operand_Out(EX_Shift_operand),
		.Signed_imm_24_Out(EX_signed_immed_24),
		.Dest_Out(EX_Dest),
		.SR_Out(EX_SR)
    );
    EX EX_inst(
		.EXE_CMD(EX_EXE_CMD),
		.SR_In(EX_SR),
		.MEM_R_EN(EX_MEM_R_EN),
		.MEM_W_EN(EX_MEM_W_EN),
		.PC(EX_PC),
		.Val_Rn(EX_Val_Rn),
		.Val_Rm(EX_Val_Rm),
		.Shift_operand(EX_Shift_operand),
		.imm(EX_imm),
		.Signed_EX_imm_24(EX_signed_immed_24),
		.ALU_Result(EX_ALU_Res),
		.Branch_Address(Branch_Address),
		.SR_Out(SR_In)
    );
    EX_Reg EX_Reg_inst(
		.CLK(clk),
		.RST(rst),
		.WB_EN_In(EX_WB_EN),
		.MEM_R_EN_In(EX_MEM_R_EN),
		.MEM_W_EN_In(EX_MEM_W_EN),
		.ALU_Res_In(EX_ALU_Res),
		.Val_Rm_In(EX_Val_Rm),
		.Dest_In(EX_Dest),
		.WB_EN_Out(MEM_WB_EN),
		.MEM_R_EN_Out(MEM_MEM_R_EN),
		.MEM_W_EN_Out(MEM_MEM_W_EN),
		.ALU_Res_Out(MEM_ALU_Res),
		.Val_Rm_Out(MEM_Val_Rm),
		.Dest_Out(MEM_Dest)
    );
    MEM MEM_inst(
		.CLK(clk),
		.MEM_R_EN(MEM_MEM_R_EN),
		.MEM_W_EN(MEM_MEM_W_EN),
		.Address(MEM_ALU_Res),
		.Data(MEM_Val_Rm),
		.MEM_result(MEM_Data)
    );
    MEM_Reg MEM_Reg_inst(
		.CLK(clk),
		.RST(rst),
		.WB_EN_In(MEM_WB_EN),
		.MEM_R_EN_In(MEM_MEM_R_EN),
		.ALU_Res_In(MEM_ALU_Res),
		.Data_In(MEM_Data),
		.Dest_In(MEM_Dest),
		.WB_EN_Out(WB_WB_EN),
		.MEM_R_EN_Out(WB_MEM_R_EN),
		.ALU_Res_Out(WB_ALU_Res),
		.Data_Out(WB_Data),
		.Dest_Out(WB_Dest)
    );
    WB WB_inst(
		.ALU_result(WB_ALU_Res),
		.MEM_result(WB_Data),
		.MEM_R_EN(WB_MEM_R_EN),
		.WB_Value(WB_Value)
    );

endmodule