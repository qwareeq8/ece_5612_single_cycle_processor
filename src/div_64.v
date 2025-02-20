`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: 64-bit Divider
// Module Name: div_64
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This module implements a 64-bit divider capable of handling both signed and
// unsigned division using a hardware-like iterative algorithm. It provides the 
// quotient, remainder, and a divide-by-zero flag for error handling. The division 
// mode (signed or unsigned) is determined by the `is_signed_div` control input.
//
// Dependencies: None.
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module div_64 (
    output reg [31:0] quotient_out,      // 32-bit quotient output.
    output reg [63:0] remainder_out,     // 64-bit remainder output.
    output reg divide_by_zero_flag,      // Flag indicating divide-by-zero error.
    input [63:0] dividend_in,            // 64-bit dividend input.
    input [31:0] divisor_in,             // 32-bit divisor input.
    input is_signed_div                  // Control signal: 1 for signed division, 0 for unsigned.
);

    // Internal signals for iterative division algorithm.
    reg [63:0] rem;                      // Remainder register.
    reg [63:0] div;                      // Divisor register.
    reg [31:0] quot;                     // Quotient register.
    reg dividend_neg;                    // Indicates if the dividend is negative.
    reg divisor_neg;                     // Indicates if the divisor is negative.
    integer i;                           // Loop counter for iterative division.

    always @(*) begin
        // Initialize outputs to default values.
        quotient_out = 32'd0;            // Default quotient is zero.
        remainder_out = 64'd0;           // Default remainder is zero.
        divide_by_zero_flag = 1'b0;      // Default: No divide-by-zero error.

        // Step 1: Handle divide-by-zero case.
        if (divisor_in == 0) begin
            divide_by_zero_flag = 1'b1;  // Set divide-by-zero flag.
        end else begin
            // Step 2: Handle sign adjustments for signed division.
            dividend_neg = is_signed_div && dividend_in[63]; // Dividend is negative if signed and MSB is 1.
            divisor_neg = is_signed_div && divisor_in[31];   // Divisor is negative if signed and MSB is 1.

            // Step 3: Initialize remainder and divisor registers.
            rem = (dividend_neg) ? {64'd0 - dividend_in} : dividend_in; // Convert dividend to positive if needed.
            div = (divisor_neg) ? {32'd0 - divisor_in, 32'd0} : {divisor_in, 32'd0}; // Convert divisor to positive.
            quot = 32'd0;                   // Reset quotient register.

            // Step 4: Perform iterative division.
            for (i = 0; i < 33; i = i + 1) begin
                if (rem >= div) begin
                    // If remainder is greater than or equal to divisor:
                    rem = rem - div;       // Subtract divisor from remainder.
                    quot = (quot << 1) | 1'b1; // Shift quotient left and set LSB to 1.
                end else begin
                    // If remainder is less than divisor:
                    quot = (quot << 1);    // Shift quotient left and set LSB to 0.
                end
                div = div >> 1;            // Shift divisor right for next iteration.
            end

            // Step 5: Adjust signs of results for signed division.
            if (is_signed_div) begin
                if (dividend_neg ^ divisor_neg) begin
                    // If dividend and divisor signs differ:
                    quot = ~quot + 1;     // Negate the quotient.
                end
                rem = (dividend_neg) ? ~rem + 1 : rem; // Adjust remainder sign if dividend was negative.
            end

            // Step 6: Assign final outputs.
            quotient_out = quot;          // Assign the computed quotient.
            remainder_out = rem;          // Assign the computed remainder.
        end
    end

endmodule
