// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// After MergeBlocks, empty `while (true) {}` body (`GoTo` back to the header)
// is folded, but the header itself stays: entry `GoTo(#H)`, then `#H` does
// `Branch(..., #H, #exit)` (self-loop on the true edge). `#H` is not
// GoTo-only (`Constant` + `Branch`), so `checkGotoOnly` never applies.
// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %dumpCHIRDebug %warnOffAll %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_MergingBlock.chirtxt "Func @_CN7default3fooHv" | compare %f

func foo(): Int64 {
    while (true) {
    }
    return 0
}

main() {
    0
}

// ASSERT: regex-begin Func @_CN7default3fooHv
// ASSERT: regex-after \[ret\] %\d+: Int64& = Allocate\(Int64\)\n  GoTo\(#(?P<header>\d+)\)
// ASSERT: regex-after Block #(?P=header):
// ASSERT: regex-after Branch\(%\d+, #(?P=header), #\d+\).*sourceExpr: WHILE_EXPR
