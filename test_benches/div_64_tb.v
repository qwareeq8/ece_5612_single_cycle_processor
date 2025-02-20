`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: 64-bit Divider Testbench
// Module Name: div_64_tb
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description: 
// This testbench verifies the functionality of the 64-bit divider by testing
// various operations, including signed and unsigned division, divide-by-zero
// scenarios, and edge cases.
//
// Dependencies: div_64.
//
// Results:
// Format: Dividend (64-bit hex) | Divisor (32-bit hex) | Signed (1-bit) | Quotient (32-bit hex) | Remainder (64-bit hex) | Divide by zero (1-bit)
// Dividend: 0000000000000064 | Divisor: 00000005 | Signed: 0 | Quotient: 00000014 | Remainder: 0000000000000000 | Divide by zero: 0
// Dividend: 0000000000000067 | Divisor: 00000005 | Signed: 0 | Quotient: 00000014 | Remainder: 0000000000000003 | Divide by zero: 0
// Dividend: 0000000000000064 | Divisor: 00000005 | Signed: 1 | Quotient: 00000014 | Remainder: 0000000000000000 | Divide by zero: 0
// Dividend: ffffffffffffff9c | Divisor: 00000005 | Signed: 1 | Quotient: ffffffec | Remainder: 0000000000000000 | Divide by zero: 0
// Dividend: 0000000000000064 | Divisor: fffffffb | Signed: 1 | Quotient: ffffffec | Remainder: 0000000000000000 | Divide by zero: 0
// Dividend: ffffffffffffff9c | Divisor: fffffffb | Signed: 1 | Quotient: 00000014 | Remainder: 0000000000000000 | Divide by zero: 0
// Dividend: 0000000000000064 | Divisor: 00000000 | Signed: 0 | Quotient: 00000000 | Remainder: 0000000000000000 | Divide by zero: 1
// Dividend: ffffffffffffff9c | Divisor: 00000000 | Signed: 1 | Quotient: 00000000 | Remainder: 0000000000000000 | Divide by zero: 1
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module div_64_tb;

    // Inputs.
    reg [63:0] dividend_in;      // Dividend input.
    reg [31:0] divisor_in;       // Divisor input.
    reg is_signed_div;           // Control signal for signed division.

    // Outputs.
    wire [31:0] quotient_out;    // Quotient output.
    wire [63:0] remainder_out;   // Remainder output.
    wire divide_by_zero_flag;    // Divide-by-zero flag.

    // Instantiate the Unit Under Test (UUT).
    div_64 uut (
        .quotient_out(quotient_out),
        .remainder_out(remainder_out),
        .divide_by_zero_flag(divide_by_zero_flag),
        .dividend_in(dividend_in),
        .divisor_in(divisor_in),
        .is_signed_div(is_signed_div)
    );

    // Task to display results.
    task display_result;
        begin
            $display("Dividend: %016h | Divisor: %08h | Signed: %1b | Quotient: %08h | Remainder: %016h | Divide by zero: %1b",
                     dividend_in, divisor_in, is_signed_div, quotient_out, remainder_out, divide_by_zero_flag);
        end
    endtask

    // Test cases.
    initial begin
        // Display format information.
        $display("Format: Dividend (64-bit hex) | Divisor (32-bit hex) | Signed (1-bit) | Quotient (32-bit hex) | Remainder (64-bit hex) | Divide by zero (1-bit)");

        // Test case 1: Unsigned division, no remainder.
        dividend_in = 64'h0000000000000064;
        divisor_in = 32'h00000005;
        is_signed_div = 0;
        #10 display_result();

        // Test case 2: Unsigned division, with remainder.
        dividend_in = 64'h0000000000000067;
        divisor_in = 32'h00000005;
        is_signed_div = 0;
        #10 display_result();

        // Test case 3: Signed division, positive inputs.
        dividend_in = 64'h0000000000000064;
        divisor_in = 32'h00000005;
        is_signed_div = 1;
        #10 display_result();

        // Test case 4: Signed division, negative dividend.
        dividend_in = 64'hffffffffffffff9c; // -100 in signed 64-bit.
        divisor_in = 32'h00000005;
        is_signed_div = 1;
        #10 display_result();

        // Test case 5: Signed division, negative divisor.
        dividend_in = 64'h0000000000000064;
        divisor_in = 32'hfffffffb; // -5 in signed 32-bit.
        is_signed_div = 1;
        #10 display_result();

        // Test case 6: Signed division, negative dividend and divisor.
        dividend_in = 64'hffffffffffffff9c; // -100 in signed 64-bit.
        divisor_in = 32'hfffffffb; // -5 in signed 32-bit.
        is_signed_div = 1;
        #10 display_result();

        // Test case 7: Unsigned division by zero.
        dividend_in = 64'h0000000000000064;
        divisor_in = 32'h00000000;
        is_signed_div = 0;
        #10 display_result();

        // Test case 8: Signed division by zero.
        dividend_in = 64'hffffffffffffff9c; // -100 in signed 64-bit.
        divisor_in = 32'h00000000;
        is_signed_div = 1;
        #10 display_result();

        // End of test cases.
        $stop;
    end

endmodule
