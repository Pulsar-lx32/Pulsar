//===-- LX32FrameLowering.h - LX32 Frame Lowering Interface --------------===//
//
// Part of the LX32 Project
// SPDX-License-Identifier: MIT
//
//===----------------------------------------------------------------------===//
//
// This file defines the frame-lowering interface for the LX32 backend.
// It is organized into the following sections:
//
//   Section 0 — LX32FrameLowering declaration
//   Section 1 — Stub hooks for prologue/epilogue and base-pointer policy
//
//===----------------------------------------------------------------------===//

#ifndef LX32_LX32FRAMELOWERING_H
#define LX32_LX32FRAMELOWERING_H

class LX32FrameLowering : public TargetFrameLowering {
public:
    // Construct frame-lowering policy for a specific subtarget instance.
    explicit LX32FrameLowering(const llvm::LX32Subtarget &STI);

    // Stubs in skeleton mode; real prologue/epilogue emission is implemented
    // in the frame-lowering roadmap phase.
    void emitPrologue(MachineFunction&, MachineBasicBlock&) const override {}
    void emitEpilogue(MachineFunction&, MachineBasicBlock&) const override {}

    // LX32 v1 does not use a dedicated base pointer.
    bool hasBP(const MachineFunction&) const override { return false; }
};


#endif // LX32_LX32FRAMELOWERING_H
