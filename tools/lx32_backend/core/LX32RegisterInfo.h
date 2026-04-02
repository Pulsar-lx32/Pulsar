//===-- LX32RegisterInfo.h - LX32 Register Info Interface ----------------===//
//
// Part of the LX32 Project
// SPDX-License-Identifier: MIT
//
//===----------------------------------------------------------------------===//
//
// This file defines runtime register-management hooks for the LX32 backend.
// It is organized into the following sections:
//
//   Section 0 — LX32RegisterInfo declaration
//   Section 1 — ABI and frame-index hooks required by register allocation
//
//===----------------------------------------------------------------------===//

#ifndef LX32_LX32REGISTERINFO_H
#define LX32_LX32REGISTERINFO_H

class LX32RegisterInfo : public LX32GenRegisterInfo {
public:
    LX32RegisterInfo(unsigned HwMode);

    // Return the ABI callee-saved list for the current function.
    const MCPhysReg *getCalleeSavedRegs(const MachineFunction*) const override;

    // Mark registers that must never be allocated by the generic RA.
    BitVector getReservedRegs(const MachineFunction&) const override;

    // Replace abstract frame-index operands with concrete base+offset forms.
    bool eliminateFrameIndex(MachineBasicBlock::iterator, int,
                             unsigned, RegScavenger*) const override;

    // Return the active frame register (sp or fp).
    Register getFrameRegister(const MachineFunction&) const override;
};

#endif // LX32_LX32REGISTERINFO_H
