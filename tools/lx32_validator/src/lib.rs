pub mod models;
pub mod program_generator;
pub mod shrinking;

use std::ffi::c_void;

#[link(name = "lx32_bridge", kind = "static")]
unsafe extern "C" {
    pub fn create_core() -> *mut c_void;
    pub fn tick_core(core: *mut c_void, reset: u8, instr: u32, mem_rdata: u32);
    pub fn get_pc(core: *mut c_void) -> u32;
    pub fn get_reg(core: *mut c_void, index: u8) -> u32;
}
