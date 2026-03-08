# mod — Golden Model Documentation

## Overview

The `mod` module acts as the central module for the LX32 golden model core, re-exporting all core sub-modules: ALU, Branch Unit, Control Unit, Immediate Generator, LSU, LX32 System, Memory Simulation, Generic Register, and Register File. It mirrors the RTL core module structure, facilitating modular integration and maintainability.

---

## Design Principles

- Central repository for core module exports.
- Modular structure for ease of extension and integration.
- Promotes reuse and clarity across core reference modules.

---

## API / Interface

**Inputs/Outputs:**

| Name        | Type         | Description                                 |
|-------------|--------------|---------------------------------------------|
| alu         | module       | Arithmetic Logic Unit                       |
| branch_unit | module       | Branch Evaluation Unit                      |
| control_unit| module       | Control Unit                                |
| imm_gen     | module       | Immediate Generation Unit                   |
| lsu         | module       | Load/Store Unit                             |
| lx32_system | module       | Processor System                            |
| memory_sim  | module       | Simulation Memory                           |
| reg_generic | module       | Generic Register                            |
| register_file| module      | Register File                               |

---

## Functional Description

- Re-exports all core modules for unified access.
- Facilitates integration in testbenches, validation framework, and full-system simulation.
- No runtime logic; only module declarations.

---

## Test & Validation

- All core module tests are located in `tools/lx32_validator/tests/`.
- Regression tests cover integration scenarios and equivalence with RTL outputs.

---

## Cross-Validation with Hardware

- Results compared to RTL core module via test vector generation and automated diffing.
- CI pipelines and logs ensure equivalence.
- Automation via `setup.sh` and Makefile.

---

## Integration

- Central module connecting all golden model core units.
- Used in reference testbench, validation framework, and full-system simulation.
- Depends on architectural packages and core modules.

---

## References

- Golden Model source: [`tools/lx32_validator/src/models/core/mod.rs`](../../../tools/lx32_validator/src/models/core/mod.rs)
- Rust Tests: [`tools/lx32_validator/tests/`](../../../tools/lx32_validator/tests/)
- Related documentation: [RTL Core](../../../rtl/core/mod.sv)

---

## License

MIT
