// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %enableO2 %dumpCHIRDebug -Woff all %f -o unit-unify.out
// EXEC: %python pick_defination.py unit-unify_CHIR/[0-9]*_Unit_Unify.chirtxt "Func @_CN7default6<main>Hv" | compare %f

func f(): Unit {
    0
}

func g(a: Unit) {
    0
}

main() {
    var lambda1 = { => f()}
    let a = lambda1()
    g(a)
    0
}

// ASSERT: scan-2 = Constant(unit)
// ASSERT: regex-1 = Apply\(@_CN7default1fHv\)
// ASSERT: regex-1 = Apply\(@_CN7default1gHu,
// ASSERT: regex-begin ^Block #0:
// ASSERT: regex-next ^\s*%(?P<outerUnit>\d+): Unit = Constant\(unit\)
// ASSERT: regex-after %(?P<closure>\d+): \(\) -> Unit = Lambda\[
// ASSERT: regex-after ^\s+Block #\d+:
// ASSERT: regex-next ^\s*\[ret\] %(?P<lambdaRet>\d+): Unit& = Allocate\(Unit\)
// ASSERT: regex-after %\d+: Unit = Apply\(@_CN7default1fHv\)
// ASSERT: regex-after %(?P<innerUnit>\d+): Unit = Constant\(unit\)
// ASSERT: regex-after Unit = Store\(%(?P=innerUnit), %(?P=lambdaRet)\)
// ASSERT: regex-after Unit = Store\(%(?P=closure), %(?P<slot>\d+)\)
// ASSERT: regex-after %(?P<callee>\d+): \(\) -> Unit = Load\(%(?P=slot)\)
// ASSERT: regex-after %\d+: Unit = Apply\(%(?P=callee)\)
// ASSERT: regex-after Int64 = Apply\(@_CN7default1gHu, %(?P=outerUnit)\)
