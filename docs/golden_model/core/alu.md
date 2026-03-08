# alu — Golden Model Documentation

## Overview

The `alu` module implements the Arithmetic Logic Unit (ALU) for the LX32 golden model, supporting RV32I base ALU operations. It mirrors the RTL ALU functionality, providing reference computation for arithmetic, logical, shift, and comparison operations. The module is used for verification, equivalence checking, and reference testing of ALU behavior.

---

## Design Principles

- Parametrizable width (default 32 bits).
- No magic numbers; explicit bit masking and shifting.
- Type-safe operation selection via Rust enums.
- Lint/formal friendly: clear, modular logic.
- Explicit comparison widening for correctness.

---

## API / Interface

**Inputs/Outputs:**

| Name        | Type         | Description                                 |
|-------------|--------------|---------------------------------------------|
| src_a       | u32          | First operand (register or immediate)       |
| src_b       | u32          | Second operand (register or immediate)      |
| alu_control | alu_op_e     | ALU operation selector (enum)               |
| return      | u32          | ALU result                                  |

**Parameters/Enums/Constants:**

| Name        | Type/Value   | Description                                 |
|-------------|--------------|---------------------------------------------|
| alu_op_e    | enum         | Operation type (ADD, SUB, SLL, SRL, SRA, etc.) |

---

## Functional Description

- Implements arithmetic (ADD, SUB), logical (XOR, OR, AND), shift (SLL, SRL, SRA), and comparison (SLT, SLTU) operations.
- Uses explicit bit masking for shift amount.
- Handles signed and unsigned comparisons.
- Returns result as u32, matching RTL output.
- No runtime errors; all operations are defined for valid inputs.

---

## Test & Validation

- Unit tests located in `tools/lx32_validator/tests/test_alu.rs`.
- Tests cover all ALU operations, edge cases (overflow, signed/unsigned), and equivalence with RTL outputs.
- Regression tests compare golden model results to RTL simulation.

---

## Cross-Validation with Hardware

- Results are compared to RTL ALU via test vector generation and automated diffing.
- CI pipelines and logs ensure equivalence.
- Automation via `setup.sh` and Makefile.

---

## Integration

- Used by the LX32 processor system, control unit, and testbenches.
- Depends on architectural package (`lx32_alu_pkg`) for operation enums.
- Integrated in full-system simulation and validation framework.

---

## References

- Golden Model source: [`tools/lx32_validator/src/models/core/alu.rs`](../../../tools/lx32_validator/src/models/core/alu.rs)
- Rust Test: [`tools/lx32_validator/tests/test_alu.rs`](../../../tools/lx32_validator/tests/test_alu.rs)
- Related documentation: [RTL Core](../../../rtl/core/alu.sv)

---

## License

MIT
