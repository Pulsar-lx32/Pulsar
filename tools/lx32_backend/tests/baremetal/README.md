# Bare-Metal C Smoke (LX32)

This folder validates the minimum C-freestanding slice for firmware/drivers on LX32:

- assignments and integer arithmetic,
- raw pointer/MMIO loads and stores,
- control flow and direct calls,
- no libc/runtime dependency.

## Programs

- `programs/01_return42.c` - simplest entrypoint.
- `programs/02_pointer_store.c` - pointer dereference load/store.
- `programs/03_call_chain.c` - direct call sequence and return path.
- `programs/04_branch_loop.c` - simple counted loop with branches.
- `programs/05_compare_assign.c` - comparisons and conditional assignments.
- `programs/06_pointer_walk.c` - pointer indexing loop and accumulation.
- `programs/07_fibonacci_iter.c` - iterative Fibonacci loop.
- `programs/08_fibonacci_recursive.c` - recursive calls + branch-heavy base cases.

## Run

```bash
bash /Users/axel/lx32/tools/lx32_backend/tests/baremetal/run_baremetal_smoke.sh
```

Deep mode:

```bash
bash /Users/axel/lx32/tools/lx32_backend/tests/baremetal/run_baremetal_smoke.sh deep
```

## Notes

- Uses `-ffreestanding -fno-builtin -nostdlib`.
- Uses `-O0` by default for backend bring-up (`LX32_C_OLEVEL` overrides this).
- `tests/compile_baremetal_c.sh` always emits `.ll` and `.s`.
- `.o` is attempted and reported as best-effort while MC object emission is
  still being finished.
- Script fails if it detects common libcalls (`__divsi3`, `memcpy`, etc.).
- Set `LX32_BACKEND_DEBUG=1` to enable additional verifier checks and richer
  compile diagnostics.



