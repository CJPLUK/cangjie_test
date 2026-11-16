// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %enableO2 --fno-chir-function-inlining %dumpCHIRDebug -Woff all %f -o allocate.out
// EXEC: %python pick_defination.py allocate_CHIR/[0-9]*_UselessAllocateElimination.chirtxt "Func @_CN7default4testHv" | compare %f
// EXEC: %python pick_defination.py allocate_CHIR/[0-9]*_UselessAllocateElimination.chirtxt "Func @_CN7default1A6<init>Hv" | compare %f --assert_flag=ASSERT_CONSTRUCTOR

var counter = 0

public class A {
    init() { counter++ }
}

public func test() {
    try {
        let a = A()
    } catch (e: Exception) {
        println("caught")
    }
}

main() {
    test()
    0
}

// ASSERT: regex-1 = TryAllocate\(Class-_CN7default1AE\)
// ASSERT: regex-1 = TryApply\(Class-_CN7default1AE&->@_CN7default1A6<init>Hv,
// ASSERT: regex-begin %(?P<object>\d+): Class-_CN7default1AE& = TryAllocate\(Class-_CN7default1AE\)
// ASSERT: regex-after Void = TryApply\(Class-_CN7default1AE&->@_CN7default1A6<init>Hv, %(?P=object), normal: #\d+, exception: #\d+\)

// ASSERT_CONSTRUCTOR: regex-begin %(?P<old>\d+): Int64 = Load\(@_CN7default7counterE\)
// ASSERT_CONSTRUCTOR: regex-after %(?P<one>\d+): Int64 = Constant\(1i\)
// ASSERT_CONSTRUCTOR: regex-after %(?P<next>\d+): Int64 = Add\(%(?P=old), %(?P=one)\)
// ASSERT_CONSTRUCTOR: regex-after Unit = Store\(%(?P=next), @_CN7default7counterE\)
