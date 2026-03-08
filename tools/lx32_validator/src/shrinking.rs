// src/shrinking.rs
//
// LX32 Test Case Shrinker - Reduces failing test cases to minimal reproducible examples
//
// When a test fails, this module attempts to:
// 1. Remove unnecessary instructions
// 2. Simplify immediate values
// 3. Reduce register usage
// 4. Find the minimal program that reproduces the bug
//
// This is inspired by property-based testing frameworks like QuickCheck and modern fuzzers
//
// Author: LX32 Validation Team
// License: MIT

use crate::program_generator::{Instruction, Program};

/// Shrinking strategy configuration
pub struct ShrinkConfig {
    pub max_iterations: usize,
    pub aggressive: bool,
}

impl Default for ShrinkConfig {
    fn default() -> Self {
        Self {
            max_iterations: 100,
            aggressive: false,
        }
    }
}

/// Result of shrinking operation
pub struct ShrinkResult {
    pub original_size: usize,
    pub shrunk_size: usize,
    pub iterations: usize,
    pub program: Program,
}

/// Main shrinker engine
pub struct Shrinker {
    config: ShrinkConfig,
}

impl Shrinker {
    pub fn new(config: ShrinkConfig) -> Self {
        Shrinker { config }
    }

    /// Shrink a failing program to minimal reproducible case
    /// test_fn should return true if the bug is still present
    pub fn shrink<F>(&self, program: &Program, test_fn: F) -> ShrinkResult
    where
        F: Fn(&Program) -> bool,
    {
        let original_size = program.instructions.len();
        let mut current = program.clone();
        let mut iterations = 0;
        let mut improved = true;

        println!("\n{:=^100}", " SHRINKING FAILING TEST CASE ");
        println!("Original program size: {} instructions", original_size);

        while improved && iterations < self.config.max_iterations {
            improved = false;

            // Strategy 1: Remove instructions one by one
            if let Some(smaller) = self.try_remove_instructions(&current, &test_fn) {
                println!("  [Shrink] Removed instruction(s), now {} instructions", smaller.instructions.len());
                current = smaller;
                improved = true;
                iterations += 1;
                continue;
            }

            // Strategy 2: Remove chunks of instructions
            if self.config.aggressive {
                if let Some(smaller) = self.try_remove_chunks(&current, &test_fn) {
                    println!("  [Shrink] Removed chunk, now {} instructions", smaller.instructions.len());
                    current = smaller;
                    improved = true;
                    iterations += 1;
                    continue;
                }
            }

            // Strategy 3: Simplify immediates
            if self.config.aggressive {
                if let Some(simplified) = self.try_simplify_immediates(&current, &test_fn) {
                    println!("  [Shrink] Simplified immediates");
                    current = simplified;
                    improved = true;
                    iterations += 1;
                    continue;
                }
            }
        }

        let shrunk_size = current.instructions.len();
        let reduction = if original_size > 0 {
            ((original_size - shrunk_size) as f64 / original_size as f64) * 100.0
        } else {
            0.0
        };

        println!("Shrinking complete:");
        println!("  Original: {} instructions", original_size);
        println!("  Shrunk:   {} instructions", shrunk_size);
        println!("  Reduction: {:.1}%", reduction);
        println!("  Iterations: {}", iterations);

        ShrinkResult {
            original_size,
            shrunk_size,
            iterations,
            program: current,
        }
    }

    /// Try to remove instructions one at a time
    fn try_remove_instructions<F>(&self, program: &Program, test_fn: F) -> Option<Program>
    where
        F: Fn(&Program) -> bool,
    {
        for i in (0..program.instructions.len()).rev() {
            let mut candidate = program.clone();
            candidate.instructions.remove(i);

            if !candidate.instructions.is_empty() && test_fn(&candidate) {
                return Some(candidate);
            }
        }
        None
    }

    /// Try to remove chunks of instructions
    fn try_remove_chunks<F>(&self, program: &Program, test_fn: F) -> Option<Program>
    where
        F: Fn(&Program) -> bool,
    {
        let chunk_sizes = [program.instructions.len() / 2, program.instructions.len() / 4, 10, 5];

        for chunk_size in chunk_sizes {
            if chunk_size == 0 || chunk_size >= program.instructions.len() {
                continue;
            }

            for start in (0..program.instructions.len()).step_by(chunk_size) {
                let end = (start + chunk_size).min(program.instructions.len());
                let mut candidate = program.clone();
                candidate.instructions.drain(start..end);

                if !candidate.instructions.is_empty() && test_fn(&candidate) {
                    return Some(candidate);
                }
            }
        }
        None
    }

    /// Try to simplify immediate values (reduce to 0, 1, or powers of 2)
    fn try_simplify_immediates<F>(&self, program: &Program, test_fn: F) -> Option<Program>
    where
        F: Fn(&Program) -> bool,
    {
        for i in 0..program.instructions.len() {
            if let Some(imm) = program.instructions[i].imm {
                if imm == 0 || imm == 1 {
                    continue; // Already simplified
                }

                // Try simplifying to 0
                let mut candidate = program.clone();
                candidate.instructions[i] = self.simplify_instruction_imm(&candidate.instructions[i], 0);
                if test_fn(&candidate) {
                    return Some(candidate);
                }

                // Try simplifying to 1
                let mut candidate = program.clone();
                candidate.instructions[i] = self.simplify_instruction_imm(&candidate.instructions[i], 1);
                if test_fn(&candidate) {
                    return Some(candidate);
                }

                // Try power of 2
                if imm > 1 {
                    let simplified = 1 << (imm.abs().ilog2());
                    let mut candidate = program.clone();
                    candidate.instructions[i] = self.simplify_instruction_imm(&candidate.instructions[i], simplified as i32);
                    if test_fn(&candidate) {
                        return Some(candidate);
                    }
                }
            }
        }
        None
    }

    /// Create a new instruction with simplified immediate
    fn simplify_instruction_imm(&self, instr: &Instruction, new_imm: i32) -> Instruction {
        let mut simplified = instr.clone();
        simplified.imm = Some(new_imm);

        // Reconstruct encoding based on instruction type
        // This is a simplified version - you'd need to handle all instruction formats
        let opcode = instr.encoding & 0x7F;

        simplified.encoding = match opcode {
            0x13 | 0x03 => {
                // I-type (ALU-I, LOAD)
                ((new_imm as u32) << 20) | (instr.encoding & 0x000FFFFF)
            }
            0x23 => {
                // S-type (STORE)
                let imm_11_5 = ((new_imm >> 5) & 0x7F) as u32;
                let imm_4_0 = (new_imm & 0x1F) as u32;
                (imm_11_5 << 25) | (instr.encoding & 0x01FFFFFF) | (imm_4_0 << 7)
            }
            0x63 => {
                // B-type (BRANCH)
                let imm_12 = ((new_imm >> 12) & 0x1) as u32;
                let imm_10_5 = ((new_imm >> 5) & 0x3F) as u32;
                let imm_4_1 = ((new_imm >> 1) & 0xF) as u32;
                let imm_11 = ((new_imm >> 11) & 0x1) as u32;
                (imm_12 << 31) | (imm_10_5 << 25) | (instr.encoding & 0x01FFF07F) | (imm_4_1 << 8) | (imm_11 << 7)
            }
            _ => instr.encoding,
        };

        simplified
    }
}

/// Quick shrink - simple interface for most common case
pub fn quick_shrink<F>(program: &Program, test_fn: F) -> Program
where
    F: Fn(&Program) -> bool,
{
    let shrinker = Shrinker::new(ShrinkConfig::default());
    let result = shrinker.shrink(program, test_fn);
    result.program
}

/// Aggressive shrink - more strategies, takes longer
pub fn aggressive_shrink<F>(program: &Program, test_fn: F) -> Program
where
    F: Fn(&Program) -> bool,
{
    let shrinker = Shrinker::new(ShrinkConfig {
        max_iterations: 500,
        aggressive: true,
    });
    let result = shrinker.shrink(program, test_fn);
    result.program
}

