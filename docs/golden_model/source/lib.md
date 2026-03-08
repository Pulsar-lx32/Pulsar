# lib — Source Module Documentation

## Overview

Defines the core Rust library interface for LX32 validator. Exposes models, program generation, shrinking, and FFI bindings to the hardware bridge (C++).

---

## Design Principles

- Modular Rust implementation
- Separation of concerns: library interface and FFI
- Robust error handling
- Integration with Rust and C++ bridge
- Designed for maintainability/extensibility

---

## API / Interface

| Function / Struct   | Inputs/Outputs                | Description                                 |
|---------------------|------------------------------|---------------------------------------------|
| models              |                              | Core architectural models                    |
| program_generator   |                              | Program generation module                    |
| shrinking           |                              | Shrinking module                             |
| create_core         |                              | Creates hardware core via C++ bridge         |
| tick_core           | core, reset, instr, mem_rdata| Pulses hardware core via C++ bridge          |
| get_pc              | core                         | Gets program counter from hardware core      |
| get_reg             | core, index                  | Gets register value from hardware core       |

---

## Functional Description

- Exposes Rust modules and FFI bindings to C++ hardware bridge
- Allows creation, ticking, and inspection of hardware core from Rust
- Used by test modules and orchestrator for hardware interaction

---

## Integration

- Used by main.rs and test modules for hardware interaction
- Depends on C++ bridge for hardware simulation
- Provides FFI interface and core modules

---

## References
- This file: `tools/lx32_validator/src/lib.rs`

---

## License

MIT
