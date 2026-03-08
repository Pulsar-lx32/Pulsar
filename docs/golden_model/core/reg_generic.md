# reg_generic — Golden Model Documentation

## Overview

The `reg_generic` module implements a parameterizable synchronous register for the LX32 golden model, supporting asynchronous reset and clock enable. It mirrors RTL generic register functionality, providing reference sequential logic for register state updates.

---

## Design Principles

- No implicit latches; only explicit sequential logic.
- Non-blocking assignments.
- Reset-safe initialization.
- Width scalability (default 32 bits).

---

## API / Interface

**Inputs/Outputs:**

| Name        | Type         | Description                                 |
|-------------|--------------|---------------------------------------------|
| data_out    | u32          | Register output value                       |
| width       | u32          | Register width (bits)                       |
| tick()      | fn           | Sequential logic update                     |

---

## Functional Description

- Replicates synchronous register with asynchronous reset and clock enable.
- Applies mask to ensure data stays within specified width.
- Holds previous value if neither reset nor enable is active.

---

## Test & Validation

- Unit tests located in `tools/lx32_validator/tests/test_reg_generic.rs`.
- Tests cover register initialization, reset, enable, and width scaling.
- Regression tests compare golden model results to RTL simulation.

---

## Cross-Validation with Hardware

- Results compared to RTL generic register via test vector generation and automated diffing.
- CI pipelines and logs ensure equivalence.
- Automation via `setup.sh` and Makefile.

---

## Integration

- Used by the LX32 processor system and testbenches.
- Integrated in full-system simulation and validation framework.

---

## References

- Golden Model source: [`tools/lx32_validator/src/models/core/reg_generic.rs`](../../../tools/lx32_validator/src/models/core/reg_generic.rs)
- Rust Test: [`tools/lx32_validator/tests/test_reg_generic.rs`](../../../tools/lx32_validator/tests/test_reg_generic.rs)
- Related documentation: [RTL Core](../../../rtl/core/reg_generic.sv)

---

## License

MIT
