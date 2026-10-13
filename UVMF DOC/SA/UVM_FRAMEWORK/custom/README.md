# Customization requirements

These are **integration reference snippets**, not generator-consumed YAML.
Copy each into the corresponding UVMF-generated `// UVMF_CHANGE_ME` or user-code region **after inspecting generated method signatures**. The generator cannot derive the serial protocol drive/monitor timing, predictor logic, or scoreboard connections from the four structural YAMLs.

1. `sa_in_driver_bfm_tasks.sv.txt`: serial stimulus on negedges.
2. `sa_out_monitor_bfm_tasks.sv.txt`: collect three output bits following `en_o`.
3. `sa_predictor.svh`: expected sum calculation. Reference uses pure SV; original C++ DPI predictor is in `original_uvm/` and can be retained with `-sv_lib`.
4. `sa_scoreboard.svh`: expected/actual result comparisons.
5. `sa_sequence.svh`: 15 randomized transactions.
6. `sa_coverage.svh`: 16-bin operand cross.

Generated UVMF agent BFMs use version-specific proxy APIs. These snippets are intentionally not asserted to compile unchanged; map them to the generator output. Generated environment requires explicit predictor/scoreboard creation and TLM connection.
