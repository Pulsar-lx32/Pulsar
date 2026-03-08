// ============================================================
// LX32 Simulation Memory
// ============================================================
// Dual-port memory model for RV32I core simulation.
//
// Features:
//   - 4 KB total memory (1024 x 32-bit words)
//   - Word-aligned addressing
//   - Asynchronous read
//   - Synchronous write
//   - Program preload via $readmemh
//
// Design Principles:
//   - Tool-friendly (no latches)
//   - Deterministic behavior
//   - ISA-aligned word indexing
//   - Clean separation of instruction/data ports
// ============================================================

/// Provides a 4KB memory space with dual-port access.
pub struct MemorySim {
    // 1024 words of 32 bits (4KB)
    pub ram: Vec<u32>,
}

impl MemorySim {
    pub fn new() -> Self {
        Self { ram: vec![0; 1024] }
    }

    /// Load a program from a hex-like list of instructions
    pub fn load_program(&mut self, program: &[u32]) {
        for (i, &instr) in program.iter().enumerate() {
            if i < self.ram.len() {
                self.ram[i] = instr;
            }
        }
    }

    /// Instruction Port (Asynchronous/Combinational Read)
    pub fn read_instr(&self, addr: u32) -> u32 {
        // assign i_index = i_addr[11:2];
        let index = ((addr & 0xFFF) >> 2) as usize;
        self.ram[index % 1024]
    }

    /// Data Port Read (Asynchronous/Combinational)
    pub fn read_data(&self, addr: u32) -> u32 {
        // assign d_index = d_addr[11:2];
        let index = ((addr & 0xFFF) >> 2) as usize;
        self.ram[index % 1024]
    }

    /// Data Port Write (Synchronous/Clocked)
    /// In the golden model, we call this on the clock edge.
    pub fn write_data(&mut self, addr: u32, data: u32, we: bool) {
        if we {
            let index = ((addr & 0xFFF) >> 2) as usize;
            self.ram[index % 1024] = data;
        }
    }
}



