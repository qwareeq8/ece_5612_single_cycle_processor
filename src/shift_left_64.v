`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: Shift Left by 1
// Module Name: shift_left_64
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This module shifts the input value left by 1 bit. The least significant bit
// is padded with 0.
//
// Dependencies: None.
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module shift_left_64 (
    input [63:0] in,  // 64-bit input value.
    output [63:0] out // 64-bit shifted output value.
);

    assign out = in << 1; // Shift left by 1 bit.

endmodule
