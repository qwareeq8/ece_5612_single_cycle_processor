`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: Instruction Memory Testbench
// Module Name: instruction_memory_tb
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This testbench verifies the functionality of the `instruction_memory` module 
// by simulating the Program Counter's behavior and the corresponding instruction output.
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
// Dependencies: instruction_memory.
//
// Revision: Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module instruction_memory_tb;

    // Inputs to the DUT.
    reg [63:0] pc;               // Program Counter (64 bits).
    reg clk;                     // Clock signal.

    // Outputs from the DUT.
    wire [31:0] instruction;     // Instruction output (32 bits).

    // Instantiate the DUT.
    instruction_memory dut (
        .pc(pc),
        .clk(clk),
        .instruction(instruction)
    );

    // Generate clock signal.
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // Clock toggles every 5 time units (10ns period).
    end

    // Test sequence.
    initial begin
        // Display format information.
        $display("Format: PC (hexadecimal, 16 digits) | Instruction (binary, 32 bits)");
        
        // Test cases.
        pc = 64'd0; #10;
        $display("PC: %016h | Instruction: %032b", pc, instruction);

        pc = 64'd4; #10;
        $display("PC: %016h | Instruction: %032b", pc, instruction);

        pc = 64'd8; #10;
        $display("PC: %016h | Instruction: %032b", pc, instruction);

        pc = 64'd12; #10;
        $display("PC: %016h | Instruction: %032b", pc, instruction);

        pc = 64'd16; #10;
        $display("PC: %016h | Instruction: %032b", pc, instruction);

        pc = 64'd20; #10;
        $display("PC: %016h | Instruction: %032b", pc, instruction);

        pc = 64'd24; #10;
        $display("PC: %016h | Instruction: %032b", pc, instruction);

        $stop;  // End simulation.
    end

endmodule
