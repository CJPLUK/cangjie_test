// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// Positive: Visitor walks into Lambda bodies. The inner entry `GoTo` is the
// same SESE pattern as forInPos (`checkSingleEntrySingleExit` /
// `MergeIntoPredecessor`). After MergingBlock, neither the outer func nor the
// nested lambda BlockGroup may still have a single-entry single-exit GoTo.
// DEPENDENCE: ../pick_defination.py check_no_sese.py
// EXEC: %compiler %cmp_opt %dumpCHIRDebug %warnOffAll %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_MergingBlock.chirtxt "Func @_CN7default3fooHv" | %python check_no_sese.py

func foo(): Int64 {
    let f = { x: Int64 =>
        let a = x + 1
        a + 2
    }
    return f(1)
}

main() {
    foo()
}
