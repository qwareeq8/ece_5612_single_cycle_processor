`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: Data Memory Testbench
// Module Name: data_memory_tb
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description: This testbench verifies the read and write functionality of the 
//              Data Memory module using a variety of simulated scenarios.
//
// Dependencies: data_memory.
//
// Results:
// Format: Cycle (Decimal) | Address (6-bit hex) | Write Data (64-bit hex) | MemWrite (Binary) | MemRead (Binary) | Read Data (64-bit hex)
// Cycle:                    2 | Address: 00 | Write Data: deadbeef12345678 | MemWrite: 1 | MemRead: 0 | Read Data: 0000000000000000
// Cycle:                    3 | Address: 01 | Write Data: cafebabe87654321 | MemWrite: 1 | MemRead: 0 | Read Data: 0000000000000000
// Cycle:                    4 | Address: 02 | Write Data: 123456789abcdef0 | MemWrite: 1 | MemRead: 0 | Read Data: 0000000000000000
// Cycle:                    5 | Address: 00 | Write Data: - | MemWrite: 0 | MemRead: 1 | Read Data: deadbeef12345678
// Cycle:                    6 | Address: 01 | Write Data: - | MemWrite: 0 | MemRead: 1 | Read Data: cafebabe87654321
// Cycle:                    7 | Address: 02 | Write Data: - | MemWrite: 0 | MemRead: 1 | Read Data: 123456789abcdef0
// Cycle:                    8 | Address: 03 | Write Data: aabbccddeeff0011 | MemWrite: 1 | MemRead: 0 | Read Data: 0000000000000000
// Cycle:                    9 | Address: 03 | Write Data: - | MemWrite: 0 | MemRead: 1 | Read Data: aabbccddeeff0011
//
//
// Revision: Revision 0.1 - File created.
// Additional Comments:
// None.
////////////////////////////////////////////////////////////////////////////////

module data_memory_tb;

    // Inputs to the DUT.
    reg [5:0] address;           // Memory address input.
    reg [63:0] write_data;       // Data to write into memory.
    reg mem_read;                // Memory read enable signal.
    reg mem_write;               // Memory write enable signal.
    reg clk;                     // Clock signal.

    // Output from the DUT.
    wire [63:0] read_data;       // Data read from memory.

    // Instantiate the DUT.
    data_memory dut (
        .address(address),
        .write_data(write_data),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .clk(clk),
        .read_data(read_data)
    );

    // Clock generation: 10ns period.
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test cases.
    initial begin
        $display("Format: Cycle (Decimal) | Address (6-bit hex) | Write Data (64-bit hex) | MemWrite (Binary) | MemRead (Binary) | Read Data (64-bit hex)");

        // Initialize signals.
        address = 6'd0;
        write_data = 64'd0;
        mem_read = 0;
        mem_write = 0;
        #10;

        // Write data to memory and display results.
        address = 6'd0; write_data = 64'hDEADBEEF12345678; mem_write = 1; mem_read = 0; #10;
        $display("Cycle: %d | Address: %h | Write Data: %h | MemWrite: %b | MemRead: %b | Read Data: %h", $time / 10, address, write_data, mem_write, mem_read, read_data);

        address = 6'd1; write_data = 64'hCAFEBABE87654321; mem_write = 1; mem_read = 0; #10;
        $display("Cycle: %d | Address: %h | Write Data: %h | MemWrite: %b | MemRead: %b | Read Data: %h", $time / 10, address, write_data, mem_write, mem_read, read_data);

        address = 6'd2; write_data = 64'h123456789ABCDEF0; mem_write = 1; mem_read = 0; #10;
        $display("Cycle: %d | Address: %h | Write Data: %h | MemWrite: %b | MemRead: %b | Read Data: %h", $time / 10, address, write_data, mem_write, mem_read, read_data);

        // Read data from memory and display results.
        address = 6'd0; mem_write = 0; mem_read = 1; #10;
        $display("Cycle: %d | Address: %h | Write Data: %s | MemWrite: %b | MemRead: %b | Read Data: %h", $time / 10, address, "-", mem_write, mem_read, read_data);

        address = 6'd1; mem_write = 0; mem_read = 1; #10;
        $display("Cycle: %d | Address: %h | Write Data: %s | MemWrite: %b | MemRead: %b | Read Data: %h", $time / 10, address, "-", mem_write, mem_read, read_data);

        address = 6'd2; mem_write = 0; mem_read = 1; #10;
        $display("Cycle: %d | Address: %h | Write Data: %s | MemWrite: %b | MemRead: %b | Read Data: %h", $time / 10, address, "-", mem_write, mem_read, read_data);

        // Write and read another value.
        address = 6'd3; write_data = 64'hAABBCCDDEEFF0011; mem_write = 1; mem_read = 0; #10;
        $display("Cycle: %d | Address: %h | Write Data: %h | MemWrite: %b | MemRead: %b | Read Data: %h", $time / 10, address, write_data, mem_write, mem_read, read_data);

        address = 6'd3; mem_write = 0; mem_read = 1; #10;
        $display("Cycle: %d | Address: %h | Write Data: %s | MemWrite: %b | MemRead: %b | Read Data: %h", $time / 10, address, "-", mem_write, mem_read, read_data);

        $stop; // Stop simulation.
    end

endmodule
