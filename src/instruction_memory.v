`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: Instruction Memory
// Module Name: instruction_memory
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This module implements a 64-byte instruction memory that interacts with the 
// Program Counter (PC) and latches the instruction output on the clock edge.
// It stores instructions to evaluate the expression:
//
//   y = ((a*f - c*d) + e) / b
//
// Each instruction is 4 bytes, so the PC increments by 4 for each subsequent 
// instruction. The memory address is derived as memory[pc[7:0]].
//
// Dependencies: None.
//
// Results:
// Format: PC (hexadecimal, 16 digits) | Instruction (binary, 32 bits)
// PC: 0000000000000000 | Instruction: 00000000000000000011000010000011
// PC: 0000000000000004 | Instruction: 00000000010100000011000100000011
// PC: 0000000000000008 | Instruction: 00000010000100010000000110110011
// PC: 000000000000000c | Instruction: 00000000001000000011001000000011
// PC: 0000000000000010 | Instruction: 00000000001100000011001010000011
// PC: 0000000000000014 | Instruction: 00000010010000101000001100110011
// PC: 0000000000000018 | Instruction: 01000000011000011000001110110011
//
// Revision: Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module instruction_memory (
    input [63:0] pc,            // Program Counter (64 bits).
    input clk,                  // Clock signal.
    output reg [31:0] instruction // Instruction output (32 bits).
);

    // Memory array to store instructions (64 bytes, 8-bit width each).
    reg [7:0] memory [0:63];

    // Initialize instruction memory with predefined instructions.
    initial begin
        // LD R1,0x00 (Load 'a').
        memory[0]  = 8'b00000000;
        memory[1]  = 8'b00000000;
        memory[2]  = 8'b00110000;
        memory[3]  = 8'b10000011;
        // LD R2,0x05 (Load 'f').
        memory[4]  = 8'b00000000;
        memory[5]  = 8'b01010000;
        memory[6]  = 8'b00110001;
        memory[7]  = 8'b00000011;
        // MUL R3,R1,R2 (a*f).
        memory[8]  = 8'b00000010;
        memory[9]  = 8'b00010001;
        memory[10] = 8'b00000001;
        memory[11] = 8'b10110011;
        // LD R4,0x02 (Load 'c').
        memory[12] = 8'b00000000;
        memory[13] = 8'b00100000;
        memory[14] = 8'b00110010;
        memory[15] = 8'b00000011;
        // LD R5,0x03 (Load 'd').
        memory[16] = 8'b00000000;
        memory[17] = 8'b00110000;
        memory[18] = 8'b00110010;
        memory[19] = 8'b10000011;
        // MUL R6,R4,R5 (c*d).
        memory[20] = 8'b00000010;
        memory[21] = 8'b01000010;
        memory[22] = 8'b10000011;
        memory[23] = 8'b00110011;
        // SUB R7,R3,R6 (a*f - c*d).
        memory[24] = 8'b01000000;
        memory[25] = 8'b01100001;
        memory[26] = 8'b10000011;
        memory[27] = 8'b10110011;
        // LD R8,0x04 (Load 'e').
        memory[28] = 8'b00000000;
        memory[29] = 8'b01000000;
        memory[30] = 8'b00110100;
        memory[31] = 8'b00000011;
        // ADD R9,R7,R8 ((a*f - c*d) + e).
        memory[32] = 8'b00000000;
        memory[33] = 8'b01110100;
        memory[34] = 8'b00000100;
        memory[35] = 8'b10110011;
        // LD R10,0x01 (Load 'b').
        memory[36] = 8'b00000000;
        memory[37] = 8'b00010000;
        memory[38] = 8'b00110101;
        memory[39] = 8'b00000011;
        // DIV R11,R9,R10 (((a*f - c*d) + e) / b).
        memory[40] = 8'b00000010;
        memory[41] = 8'b10100100;
        memory[42] = 8'b11000101;
        memory[43] = 8'b10110011;
        // SD R11,0x06 (Store y).
        memory[44] = 8'b00000000;
        memory[45] = 8'b10110000;
        memory[46] = 8'b00110011;
        memory[47] = 8'b00100011;
    end

    // Latch the instruction on the rising edge of the clock.
    always @(posedge clk) begin
        instruction <= {memory[pc[7:0]], memory[pc[7:0] + 1], memory[pc[7:0] + 2], memory[pc[7:0] + 3]};
    end

endmodule
