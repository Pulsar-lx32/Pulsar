# lx32_arch_pkg — RTL Architecture Package Documentation

## Overview
The `lx32_arch_pkg` package defines fundamental architectural types, constants, and parameters for the LX32 processor RTL core. It provides canonical definitions for instruction formats, register indices, memory layout, and word sizes, standardizing architectural parameters and signal semantics for all modules.

---

## Design Principles
- Central, canonical definitions for processor-wide parameters and typedefs.
- Type safety via enums, typedefs, and structured constants.
- Facilitates modularity and consistent signal interfacing across RTL blocks.

---

## Content & Structure
- Typedefs for instruction word, data word, register index, address, and program counter.
- Constants for bus widths, register count, memory layout, word sizes, etc.
- Parameters for architectural variation and maintainability.

---

## Integration
- Imported by all core RTL modules to ensure consistent types, values, and interface semantics.
- Foundation for signal interconnection and decoding logic throughout the pipeline.

---

## References
- RTL source: [`rtl/arch/lx32_arch_pkg.sv`](../../rtl/arch/lx32_arch_pkg.sv)

---

## License
MIT
