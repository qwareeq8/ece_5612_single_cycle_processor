`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: Control Unit Testbench
// Module Name: control_unit_tb
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description: This testbench verifies the functionality of the control unit
//              module by testing its response to various opcode inputs.
//
// Dependencies: control_unit.
//
// Results:
// Format: Opcode (7-bit binary) | Branch (1-bit binary) | MemRead (1-bit binary) | MemtoReg (1-bit binary) | ALUOp (2-bit binary) | MemWrite (1-bit binary) | ALUSrc (1-bit binary) | RegWrite (1-bit binary)
// Opcode: 0000011 | Branch: 0 | MemRead: 1 | MemtoReg: 1 | ALUOp: 00 | MemWrite: 0 | ALUSrc: 1 | RegWrite: 1
// Opcode: 0100011 | Branch: 0 | MemRead: 0 | MemtoReg: 0 | ALUOp: 00 | MemWrite: 1 | ALUSrc: 1 | RegWrite: 0
// Opcode: 1100011 | Branch: 1 | MemRead: 0 | MemtoReg: 0 | ALUOp: 01 | MemWrite: 0 | ALUSrc: 0 | RegWrite: 0
// Opcode: 0110011 | Branch: 0 | MemRead: 0 | MemtoReg: 0 | ALUOp: 10 | MemWrite: 0 | ALUSrc: 0 | RegWrite: 1
// Opcode: 1111111 | Branch: 0 | MemRead: 0 | MemtoReg: 0 | ALUOp: 00 | MemWrite: 0 | ALUSrc: 0 | RegWrite: 0
//
// Revision: Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module control_unit_tb;

    // Inputs to the DUT.
    reg [6:0] opcode; // Opcode input.

    // Outputs from the DUT.
    wire branch;
    wire mem_read;
    wire mem_to_reg;
    wire [1:0] alu_op;
    wire mem_write;
    wire alu_src;
    wire reg_write;

    // Instantiate the DUT.
    control_unit dut (
        .opcode(opcode),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write)
    );

    // Task to display results.
    task display_result;
        begin
            $display("Opcode: %7b | Branch: %1b | MemRead: %1b | MemtoReg: %1b | ALUOp: %2b | MemWrite: %1b | ALUSrc: %1b | RegWrite: %1b",
                     opcode, branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write);
        end
    endtask

    // Test cases.
    initial begin
        $display("Format: Opcode (7-bit binary) | Branch (1-bit binary) | MemRead (1-bit binary) | MemtoReg (1-bit binary) | ALUOp (2-bit binary) | MemWrite (1-bit binary) | ALUSrc (1-bit binary) | RegWrite (1-bit binary)");

        // Test Load (LD).
        opcode = 7'b0000011; #10;
        display_result();

        // Test Store (SD).
        opcode = 7'b0100011; #10;
        display_result();

        // Test Branch (BEQ).
        opcode = 7'b1100011; #10;
        display_result();

        // Test R-Type (ADD, SUB, MUL, etc.).
        opcode = 7'b0110011; #10;
        display_result();

        // Test Undefined Instruction.
        opcode = 7'b1111111; #10;
        display_result();

        $stop; // Stop simulation.
    end

endmodule
