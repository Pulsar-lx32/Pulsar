//===-- LX32Subtarget.cpp - LX32 Subtarget Implementation ----------------===//
//
// Part of the LX32 Project
// SPDX-License-Identifier: MIT
//
//===----------------------------------------------------------------------===//
//
// This file implements LX32Subtarget using TableGen-generated subtarget data.
// It is organized into the following sections:
//
//   Section 0 — Generated subtarget constructors and feature parser
//   Section 1 — LX32Subtarget constructor
//
//===----------------------------------------------------------------------===//

#include "LX32Subtarget.h"
#include "LX32TargetMachine.h" // for the TM parameter type

#include "llvm/Support/Debug.h"

// The TableGen generated feature parser uses LLVM_DEBUG(), which requires
// DEBUG_TYPE to be defined before including the generated implementation.
#define DEBUG_TYPE "lx32-subtarget"

//===----------------------------------------------------------------------===//
// Section 0 — Generated subtarget constructors and feature parser
//===----------------------------------------------------------------------===//

// Emit LX32GenSubtargetInfo constructor + resolveSchedClass bodies AND the
// LX32Subtarget::ParseSubtargetFeatures body.
#define GET_SUBTARGETINFO_CTOR
#define GET_SUBTARGETINFO_TARGET_DESC
#include "../TableGen/LX32GenSubtargetInfo.inc"

namespace llvm {

//===----------------------------------------------------------------------===//
// Section 1 — LX32Subtarget constructor
//===----------------------------------------------------------------------===//

LX32Subtarget::LX32Subtarget(const Triple &TT, StringRef CPU,
                              StringRef TuneCPU, StringRef FS,
                              const LX32TargetMachine &TM)
    // Delegate to the TableGen-generated base constructor.
    // It passes the real scheduling tables to TargetSubtargetInfo — no more
    // empty-array construction that suppresses the processor-name lookup.
    : LX32GenSubtargetInfo(TT, CPU, TuneCPU, FS)
{
  (void)TM; // TM will be used when ISelLowering / FrameLowering are added.

  // Normalise CPU so the generated lookup doesn't warn about "generic".
  // LX32Processors.td defines "generic-lx32" as the canonical name.
  StringRef NormCPU = CPU.empty() ? "generic-lx32" : CPU;

  // Wire up feature bits. For the current ISA (no optional extensions) this
  // call is a no-op, but the plumbing must be present for when we add them.
  ParseSubtargetFeatures(NormCPU, TuneCPU.empty() ? NormCPU : TuneCPU, FS);
}

} // namespace llvm
