# LX32 Validator - Technical Implementation

## Architecture Overview

The LX32 validator follows a clean, modular architecture with clear separation of concerns. The main entry point serves purely as an orchestrator, delegating all logic to specialized modules.

## Module Structure

```
lx32_validator/
├── src/
│   ├── main.rs               # Entry point (orchestrator only)
│   ├── cli.rs                # Command-line argument parsing
│   ├── test_runner.rs        # Test execution coordinator
│   ├── program_generator.rs  # Long program generation
│   ├── shrinking.rs          # Test case minimization
│   ├── lib.rs                # Public API exports
│   └── models/               # Golden reference models
├── tests/
│   ├── test_alu.rs
│   ├── test_branch_unit.rs
│   ├── test_control_unit.rs
│   ├── test_lsu.rs
│   ├── test_imm_gen.rs
│   ├── test_memory_sim.rs
│   ├── test_reg_generic.rs
│   ├── test_register_file.rs
│   ├── test_lx32_system.rs
│   └── test_long_programs.rs
└── Cargo.toml
```

## Design Principles

### 1. Separation of Concerns

**main.rs** - Pure orchestrator
- No business logic
- No test configuration
- Only coordinates CLI parsing and test execution

**cli.rs** - Command-line interface
- Argument parsing using clap
- Configuration structure creation
- Seed generation

**test_runner.rs** - Test coordination
- Executes test suites based on configuration
- Delegates to individual test modules
- No test logic implementation

**Test modules** - Isolated test logic
- Each module contains its own validation logic
- Parameterized through configuration structures
- Independent and testable

### 2. Configuration-Driven

All test behavior is controlled through configuration structures:

```rust
pub struct ValidationConfig {
    pub seed: u64,
    pub verbose: bool,
    pub mode: TestMode,
}

pub enum TestMode {
    UnitTestsOnly,
    LongProgramsOnly { num_programs: usize, program_length: usize },
    Full { num_programs: usize, program_length: usize },
}
```

### 3. Modularity

Each component has a single, well-defined responsibility:

- **CLI Module**: Parse arguments, generate configuration
- **Test Runner**: Execute tests based on configuration
- **Program Generator**: Create instruction sequences
- **Shrinker**: Minimize failing test cases
- **Test Modules**: Implement validation logic

## Key Features

### Reproducible Random Seeds

Every test run uses a seed (either provided or generated from system time). This ensures:
- Deterministic test execution
- Bug reproducibility
- CI/CD integration

### Long Program Generation

Generates realistic instruction sequences (500-1000 instructions) including:
- ALU operations (ADDI, XORI, ORI, ANDI, SLTI)
- Memory operations (LW, SW)
- Control flow (BEQ, BNE, BLT, BGE, BLTU, BGEU)

### Automatic Test Shrinking

When a test fails, the shrinker automatically reduces it using:
- Instruction removal
- Chunk removal (aggressive mode)
- Immediate value simplification

Typical reduction: 500 instructions to 3-10 instructions.

## Usage

### Basic Commands

```bash
# Run all tests
cargo run

# Run with specific seed
cargo run -- --seed 42

# Run only unit tests
cargo run -- --skip-long

# Run only long program tests
cargo run -- --long-only

# Verbose output
cargo run -- --verbose

# Custom configuration
cargo run -- --seed 123 --num-programs 20 --program-length 1000
```

### Integration with CI/CD

```yaml
- name: Run LX32 Validator
  run: |
    cd tools/lx32_validator
    cargo run -- --seed ${{ github.run_number }}
```

## Performance Characteristics

| Test Mode | Duration | Instructions Tested |
|-----------|----------|---------------------|
| Unit tests only | ~2 seconds | 20,000+ |
| Standard (with 10x500) | ~10 seconds | 25,000+ |
| Intensive (100x1000) | ~2 minutes | 120,000+ |

## Extension Points

### Adding a New Test Module

1. Create `tests/test_new_module.rs` with test logic
2. Define parameter structure
3. Implement test function
4. Add to `test_runner.rs`

Example:

```rust
// In test_runner.rs
fn run_new_module_tests(config: &ValidationConfig) {
    test_new_module::run_fuzzer(test_new_module::TestParams {
        iterations: 1000,
        enable_logging: config.verbose,
    });
}
```

### Adding CLI Options

1. Add field to `CliArgs` in `cli.rs`
2. Update `ValidationConfig` if needed
3. Pass through to test modules

## Code Quality

### Standards
- No business logic in main.rs
- All modules have clear, single responsibilities
- Configuration structures for parameterization
- Comprehensive documentation

### Testing
- Each test module is independently testable
- Reproducible through seeds
- Automated shrinking for failures

## Dependencies

- **clap**: Command-line argument parsing
- **rand**: Seeded random number generation
- **verilator**: RTL simulation (via C++ bridge)

## Summary

The LX32 validator implements professional CPU verification techniques with:
- Clean architecture
- Modular design
- Reproducible testing
- Realistic workloads
- Automatic debugging support

All code follows industry best practices for maintainability, scalability, and testability.

