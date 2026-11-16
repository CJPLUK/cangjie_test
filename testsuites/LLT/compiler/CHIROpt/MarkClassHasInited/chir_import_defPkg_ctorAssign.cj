// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Defining package: constructor stores `$hasInited = false` at entry and
// `$hasInited = true` before Exit. Field index is 1 (`x` is 0).

// DEPENDENCE: ../pick_defination.py chir_import_pkg.cj
// EXEC: %compiler %cmp_opt %dumpCHIRDebug -Woff all %compile_lib_opt chir_import_pkg.cj -o pkg.%middle
// EXEC: %python pick_defination.py pkg_CHIR/[0-9]*_Canonicalization.chirtxt "Func @_CN3pkg6Handle6<init>Hv" | compare %f
// ASSERT: regex %(?P<falseVal>\d+): Bool = Constant\(false\)[\s\S]*?StoreElementRef\(%(?P=falseVal), %0, 1\)
// ASSERT: regex %(?P<trueVal>\d+): Bool = Constant\(true\)[\s\S]*?StoreElementRef\(%(?P=trueVal), %0, 1\)[\s\S]*?Exit\(

main(): Int64 {
    0
}
