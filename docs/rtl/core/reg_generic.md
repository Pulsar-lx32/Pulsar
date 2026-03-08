# reg_generic — RTL Core Module Documentation

## Overview

Parameterizable synchronous register for LX32 processor. Implements state storage for datapath and control logic. Used in register file and other modules.

---

## Design Principles

- Canonical RTL implementation for generic register.
- Parameterization for width and reset value.
- No implicit latches, non-blocking assignments only.
- Reset-safe initialization.
- Robust, synthesis-friendly design with formal-verification readiness.

---

## Port Interface & Parameters

| Signal        | Direction | Type        | Description                          |
|---------------|----------|-------------|--------------------------------------|
| clk           | input    | logic       | Clock signal                         |
| rst           | input    | logic       | Reset signal                         |
| en            | input    | logic       | Clock enable                         |
| data_in       | input    | [WIDTH-1:0] | Data input                           |
| data_out      | output   | [WIDTH-1:0] | Data output                          |

| Parameter     | Default   | Type      | Description                          |
|---------------|-----------|-----------|--------------------------------------|
| WIDTH         | 8         | integer   | Register width                       |

---

## Content & Structure

- Implements sequential logic for state storage.
- Handles reset, clocking, and control signal propagation.

---

## Integration

- Used in register file and other core modules.
- Forms part of the processor pipeline and interfaces with system-level signals.

---

## References

- RTL source: [`rtl/core/reg_generic.sv`](../../rtl/core/reg_generic.sv)


---

## License

MIT
