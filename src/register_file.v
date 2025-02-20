`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: Register File
// Module Name: register_file
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description: This module implements a 32x64-bit register file for the RISC-V CPU.
//              It supports two asynchronous read operations and one synchronous
//              write operation within a single cycle.
//
// Dependencies: None.
//
// Revision: Revision 0.1 - File created.
// Additional Comments:
// None.
////////////////////////////////////////////////////////////////////////////////

module register_file (
    input [4:0] read_reg1,        // Address of the first register to read.
    input [4:0] read_reg2,        // Address of the second register to read.
    input [4:0] write_reg,        // Address of the register to write.
    input [63:0] write_data,      // Data to write to the specified register.
    input reg_write,              // Write enable signal.
    input clk,                    // Clock signal.
    output [63:0] read_data1,     // Data read from the first register.
    output [63:0] read_data2,     // Data read from the second register.
    output [63:0] reg_x1,         // Exposed Register x1.
    output [63:0] reg_x2,         // Exposed Register x2.
    output [63:0] reg_x3,         // Exposed Register x3.
    output [63:0] reg_x4,         // Exposed Register x4.
    output [63:0] reg_x5,         // Exposed Register x5.
    output [63:0] reg_x6,         // Exposed Register x6.
    output [63:0] reg_x7,         // Exposed Register x7.
    output [63:0] reg_x8,         // Exposed Register x8.
    output [63:0] reg_x9,         // Exposed Register x9.
    output [63:0] reg_x10,        // Exposed Register x10.
    output [63:0] reg_x11         // Exposed Register x11.
);

    // Define the 32x64-bit register file.
    reg [63:0] registers [31:0];

    // Read operations (asynchronous).
    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];

    // Expose specific registers.
    assign reg_x1  = registers[1];
    assign reg_x2  = registers[2];
    assign reg_x3  = registers[3];
    assign reg_x4  = registers[4];
    assign reg_x5  = registers[5];
    assign reg_x6  = registers[6];
    assign reg_x7  = registers[7];
    assign reg_x8  = registers[8];
    assign reg_x9  = registers[9];
    assign reg_x10 = registers[10];
    assign reg_x11 = registers[11];

    // Write operation (synchronous).
    always @(posedge clk) begin
        if (reg_write && write_reg != 5'b00000) begin
            // Register 0 is hardwired to 0; writes to it are ignored.
            registers[write_reg] <= write_data;
        end
    end

    // Initialize registers to zero.
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 64'b0;
        end
    end

endmodule
