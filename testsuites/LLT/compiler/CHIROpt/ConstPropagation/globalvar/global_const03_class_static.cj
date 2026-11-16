// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Static member of a class: `static let` folds to Constant, `static var`
// keeps its Load. Reflection is disabled so the statics are not kept alive
// by reflection metadata.

// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %cmp_opt %enableConstPropagation %dumpCHIRDebug --disable-reflection -Woff unused %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_ConstantPropagation.chirtxt "Func @_CN7default6<main>Hv" | compare %f
// RUN-EXEC-PIPE-0: %run main
// ASSERT: scan Constant(100i)
// ASSERT: scan Load(@_CN7default1C1yE)
// ASSERT: scan-not Load(@_CN7default1C6x99abcE)

class C {
    public static let x99abc: Int64 = 100
    public static var y: Int64 = 100
}

main() {
    C.x99abc - C.y
}
