`timescale 1ns / 1ps

module tb_top_pipeline_processor;

    reg clk;
    reg reset;

    // DUT
    top_pipeline_processor dut (
        .clk(clk),
        .reset(reset)
    );

    // Clock: 10ns period
    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1;

        // Hold reset
        #20;
        reset = 0;

        // Run long enough for pipeline to complete
        #300;

        $display("FINAL RESULT:");
        $display("R1 = %d", dut.core.Reg[1]);
        $display("R2 = %d", dut.core.Reg[2]);
        $display("R3 = %d (R1 + R2)", dut.core.Reg[3]);

        $finish;
    end

    // -------------------------------------------------
    // Initialize registers & instruction memory
    // -------------------------------------------------
    initial begin
        // Initialize registers
        dut.core.Reg[1] = 32'd15;   // Operand 1
        dut.core.Reg[2] = 32'd25;   // Operand 2
        dut.core.Reg[3] = 32'd0;

        // Program memory
        // ADD R3, R1, R2
        dut.core.Mem[0] = {6'b000000, 5'd1, 5'd2, 5'd3, 11'd0};

        // HALT
        dut.core.Mem[1] = {6'b111111, 26'd0};
    end

    // Monitor pipeline progress
    initial begin
        $monitor(
            "Time=%0t | PC=%d | ALU_out=%d",
            $time,
            dut.core.PC,
            dut.core.ALU_result_out
        );
    end

endmodule
