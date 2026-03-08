# Using the Makefile for LX32 Validation and Simulation

## Overview

The LX32 Makefile provides convenient targets for compiling, simulating, and validating the CPU hardware and its test suite. This guide explains how to use the Makefile for both SystemVerilog simulation and Rust-based validation.

---

## Simulation Targets

### Compile and Run a Testbench

To compile and run a SystemVerilog testbench:

```bash
make sim TB=<testbench_name>
```

- Replace `<testbench_name>` with the name of your testbench module (e.g., `lx32_system_tb`).
- Example:

```bash
make sim TB=lx32_system_tb
```

This will compile the RTL and testbench, then run the simulation.

### Clean Simulation Artifacts

```bash
make clean
```

Removes all simulation output directories.

---

## Validator Targets

The validator targets allow you to run the Rust-based hardware validation suite with flexible options.

### Standard Validation

```bash
make validate
```

Runs all unit and long program tests with default parameters.

### Verbose Validation (Logging Enabled)

```bash
make validate-verbose
```

Runs all tests with detailed logging output.

### Long Program Validation Only

```bash
make validate-long
```

Runs only the long program tests.

### Long Program Validation with Logging

```bash
make validate-long-verbose
```

Runs only the long program tests with detailed logging.

### Validation with Custom Seed

```bash
make validate-seed SEED=42
```

Runs all tests with a reproducible random seed.

### Custom Long Program Validation

```bash
make validate-long-custom NUM=100 LEN=1000 VERBOSE=1 SEED=42
```

- `NUM`: Number of programs to generate and test (default: 10)
- `LEN`: Instructions per program (default: 500)
- `VERBOSE`: Set to `1` to enable logging
- `SEED`: Random seed for reproducibility

Example:

```bash
make validate-long-custom NUM=50 LEN=2000 VERBOSE=1 SEED=12345
```

### Show Validator CLI Help

```bash
make validate-help
```

Displays all available command-line options for the validator.

---

## Notes

- All validator targets use the release build for performance.
- You can combine variables for flexible validation scenarios.
- The Makefile is designed for both development and CI/CD workflows.

---

## Summary Table

| Target                   | Description                                 |
|------------------------- |---------------------------------------------|
| `make validate`          | Standard validation (all tests)             |
| `make validate-verbose`  | All tests with logging                      |
| `make validate-long`     | Only long program tests                     |
| `make validate-long-verbose` | Long program tests with logging         |
| `make validate-seed SEED=42` | All tests with seed 42                 |
| `make validate-long-custom NUM=100 LEN=1000 VERBOSE=1 SEED=42` | Custom long program validation |
| `make validate-help`     | Show validator CLI help                     |

---

For more details, see the Makefile and the validator documentation.
