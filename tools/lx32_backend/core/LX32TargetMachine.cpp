//===-- LX32TargetMachine.cpp - LX32 TargetMachine Implementation --------===//
//
// Part of the LX32 Project
// SPDX-License-Identifier: MIT
//
//===----------------------------------------------------------------------===//
//
// This file defines the LX32 TargetMachine runtime behavior.
// It is organized into the following sections:
//
//   Section 0 — Includes and shared helpers
//   Section 1 — Data layout and relocation policy
//   Section 2 — PassConfig bootstrap
//   Section 3 — LX32TargetMachine methods
//   Section 4 — Target registration entry point
//
//===----------------------------------------------------------------------===//

#include "LX32TargetMachine.h"

#include "../target/TargetInfo/LX32TargetInfo.h"

#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/CodeGen.h"
#include "llvm/Support/ErrorHandling.h"

using namespace llvm;

extern "C" LLVM_ABI LLVM_EXTERNAL_VISIBILITY void LLVMInitializeLX32TargetMC();

//===----------------------------------------------------------------------===//
// Section 1 — Data layout and relocation policy
//===----------------------------------------------------------------------===//
// Keep this stable and simple. It matches the project notes:
//  - little-endian
//  - ELF mangling
//  - 32-bit pointers
//  - i64 aligned to 64 (ABI requirement)
//  - native integer width 32
//  - minimum stack alignment 32
static constexpr const char *LX32DataLayout = "e-m:e-p:32:32-i64:64-n32-S32";

static Reloc::Model
getEffectiveRelocModel(std::optional<Reloc::Model> RM) {
  // lx32 v1: static only. PIC needs GOT/PLT which we don't have yet.
  return RM.value_or(Reloc::Static);
}

namespace {

//===----------------------------------------------------------------------===//
// Section 2 — PassConfig bootstrap
//===----------------------------------------------------------------------===//

class LX32PassConfig final : public TargetPassConfig {
public:
  LX32PassConfig(LX32TargetMachine &TM, PassManagerBase &PM)
	  : TargetPassConfig(TM, PM) {}

  LX32TargetMachine &getLX32TargetMachine() const {
	return getTM<LX32TargetMachine>();
  }

  // The instruction selector will be added later.
  // For now we install the minimum required to keep llc from crashing.
  bool addInstSelector() override {
	// If we return true, LLVM believes selection has been added.
	// We want a *clean* failure later (e.g. legalizer/isel missing), not an
	// implicit null deref, so we do not add any custom passes here.
	return false;
  }
};

} // end anonymous namespace

namespace llvm {

//===----------------------------------------------------------------------===//
// Section 3 — LX32TargetMachine methods
//===----------------------------------------------------------------------===//

LX32TargetMachine::LX32TargetMachine(
	const Target &T, const Triple &TT, StringRef CPU, StringRef FS,
	const TargetOptions &Options, std::optional<Reloc::Model> RM,
    std::optional<CodeModel::Model> CM, CodeGenOptLevel OL, bool JIT)
	: CodeGenTargetMachineImpl(T, /*DataLayoutString=*/LX32DataLayout, TT, CPU,
							   FS, Options, getEffectiveRelocModel(RM),
							   CM.value_or(CodeModel::Small), OL),
	  TLOF(std::make_unique<TargetLoweringObjectFileELF>()) {
  (void)JIT;
  // Required by CodeGenTargetMachineImpl: populate MCAsmInfo/MC* descriptors
  // from TargetRegistry before pass pipeline construction.
  initAsmInfo();
  // NOTE:
  //   Some LLVM versions expose an explicit initialization helper for object
  //   file lowering, others initialize lazily. For the current skeleton backend
  //   (text asm output only), it's enough to keep a valid TLOF instance and
  //   return it from getObjFileLowering().
}

LX32TargetMachine::~LX32TargetMachine() = default;

const LX32Subtarget *
LX32TargetMachine::getSubtargetImpl(const Function &F) const {
  // Each function may override CPU/features via attributes.
  Attribute CPUAttr = F.getFnAttribute("target-cpu");
  Attribute FSAttr = F.getFnAttribute("target-features");

  std::string CPU = CPUAttr.isValid() ? CPUAttr.getValueAsString().str()
                                      : TargetCPU;
  std::string FS = FSAttr.isValid() ? FSAttr.getValueAsString().str()
                                    : TargetFS;

  // Keep a very small key; CPU+FS is enough for the cache.
  std::string Key = CPU + FS;

  auto &Entry = SubtargetMap[Key];
  if (!Entry) {
	// Normalise CPU to avoid the "generic" warning. The MC layer already uses
	// "generic-lx32" as canonical; we mirror that behaviour here.
	if (CPU.empty())
	  CPU = "generic-lx32";
	Entry = std::make_unique<LX32Subtarget>(TargetTriple, CPU, /*TuneCPU=*/CPU,
										   FS, *this);
  }
  return Entry.get();
}

TargetPassConfig *LX32TargetMachine::createPassConfig(PassManagerBase &PM) {
  return new LX32PassConfig(*this, PM);
}

extern "C" LLVM_ABI LLVM_EXTERNAL_VISIBILITY void LLVMInitializeLX32Target() {
  //===--------------------------------------------------------------------===//
  // Section 4 — Target registration entry point
  //===--------------------------------------------------------------------===//
  // Register LX32TargetMachine in the same library clang already links
  // (LLVMLX32CodeGen), so the symbol is always available.
  //
  // Also make sure MC-layer factories are registered before the first
  // TargetMachine instance is created; otherwise llc can assert with
  // "No MCAsmInfo" while building the pass pipeline.
  LLVMInitializeLX32TargetMC();
  RegisterTargetMachine<LX32TargetMachine> X(getTheLX32TargetInfo());
}

} // namespace llvm



