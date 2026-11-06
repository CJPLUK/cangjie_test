// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %enableO2 --fno-chir-function-inlining %dumpCHIRDebug -Woff all %f -o allocate.out
// EXEC: %python pick_defination.py allocate_CHIR/[0-9]*_RedundantLoadElimination.chirtxt "Func @_CN7default4test" | compare %f --assert_flag=ASSERT_BEFORE
// EXEC: %python pick_defination.py allocate_CHIR/[0-9]*_UselessAllocateElimination.chirtxt "Func @_CN7default4test" | compare %f

public func test(producer: () -> Int64) {
    try {
        // Keep both calls even when their results are only stored to an unused variable.
        var unused = producer()
        unused = producer()
    } catch (e: Exception) {
        println("caught")
    }
}

main() {
    test({ => 42 })
    0
}

// ASSERT_BEFORE: regex-1 = Allocate\(Int64\)
// ASSERT_BEFORE: regex-3 = Store\(
// ASSERT_BEFORE: regex-begin %(?P<producer>\d+)\[producer\]:
// ASSERT_BEFORE: regex-after %(?P<unused>\d+)\[unused\]: Int64& = Allocate\(Int64\)
// ASSERT_BEFORE: regex-after %(?P<first>\d+): Int64 = TryApply\(%(?P=producer), normal: #\d+, exception: #\d+\)
// ASSERT_BEFORE: regex-after Unit = Store\(%(?P=first), %(?P=unused)\)
// ASSERT_BEFORE: regex-after %(?P<second>\d+): Int64 = TryApply\(%(?P=producer), normal: #\d+, exception: #\d+\)
// ASSERT_BEFORE: regex-after Unit = Store\(%(?P=second), %(?P=unused)\)

// ASSERT: scan-not = Allocate(Int64)
// ASSERT: regex-2 = TryApply\(
// ASSERT: regex-1 = Store\(
// ASSERT: regex-begin %(?P<producer>\d+)\[producer\]:
// ASSERT: regex-after \[ret\] %(?P<ret>\d+): Unit& = Allocate\(Unit\)
// ASSERT: regex-after Int64 = TryApply\(%(?P=producer), normal: #\d+, exception: #\d+\)
// ASSERT: regex-after Int64 = TryApply\(%(?P=producer), normal: #\d+, exception: #\d+\)
// ASSERT: regex-after %(?P<unit>\d+): Unit = Constant\(unit\)
// ASSERT: regex-after Unit = Store\(%(?P=unit), %(?P=ret)\)
