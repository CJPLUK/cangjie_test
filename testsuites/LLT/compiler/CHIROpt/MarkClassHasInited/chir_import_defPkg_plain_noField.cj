// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Defining package: class without a finalizer is skipped; no `$hasInited`.

// DEPENDENCE: ../pick_defination.py chir_import_pkg.cj
// EXEC: %compiler %cmp_opt %dumpCHIRDebug -Woff all %compile_lib_opt chir_import_pkg.cj -o pkg.%middle
// EXEC: %python pick_defination.py pkg_CHIR/[0-9]*_Canonicalization.chirtxt "class @_CN3pkg5PlainE" | compare %f
// ASSERT: regex class @(?P<cls>_CN3pkg5PlainE)
// ASSERT: scan-not $hasInited

main(): Int64 {
    0
}
