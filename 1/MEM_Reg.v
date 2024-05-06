//done
module MEM_Reg(
	CLK,
	RST,
	WB_EN_In,
	MEM_R_EN_In,
	ALU_Res_In,
	Data_In,
	Dest_In,
	WB_EN_Out,
	MEM_R_EN_Out,
	ALU_Res_Out,
	Data_Out,
	Dest_Out
	);
	input CLK, RST;
	input WB_EN_In,MEM_R_EN_In;
	input [3:0] Dest_In;
	input [31:0] ALU_Res_In, Data_In;
	output WB_EN_Out,MEM_R_EN_Out;
	output [3:0] Dest_Out;
	output [31:0] ALU_Res_Out, Data_Out;

	Register #(70) MEM_Reg_inst (
        .clk(CLK),
        .rst(RST),
        .ld(1'b1),
        .regIn(
			{
				WB_EN_In,
				MEM_R_EN_In,
				ALU_Res_In,
				Data_In,
				Dest_In
			}
		),
        .regOut(
			{
				WB_EN_Out,
				MEM_R_EN_Out,
				ALU_Res_Out,
				Data_Out,
				Dest_Out
			}
		)
    );

endmodule	
