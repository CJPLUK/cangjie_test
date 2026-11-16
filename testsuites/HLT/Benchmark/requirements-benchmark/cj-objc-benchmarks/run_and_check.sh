#!/usr/bin/env bash
# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

# cj-objc-benchmarks 一键执行 + 达标判定。
#
# 分别构建并运行：
#   cj-uses-objc/   （Cangjie 调 ObjC，需 CANGJIE_HOME + cjc 的 objc 实验支持 + clang/objc）
#   kt-uses-objc/   （Kotlin/Native 调 ObjC，需 cinterop/kotlinc-native + clang/objc）
# 然后按标准判定：
#   以 KT->ObjC 为基线，CJ->ObjC 的耗时（AVG ns，取 static/get 两行 Iter=0）需优于 KT 至少 10%。
#
# 用法：
#   cd <cj-objc-benchmarks 目录>
#   bash run_and_check.sh
set -euo pipefail

CASE_DIR="$(cd "$(dirname "$0")" && pwd -P)"
SCRIPT_DIR="$CASE_DIR/script"
PYTHON_BIN="${PYTHON_BIN:-python3}"
CJ_LOG="$CASE_DIR/cj_uses_objc.log"
KT_LOG="$CASE_DIR/kt_uses_objc.log"

echo "[INFO] ==== cj-objc-benchmarks: build + run + check ===="

echo "[INFO] build & run cj-uses-objc (Cangjie -> ObjC) ..."
: >"$CJ_LOG"
(cd "$CASE_DIR/cj-uses-objc" && bash build.sh) >>"$CJ_LOG" 2>&1
(cd "$CASE_DIR/cj-uses-objc" && bash run.sh) >>"$CJ_LOG" 2>&1

echo "[INFO] build & run kt-uses-objc (Kotlin -> ObjC) ..."
: >"$KT_LOG"
(cd "$CASE_DIR/kt-uses-objc" && bash build.sh) >>"$KT_LOG" 2>&1
(cd "$CASE_DIR/kt-uses-objc" && ./main) >>"$KT_LOG" 2>&1

echo "[INFO] CJ 输出: $CJ_LOG"
echo "[INFO] KT 输出: $KT_LOG"
echo "[INFO] 关键行（CJ）:"
grep -E "CJ->ObjC (static|get) +Iter= +0" "$CJ_LOG" || true
echo "[INFO] 关键行（KT）:"
grep -E "KT->ObjC (static|get) +Iter= +0" "$KT_LOG" || true

"$PYTHON_BIN" "$SCRIPT_DIR/check_objc_pass.py" \
    --cj-log "$CJ_LOG" \
    --kt-log "$KT_LOG"
