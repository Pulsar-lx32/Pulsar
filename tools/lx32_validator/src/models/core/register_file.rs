// ============================================================
// LX32 Register File (RV32I)
// ============================================================
// - 32 registers (x0–x31), 32-bit wide.
// - x0 is hardwired to zero (read-only).
// - Dual asynchronous read ports for combinational decode.
// - Single synchronous write port.
// ============================================================

/// Replicates a 32-register file where x0 is hardwired to 0.
/// Features dual-port asynchronous reads and single-port synchronous writes.
pub struct RegisterFile {
    // 32 registers (x0 to x31)
    regs: [u32; 32],
}

impl RegisterFile {
    pub fn new() -> Self {
        Self { regs: [0; 32] }
    }

    /// Read Port 1 (Asynchronous)
    pub fn read_rs1(&self, addr: u8) -> u32 {
        if addr == 0 {
            0
        } else {
            self.regs[addr as usize]
        }
    }

    /// Read Port 2 (Asynchronous)
    pub fn read_rs2(&self, addr: u8) -> u32 {
        if addr == 0 {
            0
        } else {
            self.regs[addr as usize]
        }
    }

    /// Write Port (Synchronous / Clocked)
    /// This mirrors the generate block and the write_en logic in SV.
    pub fn tick(&mut self, rst: bool, addr_rd: u8, data_rd: u32, we: bool) {
        if rst {
            // Reset all registers (x0 stays 0 anyway)
            self.regs = [0; 32];
        } else if we && addr_rd != 0 {
            // Replicates: assign write_en = (we && (addr_rd != 5'd0))
            self.regs[addr_rd as usize] = data_rd;
        }
    }

    /// Helper for debugging/trace: Get the current value of a register
    pub fn get_reg(&self, index: usize) -> u32 {
        if index == 0 { 0 } else { self.regs[index] }
    }
}



