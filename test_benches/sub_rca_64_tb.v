`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: Ripple_Carry_Subtractor_Testbench
// Module Name: sub_rca_64_tb
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description:
// This testbench verifies the functionality of the 64-bit Ripple Carry Subtractor (sub_rca_64).
// It tests various cases, including signed/unsigned subtraction, edge cases like overflow,
// and typical scenarios.
//
// Dependencies: sub_rca_64.
//
// Results:
// Format: Input A (64-bit hex) | Input B (64-bit hex) | C_in (1-bit) | Signed (1-bit) | Diff Out (64-bit hex) | B_out (1-bit) | Overflow (1-bit)
// Input A: 0000000000000005 | Input B: 0000000000000002 | C_in: 0 | Signed: 0 | Diff Out: 0000000000000003 | B_out: 0 | Overflow: x
// Input A: 0000000000000001 | Input B: 0000000000000002 | C_in: 1 | Signed: 0 | Diff Out: 0000000000000000 | B_out: 1 | Overflow: x
// Input A: 7fffffffffffffff | Input B: ffffffffffffffff | C_in: 0 | Signed: 1 | Diff Out: 8000000000000000 | B_out: x | Overflow: 1
// Input A: 8000000000000000 | Input B: 0000000000000001 | C_in: 0 | Signed: 1 | Diff Out: 7fffffffffffffff | B_out: x | Overflow: 1
// Input A: 0000000000003039 | Input B: fffffffffffcfdaf | C_in: 0 | Signed: 1 | Diff Out: 000000000003328a | B_out: x | Overflow: 0
// Input A: 0000000000000000 | Input B: ffffffffffffffff | C_in: 0 | Signed: 0 | Diff Out: 0000000000000001 | B_out: 1 | Overflow: x
// Input A: 0000000000000000 | Input B: 0000000000000000 | C_in: 0 | Signed: 0 | Diff Out: 0000000000000000 | B_out: 0 | Overflow: x
// Input A: ffffffffffffff9c | Input B: ffffffffffffff38 | C_in: 0 | Signed: 1 | Diff Out: 0000000000000064 | B_out: x | Overflow: 0
//
// Revision:
// Revision 0.1 - File created.
// Additional Comments:
// None.
//////////////////////////////////////////////////////////////////////////////////

module sub_rca_64_tb;

    // Inputs.
    reg [63:0] input_a;
    reg [63:0] input_b;
    reg borrow_in;
    reg is_signed_sub;

    // Outputs.
    wire [63:0] diff_out;
    wire borrow_out;
    wire overflow;

    // Instantiate the 64-bit Ripple Carry Subtractor.
    sub_rca_64 uut (
        .diff_out(diff_out),
        .borrow_out(borrow_out),
        .overflow(overflow),
        .input_a(input_a),
        .input_b(input_b),
        .borrow_in(borrow_in),
        .is_signed_sub(is_signed_sub)
    );

    // Display format.
    initial begin
        $display("Format: Input A (64-bit hex) | Input B (64-bit hex) | C_in (1-bit) | Signed (1-bit) | Diff Out (64-bit hex) | B_out (1-bit) | Overflow (1-bit)");
    end

    // Task to display results in a single line.
    task display_result;
        begin
            $display("Input A: %016h | Input B: %016h | C_in: %1b | Signed: %1b | Diff Out: %016h | B_out: %1b | Overflow: %1b",
                     input_a, input_b, borrow_in, is_signed_sub, diff_out, borrow_out, overflow);
        end
    endtask

    // Stimulus.
    initial begin
        // Case 1: Unsigned subtraction, no borrow-in, no borrow.
        input_a = 64'h0000000000000005;
        input_b = 64'h0000000000000002;
        borrow_in = 0;
        is_signed_sub = 0;
        #10 display_result();

        // Case 2: Unsigned subtraction, borrow-in, with borrow.
        input_a = 64'h0000000000000001;
        input_b = 64'h0000000000000002;
        borrow_in = 1;
        is_signed_sub = 0;
        #10 display_result();

        // Case 3: Signed subtraction, no borrow-in, positive overflow.
        input_a = 64'h7FFFFFFFFFFFFFFF; // Max positive 64-bit signed integer.
        input_b = 64'hFFFFFFFFFFFFFFFF; // -1 in signed.
        borrow_in = 0;
        is_signed_sub = 1;
        #10 display_result();

        // Case 4: Signed subtraction, no borrow-in, negative overflow.
        input_a = 64'h8000000000000000; // Min negative 64-bit signed integer.
        input_b = 64'h0000000000000001;
        borrow_in = 0;
        is_signed_sub = 1;
        #10 display_result();

        // Case 5: Mixed signed subtraction, result within range.
        input_a = 64'h0000000000003039; // Decimal 12345 in hex.
        input_b = 64'hFFFFFFFFFFFCFDAF; // Decimal -54321 in hex.
        borrow_in = 0;
        is_signed_sub = 1;
        #10 display_result();

        // Case 6: Unsigned subtraction, underflow.
        input_a = 64'h0000000000000000;
        input_b = 64'hFFFFFFFFFFFFFFFF; // Max unsigned 64-bit integer.
        borrow_in = 0;
        is_signed_sub = 0;
        #10 display_result();

        // Case 7: Edge case, both inputs zero.
        input_a = 64'h0000000000000000;
        input_b = 64'h0000000000000000;
        borrow_in = 0;
        is_signed_sub = 0;
        #10 display_result();

        // Case 8: Signed subtraction, both inputs negative.
        input_a = 64'hFFFFFFFFFFFFFF9C; // Decimal -100 in hex.
        input_b = 64'hFFFFFFFFFFFFFF38; // Decimal -200 in hex.
        borrow_in = 0;
        is_signed_sub = 1;
        #10 display_result();

        $stop;
    end

endmodule
