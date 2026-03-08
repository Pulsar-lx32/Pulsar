# branch_unit — Golden Model Documentation

## Overview

The `branch_unit` module implements the branch evaluation logic for the LX32 golden model, supporting RV32I base ISA branch conditions. It mirrors RTL branch unit functionality, providing reference computation for equality, signed, and unsigned comparisons used in branch instructions.

---

## Design Principles

- Parametrizable width (default 32 bits).
- Separation of comparison logic from branch gating.
- Tool-friendly: no unique/priority qualifiers, no redundant defaults.
- Clear, modular structure for maintainability.

---

## API / Interface

**Inputs/Outputs:**

| Name        | Type         | Description                                 |
|-------------|--------------|---------------------------------------------|
| src_a       | u32          | First operand (register value)              |
| src_b       | u32          | Second operand (register value)             |
| is_branch   | bool         | Branch enable signal                        |
| branch_op   | branch_op_e  | Branch operation selector (enum)            |
| return      | bool         | Branch taken (true/false)                   |

**Parameters/Enums/Constants:**

| Name        | Type/Value   | Description                                 |
|-------------|--------------|---------------------------------------------|
| branch_op_e | enum         | Operation type (EQ, NE, LT, GE, LTU, GEU)  |

---

## Functional Description

- Evaluates branch conditions: equality, signed and unsigned comparisons.
- Combines comparison result with branch enable gating.
- Returns boolean indicating whether branch is taken.
- No runtime errors; all operations defined for valid inputs.

---

## Test & Validation

- Unit tests located in `tools/lx32_validator/tests/test_branch_unit.rs`.
- Tests cover all branch operations, edge cases, and equivalence with RTL outputs.
- Regression tests compare golden model results to RTL simulation.

---

## Cross-Validation with Hardware

- Results compared to RTL branch unit via test vector generation and automated diffing.
- CI pipelines and logs ensure equivalence.
- Automation via `setup.sh` and Makefile.

---

## Integration

- Used by the LX32 processor system and testbenches.
- Depends on architectural package (`lx32_branch_pkg`) for operation enums.
- Integrated in full-system simulation and validation framework.

---

## References

- Golden Model source: [`tools/lx32_validator/src/models/core/branch_unit.rs`](../../../tools/lx32_validator/src/models/core/branch_unit.rs)
- Rust Test: [`tools/lx32_validator/tests/test_branch_unit.rs`](../../../tools/lx32_validator/tests/test_branch_unit.rs)
- Related documentation: [RTL Core](../../../rtl/core/branch_unit.sv)

---

## License

MIT
