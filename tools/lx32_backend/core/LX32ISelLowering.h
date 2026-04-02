//===-- LX32ISelLowering.h - LX32 SelectionDAG Lowering Interface --------===//
//
// Part of the LX32 Project
// SPDX-License-Identifier: MIT
//
//===----------------------------------------------------------------------===//
//
// This file defines SelectionDAG lowering policy interfaces for LX32.
// It is organized into the following sections:
//
//   Section 0 — LX32TargetLowering declaration
//   Section 1 — Constructor hook for target/subtarget lowering policy
//
//===----------------------------------------------------------------------===//

#ifndef LX32_LX32ISELLOWERING_H
#define LX32_LX32ISELLOWERING_H
class LX32TargetLowering : public TargetLowering {
public:
    // Build lowering policy for a specific target machine + subtarget pair.
    LX32TargetLowering(const TargetMachine&, const LX32Subtarget&);
};

#endif // LX32_LX32ISELLOWERING_H
