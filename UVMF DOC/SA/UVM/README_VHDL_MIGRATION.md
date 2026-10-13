# Sa: VHDL RTL + updated original UVM testbench

## Scope
- `sa.v` was **replaced** by `sa.vhd` (VHDL-2008).
- SystemVerilog UVM components, transaction model, interface, scoreboard, driver, and independent monitors remain in SystemVerilog.
- C++ DPI predictor remains unchanged.
- Because `out` is a reserved VHDL word, the DUT port was renamed `result_o`; the mixed-language DUT instantiation in `sa_tb_top.sv` is updated. `vif.sig_out` remains unchanged.
- `compile_sa.do` now compiles VHDL with `vcom -2008` before compiling the SystemVerilog testbench with `vlog -sv`.

## Behavior translated from Verilog
The original design samples serial MSB-first operands in two cycles; calculates a 3-bit unsigned sum; emits the sum MSB-first over three cycles; pulses `en_o` high on the first output cycle. It has no explicit reset and relies on initial state. VHDL process variables preserve Verilog blocking-assignment ordering, and signal assignments preserve registered output semantics. The source's restart behavior when `en_i` is asserted during an operation is retained.

## Commands (Questa GUI/transcript)
From `UVM/`:
```tcl
set PREDICT_LIB C:/path/to/compiled/predictor
# compile shared DPI library first using your Questa toolchain
# then:
do sim_ver_sa.do
```
Or compile manually:
```tcl
vlib work
vcom -2008 sa.vhd
vlog -sv +incdir+. sa_tb_top.sv
vsim -c -sv_lib C:/path/to/compiled/predictor work.sa_tb_top +UVM_TESTNAME=sa_test
run -all
```

## Existing UVM corrections retained
The previous corrected UVM code includes `run_phase` scoreboard checking, errors on mismatches, independently allocated monitor transactions, negative-edge driver updates, and explicit input/output monitor naming.

## Caveats / verification
- Requires **mixed-language** Questa VHDL/SystemVerilog support and a working UVM library.
- Requires compilation of `predict_class.cpp` as a DPI shared library for the installed simulator toolchain.
- Functional equivalence and compilation were source-reviewed, **not** verified by Questa simulation in this environment. Use a regression to confirm timing and DPI linkage.
- The original design depends on initialized registers instead of a reset signal; this is retained, not redesigned.
