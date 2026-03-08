# memory_sim — Golden Model Documentation

## Overview

The `memory_sim` module implements a dual-port simulation memory for the LX32 golden model, providing 4KB of word-aligned memory for core simulation. It mirrors RTL memory behavior, supporting asynchronous reads, synchronous writes, and program preload.

---

## Design Principles

- Tool-friendly: no latches, deterministic behavior.
- ISA-aligned word indexing.
- Clean separation of instruction and data ports.
- Modular, maintainable structure.

---

## API / Interface

**Inputs/Outputs:**

| Name        | Type         | Description                                 |
|-------------|--------------|---------------------------------------------|
| ram         | Vec<u32>     | Internal memory array (1024 x 32-bit words) |
| new()       | fn           | Initializes memory                          |
| load_program| fn           | Loads program into memory                   |
| read_instr  | fn           | Reads instruction word                      |
| read_data   | fn           | Reads data word                            |
| write_data  | fn           | Writes data word                           |

---

## Functional Description

- Provides 4KB memory space with dual-port access.
- Supports asynchronous instruction and data reads.
- Synchronous data writes on clock edge.
- Program preload for simulation setup.
- Handles out-of-bounds access gracefully.

---

## Test & Validation

- Unit tests located in `tools/lx32_validator/tests/test_memory_sim.rs`.
- Tests cover memory access, edge cases, and equivalence with RTL outputs.
- Regression tests compare golden model results to RTL simulation.

---

## Cross-Validation with Hardware

- Results compared to RTL memory via test vector generation and automated diffing.
- CI pipelines and logs ensure equivalence.
- Automation via `setup.sh` and Makefile.

---

## Integration

- Used by the LX32 processor system and testbenches.
- Integrated in full-system simulation and validation framework.

---

## References

- Golden Model source: [`tools/lx32_validator/src/models/core/memory_sim.rs`](../../../tools/lx32_validator/src/models/core/memory_sim.rs)
- Rust Test: [`tools/lx32_validator/tests/test_memory_sim.rs`](../../../tools/lx32_validator/tests/test_memory_sim.rs)
- Related documentation: [RTL Core](../../../rtl/core/memory_sim.sv)

---

## License

MIT
