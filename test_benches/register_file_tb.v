`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: Register File Testbench
// Module Name: register_file_tb
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description: This testbench verifies the functionality of the register file
//              module by testing synchronous writes and asynchronous reads. It
//              ensures that register x0 remains constant as zero.
//
// Dependencies: register_file.
//
// Results:
// Format: Cycle (decimal) | Write Enable (binary) | Write Register (decimal) | Write Data (hexadecimal) | Read Data 1 (hexadecimal) | Read Data 2 (hexadecimal) | Registers x1-x11 (hexadecimal)
// Cycle:   2 | Write Enable: 1 | Write Register:  1 | Write Data: deadbeef12345678 | Read Data 1: 0000000000000000 | Read Data 2: 0000000000000000
// Registers (x1-x11): x1: deadbeef12345678, x2: 0000000000000000, x3: 0000000000000000, x4: 0000000000000000, x5: 0000000000000000, x6: 0000000000000000, x7: 0000000000000000, x8: 0000000000000000, x9: 0000000000000000, x10: 0000000000000000, x11: 0000000000000000
// Cycle:   3 | Write Enable: 1 | Write Register:  2 | Write Data: cafebabe87654321 | Read Data 1: 0000000000000000 | Read Data 2: 0000000000000000
// Registers (x1-x11): x1: deadbeef12345678, x2: cafebabe87654321, x3: 0000000000000000, x4: 0000000000000000, x5: 0000000000000000, x6: 0000000000000000, x7: 0000000000000000, x8: 0000000000000000, x9: 0000000000000000, x10: 0000000000000000, x11: 0000000000000000
// Cycle:   4 | Write Enable: 0 | Write Register:  2 | Write Data: cafebabe87654321 | Read Data 1: deadbeef12345678 | Read Data 2: cafebabe87654321
// Registers (x1-x11): x1: deadbeef12345678, x2: cafebabe87654321, x3: 0000000000000000, x4: 0000000000000000, x5: 0000000000000000, x6: 0000000000000000, x7: 0000000000000000, x8: 0000000000000000, x9: 0000000000000000, x10: 0000000000000000, x11: 0000000000000000
// Cycle:   6 | Write Enable: 0 | Write Register:  3 | Write Data: 123456789abcdef0 | Read Data 1: 123456789abcdef0 | Read Data 2: cafebabe87654321
// Registers (x1-x11): x1: deadbeef12345678, x2: cafebabe87654321, x3: 123456789abcdef0, x4: 0000000000000000, x5: 0000000000000000, x6: 0000000000000000, x7: 0000000000000000, x8: 0000000000000000, x9: 0000000000000000, x10: 0000000000000000, x11: 0000000000000000
// Cycle:   8 | Write Enable: 0 | Write Register:  0 | Write Data: ffffffffffffffff | Read Data 1: 0000000000000000 | Read Data 2: cafebabe87654321
// Registers (x1-x11): x1: deadbeef12345678, x2: cafebabe87654321, x3: 123456789abcdef0, x4: 0000000000000000, x5: 0000000000000000, x6: 0000000000000000, x7: 0000000000000000, x8: 0000000000000000, x9: 0000000000000000, x10: 0000000000000000, x11: 0000000000000000
//
// Revision: Revision 0.1 - File created.
// Additional Comments:
// None.
////////////////////////////////////////////////////////////////////////////////

module register_file_tb;

    // Inputs to the DUT.
    reg [4:0] read_reg1;         // Address of the first register to read.
    reg [4:0] read_reg2;         // Address of the second register to read.
    reg [4:0] write_reg;         // Address of the register to write.
    reg [63:0] write_data;       // Data to write into the specified register.
    reg reg_write;               // Write enable signal.
    reg clk;                     // Clock signal.

    // Outputs from the DUT.
    wire [63:0] read_data1;      // Data read from the first register.
    wire [63:0] read_data2;      // Data read from the second register.
    wire [63:0] reg_x1, reg_x2, reg_x3, reg_x4, reg_x5, reg_x6, reg_x7, reg_x8, reg_x9, reg_x10, reg_x11; // Exposed registers.

    // Instantiate the DUT.
    register_file dut (
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_data(write_data),
        .reg_write(reg_write),
        .clk(clk),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .reg_x1(reg_x1),
        .reg_x2(reg_x2),
        .reg_x3(reg_x3),
        .reg_x4(reg_x4),
        .reg_x5(reg_x5),
        .reg_x6(reg_x6),
        .reg_x7(reg_x7),
        .reg_x8(reg_x8),
        .reg_x9(reg_x9),
        .reg_x10(reg_x10),
        .reg_x11(reg_x11)
    );

    // Generate clock signal.
    always begin
        #5 clk = ~clk; // Toggle clock every 5ns.
    end

    // Task to display the state of registers and read outputs.
    task display_registers;
        begin
            $display("Cycle: %3d | Write Enable: %b | Write Register: %2d | Write Data: %h | Read Data 1: %h | Read Data 2: %h",
                     $time / 10, reg_write, write_reg, write_data, read_data1, read_data2);
            $display("Registers (x1-x11): x1: %h, x2: %h, x3: %h, x4: %h, x5: %h, x6: %h, x7: %h, x8: %h, x9: %h, x10: %h, x11: %h",
                     reg_x1, reg_x2, reg_x3, reg_x4, reg_x5, reg_x6, reg_x7, reg_x8, reg_x9, reg_x10, reg_x11);
        end
    endtask

    // Test sequence.
    initial begin
        // Display format information.
        $display("Format: Cycle (decimal) | Write Enable (binary) | Write Register (decimal) | Write Data (hexadecimal) | Read Data 1 (hexadecimal) | Read Data 2 (hexadecimal) | Registers x1-x11 (hexadecimal)");
        
        // Initialize inputs.
        clk = 0;
        reg_write = 0;
        write_reg = 5'd0;
        write_data = 64'd0;
        read_reg1 = 5'd0;
        read_reg2 = 5'd0;

        // Wait for clock stabilization.
        #10;

        // Test 1: Write to x1.
        reg_write = 1;
        write_reg = 5'd1; // Write to x1.
        write_data = 64'hDEADBEEF12345678;
        #10; // Wait for one clock cycle.
        display_registers();

        // Test 2: Write to x2.
        write_reg = 5'd2; // Write to x2.
        write_data = 64'hCAFEBABE87654321;
        #10; // Wait for one clock cycle.
        display_registers();

        // Test 3: Read from x1 and x2.
        reg_write = 0;
        read_reg1 = 5'd1; // Read from x1.
        read_reg2 = 5'd2; // Read from x2.
        #10; // Wait for read propagation.
        display_registers();

        // Test 4: Write to x3 and confirm.
        reg_write = 1;
        write_reg = 5'd3; // Write to x3.
        write_data = 64'h123456789ABCDEF0;
        #10; // Wait for one clock cycle.
        reg_write = 0;
        read_reg1 = 5'd3; // Read from x3.
        #10; // Wait for read propagation.
        display_registers();

        // Test 5: Attempt to write to x0 (should not change).
        reg_write = 1;
        write_reg = 5'd0; // Attempt to write to x0.
        write_data = 64'hFFFFFFFFFFFFFFFF;
        #10; // Wait for one clock cycle.
        reg_write = 0;
        read_reg1 = 5'd0; // Read from x0.
        #10; // Wait for read propagation.
        display_registers();

        // End simulation.
        $stop;
    end

endmodule
