module MEM(
	CLK,
	MEM_R_EN,
	MEM_W_EN,
	Address,
	Data,
	MEM_result
);

	input CLK, MEM_R_EN, MEM_W_EN;
	input [31:0] Address, Data;
	output [31:0] MEM_result;

	Memory #(32, 32) memory_inst(
        .Address(Address),
        .WriteData(Data),
        .MemRead(MEM_R_EN), .MemWrite(MEM_W_EN), .clk(CLK),
        .ReadData(MEM_result)
    );


endmodule 
