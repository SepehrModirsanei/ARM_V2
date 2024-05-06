module ALU (in1, in2, Cin, Vin, SR, EXE_CMD, result);
    input [31:0] in1, in2;
    input Cin, Vin;
    input [3:0] EXE_CMD;
    output [3:0] SR;
    output reg [31:0] result;

    reg Cout, Vout;
    wire Nout, Zout;
    
/*     assign OF = (result[31] & ~in1[31] & ~in2[31]) |
                (~result[31] & in1[31] & in2[31]);
                
    assign OFN = (result[31] & ~in1[31] & in2[31]) |
                (~result[31] & in1[31] & ~in2[31]); */

    assign Nout = result[31];
    assign Zout = ~(|result);
    assign SR = {Nout, Zout, Cout, Vout};

    always @(EXE_CMD, in1, in2, Cin) begin
        result = 32'bX; Vout = Vin; Cout = Cin; // Vout, Cout = 0 ??
        case (EXE_CMD)
            4'h1: begin: MOV
                result = in2;
            end
            4'h9: begin: MVN
                result = ~in2;
            end
            4'h2: begin: ADD
                {Cout, result} = in1 + in2;
                Vout = (result[31] & ~in1[31] & ~in2[31]) | (~result[31] & in1[31] & in2[31]);
            end
            4'h3: begin: ADC
                {Cout, result} = in1 + in2 + Cin;
                Vout = (result[31] & ~in1[31] & ~in2[31]) | (~result[31] & in1[31] & in2[31]);
            end 
            4'h4: begin: SUB
                {Cout, result} = in1 - in2;
                Vout = (result[31] & ~in1[31] & in2[31]) | (~result[31] & in1[31] & ~in2[31]);
            end
            4'h5: begin: SBC
                {Cout, result} = in1 - in2 - ({31'b0, ~Cin});
                Vout = (result[31] & ~in1[31] & in2[31]) | (~result[31] & in1[31] & ~in2[31]);
            end
            4'h6: begin: AND
                result = in1 & in2;
            end
            4'h7: begin: ORR
                result = in1 | in2;
            end
            4'h8: begin: EOR
                result = in1 ^ in2;
            end
            default: result = 32'b0;
        endcase
    end


endmodule