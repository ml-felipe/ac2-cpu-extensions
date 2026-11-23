# AC2 CPU extensions and branch logic

Recovered UPC-FIB Computer Architecture Labs 4–5 work for the DRAC teaching processor. The source includes an incremental ALU extension for signed MAX/MIN and a tree-based 64-bit population count, branch decisions/targets, prediction checking, and the associated decoder/datapath files. Original C and assembly exercises compare custom instructions with software loops.

This is a collection of recoverable CPU modules and programs, **not a complete processor**. `drac_pkg`, `riscv_pkg`, the remaining pipeline/system, and the original simulation environment were not recovered here. Decoder constants and pipeline interfaces cannot be validated without them.

## Tests

Install Icarus Verilog with SystemVerilog support, then run `make test`. It runs the recovered ALU, branch unit and prediction checker with and without `BP_ENABLE`. The test fixture in `tests/drac_pkg_fixture.sv` supplies only the types needed by these isolated modules. Its instruction enum values are arbitrary and its address type is 64-bit; it is newly written test infrastructure, not a replacement or reconstruction of the missing DRAC packages.

Both simulations passed: 13,092 checks with prediction disabled and 13,098 enabled. Coverage includes 1,000 operand pairs, signed extrema, every single-bit population-count input, all-ones input, arithmetic/logic operations, directed word operations, signed/unsigned branch decisions, JALR alignment, decode-owned JAL behavior and prediction outcomes. Icarus emits conservative `always_*` sensitivity warnings; these do not prevent the simulations. The full decoder and datapath are not compiled by this target.

The two recovered assembly benchmark routines assembled with Clang targeting `riscv64`/`rv64gc`:

```sh
clang --target=riscv64 -march=rv64gc -c programs/benchmarks/popcnt_custom/popcnt_custom.S -o /tmp/popcnt.o
clang --target=riscv64 -march=rv64gc -c programs/benchmarks/maxmin_custom/maxmin_custom.S -o /tmp/maxmin.o
```

This checks assembly syntax, not execution of the custom instruction words. The C benchmarks still need the original RISC-V runtime (`syscalls.h`, `setStats`) and matching custom-instruction processor. No benchmark speedup or hardware execution is claimed. The historical C tests print results; they are not the automated regression target.

## Migration changes

The POPCNT C exercise moved its operand to x13 although its instruction word reads x10; it now loads x10. The POPCNT assembly routine used x8/x9 without preserving those callee-saved registers; those scratch values now use caller-saved x28/x29. Corresponding instruction comments were corrected. RTL behavior was preserved. Documentation, the isolated test fixture and testbench are new migration work.

See [ATTRIBUTION.md](ATTRIBUTION.md) before publication.
