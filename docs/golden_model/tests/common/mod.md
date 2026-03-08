# Mod for common utilities — Documentation

## Overview

Provides shared utilities, interfaces, and test bench setup for LX32 validation tests. Used by all test modules to instantiate RTL and golden model, manage instruction execution, and log results.

---

## Design & Principles

- Centralizes test bench creation and state management.
- Provides logging and comparison helpers for all modules.
- Exposes safe and unsafe interfaces for RTL interaction.
- Enables reproducible and automated test setup.

---

## Parameters & Interface

- Structs: `TestBench` (contains RTL pointer, golden model instance, current instruction, memory data).
- Functions:
  - `TestBench::new()` — Initializes RTL and golden model.
  - `TestBench::log_step()` — Logs state comparison for any module.
  - `reset()` — Resets RTL core.
  - `set_instr()` — Sets instruction for RTL core.
  - `posedge_clk()` — Advances RTL clock.

---

## Functional Description

- Used by all test modules for consistent test setup.
- Provides logging for state comparison (registers, PC, memory).
- Handles RTL/golden model synchronization and error reporting.
- Enables modular and maintainable test code.

---

## Integration

- Imported by all test modules via `mod common`.
- Depends on core model and RTL interface.
- Results feed into CI and nightly validation.

---

## References

- Source: [`tests/common/mod.rs`](../../tests/common/mod.rs)

---

## License

MIT

