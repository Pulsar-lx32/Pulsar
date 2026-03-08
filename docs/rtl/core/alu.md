# alu — RTL Core Module Documentation

## Overview

Arithmetic Logic Unit for LX32 processor. Implements execute stage arithmetic, logical, shift, and comparison operations. Connects to register file, immediate generator, and branch unit.

---

## Design Principles

- Canonical RTL implementation for ALU operations.
- Parameterization and type safety (WIDTH, alu_op_e).
- Clear signal semantics and modular structure.
- Robust, synthesis-friendly design with formal-verification readiness.

---

## Port Interface & Parameters

| Signal        | Direction | Type                    | Description                          |
|---------------|----------|-------------------------|--------------------------------------|
| src_a         | input    | [WIDTH-1:0]             | First operand                        |
| src_b         | input    | [WIDTH-1:0]             | Second operand                       |
| alu_control   | input    | lx32_alu_pkg::alu_op_e  | ALU operation selector               |
| alu_result    | output   | [WIDTH-1:0]             | ALU result                           |

| Parameter     | Default   | Type      | Description                          |
|---------------|-----------|-----------|--------------------------------------|
| WIDTH         | 32        | integer   | Data width                           |

---

## Content & Structure

- Implements core datapath logic for execute stage.
- Uses `lx32_alu_pkg` for operation encoding.
- Handles reset, clocking, and control signal propagation.

---

## Integration

- Connects to register file, immediate generator, branch unit, and pipeline datapath.
- Forms part of the processor pipeline and interfaces with system-level signals.

---

## References

- RTL source: [`rtl/core/alu.sv`](../../rtl/core/alu.sv)

---

## License

MIT
