// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// Positive: `for (i in 0..=2 : 1)` is ForInClosedRange. Flatten puts
// GeneratedFromForIn on the shared latch/cond join (two predecessors from the
// if/else body). MergeForInCondBlock clones that block for all but the last
// predecessor, then strips the annotation. After MergingBlock:
//   - no Block header still carries `generated-from-forin`
//   - the latch `Load` + `Branch` appears twice with the same successors
// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %dumpCHIRDebug %warnOffAll %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_MergingBlock.chirtxt "Func @_CN7default3fooHv" | compare %f

func foo(): Int64 {
    var s = 0
    for (i in 0..=2 : 1) {
        if (i > 0) {
            s = s + i
        } else {
            s = s + 1
        }
    }
    return s
}

main() {
    foo()
}

// ASSERT: regex-begin Func @_CN7default3fooHv
// ASSERT: regex-not Block #\d+:[^\n]*// generated-from-forin
// ASSERT: regex-after Load\(%\d+\)\n  Branch\(%\d+, #(?P<cont>\d+), #(?P<exit>\d+)\).*sourceExpr: OTHER
// ASSERT: regex-after Load\(%\d+\).*\n  Branch\(%\d+, #(?P=cont), #(?P=exit)\)
