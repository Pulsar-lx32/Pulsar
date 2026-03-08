# memory_sim — RTL Core Module Documentation

## Overview

Dual-port memory model for LX32 core simulation. Implements word-aligned instruction and data access, supporting asynchronous read and synchronous write. Used in testbenches and system integration.

---

## Design Principles

- Canonical RTL implementation for simulation memory.
- Tool-friendly: no latches, deterministic behavior.
- ISA-aligned word indexing.
- Clean separation of instruction/data ports.
- Program preload via $readmemh.
- Robust, synthesis-friendly design with formal-verification readiness.

---

## Port Interface & Parameters

| Signal        | Direction | Type        | Description                          |
|---------------|----------|-------------|--------------------------------------|
| clk           | input    | logic       | Clock signal                         |
| i_addr        | input    | [31:0]      | Instruction address                  |
| i_data        | output   | [31:0]      | Instruction data                     |
| d_addr        | input    | [31:0]      | Data address                         |
| d_wdata       | input    | [31:0]      | Data write                           |
| d_we          | input    | logic       | Data write enable                    |
| d_rdata       | output   | [31:0]      | Data read                            |

| Parameter     | Default   | Type      | Description                          |
|---------------|-----------|-----------|--------------------------------------|
| (none)        |           |           |                                      |

---

## Content & Structure

- Implements memory array and access logic for simulation.
- Handles reset, clocking, and control signal propagation.

---

## Integration

- Connects to processor pipeline and testbench.
- Forms part of the simulation environment.

---

## References

- RTL source: [`rtl/core/memory_sim.sv`](../../rtl/core/memory_sim.sv)

---

## License

MIT
