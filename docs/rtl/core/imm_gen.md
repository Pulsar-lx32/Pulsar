# imm_gen — RTL Core Module Documentation

## Overview

Generates sign-extended immediate values from instruction fields for LX32 processor. Implements decode stage immediate extraction. Connects to ALU, branch unit, and memory access logic.

---

## Design Principles

- Canonical RTL implementation for immediate generation.
- Opcode-driven decode, ISA-aligned extraction.
- Pure combinational logic, tool-friendly.
- Explicit safe defaults via default case.
- Robust, synthesis-friendly design with formal-verification readiness.

---

## Port Interface & Parameters

| Signal        | Direction | Type        | Description                          |
|---------------|----------|-------------|--------------------------------------|
| instr         | input    | [31:0]      | Instruction word                     |
| imm           | output   | [31:0]      | Decoded immediate value              |

| Parameter     | Default   | Type      | Description                          |
|---------------|-----------|-----------|--------------------------------------|
| (none)        |           |           |                                      |

---

## Content & Structure

- Implements immediate extraction logic for decode stage.
- Uses `lx32_decode_pkg` and `lx32_isa_pkg` for extraction.
- Handles reset, clocking, and control signal propagation.

---

## Integration

- Connects to ALU, branch unit, memory access logic, and pipeline datapath.
- Forms part of the processor pipeline and interfaces with system-level signals.

---

## References

- RTL source: [`rtl/core/imm_gen.sv`](../../rtl/core/imm_gen.sv)

---

## License

MIT
