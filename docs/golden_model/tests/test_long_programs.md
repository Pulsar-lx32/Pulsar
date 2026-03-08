# Long Programs Test Module — Test Module Documentation

## Overview

Validates the LX32 core using long, randomly generated instruction sequences. Detects register dependency bugs, memory corruption, control flow errors, PC tracking issues, and pipeline hazards. Performs integration tests and property-oriented fuzzing.

---

## Test Design & Principles

- Automated, reproducible, parameterized testing.
- Generates programs of 500–1000 instructions for stress testing.
- Captures and compares PC and state after each instruction.
- Shrinks failing programs to minimal reproducible cases.
- Logs results and detects mismatches.

---

## Parameters & Interface

| Parameter         | Type    | Description                                  |
|-------------------|---------|----------------------------------------------|
| num_programs      | usize   | Number of programs to test (default: 10)     |
| program_length    | usize   | Instructions per program (default: 500)      |
| enable_shrinking  | bool    | Enable automatic shrinking of failures        |
| enable_logging    | bool    | Enable detailed logging                      |

- Structs: `LongProgramTestParams`, `ProgramFailure`

---

## Test Flow & Functional Description

- Initializes test bench and random generator.
- Generates random programs and executes on RTL and golden model.
- Captures state after each instruction.
- Compares states and logs results.
- Shrinks failing programs to minimal cases for triage.
- On mismatch, logs details and panics for triage.

---

## Integration

- Invoked from `test_runner` or directly via test harness.
- Depends on program generator, shrinking, and common utilities.
- Results feed into CI and nightly validation.

---

## References

- Test source: [`tests/test_long_programs.rs`](../../tests/test_long_programs.rs)

---

## License

MIT
