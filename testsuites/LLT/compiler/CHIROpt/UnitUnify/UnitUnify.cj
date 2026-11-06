// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %enableO2 %dumpCHIRDebug -Woff all %f -o unit-unify.out
// EXEC: %python pick_defination.py unit-unify_CHIR/[0-9]*_Unit_Unify.chirtxt "Func @_CN7default4test" | compare %f

func foo() {
    return
}

func test() {
    let arr = Array<Unit>(5, repeat: foo())
    var element = arr[0]
}

main() {
    foo()
    test()
}

// ASSERT: scan-2 = Constant(unit)
// ASSERT: regex-1 = Apply\(@_CN7default3fooHv\)
// ASSERT: regex-1 = Apply\(.*->@_CNat5ArrayIuEixHl,
// ASSERT: regex-begin ^Block #0:
// ASSERT: regex-next ^\s*%(?P<unit>\d+): Unit = Constant\(unit\)
// ASSERT: regex-after %(?P<count>\d+): Int64 = Constant\(5i\)
// ASSERT: regex-after %\d+: Unit = Apply\(@_CN7default3fooHv\)
// ASSERT: regex-after %(?P<array>\d+): Struct-_CNat5ArrayIG_E<Unit>& = Allocate\(Struct-_CNat5ArrayIG_E<Unit>\)
// ASSERT: regex-after Void = Apply\(.*->@_CNat5ArrayIuE6<init>Hlu, %(?P=array), %(?P=count), %(?P=unit)\)
// ASSERT: regex-after %(?P<value>\d+): Struct-_CNat5ArrayIG_E<Unit> = Load\(%(?P=array)\)
// ASSERT: regex-after %(?P<element>\d+)\[element\]: Unit& = Allocate\(Unit\)
// ASSERT: regex-after %(?P<index>\d+): Int64 = Constant\(0i\)
// ASSERT: regex-after %\d+: Unit = Apply\(.*->@_CNat5ArrayIuEixHl, %(?P=value), %(?P=index)\)
// ASSERT: regex-after Unit = Store\(%(?P=unit), %(?P=element)\)
