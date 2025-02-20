`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: Immediate Generator
// Module Name: immediate_generator
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This module generates a 64-bit immediate value based on the 32-bit instruction
// provided as input. The immediate value is sign-extended for all types of RISC-V
// instructions.
//
// Immediate Formats:
// I-Type (opcode = 0000011, 0010011): Immediate = sign_extend(instr[31:20]).
// S-Type (opcode = 0100011): Immediate = sign_extend({instr[31:25], instr[11:7]}).
// B-Type (opcode = 1100011): Immediate = sign_extend({instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}).
// U-Type (opcode = 0110111, 0010111): Immediate = sign_extend({instr[31:12], 12'b0}).
// J-Type (opcode = 1101111): Immediate = sign_extend({instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}).
//
// Dependencies: None.
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
////////////////////////////////////////////////////////////////////////////////

module immediate_generator (
    input [31:0] instr,   // 32-bit instruction.
    output reg [63:0] imm // 64-bit immediate value.
);

    always @(*) begin
        case (instr[6:0]) // Opcode field (bits [6:0]).
            7'b0000011, 7'b0010011: begin
                // I-Type (Load, ALU immediate instructions).
                imm = {{52{instr[31]}}, instr[31:20]}; // Sign-extend bits [31:20].
            end
            7'b0100011: begin
                // S-Type (Store instructions).
                imm = {{52{instr[31]}}, instr[31:25], instr[11:7]}; // Sign-extend [31:25 | 11:7].
            end
            7'b1100011: begin
                // B-Type (Branch instructions).
                imm = {{52{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
                // Sign-extend [31 | 7 | 30:25 | 11:8].
            end
            7'b0110111, 7'b0010111: begin
                // U-Type (LUI, AUIPC instructions).
                imm = {{32{instr[31]}}, instr[31:12], 12'b0}; // Sign-extend [31:12], append 12 zeros.
            end
            7'b1101111: begin
                // J-Type (JAL instruction).
                imm = {{44{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
                // Sign-extend [31 | 19:12 | 20 | 30:21].
            end
            default: begin
                // Default case: Zero immediate for unrecognized opcodes.
                imm = 64'b0;
            end
        endcase
    end

endmodule
