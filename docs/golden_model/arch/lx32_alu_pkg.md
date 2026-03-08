# lx32_alu_pkg — Golden Model Architecture Package Documentation

## Overview
The `lx32_alu_pkg` package defines canonical ALU operation types for the LX32 golden model. It standardizes arithmetic, logical, shift, and comparison operation enums for the reference model, ensuring type safety and cross-module consistency. These definitions mirror the RTL package and are used throughout the ALU datapath, instruction decoding, and operation selection.

---

## Design Principles
- Central repository for ALU operation enums and constants.
- Designed for equivalence with RTL ALU package.
- Type safety via Rust enums and fixed-value constants.
- Modular and maintainable: promotes reuse and clarity across ALU, control, and decode modules.
- Facilitates consistent operation selection and decoding.

---

## Content & Structure
- Enumerations for ALU operations (add, sub, sll, srl, sra, slt, sltu, xor, or, and).
- Constants for canonical operation encoding.
- No runtime logic or executable functions—only static definitions.

---

## Integration
- Used throughout golden model modules: ALU, control unit, decoder, test benches, and vector generators.
- Ensures canonical reference for ALU operation types and constants.
- Cross-referenced with RTL ALU package for 1:1 mapping and equivalence.

---

## References
- Package source: [`tools/lx32_validator/src/models/arch/lx32_alu_pkg.rs`](../../../tools/lx32_validator/src/models/arch/lx32_alu_pkg.rs)
- Related documentation: [RTL Package](../../../rtl/arch/lx32_alu_pkg.sv)

---

## License
MIT
