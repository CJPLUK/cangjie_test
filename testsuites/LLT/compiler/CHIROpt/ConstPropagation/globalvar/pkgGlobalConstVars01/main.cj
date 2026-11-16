// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Across a package boundary only `const` carries its value into the importing
// package, so only `const` can be folded:
//   - imported `const` (Int64 / Bool / Rune) -> folded, no Load remains
//   - imported `let`                         -> not folded, Load remains
//   - imported `var`                         -> not folded, Load remains
// Both kinds are read in the same function so the two outcomes are compared
// directly. Dependency package is built at -O2 here.

// DEPENDENCE: ../../../pick_defination.py pkg/pkg.cj
// EXEC: %compiler %cmp_opt %enableO2 --disable-reflection pkg.cj %compile_lib_opt -o pkg.%middle
// EXEC: %compiler %cmp_opt %enableConstPropagation %dumpCHIRDebug --disable-reflection -Woff unused pkg.%middle %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_ConstantPropagation.chirtxt "Func @_CN7default6<main>Hv" | compare %f
// RUN-EXEC-PIPE-0: %run main
// const is folded: values appear inline and no Load of them survives.
// ASSERT: scan Constant(100i)
// ASSERT: scan Constant('115')
// ASSERT: scan-not Load(@_CN3pkg7cx99abcE)
// ASSERT: scan-not Load(@_CN3pkg7cm99abcE)
// ASSERT: scan-not Load(@_CN3pkg7cr99abcE)
// let/var are not folded across the boundary: their Loads remain.
// ASSERT: scan Load(@_CN3pkg6x99abcE)
// ASSERT: scan Load(@_CN3pkg1yE)

internal import pkg.*

main() {
    let res0 = (cx99abc - y) == 0
    let res1 = (cm99abc == false)
    let res2 = (cr99abc == r's')
    let res3 = (x99abc - y) == 0

    if (res0 && res1 && res2 && res3) {
        return 0
    } else {
        return 1
    }
}
