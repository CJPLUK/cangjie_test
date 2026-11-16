// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Same const-vs-let comparison as pkgGlobalConstVars01, but the dependency
// package is built with no optimisation at all. The importing side must reach
// the same result either way: whether or not the producer was optimised,
// imported `const` still folds and imported `let` / `var` still do not.

// DEPENDENCE: ../../../pick_defination.py pkg/pkg.cj
// EXEC: %compiler %cmp_opt pkg.cj %compile_lib_opt -o pkg.%middle
// EXEC: %compiler %cmp_opt %enableConstPropagation %dumpCHIRDebug -Woff unused pkg.%middle %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_ConstantPropagation.chirtxt "Func @_CN7default6<main>Hv" | compare %f
// RUN-EXEC-PIPE-0: %run main
// const is folded even though the producer was not optimised.
// ASSERT: scan Constant(100i)
// ASSERT: scan Constant('115')
// ASSERT: scan-not Load(@_CN3pkg4cx99E)
// ASSERT: scan-not Load(@_CN3pkg4cm99E)
// ASSERT: scan-not Load(@_CN3pkg4cr99E)
// let/var are not folded across the boundary: their Loads remain.
// ASSERT: scan Load(@_CN3pkg3x99E)
// ASSERT: scan Load(@_CN3pkg1yE)

internal import pkg.*

main() {
    let res0 = (cx99 - y) == 0
    let res1 = (cm99 == false)
    let res2 = (cr99 == r's')
    let res3 = (x99 - y) == 0

    if (res0 && res1 && res2 && res3) {
        return 0
    } else {
        return 1
    }
}
