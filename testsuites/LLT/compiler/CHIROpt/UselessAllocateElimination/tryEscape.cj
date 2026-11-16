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

var escaped: ?A = None

public func test() {
    try {
        let a = A()
        escaped = Some(a)
    } catch (e: Exception) {
        println("caught")
    }
}

main() {
    test()
    0
}

// ASSERT: regex-1 = TryAllocate\(Class-_CN7default1AE\)
// ASSERT: regex-begin %(?P<object>\d+): Class-_CN7default1AE& = TryAllocate\(Class-_CN7default1AE\)
// ASSERT: regex-after %(?P<tag>\d+): Bool = Constant\(false\)
// ASSERT: regex-after %(?P<option>\d+): Enum-_CNat6OptionIG_E<Class-_CN7default1AE&> = Tuple\(%(?P=tag), %(?P=object)\)
// ASSERT: regex-after Unit = Store\(%(?P=option), @_CN7default7escapedE\)
