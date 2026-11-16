// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Importing package: a local class with a finalizer still gets `$hasInited`
// from MarkClassHasInited in this package.

// DEPENDENCE: ../pick_defination.py chir_import_pkg.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt chir_import_pkg.cj -o pkg.%middle
// EXEC: %compiler %cmp_opt %dumpCHIRDebug -Woff all pkg.%middle %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_Canonicalization.chirtxt "class @_CN7default5LocalE" | compare %f
// ASSERT: regex class @(?P<cls>_CN7default5LocalE)[\s\S]*?\[private\] \[compilerAdd\] \[noReflectInfo\] var \$hasInited: Bool

internal import pkg.*

class Local {
    init() {
    }
    ~init() {
        println(1)
    }
}

main(): Int64 {
    Handle()
    Local()
    0
}
