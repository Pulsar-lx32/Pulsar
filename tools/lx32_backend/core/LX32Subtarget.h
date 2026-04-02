//===-- LX32Subtarget.h - LX32 Subtarget Declaration ---------------------===//
//
// Part of the LX32 Project
// SPDX-License-Identifier: MIT
//
//===----------------------------------------------------------------------===//
//
// This file defines the LX32 subtarget wrapper used by LLVM codegen.
// It is organized into the following sections:
//
//   Section 0 — TableGen subtarget header import
//   Section 1 — LX32Subtarget declaration and feature parser contract
//   Section 2 — Required TargetSubtargetInfo hooks (stub mode)
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LX32_CORE_LX32SUBTARGET_H
#define LLVM_LIB_TARGET_LX32_CORE_LX32SUBTARGET_H

#include "llvm/ADT/StringRef.h"

// Pull in the TableGen-generated LX32GenSubtargetInfo class declaration.
// The macro guard selects only the "HEADER" section of the .inc file,
// which declares the class without defining any bodies.
//
//===----------------------------------------------------------------------===//
// Section 0 — TableGen subtarget header import
//===----------------------------------------------------------------------===//
#define GET_SUBTARGETINFO_HEADER
#include "../TableGen/LX32GenSubtargetInfo.inc"

namespace llvm {

class Triple;
class LX32TargetMachine;

//===----------------------------------------------------------------------===//
// Section 1 — LX32Subtarget declaration
//===----------------------------------------------------------------------===//

class LX32Subtarget : public LX32GenSubtargetInfo {
public:
  LX32Subtarget(const Triple &TT, StringRef CPU, StringRef TuneCPU,
                StringRef FS, const LX32TargetMachine &TM);

  // TableGen emits an out-of-line definition for LX32Subtarget::
  // ParseSubtargetFeatures(...) when GET_SUBTARGETINFO_TARGET_DESC is
  // enabled. C++ still requires a matching declaration in this class.
  //
  // We intentionally do not implement this ourselves; the generated body
  // is the source of truth.
  void ParseSubtargetFeatures(StringRef CPU, StringRef TuneCPU, StringRef FS);

  //===--------------------------------------------------------------------===//
  // Section 2 — Required TargetSubtargetInfo hooks (stub mode)
  //===--------------------------------------------------------------------===//

  // Required TargetSubtargetInfo hooks.
  // Return nullptr until register/info/frame components are fully wired.
  const TargetRegisterInfo *getRegisterInfo() const override { return nullptr; }
  const TargetInstrInfo *getInstrInfo() const override { return nullptr; }
  const TargetFrameLowering *getFrameLowering() const override {
    return nullptr;
  }
};

} // namespace llvm

#endif // LLVM_LIB_TARGET_LX32_CORE_LX32SUBTARGET_H
