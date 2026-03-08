# lx32_decode_pkg — RTL Architecture Package Documentation

## Overview
The `lx32_decode_pkg` package centralizes immediate extraction logic and decode parameters for the LX32 processor RTL core. It provides functions for extracting immediates from instruction fields, as well as constants for instruction width and format, standardizing decode logic and signal semantics for all modules.

---

## Design Principles
- Central, canonical definitions for decode logic, immediate bit widths, and constants.
- Type safety via typedefs and structured constants.
- Facilitates modularity and consistent decode logic across RTL blocks.

---

## Content & Structure
- Functions for extracting I/S/B/U/J-type immediates.
- Constants for instruction width, sign bit, immediate bit widths.
- Parameters for architectural variation and maintainability.

---

## Integration
- Imported by immediate generator, control unit, and datapath modules to ensure consistent decode logic and interface semantics.
- Foundation for instruction decoding and immediate extraction throughout the pipeline.

---

## References
- RTL source: [`rtl/arch/lx32_decode_pkg.sv`](../../rtl/arch/lx32_decode_pkg.sv)

---

## License
MIT
