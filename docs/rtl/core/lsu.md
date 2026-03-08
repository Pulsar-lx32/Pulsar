# lsu — RTL Core Module Documentation

## Overview

Load/Store Unit for LX32 processor. Implements memory access logic for execute and memory stages. Connects to ALU and memory subsystem.

---

## Design Principles

- Canonical RTL implementation for memory access.
- Pure combinational datapath, no internal state.
- Clear separation between execute and memory stages.
- Robust, synthesis-friendly design with formal-verification readiness.

---

## Port Interface & Parameters

| Signal        | Direction | Type        | Description                          |
|---------------|----------|-------------|--------------------------------------|
| alu_result    | input    | [31:0]      | Computed address from ALU            |
| write_data    | input    | [31:0]      | Data to store                        |
| mem_write     | input    | logic       | Store enable                         |
| mem_addr      | output   | [31:0]      | Address to memory                    |
| mem_wdata     | output   | [31:0]      | Data to memory                       |
| mem_we        | output   | logic       | Write enable                         |

| Parameter     | Default   | Type      | Description                          |
|---------------|-----------|-----------|--------------------------------------|
| (none)        |           |           |                                      |

---

## Content & Structure

- Implements memory mapping logic for execute and memory stages.
- Pure combinational logic for memory interface.
- Handles reset, clocking, and control signal propagation.

---

## Integration

- Connects to ALU, memory subsystem, and pipeline datapath.
- Forms part of the processor pipeline and interfaces with system-level signals.

---

## References

- RTL source: [`rtl/core/lsu.sv`](../../rtl/core/lsu.sv)

---

## License

MIT
