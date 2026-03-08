# Immediate Generator Test Module — Test Module Documentation

## Overview

Validates the immediate generator (imm_gen) of the LX32 core. Performs parameterized unit tests using randomized instruction types (I, S, B) and state comparison between RTL and golden model. Ensures correct immediate extraction and hardware/software equivalence.

---

## Test Design & Principles

- Automated, reproducible, parameterized testing.
- Randomized instruction encoding for immediate types (IAddi, SStore, BBeq).
- Captures and compares register, PC, and immediate states between RTL and golden model.
- Logs results and detects mismatches.
- Uses property-oriented fuzzing.

---

## Parameters & Interface

| Parameter           | Type       | Description                                  |
|---------------------|-----------|----------------------------------------------|
| iterations          | u32       | Number of test iterations (default: 1000)    |
| rd_range            | (u32,u32) | Destination register range                   |
| branch_offset_range | (i32,i32) | Branch offset range                          |
| i_imm_range         | (i32,i32) | I-type immediate range                       |
| s_imm_range         | (i32,i32) | S-type immediate range                       |
| enable_logging      | bool      | Enable detailed logging                      |

- Structs: `ImmGenTestParams`, `ImmGenState`, `ImmInstrType`

---

## Test Flow & Functional Description

- Initializes test bench and random generator.
- Generates random instructions for I, S, B types and executes on RTL and golden model.
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

- Test source: [`tests/test_imm_gen.rs`](../../tests/test_imm_gen.rs)

---

## License

MIT
