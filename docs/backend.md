# Developing Baremetal C Code for LX32

Welcome to the LX32 architecture C development guide! Because LX32 is a custom 32-bit architecture, we rely on a custom LLVM backend to compile our C programs into raw binary machine code that our Verilog/SystemVerilog RTL simulation and formal models can consume.

## Backend Directory Structure

The `tools/lx32_backend/` directory is organized exactly like a standard LLVM backend, to ensure it is extremely modular, clean, and scalable:

*   **`TargetInfo/`**: Registers the LX32 architecture name and triple. 
*   **`core/`**: The main code generator. Handles Register Info, Instruction Info, Frame Lowering, Subtarget features, and Instruction Selection mapping (DAG).
*   **`AsmParser/`**: The component that parses string assembly (`.s`) and maps it into LX32 `MCInst` object representations.
*   **`MCTargetDesc/`**: The Machine Code layer. Emits the final raw binary bits (MCCodeEmitter), Object Files (ELFObjectWriter), and assembly printers.
*   **`TableGen/`**: The `.td` files that declaratively define the LX32 registers, instructions, and calling conventions, generating C++ `.inc` files automatically during the build.
*   **`tests/`**: Contains the compile scripts `compile_baremetal_c.sh` and baremetal C smoke tests.

## Prerequisites

Before you can develop C code for LX32, you need the LX32 LLVM compiler toolchain. The repository automates the entire process of downloading, configuring, and building LLVM with our backend slice cleanly linked into the LLVM tree.

Run the following command from the root of the repository:

```bash
make setup-backend
```

*This will take some time, as it clones LLVM and compiles Clang, LLD (Linker), and the LX32 backend.*

## Writing Your First C Program

Your software will run directly on "bare metal"—there is no operating system, standard library (`libc`), or dynamic memory allocation (`malloc`). You must use freestanding C.

Create your C file, for example, `my_program.c`:

```c
// my_program.c
void main() {
    int *ptr = (int *) 0x1000;
    *ptr = 42; // Store 42 at memory address 0x1000
    while(1);  // Loop forever
}
```

*Important Constraints:*
1. No `#include <stdio.h>` or standard libraries.
2. If you need standard logic (like `memcpy` or `memset`), you will have to implement it yourself.

## Compiling Your C Program

Use the repository's provided `Makefile` target to compile, assemble, and link your code for the LX32 CPU.

```bash
make compile-c PROG=my_program.c
```

### What happens under the hood?

1. **Clang (LLVM Frontend):** Compiles your freestanding C code down to LLVM Intermediate Representation (IR).
2. **llc (LLVM Backend):** Takes the generic IR and precisely maps it to LX32 CPU instructions, generating assembly code (`.s`).
3. **llvm-mc & C Runtime (`crt0.S`):** Your assembly is assembled to an object file (`.o`). It is then bundled with `crt0.S`, which initializes the processor's Stack Pointer and zeroes out the BSS memory segment before calling `main()`.
4. **ld.lld (Linker):** Finally, everything is organized using `tools/lx32_backend/tests/baremetal/link.ld` and packaged into a final `.elf` executable and `.bin` raw image file ready to inject into simulation memory.

## Testing the Toolchain Pipeline

To verify your local LLVM has correctly built and can flawlessly handle the pipeline, run the baremetal smoke tests:

```bash
make test-baremetal
```

This runs specific, edge-case C programs from the `tests/baremetal/programs` folder to ensure the LX32 parser and IR instructions operate flawlessly.

For extended algorithm and control-flow coverage:

```bash
make test-baremetal-deep
```

For backend diagnostics:

```bash
LX32_BACKEND_DEBUG=1 make test-baremetal
```

To probe optimization-related backend gaps:

```bash
LX32_C_OLEVEL=1 make test-baremetal-deep
```

See [`docs/tools/lx32_optimized_c.md`](tools/lx32_optimized_c.md) for practical C patterns that stay minimalist while mapping well to the current LX32 backend.

