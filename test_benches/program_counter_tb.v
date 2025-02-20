`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: Program Counter Testbench
// Module Name: program_counter_tb
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This testbench verifies the functionality of the Program Counter (PC) module.
// It evaluates the PC's behavior under various combinations of clock, reset,
// enable, and PC_in inputs.
//
// Results:
// Format: clk (binary, 1 digit) | reset (binary, 1 digit) | enable (binary, 1 digit) | pc_in (decimal, 4 digits) | pc (decimal, 4 digits)
// clk: 1 | reset: 1 | enable: 0 | pc_in:  100 | pc:    0
// clk: 1 | reset: 0 | enable: 1 | pc_in:  200 | pc:  200
// clk: 1 | reset: 0 | enable: 0 | pc_in:  300 | pc:  200
// clk: 1 | reset: 0 | enable: 1 | pc_in:  400 | pc:  400
//
// Dependencies: program_counter.
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
////////////////////////////////////////////////////////////////////////////////

module program_counter_tb;

    // Inputs.
    reg [63:0] pc_in;      // Input value for the next PC.
    reg reset;             // Reset signal.
    reg enable;            // Enable signal.
    reg clk;               // Clock signal.

    // Outputs.
    wire [63:0] pc;        // Current PC value.

    // Instantiate the DUT (Device Under Test).
    program_counter dut (
        .pc(pc),          // Current PC output.
        .pc_in(pc_in),    // Next PC input.
        .reset(reset),    // Reset signal.
        .enable(enable),  // Enable signal.
        .clk(clk)         // Clock signal.
    );

    // Clock generation.
    initial clk = 0;
    always #5 clk = ~clk;

    // Test sequence.
    initial begin
        // Print format line.
        $display("Format: clk (binary, 1 digit) | reset (binary, 1 digit) | enable (binary, 1 digit) | pc_in (decimal, 4 digits) | pc (decimal, 4 digits)");

        // Test case 1: Reset active.
        reset = 1; enable = 0; pc_in = 64'd100; #10;
        $display("clk: %b | reset: %b | enable: %b | pc_in: %4d | pc: %4d", clk, reset, enable, pc_in, pc);

        // Test case 2: Reset inactive, enable active, update PC.
        reset = 0; enable = 1; pc_in = 64'd200; #10;
        $display("clk: %b | reset: %b | enable: %b | pc_in: %4d | pc: %4d", clk, reset, enable, pc_in, pc);

        // Test case 3: Enable inactive, hold PC.
        reset = 0; enable = 0; pc_in = 64'd300; #10;
        $display("clk: %b | reset: %b | enable: %b | pc_in: %4d | pc: %4d", clk, reset, enable, pc_in, pc);

        // Test case 4: Enable active, update PC.
        reset = 0; enable = 1; pc_in = 64'd400; #10;
        $display("clk: %b | reset: %b | enable: %b | pc_in: %4d | pc: %4d", clk, reset, enable, pc_in, pc);

        $stop; // End simulation.
    end

endmodule
