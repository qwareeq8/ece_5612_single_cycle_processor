`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: Shift Left by 1 Testbench
// Module Name: shift_left_64_tb
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This testbench verifies the functionality of the `shift_left_64` module by
// testing various 64-bit input values.
//
// Results:
// Format: Input (hexadecimal, 16 digits) | Output (hexadecimal, 16 digits)
// Input (hexadecimal): 0000000000000001 | Output (hexadecimal): 0000000000000002
// Input (hexadecimal): 8000000000000000 | Output (hexadecimal): 0000000000000000
// Input (hexadecimal): 7fffffffffffffff | Output (hexadecimal): fffffffffffffffe
// Input (hexadecimal): 123456789abcdef0 | Output (hexadecimal): 2468acf13579bde0
// Input (hexadecimal): 0000000000000000 | Output (hexadecimal): 0000000000000000
//
// Dependencies: shift_left_64.
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module shift_left_64_tb;

    // Inputs to the DUT.
    reg [63:0] in;

    // Outputs from the DUT.
    wire [63:0] out;

    // Instantiate the DUT.
    shift_left_64 dut (
        .in(in),  // Connect input to DUT.
        .out(out) // Connect output from DUT.
    );

    // Task to display results.
    task display_result;
        input [63:0] input_val;
        input [63:0] output_val;
        begin
            $display("Input (hexadecimal): %16h | Output (hexadecimal): %16h", input_val, output_val); // Display input and output values.
        end
    endtask

    // Test cases.
    initial begin
        // Print format line.
        $display("Format: Input (hexadecimal, 16 digits) | Output (hexadecimal, 16 digits)");

        // Test cases.
        in = 64'h0000000000000001; #10 display_result(in, out); // Test 1.
        in = 64'h8000000000000000; #10 display_result(in, out); // Test 2.
        in = 64'h7FFFFFFFFFFFFFFF; #10 display_result(in, out); // Test 3.
        in = 64'h123456789ABCDEF0; #10 display_result(in, out); // Test 4.
        in = 64'h0000000000000000; #10 display_result(in, out); // Test 5.

        $stop; // Stop simulation.
    end

endmodule
