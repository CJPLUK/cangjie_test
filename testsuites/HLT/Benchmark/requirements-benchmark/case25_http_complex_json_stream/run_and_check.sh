#!/usr/bin/env bash
# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

# case25_http_complex_json_stream one-shot run + pass check.
#
# Usage:
#   cd <case25_http_complex_json_stream dir>
#   CANGJIE_HOME=<cangjie-opt SDK root> bash run_and_check.sh
#
# Flow:
#   1) Run run_compare.sh to produce <timestamp>_opt_gc1_vs_gc2_* dirs and compare_report.md;
#   2) Invoke script/check_case25_pass.py to decide PASS/FAIL:
#        With WGC(cjEnableGC=1) as baseline, GenerationalGC(cjEnableGC=2)
#        must reduce CPU cost per successful request >= 30% and avg RSS >= 30%;
#   3) PASS exits 0, otherwise non-zero (FAIL).
set -euo pipefail

CASE_DIR="$(cd "$(dirname "$0")" && pwd -P)"
SCRIPT_DIR="$CASE_DIR/script"
PYTHON_BIN="${PYTHON_BIN:-python3}"

echo "[INFO] ==== case25_http_complex_json_stream: run + check ===="
run_output="$(bash "$CASE_DIR/run_compare.sh" "$@")"
printf '%s\n' "$run_output"

compare_dir="$(printf '%s\n' "$run_output" | sed -n 's/^\[DONE\] compare_dir=//p' | tail -n 1)"
if [[ -z "$compare_dir" || ! -d "$compare_dir" ]]; then
    echo "[ERROR] cannot locate compare_dir from run_compare.sh output" >&2
    exit 1
fi
echo "[INFO] compare_dir=$compare_dir"
echo "[INFO] compare_report: $compare_dir/compare_report.md"

"$PYTHON_BIN" "$SCRIPT_DIR/check_case25_pass.py" \
    --compare-dir "$compare_dir" \
    --report "$compare_dir/compare_report.md"
