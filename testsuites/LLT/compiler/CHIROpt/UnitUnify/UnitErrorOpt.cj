// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %enableO2 %dumpCHIRDebug -Woff all %f -o unit-unify.out
// EXEC: %python pick_defination.py unit-unify_CHIR/[0-9]*_Unit_Unify.chirtxt "Func @_CN7default6<main>Hv" | compare %f

class A <: Exception {}

main():Int64 {
    var a = 1
    try {
        throw A();
    } catch (e : A) {
        let a = e.printStackTrace()
        var x = a
    } finally {
        print("finally one.\n")
    }
    print("success.\n")
    return a-1
}

// ASSERT: scan-1 = Constant(unit)
// ASSERT: regex-1 = TryApply\(.*15printStackTraceHv,
// ASSERT: regex-3 = Apply\(@_CNat5printHRNat6StringEb,
// ASSERT: regex-begin ^Block #0:
// ASSERT: regex-next ^\s*%(?P<unit>\d+): Unit = Constant\(unit\)
// ASSERT: regex-after %\d+: Unit = TryApply\(.*15printStackTraceHv, %\d+, normal: #(?P<success>\d+), exception: #\d+\)
// ASSERT: regex-after ^Block #(?P=success):
// ASSERT: regex-after %(?P<x>\d+)\[x\]: Unit& = Allocate\(Unit\)
// ASSERT: regex-after Unit = Store\(%(?P=unit), %(?P=x)\)
