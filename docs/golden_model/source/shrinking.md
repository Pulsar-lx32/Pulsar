# shrinking — Source Module Documentation

## Overview

Implements the LX32 Test Case Shrinker. Reduces failing test cases to minimal reproducible examples by removing unnecessary instructions, simplifying immediates, and reducing register usage. Inspired by property-based testing frameworks.

---

## Design Principles

- Modular Rust implementation
- Separation of concerns: shrinking only
- Configurable strategies (aggressive, max_iterations)
- Robust error handling
- Designed for maintainability/extensibility

---

## API / Interface

| Function / Struct | Inputs/Outputs                | Description                                 |
|-------------------|------------------------------|---------------------------------------------|
| ShrinkConfig      | max_iterations, aggressive   | Shrinking strategy configuration             |
| ShrinkResult      | original_size, shrunk_size   | Result of shrinking operation                |
| Shrinker          | ShrinkConfig                 | Main shrinker engine                        |
| shrink            | &Program, test_fn            | Shrinks a failing program to minimal case    |
| ...               | ...                          | ...                                         |

---

## Functional Description

- Shrinks failing programs using multiple strategies:
  - Remove instructions one by one
  - Remove chunks of instructions (aggressive)
  - Simplify immediate values (aggressive)
- Iteratively applies strategies until minimal bug-reproducing program is found
- Tracks iterations and improvement

---

## Integration

- Used by test modules and main orchestrator for shrinking failing test cases
- Depends on program_generator for Program and Instruction types
- Provides ShrinkResult to validation workflow

---

## References
- This file: `tools/lx32_validator/src/shrinking.rs`

---

## License

MIT
