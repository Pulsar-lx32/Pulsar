# branch_unit — RTL Core Module Documentation

## Overview

Evaluates branch conditions for the LX32 processor, supporting all RV32I branch types. Implements execute stage branch logic. Connects to control unit and ALU.

---

## Design Principles

- Canonical RTL implementation for branch evaluation.
- Parameterization and type safety (WIDTH, branch_op_e).
- Clear signal semantics and modular structure.
- Robust, synthesis-friendly design with formal-verification readiness.

---

## Port Interface & Parameters

| Signal        | Direction | Type                        | Description                          |
|---------------|----------|-----------------------------|--------------------------------------|
| src_a         | input    | [WIDTH-1:0]                 | First operand                        |
| src_b         | input    | [WIDTH-1:0]                 | Second operand                       |
| is_branch     | input    | logic                       | Enables branch logic                 |
| branch_op     | input    | lx32_branch_pkg::branch_op_e| Branch operation selector            |
| branch_taken  | output   | logic                       | Branch comparison result             |

| Parameter     | Default   | Type      | Description                          |
|---------------|-----------|-----------|--------------------------------------|
| WIDTH         | 32        | integer   | Data width                           |

---

## Content & Structure

- Implements branch comparison logic for execute stage.
- Uses `lx32_branch_pkg` for operation encoding.
- Handles reset, clocking, and control signal propagation.

---

## Integration

- Connects to control unit, ALU, and pipeline datapath.
- Forms part of the processor pipeline and interfaces with system-level signals.

---

## References

- RTL source: [`rtl/core/branch_unit.sv`](../../rtl/core/branch_unit.sv)

---

## License

MIT
