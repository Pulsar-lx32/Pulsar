# LSU Test Module — Test Module Documentation

## Overview

Validates the Load/Store Unit (LSU) of the LX32 core. Performs parameterized unit tests using randomized load/store instructions and state comparison between RTL and golden model. Ensures correct memory access and hardware/software equivalence.

---

## Test Design & Principles

- Automated, reproducible, parameterized testing.
- Randomized instruction encoding for load (LW) and store (SW) operations.
- Captures and compares register, PC, and memory states between RTL and golden model.
- Logs results and detects mismatches.
- Uses property-oriented fuzzing.

---

## Parameters & Interface

| Parameter      | Type    | Description                                  |
|---------------|---------|----------------------------------------------|
| iterations    | u32     | Number of test iterations (default: 1000)    |
| reg_range     | (u32,u32)| Register range for sources                   |
| imm_range     | (i32,i32)| Immediate value range                        |
| enable_logging| bool    | Enable detailed logging                      |

- Structs: `LsuTestParams`, `LsuState`

---

## Test Flow & Functional Description

- Initializes test bench and random generator.
- Generates random load/store instructions and executes on RTL and golden model.
- Captures state after each instruction.
- Compares states and logs results.
- On mismatch, logs details and panics for triage.

---

## Integration

- Invoked from `test_runner` or directly via test harness.
- Depends on common utilities and state capture modules.
- Results feed into CI and nightly validation.

---

## References

- Test source: [`tests/test_lsu.rs`](../../tests/test_lsu.rs)

---

## License

MIT
