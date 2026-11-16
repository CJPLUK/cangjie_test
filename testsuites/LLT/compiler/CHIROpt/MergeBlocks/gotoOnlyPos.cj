// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// Positive: empty `if` then-block is a GoTo-only block (MergeGotoOnlyBlock).
// Both Branch edges are rewritten to the join block.
// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %dumpCHIRDebug %warnOffAll %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_MergingBlock.chirtxt "Func @_CN7default3fooHb" | compare %f

func foo(c: Bool): Int64 {
    if (c) {
    }
    return 1
}

main() {
    foo(true)
}

// ASSERT: regex-begin Func @_CN7default3fooHb
// ASSERT: regex-after Branch\(%\d+, #(?P<join>\d+), #(?P=join)\)
// ASSERT: regex-after Constant\(1i\)
