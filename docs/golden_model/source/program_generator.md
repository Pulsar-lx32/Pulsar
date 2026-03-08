# program_generator — Source Module Documentation

## Overview

Generates long instruction sequences for comprehensive LX32 hardware testing. Produces randomized programs to test register dependencies, memory operations, control flow, and PC correctness.

---

## Design Principles

- Modular Rust implementation
- Separation of concerns: program generation only
- Configurable program parameters
- Robust error handling
- Designed for maintainability/extensibility

---

## API / Interface

| Function / Struct   | Inputs/Outputs                | Description                                 |
|---------------------|------------------------------|---------------------------------------------|
| Instruction         | encoding, mnemonic, rd, ...  | Represents a single instruction              |
| ProgramConfig       | length, enable_branches, ... | Program sequence configuration               |
| Program             | instructions, config          | Generated program with full trace            |
| generate            | ProgramConfig, seed           | Generates a new random program               |
| generate_instruction| ProgramConfig, rng            | Generates a single random instruction        |
| ...                 | ...                          | ...                                         |

---

## Functional Description

- Generates randomized instruction sequences based on config and seed
- Supports ALU, LOAD, STORE, BRANCH categories
- Produces programs for fuzzing and validation
- Used for long program tests and bug reproduction

---

## Integration

- Used by test modules and shrinking for program generation
- Depends on rand crate for randomness
- Provides Program and Instruction types to validation workflow

---

## References
- This file: `tools/lx32_validator/src/program_generator.rs`

---

## License

MIT
