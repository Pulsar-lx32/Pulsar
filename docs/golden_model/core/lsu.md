# lsu — Golden Model Documentation

## Overview

The `lsu` module implements the Load/Store Unit (LSU) for the LX32 golden model, providing a minimal pass-through interface for single-cycle memory operations. It mirrors RTL LSU functionality, handling address, data, and write enable signals for memory access.

---

## Design Principles

- Pure combinational datapath.
- No internal state.
- Clear separation between execute and memory stages.
- Tool-friendly: no qualifiers, no implicit latches.

---

## API / Interface

**Inputs/Outputs:**

| Name        | Type         | Description                                 |
|-------------|--------------|---------------------------------------------|
| alu_result  | u32          | ALU result (memory address)                 |
| write_data  | u32          | Data to write to memory                     |
| mem_write   | bool         | Memory write enable                         |
| return      | MemInterface | Memory interface struct                     |

**Parameters/Enums/Constants:**

| Name        | Type/Value   | Description                                 |
|-------------|--------------|---------------------------------------------|
| MemInterface| struct       | Memory interface ports                      |

---

## Functional Description

- Passes ALU result, write data, and write enable to memory interface.
- No internal state or latches.
- Returns memory interface struct for comparison with RTL outputs.

---

## Test & Validation

- Unit tests located in `tools/lx32_validator/tests/test_lsu.rs`.
- Tests cover all LSU operations, edge cases, and equivalence with RTL outputs.
- Regression tests compare golden model results to RTL simulation.

---

## Cross-Validation with Hardware

- Results compared to RTL LSU via test vector generation and automated diffing.
- CI pipelines and logs ensure equivalence.
- Automation via `setup.sh` and Makefile.

---

## Integration

- Used by the LX32 processor system and testbenches.
- Integrated in full-system simulation and validation framework.

---

## References

- Golden Model source: [`tools/lx32_validator/src/models/core/lsu.rs`](../../../tools/lx32_validator/src/models/core/lsu.rs)
- Rust Test: [`tools/lx32_validator/tests/test_lsu.rs`](../../../tools/lx32_validator/tests/test_lsu.rs)
- Related documentation: [RTL Core](../../../rtl/core/lsu.sv)

---

## License

MIT
