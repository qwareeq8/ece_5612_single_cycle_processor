`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: 64-bit AND Gate
// Module Name: and_64
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description: 
// This module implements a 64-bit AND gate that performs a bitwise AND
// operation on two 64-bit input vectors 'a' and 'b'. The result is
// provided on the 64-bit output vector 'y'.
//
// Dependencies: None.
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

// 64-bit AND Gate Module.
module and_64 (
    output [63:0] y,   // 64-bit output vector.
    input [63:0] a,    // 64-bit input vector a.
    input [63:0] b     // 64-bit input vector b.
    );

    // Perform bitwise AND operation.
    assign y = a & b;

endmodule
