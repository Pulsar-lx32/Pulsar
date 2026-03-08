// src/main.rs
//
// LX32 Validator - Main orchestrator for hardware validation
//
// This orchestrator coordinates all validation tests with:
// - Reproducible random seeds
// - Long program generation
// - Automatic test case shrinking
//
// Author: LX32 Validation Team

use clap::Parser;

#[path = "../tests/test_alu.rs"]
mod test_alu;

#[path = "../tests/test_branch_unit.rs"]
mod test_branch_unit;

#[path = "../tests/test_control_unit.rs"]
mod test_control_unit;

#[path = "../tests/test_lsu.rs"]
mod test_lsu;

#[path = "../tests/test_imm_gen.rs"]
mod test_imm_gen;

#[path = "../tests/test_memory_sim.rs"]
mod test_memory_sim;

#[path = "../tests/test_reg_generic.rs"]
mod test_reg_generic;

#[path = "../tests/test_register_file.rs"]
mod test_register_file;

#[path = "../tests/test_lx32_system.rs"]
mod test_lx32_system;

#[path = "../tests/test_long_programs.rs"]
mod test_long_programs;

/// LX32 Hardware Validator - Comprehensive CPU validation framework
#[derive(Parser, Debug)]
#[command(name = "lx32_validator")]
#[command(about = "LX32 CPU Hardware Validation with Fuzzing and Shrinking", long_about = None)]
struct Args {
    /// Random seed for reproducible tests (if not specified, uses system entropy)
    #[arg(short, long)]
    seed: Option<u64>,

    /// Enable verbose logging
    #[arg(short, long)]
    verbose: bool,

    /// Run only long program tests
    #[arg(short, long)]
    long_only: bool,

    /// Skip long program tests
    #[arg(long)]
    skip_long: bool,

    /// Number of long programs to generate and test
    #[arg(long, default_value = "10")]
    num_programs: usize,

    /// Length of each long program (number of instructions)
    #[arg(long, default_value = "500")]
    program_length: usize,
}

fn main() {
    let args = Args::parse();

    // Determine seed
    let seed = args.seed.unwrap_or_else(|| {
        use std::time::{SystemTime, UNIX_EPOCH};
        SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap()
            .as_secs()
    });

    println!("{:=^100}", " LX32 FULL HARDWARE VALIDATION ");
    println!("Seed: {} (use --seed {} to reproduce this run)", seed, seed);
    println!();

    if args.long_only {
        // Run only long program tests
        test_long_programs::run_long_program_fuzzer(
            test_long_programs::LongProgramTestParams {
                num_programs: args.num_programs,
                program_length: args.program_length,
                enable_shrinking: true,
                enable_logging: args.verbose,
            },
            seed,
        );
    } else {
        // Run standard unit tests

        // ALU validation
        test_alu::run_alu_fuzzer(test_alu::AluTestParams {
            iterations: 3000,
            rd_range: (1, 32),
            rs1_range: (0, 32),
            imm_range: (0, 4096),
            enable_logging: args.verbose,
        });

        // Branch validation
        test_branch_unit::run_branch_fuzzer(test_branch_unit::BranchTestParams {
            iterations: 10000,
            reg_range: (0, 32),
            offset_word_range: (-128, 128),
            enable_logging: args.verbose,
        });

        // Control Unit validation
        test_control_unit::run_control_unit_fuzzer(test_control_unit::ControlUnitTestParams {
            iterations: 500,
            reg_range: (0, 32),
            imm_range: (-2048, 2047),
            enable_logging: args.verbose,
        });

        // LSU validation
        test_lsu::run_lsu_fuzzer(test_lsu::LsuTestParams {
            iterations: 2000,
            reg_range: (0, 32),
            imm_range: (-2048, 2047),
            enable_logging: args.verbose,
        });

        // IMM_GEN validation
        test_imm_gen::run_imm_gen_fuzzer(test_imm_gen::ImmGenTestParams {
            iterations: 2000,
            rd_range: (1, 32),
            branch_offset_range: (-1024, 1024),
            i_imm_range: (-2048, 2047),
            s_imm_range: (-2048, 2047),
            enable_logging: args.verbose,
        });

        // Memory simulation validation
        test_memory_sim::run_memory_sim_fuzzer(test_memory_sim::MemorySimTestParams {
            iterations: 1000,
            addr_range: (0, 4096),
            data_range: (0, u32::MAX),
            enable_logging: args.verbose,
        });

        // Register generic validation
        test_reg_generic::run_reg_generic_fuzzer(test_reg_generic::RegGenericTestParams {
            iterations: 2000,
            data_range: (0, u32::MAX),
            enable_logging: args.verbose,
        });

        // Register file validation
        test_register_file::run_register_file_fuzzer(test_register_file::RegisterFileTestParams {
            iterations: 2000,
            reg_range: (0, 32),
            data_range: (0, u32::MAX),
            enable_logging: args.verbose,
        });

        // LX32 System validation
        test_lx32_system::run_lx32_system_fuzzer(test_lx32_system::LX32SystemTestParams {
            iterations: 500,
            reg_range: (0, 32),
            imm_range: (-2048, 2047),
            enable_logging: args.verbose,
        });

        // Long program tests (if not skipped)
        if !args.skip_long {
            test_long_programs::run_long_program_fuzzer(
                test_long_programs::LongProgramTestParams {
                    num_programs: args.num_programs,
                    program_length: args.program_length,
                    enable_shrinking: true,
                    enable_logging: args.verbose,
                },
                seed,
            );
        }
    }

    println!("{:=^100}", " ALL TESTS PASSED SUCCESSFULLY ");
}
