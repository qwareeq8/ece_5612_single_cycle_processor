`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: ALU Control Unit
// Module Name: alu_control_unit
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description: This module generates the ALU control signal based on `alu_op`, 
//              `funct7`, and `funct3` fields from the instruction. It handles 
//              signed and unsigned operations uniquely by assigning distinct 
//              control signals.
//
// ALU Operations:
// alu_op: 00, funct7: XXXXXXX, funct3: XXX -> alu_control: 0010 (LD/SD - Signed ADD).
// alu_op: 01, funct7: XXXXXXX, funct3: XXX -> alu_control: 0110 (BEQ - Signed SUBTRACT).
// alu_op: 10, funct7: 1001000, funct3: 111 -> alu_control: 0000 (AND - Bitwise).
// alu_op: 10, funct7: 1001001, funct3: 111 -> alu_control: 0001 (OR - Bitwise).
// alu_op: 10, funct7: 0000000, funct3: 000 -> alu_control: 0010 (ADD - Signed).
// alu_op: 10, funct7: 1000001, funct3: 000 -> alu_control: 0011 (ADDU - Unsigned).
// alu_op: 10, funct7: 0100000, funct3: 000 -> alu_control: 0110 (SUB - Signed).
// alu_op: 10, funct7: 1000011, funct3: 100 -> alu_control: 0111 (SUBU - Unsigned).
// alu_op: 10, funct7: 0000001, funct3: 000 -> alu_control: 1000 (MUL - Signed).
// alu_op: 10, funct7: 0110001, funct3: 001 -> alu_control: 1001 (MULU - Unsigned).
// alu_op: 10, funct7: 0000001, funct3: 100 -> alu_control: 1010 (DIV - Signed).
// alu_op: 10, funct7: 0110101, funct3: 010 -> alu_control: 1011 (DIVU - Unsigned).
// alu_op: 10, funct7: 0111000, funct3: 011 -> alu_control: 1100 (REM - Signed).
// alu_op: 10, funct7: 0111001, funct3: 011 -> alu_control: 1101 (REMU - Unsigned).
// alu_op: 10, funct7: 0111100, funct3: 110 -> alu_control: 1110 (MULH - Signed).
// alu_op: 10, funct7: 0111101, funct3: 110 -> alu_control: 1111 (MULHU - Unsigned).
//
// Dependencies: None.
//
// Revision: Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module alu_control_unit (
    output reg [3:0] alu_control, // ALU control signal for ALU.
    input [1:0] alu_op,           // ALUOp field from the control unit.
    input [6:0] funct7,           // funct7 field from the instruction.
    input [2:0] funct3            // funct3 field from the instruction.
);

    always @(*) begin
        case (alu_op)
            2'b00: alu_control = 4'b0010; // LD/SD (Signed ADD).
            2'b01: alu_control = 4'b0110; // BEQ (Signed SUBTRACT).
            2'b10: begin
                case ({funct7, funct3})
                    10'b1001000_111: alu_control = 4'b0000; // AND (Bitwise).
                    10'b1001001_111: alu_control = 4'b0001; // OR (Bitwise).
                    10'b0000000_000: alu_control = 4'b0010; // ADD (Signed).
                    10'b1000001_000: alu_control = 4'b0011; // ADDU (Unsigned).
                    10'b0100000_000: alu_control = 4'b0110; // SUB (Signed).
                    10'b1000011_100: alu_control = 4'b0111; // SUBU (Unsigned).
                    10'b0000001_000: alu_control = 4'b1000; // MUL (Signed).
                    10'b0110001_001: alu_control = 4'b1001; // MULU (Unsigned).
                    10'b0000001_100: alu_control = 4'b1010; // DIV (Signed).
                    10'b0110101_010: alu_control = 4'b1011; // DIVU (Unsigned).
                    10'b0111000_011: alu_control = 4'b1100; // REM (Signed).
                    10'b0111001_011: alu_control = 4'b1101; // REMU (Unsigned).
                    10'b0111100_110: alu_control = 4'b1110; // MULH (Signed).
                    10'b0111101_110: alu_control = 4'b1111; // MULHU (Unsigned).
                    default: alu_control = 4'bxxxx; // Undefined.
                endcase
            end
            default: alu_control = 4'bxxxx; // Undefined.
        endcase
    end

endmodule
