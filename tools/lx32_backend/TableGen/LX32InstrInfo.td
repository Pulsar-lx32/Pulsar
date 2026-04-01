//===-- LX32InstrInfo.td - LX32 Instruction Definitions --------*- tablegen -*-===//
//
// Part of the LX32 Project
// SPDX-License-Identifier: MIT
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Section 0 — Helpers: Custom SDNodes and Pattern Fragments
//===----------------------------------------------------------------------===//

def LX32ret : SDNode<"LX32ISD::RET", SDTNone, [SDNPHasChain, SDNPOptInGlue, SDNPVariadic]>;

def lx32_lh  : PatFrag<(ops node:$ptr), (i32 (sextloadi16 node:$ptr))>;
def lx32_lhu : PatFrag<(ops node:$ptr), (i32 (zextloadi16 node:$ptr))>;
def lx32_lb  : PatFrag<(ops node:$ptr), (i32 (sextloadi8 node:$ptr))>;
def lx32_lbu : PatFrag<(ops node:$ptr), (i32 (zextloadi8 node:$ptr))>;
def lx32_sh  : PatFrag<(ops node:$src, node:$base, node:$off), (truncstorei16 node:$src, (add node:$base, node:$off))>;
def lx32_sb  : PatFrag<(ops node:$src, node:$base, node:$off), (truncstorei8 node:$src, (add node:$base, node:$off))>;

//===----------------------------------------------------------------------===//
// Section 0.5 — Operand Transformers
//===----------------------------------------------------------------------===//

def HI20 : SDNodeXForm<imm, [{
  return CurDAG->getTargetConstant(((uint64_t)N->getZExtValue() + 0x800) >> 12, SDLoc(N), MVT::i32);
}]>;
def LO12 : SDNodeXForm<imm, [{
  return CurDAG->getTargetConstant(N->getZExtValue() & 0xfff, SDLoc(N), MVT::i32);
}]>;

//===----------------------------------------------------------------------===//
// Section 1 — Operand Definitions
//===----------------------------------------------------------------------===//

def bare_symbol : Operand<i32>;
def simm12 : Operand<i32>     { let EncoderMethod = "getImmOpValue"; }
def uimm5  : Operand<i32>     { let EncoderMethod = "getImmOpValue"; }
def uimm12 : Operand<i32>     { let EncoderMethod = "getImmOpValue"; }
def uimm20 : Operand<i32>     { let EncoderMethod = "getImmOpValue"; }
def simm13 : Operand<OtherVT> { let EncoderMethod = "getBranchTargetOpValue"; }
def simm21 : Operand<OtherVT> { let EncoderMethod = "getJumpTargetOpValue"; }

// Pattern Leaves for Selection (Crucial to prevent TableGen crash)
def imm12 : PatLeaf<(i32 imm), [{ return isInt<12>(N->getSExtValue()); }]>;
def imm5  : PatLeaf<(i32 imm), [{ return isUInt<5>(N->getZExtValue()); }]>;

//===----------------------------------------------------------------------===//
// Section 2 — Opcode Map
//===----------------------------------------------------------------------===//

def OPC_LOAD   : LX32Opcode<"load",   0b0000011>;
def OPC_STORE  : LX32Opcode<"store",  0b0100011>;
def OPC_BRANCH : LX32Opcode<"branch", 0b1100011>;
def OPC_JAL    : LX32Opcode<"jal",    0b1101111>;
def OPC_JALR   : LX32Opcode<"jalr",   0b1100111>;
def OPC_LUI    : LX32Opcode<"lui",    0b0110111>;
def OPC_AUIPC  : LX32Opcode<"auipc",  0b0010111>;
def OPC_IMM    : LX32Opcode<"imm",    0b0010011>;
def OPC_ARITH  : LX32Opcode<"arith",  0b0110011>;
def OPC_SYSTEM : LX32Opcode<"system", 0b1110011>;

//===----------------------------------------------------------------------===//
// Section 3 — R-Type Instructions
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
class ALU_R_Pat<bits<7> f7, bits<3> f3, string op, list<dag> pat>
  : LXInstR<f7, f3, OPC_ARITH, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2), op, "$rd, $rs1, $rs2"> {
  let Pattern = pat;
}

def ADD  : ALU_R_Pat<0b0000000, 0b000, "add",  [(set GPR:$rd, (add GPR:$rs1, GPR:$rs2))]>;
def SUB  : ALU_R_Pat<0b0100000, 0b000, "sub",  [(set GPR:$rd, (sub GPR:$rs1, GPR:$rs2))]>;
def SLL  : ALU_R_Pat<0b0000000, 0b001, "sll",  [(set GPR:$rd, (shl GPR:$rs1, GPR:$rs2))]>;
def SLT  : ALU_R_Pat<0b0000000, 0b010, "slt",  [(set GPR:$rd, (setlt GPR:$rs1, GPR:$rs2))]>;
def SLTU : ALU_R_Pat<0b0000000, 0b011, "sltu", [(set GPR:$rd, (setult GPR:$rs1, GPR:$rs2))]>;
def XOR  : ALU_R_Pat<0b0000000, 0b100, "xor",  [(set GPR:$rd, (xor GPR:$rs1, GPR:$rs2))]>;
def SRL  : ALU_R_Pat<0b0000000, 0b101, "srl",  [(set GPR:$rd, (srl GPR:$rs1, GPR:$rs2))]>;
def SRA  : ALU_R_Pat<0b0100000, 0b101, "sra",  [(set GPR:$rd, (sra GPR:$rs1, GPR:$rs2))]>;
def OR   : ALU_R_Pat<0b0000000, 0b110, "or",   [(set GPR:$rd, (or GPR:$rs1, GPR:$rs2))]>;
def AND  : ALU_R_Pat<0b0000000, 0b111, "and",  [(set GPR:$rd, (and GPR:$rs1, GPR:$rs2))]>;
}

//===----------------------------------------------------------------------===//
// Section 4 — I-Type Instructions
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
class ALU_I_Pat<bits<3> f3, string op, list<dag> pat>
  : LXInstI<f3, OPC_IMM, (outs GPR:$rd), (ins GPR:$rs1, simm12:$imm12), op, "$rd, $rs1, $imm12"> {
  let Pattern = pat;
}

def ADDI  : ALU_I_Pat<0b000, "addi",  [(set GPR:$rd, (add GPR:$rs1, imm12:$imm12))]>;
def SLTI  : ALU_I_Pat<0b010, "slti",  [(set GPR:$rd, (setlt GPR:$rs1, imm12:$imm12))]>;
def SLTIU : ALU_I_Pat<0b011, "sltiu", [(set GPR:$rd, (setult GPR:$rs1, imm12:$imm12))]>;
def XORI  : ALU_I_Pat<0b100, "xori",  [(set GPR:$rd, (xor GPR:$rs1, imm12:$imm12))]>;
def ORI   : ALU_I_Pat<0b110, "ori",   [(set GPR:$rd, (or GPR:$rs1, imm12:$imm12))]>;
def ANDI  : ALU_I_Pat<0b111, "andi",  [(set GPR:$rd, (and GPR:$rs1, imm12:$imm12))]>;

// Shifts use imm5 instead of the raw uimm5 operand in Patterns to avoid crash
def SLLI : LXInstI<0b001, OPC_IMM, (outs GPR:$rd), (ins GPR:$rs1, uimm5:$imm12), "slli", "$rd, $rs1, $imm12">
           { let Pattern = [(set GPR:$rd, (shl GPR:$rs1, imm5:$imm12))]; let imm12{11-5} = 0b0000000; }
def SRLI : LXInstI<0b101, OPC_IMM, (outs GPR:$rd), (ins GPR:$rs1, uimm5:$imm12), "srli", "$rd, $rs1, $imm12">
           { let Pattern = [(set GPR:$rd, (srl GPR:$rs1, imm5:$imm12))]; let imm12{11-5} = 0b0000000; }
def SRAI : LXInstI<0b101, OPC_IMM, (outs GPR:$rd), (ins GPR:$rs1, uimm5:$imm12), "srai", "$rd, $rs1, $imm12">
           { let Pattern = [(set GPR:$rd, (sra GPR:$rs1, imm5:$imm12))]; let imm12{11-5} = 0b0100000; }
}

//===----------------------------------------------------------------------===//
// Section 5 — Load Instructions
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 1, mayStore = 0 in {
class Load_Pat<bits<3> f3, string op, list<dag> pat>
  : LXInstI<f3, OPC_LOAD, (outs GPR:$rd), (ins GPR:$rs1, simm12:$imm12), op, "$rd, ${imm12}(${rs1})"> {
  let Pattern = pat;
}

def LW  : Load_Pat<0b010, "lw",  [(set GPR:$rd, (load (add GPR:$rs1, imm12:$imm12)))]>;
def LH  : Load_Pat<0b001, "lh",  [(set GPR:$rd, (lx32_lh (add GPR:$rs1, imm12:$imm12)))]>;
def LHU : Load_Pat<0b101, "lhu", [(set GPR:$rd, (lx32_lhu (add GPR:$rs1, imm12:$imm12)))]>;
def LB  : Load_Pat<0b000, "lb",  [(set GPR:$rd, (lx32_lb (add GPR:$rs1, imm12:$imm12)))]>;
def LBU : Load_Pat<0b100, "lbu", [(set GPR:$rd, (lx32_lbu (add GPR:$rs1, imm12:$imm12)))]>;
}

//===----------------------------------------------------------------------===//
// Section 6 — Store Instructions
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in {
class Store_Pat<bits<3> f3, string op, list<dag> pat>
  : LXInstS<f3, OPC_STORE, (outs), (ins GPR:$rs2, GPR:$rs1, simm12:$imm12), op, "$rs2, ${imm12}(${rs1})"> {
  let Pattern = pat;
}

def SW : Store_Pat<0b010, "sw", [(store GPR:$rs2, (add GPR:$rs1, imm12:$imm12))]>;
def SH : Store_Pat<0b001, "sh", [(lx32_sh GPR:$rs2, GPR:$rs1, imm12:$imm12)]>;
def SB : Store_Pat<0b000, "sb", [(lx32_sb GPR:$rs2, GPR:$rs1, imm12:$imm12)]>;
}

//===----------------------------------------------------------------------===//
// Section 7 — Branch Instructions
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, isTerminator = 1, isBranch = 1 in {
class Branch_B<bits<3> funct3, string opcodestr>
  : LXInstB<funct3, OPC_BRANCH, (outs), (ins GPR:$rs1, GPR:$rs2, simm13:$imm13), opcodestr, "$rs1, $rs2, $imm13">;

def BEQ  : Branch_B<0b000, "beq">;
def BNE  : Branch_B<0b001, "bne">;
def BLT  : Branch_B<0b100, "blt">;
def BGE  : Branch_B<0b101, "bge">;
def BLTU : Branch_B<0b110, "bltu">;
def BGEU : Branch_B<0b111, "bgeu">;
}

//===----------------------------------------------------------------------===//
// Section 8 — Jump Instructions
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 0, mayStore = 0, isTerminator = 1, isBarrier = 1 in {
  def JAL  : LXInstJ<OPC_JAL, (outs GPR:$rd), (ins simm21:$imm21), "jal", "$rd, $imm21"> { let isCall = 1; }
  def JALR : LXInstI<0b000, OPC_JALR, (outs GPR:$rd), (ins GPR:$rs1, simm12:$imm12), "jalr", "$rd, ${imm12}(${rs1})">;
}

//===----------------------------------------------------------------------===//
// Section 9 — Upper Immediate Instructions
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
  def LUI   : LXInstU<OPC_LUI, (outs GPR:$rd), (ins uimm20:$imm20), "lui", "$rd, $imm20">;
  def AUIPC : LXInstU<OPC_AUIPC, (outs GPR:$rd), (ins uimm20:$imm20), "auipc", "$rd, $imm20">;
}

//===----------------------------------------------------------------------===//
// Section 10 — Patterns for constant materialization
//===----------------------------------------------------------------------===//

def : Pat<(i32 imm12:$imm), (ADDI X0, imm12:$imm)>;
def : Pat<(i32 imm:$imm), (ADDI (LUI (HI20 imm:$imm)), (LO12 imm:$imm))>;

//===----------------------------------------------------------------------===//
// Section 11 — Pseudo Instructions
//===----------------------------------------------------------------------===//

class LX32Pseudo<dag outs, dag ins, string opcodestr, list<dag> pattern>
  : LXInstCommon<outs, ins, opcodestr, ""> {
  let isPseudo = 1;
  let Pattern = pattern;
}

let isPseudo = 1, hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
  def PseudoRET : LX32Pseudo<(outs), (ins), "ret", [(LX32ret)]> {
    let isReturn = 1;
    let isTerminator = 1;
    let isBarrier = 1;
    let Uses = [X1];
  }

  def PseudoCALL : LX32Pseudo<(outs), (ins GPRNOX0:$rs1), "call\t$rs1", []> {
    let isCall = 1;
    let Defs = [X1];
    let hasSideEffects = 1;
  }

  def PseudoLA : LX32Pseudo<(outs GPR:$rd), (ins bare_symbol:$addr), "la\t$rd, $addr", []>;
  def PseudoNOP : LX32Pseudo<(outs), (ins), "nop", []>;
}

//===----------------------------------------------------------------------===//
// Section 12 — Standard Pseudo Overrides
//===----------------------------------------------------------------------===//

let isPseudo = 1, isCodeGenOnly = 1, Namespace = "LX32" in {
  def LX32_LOAD_STACK_GUARD : LX32Pseudo<(outs GPR:$dst), (ins), "load_stack_guard", []> {
    let mayLoad = 1;
    let hasSideEffects = 0;
    let mayStore = 0;
  }

  def LX32_PREALLOCATED_ARG : LX32Pseudo<(outs), (ins i32imm:$p), "preallocated_arg", []> {
    let hasSideEffects = 1;
    let mayLoad = 0;
    let mayStore = 0;
  }

  def ADJCALLSTACKDOWN : LX32Pseudo<(outs), (ins i32imm:$amt1, i32imm:$amt2),
                                    "adjcallstackdown", []> {
    let hasSideEffects = 1;
    let mayLoad = 0;
    let mayStore = 0;
  }

  def ADJCALLSTACKUP : LX32Pseudo<(outs), (ins i32imm:$amt1, i32imm:$amt2),
                                  "adjcallstackup", []> {
    let hasSideEffects = 1;
    let mayLoad = 0;
    let mayStore = 0;
  }
}
