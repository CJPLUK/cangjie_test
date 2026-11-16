// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Defining package: CreateVTable is before MarkClassHasInited, so `$hasInited`
// must not exist yet on the package class.

// DEPENDENCE: ../pick_defination.py chir_import_pkg.cj
// EXEC: %compiler %cmp_opt %dumpCHIRDebug -Woff all %compile_lib_opt chir_import_pkg.cj -o pkg.%middle
// EXEC: %python pick_defination.py pkg_CHIR/[0-9]*_CreateVTable.chirtxt "class @_CN3pkg6HandleE" | compare %f
// ASSERT: regex class @(?P<cls>_CN3pkg6HandleE)
// ASSERT: scan-not $hasInited

main(): Int64 {
    0
}
