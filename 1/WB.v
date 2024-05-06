module WB(
	ALU_result,
	MEM_result,
	MEM_R_EN,
	WB_Value
);

	input MEM_R_EN;
	input [31:0] ALU_result, MEM_result;
	output [31:0] WB_Value;

	assign WB_Value = MEM_R_EN ? MEM_result:ALU_result;
    
endmodule