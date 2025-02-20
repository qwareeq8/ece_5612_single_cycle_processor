`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: ALU Control Unit Testbench
// Module Name: alu_control_unit_tb
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description: This testbench verifies the functionality of the ALU Control Unit 
//              by testing all possible combinations of `alu_op`, `funct7`, and 
//              `funct3` fields.
//
// Results:
// Format: alu_op (2-bit binary) | funct7 (7-bit binary) | funct3 (3-bit binary) | alu_control (4-bit binary)
// alu_op: 10 | funct7: 1001000 | funct3: 111 | alu_control: 0000
// alu_op: 10 | funct7: 1001001 | funct3: 111 | alu_control: 0001
// alu_op: 00 | funct7: xxxxxxx | funct3: xxx | alu_control: 0010
// alu_op: 10 | funct7: 0000000 | funct3: 000 | alu_control: 0010
// alu_op: 10 | funct7: 1000001 | funct3: 000 | alu_control: 0011
// alu_op: 01 | funct7: xxxxxxx | funct3: xxx | alu_control: 0110
// alu_op: 10 | funct7: 0100000 | funct3: 000 | alu_control: 0110
// alu_op: 10 | funct7: 1000011 | funct3: 100 | alu_control: 0111
// alu_op: 10 | funct7: 0000001 | funct3: 000 | alu_control: 1000
// alu_op: 10 | funct7: 0110001 | funct3: 001 | alu_control: 1001
// alu_op: 10 | funct7: 0000001 | funct3: 100 | alu_control: 1010
// alu_op: 10 | funct7: 0110101 | funct3: 010 | alu_control: 1011
// alu_op: 10 | funct7: 0111000 | funct3: 011 | alu_control: 1100
// alu_op: 10 | funct7: 0111001 | funct3: 011 | alu_control: 1101
// alu_op: 10 | funct7: 0111100 | funct3: 110 | alu_control: 1110
// alu_op: 10 | funct7: 0111101 | funct3: 110 | alu_control: 1111
// Dependencies: alu_control_unit.
//
// Revision: Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module alu_control_unit_tb;

    // Inputs.
    reg [1:0] alu_op;        // ALUOp field from the control unit.
    reg [6:0] funct7;        // funct7 field from the instruction.
    reg [2:0] funct3;        // funct3 field from the instruction.

    // Outputs.
    wire [3:0] alu_control;  // ALU control signal for ALU.

    // Instantiate the Unit Under Test (UUT).
    alu_control_unit uut (
        .alu_control(alu_control),
        .alu_op(alu_op),
        .funct7(funct7),
        .funct3(funct3)
    );

    // Task to display results.
    task display_result;
        begin
            $display("alu_op: %2b | funct7: %7b | funct3: %3b | alu_control: %4b",
                     alu_op, funct7, funct3, alu_control);
        end
    endtask

    // Test cases.
    initial begin
        $display("Format: alu_op (2-bit binary) | funct7 (7-bit binary) | funct3 (3-bit binary) | alu_control (4-bit binary)");

        alu_op = 2'b10; funct7 = 7'b1001000; funct3 = 3'b111; #10 display_result(); // AND.
        alu_op = 2'b10; funct7 = 7'b1001001; funct3 = 3'b111; #10 display_result(); // OR.
        alu_op = 2'b00; funct7 = 7'bXXXXXXX; funct3 = 3'bXXX; #10 display_result(); // LD/SD.
        alu_op = 2'b10; funct7 = 7'b0000000; funct3 = 3'b000; #10 display_result(); // ADD.
        alu_op = 2'b10; funct7 = 7'b1000001; funct3 = 3'b000; #10 display_result(); // ADDU.
        alu_op = 2'b01; funct7 = 7'bXXXXXXX; funct3 = 3'bXXX; #10 display_result(); // BEQ.
        alu_op = 2'b10; funct7 = 7'b0100000; funct3 = 3'b000; #10 display_result(); // SUB.
        alu_op = 2'b10; funct7 = 7'b1000011; funct3 = 3'b100; #10 display_result(); // SUBU.
        alu_op = 2'b10; funct7 = 7'b0000001; funct3 = 3'b000; #10 display_result(); // MUL.
        alu_op = 2'b10; funct7 = 7'b0110001; funct3 = 3'b001; #10 display_result(); // MULU.
        alu_op = 2'b10; funct7 = 7'b0000001; funct3 = 3'b100; #10 display_result(); // DIV.
        alu_op = 2'b10; funct7 = 7'b0110101; funct3 = 3'b010; #10 display_result(); // DIVU.
        alu_op = 2'b10; funct7 = 7'b0111000; funct3 = 3'b011; #10 display_result(); // REM.
        alu_op = 2'b10; funct7 = 7'b0111001; funct3 = 3'b011; #10 display_result(); // REMU.
        alu_op = 2'b10; funct7 = 7'b0111100; funct3 = 3'b110; #10 display_result(); // MULH.
        alu_op = 2'b10; funct7 = 7'b0111101; funct3 = 3'b110; #10 display_result(); // MULHU.

        $stop;
    end

endmodule
