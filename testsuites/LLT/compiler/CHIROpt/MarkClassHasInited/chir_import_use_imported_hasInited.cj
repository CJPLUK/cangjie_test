// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Importing package: upstream cjo does not carry `$hasInited`. MarkClassHasInited
// in this package must still add the field on the imported class (CreateVTable
// has none; Canonicalization has one).

// DEPENDENCE: ../pick_defination.py chir_import_pkg.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt chir_import_pkg.cj -o pkg.%middle
// EXEC: %compiler %cmp_opt %dumpCHIRDebug -Woff all pkg.%middle %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_Canonicalization.chirtxt "class @_CN3pkg6HandleE" | compare %f
// ASSERT: regex \[imported\] class @(?P<cls>_CN3pkg6HandleE)[\s\S]*?\[private\] \[compilerAdd\] \[noReflectInfo\] var \$hasInited: Bool
// ASSERT: scan-1 $hasInited

internal import pkg.*

main(): Int64 {
    Handle()
    0
}
