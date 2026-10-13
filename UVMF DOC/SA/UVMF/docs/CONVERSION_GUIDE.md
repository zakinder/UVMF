# Simpleadder — UVM to UVMF 2023.4 migration

## Inventory and intent
The supplied UVM source describes `simpleadder.v`: two serialized two-bit operands produce
one serialized three-bit sum. Preserved original source under `original_uvm/`.

## Architecture
```
UVMF adder_in_agent [ACTIVE] -- serial driver BFM --> DUT
            |                                   |
      input monitor                         output monitor
            |                                   |
            v                                   v
       adder_predictor --> expected --> UVMF in-order scoreboard <-- actual
```

## Generate skeleton
Run `scripts/generate_uvmf_windows.bat` in a Windows CMD terminal with `UVMF_HOME`
pointing to the installed **UVMF 2023.4** distribution, or the Linux `.sh` variant.
Five YAML files must be supplied together because the bench depends on the environment,
two interface agents, and predictor. UVMF creates generated class packages and testbench.

## Mandatory post-generation integration
The YAML describes the *structural* verification environment, not signal-level
custom logic. The `custom/` files provide implementation algorithms that must be
merged into UVMF-generated customization regions:

1. `adder_in_driver_bfm_algorithm.sv.txt`: serialize MSB and LSB at negative edges.
2. `adder_in_monitor_bfm_algorithm.sv.txt`: reconstruct operands from positive edges.
3. `adder_out_monitor_bfm_algorithm.sv.txt`: reconstruct three output bits.
4. `adder_predictor_write.svh`: reference addition into expected transaction.
5. `adder_in_random_sequence.svh.txt`: generate 15 randomized input transfers.
6. Connect generated HDL tops and BFMs to DUT pins `sig_clock`, `sig_ina`, `sig_inb`,
   `sig_en_i`, `sig_en_o`, `sig_out`. **DUT has no reset**; the YAML's
   generated `reset` is a *testbench-only* virtual/reset signal and should not be
   connected to a non-existent DUT reset port.
7. Ensure environment/test selects the randomized sequence; configure checker,
   coverage, and watchdog/objections in the generated test.
8. Inspect generated monitor sampling for simulator event-region correctness and
   single-pulse output detection.

## Original source defects corrected/avoided in design
- Original scoreboard declares `task run()` not `run_phase(uvm_phase phase)`;
  an ordinary UVM simulation does not automatically call that task. UVMF scoreboards
  solve this with built-in analysis and comparison.
- Original monitor reuses a mutable transaction handle for repeated analysis writes;
  generated monitors should create/copy a fresh object for each complete transfer.
- Original scoreboard logs failures with `uvm_info` instead of `uvm_error`.
- Original driver updates at positive edges (same as DUT), causing scheduling races;
  proposed BFM drives negative edges.
- Original source uses a C++ DPI predictor; basic arithmetic can be implemented
  in SystemVerilog without a simulator-specific DPI compilation dependency.
- Original monitor names are misleading (`before` observes DUT output,
  `after` observes inputs/prediction). Converted design explicitly separates agents.

## Validation status
YAML has been parsed and checked for structural references locally. This machine
has **not** run Mentor/Siemens UVMF 2023.4 `yaml2uvmf.py`, Questa compilation,
or UVM simulation. Exact generator acceptance and runtime pass/fail remain unverified.
After generator runs, check generated BFM signatures and adapt the custom snippets.

## Suggested functional checks
- Directed exhaustive 16 operand pairs: `ina=0..3`, `inb=0..3`.
- Boundary sums: 0+0=0, 3+3=6, 1+3=4, 2+3=5.
- Back-to-back transactions respecting the DUT's six-cycle serialization.
- Monitor/scoreboard coverage: all 16 operand pairs, each output sum 0..6.
- Expected and actual matched counts, no unmatched transaction on completion.
