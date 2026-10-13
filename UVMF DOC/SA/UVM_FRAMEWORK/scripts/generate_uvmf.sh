#!/usr/bin/env bash
set -euo pipefail
: "${UVMF_HOME:?Set UVMF_HOME}"
cd "$(dirname "$0")/../yaml"
python3 "$UVMF_HOME/scripts/yaml2uvmf.py" sa_in_interface.yaml sa_out_interface.yaml sa_environment.yaml sa_bench.yaml
