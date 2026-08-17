# Design Flow – 32-bit RISC Processor

## Step 1: Specification
- Defined ISA (R-type, I-type, J-type).
- Identified datapath components (ALU, Register File, Control Unit, PC, Memory).
- Listed control signals.

## Step 2: RTL Design
- Implemented Verilog modules:
  - alu.v
  - register_file.v
  - control_unit.v
  - datapath.v
  - risc_processor.v

## Step 3: Testbenches
- Created alu_tb.v to verify arithmetic/logical operations.
- Created processor_tb.v to verify instruction fetch, PC increment, and datapath integration.

## Step 4: Verification
- Ran simulations in ModelSim.
- Captured waveforms (alu_waveform.png, processor_waveform.png, datapath_waveform.png).
- Documented results in simulation_results.md.

## Step 5: Documentation
- Prepared README.md for project overview.
- Prepared design_flow.md for step-by-step explanation.
- Final report compiled for submission.
