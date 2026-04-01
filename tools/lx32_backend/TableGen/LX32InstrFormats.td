//===----------------------------------------------------------------------===//
// LX32 32-bit Instruction Format Definitions
//
// Part of the LX32 Project
// SPDX-License-Identifier: MIT
//===----------------------------------------------------------------------===//

// -----------------------------------------------------------------------------
// Minimal field mixins (pure encoding layer, single source of truth)
// -----------------------------------------------------------------------------

/// Destination register field.
class LXInstRD { bits<5> rd; }

/// Source register 1 field.
class LXInstRS1 { bits<5> rs1; }

/// Source register 2 field.
class LXInstRS2 { bits<5> rs2; }

/// Both source registers (composed).
class LXInstRS1_RS2 : LXInstRS1, LXInstRS2 {}

/// funct3 field.
class LXInstFunct3<bits<3> funct3_val> {
  bits<3> funct3 = funct3_val;
}

/// Immediate field, 12 bits. Value is sign-extended.
class LXImm12  { bits<12> imm12; } // sign-extended

/// Immediate field, 13 bits (B-type branches).
/// Represents bits [12:1] (bit 0 is implicit zero). Value is sign-extended.
class LXImm13  { bits<13> imm13; } // sign-extended, [12:1], LSB implicit zero

/// Immediate field, 20 bits. Used in U-type and sign-extended.
class LXImm20  { bits<20> imm20; } // sign-extended

/// Immediate field, 21 bits (J-type jumps).
/// Represents bits [20:1] (bit 0 is implicit zero). Value is sign-extended.
class LXImm21  { bits<21> imm21; } // sign-extended, [20:1], LSB implicit zero

// -----------------------------------------------------------------------------
// Opcode descriptor
// -----------------------------------------------------------------------------
class LX32Opcode<string name, bits<7> val> {
  string Name           = name;
  bits<7>  Val          = val;
}

// -----------------------------------------------------------------------------
// Instruction semantic/meta-properties
// -----------------------------------------------------------------------------

/// Base for all LX32 instructions: syntax, operands and semantic attributes.
class LXInstCommon<dag outs, dag ins, string opcodestr, string argstr> : Instruction {
  let Namespace      = "LX32";
  field bits<32> Inst;
  let Size = 4;
  dag OutOperandList = outs;
  dag InOperandList  = ins;
  let AsmString      = !if(!empty(argstr), opcodestr # "\t" # argstr, opcodestr);
}

/// Main encoding base for all LX32 instructions.
class LXInst<LX32Opcode opcode, dag outs, dag ins, string opcodestr, string argstr> :
  LXInstCommon<outs, ins, opcodestr, argstr> {
  let Inst{6-0} = opcode.Val;
}

// -----------------------------------------------------------------------------
// Unified semantic operand helpers
// -----------------------------------------------------------------------------

// General-purpose register default types
def LX32GPROut : RegisterOperand<GPR>;
def LX32GPRIn  : RegisterOperand<GPR>;
def LX32GPRNOX0Out : RegisterOperand<GPRNOX0>;

// -----------------------------------------------------------------------------
// Instruction formats: field composition, semantics, and meta-attributes
// -----------------------------------------------------------------------------

/// R-Type: Register-register format (rd, rs1, rs2, funct3, funct7).
class LXInstRBase<bits<3> funct3, LX32Opcode opcode, dag outs, dag ins, string opcodestr, string argstr> :
  LXInst<opcode, outs, ins, opcodestr, argstr>,
  LXInstRD, LXInstRS1_RS2, LXInstFunct3<funct3> {
  let Inst{11-7}  = rd;
  let Inst{19-15} = rs1;
  let Inst{24-20} = rs2;
  let Inst{14-12} = funct3;
}

class LXInstR<bits<7> funct7, bits<3> funct3, LX32Opcode opcode,
              dag outs, dag ins, string opcodestr, string argstr> :
  LXInstRBase<funct3, opcode, outs, ins, opcodestr, argstr> {
  let Inst{31-25} = funct7;
  // Example: No extra default attributes, semantic properties go in pattern defs.
}

/// I-Type: Register-immediate and loads (rd, rs1, funct3, imm12).
class LXInstIBase<bits<3> funct3, LX32Opcode opcode,
                  dag outs, dag ins, string opcodestr, string argstr> :
  LXInst<opcode, outs, ins, opcodestr, argstr>,
  LXInstRD, LXInstRS1, LXInstFunct3<funct3>, LXImm12 {
  let Inst{11-7}  = rd;
  let Inst{19-15} = rs1;
  let Inst{14-12} = funct3;
  let Inst{31-20} = imm12;
}

class LXInstI<bits<3> funct3, LX32Opcode opcode,
              dag outs, dag ins, string opcodestr, string argstr> :
  LXInstIBase<funct3, opcode, outs, ins, opcodestr, argstr> {
  // let mayLoad = 1; // For loads: set this attribute in instruction defs as needed.
}

/// S-Type: Store format (rs1, rs2, funct3, imm12).
class LXInstMemBase<bits<3> funct3, LX32Opcode opcode,
                    dag outs, dag ins, string opcodestr, string argstr> :
  LXInst<opcode, outs, ins, opcodestr, argstr>,
  LXInstRS1_RS2, LXInstFunct3<funct3>, LXImm12 {
  let Inst{19-15} = rs1;
  let Inst{24-20} = rs2;
  let Inst{14-12} = funct3;
  let Inst{31-25} = imm12{11-5};
  let Inst{11-7}  = imm12{4-0};
}

class LXInstS<bits<3> funct3, LX32Opcode opcode,
              dag outs, dag ins, string opcodestr, string argstr> :
  LXInstMemBase<funct3, opcode, outs, ins, opcodestr, argstr> {
  let mayStore = 1;
  let hasSideEffects = 1;
}

/// B-Type: Conditional branches (rs1, rs2, funct3, imm13).
/// imm13 models bits [12:1]—bit 0 is always zero and not encoded.
/// Logical immediate is sign-extended and shifted left by 1.
/// Encoding: imm[12|10:5|4:1|11] → Inst[31|30:25|24:20|19:15|14:12|11:8|7]
class LXInstBBase<bits<3> funct3, LX32Opcode opcode,
                  dag outs, dag ins, string opcodestr, string argstr> :
  LXInst<opcode, outs, ins, opcodestr, argstr>,
  LXInstRS1_RS2, LXInstFunct3<funct3>, LXImm13 {
  let Inst{19-15} = rs1;
  let Inst{24-20} = rs2;
  let Inst{14-12} = funct3;
  let Inst{31}     = imm13{12};
  let Inst{30-25}  = imm13{10-5};
  let Inst{11-8}   = imm13{4-1};
  let Inst{7}      = imm13{11};
}

class LXInstB<bits<3> funct3, LX32Opcode opcode,
              dag outs, dag ins, string opcodestr, string argstr> :
  LXInstBBase<funct3, opcode, outs, ins, opcodestr, argstr> {
  let isBranch = 1;
  let hasSideEffects = 1;
  let isTerminator = 1;
  // TSFlags fields can encode target-specific classification if needed.
}

/// U-Type: Upper immediate format (rd, imm20).
class LXInstUBase<LX32Opcode opcode,
                  dag outs, dag ins, string opcodestr, string argstr> :
  LXInst<opcode, outs, ins, opcodestr, argstr>, LXInstRD, LXImm20 {
  let Inst{11-7}  = rd;
  let Inst{31-12} = imm20;
}

class LXInstU<LX32Opcode opcode, dag outs, dag ins, string opcodestr, string argstr> :
  LXInstUBase<opcode, outs, ins, opcodestr, argstr> {}

/// J-Type: Unconditional jump (rd, imm21).
/// imm21 models bits [20:1]. Bit 0 is always zero and not encoded.
/// Logical immediate is sign-extended and shifted left by 1.
/// Encoding: imm[20|10:1|11|19:12] → Inst[31|30:21|20|19:12|11:7]
class LXInstJBase<LX32Opcode opcode,
                  dag outs, dag ins, string opcodestr, string argstr> :
  LXInst<opcode, outs, ins, opcodestr, argstr>, LXInstRD, LXImm21 {
  let Inst{11-7}  = rd;
  let Inst{31}     = imm21{20};
  let Inst{30-21}  = imm21{10-1};
  let Inst{20}     = imm21{11};
  let Inst{19-12}  = imm21{19-12};
}

class LXInstJ<LX32Opcode opcode, dag outs, dag ins, string opcodestr, string argstr> :
  LXInstJBase<opcode, outs, ins, opcodestr, argstr> {
  let isBranch = 1;
  let hasSideEffects = 1;
  let isTerminator = 1;
}