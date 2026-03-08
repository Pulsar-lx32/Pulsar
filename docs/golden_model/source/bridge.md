# bridge — Source Module Documentation

## Overview

C++ hardware bridge for LX32 validator. Provides FFI interface between Rust and Verilated hardware model, enabling creation, ticking, and inspection of the hardware core.

---

## Design Principles

- Modular C++ implementation
- Separation of concerns: hardware bridge only
- Robust error handling
- Integration with Rust via extern "C"
- Designed for maintainability/extensibility

---

## API / Interface

| Function         | Inputs/Outputs                        | Description                                 |
|------------------|---------------------------------------|---------------------------------------------|
| create_core      |                                       | Creates hardware core object                |
| tick_core        | core, reset, instr, mem_rdata         | Pulses hardware core, applies inputs        |
| get_pc           | core                                  | Gets program counter from hardware core     |
| get_reg          | core, index                           | Gets register value from hardware core      |

---

## Functional Description

- Provides C++ functions for hardware simulation
- Allows Rust to create, tick, and inspect hardware core
- Uses Verilator-generated model (Vlx32_system)
- Handles clock pulsing and input application

---

## Integration

- Used by Rust lib.rs via FFI for hardware simulation
- Depends on Verilator-generated model and C++ headers
- Provides hardware bridge for validation workflow

---

## References
- This file: `tools/lx32_validator/src/bridge.cpp`

---

## License

MIT
