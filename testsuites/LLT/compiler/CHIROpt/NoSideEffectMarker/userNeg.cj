// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// Negative: a user function is not on the NoSideEffectMarker whitelist, so
// Canonicalization must not put `[noSideEffect]` on `foo`.
// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %dumpCHIRDebug -Woff all %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN7default3fooHl" | compare %f

func foo(x: Int64): Int64 {
    x + 1
}

main() {
    foo(1)
}

// ASSERT: regex-begin Func @_CN7default3fooHl
// ASSERT: regex-not \[noSideEffect\]
