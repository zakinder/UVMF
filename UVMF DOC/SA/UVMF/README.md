# UVMF 2023.4 conversion package — Simpleadder

**Deliverable:** five UVMF generator-input YAMLs, supporting migration snippets,
generation scripts, original UVM source, original DUT, and a detailed migration guide.

Start at [`docs/CONVERSION_GUIDE.md`](docs/CONVERSION_GUIDE.md).

**Important:** This is a UVMF **generator-input and porting package**, not a
precompiled or fully integrated simulator-ready bench. BFM custom regions and HDL
wiring require integration after `yaml2uvmf.py` code generation.
