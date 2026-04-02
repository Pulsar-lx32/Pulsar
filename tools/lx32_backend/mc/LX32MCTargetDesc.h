//===-- LX32MCTargetDesc.h - LX32 MC Target Description ------------------===//
//
// Part of the LX32 Project
// SPDX-License-Identifier: MIT
//
//===----------------------------------------------------------------------===//
//
// This file declares LX32 MC target-description forward declarations.
// It is organized into the following sections:
//
//   Section 0 — Required LLVM includes
//   Section 1 — Forward declarations used by MC factories
//
//===----------------------------------------------------------------------===//
#ifndef LLVM_LIB_TARGET_LX32_MCTARGETDESC_LX32MCTARGETDESC_H
#define LLVM_LIB_TARGET_LX32_MCTARGETDESC_LX32MCTARGETDESC_H

#include "llvm/MC/MCTargetOptions.h"
#include "llvm/Support/DataTypes.h"
#include <memory>
namespace llvm {

    //===------------------------------------------------------------------===//
    // Section 1 — Forward declarations used by MC factories
    //===------------------------------------------------------------------===//

    class MCAsmBackend;
    class MCCodeEmitter;
    class MCContext;
    class MCInstrInfo;
    class MCObjectTargetWriter;
    class MCRegisterInfo;
    class MCRelocationInfo;
    class MCSubtargetInfo;
    class Target;
}

#endif // LLVM_LIB_TARGET_LX32_MCTARGETDESC_LX32MCTARGETDESC_H
