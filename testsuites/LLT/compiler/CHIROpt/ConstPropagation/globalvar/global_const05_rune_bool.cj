// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Non-integer primitive globals fold too: an immutable `Rune` and `Bool` are
// both replaced by Constant, and because both sides of each comparison are
// known the Equal itself collapses to Constant(true). The mutable
// `var y: Rune` is the control -- it keeps its Load.

// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %cmp_opt %enableConstPropagation %dumpCHIRDebug -Woff unused %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_ConstantPropagation.chirtxt "Func @_CN7default6<main>Hv" | compare %f
// RUN-EXEC-PIPE-0: %run main
// ASSERT: scan Constant('115')
// ASSERT: scan Constant(true)
// ASSERT: scan Load(@_CN7default1yE)
// ASSERT: scan-not Load(@_CN7default6r99abcE)
// ASSERT: scan-not Load(@_CN7default6m99abcE)

let r99abc: Rune = r's'
let m99abc = false
var y: Rune = r's'

main() {
    let a = (r99abc == r's')
    let b = (m99abc == false)
    let c = (y == r's')
    if (a && b && c) {
        return 0
    } else {
        return 1
    }
}
