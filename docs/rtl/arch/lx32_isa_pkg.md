# lx32_isa_pkg — RTL Architecture Package Documentation

## Overview
The `lx32_isa_pkg` package defines opcode enumerations and instruction class encodings for the LX32 processor RTL core. It provides explicit enumerations for RV32I instructions, standardizing opcode values and signal semantics for all modules.

---

## Design Principles
- Central, canonical definitions for opcode enums and constants.
- Type safety via enums and structured constants.
- Facilitates modularity and consistent instruction decoding across RTL blocks.

---

## Content & Structure
- Enumerations for opcode selection and instruction classes.
- Constants for canonical opcode encoding.
- Parameters for architectural variation and maintainability.

---

## Integration
- Imported by control unit, decode logic, and datapath modules to ensure consistent instruction class encoding and interface semantics.
- Foundation for instruction decoding and pipeline control throughout the pipeline.

---

## References
- RTL source: [`rtl/arch/lx32_isa_pkg.sv`](../../rtl/arch/lx32_isa_pkg.sv)

---

## License
MIT
