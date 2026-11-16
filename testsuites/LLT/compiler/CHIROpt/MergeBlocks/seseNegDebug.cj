// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// Negative: with `-g`, SkipMergeBlock refuses a block whose own terminator has
// a real source location. The entry `GoTo(#H)` itself has no loc (so the
// checkSESE `line==0 && column==0` test would allow the merge); `#H`'s
// `Branch` does have loc, so `#H` is not fused into the entry.
// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %enableCompileDebug %dumpCHIRDebug %warnOffAll %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_MergingBlock.chirtxt "Func @_CN7default3fooHl" | compare %f

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

// ASSERT: regex-begin Func @_CN7default3fooHl
// ASSERT: regex-after \[ret\] %\d+: Int64& = Allocate\(Int64\)\n  GoTo\(#(?P<header>\d+)\)
// ASSERT: regex-after Block #(?P=header):
// ASSERT: regex-after Branch\(%\d+, #\d+, #\d+\) // loc: "seseNegDebug.cj"
