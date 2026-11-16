// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// Positive: textbook SESE (`checkSingleEntrySingleExit` / MergeIntoPredecessor)
// on `if` without else. Entry `GoTo` into the `if` header is fused. The then
// arm and join are not SESE (header `Branch` has two successors; join has two
// predecessors) — that leftover diamond is the seseNegJoin case. After the
// pass, foo must have no remaining SESE GoTo (`check_no_sese.py`). forInPos /
// lambdaPos check the same invariant on other CFGs (for-in chain, nested
// Lambda).
// DEPENDENCE: ../pick_defination.py check_no_sese.py
// EXEC: %compiler %cmp_opt %dumpCHIRDebug %warnOffAll %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_MergingBlock.chirtxt "Func @_CN7default3fooHl" | %python check_no_sese.py

func foo(x: Int64): Int64 {
    var a = x
    if (x > 0) {
        a = a + 1
    }
    let b = a + 2
    return b
}

main() {
    foo(1)
}
