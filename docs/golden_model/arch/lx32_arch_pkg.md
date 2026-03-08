# lx32_arch_pkg — Golden Model Architecture Package Documentation

## Overview
The `lx32_arch_pkg` package defines fundamental architectural types, constants, and parameters for the LX32 golden model. It standardizes instruction formats, register indices, memory layout, and word sizes for the reference model, ensuring type safety and cross-module consistency. These definitions mirror the RTL package and are used throughout instruction decoding, register mapping, and memory management.

---

## Design Principles
- Central repository for architecture-wide types and constants.
- Designed for equivalence with RTL architecture package.
- Type safety via Rust types and fixed-value constants.
- Modular and maintainable: promotes reuse and clarity across core reference modules.
- Facilitates consistent instruction decoding, register mapping, and memory handling.

---

## Content & Structure
- Constants for word size, register count, address width, program counter width.
- Type aliases for instruction word, data word, register index, address, and program counter.
- No runtime logic or executable functions—only static definitions.

---

## Integration
- Used throughout golden model modules: ALU, branch unit, control unit, memory system, test benches, and vector generators.
- Ensures canonical reference for architectural types and constants.
- Cross-referenced with RTL architecture package for 1:1 mapping and equivalence.

---

## References
- Package source: [`tools/lx32_validator/src/models/arch/lx32_arch_pkg.rs`](../../../tools/lx32_validator/src/models/arch/lx32_arch_pkg.rs)
- Related documentation: [RTL Package](../../../rtl/arch/lx32_arch_pkg.sv)

---

## License
MIT
