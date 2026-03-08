# lx32_system — RTL Core Module Documentation

## Overview

Integrates all core components of LX32 processor, including datapath, control unit, ALU, branch unit, register file, immediate generator, and load/store unit. Implements instruction fetch, decode, execute, memory access, and write-back in a single-cycle pipeline.

---

## Design Principles

- Modular integration of core blocks.
- Parameterization for architectural flexibility.
- Clear signal naming and hierarchical structure.
- Single-cycle execution datapath.
- Asynchronous reset for program counter.
- Robust, synthesis-friendly design with formal-verification readiness.

---

## Port Interface & Parameters

| Signal        | Direction | Type        | Description                          |
|---------------|----------|-------------|--------------------------------------|
| clk           | input    | logic       | Clock signal                         |
| rst           | input    | logic       | Reset signal                         |
| pc_out        | output   | [31:0]      | Program counter output               |
| instr         | input    | [31:0]      | Instruction word                     |
| mem_addr      | output   | [31:0]      | Memory address                       |
| mem_wdata     | output   | [31:0]      | Memory write data                    |
| mem_rdata     | input    | [31:0]      | Memory read data                     |
| mem_we        | output   | logic       | Memory write enable                  |

| Parameter     | Default   | Type      | Description                          |
|---------------|-----------|-----------|--------------------------------------|
| (none)        |           |           |                                      |

---

## Content & Structure

- Implements integration logic for all pipeline stages.
- Instantiates submodules: control unit, ALU, branch unit, LSU, register file, immediate generator.
- Handles reset, clocking, and control signal propagation.

---

## Integration

- Connects to all core modules and system-level signals.
- Forms the processor pipeline and interfaces with memory subsystem.

---

## References

- RTL source: [`rtl/core/lx32_system.sv`](../../rtl/core/lx32_system.sv)

---

## License

MIT
