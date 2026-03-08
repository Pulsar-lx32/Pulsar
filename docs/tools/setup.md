# LX32 Environment Setup & Verification Script Documentation

This document explains the purpose and workflow of the `setup.sh` script found in `tools/`.

## Purpose
- Prepares the LX32 project environment for development and validation.
- Ensures all required dependencies are installed.
- Automates bridge generation, validator compilation, and initial validation via Make targets.

## Steps
1. **Dependency Checks**
   - Verifies that `verilator` (RTL simulator) and `cargo` (Rust toolchain) are installed.
   - If missing, prints an error and exits.
2. **Project Root Detection**
   - Determines the project root directory regardless of where the script is run from.
3. **RTL-to-Rust Bridge Generation**
   - Runs `make librust` to generate C++ headers and shared objects via Verilator.
4. **Rust Validator Compilation**
   - Runs `cargo build --release` to compile the validator in release mode.
5. **Initial Validation Suite**
   - Runs `make validate` to execute the default test suite.
6. **Success Message**
   - Prints a success message and suggests further commands.

## Usage
### Automated Setup
Run the following command from the project root to automate environment setup:
```sh
make setup
```
This will ensure `setup.sh` is executable and run it.

### Manual Setup
Alternatively, run the script directly from any location:
```sh
./tools/setup.sh
```

## Advanced Testing
- Use `make validate`, `make validate-verbose`, `make validate-long`, etc. for advanced validation options.
- For CLI options, run `make validate-help`.

## Troubleshooting
- If dependencies are missing, follow the instructions printed by the script.
- For more testing options, use `make validate-help` after setup.

