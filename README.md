# 64-bit RISC-V Single-Cycle Processor

This repository contains the complete design, simulation files, and documentation for a 64-bit RISC-V single-cycle processor implemented in Verilog. The processor supports a subset of RISC-V instructions—including arithmetic, logical, load/store, and branch operations—and has been thoroughly validated via simulation in Vivado.

## Repository Structure

- **Source Code:** Contains the Verilog modules that implement the processor.
- **Test Benches:** Includes testbench files for individual modules and the integrated processor.
- **Documents:** Contains the full project report (both LaTeX source and compiled PDF).

```
ece_5612_single_cycle_processor/
├── docs/
│   ├── final_report.tex
│   └── final_report.pdf
├── src/
│   ├── alu.v
│   ├── alu_control_unit.v
│   ├── control_unit.v
│   ├── data_memory.v
│   ├── instruction_memory.v
│   ├── program_counter.v
│   ├── immediate_generator.v
│   ├── register_file.v
│   ├── multiplexer_2to1.v
│   ├── shift_left_1.v
│   └── top_module.v
├── test_benches/
│   ├── alu_tb.v
│   ├── control_unit_tb.v
│   ├── data_memory_tb.v
│   ├── instruction_memory_tb.v
│   ├── register_file_tb.v
│   └── ...
└── README.md
```

## Tools & Environment

- **Verilog & Vivado:** Hardware design and simulation were performed in Vivado.
- **Vivado Waveform Viewer:** Used to analyze simulation results.

## How to Simulate

1. **Setup:** Open the project in Vivado and add the source files from the `src/` directory along with the testbenches from `test_benches/`.
2. **Run Simulation:** Execute the top-level testbench (or simulate `top_module.v`) to simulate the complete processor.
3. **Review Results:** Analyze the waveform output in the Vivado Waveform Viewer.

## Design Approach

- **Single-Cycle Datapath:** The processor fetches, decodes, executes, and writes back within one clock cycle.
- **Modularity:** Each module is implemented with clear interfaces for isolated testing and debugging.
- **Hierarchical ALU Design:** The ALU is constructed from smaller building blocks to handle 64-bit operations, supporting signed/unsigned arithmetic, multiplication, and division.
- **Control Logic:** The Control Unit and ALU Control Unit decode instruction fields and generate precise control signals.
- **Cycle-by-Cycle Execution:** The integrated processor executes a sample program that calculates an algebraic expression with each step documented via simulation outputs.

## Additional Information

For complete details of the design, testbench results, and simulation outputs, please refer to the full project report:
- [Final Report (PDF)](docs/final_report.pdf)
- [Final Report (LaTeX source)](docs/final_report.tex)
