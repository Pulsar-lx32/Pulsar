# Writing Optimized Bare-Metal C for LX32

This guide is for firmware-style C on LX32: tiny code, predictable assembly, and no unnecessary dependencies.

## Goals

- Keep source minimal: include headers only when they are actually needed.
- Stay freestanding: no libc assumptions.
- Generate backend-friendly IR for the currently implemented instruction set.
- Make backend issues easy to debug when codegen fails.

## Minimalist C Rules

- You do **not** need to include your own library headers unless you call their APIs.
- Prefer plain integer types and explicit control flow.
- Use `volatile` for MMIO pointers.
- Avoid hidden runtime calls (`memcpy`, division helpers) unless you provide your own implementation.

## Recommended Build Modes

### Bring-up default (most stable)

```bash
LX32_C_OLEVEL=0 make test-baremetal
```

Why: `-O0` avoids optimizer transforms that can introduce unsupported ops (for example multiply/divide patterns) before backend support is complete.

### Optimization probing

```bash
LX32_C_OLEVEL=1 make test-baremetal-deep
```

Use this to find optimization blind spots and backend gaps.

### Debugging backend failures

```bash
LX32_BACKEND_DEBUG=1 make test-baremetal
```

This enables extra verifier checks in `llc` and prints richer failure context.

## C Patterns That Map Well to Current LX32

- **Functions/calls:** direct calls with small fixed argument lists.
- **Comparisons:** `==`, `!=`, `<`, `<=`, `>`, `>=` in simple `if`/`while` control flow.
- **Pointers:** base + small index loops (`ptr[i]`) and explicit MMIO addresses.
- **Loops:** counted `while`/`for` loops using integer induction variables.
- **Assignments/jumps:** straightforward scalar assignments and structured branches.

## Patterns to Use Carefully

- Multiplication/division/modulo in optimized builds may become unsupported instruction patterns.
- Large switch/jump-table style control flow can increase backend complexity early.
- Aggressive inlining/unrolling can hide source intent during backend bring-up.

## Workflow for Fast Iteration

1. Start with `LX32_C_OLEVEL=0` and make sure codegen works.
2. Raise to `LX32_C_OLEVEL=1` to probe optimization behavior.
3. If it fails, rerun with `LX32_BACKEND_DEBUG=1` and keep the generated `.ll` for triage.
4. Add a focused test under `tools/lx32_backend/tests/baremetal/programs/`.

## Deep Coverage Programs

Use these programs to check functionality and detect regressions:

- `01_return42.c` - baseline function return.
- `02_pointer_store.c` - pointer load/store path.
- `03_call_chain.c` - direct call lowering.
- `04_branch_loop.c` - branch/loop lowering.
- `05_compare_assign.c` - comparison-heavy assignment flow.
- `06_pointer_walk.c` - pointer walk in loop.
- `07_fibonacci_iter.c` - iterative loop algorithm.
- `08_fibonacci_recursive.c` - recursive call stress case.

