# lx32_isa_pkg — Golden Model Architecture Package Documentation

## Overview
The `lx32_isa_pkg` package defines opcode enumerations and instruction class encodings for the LX32 golden model. It standardizes instruction formats and opcode mapping for the reference model, ensuring type safety and cross-module consistency. These definitions mirror the RTL package and are used throughout instruction decoding and pipeline control.

---

## Design Principles
- Central repository for opcode enums and constants.
- Designed for equivalence with RTL ISA package.
- Type safety via Rust enums and fixed-value constants.
- Modular and maintainable: promotes reuse and clarity across core reference modules.
- Facilitates consistent instruction decoding and opcode mapping.

---

## Content & Structure
- Enumerations for opcode selection and instruction classes.
- Constants for canonical opcode encoding.
- No runtime logic or executable functions—only static definitions.

---

## Integration
- Used throughout golden model modules: control unit, decode logic, datapath, test benches, and vector generators.
- Ensures canonical reference for opcode values and instruction classes.
- Cross-referenced with RTL ISA package for 1:1 mapping and equivalence.

---

## References
- Package source: [`tools/lx32_validator/src/models/arch/lx32_isa_pkg.rs`](../../../tools/lx32_validator/src/models/arch/lx32_isa_pkg.rs)
- Related documentation: [RTL Package](../../../rtl/arch/lx32_isa_pkg.sv)

---

## License
MIT
