`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: Immediate Generator Testbench
// Module Name: immediate_generator_tb
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This testbench verifies the functionality of the Immediate Generator module by
// testing various RISC-V instruction formats (I-Type, S-Type, B-Type, U-Type, J-Type).
//
// Results:
// Format: Instruction (binary, 32 bits) | Immediate (hexadecimal, 16 digits)
// Instruction (binary): 00000000001100001000010100010011 | Immediate (hexadecimal): 0000000000000003
// Instruction (binary): 00000000110000001010000000100011 | Immediate (hexadecimal): 0000000000000000
// Instruction (binary): 00000000101000001000000001100011 | Immediate (hexadecimal): 0000000000000000
// Instruction (binary): 00000000010100001000000010110111 | Immediate (hexadecimal): 0000000000508000
// Instruction (binary): 00000000101000000000111101101111 | Immediate (hexadecimal): 000000000000000a
//
// Dependencies: immediate_generator.
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
////////////////////////////////////////////////////////////////////////////////

module immediate_generator_tb;

    // Inputs to the DUT.
    reg [31:0] instr; // 32-bit instruction input.

    // Outputs from the DUT.
    wire [63:0] imm; // 64-bit immediate output.

    // Instantiate the DUT.
    immediate_generator dut (
        .instr(instr), // Connect instruction input to DUT.
        .imm(imm)      // Connect immediate output from DUT.
    );

    // Task to display results.
    task display_result;
        input [31:0] instr; // Input instruction.
        input [63:0] imm;   // Input immediate value.
        begin
            $display("Instruction (binary): %b | Immediate (hexadecimal): %h", instr, imm);
        end
    endtask

    // Test cases.
    initial begin
        $display("Format: Instruction (binary, 32 bits) | Immediate (hexadecimal, 16 digits)");

        // I-Type instruction test (example: ADDI R1, R2, 3).
        instr = 32'b00000000001100001000010100010011; // I-Type instruction.
        #10 display_result(instr, imm);

        // S-Type instruction test (example: SD R1, R2, 25).
        instr = 32'b00000000110000001010000000100011; // S-Type instruction.
        #10 display_result(instr, imm);

        // B-Type instruction test (example: BEQ R1, R2, 40).
        instr = 32'b00000000101000001000000001100011; // B-Type instruction.
        #10 display_result(instr, imm);

        // U-Type instruction test (example: LUI R1, 0x5000).
        instr = 32'b00000000010100001000000010110111; // U-Type instruction.
        #10 display_result(instr, imm);

        // J-Type instruction test (example: JAL R1, 0x27E0).
        instr = 32'b00000000101000000000111101101111; // J-Type instruction.
        #10 display_result(instr, imm);

        $stop; // End simulation.
    end

endmodule
