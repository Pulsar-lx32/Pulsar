# lx32_alu_pkg — RTL Architecture Package Documentation

## Overview
The `lx32_alu_pkg` package defines canonical ALU operation types for the LX32 processor RTL core. It provides explicit enumerations for arithmetic, logical, shift, and comparison operations, standardizing ALU operation encoding and signal semantics for all modules.

---

## Design Principles
- Central, canonical definitions for ALU operation enums and constants.
- Type safety via enums and structured constants.
- Facilitates modularity and consistent ALU operation selection across RTL blocks.

---

## Content & Structure
- Enumerations for ALU operations (add, sub, sll, srl, sra, slt, sltu, xor, or, and).
- Constants for canonical operation encoding.
- Parameters for architectural variation and maintainability.

---

## Integration
- Imported by ALU, control unit, and decoder modules to ensure consistent operation encoding and interface semantics.
- Foundation for ALU operation selection and decoding logic throughout the pipeline.

---

## References
- RTL source: [`rtl/arch/lx32_alu_pkg.sv`](../../rtl/arch/lx32_alu_pkg.sv)

---

## License
MIT
