`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: 64-bit Multiplier
// Module Name: mul_64
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This module implements a 64-bit multiplier that performs both signed and
// unsigned multiplication based on the control signal 'is_signed_mult'.
// The multiplicand, multiplier, and product registers are implemented
// following standard hardware multiplier design with iterative bit-shifting.
//
// Dependencies: None.
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module mul_64 (
    output reg [63:0] product_out,   // 64-bit product output.
    input [31:0] multiplicand_in,   // 32-bit multiplicand input.
    input [31:0] multiplier_in,     // 32-bit multiplier input.
    input is_signed_mult            // Control signal: 1 for signed multiplication, 0 for unsigned.
    );

    // Internal registers.
    reg [63:0] multiplicand_reg;     // 64-bit multiplicand register.
    reg [31:0] multiplier_reg;       // 32-bit multiplier register.
    reg [63:0] product_reg;          // 64-bit product register.
    reg multiplicand_negative;       // Flag indicating if multiplicand is negative.
    reg multiplier_negative;         // Flag indicating if multiplier is negative.
    integer i;                       // Loop counter for iterations.

    always @(*) begin
        // Initialize registers.
        multiplicand_reg = {32'd0, multiplicand_in};
        multiplier_reg = multiplier_in;
        product_reg = 64'd0;
        multiplicand_negative = 1'b0;
        multiplier_negative = 1'b0;

        // Handle signed multiplication.
        if (is_signed_mult) begin
            // Step 1: Handle sign conversion for multiplicand.
            if (multiplicand_in[31] == 1'b1) begin
                multiplicand_reg[31:0] = ~multiplicand_in + 1; // Convert to positive.
                multiplicand_negative = 1'b1;                 // Mark as negative.
            end else begin
                multiplicand_reg[31:0] = multiplicand_in;
            end

            // Step 2: Handle sign conversion for multiplier.
            if (multiplier_in[31] == 1'b1) begin
                multiplier_reg = ~multiplier_in + 1; // Convert to positive.
                multiplier_negative = 1'b1;         // Mark as negative.
            end else begin
                multiplier_reg = multiplier_in;
            end
        end else begin
            // For unsigned multiplication, use inputs directly.
            multiplicand_reg[31:0] = multiplicand_in;
            multiplier_reg = multiplier_in;
        end

        // Step 3: Perform multiplication using iterative shifting.
        for (i = 0; i < 32; i = i + 1) begin
            // Add multiplicand to product if the LSB of multiplier is 1.
            if (multiplier_reg[0] == 1'b1) begin
                product_reg = product_reg + multiplicand_reg;
            end
            // Shift multiplicand left by 1 bit.
            multiplicand_reg = multiplicand_reg << 1;
            // Shift multiplier right by 1 bit.
            multiplier_reg = multiplier_reg >> 1;
        end

        // Step 4: Apply correction for signed multiplication.
        if (is_signed_mult) begin
            if (multiplicand_negative ^ multiplier_negative) begin
                product_reg = -product_reg;
            end
        end

        // Step 5: Assign the final product to the output.
        product_out = product_reg;
    end

endmodule
