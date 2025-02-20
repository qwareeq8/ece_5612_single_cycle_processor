`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: CPU Top Module Testbench
// Module Name: cpu_top_tb
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This testbench verifies the functionality of the CPU Top Module by testing
// the execution of instructions, including memory reads/writes and register
// updates. Detailed results are displayed, covering each cycle's key signals
// and the final states of the data memory and register file.
//
// Results:
// +---------------------------------------------------------------------------------------------------------------------------------------+
// | Cycle |        PC        |  Opcode  | Branch | MemRead | MemtoReg | ALUOp | MemWrite | ALUSrc |  RegWrite |    ALU Result    | DivBy0 |
// +---------------------------------------------------------------------------------------------------------------------------------------+
// |     0 | 0000000000000004 | 00000011 |    0   |    1    |    1     |  00   |    0     |   1    |     1     | 0000000000000000 |   0    |
// |     1 | 0000000000000008 | 00000011 |    0   |    1    |    1     |  00   |    0     |   1    |     1     | 0000000000000005 |   0    |
// |     2 | 000000000000000c | 00110011 |    0   |    0    |    0     |  10   |    0     |   0    |     1     | 0000000000000bb8 |   0    |
// |     3 | 0000000000000010 | 00000011 |    0   |    1    |    1     |  00   |    0     |   1    |     1     | 0000000000000002 |   0    |
// |     4 | 0000000000000014 | 00000011 |    0   |    1    |    1     |  00   |    0     |   1    |     1     | 0000000000000003 |   0    |
// |     5 | 0000000000000018 | 00110011 |    0   |    0    |    0     |  10   |    0     |   0    |     1     | 000000000001d4c0 |   0    |
// |     6 | 000000000000001c | 00110011 |    0   |    0    |    0     |  10   |    0     |   0    |     1     | fffffffffffe36f8 |   0    |
// |     7 | 0000000000000020 | 00000011 |    0   |    1    |    1     |  00   |    0     |   1    |     1     | 0000000000000004 |   0    |
// |     8 | 0000000000000024 | 00110011 |    0   |    0    |    0     |  10   |    0     |   0    |     1     | fffffffffffe3702 |   0    |
// |     9 | 0000000000000028 | 00000011 |    0   |    1    |    1     |  00   |    0     |   1    |     1     | 0000000000000001 |   0    |
// |    10 | 000000000000002c | 00110011 |    0   |    0    |    0     |  10   |    0     |   0    |     1     | fffffffffffffdb8 |   0    |
// |    11 | 0000000000000030 | 00100011 |    0   |    0    |    0     |  00   |    1     |   1    |     0     | 0000000000000006 |   0    |
// |    12 | 0000000000000034 | 0xxxxxxx |    0   |    0    |    0     |  00   |    0     |   0    |     0     | xxxxxxxxxxxxxxxx |   0    |
// |    13 | 0000000000000038 | 0xxxxxxx |    0   |    0    |    0     |  00   |    0     |   0    |     0     | xxxxxxxxxxxxxxxx |   0    |
// |    14 | 000000000000003c | 0xxxxxxx |    0   |    0    |    0     |  00   |    0     |   0    |     0     | xxxxxxxxxxxxxxxx |   0    |
// |    15 | 0000000000000040 | 0xxxxxxx |    0   |    0    |    0     |  00   |    0     |   0    |     0     | xxxxxxxxxxxxxxxx |   0    |
// |    16 | 0000000000000044 | 0xxxxxxx |    0   |    0    |    0     |  00   |    0     |   0    |     0     | xxxxxxxxxxxxxxxx |   0    |
// |    17 | 0000000000000048 | 0xxxxxxx |    0   |    0    |    0     |  00   |    0     |   0    |     0     | xxxxxxxxxxxxxxxx |   0    |
// |    18 | 000000000000004c | 0xxxxxxx |    0   |    0    |    0     |  00   |    0     |   0    |     0     | xxxxxxxxxxxxxxxx |   0    |
// |    19 | 0000000000000050 | 0xxxxxxx |    0   |    0    |    0     |  00   |    0     |   0    |     0     | xxxxxxxxxxxxxxxx |   0    |
// +---------------------------------------------------------------------------------------------------------------------------------------+
// 
// Data Memory Contents (Actual Byte Addresses):
// Format: Address (decimal) | Value (decimal, signed).
// Address:        0 | Value:                     1000.
// Address:        8 | Value:                      200.
// Address:       16 | Value:                      300.
// Address:       24 | Value:                      400.
// Address:       32 | Value:                       10.
// Address:       40 | Value:                        3.
// Address:       48 | Value:                     -584.
//
// Register File Contents:
// Format: Register Number (decimal) | Value (decimal, signed).
// Register:  0 | Value:                        0.
// Register:  1 | Value:                     1000.
// Register:  2 | Value:                        3.
// Register:  3 | Value:                     3000.
// Register:  4 | Value:                      300.
// Register:  5 | Value:                      400.
// Register:  6 | Value:                   120000.
// Register:  7 | Value:                  -117000.
// Register:  8 | Value:                       10.
// Register:  9 | Value:                  -116990.
// Register: 10 | Value:                      200.
// Register: 11 | Value:                     -584.
//
// Dependencies: cpu_top.
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module cpu_top_tb;

    // Testbench Inputs.
    reg clk; // Clock signal.
    reg reset; // Reset signal.
    reg enable; // Enable signal.

    // Outputs from the DUT.
    wire [63:0] pc_out; // Program Counter output.
    wire [31:0] instr; // Instruction output.
    wire [63:0] imm; // Immediate value output.
    wire [63:0] reg_out1; // Register File Output 1.
    wire [63:0] reg_out2; // Register File Output 2.
    wire [63:0] alu_result; // ALU result output.
    wire divide_by_zero_flag; // Division by zero flag.

    // Control Signals from the DUT.
    wire [1:0] alu_op; // ALU operation control signal.
    wire [3:0] alu_control; // ALU control signal.
    wire branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write; // Control signals.

    integer i, cycle_count = 0; // Loop counters.

    // Instantiate the DUT (Device Under Test).
    cpu_top dut (
        .reset(reset), // Reset signal.
        .enable(enable), // Enable signal.
        .clk(clk), // Clock signal.
        .pc_out(pc_out), // Program Counter output.
        .instr(instr), // Instruction output.
        .imm(imm), // Immediate value output.
        .reg_out1(reg_out1), // Register File Output 1.
        .reg_out2(reg_out2), // Register File Output 2.
        .alu_result(alu_result), // ALU result output.
        .divide_by_zero_flag(divide_by_zero_flag) // Division by zero flag.
    );

    // Extract signals from DUT for debugging.
    assign alu_op = dut.cu.alu_op; // ALU operation control signal.
    assign alu_control = dut.alu_ctrl.alu_control; // ALU control signal.
    assign branch = dut.cu.branch; // Branch control signal.
    assign mem_read = dut.cu.mem_read; // Memory read enable signal.
    assign mem_to_reg = dut.cu.mem_to_reg; // Memory to register signal.
    assign mem_write = dut.cu.mem_write; // Memory write enable signal.
    assign alu_src = dut.cu.alu_src; // ALU source selection signal.
    assign reg_write = dut.cu.reg_write; // Register write enable signal.

    // Clock generation (10 ns period).
    initial begin
        clk = 0; // Initialize clock.
        forever #5 clk = ~clk; // Toggle clock every 5 ns.
    end

    // Testbench logic
    initial begin
        $display("+---------------------------------------------------------------------------------------------------------------------------------------+");
        $display("| Cycle |        PC        |  Opcode  | Branch | MemRead | MemtoReg | ALUOp | MemWrite | ALUSrc |  RegWrite |    ALU Result    | DivBy0 |");
        $display("+---------------------------------------------------------------------------------------------------------------------------------------+");

        // Initialization.
        reset = 1;
        enable = 0;

        // Reset the CPU.
        @(posedge clk); #1;
        reset = 0;

        // Enable the CPU.
        @(posedge clk); #1;
        enable = 1;

        // Run for 20 cycles.
        repeat (20) begin
            @(posedge clk); #2; // Wait after clock edge for signals to settle.

            $display("| %5d | %16h | %8b |    %1b   |    %1b    |    %1b     |  %2b   |    %1b     |   %1b    |     %1b     | %16h |   %1b    |",
                     cycle_count, pc_out, instr[6:0], branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write, alu_result, divide_by_zero_flag);

            cycle_count = cycle_count + 1;
        end
		
		$display("+---------------------------------------------------------------------------------------------------------------------------------------+");
		
        // Print data memory contents after execution.
        $display("\nData Memory Contents (Actual Byte Addresses):");
        $display("Format: Address (decimal) | Value (decimal, signed).");
        for (i = 0; i <= 48; i = i + 8) begin
            $display("Address: %8d | Value: %24d.", i, $signed({dut.dm.memory[i], dut.dm.memory[i + 1], dut.dm.memory[i + 2], dut.dm.memory[i + 3],
                                                           dut.dm.memory[i + 4], dut.dm.memory[i + 5], dut.dm.memory[i + 6], dut.dm.memory[i + 7]}));
        end

        // Print register file contents after execution.
        $display("\nRegister File Contents:");
        $display("Format: Register Number (decimal) | Value (decimal, signed).");
        for (i = 0; i < 12; i = i + 1) begin
            $display("Register: %2d | Value: %24d.", i, $signed(dut.rf.registers[i]));
        end

        $stop; // Stop simulation.
    end


endmodule
