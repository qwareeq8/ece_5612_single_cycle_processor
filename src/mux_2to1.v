`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: 2-to-1 Multiplexer
// Module Name: mux_2to1
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This module implements a 2-to-1 multiplexer that selects one of two 64-bit 
// inputs based on a single-bit select signal (`sel`).
//
// Operation Summary:
// sel = 0: Output is assigned to input 0 (in0).
// sel = 1: Output is assigned to input 1 (in1).
//
// Dependencies: None.
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
////////////////////////////////////////////////////////////////////////////////

module mux_2to1 (
    output reg [63:0] out,    // Output of the MUX (64-bit).
    input [63:0] in0,         // Input 0 to the MUX (64-bit).
    input [63:0] in1,         // Input 1 to the MUX (64-bit).
    input sel                 // Select signal for MUX.
);

    always @(*) begin
        case (sel)
            1'b0: out = in0; // Select Input 0.
            1'b1: out = in1; // Select Input 1.
            default: out = 64'd0; // Default case for safety.
        endcase
    end

endmodule
