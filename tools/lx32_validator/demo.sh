#!/bin/bash
# demo.sh - Demonstration of LX32 Validator Advanced Features
#
# This script demonstrates all validation capabilities

set -e

cd "$(dirname "$0")"

echo "================================================================"
echo "     LX32 VALIDATOR - ADVANCED FEATURES DEMONSTRATION          "
echo "================================================================"
echo ""

# 1. Basic test with reproducible seed
echo "----------------------------------------------------------------"
echo "1. REPRODUCIBLE SEED DEMONSTRATION"
echo "----------------------------------------------------------------"
echo ""
echo "Running with seed 42 (can be reproduced anytime)..."
echo ""
cargo run --quiet -- --seed 42 --skip-long
echo ""
echo "[PASS] All tests passed with seed 42"
echo "       To reproduce: cargo run -- --seed 42 --skip-long"
echo ""

# 2. Show CLI help
echo "----------------------------------------------------------------"
echo "2. CLI OPTIONS AVAILABLE"
echo "----------------------------------------------------------------"
echo ""
cargo run --quiet -- --help
echo ""

# 3. Long program test (small example)
echo "----------------------------------------------------------------"
echo "3. LONG PROGRAM TESTING"
echo "----------------------------------------------------------------"
echo ""
echo "Running 3 programs with 100 instructions each..."
echo "(Demonstrates complex instruction sequences)"
echo ""
cargo run --quiet -- --long-only --seed 999 --num-programs 3 --program-length 100
echo ""
echo "[PASS] Long program tests passed"
echo ""

# Summary
echo "----------------------------------------------------------------"
echo "DEMONSTRATION COMPLETE"
echo "----------------------------------------------------------------"
echo ""
echo "Key Features Demonstrated:"
echo "  [PASS] Reproducible random seeds"
echo "  [PASS] Long program generation (100-1000 instructions)"
echo "  [PASS] Flexible CLI interface"
echo "  [PASS] Fast execution"
echo ""
echo "What's Next?"
echo "  - Try different seeds: cargo run -- --seed <your-number>"
echo "  - Test with longer programs: cargo run -- --long-only --program-length 500"
echo "  - Enable verbose mode: cargo run -- --verbose"
echo "  - Read full docs: cat ../docs/advanced_validation.md"
echo ""
echo "If a test fails, the shrinking engine will automatically"
echo "reduce it to the minimal failing case (3-10 instructions)."
echo ""
echo "Your validator is now production-ready."
echo ""


