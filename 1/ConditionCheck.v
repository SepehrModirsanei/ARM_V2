
module ConditionCheck(Cond,Zee,C,N,V,Result);

input Zee,C,N,V;
input [3:0]Cond;
output reg Result;

always @(Cond,Zee,C,N,V)
begin

 case(Cond)
	//EQ
	4'b0000: Result=(Zee)? 1:0;
	//NE
	4'b0001: Result=(~Zee)? 1:0; 
	//CS/HS
	4'b0010: Result=(C)? 1:0;
	//CC/LO
	4'b0011: Result=(~C)? 1:0;
	//MI
	4'b0100: Result=(N)? 1:0;
	//PL
	4'b0101: Result=(~N)? 1:0;
	//VS
	4'b0110: Result=(V)? 1:0;
	//VC
	4'b0111: Result=(~V)? 1:0;
	//HI
	4'b1000: Result=(C && ~Zee)? 1:0;
	//LS
	4'b1001: Result=(~C || Zee)? 1:0;
	//GE
	4'b1010: Result=(N==V)? 1:0;
	//LT
	4'b1011: Result=(N!=V)? 1:0;
	//GT
	4'b1100: Result=(Zee==0 && ((N && V) || (~N && ~V)))? 1:0;
	//LE
	4'b1101: Result=(Zee==1 || N!=V)? 1:0;
	//Always
	4'b1110: Result=1'b1;
	default: Result=1'bz;
	endcase

end

endmodule