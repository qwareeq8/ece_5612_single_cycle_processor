`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: 64-bit OR Gate
// Module Name: or_64
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This module implements a 64-bit OR gate that performs a bitwise OR
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

// 64-bit OR Gate Module.
module or_64 (
    output [63:0] y,   // 64-bit output vector.
    input [63:0] a,     // 64-bit input vector A.
    input [63:0] b      // 64-bit input vector B.
);

    // Perform bitwise OR operation.
    assign y = a | b;

endmodule
