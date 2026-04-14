// ============================================================
// LX32 Processor System (Single Cycle) - Golden Model
// ============================================================
// Integration of all core sub-modules:
// - Control Unit, ALU, Branch Unit, LSU, RF and ImmGen.
//
// Design Principles:
//   - Clear signal naming and hierarchical structure.
//   - Single-cycle execution datapath.
//   - Synchronous state updates matching RTL behavior.
// ============================================================

use crate::models::arch::lx32_isa_pkg::opcode_t;
use crate::models::core::alu::alu_golden_model;
use crate::models::core::branch_unit::branch_unit_golden;
use crate::models::core::control_unit::control_unit_golden;
use crate::models::core::imm_gen::imm_gen_golden;
use crate::models::core::register_file::RegisterFile;

pub struct Lx32System {
    pub pc: u32,
    pub reg_file: RegisterFile,
    pub memory: Vec<u8>,
    wait_counter: u32,
    wait_consumed: bool,
}

impl Lx32System {
    /// Initialize a new LX32 Golden Model with 4KB of memory
    pub fn new() -> Self {
        Self {
            pc: 0,
            reg_file: RegisterFile::new(),
            memory: vec![0; 4096],
            wait_counter: 0,
            wait_consumed: false,
        }
    }

    /// Helper to read a 32-bit word from the internal memory (Little Endian)
    pub fn read_mem(&self, addr: u32) -> u32 {
        let a = addr as usize;
        if a + 3 < self.memory.len() {
            u32::from_le_bytes([
                self.memory[a],
                self.memory[a + 1],
                self.memory[a + 2],
                self.memory[a + 3],
            ])
        } else {
            0 // Return 0 for out-of-bounds access
        }
    }

    /// Executes a single clock cycle of the processor
    ///
    /// Arguments:
    /// * `instr` - The 32-bit instruction fetched from memory
    /// * `mem_rdata` - Data returned from memory (used for Load instructions)
    /// * `rst` - Reset signal
    ///
    /// Returns:
    /// * `(alu_res, rs2_data, mem_write)` - LSU signals to be compared with RTL
    pub fn step(&mut self, instr: u32, mem_rdata: u32, rst: bool) -> (u32, u32, bool) {
        // --- 1. Reset Logic ---
        if rst {
            self.pc = 0;
            self.wait_counter = 0;
            self.wait_consumed = false;
            self.reg_file.tick(true, 0, 0, false);
            return (0, 0, false);
        }

        // WAIT already active: hold pipeline and PC while countdown runs.
        if self.wait_counter > 0 {
            self.wait_counter = self.wait_counter.saturating_sub(1);
            self.reg_file.tick(false, 0, 0, false);
            return (0, 0, false);
        }

        // --- 2. Decode Stage ---
        // Extracting fields from the instruction
        let opcode = opcode_t::from_bits((instr & 0x7F) as u8);
        let funct3 = ((instr >> 12) & 0x7) as u8;
        let funct7_5 = ((instr >> 30) & 0x1) != 0;

        // Generating control signals and extending immediate
        let ctrl = control_unit_golden(opcode, funct3, funct7_5);
        let imm_ext = imm_gen_golden(instr);

        // --- 3. Register File Read ---
        let rs1_addr = ((instr >> 15) & 0x1F) as u8;
        let rs2_addr = ((instr >> 20) & 0x1F) as u8;
        let rd_addr = ((instr >> 7) & 0x1F) as u8;

        let rs1_data = self.reg_file.read_rs1(rs1_addr);
        let rs2_data = self.reg_file.read_rs2(rs2_addr);

        // Stub custom datapath values mirrored from RTL stubs.
        let sensor_idx = (rs1_data & 0x3F) as u32;
        let sensor_val = 1000u32 + sensor_idx;
        let delta_val = 20u32;
        let matrix_ptr = 0x5000_0000u32;
        let active_keys = 0x0000_00FFu32;
        let chord_match = if (active_keys & rs1_data) == rs1_data {
            1u32
        } else {
            0u32
        };

        // --- 4. Execution Stage ---
        let alu_a = if ctrl.src_a_pc { self.pc } else { rs1_data };
        let alu_b = if ctrl.alu_src { imm_ext } else { rs2_data };

        // ALU evaluation uses the MUXed alu_b
        let alu_res = alu_golden_model(alu_a, alu_b, ctrl.alu_control);

        // BRANCH evaluation ALWAYS uses rs1_data and rs2_data directly
        // Do not use alu_a/alu_b here to avoid confusion
        let branch_taken = branch_unit_golden(rs1_data, rs2_data, ctrl.branch, ctrl.branch_op);

        // --- 6. State Update ---
        let is_wait_instr = ctrl.custom_1 && funct3 == 0b000;
        let wait_start = is_wait_instr && !self.wait_consumed;

        let next_pc = if wait_start {
            self.pc
        } else if ctrl.jump {
            if ctrl.jalr {
                rs1_data.wrapping_add(imm_ext) & 0xFFFF_FFFE
            } else {
                self.pc.wrapping_add(imm_ext)
            }
        } else if ctrl.branch && branch_taken {
            self.pc.wrapping_add(imm_ext)
        } else {
            self.pc.wrapping_add(4)
        };

        // --- 7. Result MUX (Write-back source) ---
        // result_src: 00=ALU, 01=Mem, 10=PC+4, 11=IMM
        let write_data = match ctrl.result_src {
            0b00 => {
                if ctrl.custom_0 {
                    match funct3 {
                        0b000 => sensor_val,
                        0b001 => matrix_ptr,
                        0b010 => delta_val,
                        0b011 => chord_match,
                        _ => 0,
                    }
                } else {
                    alu_res
                }
            }
            0b01 => mem_rdata,
            0b10 => self.pc.wrapping_add(4),
            0b11 => imm_ext,
            _ => alu_res,
        };

        // --- 8. Register File Write-back ---
        self.reg_file.tick(false, rd_addr, write_data, ctrl.reg_write);

        if wait_start {
            self.wait_counter = rs1_data;
            self.wait_consumed = true;
        } else if !is_wait_instr {
            self.wait_consumed = false;
        }

        // --- 8.5 Commit next PC ---
        self.pc = next_pc;

        // --- 9. Return LSU signals for validation ---
        // (Address, Data to write, Write Enable)
        (alu_res, rs2_data, ctrl.mem_write)
    }
}



