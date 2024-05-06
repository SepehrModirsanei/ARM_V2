module Memory #(parameter WORD_SIZE = 32, ADDRESS_SIZE = 32) (
    input [(ADDRESS_SIZE-1):0] Address,
    input [(WORD_SIZE-1):0] WriteData,
    input MemRead, MemWrite, clk,
    output [(WORD_SIZE-1):0] ReadData
);
    localparam offset = 1024;

    reg [31:0] mem [0:63];

/*     initial begin
        $readmemb("../Codes/mem/memory.mem", mem, 1000);
    end */

    assign ReadData = MemRead ? mem[Address[(ADDRESS_SIZE-1):2] - (offset/4)] : {WORD_SIZE{1'bZ}};

    always @(posedge clk) begin
        if(MemWrite)
            mem[Address[(ADDRESS_SIZE-1):2] - (offset/4)] <= WriteData;
/*         else if(MemRead)
            ReadData <= mem[Address]; */
    end

endmodule