# lx32_branch_pkg — Golden Model Architecture Package Documentation

## Overview
The `lx32_branch_pkg` package defines canonical branch operation types for the LX32 golden model. It standardizes equality, signed, and unsigned comparison enums for the reference model, ensuring type safety and cross-module consistency. These definitions mirror the RTL package and are used throughout the branch unit, instruction decoding, and control logic.

---

## Design Principles
- Central repository for branch operation enums and constants.
- Designed for equivalence with RTL branch package.
- Type safety via Rust enums and fixed-value constants.
- Modular and maintainable: promotes reuse and clarity across core reference modules.
- Facilitates consistent branch operation selection and decoding.

---

## Content & Structure
- Enumerations for branch operations (eq, ne, lt, ge, ltu, geu).
- Constants for canonical operation encoding.
- No runtime logic or executable functions—only static definitions.

---

## Integration
- Used throughout golden model modules: branch unit, ALU, control unit, test benches, and vector generators.
- Ensures canonical reference for branch operation types and constants.
- Cross-referenced with RTL branch package for 1:1 mapping and equivalence.

---

## References
- Package source: [`tools/lx32_validator/src/models/arch/lx32_branch_pkg.rs`](../../../tools/lx32_validator/src/models/arch/lx32_branch_pkg.rs)
- Related documentation: [RTL Package](../../../rtl/arch/lx32_branch_pkg.sv)

---

## License
MIT
