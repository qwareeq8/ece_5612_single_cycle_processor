`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: Ripple Carry Adder Testbench
// Module Name: add_rca_64_tb
// Project Name: RISC-V 64-bit Single-Cycle CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description: 
// This testbench verifies the functionality of the 64-bit Ripple Carry Adder by testing
// various operations, including signed and unsigned addition, overflow cases, and edge
// scenarios.
//
// Dependencies: add_rca_64.
//
// Results:
// Format: Input A (64-bit hex) | Input B (64-bit hex) | C_in (1-bit) | Signed (1-bit) | Sum Out (64-bit hex) | C_out (1-bit) | Overflow (1-bit)
// Input A: 0000000000000005 | Input B: 000000000000000a | C_in: 0 | Signed: 0 | Sum Out: 000000000000000f | C_out: 0 | Overflow: x
// Input A: ffffffffffffffff | Input B: 0000000000000001 | C_in: 1 | Signed: 0 | Sum Out: 0000000000000001 | C_out: 1 | Overflow: x
// Input A: 7fffffffffffffff | Input B: 0000000000000001 | C_in: 0 | Signed: 1 | Sum Out: 8000000000000000 | C_out: x | Overflow: 1
// Input A: 8000000000000000 | Input B: ffffffffffffffff | C_in: 0 | Signed: 1 | Sum Out: 7fffffffffffffff | C_out: x | Overflow: 1
// Input A: 0000000000003039 | Input B: fffffffffffcfdaf | C_in: 0 | Signed: 1 | Sum Out: fffffffffffd2de8 | C_out: x | Overflow: 0
// Input A: ffffffffffffffff | Input B: 0000000000000001 | C_in: 0 | Signed: 0 | Sum Out: 0000000000000000 | C_out: 1 | Overflow: x
// Input A: 0000000000000000 | Input B: 0000000000000000 | C_in: 0 | Signed: 0 | Sum Out: 0000000000000000 | C_out: 0 | Overflow: x
// Input A: ffffffffffffff9c | Input B: ffffffffffffff38 | C_in: 0 | Signed: 1 | Sum Out: fffffffffffffed4 | C_out: x | Overflow: 0
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module add_rca_64_tb;

    // Inputs.
    reg [63:0] input_a;    // First operand (64-bit input).
    reg [63:0] input_b;    // Second operand (64-bit input).
    reg carry_in;          // Carry-in for the addition.
    reg is_signed_add;     // Indicates signed or unsigned addition.

    // Outputs.
    wire [63:0] sum_out;   // Sum result (64-bit output).
    wire carry_out;        // Carry-out from addition.
    wire overflow;         // Overflow flag for signed addition.

    // Instantiate the Unit Under Test (UUT).
    add_rca_64 uut (
        .sum_out(sum_out),
        .carry_out(carry_out),
        .overflow(overflow),
        .input_a(input_a),
        .input_b(input_b),
        .carry_in(carry_in),
        .is_signed_add(is_signed_add)
    );

    // Task to display results.
    task display_result;
        begin
            $display("Input A: %16h | Input B: %16h | C_in: %1b | Signed: %1b | Sum Out: %16h | C_out: %1b | Overflow: %1b",
                     input_a, input_b, carry_in, is_signed_add, sum_out, carry_out, overflow);
        end
    endtask

    // Test cases.
    initial begin
        // Display format information.
        $display("Format: Input A (64-bit hex) | Input B (64-bit hex) | C_in (1-bit) | Signed (1-bit) | Sum Out (64-bit hex) | C_out (1-bit) | Overflow (1-bit)");

        // Test unsigned addition with no carry-in and no overflow.
        input_a = 64'h0000000000000005;
        input_b = 64'h000000000000000A;
        carry_in = 0;
        is_signed_add = 0;
        #10 display_result();

        // Test unsigned addition with carry-in and no overflow.
        input_a = 64'hFFFFFFFFFFFFFFFF;
        input_b = 64'h0000000000000001;
        carry_in = 1;
        is_signed_add = 0;
        #10 display_result();

        // Test signed addition with no carry-in and positive overflow.
        input_a = 64'h7FFFFFFFFFFFFFFF;
        input_b = 64'h0000000000000001;
        carry_in = 0;
        is_signed_add = 1;
        #10 display_result();

        // Test signed addition with no carry-in and negative overflow.
        input_a = 64'h8000000000000000;
        input_b = 64'hFFFFFFFFFFFFFFFF;
        carry_in = 0;
        is_signed_add = 1;
        #10 display_result();

        // Test signed addition with mixed inputs and sum within range.
        input_a = 64'h0000000000003039; // Decimal 12345.
        input_b = 64'hFFFFFFFFFFFCFDAF; // Decimal -54321.
        carry_in = 0;
        is_signed_add = 1;
        #10 display_result();

        // Test unsigned addition with wrap-around.
        input_a = 64'hFFFFFFFFFFFFFFFF;
        input_b = 64'h0000000000000001;
        carry_in = 0;
        is_signed_add = 0;
        #10 display_result();

        // Test edge case with zero inputs.
        input_a = 64'h0000000000000000;
        input_b = 64'h0000000000000000;
        carry_in = 0;
        is_signed_add = 0;
        #10 display_result();

        // Test signed addition with both negative inputs.
        input_a = 64'hFFFFFFFFFFFFFF9C; // Decimal -100.
        input_b = 64'hFFFFFFFFFFFFFF38; // Decimal -200.
        carry_in = 0;
        is_signed_add = 1;
        #10 display_result();

        // End of test cases.
        $stop;
    end

endmodule
