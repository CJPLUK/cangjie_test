#!/usr/bin/env bash
# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

# mirrorcalls 一键执行 + 达标判定（与 cj-objc-benchmarks 类似）。
#
# 目录结构（代码由使用者放入）：
#   cj-uses-objc/   （Cangjie 调 ObjC，build.sh 构建；默认再执行 run.sh，若不存在则执行 ./main）
#   kt-uses-objc/   （Kotlin/Native 调 ObjC，build.sh 构建后执行 ./main）
#
# 判定标准（以 KT 为基线）：CJ 的耗时需 <= threshold × KT（默认 0.9，即 CJ 优于 KT 至少 10%）。
# 行名/指标名/阈值可用环境变量覆盖：
#   CJ_LABEL（默认 CJ->ObjC）、KT_LABEL（默认 KT->ObjC）、KINDS（默认 static,get）、THRESHOLD（默认 0.9）
#
# 用法：
#   cd <mirrorcalls 目录>
#   bash run_and_check.sh
set -euo pipefail

CASE_DIR="$(cd "$(dirname "$0")" && pwd -P)"
SCRIPT_DIR="$CASE_DIR/script"
PYTHON_BIN="${PYTHON_BIN:-python3}"
CJ_LOG="$CASE_DIR/cj_uses_objc.log"
KT_LOG="$CASE_DIR/kt_uses_objc.log"

: "${CJ_LABEL:=CJ->ObjC}"
: "${KT_LABEL:=KT->ObjC}"
: "${KINDS:=static,get}"
: "${THRESHOLD:=0.9}"

echo "[INFO] ==== mirrorcalls: build + run + check ===="

echo "[INFO] build & run cj-uses-objc (Cangjie -> ObjC) ..."
: >"$CJ_LOG"
(cd "$CASE_DIR/cj-uses-objc" && bash build.sh) >>"$CJ_LOG" 2>&1
if [[ -f "$CASE_DIR/cj-uses-objc/run.sh" ]]; then
    (cd "$CASE_DIR/cj-uses-objc" && bash run.sh) >>"$CJ_LOG" 2>&1
else
    (cd "$CASE_DIR/cj-uses-objc" && ./main) >>"$CJ_LOG" 2>&1
fi

echo "[INFO] build & run kt-uses-objc (Kotlin -> ObjC) ..."
: >"$KT_LOG"
(cd "$CASE_DIR/kt-uses-objc" && bash build.sh) >>"$KT_LOG" 2>&1
(cd "$CASE_DIR/kt-uses-objc" && ./main) >>"$KT_LOG" 2>&1

echo "[INFO] CJ 输出: $CJ_LOG"
echo "[INFO] KT 输出: $KT_LOG"

"$PYTHON_BIN" "$SCRIPT_DIR/check_objc_pass.py" \
    --cj-log "$CJ_LOG" \
    --kt-log "$KT_LOG" \
    --cj-label "$CJ_LABEL" \
    --kt-label "$KT_LABEL" \
    --kinds "$KINDS" \
    --threshold "$THRESHOLD"
