# core/CMakeLists.txt
#
# CodeGen layer for LX32.
# Keep it minimal: just enough for llc to construct a TargetMachine and
# run a pipeline without crashing.

add_llvm_component_library(LLVMLX32CodeGen
  LX32Subtarget.cpp
  LX32TargetMachine.cpp

  LINK_COMPONENTS
  CodeGen
  Core
  MC
  SelectionDAG
  Support
  Target

  ADD_TO_COMPONENT
  LX32
)

