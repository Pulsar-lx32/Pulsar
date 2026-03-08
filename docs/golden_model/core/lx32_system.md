# lx32_system — Golden Model Documentation

## Overview

The `lx32_system` module integrates all core sub-modules of the LX32 golden model, including Control Unit, ALU, Branch Unit, LSU, Register File, and Immediate Generator. It mirrors the RTL processor system, providing reference single-cycle execution and state updates for full-system simulation and validation.

---

## Design Principles

- Clear signal naming and hierarchical structure.
- Single-cycle execution datapath.
- Synchronous state updates matching RTL behavior.
- Modular integration of all core units.

---

## API / Interface

**Inputs/Outputs:**

| Name        | Type         | Description                                 |
|-------------|--------------|---------------------------------------------|
| pc          | u32          | Program counter                             |
| reg_file    | RegisterFile | Register file instance                      |
| memory      | Vec<u8>      | Internal memory (4KB)                       |
| step()      | fn           | Executes a single clock cycle               |

**Parameters/Enums/Constants:**

| Name        | Type/Value   | Description                                 |
|-------------|--------------|---------------------------------------------|
| RegisterFile| struct       | Register file abstraction                   |
| ALU, Branch Unit, Control Unit, ImmGen, LSU | modules | Integrated sub-modules |

---

## Functional Description

- Initializes processor state and memory.
- Executes single clock cycle: decode, register read, execution, branch evaluation, state update.
- Handles reset logic and out-of-bounds memory access.
- Returns signals for comparison with RTL outputs.

---

## Test & Validation

- Unit tests located in `tools/lx32_validator/tests/test_lx32_system.rs`.
- Tests cover full-system scenarios, edge cases, and equivalence with RTL outputs.
- Regression tests compare golden model results to RTL simulation.

---

## Cross-Validation with Hardware

- Results compared to RTL processor system via test vector generation and automated diffing.
- CI pipelines and logs ensure equivalence.
- Automation via `setup.sh` and Makefile.

---

## Integration

- Central module connecting all golden model core units.
- Used in reference testbench, validation framework, and full-system simulation.
- Depends on architectural packages and core modules.

---

## References

- Golden Model source: [`tools/lx32_validator/src/models/core/lx32_system.rs`](../../../tools/lx32_validator/src/models/core/lx32_system.rs)
- Rust Test: [`tools/lx32_validator/tests/test_lx32_system.rs`](../../../tools/lx32_validator/tests/test_lx32_system.rs)
- Related documentation: [RTL Core](../../../rtl/core/lx32_system.sv)

---

## License

MIT
