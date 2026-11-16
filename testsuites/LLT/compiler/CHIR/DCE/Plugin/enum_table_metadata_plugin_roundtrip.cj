// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Verify a plugin round trip preserves enum table traversal metadata.
// (Linux) EXEC-PIPE-0: export LD_LIBRARY_PATH=$CANGJIE_HOME/tools/lib:$LD_LIBRARY_PATH && %compiler %import-cangjie-stdx %cmp_opt %diag_json -O2 %f -o %output %collect_aspects_plugin 2>&1 | compare %f

// Payload constants are not propagated yet; only the three Right alternatives are diagnosed.
// ASSERT: scan-3 "DiagKind": "chir_unreachable_pattern"

enum TableState {
    | Left(Int64, Bool)
    | Right(Int64, Bool)
}

main() {
    let state = TableState.Left(0, true)
    match (state) {
        case Left(0, true) => 0
        case Left(_, true) | Right(0, true) => 1
        case Left(_, false) => 2
        case Right(_, true) => 3
        case Right(_, false) => 4
    }
}
