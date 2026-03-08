# lx32

**lx32** is a minimal 32-bit CPU project written in **SystemVerilog**.

> **Purpose**  
> This project's goal is educational: to understand how a CPU works from the ground up, including digital logic, datapaths, control logic, and basic instruction execution.

---

## 🛠️ Quick Start

The LX32 environment is **fully automated**. To compile the RTL-to-Rust bridge, build the validator, and run the full test suite:

```bash
make setup
```

> **Note:**  
> Requires `verilator` and the Rust toolchain installed.

---

## 🎯 Goals

- Learn computer architecture by building it.
- Practice SystemVerilog through real hardware design.
- Keep the design simple, readable, and well-documented.

---

## 🚫 Non-Goals

- High performance.
- Feature completeness.
- Production-ready silicon.

---

## 🏗️ Project Scope

- Custom 32-bit architecture.
- Simple instruction set.
- Incremental development and testing.
- Simulation-first approach.

---

## ✅ Verification and Robustness

The LX32 architecture undergoes comprehensive stress testing via a custom **Rust-based validator**.

| Module         | Iterations     | Status  |
| -------------- | ------------- | ------- |
| ALU Core       | 100,000,000   | PASSED  |
| Branch Unit    | 100,000,000   | PASSED  |
| Control Unit   | 100,000,000   | PASSED  |
| Register File  | 100,000,000   | PASSED  |
| Full System    | 100,000,000   | PASSED  |

**Total random vectors processed:**  
_Approximately 1.1 Billion in under 75 seconds._

---

## 📄 License

MIT

---
