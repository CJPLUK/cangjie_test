// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// Positive: MergeBlocks fuses every remaining single-entry single-exit GoTo
// (checkSingleEntrySingleExit / MergeIntoPredecessor). After the pass, foo
// must not contain a block whose only predecessor is a GoTo with that block
// as its only successor. MATCH_PATTERN / UNREACHABLE are excluded, same as
// SkipMergeBlock. Before this pass the for-in body is a GoTo chain (#3->#6->#4).
// DEPENDENCE: ../pick_defination.py check_no_sese.py
// EXEC: %compiler %cmp_opt %dumpCHIRDebug %warnOffAll %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_MergingBlock.chirtxt "Func @_CN7default3fooHv" | %python check_no_sese.py

func foo(): Int64 {
    var s = 0
    for (i in 0..3) {
        s = s + i
    }
    return s
}

main() {
    foo()
}
