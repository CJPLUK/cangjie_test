// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../pick_defination.py
// EXEC: %frontendCompiler %enableO2 --fno-chir-function-inlining %dumpCHIRDebug -Woff all %f -o allocate.out
// EXEC: %python pick_defination.py allocate_CHIR/[0-9]*_UselessAllocateElimination.chirtxt "Func @_CN7default4test" | compare %f

public class A {
    var field: Int64 = 1
}

public func test(consumer: (A) -> Int64): Int64 {
    try {
        let a = A()
        return consumer(a)
    } catch (e: Exception) {
        return -1
    }
}

func read(a: A): Int64 { a.field }

main() {
    test(read)
    0
}

// ASSERT: regex-1 = TryAllocate\(Class-_CN7default1AE\)
// ASSERT: regex-begin %(?P<consumer>\d+)\[consumer\]:
// ASSERT: regex-after \[ret\] %(?P<ret>\d+): Int64& = Allocate\(Int64\)
// ASSERT: regex-after %(?P<object>\d+): Class-_CN7default1AE& = TryAllocate\(Class-_CN7default1AE\)
// ASSERT: regex-after %(?P<result>\d+): Int64 = TryApply\(%(?P=consumer), %(?P=object), normal: #\d+, exception: #\d+\)
// ASSERT: regex-after Unit = Store\(%(?P=result), %(?P=ret)\)
