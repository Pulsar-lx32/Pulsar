//===-- LX32.td - Describe the LX32 Target Machine ---------*- tablegen -*-===//
//
// Part of the LX32 Project
// SPDX-License-Identifier: MIT
//
//===----------------------------------------------------------------------===//
//
// This is the top-level TableGen file for the LX32 architecture. It bundles
// together register info, instruction formats, and instruction definitions.
//
//===----------------------------------------------------------------------===//

include "llvm/Target/Target.td"

//===----------------------------------------------------------------------===//
// Target-specific Hierarchy Includes
//===----------------------------------------------------------------------===//

include "LX32RegisterInfo.td"
include "LX32InstrFormats.td"
include "LX32InstrInfo.td"
include "LX32CallingConv.td"

//===----------------------------------------------------------------------===//
// Instruction Set and Target Definitions
//===----------------------------------------------------------------------===//

/// The InstrInfo class represents the target's instruction set properties.
def LX32InstrInfo : InstrInfo {
  /// guessInstructionProperties = 0 tells TableGen NOT to guess side effects.
  /// This forces us to be explicit and professional with our definitions.
  let guessInstructionProperties = 0;
}

defm : RemapAllTargetPseudoPointerOperands<GPR>;

/// This is the primary target definition. It ties everything together.
def LX32 : Target {
  /// InstructionSet points to our instruction set metadata.
  let InstructionSet = LX32InstrInfo;
  let AllowRegisterRenaming = 1;
}
