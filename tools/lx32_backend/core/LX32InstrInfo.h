//===-- LX32InstrInfo.h - LX32 Instruction Info Interface ----------------===//
//
// Part of the LX32 Project
// SPDX-License-Identifier: MIT
//
//===----------------------------------------------------------------------===//
//
// This file defines the target-specific MachineInstr helper interface for LX32.
// It is organized into the following sections:
//
//   Section 0 — LX32InstrInfo declaration
//   Section 1 — Construction hook for subtarget-bound instruction services
//
//===----------------------------------------------------------------------===//

#ifndef LX32_LX32INSTRINFO_H
#define LX32_LX32INSTRINFO_H
class LX32InstrInfo : public LX32GenInstrInfo {
public:
    // Construct instruction helper services for the selected subtarget.
    explicit LX32InstrInfo(LX32Subtarget &STI);
};

#endif // LX32_LX32INSTRINFO_H
