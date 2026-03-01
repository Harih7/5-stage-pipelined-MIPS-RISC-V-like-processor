module processor_top (
    input  wire clk,
    input  wire reset,
    output wire [31:0] result
);

    wire clk1 = clk;
    wire clk2 = ~clk;
    wire [31:0] alu_out;

    pipe_MIPS core (
        .clk1(clk1),
        .clk2(clk2),
        .reset(reset),
        .ALU_result_out(alu_out)
    );

    assign result = alu_out;

endmodule
