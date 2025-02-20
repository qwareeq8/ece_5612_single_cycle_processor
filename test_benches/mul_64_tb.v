`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: 64-bit Multiplier Testbench
// Module Name: mul_64_tb
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This testbench verifies the functionality of the 64-bit Multiplier (mul_64).
// It tests various cases, including signed/unsigned multiplication, edge cases like
// overflows, and typical scenarios. All outputs are displayed in hexadecimal format.
//
// Dependencies: mul_64.
//
// Results:
// Format: Multiplicand (32-bit hex) | Multiplier (32-bit hex) | Signed (1-bit) | Product Out (64-bit hex)
// Multiplicand: 00000005 | Multiplier: 0000000a | Signed: 0 | Product Out: 0000000000000032
// Multiplicand: ffffffff | Multiplier: 00000001 | Signed: 0 | Product Out: 00000000ffffffff
// Multiplicand: 7fffffff | Multiplier: 00000002 | Signed: 1 | Product Out: 00000000fffffffe
// Multiplicand: 80000000 | Multiplier: ffffffff | Signed: 1 | Product Out: 0000000080000000
// Multiplicand: 00003039 | Multiplier: fffffdaf | Signed: 1 | Product Out: ffffffffff904bf7
// Multiplicand: 00000000 | Multiplier: ffffffff | Signed: 0 | Product Out: 0000000000000000
// Multiplicand: ffffff9c | Multiplier: ffffff38 | Signed: 1 | Product Out: 0000000000004e20
// Multiplicand: 00000000 | Multiplier: 00000000 | Signed: 0 | Product Out: 0000000000000000
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module mul_64_tb;

    // Inputs.
    reg [31:0] multiplicand_in;
    reg [31:0] multiplier_in;
    reg is_signed_mult;

    // Outputs.
    wire [63:0] product_out;

    // Instantiate the 64-bit Multiplier.
    mul_64 uut (
        .product_out(product_out),
        .multiplicand_in(multiplicand_in),
        .multiplier_in(multiplier_in),
        .is_signed_mult(is_signed_mult)
    );

    // Display format information.
    initial begin
        $display("Format: Multiplicand (32-bit hex) | Multiplier (32-bit hex) | Signed (1-bit) | Product Out (64-bit hex)");
    end

    // Task to display results in a single line.
    task display_result;
        begin
            $display("Multiplicand: %08h | Multiplier: %08h | Signed: %1b | Product Out: %016h",
                     multiplicand_in, multiplier_in, is_signed_mult, product_out);
        end
    endtask

    // Stimulus.
    initial begin
        // Case 1: Unsigned multiplication, both positive.
        multiplicand_in = 32'h00000005;
        multiplier_in = 32'h0000000A;
        is_signed_mult = 0;
        #10 display_result();

        // Case 2: Unsigned multiplication, one large value.
        multiplicand_in = 32'hFFFFFFFF; // Max unsigned 32-bit value.
        multiplier_in = 32'h00000001;
        is_signed_mult = 0;
        #10 display_result();

        // Case 3: Signed multiplication, both positive.
        multiplicand_in = 32'h7FFFFFFF; // Max positive signed 32-bit value.
        multiplier_in = 32'h00000002;
        is_signed_mult = 1;
        #10 display_result();

        // Case 4: Signed multiplication, one positive, one negative.
        multiplicand_in = 32'h80000000; // Min negative signed 32-bit value.
        multiplier_in = 32'hFFFFFFFF; // -1 in signed.
        is_signed_mult = 1;
        #10 display_result();

        // Case 5: Mixed signed multiplication, result within range.
        multiplicand_in = 32'h00003039; // Decimal 12345 in hex.
        multiplier_in = 32'hFFFFFDAF; // Decimal -54321 in hex.
        is_signed_mult = 1;
        #10 display_result();

        // Case 6: Unsigned multiplication, edge case with zero.
        multiplicand_in = 32'h00000000;
        multiplier_in = 32'hFFFFFFFF; // Max unsigned 32-bit integer.
        is_signed_mult = 0;
        #10 display_result();

        // Case 7: Signed multiplication, both negative.
        multiplicand_in = 32'hFFFFFF9C; // Decimal -100 in hex.
        multiplier_in = 32'hFFFFFF38; // Decimal -200 in hex.
        is_signed_mult = 1;
        #10 display_result();

        // Case 8: Edge case, both inputs zero.
        multiplicand_in = 32'h00000000;
        multiplier_in = 32'h00000000;
        is_signed_mult = 0;
        #10 display_result();

        $stop;
    end

endmodule
