# control_unit — RTL Core Module Documentation

## Overview

Decodes instructions and generates control signals for LX32 processor pipeline. Implements decode stage control logic. Connects to ALU, branch unit, register file, and immediate generator.

---

## Design Principles

- Canonical RTL implementation for instruction decode and control signal generation.
- Type-safe opcode usage and signal encoding.
- No implicit latches: default assignments and default cases.
- Full RV32I coverage for ALU and branch operations.
- Robust, synthesis-friendly design with formal-verification readiness.

---

## Port Interface & Parameters

| Signal        | Direction | Type                        | Description                          |
|---------------|----------|-----------------------------|--------------------------------------|
| opcode        | input    | lx32_isa_pkg::opcode_t      | Instruction opcode                   |
| funct3        | input    | [2:0]                       | Instruction funct3 field             |
| funct7_5      | input    | logic                       | Instruction funct7[5] bit            |
| reg_write     | output   | logic                       | Register write enable                |
| alu_src       | output   | logic                       | ALU source select                    |
| mem_write     | output   | logic                       | Memory write enable                  |
| result_src    | output   | [1:0]                       | Result source select                 |
| branch        | output   | logic                       | Branch enable                        |
| branch_op     | output   | lx32_branch_pkg::branch_op_e| Branch operation selector            |
| alu_control   | output   | lx32_alu_pkg::alu_op_e      | ALU operation selector               |

| Parameter     | Default   | Type      | Description                          |
|---------------|-----------|-----------|--------------------------------------|
| (none)        |           |           |                                      |

---

## Content & Structure

- Implements control signal generation for decode stage.
- Uses `lx32_isa_pkg`, `lx32_alu_pkg`, and `lx32_branch_pkg` for encoding.
- Handles reset, clocking, and control signal propagation.

---

## Integration

- Connects to ALU, branch unit, register file, immediate generator, and pipeline datapath.
- Forms part of the processor pipeline and interfaces with system-level signals.

---

## References

- RTL source: [`rtl/core/control_unit.sv`](../../rtl/core/control_unit.sv)

---

## License

MIT
