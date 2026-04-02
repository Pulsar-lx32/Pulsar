//===-- LX32TargetMachine.h - LX32 TargetMachine Declaration -------------===//
//
// Part of the LX32 Project
// SPDX-License-Identifier: MIT
//
//===----------------------------------------------------------------------===//
//
// This file defines the LX32 TargetMachine interface.
// It is organized into the following sections:
//
//   Section 0 — Includes and forward dependencies
//   Section 1 — LX32TargetMachine declaration
//   Section 2 — Public target hooks used by LLVM codegen
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LX32_CORE_LX32TARGETMACHINE_H
#define LLVM_LIB_TARGET_LX32_CORE_LX32TARGETMACHINE_H

#include "LX32Subtarget.h"

#include "llvm/ADT/StringMap.h"
#include "llvm/CodeGen/CodeGenTargetMachineImpl.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/IR/Function.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetOptions.h"
#include "llvm/TargetParser/Triple.h"

#include <memory>
#include <optional>

namespace llvm {

//===----------------------------------------------------------------------===//
// Section 1 — LX32TargetMachine declaration
//===----------------------------------------------------------------------===//

class LX32TargetMachine final : public CodeGenTargetMachineImpl {
  // Object file lowering. Even as a stub we keep the ownership here so
  // LLVM can query it without needing target hooks.
  std::unique_ptr<TargetLoweringObjectFile> TLOF;

  // Subtarget cache keyed by (CPU + FS). This matches the common LLVM pattern
  // and avoids rebuilding subtargets when different functions reuse the same
  // attributes.
  mutable StringMap<std::unique_ptr<LX32Subtarget>> SubtargetMap;

public:
  //===--------------------------------------------------------------------===//
  // Section 2 — Construction and target hooks
  //===--------------------------------------------------------------------===//

  LX32TargetMachine(const Target &T, const Triple &TT, StringRef CPU,
					StringRef FS, const TargetOptions &Options,
					std::optional<Reloc::Model> RM,
          std::optional<CodeModel::Model> CM, CodeGenOptLevel OL,
          bool JIT);

  ~LX32TargetMachine() override;

  const LX32Subtarget *getSubtargetImpl(const Function &F) const override;
  TargetPassConfig *createPassConfig(PassManagerBase &PM) override;

  TargetLoweringObjectFile *getObjFileLowering() const override {
	return TLOF.get();
  }
};

} // namespace llvm

#endif // LLVM_LIB_TARGET_LX32_CORE_LX32TARGETMACHINE_H
