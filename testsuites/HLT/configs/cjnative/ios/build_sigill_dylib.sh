#!/bin/bash
# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.
#
# Build (and cache) the SIGILL context-capture dylib for one simulator
# architecture. Used by ios_sim_common.sh when CJ_TRACE_STACK is set.
# Usage: build_sigill_dylib.sh <x86_64|arm64>
# Prints the dylib path on success.

set -e

ARCH="${1:-x86_64}"
case "$ARCH" in
    x86_64) TRIPLE="x86_64-apple-ios-simulator" ;;
    arm64)  TRIPLE="arm64-apple-ios-simulator" ;;
    *) echo "unsupported arch: $ARCH" >&2; exit 2 ;;
esac

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SRC_DIR/sigill_catch.c"
CACHE="${TMPDIR:-/tmp}"
OUT="$CACHE/cangjie-sigill-$ARCH.dylib"

if [ -f "$OUT" ] && [ "$OUT" -nt "$SRC" ]; then
    echo "$OUT"
    exit 0
fi

SDK="$(xcrun --sdk iphonesimulator --show-sdk-path)"
TMP="$OUT.tmp.$$"
xcrun -sdk iphonesimulator clang -target "$TRIPLE" -isysroot "$SDK" \
    -dynamiclib -o "$TMP" "$SRC"
codesign -f -s - "$TMP"
mv -f "$TMP" "$OUT"
echo "$OUT"
