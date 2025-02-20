`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: 64-bit ALU
// Module Name: alu_64
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This module implements a 64-bit ALU capable of performing arithmetic, logical,
// comparison, load/store, multiplication, division, and remainder operations.
//
// Control Signals:
// 4'b0000 - Perform AND operation.
// 4'b0001 - Perform OR operation.
// 4'b0010 - Perform signed ADD operation.
// 4'b0011 - Perform unsigned ADDU operation (used for LD/SD).
// 4'b0110 - Perform signed SUB operation (used for BEQ).
// 4'b0111 - Perform unsigned SUBU operation.
// 4'b1000 - Perform signed MUL operation.
// 4'b1001 - Perform unsigned MULU operation.
// 4'b1010 - Perform signed DIV operation.
// 4'b1011 - Perform unsigned DIVU operation.
// 4'b1100 - Perform signed REM operation.
// 4'b1101 - Perform unsigned REMU operation.
// 4'b1110 - Perform signed MULH operation.
// 4'b1111 - Perform unsigned MULHU operation.
//
// Dependencies: add_rca_64, sub_rca_64, mul_64, div_64, and_64, or_64.
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module alu_64 (
    output reg [63:0] alu_result,         // 64-bit result of the ALU operation.
    output reg zero_flag,                 // Indicates zero result (used for BEQ).
    output reg overflow_flag,             // Indicates overflow in signed operations.
    output reg carry_out_flag,            // Indicates carry-out in unsigned addition.
    output reg divide_by_zero_flag,       // Indicates division by zero error.
    input [63:0] operand_a,               // First operand for ALU operations.
    input [63:0] operand_b,               // Second operand for ALU operations.
    input [3:0] alu_control               // Control signal to select ALU operation.
);

    // Internal wires for inter-module connections.
    wire [63:0] add_result, sub_result, mul_result, and_result, or_result;
    wire [31:0] div_result, rem_result;
    wire [63:0] remainder_out, mulh_result;
    wire add_overflow, sub_overflow, div_by_zero;
    wire add_carry_out, sub_borrow_out;

    // Determine signed/unsigned division based on control signal.
    wire is_signed_div = (alu_control == 4'b1010 || alu_control == 4'b1100);

    // Instantiate arithmetic and logical modules.
    add_rca_64 add_unit (
        .sum_out(add_result),                   // 64-bit addition result.
        .carry_out(add_carry_out),              // Carry-out for unsigned addition.
        .overflow(add_overflow),                // Overflow flag for signed addition.
        .input_a(operand_a),                    // First input for addition.
        .input_b(operand_b),                    // Second input for addition.
        .carry_in(1'b0),                        // Initial carry-in for addition.
        .is_signed_add(alu_control == 4'b0010)  // Control signal for signed addition.
    );

    sub_rca_64 sub_unit (
        .diff_out(sub_result),                  // 64-bit subtraction result.
        .borrow_out(sub_borrow_out),            // Borrow-out for unsigned subtraction.
        .overflow(sub_overflow),                // Overflow flag for signed subtraction.
        .input_a(operand_a),                    // First input for subtraction.
        .input_b(operand_b),                    // Second input for subtraction.
        .borrow_in(1'b0),                       // Initial borrow-in for subtraction.
        .is_signed_sub(alu_control == 4'b0110)  // Control signal for signed subtraction.
    );

    mul_64 mul_unit (
        .product_out(mul_result),               // 64-bit multiplication result.
        .multiplicand_in(operand_a[31:0]),      // First input for multiplication.
        .multiplier_in(operand_b[31:0]),        // Second input for multiplication.
        .is_signed_mult(alu_control == 4'b1000 || alu_control == 4'b1110) // Control for signed multiplication.
    );

    div_64 div_unit (
        .quotient_out(div_result),              // 32-bit division result.
        .remainder_out(remainder_out),          // 64-bit remainder output.
        .divide_by_zero_flag(div_by_zero),      // Division-by-zero flag.
        .dividend_in(operand_a),                // Dividend for division.
        .divisor_in(operand_b[31:0]),           // Divisor for division.
        .is_signed_div(is_signed_div)           // Control for signed division.
    );

    // Logical operations instantiations.
    and_64 and_unit (
        .y(and_result),                         // 64-bit AND result.
        .a(operand_a),                          // First input for AND operation.
        .b(operand_b)                           // Second input for AND operation.
    );

    or_64 or_unit (
        .y(output_y),                           // 64-bit OR result.
        .a(operand_a),                          // First input for OR operation.
        .b(operand_b)                           // Second input for OR operation.
    );

    // Extract high and low portions of results for special cases.
    assign rem_result = remainder_out[31:0];   // Lower 32 bits for remainder.
    assign mulh_result = mul_result[63:32];    // Upper 32 bits for MULH/MULHU.

    // ALU control logic.
    always @(*) begin
        alu_result = 64'd0;                      // Default ALU result.
        zero_flag = 1'b0;                        // Default zero flag.
        overflow_flag = 1'b0;                    // Default overflow flag.
        carry_out_flag = 1'b0;                   // Default carry-out flag.
        divide_by_zero_flag = 1'b0;              // Default division-by-zero flag.

        case (alu_control)
            4'b0000: alu_result = and_result;    // AND operation.
            4'b0001: alu_result = or_result;     // OR operation.
            4'b0010: begin                       // ADD (Signed).
                alu_result = add_result;
                overflow_flag = add_overflow;
            end
            4'b0011: begin                       // ADDU (Unsigned).
                alu_result = add_result;
                carry_out_flag = add_carry_out;
            end
            4'b0110: begin                       // SUB (Signed).
                alu_result = sub_result;
                overflow_flag = sub_overflow;
                zero_flag = (sub_result == 64'd0);
            end
            4'b0111: begin                       // SUBU (Unsigned).
                alu_result = sub_result;
                carry_out_flag = sub_borrow_out;
                zero_flag = (sub_result == 64'd0);
            end
            4'b1000: alu_result = mul_result;    // MUL (Signed).
            4'b1001: alu_result = mul_result;    // MULU (Unsigned).
            4'b1010: begin                       // DIV (Signed).
                alu_result = {{32{div_result[31]}}, div_result};
                divide_by_zero_flag = div_by_zero;
            end
            4'b1011: begin                       // DIVU (Unsigned).
                alu_result = {32'd0, div_result};
                divide_by_zero_flag = div_by_zero;
            end
            4'b1100: begin                       // REM (Signed).
                alu_result = {{32{rem_result[31]}}, rem_result};
                divide_by_zero_flag = div_by_zero;
            end
            4'b1101: begin                       // REMU (Unsigned).
                alu_result = {32'd0, rem_result};
                divide_by_zero_flag = div_by_zero;
            end
            4'b1110: alu_result = mulh_result;   // MULH (Signed).
            4'b1111: alu_result = mulh_result;   // MULHU (Unsigned).
            default: alu_result = 64'd0;         // Undefined operation.
        endcase
    end

endmodule
