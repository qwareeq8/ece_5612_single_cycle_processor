`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: 64-bit OR Gate Testbench
// Module Name: or_64_tb
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This testbench verifies the functionality of the 64-bit OR gate (or_64).
// It tests various cases, including all zeros, all ones, alternating bits, and edge cases.
// All outputs are displayed in hexadecimal format for compactness.
//
// Dependencies: or_64.
//
// Results:
// Format: A (64-bit hex) | B (64-bit hex) | OR Result (64-bit hex)
// A: 0000000000000000 | B: 0000000000000000 | OR Result: 0000000000000000
// A: ffffffffffffffff | B: ffffffffffffffff | OR Result: ffffffffffffffff
// A: aaaaaaaaaaaaaaaa | B: 5555555555555555 | OR Result: ffffffffffffffff
// A: 123456789abcdef0 | B: 0fedcba987654321 | OR Result: 1ffddff99ffddff1
// A: ffffffff00000000 | B: 00000000ffffffff | OR Result: ffffffffffffffff
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module or_64_tb;

    // Inputs.
    reg [63:0] a;        // 64-bit input vector A.
    reg [63:0] b;        // 64-bit input vector B.

    // Outputs.
    wire [63:0] y;      // 64-bit OR result.

    // Instantiate the 64-bit OR Gate.
    or_64 uut (
        .y(y),
        .a(a),
        .b(b)
    );

    // Task to display results.
    task display_result;
        begin
            $display("A: %16h | B: %16h | OR Result: %16h", a, b, y);
        end
    endtask

    // Stimulus.
    initial begin
        // Display format information.
        $display("Format: A (64-bit hex) | B (64-bit hex) | OR Result (64-bit hex)");

        // Test case 1: Both inputs are all zeros.
        a = 64'h0000000000000000;
        b = 64'h0000000000000000;
        #10 display_result();

        // Test case 2: Both inputs are all ones.
        a = 64'hFFFFFFFFFFFFFFFF;
        b = 64'hFFFFFFFFFFFFFFFF;
        #10 display_result();

        // Test case 3: Alternating bits (A: 1010..., B: 0101...).
        a = 64'hAAAAAAAAAAAAAAAA;
        b = 64'h5555555555555555;
        #10 display_result();

        // Test case 4: Random test case 1.
        a = 64'h123456789ABCDEF0;
        b = 64'h0FEDCBA987654321;
        #10 display_result();

        // Test case 5: Edge case: Mixed 0s and 1s.
        a = 64'hFFFFFFFF00000000;
        b = 64'h00000000FFFFFFFF;
        #10 display_result();

        // End of test cases.
        $stop;
    end

endmodule
