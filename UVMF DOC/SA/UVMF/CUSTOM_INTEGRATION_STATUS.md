# SA UVMF 2023.4 — custom integration

## Changes applied directly to generated source

- `sa_in_driver_bfm.sv`: drives first and second input bits with enable strobed at the first bit. Delays further transactions until serial calculation is complete.
- `sa_in_monitor_bfm.sv`: reconstructs 2-bit A and B on falling clock edges.
- `sa_out_monitor_bfm.sv`: reconstructs 3-bit sum beginning on `en_o`, matching the original UVM output-monitor convention.
- `sa_sa_predictor.svh`: maps input transactions to expected 3-bit sum.
- `sa_sa_scoreboard.svh`: consumes expected and actual FIFOs; reports comparison pass/fail.
- `sa_sa_coverage.svh`: functional operand-pair coverage (16 bins).
- `sa_environment.svh`: instantiates predictor, scoreboard, coverage; makes monitor-to-predictor/FIFO/coverage TLM connections.
- `sa_env_pkg.sv`: includes additional components.
- `sa_in_random_sequence.svh`: exercises all 16 input combinations plus 15 random transactions.

## Critical RTL compatibility note

The provided `sa.vhd` has no reset input. Generated BFM reset (`rst_n`) is solely testbench-side. Generated bench and DUT binding/top-level remain **outside this archive**, and must be generated or supplied separately; build/test execution is not validated.

## Outstanding integration

1. Regenerate bench from `yaml/sa_bench.yaml` or restore your existing UVMF bench/test infrastructure. Connect sa_in_if/sa_out_if to VHDL DUT; do not connect rst_n to the DUT.
2. Start `sa_in_random_sequence` on the input agent's sequencer from your UVMF test/virtual sequence. Allow output transactions to drain before ending objection.
3. Confirm UVMF 2023.4 generated base library exposes `monitored_ap` and that the environment compiles.
4. Run coverage, scoreboard comparisons, and Questa compile/simulation; adjust serial output sampling only if a waveform establishes mismatch with the original protocol.
5. Regeneration of `verification_ip` may overwrite modifications; reapply custom portions or move into generator-preserved regions.

**Verification status:** static integration only, not compile-verified, not simulation-verified.
