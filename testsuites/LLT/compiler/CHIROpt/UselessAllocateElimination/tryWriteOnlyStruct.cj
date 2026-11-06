// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %enableO2 --fno-chir-function-inlining %dumpCHIRDebug -Woff all %f -o allocate.out
// EXEC: %python pick_defination.py allocate_CHIR/[0-9]*_RedundantLoadElimination.chirtxt "Func @_CN7default4testHv" | compare %f --assert_flag=ASSERT_BEFORE
// EXEC: %python pick_defination.py allocate_CHIR/[0-9]*_UselessAllocateElimination.chirtxt "Func @_CN7default4testHv" | compare %f

public struct A {
    var first: Int64 = 1
    var second: Int64 = 2
}

public func test() {
    try {
        // Only the local copy is unused; the constructor temporary is still read.
        var unused = A()
        unused.first = 3
        unused.second = 4
    } catch (e: Exception) {
        println("caught")
    }
}

main() {
    test()
    0
}

// ASSERT_BEFORE: regex-1 = Allocate\(Struct-_CN7default1AE\)
// ASSERT_BEFORE: regex-2 = StoreElementRef\(
// ASSERT_BEFORE: regex-begin %(?P<unused>\d+)\[unused\]: Struct-_CN7default1AE& = Allocate\(Struct-_CN7default1AE\)
// ASSERT_BEFORE: regex-after %(?P<temporary>\d+): Struct-_CN7default1AE& = TryAllocate\(Struct-_CN7default1AE\)
// ASSERT_BEFORE: regex-after %(?P<value>\d+): Struct-_CN7default1AE = Load\(%(?P=temporary)\)
// ASSERT_BEFORE: regex-after Unit = Store\(%(?P=value), %(?P=unused)\)
// ASSERT_BEFORE: regex-after %(?P<three>\d+): Int64 = Constant\(3i\)
// ASSERT_BEFORE: regex-after Unit = StoreElementRef\(%(?P=three), %(?P=unused), 0\)
// ASSERT_BEFORE: regex-after %(?P<four>\d+): Int64 = Constant\(4i\)
// ASSERT_BEFORE: regex-after Unit = StoreElementRef\(%(?P=four), %(?P=unused), 1\)

// ASSERT: scan-not = Allocate(Struct-_CN7default1AE)
// ASSERT: scan-not = StoreElementRef(
// ASSERT: regex-1 = TryAllocate\(Struct-_CN7default1AE\)
// ASSERT: regex-1 = Store\(
// ASSERT: regex-begin \[ret\] %(?P<ret>\d+): Unit& = Allocate\(Unit\)
// ASSERT: regex-after %(?P<temporary>\d+): Struct-_CN7default1AE& = TryAllocate\(Struct-_CN7default1AE\)
// ASSERT: regex-after Void = TryApply\(Struct-_CN7default1AE&->@_CN7default1A6<init>Hv, %(?P=temporary), normal: #\d+, exception: #\d+\)
// ASSERT: regex-after Struct-_CN7default1AE = Load\(%(?P=temporary)\)
// ASSERT: regex-after %(?P<unit>\d+): Unit = Constant\(unit\)
// ASSERT: regex-after Unit = Store\(%(?P=unit), %(?P=ret)\)
