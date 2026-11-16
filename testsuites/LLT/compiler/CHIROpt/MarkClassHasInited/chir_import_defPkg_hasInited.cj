// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Defining package: after MarkClassHasInited, a public class with a finalizer
// gets `$hasInited` in that package's Canonicalization dump.

// DEPENDENCE: ../pick_defination.py chir_import_pkg.cj
// EXEC: %compiler %cmp_opt %dumpCHIRDebug -Woff all %compile_lib_opt chir_import_pkg.cj -o pkg.%middle
// EXEC: %python pick_defination.py pkg_CHIR/[0-9]*_Canonicalization.chirtxt "class @_CN3pkg6HandleE" | compare %f
// ASSERT: regex class @(?P<cls>_CN3pkg6HandleE)[\s\S]*?\[private\] \[compilerAdd\] \[noReflectInfo\] var \$hasInited: Bool

main(): Int64 {
    0
}
