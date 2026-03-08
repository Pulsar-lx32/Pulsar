# ============================================================
# LX32 Makefile :: SystemVerilog Simulation (Verilator portable)
# ============================================================

SHELL := /bin/sh
VERILATOR ?= verilator
VERILATOR_FLAGS ?= -Wall -Wno-fatal --binary --trace --trace-structs -O2 --timing

OUTDIR := .sim
ROOT_DIR := $(CURDIR)
LIB_OUTDIR := $(abspath $(OUTDIR)/lx32_lib)

# Relative paths
RTL_CORE := rtl/core
RTL_ARCH := rtl/arch
TB_CORE  := tb/core

.PHONY: help sim clean

# Verilator include path detection (Linux vs macOS)
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
  # macOS (Homebrew)
  VERILATOR_ROOT := $(shell brew --prefix verilator)/share/verilator
else
  # Linux (apt or general)
  VERILATOR_ROOT := /usr/share/verilator
endif
VERILATOR_INC := $(VERILATOR_ROOT)/include

VALIDATOR_DIR := tools/lx32_validator

librust:
	@rm -rf "$(LIB_OUTDIR)"
	@mkdir -p "$(LIB_OUTDIR)"
	@chmod -R u+rwX "$(OUTDIR)"
	@test -d "$(LIB_OUTDIR)"
	@test -w "$(LIB_OUTDIR)"
	# 1. Generate C++ files
	$(VERILATOR) -Wall --cc \
		--Mdir $(LIB_OUTDIR) \
		rtl/arch/*.sv \
		rtl/core/*.sv \
		--top-module lx32_system

	# 2. Compile the bridge (portable include handling)
	g++ -c -fPIC $(VALIDATOR_DIR)/src/bridge.cpp \
		-I$(LIB_OUTDIR) \
		-I$(VERILATOR_INC) \
		-I$(VERILATOR_INC)/vltstd \
		-o $(ROOT_DIR)/.sim/bridge.o

help:
	@echo "Usage: make sim TB=lx32_system"

sim:
	@if [ -z "$(TB)" ]; then echo "ERROR: Define TB=<name>"; exit 2; fi
	@mkdir -p "$(OUTDIR)/$(TB)"
	@echo "Compiling System: $(TB)..."

	$(VERILATOR) $(VERILATOR_FLAGS) \
		--top-module $(TB) \
		--Mdir $(OUTDIR)/$(TB) \
		$(RTL_ARCH)/*.sv \
		$(RTL_CORE)/*.sv \
		$(TB_CORE)/$(TB).sv \
		-o $(TB)_sim

	@echo "Running simulation..."
	./$(OUTDIR)/$(TB)/$(TB)_sim +trace

clean:
	@rm -rf $(OUTDIR)

# ======================
# LX32 Validator Targets
# ======================

VALIDATOR_BIN := $(VALIDATOR_DIR)/target/release/lx32_validator
SEED ?=
NUM ?=10
LEN ?=500

.PHONY: validate validate-verbose validate-long validate-long-verbose validate-seed validate-long-custom validate-help

# --- Setup & Installation ---

.PHONY: setup
setup: ## Configure the environment and run initial validation
	@chmod +x tools/setup.sh
	@./tools/setup.sh

.PHONY: help
help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

validate:
	cargo run --release --manifest-path $(VALIDATOR_DIR)/Cargo.toml

validate-verbose:
	cargo run --release --manifest-path $(VALIDATOR_DIR)/Cargo.toml -- --verbose

validate-long:
	cargo run --release --manifest-path $(VALIDATOR_DIR)/Cargo.toml -- --long-only

validate-long-verbose:
	cargo run --release --manifest-path $(VALIDATOR_DIR)/Cargo.toml -- --long-only --verbose

validate-seed:
	cargo run --release --manifest-path $(VALIDATOR_DIR)/Cargo.toml -- $(if $(SEED),--seed $(SEED))

validate-long-custom:
	cargo run --release --manifest-path $(VALIDATOR_DIR)/Cargo.toml -- --long-only --num-programs $(NUM) --program-length $(LEN) $(if $(SEED),--seed $(SEED)) $(if $(VERBOSE),--verbose)

validate-help:
	cargo run --release --manifest-path $(VALIDATOR_DIR)/Cargo.toml -- --help


# make validate
# make validate-verbose
# make validate-long
# make validate-long-verbose
# make validate-seed SEED=42
# make validate-long-custom NUM=100 LEN=1000 VERBOSE=1 SEED=42
