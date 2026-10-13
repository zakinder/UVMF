#!/usr/bin/env bash
set -euo pipefail
: "${UVMF_HOME:?Set UVMF_HOME to UVMF 2023.4 root}"
cd "$(dirname "$0")/../yaml"
python3 "$UVMF_HOME/scripts/yaml2uvmf.py" adder_in_interface.yaml adder_out_interface.yaml adder_predictor.yaml simpleadder_environment.yaml simpleadder_bench.yaml
