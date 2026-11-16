// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Classes without a finalizer are skipped by MarkClassHasInited; no `$hasInited`.

// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %dumpCHIRDebug -Woff all %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_Canonicalization.chirtxt "class @_CN7default1CE" | compare %f
// ASSERT: scan class @_CN7default1CE
// ASSERT: scan-not $hasInited
// ASSERT: scan-not hasInitedField

class C {
    var x: Int64 = 0
}

main(): Int64 {
    C()
    0
}
