`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: Control Unit
// Module Name: control_unit
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description: This module implements the control unit for a 64-bit RISC-V
//              single-cycle CPU. The control unit generates control signals
//              based on the instruction's opcode.
//
// Control Operations:
// opcode: 0000011 -> branch: 0, mem_read: 1, mem_to_reg: 1, alu_op: 00, mem_write: 0, alu_src: 1, reg_write: 1 (Load Instruction).
// opcode: 0100011 -> branch: 0, mem_read: 0, mem_to_reg: 0, alu_op: 00, mem_write: 1, alu_src: 1, reg_write: 0 (Store Instruction).
// opcode: 1100011 -> branch: 1, mem_read: 0, mem_to_reg: 0, alu_op: 01, mem_write: 0, alu_src: 0, reg_write: 0 (Branch Instruction).
// opcode: 0110011 -> branch: 0, mem_read: 0, mem_to_reg: 0, alu_op: 10, mem_write: 0, alu_src: 0, reg_write: 1 (R-Type Instruction).
//
// Dependencies: None.
//
// Revision: Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module control_unit (
    input [6:0] opcode,           // Instruction opcode (bits [6:0]).
    output reg branch,            // Branch control signal.
    output reg mem_read,          // Memory read control signal.
    output reg mem_to_reg,        // Memory to register control signal.
    output reg [1:0] alu_op,      // ALU operation control signal.
    output reg mem_write,         // Memory write control signal.
    output reg alu_src,           // ALU source select signal.
    output reg reg_write          // Register write control signal.
);

    always @(*) begin
        // Default control signals.
        branch = 0;
        mem_read = 0;
        mem_to_reg = 0;
        alu_op = 2'b00;
        mem_write = 0;
        alu_src = 0;
        reg_write = 0;

        case (opcode)
            7'b0000011: begin // Load (LD).
                branch = 0;
                mem_read = 1;
                mem_to_reg = 1;
                alu_op = 2'b00;
                mem_write = 0;
                alu_src = 1;
                reg_write = 1;
            end
            7'b0100011: begin // Store (SD).
                branch = 0;
                mem_read = 0;
                mem_to_reg = 0;
                alu_op = 2'b00;
                mem_write = 1;
                alu_src = 1;
                reg_write = 0;
            end
            7'b1100011: begin // Branch (BEQ).
                branch = 1;
                mem_read = 0;
                mem_to_reg = 0;
                alu_op = 2'b01;
                mem_write = 0;
                alu_src = 0;
                reg_write = 0;
            end
            7'b0110011: begin // R-type (ADD, SUB, MUL, etc.).
                branch = 0;
                mem_read = 0;
                mem_to_reg = 0;
                alu_op = 2'b10;
                mem_write = 0;
                alu_src = 0;
                reg_write = 1;
            end
            default: begin // Default: Undefined instruction.
                branch = 0;
                mem_read = 0;
                mem_to_reg = 0;
                alu_op = 2'b00;
                mem_write = 0;
                alu_src = 0;
                reg_write = 0;
            end
        endcase
    end

endmodule
