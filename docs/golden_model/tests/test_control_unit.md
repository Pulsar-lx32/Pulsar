# Control Unit Test Module — Test Module Documentation

## Overview

Validates the control unit of the LX32 core. Performs parameterized unit tests using randomized instruction types (R, I, S, B) and state comparison between RTL and golden model. Ensures correct instruction decoding and execution.

---

## Test Design & Principles

- Automated, reproducible, parameterized testing.
- Randomized instruction generation for all control unit operations.
- Captures and compares register and PC states between RTL and golden model.
- Logs results and detects mismatches.
- Uses property-oriented fuzzing.

---

## Parameters & Interface

| Parameter      | Type    | Description                                  |
|---------------|---------|----------------------------------------------|
| iterations    | u32     | Number of test iterations (default: 100)     |
| reg_range     | (u32,u32)| Register range for sources                   |
| imm_range     | (i32,i32)| Immediate value range                        |
| enable_logging| bool    | Enable detailed logging                      |

- Structs: `ControlUnitTestParams`, `ExecutionState`

---

## Test Flow & Functional Description

- Initializes test bench and random generator.
- Generates random instructions (R, I, S, B types) and executes on RTL and golden model.
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

- Test source: [`tests/test_control_unit.rs`](../../tests/test_control_unit.rs)

---

## License

MIT
