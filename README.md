# AXI-Stream Skid Buffer - RTL Design and Verification
This project implements and verifies a 1-deep skid buffer for an AXI-Stream–style valid/ready interface. The buffer absorbs short downstream backpressure events without data loss and preserves packet boundaries, enabling timing decoupling between streaming pipeline stages.

The design is verified using a UVM-style, constrained-random SystemVerilog testbench with assertion-based checks and coverage-driven stimulus refinement.
## Features

- AXI-Stream input interface (32-bit signed samples)
- RTL + UVM-style testbench with:
  - Constrained-random stimulus
  - Scoreboard comparison
  - Weighted functional coverage
  - Protocol and behavioral SVA assertions

## Repo Structure
- `proj/` Project source code
- `proj/rtl/`: Design logic
- `proj/tb/`: Testbench components
- `proj/wav_simulator/`: Script for running simulations
- `docs/`: Block diagrams and design notes

## Running Simulation in Questa

```bash
# Compile (from proj/)
vlog -sv rtl/skid_buffer.sv tb/tb_top.sv
# sim 
vsim -do wav_simulator/run.do
```
