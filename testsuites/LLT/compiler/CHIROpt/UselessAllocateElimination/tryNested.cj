// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %enableO2 --fno-chir-function-inlining %dumpCHIRDebug -Woff all %f -o allocate.out
// EXEC: %python pick_defination.py allocate_CHIR/[0-9]*_UselessAllocateElimination.chirtxt "Func @_CN7default4testHv" | compare %f

public class A {
    var field: Int64 = 1
}

public func test() {
    try {
        try {
            var a = A()
            a.field = 3
        } catch (e: Exception) {
            println("caught")
        }
    } finally {
        println("finally")
    }
}

main() {
    test()
    0
}

// ASSERT: regex-1 = TryAllocate\(Class-_CN7default1AE\)
// ASSERT: regex-3 = (?:Try)?Apply\(@_CNat7printlnHRNat6StringE,
// ASSERT: scan-not = Allocate(Class-_CN7default1AE&)
// ASSERT: regex-begin %(?P<object>\d+): Class-_CN7default1AE& = TryAllocate\(Class-_CN7default1AE\)
// ASSERT: regex-after Void = TryApply\(Class-_CN7default1AE&->@_CN7default1A6<init>Hv, %(?P=object), normal: #\d+, exception: #\d+\)
// ASSERT: regex-after %(?P<three>\d+): Int64 = Constant\(3i\)
// ASSERT: regex-after Unit = StoreElementRef\(%(?P=three), %(?P=object), 0\)
