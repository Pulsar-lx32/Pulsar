// src/cli.rs
//
// Command-line interface configuration for LX32 validator
//
// Defines all CLI arguments and parses them into a unified configuration structure.
//
// Author: LX32 Validation Team
// License: MIT

use clap::Parser;
use std::time::{SystemTime, UNIX_EPOCH};

#[derive(Parser, Debug)]
#[command(name = "lx32_validator")]
#[command(about = "LX32 CPU Hardware Validation Framework")]
#[command(version)]
pub struct CliArgs {
    #[arg(short, long, help = "Random seed for reproducible tests")]
    seed: Option<u64>,

    #[arg(short, long, help = "Enable verbose logging")]
    verbose: bool,

    #[arg(short, long, help = "Run only long program tests")]
    long_only: bool,

    #[arg(long, help = "Skip long program tests")]
    skip_long: bool,

    #[arg(long, default_value = "10", help = "Number of long programs to generate")]
    num_programs: usize,

    #[arg(long, default_value = "500", help = "Instructions per long program")]
    program_length: usize,
}

#[derive(Debug, Clone)]
pub struct ValidationConfig {
    pub seed: u64,
    pub verbose: bool,
    pub mode: TestMode,
}

#[derive(Debug, Clone)]
pub enum TestMode {
    UnitTestsOnly,
    LongProgramsOnly { num_programs: usize, program_length: usize },
    Full { num_programs: usize, program_length: usize },
}

pub fn parse_arguments() -> ValidationConfig {
    let args = CliArgs::parse();

    let seed = args.seed.unwrap_or_else(generate_seed);

    let mode = match (args.long_only, args.skip_long) {
        (true, _) => TestMode::LongProgramsOnly {
            num_programs: args.num_programs,
            program_length: args.program_length,
        },
        (false, true) => TestMode::UnitTestsOnly,
        (false, false) => TestMode::Full {
            num_programs: args.num_programs,
            program_length: args.program_length,
        },
    };

    ValidationConfig {
        seed,
        verbose: args.verbose,
        mode,
    }
}

fn generate_seed() -> u64 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .expect("System time is before UNIX epoch")
        .as_secs()
}

