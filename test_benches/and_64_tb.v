`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: 64-bit AND Gate Testbench
// Module Name: and_64_tb
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description: 
// This testbench verifies the functionality of the 64-bit AND gate (and_64).
// It tests various cases, including all 0s, all 1s, alternating bits, and edge cases.
// Results are displayed in hexadecimal format for compactness.
//
// Dependencies: and_64.
//
// Results:
// Format: A (64-bit hex) | B (64-bit hex) | AND Result (64-bit hex)
// A: 0000000000000000 | B: 0000000000000000 | AND Result: 0000000000000000
// A: ffffffffffffffff | B: ffffffffffffffff | AND Result: ffffffffffffffff
// A: aaaaaaaaaaaaaaaa | B: 5555555555555555 | AND Result: 0000000000000000
// A: 123456789abcdef0 | B: 0fedcba987654321 | AND Result: 0224422882244220
// A: ffffffff00000000 | B: 00000000ffffffff | AND Result: 0000000000000000
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module and_64_tb;

    // Inputs.
    reg [63:0] a;          // First operand (64-bit input).
    reg [63:0] b;          // Second operand (64-bit input).

    // Outputs.
    wire [63:0] and_result; // Result of bitwise AND operation.

    // Instantiate the 64-bit AND Gate.
    and_64 uut (
        .y(and_result),
        .a(a),
        .b(b)
    );

    // Task to display results.
    task display_result;
        begin
            $display("A: %16h | B: %16h | AND Result: %16h", a, b, and_result);
        end
    endtask

    // Stimulus.
    initial begin
        // Display format information.
        $display("Format: A (64-bit hex) | B (64-bit hex) | AND Result (64-bit hex)");

        // Case 1: Both inputs are all zeros.
        a = 64'h0000000000000000;
        b = 64'h0000000000000000;
        #10 display_result();

        // Case 2: Both inputs are all ones.
        a = 64'hFFFFFFFFFFFFFFFF;
        b = 64'hFFFFFFFFFFFFFFFF;
        #10 display_result();

        // Case 3: Alternating bits (A: 1010..., B: 0101...).
        a = 64'hAAAAAAAAAAAAAAAA;
        b = 64'h5555555555555555;
        #10 display_result();

        // Case 4: Random test case.
        a = 64'h123456789ABCDEF0;
        b = 64'h0FEDCBA987654321;
        #10 display_result();

        // Case 5: Edge case with mixed 0s and 1s.
        a = 64'hFFFFFFFF00000000;
        b = 64'h00000000FFFFFFFF;
        #10 display_result();

        $stop;
    end

endmodule
