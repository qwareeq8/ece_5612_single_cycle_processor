`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: CPU Top Module
// Module Name: cpu_top
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This module implements the CPU's top-level functionality by integrating the 
// Program Counter, Instruction Memory, Control Unit, ALU, Register File, 
// Immediate Generator, Data Memory, and supporting components. It includes 
// corrected address calculation for data memory, integration of the 
// `divide_by_zero_flag` for monitoring division operations, and properly 
// connected control signals across all components.
//
// Dependencies: program_counter, instruction_memory, immediate_generator, 
// control_unit, register_file, alu_control_unit, mux_2to1, alu_64, data_memory.
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module cpu_top (
    input reset,                    // Reset signal for the Program Counter.
    input enable,                   // Enable signal for the Program Counter.
    input clk,                      // Clock signal.
    output [63:0] pc_out,           // Program Counter output.
    output [31:0] instr,            // Instruction output.
    output [63:0] imm,              // Immediate value output.
    output [63:0] reg_out1,         // Register File Output 1.
    output [63:0] reg_out2,         // Register File Output 2.
    output [63:0] alu_result,       // ALU result output.
    output divide_by_zero_flag      // Division by zero flag from ALU.
);

    // Internal Signals.
    wire [63:0] alu_operand_b; // Second operand for the ALU.
    wire [3:0] alu_control;    // ALU control signal.
    wire branch;               // Branch control signal.
    wire mem_read;             // Memory read enable signal.
    wire mem_to_reg;           // Memory-to-register control signal.
    wire mem_write;            // Memory write enable signal.
    wire alu_src;              // ALU source selection signal.
    wire reg_write;            // Register write enable signal.
    wire [1:0] alu_op;         // ALU operation control signal.

    wire [63:0] data_mem_out;  // Data read from memory.
    wire [63:0] wb_data;       // Data to be written back to the Register File.

    // Signals for branching.
    wire zero_flag;            // Zero flag from ALU.
    wire [63:0] shifted_imm;   // Immediate value shifted left by 1.
    wire [63:0] branch_target; // Target address for branching.
    wire [63:0] pc_plus_4;     // Next sequential PC address.
    wire [63:0] next_pc;       // Next PC address (branch target or PC+4).

    // Compute PC+4 for normal instruction flow.
    assign pc_plus_4 = pc_out + 64'd4;

    // Shift immediate left by 1 for branch target calculation.
    shift_left_64 shifter (
        .in(imm),
        .out(shifted_imm)
    );

    // Calculate branch target address.
    assign branch_target = pc_out + shifted_imm;

    // Determine the next PC: branch target or PC+4.
    assign next_pc = (branch && zero_flag) ? branch_target : pc_plus_4;

    // Instantiate Program Counter.
    program_counter pc (
        .pc(pc_out),
        .pc_in(next_pc),
        .reset(reset),
        .enable(enable),
        .clk(clk)
    );

    // Instantiate Instruction Memory.
    instruction_memory im (
        .instruction(instr),
        .pc(pc_out),
        .clk(clk)
    );

    // Instantiate Immediate Generator.
    immediate_generator ig (
        .instr(instr),
        .imm(imm)
    );

    // Instantiate Control Unit.
    control_unit cu (
        .opcode(instr[6:0]),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write)
    );

    // Instantiate Register File.
    register_file rf (
        .read_reg1(instr[19:15]),
        .read_reg2(instr[24:20]),
        .write_reg(instr[11:7]),
        .write_data(wb_data),
        .reg_write(reg_write),
        .clk(clk),
        .read_data1(reg_out1),
        .read_data2(reg_out2)
    );

    // Instantiate ALU Control Unit.
    alu_control_unit alu_ctrl (
        .alu_control(alu_control),
        .alu_op(alu_op),
        .funct7(instr[31:25]),
        .funct3(instr[14:12])
    );

    // MUX for ALU Operand B.
    mux_2to1 alu_mux (
        .out(alu_operand_b),
        .in0(reg_out2),        // Second source register.
        .in1(imm),             // Immediate value.
        .sel(alu_src)          // Select signal from Control Unit.
    );

    // Instantiate ALU.
    alu_64 alu (
        .alu_result(alu_result),
        .zero_flag(zero_flag),
        .overflow_flag(),      // Overflow flag (optional, not connected).
        .carry_out_flag(),     // Carry-out flag (optional, not connected).
        .divide_by_zero_flag(divide_by_zero_flag), // Division by zero flag.
        .operand_a(reg_out1),  // First operand (Register File Output 1).
        .operand_b(alu_operand_b), // Second operand (from MUX).
        .alu_control(alu_control)  // ALU control signal from ALU Control Unit.
    );

    // Instantiate Data Memory.
    data_memory dm (
        .address(alu_result[5:0]), // Use bits [5:0] of ALU result for byte address.
        .write_data(reg_out2),     // Data to write into memory.
        .mem_read(mem_read),       // Read enable signal.
        .mem_write(mem_write),     // Write enable signal.
        .clk(clk),
        .read_data(data_mem_out)   // Data read from memory.
    );

    // MUX for Write-Back Stage.
    mux_2to1 wb_mux (
        .out(wb_data),
        .in0(alu_result),         // Data from ALU.
        .in1(data_mem_out),       // Data from Data Memory.
        .sel(mem_to_reg)          // Select signal from Control Unit.
    );

endmodule
