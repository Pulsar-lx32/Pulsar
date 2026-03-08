# cli — Source Module Documentation

## Overview

Defines and parses all command-line arguments for the LX32 validator. Converts CLI input into a unified configuration structure for test orchestration.

---

## Design Principles

- Modular Rust implementation
- Separation of concerns: CLI parsing only
- Robust error handling
- Integration with test runner and main orchestrator
- Designed for maintainability/extensibility

---

## API / Interface

| Function / Struct   | Inputs/Outputs                | Description                                 |
|---------------------|------------------------------|---------------------------------------------|
| CliArgs             | CLI arguments                 | Parsed CLI arguments                        |
| ValidationConfig    | seed, verbose, mode           | Unified test configuration                  |
| TestMode            | UnitTestsOnly, LongProgramsOnly, Full | Test mode selection                |
| parse_arguments     |                              | Parses CLI args into ValidationConfig        |
| generate_seed       |                              | Generates random seed if not specified       |

---

## Functional Description

- Parses CLI arguments using clap
- Determines test mode, seed, verbosity, and program parameters
- Converts input into ValidationConfig for test orchestration

---

## Integration

- Used by main.rs and test_runner.rs for configuration
- Depends on clap crate for argument parsing
- Provides ValidationConfig to validation workflow

---

## References
- This file: `tools/lx32_validator/src/cli.rs`

---

## License

MIT
