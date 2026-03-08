# ALU Test Module — Test Module Documentation

## Overview

Validates the Arithmetic Logic Unit (ALU) of the LX32 core. Performs parameterized unit tests using randomized instruction generation and state comparison between RTL and golden model. Ensures hardware/software equivalence for ALU operations.

---

## Test Design & Principles

- Automated, reproducible, parameterized testing.
- Randomized instruction encoding for ALU operations (ADD, SUB, etc.).
- Captures and compares register and PC states between RTL and golden model.
- Logs results and detects mismatches.
- Uses property-oriented fuzzing.

---

## Parameters & Interface

| Parameter      | Type    | Description                                  |
|---------------|---------|----------------------------------------------|
| iterations    | u32     | Number of test iterations (default: 1000)    |
| rd_range      | (u32,u32)| Destination register range                   |
| rs1_range     | (u32,u32)| Source register range                        |
| imm_range     | (u32,u32)| Immediate value range                        |
| enable_logging| bool    | Enable detailed logging                      |

- Structs: `AluTestParams`, `AluState`

---

## Test Flow & Functional Description

- Initializes test bench and random generator.
- Generates random ALU instructions and executes on RTL and golden model.
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

- Test source: [`tests/test_alu.rs`](../../tests/test_alu.rs)

---

## License

MIT
