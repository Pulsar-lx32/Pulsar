# LX32 Validator Build Script Documentation

This document explains the purpose and workflow of the `build.rs` script found in `tools/lx32_validator/`.

## Purpose
- Custom build script for the LX32 Validator Rust project.
- Integrates Verilator-generated C++ code with Rust via static library.

## Steps
1. **Verilator Root Detection**
   - Uses `VERILATOR_ROOT` environment variable if set.
   - Otherwise, auto-detects common install locations based on OS (macOS or Linux).
2. **Include Path Setup**
   - Sets up include paths for Verilator headers and simulation directory.
3. **C++ Build Configuration**
   - Configures the `cc` crate to compile C++ files, including Verilator headers and generated files.
   - Silences warnings from Verilator headers.
4. **Verilator-Generated Files Inclusion**
   - Adds all `.cpp` files from the simulation directory to the build.
   - Ensures build is re-run if any of these files change.
5. **Static Library Compilation**
   - Compiles all sources into a static library named `lx32_bridge`.
6. **Cargo Link Directives**
   - Instructs Cargo to link the static library and the appropriate C++ standard library for the OS.
7. **Build Triggers**
   - Ensures the build script re-runs if `src/bridge.cpp` changes.

## Usage
- The script is executed automatically by Cargo during build, typically triggered by `make librust` or `make setup`.
- No manual invocation required.

## Troubleshooting
- If the simulation directory is missing, the script will panic and instruct to run Verilator first (see `make librust`).
- Ensure Verilator is installed and the simulation directory is generated before building.
