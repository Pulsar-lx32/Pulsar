# control_unit — Golden Model Documentation

## Overview

The `control_unit` module implements the instruction decode logic for the LX32 golden model, performing two-level decoding: main control (instruction class) and ALU operation refinement. It mirrors RTL control unit functionality, generating control signals for instruction execution, ALU, branch, and memory operations.

---

## Design Principles

- Type-safe opcode usage via Rust enums.
- No implicit latches: explicit default assignments and cases.
- Full RV32I ALU coverage.
- Modular, maintainable structure.

---

## API / Interface

**Inputs/Outputs:**

| Name        | Type         | Description                                 |
|-------------|--------------|---------------------------------------------|
| opcode      | opcode_t     | Instruction opcode (enum)                   |
| funct3      | u8           | Function field (3 bits)                     |
| funct7_5    | bool         | Function field (bit 5 of funct7)            |
| return      | ControlSignals | Control signals struct                      |

**Parameters/Enums/Constants:**

| Name        | Type/Value   | Description                                 |
|-------------|--------------|---------------------------------------------|
| ControlSignals | struct     | Control lines for execution                 |
| opcode_t    | enum         | Instruction opcode type                     |
| branch_op_e | enum         | Branch operation type                       |
| alu_op_e    | enum         | ALU operation type                          |

---

## Functional Description

- Decodes instruction fields to generate control signals for ALU, branch, memory, and register operations.
- Two-level decode: main instruction class and ALU operation refinement.
- Handles all RV32I instruction types.
- Provides robust default handling for invalid or unsupported instructions.

---

## Test & Validation

- Unit tests located in `tools/lx32_validator/tests/test_control_unit.rs`.
- Tests cover all instruction types, edge cases, and equivalence with RTL outputs.
- Regression tests compare golden model results to RTL simulation.

---

## Cross-Validation with Hardware

- Results compared to RTL control unit via test vector generation and automated diffing.
- CI pipelines and logs ensure equivalence.
- Automation via `setup.sh` and Makefile.

---

## Integration

- Used by the LX32 processor system and testbenches.
- Depends on architectural packages for opcode and operation enums.
- Integrated in full-system simulation and validation framework.

---

## References

- Golden Model source: [`tools/lx32_validator/src/models/core/control_unit.rs`](../../../tools/lx32_validator/src/models/core/control_unit.rs)
- Rust Test: [`tools/lx32_validator/tests/test_control_unit.rs`](../../../tools/lx32_validator/tests/test_control_unit.rs)
- Related documentation: [RTL Core](../../../rtl/core/control_unit.sv)

---

## License

MIT
