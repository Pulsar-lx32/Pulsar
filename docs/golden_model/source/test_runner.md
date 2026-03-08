# test_runner — Source Module Documentation

## Overview

Coordinates execution of all validation test suites for the LX32 validator. Delegates to individual test modules, orchestrates unit and long program tests based on configuration. No test logic; only orchestration.

---

## Design Principles

- Modular Rust implementation
- Separation of concerns: test orchestration only
- Robust error handling
- Integration with CLI and test modules
- Maintainable and extensible

---

## API / Interface

| Function / Struct         | Inputs/Outputs                  | Description                       |
|--------------------------|---------------------------------|-----------------------------------|
| execute_validation_suite | ValidationConfig                | Runs all tests based on config     |
| print_header             | &ValidationConfig               | Prints test suite header           |
| print_footer             |                                 | Prints test suite footer           |
| run_unit_tests           | &ValidationConfig               | Runs all unit tests                |
| run_long_program_tests   | &ValidationConfig, usize, usize | Runs long program tests            |
| ...                      | ...                             | ...                               |

---

## Functional Description

- Orchestrates test execution based on CLI config (unit, long, or both)
- Calls individual test modules (alu, branch, control_unit, etc.)
- Handles output formatting (header/footer)
- No test logic; delegates to test modules

---

## Integration

- Called by main.rs or CLI entry point
- Depends on CLI config and test modules
- Provides test orchestration and result output

---

## References
- This file: `tools/lx32_validator/src/test_runner.rs`

---

## License

MIT
