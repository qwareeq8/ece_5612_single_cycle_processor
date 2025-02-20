`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: Temple University
// Engineer: Yusuf Qwareeq
//
// Create Date: 12/10/2024
// Design Name: Data Memory
// Module Name: data_memory
// Project Name: RISC_V_64_bit_Single_Cycle_CPU
// Target Devices: General FPGA/ASIC
// Tool Versions: Any supported Verilog simulator.
// Description: This module implements a 64-bit Data Memory for the RISC-V CPU.
//              It supports synchronous write operations on the rising edge of
//              the clock and asynchronous reads for immediate data availability.
//              Each 64-bit value is stored across 8 consecutive 1-byte memory 
//              locations in big-endian format.
//
// Dependencies: None.
//
// Revision: Revision 0.1 - File created.
// Additional Comments:
// None.
////////////////////////////////////////////////////////////////////////////////

module data_memory (
    input [5:0] address,           // Memory address (6 bits for 64 words).
    input [63:0] write_data,       // Data to write into memory.
    input mem_read,                // Memory read enable signal.
    input mem_write,               // Memory write enable signal.
    input clk,                     // Clock signal.
    output reg [63:0] read_data    // Data read from memory.
);

    // Define memory array as 8-bit words with a depth of 64 bytes (64 words * 8 bytes/word).
    reg [7:0] memory [0:63];

    // Initialize memory with default values and test data.
    integer i;
    initial begin
        for (i = 0; i < 64; i = i + 1) begin
            memory[i] = 8'b0;
        end
        {memory[0], memory[1], memory[2], memory[3], memory[4], memory[5], memory[6], memory[7]} = 64'd1000; // a.
        {memory[8], memory[9], memory[10], memory[11], memory[12], memory[13], memory[14], memory[15]} = 64'd200; // b.
        {memory[16], memory[17], memory[18], memory[19], memory[20], memory[21], memory[22], memory[23]} = 64'd300; // c.
        {memory[24], memory[25], memory[26], memory[27], memory[28], memory[29], memory[30], memory[31]} = 64'd400; // d.
        {memory[32], memory[33], memory[34], memory[35], memory[36], memory[37], memory[38], memory[39]} = 64'd10;  // e.
        {memory[40], memory[41], memory[42], memory[43], memory[44], memory[45], memory[46], memory[47]} = 64'd3;   // f.
    end

    // Synchronous write operation on rising clock edge.
    always @(posedge clk) begin
        if (mem_write) begin
            memory[address * 8]     <= write_data[63:56];
            memory[address * 8 + 1] <= write_data[55:48];
            memory[address * 8 + 2] <= write_data[47:40];
            memory[address * 8 + 3] <= write_data[39:32];
            memory[address * 8 + 4] <= write_data[31:24];
            memory[address * 8 + 5] <= write_data[23:16];
            memory[address * 8 + 6] <= write_data[15:8];
            memory[address * 8 + 7] <= write_data[7:0];
        end
    end

    // Asynchronous read operation.
    always @(*) begin
        if (mem_read) begin
            read_data = {
                memory[address * 8],
                memory[address * 8 + 1],
                memory[address * 8 + 2],
                memory[address * 8 + 3],
                memory[address * 8 + 4],
                memory[address * 8 + 5],
                memory[address * 8 + 6],
                memory[address * 8 + 7]
            };
        end else begin
            read_data = 64'd0;
        end
    end

endmodule
