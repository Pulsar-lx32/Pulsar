# Advanced Validation Features

## Overview

The LX32 validator has been upgraded with three powerful features that bring it to the level of professional CPU verification frameworks:

1. **Reproducible Random Seeds** - Every test run can be reproduced
2. **Long Program Generation** - Test with 500-1000 instruction sequences
3. **Automatic Test Case Shrinking** - Failed tests are minimized to essential bugs

---

## 1. Reproducible Seeds

### Why It Matters

In hardware validation, reproducibility is critical. When a test fails, you need to run it again with the exact same inputs to debug the issue. Without seed control, random tests are useless for debugging.

### How to Use

**Run with default (random) seed:**
```bash
cd tools/lx32_validator
cargo run
```

**Run with specific seed:**
```bash
cargo run -- --seed 918273
```

**Example output:**
```
================================== LX32 FULL HARDWARE VALIDATION ==================================
Seed: 918273 (use --seed 918273 to reproduce this run)
```

### When You'll Use This

- A test fails in CI/CD
- You see the failure message with the seed
- Reproduce locally: `cargo run -- --seed <that-seed>`
- Debug with exact same random values

---

## 2. Long Program Generation

### Why It Matters

Single instruction tests are good, but they miss:
- **Register hazards** - Back-to-back dependencies
- **Memory corruption** - Store followed by load
- **Control flow bugs** - Branch interactions
- **PC tracking errors** - Multiple jumps in sequence

Real programs are long. You need to test with realistic instruction sequences.

### Architecture

```
Program Generator
├── Configurable length (500-1000 instructions)
├── Mixed instruction types:
│   ├── ALU operations (ADDI, XORI, ORI, ANDI, SLTI)
│   ├── Memory operations (LW, SW)
│   └── Control flow (BEQ, BNE, BLT, BGE, BLTU, BGEU)
├── Seeded RNG for reproducibility
└── Human-readable disassembly
```

### How to Use

**Run only long program tests:**
```bash
cargo run -- --long-only
```

**Configure program parameters:**
```bash
# Generate 20 programs of 1000 instructions each
cargo run -- --num-programs 20 --program-length 1000
```

**Skip long tests (for quick checks):**
```bash
cargo run -- --skip-long
```

**Enable verbose logging:**
```bash
cargo run -- --verbose --long-only
```

### Example Output

```
================================== STARTING LONG PROGRAM FUZZER ==================================
Number of programs: 10
Program length: 500 instructions
Shrinking enabled: true
Seed: 918273

[Program 0] Generated 500 instructions
[PASS] Program 0 - 500 instructions executed successfully
[Program 1] Generated 500 instructions
[PASS] Program 1 - 500 instructions executed successfully
...
```

---

## 3. Automatic Shrinking

### Why It Matters

When a 500-instruction program fails, debugging is hell. Which instruction caused the bug? Is it the first? The last? Somewhere in the middle?

**Shrinking** automatically reduces a failing program to the minimal case that reproduces the bug.

### Example

**Original failure:**
```
Program with 500 instructions fails at instruction 347
```

**After shrinking:**
```
Minimal failing program (3 instructions):
   0: 00000013  ADDI x1, x0, 0
   1: 00108093  ADDI x2, x1, 1
   2: 0020a113  SLTI x3, x2, 2
```

Now you have a tiny test case that reproduces the bug. Much easier to debug!

### How It Works

The shrinker uses multiple strategies:

1. **Remove instructions** - Try removing each instruction
2. **Remove chunks** - Remove large blocks at once (aggressive mode)
3. **Simplify immediates** - Try 0, 1, or powers of 2

It keeps trying until no further reduction is possible.

### Configuration

Shrinking is enabled by default in long program tests. You can control it:

```rust
// In your test code
use lx32_validator::shrinking::{Shrinker, ShrinkConfig};

let shrinker = Shrinker::new(ShrinkConfig {
    max_iterations: 100,  // How hard to try
    aggressive: true,      // Use all strategies
});

let result = shrinker.shrink(&failing_program, |prog| {
    // Return true if bug is still present
    test_program(prog).is_failure()
});
```

### Example Output

```
======================================= SHRINKING FAILING TEST CASE =======================================
Original program size: 500 instructions
  [Shrink] Removed instruction(s), now 487 instructions
  [Shrink] Removed chunk, now 450 instructions
  [Shrink] Removed instruction(s), now 449 instructions
  ...
  [Shrink] Simplified immediates
Shrinking complete:
  Original: 500 instructions
  Shrunk:   3 instructions
  Reduction: 99.4%
  Iterations: 27

Minimal failing program:
   0: 00000013  ADDI x1, x0, 0
   1: 00108093  ADDI x2, x1, 1
   2: 0020a113  SLTI x3, x2, 2
```

---

## Complete CLI Reference

### Basic Commands

```bash
# Run all tests with random seed
cargo run

# Run with specific seed
cargo run -- --seed 42

# Verbose output
cargo run -- --verbose

# Run only long programs
cargo run -- --long-only

# Skip long programs (faster)
cargo run -- --skip-long
```

### Advanced Configuration

```bash
# Generate 50 programs of 1000 instructions each
cargo run -- --num-programs 50 --program-length 1000

# Combine options
cargo run -- --seed 12345 --verbose --num-programs 20

# Quick smoke test
cargo run -- --skip-long
```

### Help

```bash
cargo run -- --help
```

---

## Implementation Architecture

### Module Structure

```
lx32_validator/
├── src/
│   ├── main.rs               # Entry point (orchestrator only)
│   ├── cli.rs                # Command-line interface
│   ├── test_runner.rs        # Test execution coordinator
│   ├── program_generator.rs  # Long instruction sequences
│   ├── shrinking.rs          # Test case minimization
│   ├── lib.rs                # Public API
│   └── models/               # Golden reference models
├── tests/
│   └── test_*.rs             # Individual test modules
└── Cargo.toml
```

### Key Design Principles

1. **Separation of Concerns** - Main is pure orchestrator, no business logic
2. **Modularity** - Each module has single, well-defined responsibility
3. **Configuration-Driven** - All behavior controlled through config structures
4. **Testability** - Each component independently testable

See [architecture.md](architecture.md) for detailed design documentation.
2. Implement test logic with parameters struct
3. Add to `main.rs` orchestrator
4. Document in `docs/`

---

## Best Practices

### For CI/CD

```yaml
# .github/workflows/test.yml
- name: Run validator with fixed seed
  run: |
    cd tools/lx32_validator
    cargo run -- --seed ${{ github.run_number }}
```

This gives you a different seed each CI run, but reproducible within that run.

### For Debugging

1. Test fails with seed 123456
2. Reproduce: `cargo run -- --seed 123456 --verbose`
3. Examine shrunk test case
4. Fix RTL bug
5. Verify: `cargo run -- --seed 123456`

### For Nightly Fuzzing

```bash
#!/bin/bash
# nightly_fuzz.sh
for i in {1..100}; do
  echo "Run $i with seed $RANDOM"
  cargo run -- --seed $RANDOM --num-programs 100 --program-length 1000
done
```

---

## Performance Notes

- **Short tests (unit):** < 1 second
- **Long programs (10x500):** 5-10 seconds
- **Long programs (100x1000):** 1-2 minutes
- **Shrinking:** 10-30 seconds per failure

Adjust `--num-programs` and `--program-length` based on your time budget.

---

## Future Enhancements

Possible improvements:

1. **Coverage-guided fuzzing** - Track which RTL paths are hit
2. **Directed testing** - Focus on specific instruction patterns
3. **Property-based testing** - Express invariants formally
4. **Parallel execution** - Run multiple programs simultaneously
5. **Web dashboard** - Visualize test results

---

## Summary

You now have a professional-grade validation framework:

- **Reproducible** - Every test can be re-run with `--seed`  
- **Realistic** - Tests with 500-1000 instruction programs  
- **Debuggable** - Automatic shrinking to minimal failing cases  
- **Flexible** - CLI options for every scenario  
- **Fast** - Efficient enough for CI/CD  

This is the same level of tooling used by companies building real CPUs.




