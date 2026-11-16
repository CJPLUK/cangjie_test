// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// After MarkClassHasInited, a class with a finalizer gets the compiler-added
// `$hasInited` Bool field (private, compilerAdd, noReflectInfo).

// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %dumpCHIRDebug -Woff all %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_Canonicalization.chirtxt "class @_CN7default1CE" | compare %f
// ASSERT: scan [private] [compilerAdd] [noReflectInfo] var $hasInited: Bool

class C {
    var x: Int64 = 0
    ~init() {
        println(x)
    }
}

main(): Int64 {
    C()
    0
}
