# imm_gen — Golden Model Documentation

## Overview

The `imm_gen` module implements the immediate generation logic for the LX32 golden model, generating sign-extended immediates for RV32I base ISA instructions. It mirrors RTL immediate generation, providing reference extraction and extension for all instruction types.

---

## Design Principles

- Opcode-driven decode for immediate format selection.
- ISA-aligned immediate extraction.
- Pure combinational logic.
- Tool-friendly: no unique/priority qualifiers.
- Explicit safe default for unsupported opcodes.

---

## API / Interface

**Inputs/Outputs:**

| Name        | Type         | Description                                 |
|-------------|--------------|---------------------------------------------|
| instr       | u32          | 32-bit instruction word                     |
| return      | u32          | Sign-extended immediate                     |

**Parameters/Enums/Constants:**

| Name        | Type/Value   | Description                                 |
|-------------|--------------|---------------------------------------------|
| get_i_imm   | function     | Extracts I-type immediate                   |
| get_s_imm   | function     | Extracts S-type immediate                   |
| get_b_imm   | function     | Extracts B-type immediate                   |
| get_u_imm   | function     | Extracts U-type immediate                   |
| get_j_imm   | function     | Extracts J-type immediate                   |

---

## Functional Description

- Decodes opcode to select immediate format.
- Extracts and sign-extends immediate for I, S, B, U, J instruction types.
- Returns zero for unsupported or invalid opcodes.
- No runtime errors; all operations defined for valid inputs.

---

## Test & Validation

- Unit tests located in `tools/lx32_validator/tests/test_imm_gen.rs`.
- Tests cover all immediate formats, edge cases, and equivalence with RTL outputs.
- Regression tests compare golden model results to RTL simulation.

---

## Cross-Validation with Hardware

- Results compared to RTL immediate generation via test vector generation and automated diffing.
- CI pipelines and logs ensure equivalence.
- Automation via `setup.sh` and Makefile.

---

## Integration

- Used by the LX32 processor system and testbenches.
- Depends on architectural package (`lx32_decode_pkg`) for extraction functions.
- Integrated in full-system simulation and validation framework.

---

## References

- Golden Model source: [`tools/lx32_validator/src/models/core/imm_gen.rs`](../../../tools/lx32_validator/src/models/core/imm_gen.rs)
- Rust Test: [`tools/lx32_validator/tests/test_imm_gen.rs`](../../../tools/lx32_validator/tests/test_imm_gen.rs)
- Related documentation: [RTL Core](../../../rtl/core/imm_gen.sv)

---

## License

MIT
