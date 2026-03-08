# lx32_branch_pkg — RTL Architecture Package Documentation

## Overview
The `lx32_branch_pkg` package defines canonical branch operation types for the LX32 processor RTL core. It provides explicit enumerations for equality, signed, and unsigned comparisons, standardizing branch operation encoding and signal semantics for all modules.

---

## Design Principles
- Central, canonical definitions for branch operation enums and constants.
- Type safety via enums and structured constants.
- Facilitates modularity and consistent branch operation selection across RTL blocks.

---

## Content & Structure
- Enumerations for branch operations (eq, ne, lt, ge, ltu, geu).
- Constants for canonical operation encoding.
- Parameters for architectural variation and maintainability.

---

## Integration
- Imported by branch unit, ALU, and control unit modules to ensure consistent operation encoding and interface semantics.
- Foundation for branch operation selection and decoding logic throughout the pipeline.

---

## References
- RTL source: [`rtl/arch/lx32_branch_pkg.sv`](../../rtl/arch/lx32_branch_pkg.sv)

---

## License
MIT
