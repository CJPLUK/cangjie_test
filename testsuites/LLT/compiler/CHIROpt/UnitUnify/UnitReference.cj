// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %enableO2 %dumpCHIRDebug -Woff all %f -o unit-unify.out
// EXEC: %python pick_defination.py unit-unify_CHIR/[0-9]*_Unit_Unify.chirtxt "Func @_CN7default6<main>Hv" | compare %f

main() {
    let a:Unit = ()
    let b = a
    var c = b
    0
}

// ASSERT: scan-1 = Constant(unit)
// ASSERT: regex-begin ^Block #0:
// ASSERT: regex-next ^\s*\[ret\] %\d+: Int64& = Allocate\(Int64\)
// ASSERT: regex-after %(?P<unit>\d+): Unit = Constant\(unit\)
// ASSERT: regex-after %(?P<c>\d+)\[c\]: Unit& = Allocate\(Unit\)
// ASSERT: regex-after Unit = Store\(%(?P=unit), %(?P=c)\)
