// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Package-level immutable global: `let x99abc` is folded into Constant, while
// the mutable `var y` on the same expression keeps its Load.

// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %cmp_opt %enableConstPropagation %dumpCHIRDebug -Woff unused %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_ConstantPropagation.chirtxt "Func @_CN7default6<main>Hv" | compare %f
// RUN-EXEC-PIPE-0: %run main
// ASSERT: scan Constant(100i)
// ASSERT: scan Load(@_CN7default1yE)
// ASSERT: scan-not Load(@_CN7default6x99abcE)

let x99abc: Int64 = 100
var y: Int64 = 100

main() {
    x99abc - y
}
