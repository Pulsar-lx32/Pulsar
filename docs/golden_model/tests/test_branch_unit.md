# Branch Unit Test Module — Test Module Documentation

## Overview

Validates the branch unit of the LX32 core. Performs parameterized unit tests using randomized branch instructions and state comparison between RTL and golden model. Ensures correct branch behavior and hardware/software equivalence.

---

## Test Design & Principles

- Automated, reproducible, parameterized testing.
- Randomized branch instruction encoding (BEQ, BNE, etc.).
- Captures and compares PC and register states before and after branch.
- Logs results and detects mismatches.
- Uses property-oriented fuzzing.

---

## Parameters & Interface

| Parameter           | Type       | Description                                  |
|---------------------|-----------|----------------------------------------------|
| iterations          | u32       | Number of test iterations (default: 1000)    |
| reg_range           | (u32,u32) | Register range for sources                   |
| offset_word_range   | (i32,i32) | Branch offset range (in words)               |
| enable_logging      | bool      | Enable detailed logging                      |

- Structs: `BranchTestParams`, `BranchState`

---

## Test Flow & Functional Description

- Initializes test bench and random generator.
- Generates random branch instructions and executes on RTL and golden model.
- Captures state before and after branch.
- Compares states and logs results.
- On mismatch, logs details and panics for triage.

---

## Integration

- Invoked from `test_runner` or directly via test harness.
- Depends on common utilities and state capture modules.
- Results feed into CI and nightly validation.

---

## References

- Test source: [`tests/test_branch_unit.rs`](../../tests/test_branch_unit.rs)

---

## License

MIT
