// tests/common/mod.rs
pub use lx32_validator::models::core::lx32_system::Lx32System;
pub use lx32_validator::{create_core, get_pc, get_reg, tick_core};

pub struct TestBench {
    pub rtl: *mut std::ffi::c_void,
    pub gold: Lx32System,
    current_instr: u32,
    current_mem_rdata: u32,
}

impl TestBench {
    pub fn new() -> Self {
        let rtl = unsafe { create_core() };
        let mut gold = Lx32System::new();
        for _ in 0..10 {
            unsafe { tick_core(rtl, 1, 0, 0) };
            gold.step(0, 0, true);
        }
        Self {
            rtl,
            gold,
            current_instr: 0,
            current_mem_rdata: 0,
        }
    }

    // Helper to print a clean debug line for any module
    pub fn log_step(&self, iter: u32, instr: u32, rd: u32, rtl_val: u32, gold_val: u32) {
        let rtl_pc = unsafe { get_pc(self.rtl) };
        let gold_pc = self.gold.pc;

        let status = if rtl_val == gold_val && rtl_pc == gold_pc {
            "MATCH"
        } else {
            "!!! MISMATCH !!!"
        };

        println!(
            "[{:>5}] Instr: 0x{:08x} | PC: [R:0x{:04x} G:0x{:04x}] | x{:>2}: [R:0x{:08x} G:0x{:08x}] | {}",
            iter, instr, rtl_pc, gold_pc, rd, rtl_val, gold_val, status
        );
    }
}

// Helper functions for long program tests
pub unsafe fn reset(core: *mut std::ffi::c_void) {
    // Hold reset for a few cycles
    for _ in 0..10 {
        tick_core(core, 1, 0, 0);
    }
}

pub unsafe fn set_instr(core: *mut std::ffi::c_void, instr: u32) {
    // Instruction will be used in next posedge_clk call
    // We store it in thread-local or global state
    // For now, we'll just note that this should be used with posedge_clk
}

pub unsafe fn posedge_clk(core: *mut std::ffi::c_void) {
    // Clock cycle with current instruction
    tick_core(core, 0, 0, 0);
}

