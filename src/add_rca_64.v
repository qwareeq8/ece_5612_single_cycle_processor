`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
// 
// Create Date: 12/10/2024
// Design Name: Ripple_Carry_Adder
// Module Name: add_rca_64
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description: 
// This module implements a 64-bit Ripple Carry Adder. It performs signed or unsigned
// addition based on the control signal 'is_signed_add'. The overflow output is a don't 
// care during unsigned additions, and the carry_out output is a don't care during 
// signed additions.
// 
// Dependencies: add_rca_32, add_rca_16, add_rca_4, add_full, add_half.
// 
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module add_rca_64 (
    output [63:0] sum_out,    // 64-bit sum output.
    output carry_out,         // Final carry output (don't care when is_signed_add = 1).
    output overflow,          // Overflow flag for signed addition (don't care when is_signed_add = 0).
    input [63:0] input_a,     // 64-bit input operands A.
    input [63:0] input_b,     // 64-bit input operands B.
    input carry_in,           // Initial carry input.
    input is_signed_add       // Control signal: 1 for signed addition, 0 for unsigned.
    );

    wire carry_32;            // Internal carry signal between 32-bit adders.
    wire carry_msb_in;        // Carry into bit 63 from the last 32-bit adder.
    wire true_carry_out;      // Ungated carry_out from the second 32-bit adder.

    // Two instances of 32-bit ripple carry adders.
    add_rca_32 adder1 (
        .sum_out(sum_out[31:0]),
        .carry_out(carry_32),
        .overflow(),
        .input_a(input_a[31:0]),
        .input_b(input_b[31:0]),
        .carry_in(carry_in),
        .is_signed_add(is_signed_add)
    );

    add_rca_32 adder2 (
        .sum_out(sum_out[63:32]),
        .carry_out(true_carry_out),
        .overflow(carry_msb_in),
        .input_a(input_a[63:32]),
        .input_b(input_b[63:32]),
        .carry_in(carry_32),
        .is_signed_add(is_signed_add)
    );

    // During signed addition, carry_out is not meaningful, so set it to 'x'.
    // During unsigned addition, use the computed true_carry_out.
    assign carry_out = is_signed_add ? 1'bx : true_carry_out;

    // During signed addition, compute overflow as before.
    // During unsigned addition, overflow is not meaningful, so set it to 'x'.
    assign overflow = is_signed_add ? (~(input_a[63] ^ input_b[63]) && (input_a[63] ^ sum_out[63])) : 1'bx;

endmodule

//////////////////////////////////////////////////////////////////////////////////
// 32-bit Ripple Carry Adder Module.
//////////////////////////////////////////////////////////////////////////////////
module add_rca_32 (
    output [31:0] sum_out,   // 32-bit sum output.
    output carry_out,        // Final carry output.
    output overflow,         // Overflow flag for signed addition.
    input [31:0] input_a,    // 32-bit input operand A.
    input [31:0] input_b,    // 32-bit input operand B.
    input carry_in,          // Initial carry input.
    input is_signed_add      // Control signal: 1 for signed addition, 0 for unsigned.
    );

    wire carry_16;           // Internal carry signal between 16-bit adders.
    wire carry_msb_in;       // Carry into bit 31 from the last 16-bit adder.

    // Two instances of 16-bit ripple carry adders.
    add_rca_16 adder1 (
        .sum_out(sum_out[15:0]),
        .carry_out(carry_16),
        .overflow(),
        .input_a(input_a[15:0]),
        .input_b(input_b[15:0]),
        .carry_in(carry_in),
        .is_signed_add(is_signed_add)
    );

    add_rca_16 adder2 (
        .sum_out(sum_out[31:16]),
        .carry_out(carry_out),
        .overflow(carry_msb_in),
        .input_a(input_a[31:16]),
        .input_b(input_b[31:16]),
        .carry_in(carry_16),
        .is_signed_add(is_signed_add)
    );

    // Overflow detection for signed addition.
    assign overflow = is_signed_add ? (carry_msb_in ^ carry_out) : 1'b0;

endmodule

//////////////////////////////////////////////////////////////////////////////////
// 16-bit Ripple Carry Adder Module.
//////////////////////////////////////////////////////////////////////////////////
module add_rca_16 (
    output [15:0] sum_out,   // 16-bit sum output.
    output carry_out,        // Final carry output.
    output overflow,         // Overflow flag for signed addition.
    input [15:0] input_a,    // 16-bit input operand A.
    input [15:0] input_b,    // 16-bit input operand B.
    input carry_in,          // Initial carry input.
    input is_signed_add      // Control signal: 1 for signed addition, 0 for unsigned.
    );

    wire carry_4, carry_8, carry_12;    // Internal carry signals between 4-bit adders.
    wire carry_msb_in;                  // Carry into bit 15 from the last 4-bit adder.

    // Four instances of 4-bit ripple carry adders.
    add_rca_4 adder1 (
        .sum_out(sum_out[3:0]),
        .carry_out(carry_4),
        .carry_msb_in(),
        .input_a(input_a[3:0]),
        .input_b(input_b[3:0]),
        .carry_in(carry_in)
    );

    add_rca_4 adder2 (
        .sum_out(sum_out[7:4]),
        .carry_out(carry_8),
        .carry_msb_in(),
        .input_a(input_a[7:4]),
        .input_b(input_b[7:4]),
        .carry_in(carry_4)
    );

    add_rca_4 adder3 (
        .sum_out(sum_out[11:8]),
        .carry_out(carry_12),
        .carry_msb_in(),
        .input_a(input_a[11:8]),
        .input_b(input_b[11:8]),
        .carry_in(carry_8)
    );

    add_rca_4 adder4 (
        .sum_out(sum_out[15:12]),
        .carry_out(carry_out),
        .carry_msb_in(carry_msb_in),
        .input_a(input_a[15:12]),
        .input_b(input_b[15:12]),
        .carry_in(carry_12)
    );

    // Overflow detection for signed addition.
    assign overflow = is_signed_add ? (carry_msb_in ^ carry_out) : 1'b0;

endmodule

//////////////////////////////////////////////////////////////////////////////////
// 4-bit Ripple Carry Adder Module.
//////////////////////////////////////////////////////////////////////////////////
module add_rca_4 (
    output [3:0] sum_out,   // 4-bit sum output.
    output carry_out,       // Carry output from the 4-bit adder.
    output carry_msb_in,    // Carry into the most significant bit (bit 3).
    input [3:0] input_a,    // 4-bit input operand A.
    input [3:0] input_b,    // 4-bit input operand B.
    input carry_in          // Initial carry input.
    );

    wire carry_1, carry_2, carry_3; // Internal carry signals.

    // Four instances of full adders.
    add_full full_adder1 (.sum_out(sum_out[0]), .carry_out(carry_1), .input_a(input_a[0]), .input_b(input_b[0]), .carry_in(carry_in));
    add_full full_adder2 (.sum_out(sum_out[1]), .carry_out(carry_2), .input_a(input_a[1]), .input_b(input_b[1]), .carry_in(carry_1));
    add_full full_adder3 (.sum_out(sum_out[2]), .carry_out(carry_3), .input_a(input_a[2]), .input_b(input_b[2]), .carry_in(carry_2));
    add_full full_adder4 (.sum_out(sum_out[3]), .carry_out(carry_out), .input_a(input_a[3]), .input_b(input_b[3]), .carry_in(carry_3));

    // Output the carry into the most significant bit.
    assign carry_msb_in = carry_3;

endmodule

//////////////////////////////////////////////////////////////////////////////////
// Full Adder Module.
//////////////////////////////////////////////////////////////////////////////////
module add_full (
    output sum_out,    // Sum output.
    output carry_out,  // Carry output.
    input input_a,     // First input bit.
    input input_b,     // Second input bit.
    input carry_in     // Carry input.
    );

    wire xor1_out, and1_out, and2_out; // Internal signals for intermediate results.

    // First half adder.
    add_half half_adder1 (.sum_out(xor1_out), .carry_out(and1_out), .input_a(input_a), .input_b(input_b));

    // Second half adder.
    add_half half_adder2 (.sum_out(sum_out), .carry_out(and2_out), .input_a(xor1_out), .input_b(carry_in));

    // OR gate to compute final carry output.
    or or_gate (carry_out, and1_out, and2_out);

endmodule

//////////////////////////////////////////////////////////////////////////////////
// Half Adder Module.
//////////////////////////////////////////////////////////////////////////////////
module add_half (
    output sum_out,    // Sum output.
    output carry_out,  // Carry output.
    input input_a,     // First input bit.
    input input_b      // Second input bit.
    );

    xor xor_gate (sum_out, input_a, input_b);
    and and_gate (carry_out, input_a, input_b);

endmodule
