`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: 2-to-1 Multiplexer Testbench
// Module Name: mux_2to1_tb
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This testbench verifies the functionality of the 2-to-1 multiplexer by testing
// all combinations of select signal (`sel`) and different input values.
//
// Results:
// Format: sel (binary, 1 digit) | in0 (hexadecimal, 16 digits) | in1 (hexadecimal, 16 digits) | out (hexadecimal, 16 digits)
// sel: 0 | in0: 0000000000000005 | in1: aaaaaaaaaaaaaaaa | out: 0000000000000005
// sel: 1 | in0: 0000000000000005 | in1: aaaaaaaaaaaaaaaa | out: aaaaaaaaaaaaaaaa
// sel: 0 | in0: 0000000000000000 | in1: 0000000000000000 | out: 0000000000000000
// sel: 1 | in0: ffffffffffffffff | in1: ffffffffffffffff | out: ffffffffffffffff
// sel: 0 | in0: 123456789abcdef0 | in1: fedcba9876543210 | out: 123456789abcdef0
// sel: 1 | in0: 123456789abcdef0 | in1: fedcba9876543210 | out: fedcba9876543210
//
// Dependencies: mux_2to1.
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
////////////////////////////////////////////////////////////////////////////////

module mux_2to1_tb;

    // Inputs.
    reg [63:0] in0;   // Input 0 to the MUX.
    reg [63:0] in1;   // Input 1 to the MUX.
    reg sel;          // Select signal for the MUX.

    // Output.
    wire [63:0] out;  // Output of the MUX.

    // Instantiate the Device Under Test (DUT).
    mux_2to1 dut (
        .out(out),
        .in0(in0),
        .in1(in1),
        .sel(sel)
    );

    // Print format for results.
    initial begin
        $display("Format: sel (binary, 1 digit) | in0 (hexadecimal, 16 digits) | in1 (hexadecimal, 16 digits) | out (hexadecimal, 16 digits)");
    end

    // Task to display results.
    task display_result;
        begin
            $display("sel: %1b | in0: %16h | in1: %16h | out: %16h", sel, in0, in1, out);
        end
    endtask

    // Test cases.
    initial begin
        // Test case 1: Select Input 0 (sel = 0).
        sel = 1'b0; in0 = 64'h0000000000000005; in1 = 64'hAAAAAAAAAAAAAAAA;
        #10 display_result();

        // Test case 2: Select Input 1 (sel = 1).
        sel = 1'b1; in0 = 64'h0000000000000005; in1 = 64'hAAAAAAAAAAAAAAAA;
        #10 display_result();

        // Test case 3: Test with all zeros.
        sel = 1'b0; in0 = 64'h0000000000000000; in1 = 64'h0000000000000000;
        #10 display_result();

        // Test case 4: Test with all ones.
        sel = 1'b1; in0 = 64'hFFFFFFFFFFFFFFFF; in1 = 64'hFFFFFFFFFFFFFFFF;
        #10 display_result();

        // Test case 5: Mixed values.
        sel = 1'b0; in0 = 64'h123456789ABCDEF0; in1 = 64'hFEDCBA9876543210;
        #10 display_result();

        sel = 1'b1; in0 = 64'h123456789ABCDEF0; in1 = 64'hFEDCBA9876543210;
        #10 display_result();

        $stop; // Stop simulation.
    end

endmodule
