# main — Source Module Documentation

## Overview

Main orchestrator for LX32 hardware validation. Coordinates all validation tests, manages reproducible random seeds, long program generation, and automatic test case shrinking.

---

## Design Principles

- Modular Rust implementation
- Separation of concerns: orchestration only
- Robust error handling
- Integration with CLI, test modules, and shrinking
- Designed for maintainability/extensibility

---

## API / Interface

| Function / Struct | Inputs/Outputs                | Description                                 |
|-------------------|------------------------------|---------------------------------------------|
| main              |                              | Entry point for LX32 validator               |
| Args              | CLI arguments                 | Parsed CLI arguments                        |
| ...               | ...                          | ...                                         |

---

## Functional Description

- Parses CLI arguments and determines test configuration
- Prints header and seed information
- Runs unit tests, long program tests, and shrinking as needed
- Delegates to test modules and shrinking engine

---

## Integration

- Entry point for LX32 validator
- Depends on CLI, test modules, and shrinking
- Provides orchestration and result output

---

## References
- This file: `tools/lx32_validator/src/main.rs`

---

## License

MIT
