# LX32 Validator - Quick Start Guide

## Overview

The LX32 validator is a comprehensive hardware verification framework for the LX32 CPU. It provides reproducible testing, long program generation, and automatic test case shrinking.

## Prerequisites

- Rust toolchain (1.70+)
- Verilator (for RTL simulation)
- SystemVerilog source files
- C++ compiler

## Installation

```bash
cd tools/lx32_validator
cargo build --release
```

## Basic Usage

### Run All Tests

```bash
cargo run --release
```

This executes all unit tests plus long program validation with a random seed.

### Run with Specific Seed

```bash
cargo run --release -- --seed 42
```

Use this to reproduce a previous test run.

### Quick Validation (Skip Long Programs)

```bash
cargo run --release -- --skip-long
```

Runs only unit tests for rapid development cycles.

### Long Program Testing Only

```bash
cargo run --release -- --long-only
```

Focuses on complex multi-instruction sequence validation.

### Verbose Output

```bash
cargo run --release -- --verbose
```

Enables detailed logging for debugging.

## Advanced Configuration

### Custom Program Parameters

```bash
cargo run --release -- --num-programs 20 --program-length 1000
```

Generates 20 programs with 1000 instructions each.

### Combined Options

```bash
cargo run --release -- --seed 123 --verbose --num-programs 50 --program-length 500
```

## Command Reference

| Option | Description | Default |
|--------|-------------|---------|
| `-s, --seed <SEED>` | Random seed for reproducibility | System time |
| `-v, --verbose` | Enable verbose logging | false |
| `-l, --long-only` | Run only long program tests | false |
| `--skip-long` | Skip long program tests | false |
| `--num-programs <N>` | Number of programs to generate | 10 |
| `--program-length <N>` | Instructions per program | 500 |
| `-h, --help` | Display help | - |
| `-V, --version` | Display version | - |

## Test Modes

### Unit Tests Only

Validates individual CPU components:
- ALU operations
- Branch logic
- Control unit
- Load/Store unit
- Immediate generation
- Memory simulation
- Register file
- Full system integration

Execution time: approximately 2 seconds

### Long Program Tests

Validates complex instruction sequences:
- 500-1000 instruction programs
- Mixed ALU, memory, and control flow operations
- Register dependency testing
- Memory consistency validation

Execution time: 5-10 seconds for 10 programs

### Full Validation

Combines unit tests with long program validation.

Execution time: approximately 10-15 seconds

## Interpreting Results

### Success

```
===================================== LX32 HARDWARE VALIDATION =====================================
Seed: 42 (use --seed 42 to reproduce)

======================================== ALU FUZZER PASSED =========================================
[...]
========================================= ALL TESTS PASSED =========================================
```

### Failure with Shrinking

When a test fails, the validator automatically reduces it:

```
[FAIL] Program 5 - Failed at instruction 347/500
  PC mismatch: RTL=0x1234, GOLD=0x5678
  Failing instruction: 0x00108093 (ADDI x2, x1, 1)

======================================= SHRINKING FAILING TEST CASE =======================================
Original program size: 500 instructions
  [Shrink] Removed instruction(s), now 487 instructions
  [Shrink] Removed chunk, now 450 instructions
  ...
Shrinking complete:
  Original: 500 instructions
  Shrunk:   3 instructions
  Reduction: 99.4%

Minimal failing program:
   0: 00000013  ADDI x1, x0, 0
   1: 00108093  ADDI x2, x1, 1
   2: 0020a113  SLTI x3, x2, 2

Reproduce with: cargo run -- --seed 123456
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Hardware Validation

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Install Rust
        uses: actions-rs/toolchain@v1
        with:
          toolchain: stable
          
      - name: Install Verilator
        run: sudo apt-get install verilator
        
      - name: Run LX32 Validator
        working-directory: tools/lx32_validator
        run: cargo run --release -- --seed ${{ github.run_number }}
```

### Jenkins Pipeline Example

```groovy
pipeline {
    agent any
    stages {
        stage('Validate') {
            steps {
                dir('tools/lx32_validator') {
                    sh 'cargo run --release -- --seed ${BUILD_NUMBER}'
                }
            }
        }
    }
}
```

## Performance Tuning

### Development Mode

```bash
cargo run -- --skip-long
```

Fast iteration during development.

### Standard Testing

```bash
cargo run --release
```

Balanced speed and coverage.

### Intensive Testing

```bash
cargo run --release -- --num-programs 100 --program-length 1000
```

Comprehensive validation for releases.

## Troubleshooting

### Build Failures

Ensure Verilator and all dependencies are installed:

```bash
verilator --version
cargo --version
```

### Test Failures

1. Note the seed from the failure message
2. Reproduce: `cargo run -- --seed <seed>`
3. Enable verbose: `cargo run -- --seed <seed> --verbose`
4. Examine shrunk test case
5. Debug RTL issue

### Performance Issues

- Use `--release` builds for faster execution
- Reduce `--num-programs` for quicker validation
- Use `--skip-long` during development


## Support

For issues or questions, consult the project documentation or review the source code in `src/` and `tests/` directories.

