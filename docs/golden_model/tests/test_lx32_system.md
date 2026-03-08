# LX32 System Test Module — Test Module Documentation

## Overview

Validates the overall LX32 system, including register file and PC tracking. Performs parameterized unit tests using randomized instructions and state comparison between RTL and golden model. Ensures hardware/software equivalence for system-level operations.

---

## Test Design & Principles

- Automated, reproducible, parameterized testing.
- Randomized instruction generation for system-level operations.
- Captures and compares register and PC states between RTL and golden model.
- Logs results and detects mismatches.
- Uses property-oriented fuzzing.

---

## Parameters & Interface

| Parameter      | Type    | Description                                  |
|---------------|---------|----------------------------------------------|
| iterations    | u32     | Number of test iterations (default: 500)     |
| reg_range     | (u32,u32)| Register range for sources                   |
| imm_range     | (i32,i32)| Immediate value range                        |
| enable_logging| bool    | Enable detailed logging                      |

- Structs: `LX32SystemTestParams`, `SystemState`

---

## Test Flow & Functional Description

- Initializes system and random generator.
- Generates random instructions and executes on golden model.
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

- Test source: [`tests/test_lx32_system.rs`](../../tests/test_lx32_system.rs)

---

## License

MIT
