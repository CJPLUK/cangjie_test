// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// Negative: if/else join has two predecessors, so it is not SESE and is not fused
// into either arm (MergeIntoPredecessor requires pred.successors.size() == 1).
// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %dumpCHIRDebug %warnOffAll %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_MergingBlock.chirtxt "Func @_CN7default3fooHb" | compare %f

func foo(c: Bool): Int64 {
    var x = 0
    if (c) {
        x = 1
    } else {
        x = 2
    }
    return x
}

main() {
    foo(true)
}

// ASSERT: regex-begin Func @_CN7default3fooHb
// ASSERT: regex-after Branch\(%\d+, #(?P<then>\d+), #(?P<else>\d+)\) // loc: "seseNegJoin.cj"
// ASSERT: regex-after Block #(?P=then):
// ASSERT: regex-after Constant\(1i\)
// ASSERT: regex-after GoTo\(#(?P<join>\d+)\)
// ASSERT: regex-after Block #(?P=else):
// ASSERT: regex-after Constant\(2i\)
// ASSERT: regex-after GoTo\(#(?P=join)\)
// ASSERT: regex-after Block #(?P=join):  // predecessors: \[#(?P=then), #(?P=else)\]
// ASSERT: regex-after Load\(%\d+\)
