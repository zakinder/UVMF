# SA Serial Adder — UVM to UVMF 2023.4 conversion starter

This archive provides original source, unchanged VHDL DUT, UVMF generator input YAML and explicitly labeled custom logic reference code.

## Requirements
- Mentor/Siemens Questa with mixed-language VHDL/SystemVerilog support.
- UVMF 2023.4 with `$UVMF_HOME/scripts/yaml2uvmf.py`.
- Python and PyYAML.

## Generate (Windows CMD)
```bat
set UVMF_HOME=C:\path\to\UVMF_2023.4
scripts\generate_uvmf.bat
```
Or run from `yaml/`:
```bat
python "%UVMF_HOME%\scripts\yaml2uvmf.py" sa_in_interface.yaml sa_out_interface.yaml sa_environment.yaml sa_bench.yaml
```

## Architecture
```text
sa_bench (clock 10 ns, synthetic rst_n only for UVMF generation)
  sa environment
    sa_in_agent (ACTIVE) -> VHDL sa input serial pins
    sa_out_agent (PASSIVE) <- VHDL sa output serial pins
    [integrate] sa_predictor -> expected_fifo
    [integrate] output monitor -> actual_fifo
    [integrate] sa_scoreboard compare
```

**Critical**: `sa.vhd` has **no reset port**. The generated UVMF `rst_n` is a testbench-only control signal and must NOT be wired to the DUT. The DUT needs six cycles per input transaction, MSB-first data on first two cycles and an `en_o` result capture window. The generator generates structure but not functional protocol drivers, monitors or scoreboard wiring. Read `custom/README.md`.

**Status**: YAML files passed PyYAML parsing and structural checks; **not run through UVMF 2023.4 or Questa** (these installations are unavailable here). Thus no claim of generator compilation or simulation PASS is made.

## Source mapping
| Original UVM | UVMF target |
|---|---|
| `sa_transaction.svh` | `sa_in_transaction`, `sa_out_transaction` |
| `sa_driver.sv` | `sa_in_driver_bfm` custom drive logic |
| `sa_monitor.sv` | `sa_in_monitor_bfm`, `sa_out_monitor_bfm` |
| `sa_agent.sv` | `sa_in_agent`, `sa_out_agent` |
| `sa_env.sv` | `sa_environment` |
| `sa_scoreboard.sv` | custom `sa_scoreboard_uvmf` |
| `sa_sequencer.sv` | generated sequencer + `sa_random_sequence` |
| `predict_class.cpp` | optional DPI model; pure SV model provided |
| `sa_tb_top.sv` | generated bench top; manually connect VHDL DUT |

## Key verification matrix
Inputs a,b in [0..3]; expected sum a+b in [0..6]; 16 input cross combinations. Include zero, carry-generating (3+3), and repeated requests only after six-cycle completion. Input monitor and output monitor must communicate via independently observed transactions.
