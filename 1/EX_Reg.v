//done
module EX_Reg(
	CLK,
	RST,
	WB_EN_In,
	MEM_R_EN_In,
	MEM_W_EN_In,
	ALU_Res_In,
	Val_Rm_In,
	Dest_In,
	WB_EN_Out,
	MEM_R_EN_Out,
	MEM_W_EN_Out,
	ALU_Res_Out,
	Val_Rm_Out,
	Dest_Out
	);
	input CLK, RST;
	input WB_EN_In, MEM_R_EN_In, MEM_W_EN_In;
	input [31:0] ALU_Res_In, Val_Rm_In;
	input [3:0] Dest_In;

	output WB_EN_Out, MEM_R_EN_Out, MEM_W_EN_Out;
	output [31:0] ALU_Res_Out, Val_Rm_Out;
	output [3:0] Dest_Out;

	Register #(71) EX_Reg_inst (
        .clk(CLK),
        .rst(RST),
        .ld(1'b1),
        .regIn(
			{
				WB_EN_In,
				MEM_R_EN_In,
				MEM_W_EN_In,
				ALU_Res_In,
				Val_Rm_In,
				Dest_In
			}
		),
        .regOut(
			{
				WB_EN_Out,
				MEM_R_EN_Out,
				MEM_W_EN_Out,
				ALU_Res_Out,
				Val_Rm_Out,
				Dest_Out
			}
		)
    );

endmodule
