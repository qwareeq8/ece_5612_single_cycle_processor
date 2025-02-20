`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: Program Counter
// Module Name: program_counter
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This module implements a 64-bit Program Counter (PC). The PC value updates
// on the rising edge of the clock based on the external input, with support for
// reset and enable functionality.
//
// Operations:
// reset = 1: PC is reset to 0.
// reset = 0, enable = 1: PC updates with the value of pc_in.
// reset = 0, enable = 0: PC holds its current value.
//
// Dependencies: None.
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
////////////////////////////////////////////////////////////////////////////////

module program_counter (
    output reg [63:0] pc,       // Program Counter output (current PC value).
    input [63:0] pc_in,         // Input value for the next PC.
    input reset,                // Reset signal.
    input enable,               // Enable signal to update the PC.
    input clk                   // Clock signal.
);

    always @(posedge clk) begin
        if (reset) begin
            pc <= 64'd0; // Reset PC to 0.
        end else if (enable) begin
            pc <= pc_in; // Update PC with pc_in if enabled.
        end
        // Else, hold the current PC value implicitly.
    end

endmodule
