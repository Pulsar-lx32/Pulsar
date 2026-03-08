# Memory Simulation Test Module — Test Module Documentation

## Overview

Validates the memory simulation (MemorySim) of the LX32 core. Performs parameterized unit tests using randomized read/write operations and state comparison. Ensures correct memory access and hardware/software equivalence.

---

## Test Design & Principles

- Automated, reproducible, parameterized testing.
- Randomized address and data generation for memory operations.
- Captures and compares memory states after each operation.
- Logs results and detects mismatches.
- Uses property-oriented fuzzing.

---

## Parameters & Interface

| Parameter      | Type    | Description                                  |
|---------------|---------|----------------------------------------------|
| iterations    | u32     | Number of test iterations (default: 1000)    |
| addr_range    | (u32,u32)| Address range for memory operations          |
| data_range    | (u32,u32)| Data range for memory operations             |
| enable_logging| bool    | Enable detailed logging                      |

- Structs: `MemorySimTestParams`, `MemoryState`

---

## Test Flow & Functional Description

- Initializes memory simulation and random generator.
- Generates random read/write operations and executes on memory simulation.
- Captures state after each operation.
- Compares states and logs results.
- On mismatch, logs details and panics for triage.

---

## Integration

- Invoked from `test_runner` or directly via test harness.
- Depends on common utilities and state capture modules.
- Results feed into CI and nightly validation.

---

## References

- Test source: [`tests/test_memory_sim.rs`](../../tests/test_memory_sim.rs)

---

## License

MIT
