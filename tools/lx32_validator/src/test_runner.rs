// src/test_runner.rs
//
// Test execution orchestrator for LX32 validator
//
// Coordinates execution of all validation test suites based on configuration.
// Contains no test logic - delegates to individual test modules.
//
// Author: LX32 Validation Team
// License: MIT

use crate::cli::{ValidationConfig, TestMode};

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

pub fn execute_validation_suite(config: ValidationConfig) {
    print_header(&config);

    match config.mode {
        TestMode::UnitTestsOnly => {
            run_unit_tests(&config);
        }
        TestMode::LongProgramsOnly { num_programs, program_length } => {
            run_long_program_tests(&config, num_programs, program_length);
        }
        TestMode::Full { num_programs, program_length } => {
            run_unit_tests(&config);
            run_long_program_tests(&config, num_programs, program_length);
        }
    }

    print_footer();
}

fn print_header(config: &ValidationConfig) {
    println!("{:=^100}", " LX32 HARDWARE VALIDATION ");
    println!("Seed: {} (use --seed {} to reproduce)", config.seed, config.seed);
    println!();
}

fn print_footer() {
    println!("{:=^100}", " ALL TESTS PASSED ");
}

fn run_unit_tests(config: &ValidationConfig) {
    run_alu_tests(config);
    run_branch_tests(config);
    run_control_unit_tests(config);
    run_lsu_tests(config);
    run_imm_gen_tests(config);
    run_memory_sim_tests(config);
    run_reg_generic_tests(config);
    run_register_file_tests(config);
    run_system_tests(config);
}

fn run_alu_tests(config: &ValidationConfig) {
    test_alu::run_alu_fuzzer(test_alu::AluTestParams {
        iterations: 3000,
        rd_range: (1, 32),
        rs1_range: (0, 32),
        imm_range: (0, 4096),
        enable_logging: config.verbose,
    });
}

fn run_branch_tests(config: &ValidationConfig) {
    test_branch_unit::run_branch_fuzzer(test_branch_unit::BranchTestParams {
        iterations: 10000,
        reg_range: (0, 32),
        offset_word_range: (-128, 128),
        enable_logging: config.verbose,
    });
}

fn run_control_unit_tests(config: &ValidationConfig) {
    test_control_unit::run_control_unit_fuzzer(test_control_unit::ControlUnitTestParams {
        iterations: 500,
        reg_range: (0, 32),
        imm_range: (-2048, 2047),
        enable_logging: config.verbose,
    });
}

fn run_lsu_tests(config: &ValidationConfig) {
    test_lsu::run_lsu_fuzzer(test_lsu::LsuTestParams {
        iterations: 2000,
        reg_range: (0, 32),
        imm_range: (-2048, 2047),
        enable_logging: config.verbose,
    });
}

fn run_imm_gen_tests(config: &ValidationConfig) {
    test_imm_gen::run_imm_gen_fuzzer(test_imm_gen::ImmGenTestParams {
        iterations: 2000,
        rd_range: (1, 32),
        branch_offset_range: (-1024, 1024),
        i_imm_range: (-2048, 2047),
        s_imm_range: (-2048, 2047),
        enable_logging: config.verbose,
    });
}

fn run_memory_sim_tests(config: &ValidationConfig) {
    test_memory_sim::run_memory_sim_fuzzer(test_memory_sim::MemorySimTestParams {
        iterations: 1000,
        addr_range: (0, 4096),
        data_range: (0, u32::MAX),
        enable_logging: config.verbose,
    });
}

fn run_reg_generic_tests(config: &ValidationConfig) {
    test_reg_generic::run_reg_generic_fuzzer(test_reg_generic::RegGenericTestParams {
        iterations: 2000,
        data_range: (0, u32::MAX),
        enable_logging: config.verbose,
    });
}

fn run_register_file_tests(config: &ValidationConfig) {
    test_register_file::run_register_file_fuzzer(test_register_file::RegisterFileTestParams {
        iterations: 2000,
        reg_range: (0, 32),
        data_range: (0, u32::MAX),
        enable_logging: config.verbose,
    });
}

fn run_system_tests(config: &ValidationConfig) {
    test_lx32_system::run_lx32_system_fuzzer(test_lx32_system::LX32SystemTestParams {
        iterations: 500,
        reg_range: (0, 32),
        imm_range: (-2048, 2047),
        enable_logging: config.verbose,
    });
}

fn run_long_program_tests(config: &ValidationConfig, num_programs: usize, program_length: usize) {
    test_long_programs::run_long_program_fuzzer(
        test_long_programs::LongProgramTestParams {
            num_programs,
            program_length,
            enable_shrinking: true,
            enable_logging: config.verbose,
        },
        config.seed,
    );
}

