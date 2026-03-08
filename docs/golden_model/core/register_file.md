# register_file — Golden Model Documentation

## Overview

The `register_file` module implements the register file for the LX32 golden model, supporting 32 registers (x0–x31), 32-bit wide, with x0 hardwired to zero. It mirrors RTL register file functionality, providing dual asynchronous read ports and single synchronous write port.

---

## Design Principles

- x0 hardwired to zero (read-only).
- Dual-port asynchronous reads for combinational decode.
- Single-port synchronous writes.
- Modular, maintainable structure.

---

## API / Interface

**Inputs/Outputs:**

| Name        | Type         | Description                                 |
|-------------|--------------|---------------------------------------------|
| regs        | [u32; 32]    | Register array                              |
| new()       | fn           | Initializes register file                   |
| read_rs1()  | fn           | Read port 1 (asynchronous)                  |
| read_rs2()  | fn           | Read port 2 (asynchronous)                  |
| tick()      | fn           | Write port (synchronous/clocked)            |
| get_reg()   | fn           | Debug/trace register value                  |

---

## Functional Description

- Provides 32 registers, with x0 always zero.
- Supports dual asynchronous reads and single synchronous write.
- Handles reset and write enable logic.
- Returns register values for comparison with RTL outputs.

---

## Test & Validation

- Unit tests located in `tools/lx32_validator/tests/test_register_file.rs`.
- Tests cover register reads, writes, reset, and equivalence with RTL outputs.
- Regression tests compare golden model results to RTL simulation.

---

## Cross-Validation with Hardware

- Results compared to RTL register file via test vector generation and automated diffing.
- CI pipelines and logs ensure equivalence.
- Automation via `setup.sh` and Makefile.

---

## Integration

- Used by the LX32 processor system and testbenches.
- Integrated in full-system simulation and validation framework.

---

## References

- Golden Model source: [`tools/lx32_validator/src/models/core/register_file.rs`](../../../tools/lx32_validator/src/models/core/register_file.rs)
- Rust Test: [`tools/lx32_validator/tests/test_register_file.rs`](../../../tools/lx32_validator/tests/test_register_file.rs)
- Related documentation: [RTL Core](../../../rtl/core/register_file.sv)

---

## License

MIT
