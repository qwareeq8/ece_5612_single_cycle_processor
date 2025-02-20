`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: 64-bit ALU Testbench
// Module Name: alu_64_tb
// Project Name: RISC-V 64-bit Single-Cycle CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This testbench verifies the functionality of the 64-bit ALU by testing
// various operations, including arithmetic, logical, and branch instructions.
//
// Dependencies: alu_64.
//
// Results:
// Format: ALU Control (4-bit binary) | Operand A (64-bit hex) | Operand B (64-bit hex) | ALU Result (64-bit hex) | Zero (1-bit) | Overflow (1-bit) | Carry Out (1-bit)
// ALU Control: 0010 | Operand A: 0000000000000005 | Operand B: 0000000000000003 | ALU Result: 0000000000000008 | Zero: 0 | Overflow: 0 | Carry Out: 0
// ALU Control: 0011 | Operand A: ffffffffffffffff | Operand B: 0000000000000001 | ALU Result: 0000000000000000 | Zero: 0 | Overflow: 0 | Carry Out: 1
// ALU Control: 0110 | Operand A: 000000000000000a | Operand B: 000000000000000a | ALU Result: 0000000000000000 | Zero: 1 | Overflow: 0 | Carry Out: 0
// ALU Control: 0110 | Operand A: 0000000000000010 | Operand B: 0000000000000010 | ALU Result: 0000000000000000 | Zero: 1 | Overflow: 0 | Carry Out: 0
// ALU Control: 1000 | Operand A: 0000000000000003 | Operand B: 0000000000000002 | ALU Result: 0000000000000006 | Zero: 0 | Overflow: 0 | Carry Out: 0
// ALU Control: 1010 | Operand A: 000000000000000a | Operand B: 0000000000000003 | ALU Result: 0000000000000003 | Zero: 0 | Overflow: 0 | Carry Out: 0
// ALU Control: 0000 | Operand A: ffffffffffffffff | Operand B: 000000000000000f | ALU Result: 000000000000000f | Zero: 0 | Overflow: 0 | Carry Out: 0
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module alu_64_tb;

    // Inputs.
    reg [63:0] operand_a;    // First operand (64-bit input).
    reg [63:0] operand_b;    // Second operand (64-bit input).
    reg [3:0] alu_control;   // ALU control signal.

    // Outputs.
    wire [63:0] alu_result;        // ALU result (64-bit output).
    wire zero_flag;                // Zero flag.
    wire overflow_flag;            // Overflow flag for signed arithmetic.
    wire carry_out_flag;           // Carry out flag for unsigned addition.
    wire divide_by_zero_flag;      // Flag for division by zero.

    // Instantiate the Unit Under Test (UUT).
    alu_64 uut (
        .alu_result(alu_result),
        .zero_flag(zero_flag),
        .overflow_flag(overflow_flag),
        .carry_out_flag(carry_out_flag),
        .divide_by_zero_flag(divide_by_zero_flag),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .alu_control(alu_control)
    );

    // Task to display results.
    task display_result;
        begin
            $display("ALU Control: %4b | Operand A: %016h | Operand B: %016h | ALU Result: %016h | Zero: %b | Overflow: %b | Carry Out: %b",
                     alu_control, operand_a, operand_b, alu_result, zero_flag, overflow_flag, carry_out_flag);
        end
    endtask

    // Test cases.
    initial begin
        // Display format information.
        $display("Format: ALU Control (4-bit binary) | Operand A (64-bit hex) | Operand B (64-bit hex) | ALU Result (64-bit hex) | Zero (1-bit) | Overflow (1-bit) | Carry Out (1-bit)");

        // Test ADD (Signed).
        alu_control = 4'b0010;
        operand_a = 64'h0000000000000005;
        operand_b = 64'h0000000000000003;
        #10 display_result();

        // Test ADDU (Unsigned).
        alu_control = 4'b0011;
        operand_a = 64'hFFFFFFFFFFFFFFFF;
        operand_b = 64'h0000000000000001;
        #10 display_result();

        // Test SUB (Signed).
        alu_control = 4'b0110;
        operand_a = 64'h000000000000000A;
        operand_b = 64'h000000000000000A;
        #10 display_result();

        // Test BEQ (Zero flag).
        alu_control = 4'b0110;
        operand_a = 64'h0000000000000010;
        operand_b = 64'h0000000000000010;
        #10 display_result();

        // Test MUL (Signed).
        alu_control = 4'b1000;
        operand_a = 64'h0000000000000003;
        operand_b = 64'h0000000000000002;
        #10 display_result();

        // Test DIV (Signed).
        alu_control = 4'b1010;
        operand_a = 64'h000000000000000A;
        operand_b = 64'h0000000000000003;
        #10 display_result();

        // Test AND.
        alu_control = 4'b0000;
        operand_a = 64'hFFFFFFFFFFFFFFFF;
        operand_b = 64'h000000000000000F;
        #10 display_result();

        // End of test cases.
        $stop;
    end

endmodule
