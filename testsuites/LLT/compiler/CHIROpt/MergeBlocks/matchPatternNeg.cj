// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// Negative: SkipMergeBlock leaves MATCH_PATTERN blocks alone, so
// checkGotoOnly does not MergeGotoOnlyBlock them. After MergingBlock the
// wildcard arm still has a GoTo-only `[matchPattern]` block whose successor
// is the `[matchPattern]` block that holds `Constant(0i)`.
// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %dumpCHIRDebug %warnOffAll %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_MergingBlock.chirtxt "Func @_CN7default3fooHl" | compare %f

func foo(x: Int64): Int64 {
    match (x) {
        case 1 => 10
        case 2 => 20
        case _ => 0
    }
}

main() {
    foo(1)
}

// ASSERT: regex-begin Func @_CN7default3fooHl
// ASSERT: regex-after \[matchPattern\] Block #(?P<pat>\d+):[^\n]*\n  GoTo\(#(?P<body>\d+)\)
// ASSERT: regex-after \[matchPattern\] Block #(?P=body):
// ASSERT: regex-after Constant\(0i\)
