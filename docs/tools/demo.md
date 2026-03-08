# LX32 Validator Advanced Features Demonstration Documentation

This document explains the purpose and workflow of the `demo.sh` script found in `tools/lx32_validator/`.

## Purpose
- Demonstrates the advanced validation capabilities of the LX32 Validator.
- Provides reproducible test runs, CLI help, and long program testing.

## Steps
1. **Reproducible Seed Demonstration**
   - Runs the validator with a fixed seed (`42`) and skips long tests.
   - Shows how to reproduce results using the same seed.
2. **CLI Options Display**
   - Runs the validator with `--help` to show available CLI options.
   - Equivalent to `make validate-help`.
3. **Long Program Testing**
   - Runs the validator with `--long-only`, generating 3 programs of 100 instructions each.
   - Demonstrates complex instruction sequences and long program validation.
   - Advanced usage: see `make validate-long` and `make validate-long-custom`.
4. **Summary**
   - Lists key features demonstrated: reproducible seeds, long program generation, flexible CLI, fast execution.
   - Suggests further commands and next steps.

## Usage
Run the script from its directory:
```sh
cd tools/lx32_validator
./demo.sh
```

### Automated Validation
- Use Make targets for advanced and automated validation:
  - `make validate` (standard fuzzer)
  - `make validate-verbose` (detailed output)
  - `make validate-long` (long-form tests)
  - `make validate-long-custom NUM=10 LEN=1000` (custom long tests)
  - `make validate-seed SEED=123` (specific seed)
  - `make validate-help` (CLI options)

## Notes
- If a test fails, the shrinking engine will reduce it to a minimal failing case.
- The script is intended for demonstration and quick validation of LX32 features.

