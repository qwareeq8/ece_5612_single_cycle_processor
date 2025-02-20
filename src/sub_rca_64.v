`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: Ripple_Carry_Subtractor
// Module Name: sub_rca_64
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This module implements a 64-bit ripple carry subtractor using the ripple carry adder.
// Borrow-out is calculated independently of the adder's carry-out by comparing the inputs.
// Overflow detection is reused directly from the adder's overflow logic for signed subtraction.
//
// Dependencies: add_rca_64.
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module sub_rca_64 (
    output [63:0] diff_out,   // 64-bit difference output.
    output borrow_out,        // Borrow output for unsigned subtraction.
    output overflow,          // Overflow flag for signed subtraction.
    input [63:0] input_a,     // 64-bit input operand A (minuend).
    input [63:0] input_b,     // 64-bit input operand B (subtrahend).
    input borrow_in,          // Initial borrow input, used as carry-in.
    input is_signed_sub       // Control signal: 1 for signed operation, 0 for unsigned.
);

    // Internal signals.
    wire [63:0] b_complement;        // One's complement of the subtrahend.
    wire [63:0] twos_complement_b;   // Two's complement of the subtrahend.
    wire [63:0] sum_result;          // Result of addition (A + two's complement of B).
    wire adder_overflow;             // Overflow signal from the adder.

    // Calculate the one's complement of input_b.
    assign b_complement = ~input_b;

    // Calculate the two's complement of input_b (one's complement + 1).
    assign twos_complement_b = b_complement + {63'd0, 1'b1};

    // Use the adder for subtraction (A + two's complement of B).
    add_rca_64 adder_inst (
        .sum_out(sum_result),
        .carry_out(),        // Ignore carry-out from the adder.
        .overflow(adder_overflow),
        .input_a(input_a),
        .input_b(twos_complement_b),
        .carry_in(borrow_in),
        .is_signed_add(is_signed_sub)
    );

    // Assign the result to diff_out.
    assign diff_out = sum_result;

    // Borrow detection for unsigned subtraction:
    // Borrow occurs if A < (B + Borrow In).
    assign borrow_out = is_signed_sub ? 1'bx : (input_a < (input_b + borrow_in));

    // Overflow detection for signed subtraction:
    // Reuse the adder's overflow signal.
    assign overflow = is_signed_sub ? adder_overflow : 1'bx;

endmodule
