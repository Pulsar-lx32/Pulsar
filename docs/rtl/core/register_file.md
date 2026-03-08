# register_file — RTL Core Module Documentation

## Overview

General-purpose register file for LX32 processor. Implements dual asynchronous read ports and single synchronous write port for 32 registers (x0–x31), each 32 bits wide. x0 is hardwired to zero. Used in datapath for operand access and result storage.

---

## Design Principles

- Canonical RTL implementation for register file.
- Dual asynchronous read ports, single synchronous write port.
- x0 hardwired to zero (read-only).
- One-hot write decoder for safe updates.
- Parameterization for width and register count.
- Robust, synthesis-friendly design with formal-verification readiness.

---

## Port Interface & Parameters

| Signal        | Direction | Type        | Description                          |
|---------------|----------|-------------|--------------------------------------|
| clk           | input    | logic       | Clock signal                         |
| rst           | input    | logic       | Reset signal                         |
| addr_rs1      | input    | [4:0]       | Source 1 address                     |
| addr_rs2      | input    | [4:0]       | Source 2 address                     |
| addr_rd       | input    | [4:0]       | Write address                        |
| data_rd       | input    | [31:0]      | Write data                           |
| we            | input    | logic       | Write enable                         |
| data_rs1      | output   | [31:0]      | Source 1 data                        |
| data_rs2      | output   | [31:0]      | Source 2 data                        |

| Parameter     | Default   | Type      | Description                          |
|---------------|-----------|-----------|--------------------------------------|
| (none)        |           |           |                                      |

---

## Content & Structure

- Implements register storage and access logic for datapath.
- x0 hardwired to zero, one-hot write decoder.
- Handles reset, clocking, and control signal propagation.

---

## Integration

- Connects to ALU, control unit, and pipeline datapath.
- Forms part of the processor pipeline and interfaces with system-level signals.

---

## References

- RTL source: [`rtl/core/register_file.sv`](../../rtl/core/register_file.sv)

---

## License

MIT
