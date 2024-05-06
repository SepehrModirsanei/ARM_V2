module Val2_Generator(Val_Rm, imm, memRW, Shift_operand, Val2);
    input [31:0] Val_Rm;
    input [11:0] Shift_operand;
    input imm, memRW;
    output reg [31:0] Val2;

    wire [1:0] shift;
    wire [3:0] rotate_imm; 
    wire [4:0] shift_imm; 
    wire [7:0] immed_8;
    wire [63:0] imm32_rotate, imm_shift_rotate, imm_shift_arithm;

    assign shift = Shift_operand[6:5];
    assign shift_imm = Shift_operand[11:7];
    assign imm32_rotate = {2{24'b0, immed_8}};
    assign imm_shift_arithm = {{32{Val_Rm[31]}}, Val_Rm};
    assign imm_shift_rotate = {2{Val_Rm}};
    assign {rotate_imm, immed_8} = Shift_operand;

    always @(Val_Rm, Shift_operand, imm, memRW) begin
        if(memRW) begin: LDR_STR
            Val2 = {20'b0, Shift_operand};
        end
        else if(imm) begin: immediate32
            Val2 = imm32_rotate[31 + (rotate_imm << 1) -: 32];
        end
        else begin: immediateShifts
            case(shift)
                2'b00: begin: LSL
                    Val2 = Val_Rm << shift_imm;
                end 
                2'b01: begin: LSR
                    Val2 = Val_Rm >> shift_imm;
                end
                2'b10: begin: ASR
                    Val2 = imm_shift_arithm[31 + shift_imm -: 32];
                end
                2'b11: begin: ROR
                    Val2 = imm_shift_rotate[31 + shift_imm -: 32];
                end
                default: Val2 = 32'bZ;
            endcase
        end
    end



endmodule