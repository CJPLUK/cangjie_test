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

public func test(): A {
    try {
        return A()
    } catch (e: Exception) {
        throw e
    }
}

main() {
    test()
    0
}

// ASSERT: regex-1 = TryAllocate\(Class-_CN7default1AE\)
// ASSERT: regex-begin \[ret\] %(?P<ret>\d+): Class-_CN7default1AE&& = Allocate\(Class-_CN7default1AE&\)
// ASSERT: regex-after %(?P<object>\d+): Class-_CN7default1AE& = TryAllocate\(Class-_CN7default1AE\)
// ASSERT: regex-after Unit = Store\(%(?P=object), %(?P=ret)\)
