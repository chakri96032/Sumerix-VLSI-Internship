# 🔎 Simulation Results – 32-bit RISC Processor

## 1. Objective
To verify the correctness of the Verilog modules (ALU, Register File, Control Unit, Datapath, and RISC Processor) through simulation in ModelSim/Quartus.

---

## 2. Testbenches Used
- **alu_tb.v** – verifies arithmetic and logical operations.
- **processor_tb.v** – verifies instruction fetch, PC increment, and datapath integration.

---

## 3. Simulation Outcomes
### ALU
- AND, OR, ADD, SUB, SLT operations tested.
- Outputs matched expected theoretical values.
- Zero flag asserted correctly when result = 0.

### Register File
- Correct read/write behavior observed.
- Register R0 remained constant at 0 (hardwired).

### Control Unit
- Opcode decoding produced correct control signals.
- Branch and Jump signals verified.

### Datapath
- Integration of ALU, Register File, and Control Unit successful.
- ALU results correctly written back to registers.

### Processor
- PC incremented by 4 each cycle.
- Instructions fetched and executed as expected.

---

## 4. Waveform Analysis
- **alu_tb.v**: Waveforms confirm correct logical/arithmetic outputs.
- **processor_tb.v**: PC increments, instruction fetch, and ALU results visible.

*(Insert screenshots from `waveforms/` folder here)*

---

## 5. Verification Summary
- All modules passed functional verification.
- No mismatches observed between expected and simulated outputs.
- Design is ready for extension (pipeline stages, hazard handling).
