# lx32_decode_pkg — Golden Model Architecture Package Documentation

## Overview
The `lx32_decode_pkg` package centralizes immediate extraction logic and decode parameters for the LX32 golden model. It standardizes instruction formats, immediate bit widths, and decode functions for the reference model, ensuring type safety and cross-module consistency. These definitions mirror the RTL package and are used throughout instruction decoding and immediate generation.

---

## Design Principles
- Central repository for decode logic, immediate bit widths, and constants.
- Designed for equivalence with RTL decode package.
- Type safety via Rust types and fixed-value constants.
- Modular and maintainable: promotes reuse and clarity across core reference modules.
- Facilitates consistent instruction decoding and immediate extraction.

---

## Content & Structure
- Constants for instruction width, sign bit, immediate bit widths.
- Functions for extracting I/S/B/U/J-type immediates.
- No runtime logic or executable functions—only static definitions and decode functions.

---

## Integration
- Used throughout golden model modules: immediate generator, control unit, datapath, test benches, and vector generators.
- Ensures canonical reference for decode logic and immediate constants.
- Cross-referenced with RTL decode package for 1:1 mapping and equivalence.

---

## References
- Package source: [`tools/lx32_validator/src/models/arch/lx32_decode_pkg.rs`](../../../tools/lx32_validator/src/models/arch/lx32_decode_pkg.rs)
- Related documentation: [RTL Package](../../../rtl/arch/lx32_decode_pkg.sv)

---

## License
MIT
