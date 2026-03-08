# mod — Golden Model Architecture Package Documentation

## Overview
The `mod` module acts as the central repository for all LX32 golden model architecture packages. It re-exports canonical modules (ALU, branch, decode, ISA, arch) for unified access and integration, ensuring type safety and cross-module consistency. This structure mirrors the RTL package hierarchy.

---

## Design Principles
- Central repository for architecture-wide modules.
- Designed for equivalence with RTL package structure.
- Type safety via module boundaries and re-exports.
- Modular and maintainable: promotes reuse and clarity across core reference modules.
- Facilitates consistent architectural access and integration.

---

## Content & Structure
- Re-exports modules for ALU, branch, decode, ISA, and arch types.
- No runtime logic or executable functions—only module definitions and static content.

---

## Integration
- Used throughout golden model modules: ALU, branch unit, control unit, memory system, test benches, and vector generators.
- Ensures canonical reference for architectural modules.
- Cross-referenced with RTL architecture package structure for 1:1 mapping and equivalence.

---

## References
- Package source: [`tools/lx32_validator/src/models/arch/mod.rs`](../../../tools/lx32_validator/src/models/arch/mod.rs)

---

## License
MIT
