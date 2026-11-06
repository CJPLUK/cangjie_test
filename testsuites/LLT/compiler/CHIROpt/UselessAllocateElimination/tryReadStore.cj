// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %enableO2 --fno-chir-function-inlining %dumpCHIRDebug -Woff all %f -o allocate.out
// EXEC: %python pick_defination.py allocate_CHIR/[0-9]*_RedundantLoadElimination.chirtxt "Func @_CN7default4test" | compare %f --assert_flag=ASSERT_BEFORE
// EXEC: %python pick_defination.py allocate_CHIR/[0-9]*_UselessAllocateElimination.chirtxt "Func @_CN7default4test" | compare %f

public func test(producer: () -> Int64): Int64 {
    // Either call can throw, so the catch must read the last stored value.
    var value = 7
    try {
        value = producer()
        value = producer()
        return value
    } catch (e: Exception) {
        return value
    }
}

main() {
    test({ => 42 })
    0
}

// ASSERT_BEFORE: regex-3 = Allocate\(Int64\)
// ASSERT_BEFORE: regex-5 = Store\(
// ASSERT_BEFORE: regex-1 = Load\(

// ASSERT: regex-2 = Allocate\(Int64\)
// ASSERT: regex-5 = Store\(
// ASSERT: regex-1 = Load\(
// ASSERT: regex-begin %(?P<producer>\d+)\[producer\]:
// ASSERT: regex-after \[ret\] %(?P<ret>\d+): Int64& = Allocate\(Int64\)
// ASSERT: regex-after %(?P<value>\d+)\[value\]: Int64& = Allocate\(Int64\)
// ASSERT: regex-after %(?P<initial>\d+): Int64 = Constant\(7i\)
// ASSERT: regex-after Unit = Store\(%(?P=initial), %(?P=value)\)
// ASSERT: regex-after %(?P<first>\d+): Int64 = TryApply\(%(?P=producer), normal: #\d+, exception: #\d+\)
// ASSERT: regex-after Unit = Store\(%(?P=first), %(?P=value)\)
// ASSERT: regex-after %(?P<second>\d+): Int64 = TryApply\(%(?P=producer), normal: #\d+, exception: #\d+\)
// ASSERT: regex-after Unit = Store\(%(?P=second), %(?P=value)\)
// ASSERT: regex-after Unit = Store\(%(?P=second), %(?P=ret)\)
// ASSERT: regex-after %(?P<caught>\d+): Int64 = Load\(%(?P=value)\)
// ASSERT: regex-after Unit = Store\(%(?P=caught), %(?P=ret)\)
