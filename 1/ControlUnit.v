// AND 0
// EOR 1
// SUB 2
// ADD 4
// ADC 5
// SBC 6
// TST 8
// CMP 10
// ORR 12
// MOV 13
// MVN 15
// LDR 4
// STR 4

module ControlUnit(S, mode, Opcode, Stat_update, B, MEM_W_EN, MEM_R_EN, WB_EN, EXE_CMD);
  
  input [1:0] mode;
  input S;
  input [3:0] Opcode;
  
  output reg MEM_R_EN, MEM_W_EN, WB_EN, B, Stat_update;
  output reg [3:0] EXE_CMD;
  always@(mode, Opcode, S)begin
    {MEM_R_EN, MEM_W_EN, WB_EN, B, Stat_update, EXE_CMD} = 9'd0;
    case(mode)
      0: begin
        Stat_update = S;
        case(Opcode)
          0  : {EXE_CMD, WB_EN} = {4'b0110, 1'b1};
          1  : {EXE_CMD, WB_EN} = {4'b1000, 1'b1};
          2  : {EXE_CMD, WB_EN} = {4'b0100, 1'b1};
          4  : {EXE_CMD, WB_EN} = {4'b0010, 1'b1};
          5  : {EXE_CMD, WB_EN} = {4'b0011, 1'b1};
          6  : {EXE_CMD, WB_EN} = {4'b0101, 1'b1};
          8  : {EXE_CMD} = 4'b0110; 
          10 : {EXE_CMD} = 4'b0100; 
          12 : {EXE_CMD, WB_EN} = {4'b0111, 1'b1};
          13 : {EXE_CMD, WB_EN} = {4'b0001, 1'b1};
          15 : {EXE_CMD, WB_EN} = {4'b1001, 1'b1};
        endcase
      end
      1: begin
        Stat_update = 0;
        if (Opcode == 4'd4) begin
          case(S)
            0: {EXE_CMD, MEM_W_EN} = {4'b0010, 1'b1};
            1: {EXE_CMD, WB_EN, MEM_R_EN} = {4'b0010, 1'b1, 1'b1};
          endcase
        end
      end
      2: begin
        Stat_update = 0;
        B = 1;
      end
    endcase
  end
    
endmodule
